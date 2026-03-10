---
description: "Track automatic migration from bonding curve to Raydium AMM."
---

# Monitoring token migration

Migration happens automatically when the bonding curve fundraising goal is reached. No SDK method needs to be called. The on-chain program handles the transition.

## How migration works

When `totalFundRaisingB` worth of quote tokens have been raised:

1. **Status change** — pool status changes from `0` (Trading) to `1` (Migrate)
2. **Trading stops** — buy and sell transactions are rejected
3. **Liquidity transfer** — tokens and quote tokens move from bonding curve vaults to a new AMM pool
4. **LP distribution** — LP tokens are distributed according to `migrateCpLockNftScale`:
   - `burnScale` → burned permanently (liquidity locked forever)
   - `creatorScale` → locked via Burn & Earn, creator receives Fee Key NFT
   - `platformScale` → locked via Burn & Earn, platform receives Fee Key NFT
5. **Status complete** — pool status changes to `2` (Migrated)
6. **AMM trading** — token now trades on Raydium AMM (CPMM or AMMv4)

### Migration destinations

| `migrateType` | Destination | Fee sharing | Notes |
| --- | --- | --- | --- |
| `'cpmm'` | CPMM | Yes | Creator and platform receive Fee Key NFTs for ongoing LP fees |
| `'amm'` | AMM v4 (Hybrid AMM) | No | LP tokens burned, no ongoing fee distribution |

> **Note:** Use `'cpmm'` to enable post-migration fee sharing for creators and platforms.

### What happens to fees

### Pre-migration (bonding curve)

Fees accumulate in protocol, platform, and creator vaults. These can be claimed anytime using respective claim methods.

### Post-migration (AMM pool)

Locked LP tokens earn trading fees from the AMM pool. Fee Key NFT holders claim their share using `harvestLockLiquidity()`. Fees are proportional to the LP share (`creatorScale` / `platformScale`).

### Detecting migration

Monitor pool status to detect when migration occurs:

```typescript
const poolInfo = await raydium.launchpad.getRpcPoolInfo({ poolId })

switch (poolInfo.status) {
  case 0:
    console.log('Trading active')
    break
  case 1:
    console.log('Migration in progress')
    break
  case 2:
    console.log('Migrated to AMM')
    // Find the new AMM pool for continued trading
    break
}
```

## After migration

Once migrated:

- Trading continues on the Raydium AMM pool (not the bonding curve)
- Bonding curve fees can still be claimed from the launchpad vaults
- LP fees are claimed separately using `harvestLockLiquidity()`
- Vesting begins if `cliffPeriod` and `unlockPeriod` were configured
