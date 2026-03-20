# How to configure CPMM creator fees

Creator fees allow LaunchLab platforms to reward token creators with a share of swap volume on their CPMM pool. A percentage of each swap is set aside for the creator, separate from the trade fee earned by LPs.

Creator fees are available on pools created through LaunchLab migration.

### How creator fees work

The `creator_fee_rate` is defined on the `AmmConfig` and applies to every swap in pools where creator fees are enabled. It is an additional fee on top of the trade fee — not carved out of it.

On a swap with `trade_fee_rate: 2500` (0.25%) and `creator_fee_rate: 500` (0.05%):

```
trade_fee   = input × 0.25%   → split between LPs, protocol, fund
creator_fee = input × 0.05%   → accumulated for the pool creator
                                 ─────
total fee                      = 0.30% of swap input
```

Creator fees accumulate in the pool vaults as `creator_fees_token_0` and `creator_fees_token_1` on the pool state. The creator collects them by calling `collect_creator_fee`, which requires signing as the `pool_creator` address.

### Quote-only mode

By default, LaunchLab sets `creatorFeeOn` to `OnlyTokenB` (the quote token, typically SOL). This means the creator fee is always denominated in the quote token regardless of swap direction.

The three modes:

| Mode         | Behavior                                                                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `BothToken`  | Creator fee is taken from the input token. Fees accumulate in both tokens.                                                                       |
| `OnlyToken0` | Creator fee is always in token 0. When token 0 is the input, fee is deducted from input. When token 1 is the input, fee is deducted from output. |
| `OnlyToken1` | Creator fee is always in token 1 (default for LaunchLab). Same logic as above, reversed.                                                         |

In `OnlyToken1` mode (the default), if a user swaps SOL → Token:

* Creator fee is deducted from the SOL input (the quote token)

If a user swaps Token → SOL:

* Creator fee is deducted from the SOL output (still the quote token)

This ensures the creator always receives fees in a single, liquid token.

Set this when creating a token via `createLaunchpad`:

```typescript
creatorFeeOn: CpmmCreatorFeeOn.OnlyTokenB // default
```

### Collecting creator fees

The `pool_creator` address can collect accumulated fees at any time. The SDK provides `collectMultiCreatorFees` to batch-collect across all pools:

```typescript
const { execute, transactions } = await raydium.cpmm.collectMultiCreatorFees({
  poolInfoList: poolInfos,
  programId: CREATE_CPMM_POOL_PROGRAM,
  txVersion: TxVersion.V0,
})
```

Full example: [collectAllCreatorFee.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/cpmm/collectAllCreatorFee.ts)

The script queries the API for all pools where your wallet is `pool_creator`, filters for pools with pending fees, and collects them in batched transactions.

### Setting the creator fee rate

The `creator_fee_rate` is part of the `AmmConfig`, not a per-pool setting. The platform's `cpConfigId` determines which config (and therefore which creator fee rate) applies to migrated pools.

To view available configs and their creator fee rates, see How to Set CPMM Fees.

### Who is the pool creator?

The `pool_creator` address is set at pool creation during LaunchLab migration. For LaunchLab pools, this is typically the token creator — the wallet that called `createLaunchpad`. The platform can configure this via `updatePlatformCpCreator` on the platform config.

Full example: [updatePlatform.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/launchpad/updatePlatform.ts)
