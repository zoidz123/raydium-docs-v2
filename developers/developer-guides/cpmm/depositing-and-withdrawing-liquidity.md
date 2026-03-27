---
description: "Add and remove liquidity from CPMM pools using the Raydium SDK."
---

# Depositing and withdrawing liquidity

Deposit tokens into a CPMM pool to receive LP tokens, or burn LP tokens to withdraw your share of the pool.

***

## Fetching pool info

Both deposit and withdraw operations require pool information.

```typescript
import {
  ApiV3PoolInfoStandardItemCpmm,
  CpmmKeys,
  CREATE_CPMM_POOL_PROGRAM,
  DEVNET_PROGRAM_ID,
} from '@raydium-io/raydium-sdk-v2'
import { initSdk } from '../config'

const VALID_PROGRAM_ID = new Set([
  CREATE_CPMM_POOL_PROGRAM.toBase58(),
  DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM.toBase58(),
])
const isValidCpmm = (id: string) => VALID_PROGRAM_ID.has(id)

let poolInfo: ApiV3PoolInfoStandardItemCpmm
let poolKeys: CpmmKeys | undefined

const raydium = await initSdk()
const poolId = 'YOUR_POOL_ID'

if (raydium.cluster === 'mainnet') {
  const data = await raydium.api.fetchPoolById({ ids: poolId })
  poolInfo = data[0] as ApiV3PoolInfoStandardItemCpmm
  if (!isValidCpmm(poolInfo.programId)) throw new Error('target pool is not CPMM pool')
} else {
  const data = await raydium.cpmm.getPoolInfoFromRpc(poolId)
  poolInfo = data.poolInfo
  poolKeys = data.poolKeys
}
```

***

## Depositing liquidity

Use `raydium.cpmm.addLiquidity()` to deposit tokens into a pool. You specify one token amount, and the SDK calculates the required amount of the other token based on the current pool ratio.

```typescript
import { Percent } from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import Decimal from 'decimal.js'

const deposit = async () => {
  const raydium = await initSdk()
  // ... fetch poolInfo and poolKeys as shown above

  const uiInputAmount = '0.0001'
  const inputAmount = new BN(
    new Decimal(uiInputAmount).mul(10 ** poolInfo.mintA.decimals).toFixed(0)
  )
  const slippage = new Percent(1, 100) // 1%
  const baseIn = true // true = inputAmount is for mintA, false = for mintB

  const { execute } = await raydium.cpmm.addLiquidity({
    poolInfo,
    poolKeys,
    inputAmount,
    slippage,
    baseIn,
    txVersion: TxVersion.V0,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('pool deposited', { txId: `https://explorer.solana.com/tx/${txId}` })
}
```

### Computing the paired amount (optional)

Before depositing, you can preview the required amount of the other token for UI display:

```typescript
const rpcPoolInfos = await raydium.cpmm.getRpcPoolInfos([poolId])
const pool1Info = rpcPoolInfos[poolId]

const computeRes = await raydium.cpmm.computePairAmount({
  baseReserve: pool1Info.baseReserve,
  quoteReserve: pool1Info.quoteReserve,
  poolInfo,
  amount: uiInputAmount,
  slippage,
  baseIn,
  epochInfo: await raydium.fetchEpochInfo(),
})

// computeRes.anotherAmount.amount -> paired token amount needed
// computeRes.anotherAmount.fee -> Token-2022 transfer fee (if applicable)
```

### Deposit parameters

| Parameter     | Type    | Description                                                                                          |
| ------------- | ------- | ---------------------------------------------------------------------------------------------------- |
| `poolInfo`    | object  | Pool info from API or RPC.                                                                            |
| `poolKeys`    | object  | Pool keys, required for devnet. Optional on mainnet (SDK derives them).                               |
| `inputAmount` | BN      | Amount to deposit for the base or quote token, in smallest units.                                     |
| `slippage`    | Percent | Slippage tolerance. `new Percent(1, 100)` = 1%.                                                      |
| `baseIn`      | boolean | `true` if `inputAmount` is for token A, `false` for token B.                                          |
| `txVersion`   | TxVersion | Transaction version.                                                                                |

***

## Withdrawing liquidity

Use `raydium.cpmm.withdrawLiquidity()` to burn LP tokens and receive back your proportional share of both tokens.

```typescript
import { Percent } from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'

const withdraw = async () => {
  const raydium = await initSdk()
  // ... fetch poolInfo and poolKeys as shown above

  const slippage = new Percent(1, 100) // 1%
  const lpAmount = new BN(100) // LP token amount to withdraw

  const { execute } = await raydium.cpmm.withdrawLiquidity({
    poolInfo,
    poolKeys,
    lpAmount,
    slippage,
    txVersion: TxVersion.V0,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('pool withdrawn', { txId: `https://explorer.solana.com/tx/${txId}` })
}
```

### Withdraw parameters

| Parameter  | Type    | Description                                                                    |
| ---------- | ------- | ------------------------------------------------------------------------------ |
| `poolInfo` | object  | Pool info from API or RPC.                                                      |
| `poolKeys` | object  | Pool keys, required for devnet.                                                 |
| `lpAmount` | BN      | Amount of LP tokens to burn, in smallest units.                                 |
| `slippage` | Percent | Slippage tolerance for minimum token amounts received.                          |
| `txVersion`| TxVersion | Transaction version.                                                          |

{% hint style="info" %}
By default, the SDK automatically closes the wSOL account and returns native SOL. To keep the wSOL account open, pass `closeWsol: false`.
{% endhint %}
