---
description: Create and configure your LaunchLab platform to enable token launches.
---

# Creating a platform

Create and configure your LaunchLab platform to enable token launches.

Before users can launch tokens on your platform, you need to create a platform configuration. Each wallet can only create one platform.

***

## Creating a platform

Use `createPlatformConfig()` to initialize your platform with fee structures, LP distribution settings, and metadata.

```typescript
import {
  TxVersion,
  LAUNCHPAD_PROGRAM,
  DEVNET_PROGRAM_ID,
} from '@raydium-io/raydium-sdk-v2'
import { initSdk } from './config'
import { PublicKey } from '@solana/web3.js'
import BN from 'bn.js'

const createPlatform = async () => {
  const raydium = await initSdk()
  const owner = raydium.ownerPubKey

  const { execute, extInfo } = await raydium.launchpad.createPlatformConfig({
    programId: LAUNCHPAD_PROGRAM, // Use DEVNET_PROGRAM_ID.LAUNCHPAD_PROGRAM for devnet

    // Wallet configuration
    platformAdmin: owner,
    platformClaimFeeWallet: owner,
    platformLockNftWallet: owner,
    platformVestingWallet: owner,

    // CPMM pool fee tier for migrated pools
    cpConfigId: new PublicKey('DNXgeM9EiiaAbaWvwjHj9fQQLAX5ZsfHyvmYUNRAdNC8'),

    // Token-2022 transfer fee authority (receives fee authorities post-migration)
    transferFeeExtensionAuth: owner,

    // Fee configuration
    feeRate: new BN(10000),        // 1% platform fee on bonding curve trades
    creatorFeeRate: new BN(5000),  // 0.5% creator fee on bonding curve trades

    // LP distribution at migration (must sum to 1,000,000)
    migrateCpLockNftScale: {
      platformScale: new BN(100000),  // 10% to platform (locked)
      creatorScale: new BN(100000),   // 10% to creator (locked)
      burnScale: new BN(800000),      // 80% burned
    },

    // Platform metadata
    name: 'My LaunchLab',
    web: 'https://mylaunchlab.io',
    img: 'https://mylaunchlab.io/logo.png',

    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('Platform created:', extInfo.platformId.toBase58())
}
```

***

## Configuration parameters

### Wallet configuration

| Parameter                | Type      | Description                                                                     |
| ------------------------ | --------- | ------------------------------------------------------------------------------- |
| `platformAdmin`          | PublicKey | Admin wallet that controls the platform. Can update settings.                   |
| `platformClaimFeeWallet` | PublicKey | Wallet that receives platform trading fees from bonding curves.                 |
| `platformLockNftWallet`  | PublicKey | Wallet that receives the platform's Fee Key NFT after migration.                |
| `platformVestingWallet`  | PublicKey | Wallet for platform vesting allocations. Use `PublicKey.default` if not needed. |

### Fee configuration

| Parameter        | Type | Description                                                                                      |
| ---------------- | ---- | ------------------------------------------------------------------------------------------------ |
| `feeRate`        | BN   | Platform's share of bonding curve trading fees. In bps × 100 (`10000 = 1%`).                     |
| `creatorFeeRate` | BN   | Creator's share of bonding curve trading fees. In bps × 100 (`5000 = 0.5%`). Max `50000` (`5%`). |

Fees are denominated in quote token (for example, SOL). For each trade, total fee = `protocolFeeRate` + `platformFeeRate` + `creatorFeeRate` + `shareFeeRate`. Each party receives their proportional share.

### LP distribution at migration

| Parameter       | Type | Description                                                                           |
| --------------- | ---- | ------------------------------------------------------------------------------------- |
| `platformScale` | BN   | Platform's share of LP tokens, locked via Burn & Earn. Platform receives Fee Key NFT. |
| `creatorScale`  | BN   | Creator's share of LP tokens, locked via Burn & Earn. Creator receives Fee Key NFT.   |
| `burnScale`     | BN   | LP tokens burned permanently. No fees generated.                                      |

These three values must sum to `1,000,000` (100%).

### Example distributions

```typescript
// 80% burned, 10% creator, 10% platform
{ burnScale: 800000, creatorScale: 100000, platformScale: 100000 }

// 90% burned, 10% creator (no platform share)
{ burnScale: 900000, creatorScale: 100000, platformScale: 0 }

// 100% burned (no ongoing fees)
{ burnScale: 1000000, creatorScale: 0, platformScale: 0 }
```

