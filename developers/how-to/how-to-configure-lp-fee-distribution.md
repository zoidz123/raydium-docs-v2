# How to configure LP fee distribution

After a LaunchLab token graduates its bonding curve, liquidity can migrate into a CPMM pool. CPMM migration must be enabled on the platform config.

At migration, the CPMM pool returns LP tokens. The platform config controls how those LP tokens are distributed.

### LP tokens

LP tokens represent a proportional claim on the liquidity held in a CPMM pool. When liquidity is deposited into a pool, LP tokens are minted. When LP tokens are redeemed, the holder receives their share of both tokens in the pool — including any fees that have accumulated since deposit.

Because swap fees accrue directly to the pool vaults, LP token value increases over time relative to the underlying assets. Holding LP tokens is effectively earning a share of every swap.

In the context of LaunchLab migration, Burn & Earn allows LP tokens to be permanently locked while still generating fee revenue. The LP tokens cannot be redeemed, making the liquidity permanent, but a Fee Key NFT is issued to the holder to claim the fees those positions generate.

### LP distribution

`migrateCpLockNftScale` defines the LP split. The three fields must sum to `1,000,000` (100%):

| Field           | Description                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| `platformScale` | Locked via Burn & Earn. Platform receives a Fee Key NFT to claim fees.      |
| `creatorScale`  | Locked via Burn & Earn. Token creator receives a Fee Key NFT to claim fees. |
| `burnScale`     | Burned permanently. No fees generated.                                      |

This is a platform-level setting. All tokens launched through a platform share the same distribution.

Swap fees (after protocol and fund fees) remain in the pool vaults. Fee Key NFT holders claim their share of accrued fees from locked positions.

When LP tokens are burned via `burnScale`, the underlying liquidity stays in the pool permanently — but no one holds a claim to it. Swap fees continue to accumulate against those positions, growing the total value locked.

### Examples

```typescript
// 40% platform, 50% creator, 10% burned
{
  platformScale: new BN(400000),
  creatorScale: new BN(500000),
  burnScale: new BN(100000),
}

// 100% to creator
{
  platformScale: new BN(0),
  creatorScale: new BN(1000000),
  burnScale: new BN(0),
}

// 100% burned
{
  platformScale: new BN(0),
  creatorScale: new BN(0),
  burnScale: new BN(1000000),
}
```

### Relationship to CPMM fees

`migrateCpLockNftScale` controls **who** earns LP fees. The CPMM `AmmConfig` controls **how much** fee each swap generates.

With a 0.25% trade fee config (12% protocol, 4% fund):

```
trade_fee:   0.25% of swap input
  protocol:  12% of trade fee → Raydium
  fund:       4% of trade fee → Raydium
  LPs:       84% of trade fee → pool vaults
```

With `creatorScale: 500000` and `platformScale: 400000`, the creator's Fee Key NFT earns 50% of LP fees and the platform's earns 40%. The remaining 10% (burned) benefits other LP holders.

`cpConfigId` on the platform config sets which CPMM fee tier migrated pools use. See How to Set CPMM Fees.

### Configuration

Set the LP split in `createPlatformConfig`:

```typescript
migrateCpLockNftScale: {
  platformScale: new BN(400000), // 40%
  creatorScale: new BN(500000),  // 50%
  burnScale: new BN(100000),     // 10%
},
```

One platform config per wallet.

Full example: [createPlatform.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/launchpad/createPlatform.ts)

### Updating

The LP split can be updated once per on-chain epoch:

```typescript
updateInfo: {
  type: 'migrateCpLockNftScale',
  value: {
    platformScale: new BN(300000),
    creatorScale: new BN(600000),
    burnScale: new BN(100000),
  },
},
```

Full example: [updatePlatform.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/launchpad/updatePlatform.ts)

Other updatable fields:

| Update type               | Value       | Description                        |
| ------------------------- | ----------- | ---------------------------------- |
| `updateFeeRate`           | `BN`        | Bonding curve buy/sell fee         |
| `updateCpConfigId`        | `PublicKey` | CPMM fee config for migrated pools |
| `updateClaimFeeWallet`    | `PublicKey` | Platform fee claim wallet          |
| `updatePlatformCpCreator` | `PublicKey` | Creator address on the CPMM pool   |
| `updateVestingWallet`     | `PublicKey` | Vesting distribution wallet        |
