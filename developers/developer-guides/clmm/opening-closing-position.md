# Opening / closing position

Open a position with a custom price range to provide concentrated liquidity, or close an empty position to reclaim rent.

***

### How CLMM positions work

Each CLMM position is represented by an NFT in your wallet. A position defines:

* A **price range** (lower tick and upper tick) where your liquidity is active.
* The **amounts of token A and token B** deposited within that range.

Liquidity only earns trading fees when the pool's current price is within your position's range.

***

### Fetching pool info

Both open and close operations require pool information.

```typescript
import { ApiV3PoolInfoConcentratedItem, ClmmKeys, CLMM_PROGRAM_ID, DEVNET_PROGRAM_ID } from '@raydium-io/raydium-sdk-v2'
import { initSdk, txVersion } from '../config'

const VALID_PROGRAM_ID = new Set([
  CLMM_PROGRAM_ID.toBase58(),
  DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID.toBase58(),
])
const isValidClmm = (id: string) => VALID_PROGRAM_ID.has(id)

let poolInfo: ApiV3PoolInfoConcentratedItem
let poolKeys: ClmmKeys | undefined

const raydium = await initSdk()
const poolId = 'YOUR_POOL_ID'

if (raydium.cluster === 'mainnet') {
  const data = await raydium.api.fetchPoolById({ ids: poolId })
  poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
  if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')
} else {
  const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
  poolInfo = data.poolInfo
  poolKeys = data.poolKeys
}
```

***

### Opening a position