### Pool configuration

| Parameter                  | Type      | Description                                                                     |
| -------------------------- | --------- | ------------------------------------------------------------------------------- |
| `cpConfigId`               | PublicKey | Fee tier for the CPMM pool after migration. Get available configs from the API. |
| `transferFeeExtensionAuth` | PublicKey | Receives transfer fee authorities for Token-2022 launches after migration.      |

### Available CPMM configs

* Mainnet: [api-v3.raydium.io/main/cpmm-config](https://api-v3.raydium.io/main/cpmm-config)
* Devnet: [api-v3-devnet.raydium.io/main/cpmm-config](https://api-v3-devnet.raydium.io/main/cpmm-config)

### Metadata

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| `name`    | string | Platform name (stored on-chain). |
| `web`     | string | Platform website URL.            |
| `img`     | string | Platform logo URL.               |

***

## Updating platform configuration

Platform settings can be updated once per epoch. Use `updatePlatformConfig()` to modify settings.

```typescript
const updatePlatform = async () => {
  const raydium = await initSdk()

  const { execute } = await raydium.launchpad.updatePlatformConfig({
    platformAdmin: raydium.ownerPubKey,

    // Update a single setting
    updateInfo: { type: 'updateFeeRate', value: new BN(15000) }, // Change to 1.5%

    txVersion: TxVersion.V0,
  })

  await execute({ sendAndConfirm: true })
}
```

### Available update types

| Type                         | Value     | Description                                        |
| ---------------------------- | --------- | -------------------------------------------------- |
| `updateFeeRate`              | BN        | Update platform trading fee rate                   |
| `updateClaimFeeWallet`       | PublicKey | Change fee collection wallet                       |
| `updateLockNftWallet`        | PublicKey | Change Fee Key NFT recipient                       |
| `updateVestingWallet`        | PublicKey | Change vesting wallet                              |
| `updateCpConfigId`           | PublicKey | Change CPMM fee tier for migrations                |
| `updateName`                 | string    | Update platform name                               |
| `updateWeb`                  | string    | Update website URL                                 |
| `updateImg`                  | string    | Update logo URL                                    |
| `migrateCpLockNftScale`      | object    | Update LP distribution ratios                      |
| `updatePlatformVestingScale` | BN        | Update platform vesting allocation                 |
| `updatePlatformCpCreator`    | PublicKey | pass a publicKey as fee receipient post graduation |
| `updateAll`                  | object    | Update all settings at once                        |

***

### Enforcing launch parameters (optional)

Platforms can restrict which token configurations are allowed. If a creator's parameters don't match an allowed configuration, the transaction fails.

```typescript
import { updatePlatformCurveParamInstruction } from '@raydium-io/raydium-sdk-v2'

// Add an allowed configuration at index 1
const instruction = updatePlatformCurveParamInstruction(
  LAUNCHPAD_PROGRAM,
  platformAdmin,
  platformId,
  1, // index (0-254)
  {
    migrateType: 1,                              // 0 = AMM, 1 = CPMM
    migrateCpmmFeeOn: 0,                         // Creator fee token
    supply: new BN('1000000000000000'),          // 1B tokens (with decimals)
    totalSellA: new BN('793100000000000'),       // ~79.3% sold on curve
    totalFundRaisingB: new BN('85000000000'),    // 85 SOL to raise
    totalLockedAmount: new BN('0'),              // No vesting
    cliffPeriod: new BN('0'),
    unlockPeriod: new BN('0'),
  }
)
```

### How parameter enforcement works

* Store up to 25 configurations (index 0-254)
* Set a parameter to `null` to skip validation for that field
* Creators must match at least one configuration exactly
* Configurations can be updated once per epoch

**Example:** Allow flexible raise amounts but fixed supply:

```typescript
{
  supply: new BN('1000000000000000'),     // Must be exactly 1B
  totalFundRaisingB: null,                // Any amount allowed
  // ... other params
}
```

***

### Deriving your platform ID

After creation, your platform ID is derived from your admin wallet:

```typescript
import { getPdaPlatformId, LAUNCHPAD_PROGRAM } from '@raydium-io/raydium-sdk-v2'

const { publicKey: platformId } = getPdaPlatformId(
  LAUNCHPAD_PROGRAM,
  adminWallet
)
```

Share this `platformId` with token creators who want to launch on your platform.
