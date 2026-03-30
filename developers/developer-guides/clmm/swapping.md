# Swapping

Execute token swaps in CLMM pools. The SDK supports both **base-input** (fixed input amount) and **base-output** (fixed output amount) swaps.

***

### Base-input swap (exact input)

Specify the exact amount of tokens to sell. The SDK computes the swap route across tick arrays and calculates how many tokens you receive.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  ClmmKeys,
  ComputeClmmPoolInfo,
  PoolUtils,
  ReturnTypeFetchMultiplePoolTickArrays,
  RAYMint,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const swap = async () => {
  const raydium = await initSdk()
  let poolInfo: ApiV3PoolInfoConcentratedItem
  const poolId = 'DiwsGxJYoRZURvyCtMsJVyxR86yZBBbSYeeWNm7YCmT6'
  const inputMint = RAYMint.toBase58()
  let poolKeys: ClmmKeys | undefined
  let clmmPoolInfo: ComputeClmmPoolInfo
  let tickCache: ReturnTypeFetchMultiplePoolTickArrays

  const inputAmount = new BN(100)

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
    if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')

    clmmPoolInfo = await PoolUtils.fetchComputeClmmInfo({
      connection: raydium.connection,
      poolInfo,
    })
    tickCache = await PoolUtils.fetchMultiplePoolTickArrays({
      connection: raydium.connection,
      poolKeys: [clmmPoolInfo],
    })
  } else {
    const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
    clmmPoolInfo = data.computePoolInfo
    tickCache = data.tickData
  }

  if (inputMint !== poolInfo.mintA.address && inputMint !== poolInfo.mintB.address)
    throw new Error('input mint does not match pool')

  const baseIn = inputMint === poolInfo.mintA.address

  const { minAmountOut, remainingAccounts } = await PoolUtils.computeAmountOutFormat({
    poolInfo: clmmPoolInfo,
    tickArrayCache: tickCache[poolId],
    amountIn: inputAmount,
    tokenOut: poolInfo[baseIn ? 'mintB' : 'mintA'],
    slippage: 0.01,
    epochInfo: await raydium.fetchEpochInfo(),
  })

  const { execute } = await raydium.clmm.swap({
    poolInfo,
    poolKeys,
    inputMint: poolInfo[baseIn ? 'mintA' : 'mintB'].address,
    amountIn: inputAmount,
    amountOutMin: minAmountOut.amount.raw,
    observationId: clmmPoolInfo.observationId,
    ownerInfo: {
      useSOLBalance: true,
    },
    remainingAccounts,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 465915,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log(`swapped: ${poolInfo.mintA.symbol} to ${poolInfo.mintB.symbol}:`, {
    txId: `https://explorer.solana.com/tx/${txId}`,
  })
}

swap()
```

***

### Base-output swap (exact output)

Specify the exact amount of tokens to receive. The SDK calculates how many tokens you need to sell.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  ClmmKeys,
  ComputeClmmPoolInfo,
  PoolUtils,
  ReturnTypeFetchMultiplePoolTickArrays,
  USDCMint,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import Decimal from 'decimal.js'
import { NATIVE_MINT } from '@solana/spl-token'
import { initSdk, txVersion } from '../config'
import { isValidClmm } from './utils'

const swapBaseOut = async () => {
  const raydium = await initSdk()
  let poolInfo: ApiV3PoolInfoConcentratedItem
  const poolId = '2QdhepnKRTLjjSqPL1PtKNwqrUkoLee5Gqs8bvZhRdMv'
  let poolKeys: ClmmKeys | undefined
  let clmmPoolInfo: ComputeClmmPoolInfo
  let tickCache: ReturnTypeFetchMultiplePoolTickArrays

  const outputMint = NATIVE_MINT
  const amountOut = new BN(1000000)

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoConcentratedItem
    if (!isValidClmm(poolInfo.programId)) throw new Error('target pool is not CLMM pool')

    clmmPoolInfo = await PoolUtils.fetchComputeClmmInfo({
      connection: raydium.connection,
      poolInfo,
    })
    tickCache = await PoolUtils.fetchMultiplePoolTickArrays({
      connection: raydium.connection,
      poolKeys: [clmmPoolInfo],
    })
  } else {
    const data = await raydium.clmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
    clmmPoolInfo = data.computePoolInfo
    tickCache = data.tickData
  }

  if (
    outputMint.toBase58() !== poolInfo.mintA.address &&
    outputMint.toBase58() !== poolInfo.mintB.address
  )
    throw new Error('output mint does not match pool')

  const { remainingAccounts, ...res } = await PoolUtils.computeAmountIn({
    poolInfo: clmmPoolInfo,
    tickArrayCache: tickCache[poolId],
    amountOut,
    baseMint: outputMint,
    slippage: 0.01,
    epochInfo: await raydium.fetchEpochInfo(),
  })

  const { execute } = await raydium.clmm.swapBaseOut({
    poolInfo,
    poolKeys,
    outputMint,
    amountInMax: res.maxAmountIn.amount,
    amountOut: res.realAmountOut.amount,
    observationId: clmmPoolInfo.observationId,
    ownerInfo: {
      useSOLBalance: true,
    },
    remainingAccounts,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 465915,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('swapped in clmm pool:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

swapBaseOut()
```

***

### Swap parameters (base-input)

| Parameter           | Type                | Description                                                                     |
| ------------------- | ------------------- | ------------------------------------------------------------------------------- |
| `poolInfo`          | object              | Pool info from API or RPC.                                                      |
| `poolKeys`          | object              | Pool keys. Required for devnet.                                                 |
| `inputMint`         | string \| PublicKey | Mint address of the input token.                                                |
| `amountIn`          | BN                  | Amount of input tokens, in smallest units.                                      |
| `amountOutMin`      | BN                  | Minimum output tokens to accept (slippage protection).                          |
| `observationId`     | PublicKey           | Oracle observation account from `clmmPoolInfo.observationId`.                   |
| `remainingAccounts` | array               | Tick array accounts needed for the swap route, from `computeAmountOutFormat()`. |
| `txVersion`         | TxVersion           | Transaction version.                                                            |

### Swap parameters (base-output)

| Parameter           | Type                | Description                                                              |
| ------------------- | ------------------- | ------------------------------------------------------------------------ |
| `poolInfo`          | object              | Pool info from API or RPC.                                               |
| `poolKeys`          | object              | Pool keys. Required for devnet.                                          |
| `outputMint`        | string \| PublicKey | Mint address of the desired output token.                                |
| `amountInMax`       | BN                  | Maximum input tokens to spend (slippage protection).                     |
| `amountOut`         | BN                  | Desired output amount, in smallest units.                                |
| `observationId`     | PublicKey           | Oracle observation account from `clmmPoolInfo.observationId`.            |
| `remainingAccounts` | array               | Tick array accounts needed for the swap route, from `computeAmountIn()`. |
| `txVersion`         | TxVersion           | Transaction version.                                                     |

### Tick arrays and swap computation

CLMM swaps traverse **tick arrays** to move through price ranges. Before submitting a swap, you must:

1. Fetch the pool's compute info via `PoolUtils.fetchComputeClmmInfo()`.
2. Fetch the relevant tick arrays via `PoolUtils.fetchMultiplePoolTickArrays()`.
3. Compute the swap result via `PoolUtils.computeAmountOutFormat()` (base-input) or `PoolUtils.computeAmountIn()` (base-output).

The compute step returns the `remainingAccounts` (tick array accounts) that must be passed to the swap instruction.

{% hint style="info" %}
Always fetch fresh tick array data before computing swaps to get the latest price and liquidity distribution.
{% endhint %}
