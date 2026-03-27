---
description: "Lock LP tokens via Burn & Earn and collect trading fees from locked positions."
---

# Locking liquidity and collecting fees

Lock LP tokens permanently using the Burn & Earn program and collect your share of trading fees via a Fee Key NFT.

***

## How it works

When you lock LP tokens:

1. Your LP tokens are transferred to the Burn & Earn locker program — they cannot be withdrawn.
2. You receive a **Fee Key NFT** that represents your locked position.
3. The Fee Key NFT entitles you to claim trading fees that have accumulated in the pool.

### How fee harvesting works under the hood

In a constant-product pool, fees aren't stored separately — they accumulate in the pool vaults, making each LP token worth more underlying tokens over time. The only way to extract that accrued value is to redeem (burn) LP tokens.

When you harvest from a locked position:

1. Your locked position holds, say, **1000 LP** tokens.
2. Swaps occur, fees flow into the pool vaults, and each LP token appreciates in value.
3. You call `harvestLockLp` with an `lpFeeAmount` (e.g. **5 LP**).
4. The locker program burns those 5 LP via a withdraw on the CPMM program.
5. You receive the proportional share of token A + token B to your wallet.
6. Your locked position now holds **995 LP** tokens.

The LP balance **does decrease** with each harvest. However, the remaining 995 LP tokens are worth roughly what the original 1000 were before fees accumulated, because each LP token is now worth more. You are extracting the appreciation, not the principal.

The `lpFeeAmount` parameter controls how much LP to burn. It is up to you to calculate how much LP appreciation has occurred and pass the appropriate amount to extract just the fee portion.

***

## Locking LP tokens

Use `raydium.cpmm.lockLp()` to permanently lock LP tokens and receive a Fee Key NFT.

```typescript
import {
  ApiV3PoolInfoStandardItemCpmm,
  CpmmKeys,
  DEVNET_PROGRAM_ID,
  TxVersion,
} from '@raydium-io/raydium-sdk-v2'
import { initSdk } from '../config'

const lockLiquidity = async () => {
  const raydium = await initSdk()
  const poolId = 'YOUR_POOL_ID'

  let poolInfo: ApiV3PoolInfoStandardItemCpmm
  let poolKeys: CpmmKeys | undefined

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoStandardItemCpmm
  } else {
    const data = await raydium.cpmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
  }

  // Fetch wallet token accounts to get LP balance
  await raydium.account.fetchWalletTokenAccounts()
  const lpBalance = raydium.account.tokenAccounts.find(
    (a) => a.mint.toBase58() === poolInfo.lpMint.address
  )
  if (!lpBalance) throw new Error(`no LP balance for pool: ${poolId}`)

  const { execute, extInfo } = await raydium.cpmm.lockLp({
    // devnet: programId: DEVNET_PROGRAM_ID.LOCK_CPMM_PROGRAM
    // devnet: authProgram: DEVNET_PROGRAM_ID.LOCK_CPMM_AUTH
    // devnet: poolKeys
    poolInfo,
    lpAmount: lpBalance.amount,
    withMetadata: true,
    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('lp locked', {
    txId: `https://explorer.solana.com/tx/${txId}`,
    nftMint: extInfo,
  })
}

lockLiquidity()
```

### Lock parameters

| Parameter      | Type      | Description                                                                                  |
| -------------- | --------- | -------------------------------------------------------------------------------------------- |
| `poolInfo`     | object    | Pool info from API or RPC.                                                                    |
| `poolKeys`     | object    | Pool keys. Required for devnet.                                                               |
| `lpAmount`     | BN        | Amount of LP tokens to lock, in smallest units.                                               |
| `withMetadata` | boolean   | If `true`, creates on-chain metadata for the Fee Key NFT.                                     |
| `programId`    | PublicKey | Locker program. Mainnet default is auto-resolved. Devnet: `DEVNET_PROGRAM_ID.LOCK_CPMM_PROGRAM`. |
| `authProgram`  | PublicKey | Locker auth program. Devnet: `DEVNET_PROGRAM_ID.LOCK_CPMM_AUTH`.                              |
| `txVersion`    | TxVersion | Transaction version.                                                                          |

{% hint style="warning" %}
Locking is permanent. Once locked, LP tokens cannot be withdrawn. Only the trading fees can be collected via the Fee Key NFT.
{% endhint %}

***

## Collecting fees from locked liquidity

Use `raydium.cpmm.harvestLockLp()` to claim accumulated trading fees from a locked LP position using the Fee Key NFT mint address.

```typescript
import { PublicKey } from '@solana/web3.js'
import BN from 'bn.js'

