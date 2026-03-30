# Deposting / withdrawing liquidity

Add liquidity to an existing CLMM position to increase your concentration, or remove liquidity to withdraw tokens.

***

### Fetching pool and position info

Both operations require pool information and the position you want to modify.

```typescript
import { ApiV3PoolInfoConcentratedItem, ClmmKeys } from '@raydium-io/raydium-sdk-v2'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const raydium = await initSdk()
const poolId = 'YOUR_POOL_ID'
let poolInfo: ApiV3PoolInfoConcentratedItem
let poolKeys: ClmmKeys | undefined

if (raydium.cluster === 'mainnet') {
  const data = await raydium.api.fetchPoolById({ ids: poolId })
  poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
  if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')
} else {
  const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
  poolInfo = data.poolInfo
  poolKeys = data.poolKeys
}

const allPosition = await raydium.clmm.getOwnerPositionInfo({ programId: poolInfo.programId })
const position = allPosition.find((p) => p.poolId.toBase58() === poolInfo.id)
if (!position) throw new Error(`no position found in pool: ${poolInfo.id}`)
```

***

### Depositing liquidity (increase)

Use `raydium.clmm.increasePositionFromLiquidity()` to add more liquidity to an existing position. The SDK computes the required token amounts based on the position's tick range and the current pool price.

```typescript
import { ApiV3PoolInfoConcentratedItem, ClmmKeys, PoolUtils } from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import Decimal from 'decimal.js'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const increaseLiquidity = async () => {
  const raydium = await initSdk()
  const poolId = 'Enfoa5Xdtirwa46xxa5LUVcQWe7EUb2pGzTjfvU7EBS1'
  let poolInfo: ApiV3PoolInfoConcentratedItem
  let poolKeys: ClmmKeys | undefined

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
    if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')
  } else {
    const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
  }

  const allPosition = await raydium.clmm.getOwnerPositionInfo({ programId: poolInfo.programId })
  if (!allPosition.length) throw new Error('user do not have any positions')

  const position = allPosition.find((p) => p.poolId.toBase58() === poolInfo.id)
  if (!position) throw new Error(`user do not have position in pool: ${poolInfo.id}`)

  const inputAmount = 0.0001 // UI amount
  const slippage = 0.05

  const epochInfo = await raydium.fetchEpochInfo()
  const res = await PoolUtils.getLiquidityAmountOutFromAmountIn({
    poolInfo,
    slippage: 0,
    inputA: true,
    tickUpper: Math.max(position.tickLower, position.tickUpper),
    tickLower: Math.min(position.tickLower, position.tickUpper),
    amount: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    add: true,
    amountHasFee: true,
    epochInfo,
  })

  const { execute } = await raydium.clmm.increasePositionFromLiquidity({
    poolInfo,
    poolKeys,
    ownerPosition: position,
    ownerInfo: {
      useSOLBalance: true,
    },
    liquidity: new BN(new Decimal(res.liquidity.toString()).mul(1 - slippage).toFixed(0)),
    amountMaxA: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    amountMaxB: new BN(
      new Decimal(res.amountSlippageB.amount.toString()).mul(1 + slippage).toFixed(0)
    ),
    checkCreateATAOwner: true,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('clmm position liquidity increased:', {
    txId: `https://explorer.solana.com/tx/${txId}`,
  })
}

increaseLiquidity()
```

#### Deposit parameters

| Parameter             | Type      | Description                                                             |
| --------------------- | --------- | ----------------------------------------------------------------------- |
| `poolInfo`            | object    | Pool info from API or RPC.                                              |
| `poolKeys`            | object    | Pool keys. Required for devnet.                                         |
| `ownerPosition`       | object    | Position info from `getOwnerPositionInfo()`.                            |
| `liquidity`           | BN        | Liquidity amount to add (slippage-adjusted).                            |
| `amountMaxA`          | BN        | Maximum token A to deposit, in smallest units.                          |
| `amountMaxB`          | BN        | Maximum token B to deposit, in smallest units (slippage-adjusted).      |
| `ownerInfo`           | object    | `{ useSOLBalance: true }` to use native SOL balance for wrapping.       |
| `checkCreateATAOwner` | boolean   | If `true`, verifies associated token account ownership before creating. |
| `txVersion`           | TxVersion | Transaction version.                                                    |

***

### Withdrawing liquidity (decrease)

Use `raydium.clmm.decreaseLiquidity()` to remove liquidity from a position and receive back tokens.

```typescript
import { ApiV3PoolInfoConcentratedItem, ClmmKeys } from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const decreaseLiquidity = async () => {
  const raydium = await initSdk()

  let poolInfo: ApiV3PoolInfoConcentratedItem
  const poolId = '2QdhepnKRTLjjSqPL1PtKNwqrUkoLee5Gqs8bvZhRdMv'
  let poolKeys: ClmmKeys | undefined

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
    if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')
  } else {
    const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
  }

  const allPosition = await raydium.clmm.getOwnerPositionInfo({ programId: poolInfo.programId })
  if (!allPosition.length) throw new Error('user do not have any positions')

  const position = allPosition.find((p) => p.poolId.toBase58() === poolInfo.id)
  if (!position) throw new Error(`user do not have position in pool: ${poolInfo.id}`)

  const { execute } = await raydium.clmm.decreaseLiquidity({
    poolInfo,
    poolKeys,
    ownerPosition: position,
    ownerInfo: {
      useSOLBalance: true,
      closePosition: true, // close the position after withdrawing all liquidity
    },
    liquidity: position.liquidity,
    amountMinA: new BN(0),
    amountMinB: new BN(0),
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('withdraw liquidity from clmm position:', {
    txId: `https://explorer.solana.com/tx/${txId}`,
  })
}

decreaseLiquidity()
```

#### Withdraw parameters

| Parameter       | Type      | Description                                                                                                                         |
| --------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `poolInfo`      | object    | Pool info from API or RPC.                                                                                                          |
| `poolKeys`      | object    | Pool keys. Required for devnet.                                                                                                     |
| `ownerPosition` | object    | Position info from `getOwnerPositionInfo()`.                                                                                        |
| `liquidity`     | BN        | Amount of liquidity to remove. Use `position.liquidity` to withdraw everything.                                                     |
| `amountMinA`    | BN        | Minimum token A to receive (slippage protection).                                                                                   |
| `amountMinB`    | BN        | Minimum token B to receive (slippage protection).                                                                                   |
| `ownerInfo`     | object    | `{ useSOLBalance: true, closePosition: boolean }`. Set `closePosition: true` to close the position after withdrawing all liquidity. |
| `txVersion`     | TxVersion | Transaction version.                                                                                                                |

{% hint style="info" %}
When `closePosition` is `true`, the position NFT is burned and account rent is reclaimed. Only set this when withdrawing the full liquidity amount.
{% endhint %}
