# LaunchLab & CPMM fee reference

This page shows how fees work end-to-end — from bonding curve through migration to the CPMM pool — so you can see exactly where money flows and who gets what.

### Fee lifecycle

A token launched through LaunchLab has two trading phases. Each phase has its own fee structure.

#### Phase 1: Bonding curve

Every trade on the bonding curve is subject to four independent fees.

```
total fee = protocol fee + platform fee + creator fee + referral fee
```

| Fee          | Set by                                                   | Rate example | Recipient               |
| ------------ | -------------------------------------------------------- | ------------ | ----------------------- |
| Protocol fee | Raydium (global config `tradeFeeRate`)                   | 0.25%        | Raydium                 |
| Platform fee | Platform developer (`feeRate` on platform config)        | 1%           | Platform's claim wallet |
| Creator fee  | Platform developer (`creatorFeeRate` on platform config) | 0.5%         | Token creator's vault   |
| Referral fee | Per-transaction (`shareFeeRate`)                         | 0–0.5%       | Referrer wallet         |

These fees are **additive**. If a platform sets 1% platform fee and 0.5% creator fee, and the protocol fee is 0.25%, the total fee on each trade is at least 1.75% (plus any referral fee).

**Claim methods:**

| Who      | SDK method                                                     |
| -------- | -------------------------------------------------------------- |
| Platform | `claimVaultPlatformFee()` or `claimMultipleVaultPlatformFee()` |
| Creator  | `claimCreatorFee()` or `claimMultipleCreatorFee()`             |

Fees accumulate in vaults and must be claimed manually. Referral fees are transferred directly to the referrer on each trade.

#### Migration

When the bonding curve reaches its graduation target:

1. Liquidity migrates into a CPMM pool (0.15 SOL pool creation fee).
2. LP tokens are distributed according to `migrateCpLockNftScale`:
   * `burnScale` → burned permanently (no one claims fees from these)
   * `creatorScale` → locked via Burn & Earn, creator receives a Fee Key NFT
   * `platformScale` → locked via Burn & Earn, platform receives a Fee Key NFT
3. The CPMM pool uses the fee config specified by `cpConfigId` on the platform config.

#### Phase 2: CPMM pool

After migration, every swap generates up to two fees, both deducted from the swap input:

```
trade fee    = swap input × trade_fee_rate (e.g. 0.25%)
creator fee  = swap input × creator_fee_rate (e.g. 0.05%)
```

The trade fee is then split:

| Slice    | Share            | Recipient                                                     |
| -------- | ---------------- | ------------------------------------------------------------- |
| LP share | 84% of trade fee | Pool vaults (benefits all LP holders and Fee Key NFT holders) |
| Protocol | 12% of trade fee | Raydium                                                       |
| Treasury | 4% of trade fee  | Raydium                                                       |

The creator fee goes 100% to the pool creator. It is **not** carved out of the trade fee — it is an additional charge on top of it.

Fee Key NFT holders earn from the LP share. Their claim is proportional to the locked LP tokens their NFT represents.

**Claim methods:**

| Who      | What             | SDK method            |
| -------- | ---------------- | --------------------- |
| Creator  | CPMM creator fee | `collectCreatorFee()` |
| Creator  | LP fee share     | `harvestLockLp()`     |
| Platform | LP fee share     | `harvestLockLp()`     |

***

### How fees stack for a creator

After migration, a creator can earn from **three sources simultaneously**:

| Source                     | Mechanism                                      | Claim                 |
| -------------------------- | ---------------------------------------------- | --------------------- |
| Bonding curve creator fee  | Pre-migration vault                            | `claimCreatorFee()`   |
| CPMM creator fee           | Per-swap from `creator_fee_rate`               | `collectCreatorFee()` |
| LP fee share (Fee Key NFT) | Share of LP trading fees from locked liquidity | `harvestLockLp()`     |

These do not replace each other. A creator who launched with all three enabled must claim from all three separately.