const harvestLockLiquidity = async () => {
  const raydium = await initSdk()
  const poolId = 'YOUR_POOL_ID'

  let poolInfo: ApiV3PoolInfoStandardItemCpmm
  let poolKeys: CpmmKeys | undefined

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoStandardItemCpmm
  } else {
    const data = await raydium.cpmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
  }

  const { execute } = await raydium.cpmm.harvestLockLp({
    // devnet: programId: DEVNET_PROGRAM_ID.LOCK_CPMM_PROGRAM
    // devnet: authProgram: DEVNET_PROGRAM_ID.LOCK_CPMM_AUTH
    // devnet: poolKeys
    poolInfo,
    nftMint: new PublicKey('YOUR_FEE_KEY_NFT_MINT'),
    lpFeeAmount: new BN(99999999),
    txVersion: TxVersion.V0,
    // closeWsol: false, // default true — set false to keep wSOL account
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('fees harvested', { txId: `https://explorer.solana.com/tx/${txId}` })
}

harvestLockLiquidity()
```

### Harvest parameters

| Parameter     | Type      | Description                                                                       |
| ------------- | --------- | --------------------------------------------------------------------------------- |
| `poolInfo`    | object    | Pool info from API or RPC.                                                         |
| `poolKeys`    | object    | Pool keys. Required for devnet.                                                    |
| `nftMint`     | PublicKey | Mint address of the Fee Key NFT received when locking.                             |
| `lpFeeAmount` | BN        | Amount of LP tokens to burn from the locked position. This is how you extract accumulated fee value — see "How fee harvesting works" above. |
| `closeWsol`   | boolean   | Default `true`. Closes wSOL account and returns native SOL. Set `false` to keep wSOL. |
| `txVersion`   | TxVersion | Transaction version.                                                               |

***

## Collecting creator fees

Creator fees are a separate per-swap fee paid to the pool creator. They are **only available on pools created via the permissioned path** (`createPoolWithPermission`), which requires a Permission PDA from the Raydium admin. Pools created with the standard `createPool()` have creator fees disabled at the program level — see [Creating a pool](creating-a-pool.md#creating-a-pool-with-permission-creator-fees) for details.

If your pool was created with permission and the fee config includes a non-zero `creator_fee_rate`, you can collect the accumulated creator fees.

### Single pool

```typescript
const collectCreatorFee = async () => {
  const raydium = await initSdk()
  // ... fetch poolInfo and poolKeys

  const { execute } = await raydium.cpmm.collectCreatorFees({
    poolInfo,
    poolKeys,
    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('creator fees collected', { txId: `https://explorer.solana.com/tx/${txId}` })
}
```

### Multiple pools at once

```typescript
import {
  CREATE_CPMM_POOL_PROGRAM,
  DEVNET_PROGRAM_ID,
} from '@raydium-io/raydium-sdk-v2'

const collectAllCreatorFees = async () => {
  const raydium = await initSdk()
  const isDevnet = raydium.cluster === 'devnet'

  const host = isDevnet
    ? 'https://temp-api-v1-devnet.raydium.io'
    : 'https://temp-api-v1.raydium.io'

  // Fetch all pools where the connected wallet has pending creator fees
  const res = await fetch(
    `${host}/cp-creator-fee?wallet=${raydium.ownerPubKey.toBase58()}`
  )
  const { data } = await res.json()

  const poolsWithFees = data.filter(
    (d: any) => d.fee.amountA !== '0' || d.fee.amountB !== '0'
  )

  if (!poolsWithFees.length) {
    console.log('no pending creator fees')
    return
  }

  const { execute } = await raydium.cpmm.collectMultiCreatorFees({
    poolInfoList: poolsWithFees.map((d: any) => d.poolInfo),
    programId: isDevnet
      ? DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM
      : CREATE_CPMM_POOL_PROGRAM,
    txVersion: TxVersion.V0,
  })

  const sentInfo = await execute({ sequentially: true })
  console.log('creator fees collected', sentInfo)
}
```
