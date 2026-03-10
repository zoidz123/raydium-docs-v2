---
description: "Claim platform and creator fees before and after migration."
---

# Collecting fees

LaunchLab generates fees at two stages: during bonding curve trading and after migration to liquidity pools. Platforms and creators can claim their earned fees at any time.

### Fee overview

| Stage | Fee type | Who earns | Claim method |
| --- | --- | --- | --- |
| Bonding curve | Trading fees | Platform | `claimVaultPlatformFee()` |
| Bonding curve (former method) | Trading fees | Platform | `claimAllPlatformFee()` |
| Bonding curve | Trading fees | Creator | `claimCreatorFee()` |
| Post-migration | LP trading fees | Platform | `harvestLockLiquidity()` |
| Post-migration | LP trading fees | Creator | `harvestLockLiquidity()` |
| Post-migration | CPMM creator fees | Creator | `collectCreatorFee()` |

***

### Bonding curve fee collection

Fees accumulate during bonding curve trading. Both platforms and creators can claim their share at any time.

#### Platform fee collection

### Claiming from platform vault

Platforms earn a share of every trade on bonding curves they host. Fees accumulate in a vault and can be claimed anytime.

```typescript
import { TxVersion } from '@raydium-io/raydium-sdk-v2'
import { initSdk } from './config'
import { PublicKey } from '@solana/web3.js'
import { NATIVE_MINT } from '@solana/spl-token'

const claimPlatformFees = async () => {
  const raydium = await initSdk()

  const { execute } = await raydium.launchpad.claimVaultPlatformFee({
    platformId: new PublicKey('your-platform-id'),
    mintB: NATIVE_MINT,
    claimFeeWallet: raydium.ownerPubKey, // optional, defaults to signer
    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('Platform fees claimed:', txId)
}
```

### Claiming from multiple quote tokens

If your platform hosts launches with different quote tokens:

```typescript
const claimMultipleVaultFees = async () => {
  const raydium = await initSdk()
  const platformId = new PublicKey('your-platform-id')

  const { execute } = await raydium.launchpad.claimMultipleVaultPlatformFee({
    platformList: [
      { id: platformId, mintB: NATIVE_MINT },
      { id: platformId, mintB: new PublicKey('USDC-mint-address') },
    ],
    unwrapSol: true, // unwrap SOL to native balance
    txVersion: TxVersion.V0,
  })

  const { txIds } = await execute({ sendAndConfirm: true, sequentially: true })
  console.log('Fees claimed:', txIds)
}
```

### Claiming from all pools (former method)

Claim fees from all bonding curve pools on your platform at once:

```typescript
const claimAllFees = async () => {
  const raydium = await initSdk()

  const { execute } = await raydium.launchpad.claimAllPlatformFee({
    platformId: new PublicKey('your-platform-id'),
    platformClaimFeeWallet: raydium.ownerPubKey,
    txVersion: TxVersion.V0,
  })

  const { txIds } = await execute({ sendAndConfirm: true, sequentially: true })
  console.log('All platform fees claimed:', txIds)
}
```

***

#### Creator fee collection

### Claiming bonding curve fees

Creators earn fees from trades on their token's bonding curve. Fees accumulate in a creator-specific vault.

```typescript
import { TxVersion } from '@raydium-io/raydium-sdk-v2'
import { initSdk } from './config'
import { NATIVE_MINT } from '@solana/spl-token'

const claimCreatorFees = async () => {
  const raydium = await initSdk()

  const { execute } = await raydium.launchpad.claimCreatorFee({
    mintB: NATIVE_MINT,
    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('Creator fees claimed:', txId)
}
```

### Claiming from multiple quote tokens

If you've launched tokens with different quote tokens:

```typescript
import { TOKEN_PROGRAM_ID } from '@solana/spl-token'

const claimMultipleCreatorFees = async () => {
  const raydium = await initSdk()

  const { execute } = await raydium.launchpad.claimMultipleCreatorFee({
    mintBList: [
      { pubKey: NATIVE_MINT, programId: TOKEN_PROGRAM_ID },
      { pubKey: new PublicKey('USDC-mint-address'), programId: TOKEN_PROGRAM_ID },
    ],
    txVersion: TxVersion.V0,
  })

  const { txIds } = await execute({ sendAndConfirm: true, sequentially: true })
  console.log('Creator fees claimed:', txIds)
}
```

### Post-migration LP fee collection

After migration to CPMM, both platforms and creators can claim their share of LP trading fees using the Fee Key NFT they received.

### Claiming LP fees

```typescript
import {
  LOCK_CPMM_PROGRAM,
  LOCK_CPMM_AUTH,
} from '@raydium-io/raydium-sdk-v2'

const claimLpFees = async () => {
  const raydium = await initSdk()

  // Get lock position data (contains Fee Key NFT info)
  const lockPositions = await raydium.cpmm.getOwnerLockLpInfo({
    owner: raydium.ownerPubKey,
  })

  for (const position of lockPositions) {
    const { execute } = await raydium.cpmm.harvestLockLp({
      programId: LOCK_CPMM_PROGRAM,
      authProgram: LOCK_CPMM_AUTH,

      // Lock position data
      lockData: position,

      txVersion: TxVersion.V0,
    })

    await execute({ sendAndConfirm: true })
    console.log('LP fees harvested for:', position.poolId.toBase58())
  }
}
```

### Understanding Fee Key NFTs

| Property | Details |
| --- | --- |
| What it is | An NFT minted to the creator/platform wallet during migration |
| What it represents | Claim rights to a share of LP trading fees |
| Transferable | Yes, the new owner inherits fee claim rights |

> **Warning:** Do not burn your Fee Key NFT. If burned, fee claim rights are permanently lost.

#### CPMM creator fees

If `creatorFeeOn` was configured during launch, creators also earn additional fees from CPMM trades. These are separate from the LP fee share.

```typescript
const claimCpmmCreatorFees = async () => {
  const raydium = await initSdk()

  // Get pools where you're the creator
  const pools = await raydium.cpmm.getCreatorPools({
    creator: raydium.ownerPubKey,
  })

  for (const pool of pools) {
    const { execute } = await raydium.cpmm.collectCreatorFee({
      poolInfo: pool,
      txVersion: TxVersion.V0,
    })

    await execute({ sendAndConfirm: true })
  }
}
```

#### Fee accumulation timeline

### Bonding curve phase

- **Platform fees** — claim with `claimVaultPlatformFee()`
- **Creator fees** — claim with `claimCreatorFee()`
- **Denomination** — quote token (for example, SOL)

### Post-migration phase

- **Platform fees** — claim with `harvestLockLp()`
- **Creator fees** — claim with `harvestLockLp()` and optionally `collectCreatorFee()` (CPMM)
- **Denomination** — both tokens in the pair

#### Best practices

1. **Claim regularly** — fees don't auto-compound, claim periodically to realize gains
2. **Track multiple pools** — if you operate multiple launches, batch claims where possible
3. **Secure Fee Key NFTs** — treat them like valuable assets; losing them means losing fee rights
4. **Monitor both sources** — after migration, remember to claim from both bonding curve vaults and LP positions