{% hint style="info" %}
**CPMM creator fee can be rerouted.** Platforms can call `updatePlatformCpCreator` to redirect creator fees to a platform-controlled wallet (or PDA), then redistribute however they want — keep a cut as platform revenue, split with creators on custom terms, or fund other programs.
{% endhint %}

#### Worked example

A CPMM pool with `trade_fee_rate: 2500` (0.25%), `creator_fee_rate: 500` (0.05%), and `creatorScale: 100%`.

On a **1,000,000 token** swap:

| Fee                 | Amount           | Recipient                                     |
| ------------------- | ---------------- | --------------------------------------------- |
| Trade fee (0.25%)   | 2,500 tokens     | Split: 2,100 LP / 300 protocol / 100 treasury |
| Creator fee (0.05%) | 500 tokens       | Pool creator                                  |
| **Total fees**      | **3,000 tokens** |                                               |
| Into swap           | 997,000 tokens   | Constant-product calculation                  |

The creator earns **2,600 tokens**: 2,100 from LP fees (via Fee Key NFT) + 500 from the CPMM creator fee.

***

### Configuration reference

#### Global config (LaunchLab — set by Raydium)

| Field             | Controls                                       |
| ----------------- | ---------------------------------------------- |
| `tradeFeeRate`    | Raydium's protocol fee on bonding curve trades |
| `maxShareFeeRate` | Maximum allowed referral fee rate              |

The global config is derived from the quote token and curve type via `getPdaLaunchpadConfigId()`. Developers cannot modify it.

#### Platform config (LaunchLab — set by platform developer)

| Field                   | Controls                                              | Set via                                                   |
| ----------------------- | ----------------------------------------------------- | --------------------------------------------------------- |
| `feeRate`               | Platform's bonding curve trading fee                  | `createPlatformConfig()` or `updateFeeRate`               |
| `creatorFeeRate`        | Creator's bonding curve trading fee                   | `createPlatformConfig()`                                  |
| `migrateCpLockNftScale` | LP split at migration (burn / creator / platform)     | `createPlatformConfig()` or `updateMigrateCpLockNftScale` |
| `cpConfigId`            | Which CPMM AmmConfig migrated pools use               | `createPlatformConfig()` or `updateCpConfigId`            |
| `platformCpCreator`     | Overrides pool creator address on migrated CPMM pools | `updatePlatformCpCreator()`                               |

#### AmmConfig (CPMM — set by Raydium)

| Field               | Controls                                                    |
| ------------------- | ----------------------------------------------------------- |
| `trade_fee_rate`    | Fee taken from swap input (e.g. 2500 = 0.25%)               |
| `protocol_fee_rate` | Protocol's share of trade fee (e.g. 120000 = 12%)           |
| `fund_fee_rate`     | Treasury's share of trade fee (e.g. 40000 = 4%)             |
| `creator_fee_rate`  | Additional per-swap fee for pool creator (e.g. 500 = 0.05%) |
| `create_pool_fee`   | One-time pool creation cost in lamports                     |

All rate fields use a denominator of 1,000,000. Platform developers choose which AmmConfig to use via `cpConfigId` but cannot create custom configs — contact Raydium to request one.

***

### Common misconceptions

1. There are three distinct creator fees — bonding curve creator fee, CPMM creator fee, and LP fee share via Fee Key NFT. See the lifecycle sections above.
2. **The CPMM creator fee is carved out of the trade fee.** No. It is an additional fee on top of the trade fee. Both are deducted from swap input independently.
3. **Fee Key NFT = CPMM creator fee.** No. The Fee Key NFT gives you a claim on LP trading fees from locked liquidity. The CPMM creator fee is a separate per-swap charge collected via `collectCreatorFee()`. They are different revenue streams.
4. **All CPMM pools have creator fees.** No. Creator fees only exist on pools created via the permissioned path (LaunchLab migration). Standard CPMM pools created with `createPool()` have creator fees disabled at the program level.
5. **Burning LP tokens means losing liquidity.** Burned LP tokens leave liquidity in the pool permanently, but no one can claim the fees those tokens generate. Fee Key NFTs from Burn & Earn are different — the liquidity is locked (not burned), and the NFT holder claims the fee appreciation.
