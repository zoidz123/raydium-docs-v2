---
description: >-
  This guide explains how CPMM fee configs work and how to fetch existing
  configs from on-chain.
---

# How to set CPMM fees

Each CPMM pool is assigned a fee configuration at creation. Fee configurations are stored on-chain as `AmmConfig` accounts — each one defines a fee tier that any pool can use.

### Fee configurations

Every pool references a single `AmmConfig` that determines how fees are collected and distributed on each swap. To view all available configurations, use the script below to query the on-chain accounts. You can also view public config IDs at this endpoint ([https://api-v3.raydium.io/main/cpmm-config](https://api-v3.raydium.io/main/cpmm-config)) – note this endpoint excludes certain custom config IDs.

{% hint style="info" %}
To request a custom fee configuration, contact the Raydium team.
{% endhint %}

### Example output

```
--- Config index: 0 ---
  Address:           D4FPEruKEHrG5TenZ2mpDGEfu1iUvTiqBxvpU8HLBvC2
  Trade Fee Rate:    2500 (0.25%)
  Protocol Fee Rate: 120000 (12% of trade fee)
  Fund Fee Rate:     40000 (4% of trade fee)
  Creator Fee Rate:  500 (0.05%)
  Create Pool Fee:   150000000 lamports (0.15 SOL)
```

### How fees are distributed

Using Config 0 as an example, here's how fees flow on a **1,000,000 token** swap.

#### 1. Fees are deducted from the input

The `trade_fee_rate` and `creator_fee_rate` are each applied to the swap input amount:

```
trade_fee   = 1,000,000 × 0.25%  = 2,500 tokens
creator_fee = 1,000,000 × 0.05%  =   500 tokens
                                    ─────
total deducted                    = 3,000 tokens
```

The remaining **997,000 tokens** enter the constant-product swap to determine the output.

#### 2. The trade fee is split between protocol, treasury, and LPs

`protocol_fee_rate` and `fund_fee_rate` are percentages of the **trade fee**, not the swap amount:

```
protocol_fee = 2,500 × 12% = 300 tokens
fund_fee     = 2,500 ×  4% = 100 tokens
lp_fee       = 2,500 - 300 - 100 = 2,100 tokens
```

The LP fee remains in the pool vaults, increasing the value of LP positions.

#### 3. Summary

| Recipient        | Amount           | Calculation                  |
| ---------------- | ---------------- | ---------------------------- |
| LPs              | 2,100 tokens     | trade\_fee - protocol - fund |
| Raydium protocol | 300 tokens       | 12% of trade fee             |
| Raydium treasury | 100 tokens       | 4% of trade fee              |
| Pool creator     | 500 tokens       | 0.05% of swap input          |
| **Total fees**   | **3,000 tokens** | **0.30% of swap input**      |

Protocol and treasury fees accumulate in the pool vaults and are collected separately by the `protocol_owner` and `fund_owner` addresses.

### AmmConfig fields

| Field                 | Description                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------ |
| `trade_fee_rate`      | Fee taken from the swap input, in units of 1e-6. `2500` = 0.25%.                           |
| `protocol_fee_rate`   | Share of the trade fee sent to Raydium protocol, in units of 1e-6. `120000` = 12%.         |
| `fund_fee_rate`       | Share of the trade fee sent to Raydium treasury, in units of 1e-6. `40000` = 4%.           |
| `creator_fee_rate`    | Additional fee taken from the swap input, sent to the pool creator. `500` = 0.05%.         |
| `create_pool_fee`     | One-time fee in lamports to create a pool with this config. `150000000` = 0.15 SOL.        |
| `disable_create_pool` | When `true`, new pool creation is disabled for this config. Existing pools are unaffected. |
| `protocol_owner`      | Address that collects accumulated protocol fees.                                           |
| `fund_owner`          | Address that collects accumulated treasury fees.                                           |

All rate fields use a denominator of `1,000,000`. For example, a value of `2500` means 2500/1000000 = 0.25%.

### Fetch all configurations

The following script queries all `AmmConfig` accounts from mainnet:

```typescript
import { Connection, PublicKey } from "@solana/web3.js";
import { createHash } from "crypto";

const RPC_URL = "<YOUR_RPC_URL>";
const PROGRAM_ID = new PublicKey("CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C");

// Anchor discriminator: first 8 bytes of sha256("account:AmmConfig")
const discriminator = createHash("sha256")
  .update("account:AmmConfig")
  .digest()
  .subarray(0, 8);

interface AmmConfig {
  bump: number;
  disableCreatePool: boolean;
  index: number;
  tradeFeeRate: bigint;
  protocolFeeRate: bigint;
  fundFeeRate: bigint;
  createPoolFee: bigint;
  protocolOwner: PublicKey;
  fundOwner: PublicKey;
  creatorFeeRate: bigint;
}

function parseAmmConfig(data: Buffer): AmmConfig {
  let offset = 8; // skip Anchor discriminator

  const bump = data.readUInt8(offset);             offset += 1;
  const disableCreatePool = data.readUInt8(offset) !== 0; offset += 1;
  const index = data.readUInt16LE(offset);         offset += 2;
  const tradeFeeRate = data.readBigUInt64LE(offset);    offset += 8;
  const protocolFeeRate = data.readBigUInt64LE(offset); offset += 8;
  const fundFeeRate = data.readBigUInt64LE(offset);     offset += 8;
  const createPoolFee = data.readBigUInt64LE(offset);   offset += 8;
  const protocolOwner = new PublicKey(data.subarray(offset, offset + 32)); offset += 32;
  const fundOwner = new PublicKey(data.subarray(offset, offset + 32));     offset += 32;
  const creatorFeeRate = data.readBigUInt64LE(offset);

  return {
    bump, disableCreatePool, index, tradeFeeRate,
    protocolFeeRate, fundFeeRate, createPoolFee,
    protocolOwner, fundOwner, creatorFeeRate,
  };
}

async function main() {
  const connection = new Connection(RPC_URL, "confirmed");
  console.log("Fetching all AmmConfig accounts...\n");

  const accounts = await connection.getProgramAccounts(PROGRAM_ID, {
    filters: [{
      memcmp: {
        offset: 0,
        bytes: discriminator.toString("base64"),
        encoding: "base64",
      },
    }],
  });

  console.log(`Found ${accounts.length} AmmConfig account(s)\n`);

  for (const { pubkey, account } of accounts) {
    const config = parseAmmConfig(account.data as Buffer);
    console.log(`--- Config index: ${config.index} ---`);
    console.log(`  Address:           ${pubkey.toBase58()}`);
    console.log(`  Trade Fee Rate:    ${config.tradeFeeRate} (${Number(config.tradeFeeRate) / 10000}%)`);
    console.log(`  Protocol Fee Rate: ${config.protocolFeeRate} (${Number(config.protocolFeeRate) / 10000}% of trade fee)`);
    console.log(`  Fund Fee Rate:     ${config.fundFeeRate} (${Number(config.fundFeeRate) / 10000}% of trade fee)`);
    console.log(`  Creator Fee Rate:  ${config.creatorFeeRate} (${Number(config.creatorFeeRate) / 10000}%)`);
    console.log(`  Create Pool Fee:   ${config.createPoolFee} lamports (${Number(config.createPoolFee) / 1e9} SOL)`);
    console.log(`  Disable Pool:      ${config.disableCreatePool}`);
    console.log(`  Protocol Owner:    ${config.protocolOwner.toBase58()}`);
    console.log(`  Fund Owner:        ${config.fundOwner.toBase58()}`);
    console.log();
  }
}

main().catch(console.error);
```