Use `raydium.clmm.openPositionFromBase()` to open a new position. You specify one token amount, a price range, and the SDK computes the other token amount needed.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  TickUtils,
  PoolUtils,
  ClmmKeys,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import Decimal from 'decimal.js'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const createPosition = async () => {
  const raydium = await initSdk()

  let poolInfo: ApiV3PoolInfoConcentratedItem
  const poolId = '61R1ndXxvsWXXkWSyNkCxnzwd3zUNB8Q2ibmkiLPC8ht'
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

  const inputAmount = 0.000001
  const [startPrice, endPrice] = [0.000001, 100000]

  const { tick: lowerTick } = TickUtils.getPriceAndTick({
    poolInfo,
    price: new Decimal(startPrice),
    baseIn: true,
  })

  const { tick: upperTick } = TickUtils.getPriceAndTick({
    poolInfo,
    price: new Decimal(endPrice),
    baseIn: true,
  })

  const epochInfo = await raydium.fetchEpochInfo()
  const res = await PoolUtils.getLiquidityAmountOutFromAmountIn({
    poolInfo,
    slippage: 0,
    inputA: true,
    tickUpper: Math.max(lowerTick, upperTick),
    tickLower: Math.min(lowerTick, upperTick),
    amount: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    add: true,
    amountHasFee: true,
    epochInfo,
  })

  const { execute, extInfo } = await raydium.clmm.openPositionFromBase({
    poolInfo,
    poolKeys,
    tickUpper: Math.max(lowerTick, upperTick),
    tickLower: Math.min(lowerTick, upperTick),
    base: 'MintA',
    ownerInfo: {
      useSOLBalance: true,
    },
    baseAmount: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    otherAmountMax: res.amountSlippageB.amount,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 100000,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('clmm position opened:', { txId, nft: extInfo.nftMint.toBase58() })
}

createPosition()
```

#### Converting prices to ticks

CLMM positions use **ticks** to define price boundaries. Use `TickUtils.getPriceAndTick()` to convert human-readable prices to valid tick values aligned to the pool's tick spacing.

```typescript
const { tick } = TickUtils.getPriceAndTick({
  poolInfo,
  price: new Decimal(100),
  baseIn: true, // true = price of mintA in terms of mintB
})
```

#### Computing the paired amount

Before opening, use `PoolUtils.getLiquidityAmountOutFromAmountIn()` to preview how much of the other token is needed for your chosen range and input amount.

#### Open position parameters

| Parameter        | Type      | Description                                                       |
| ---------------- | --------- | ----------------------------------------------------------------- |
| `poolInfo`       | object    | Pool info from API or RPC.                                        |
| `poolKeys`       | object    | Pool keys. Required for devnet.                                   |
| `tickLower`      | number    | Lower tick boundary of the position.                              |
| `tickUpper`      | number    | Upper tick boundary of the position.                              |
| `base`           | string    | `'MintA'` or `'MintB'` — which token `baseAmount` refers to.      |
| `baseAmount`     | BN        | Amount of the base token to deposit, in smallest units.           |
| `otherAmountMax` | BN        | Maximum amount of the other token (slippage-adjusted).            |
| `ownerInfo`      | object    | `{ useSOLBalance: true }` to use native SOL balance for wrapping. |
| `txVersion`      | TxVersion | Transaction version.                                              |

#### Return value

The `extInfo` object contains:

| Field     | Description                       |
| --------- | --------------------------------- |
| `nftMint` | The position NFT mint public key. |

***

### Opening a position from liquidity

Use `raydium.clmm.openPositionFromLiquidity()` as an alternative to `openPositionFromBase()`. Instead of specifying one token amount, you specify a target liquidity value and maximum amounts for both tokens.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  TickUtils,
  PoolUtils,
  ClmmKeys,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import Decimal from 'decimal.js'
import { initSdk, txVersion } from '../config'

const createPositionFromLiquidity = async () => {
  const raydium = await initSdk()

  let poolInfo: ApiV3PoolInfoConcentratedItem
  const poolId = '8sN9549P3Zn6xpQRqpApN57xzkCh6sJxLwuEjcG2W4Ji'
  let poolKeys: ClmmKeys | undefined
  const slippage = 0.025

  const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
  poolInfo = data.poolInfo
  poolKeys = data.poolKeys

  const inputAmount = 0.025
  const [startPrice, endPrice] = [560.979027728865622, 647.86110003403338]

  const { tick: lowerTick } = TickUtils.getPriceAndTick({
    poolInfo,
    price: new Decimal(startPrice),
    baseIn: true,
  })

  const { tick: upperTick } = TickUtils.getPriceAndTick({
    poolInfo,
    price: new Decimal(endPrice),
    baseIn: true,
  })

  const epochInfo = await raydium.fetchEpochInfo()
  const res = await PoolUtils.getLiquidityAmountOutFromAmountIn({
    poolInfo,
    slippage: 0,
    inputA: true,
    tickUpper: Math.max(lowerTick, upperTick),
    tickLower: Math.min(lowerTick, upperTick),
    amount: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    add: true,
    amountHasFee: true,
    epochInfo,
  })

  const { execute, extInfo } = await raydium.clmm.openPositionFromLiquidity({
    poolInfo,
    poolKeys,
    tickUpper: Math.max(lowerTick, upperTick),
    tickLower: Math.min(lowerTick, upperTick),
    liquidity: res.liquidity,
    amountMaxA: new BN(new Decimal(inputAmount || '0').mul(10 ** poolInfo.mintA.decimals).toFixed(0)),
    amountMaxB: new BN(
      new Decimal(res.amountSlippageB.amount.toString()).mul(1 + slippage).toFixed(0)
    ),
    ownerInfo: {
      useSOLBalance: true,
    },
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 10000,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('clmm position opened:', { txId, nft: extInfo.address.nftMint.toBase58() })
}

createPositionFromLiquidity()
```

#### Parameters (from liquidity)

| Parameter    | Type      | Description                                                        |
| ------------ | --------- | ------------------------------------------------------------------ |
| `poolInfo`   | object    | Pool info from API or RPC.                                         |
| `poolKeys`   | object    | Pool keys. Required for devnet.                                    |
| `tickLower`  | number    | Lower tick boundary of the position.                               |
| `tickUpper`  | number    | Upper tick boundary of the position.                               |
| `liquidity`  | BN        | Target liquidity amount.                                           |
| `amountMaxA` | BN        | Maximum token A to deposit (slippage-adjusted), in smallest units. |
| `amountMaxB` | BN        | Maximum token B to deposit (slippage-adjusted), in smallest units. |
| `ownerInfo`  | object    | `{ useSOLBalance: true }` to use native SOL balance for wrapping.  |
| `txVersion`  | TxVersion | Transaction version.                                               |

***

### Closing a position

Use `raydium.clmm.closePosition()` to close a position and reclaim the account rent. The position must have zero liquidity, zero unclaimed fees, and zero unclaimed rewards. Withdraw all liquidity and harvest all fees/rewards before closing.

```typescript
import { ApiV3PoolInfoConcentratedItem, ClmmKeys } from '@raydium-io/raydium-sdk-v2'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const closePosition = async () => {
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

  const { execute } = await raydium.clmm.closePosition({
    poolInfo,
    poolKeys,
    ownerPosition: position,
    txVersion,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('clmm position closed:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

closePosition()
```

{% hint style="warning" %}
The program requires **zero liquidity, zero unclaimed fees, and zero unclaimed rewards** to close a position. The simplest approach is to pass `closePosition: true` in `decreaseLiquidity()` — the SDK bundles the decrease (which collects fees and rewards) and the close into one transaction. If closing separately, call `harvestAllRewards()` and `decreaseLiquidity()` first to zero out all balances.
{% endhint %}

#### Close position parameters

| Parameter       | Type      | Description                                  |
| --------------- | --------- | -------------------------------------------- |
| `poolInfo`      | object    | Pool info from API or RPC.                   |
| `poolKeys`      | object    | Pool keys. Required for devnet.              |
| `ownerPosition` | object    | Position info from `getOwnerPositionInfo()`. |
| `txVersion`     | TxVersion | Transaction version.                         |
