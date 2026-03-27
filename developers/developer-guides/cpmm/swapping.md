---
description: "Execute swaps in CPMM pools using the Raydium SDK."
---

# Swapping

Execute token swaps in CPMM pools. The SDK supports both **base-input** (fixed input amount) and **base-output** (fixed output amount) swaps.

***

## Swap flow

1. Fetch pool info and on-chain reserve data.
2. Compute the swap result off-chain using `CurveCalculator`.
3. Submit the swap transaction with slippage protection.

***

## Base-input swap (exact input)

Specify the exact amount of tokens to sell. The SDK calculates how many tokens you receive.

```typescript
import {
  ApiV3PoolInfoStandardItemCpmm,
  CpmmKeys,
  CpmmParsedRpcData,
  CurveCalculator,
  FeeOn,
  TxVersion,
} from '@raydium-io/raydium-sdk-v2'
import { NATIVE_MINT } from '@solana/spl-token'
import BN from 'bn.js'
import { initSdk } from '../config'

const swap = async () => {
  const raydium = await initSdk()

  const poolId = '7JuwJuNU88gurFnyWeiyGKbFmExMWcmRZntn9imEzdny'
  const inputAmount = new BN(100)
  const inputMint = NATIVE_MINT.toBase58()

  let poolInfo: ApiV3PoolInfoStandardItemCpmm
  let poolKeys: CpmmKeys | undefined
  let rpcData: CpmmParsedRpcData

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoStandardItemCpmm
    rpcData = await raydium.cpmm.getRpcPoolInfo(poolInfo.id, true)
  } else {
    const data = await raydium.cpmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
    rpcData = data.rpcData
  }

  if (inputMint !== poolInfo.mintA.address && inputMint !== poolInfo.mintB.address)
    throw new Error('input mint does not match pool')

  const baseIn = inputMint === poolInfo.mintA.address

  // Compute the swap off-chain
  const swapResult = CurveCalculator.swapBaseInput(
    inputAmount,
    baseIn ? rpcData.baseReserve : rpcData.quoteReserve,
    baseIn ? rpcData.quoteReserve : rpcData.baseReserve,
    rpcData.configInfo!.tradeFeeRate,
    rpcData.configInfo!.creatorFeeRate,
    rpcData.configInfo!.protocolFeeRate,
    rpcData.configInfo!.fundFeeRate,
    rpcData.feeOn === FeeOn.BothToken || rpcData.feeOn === FeeOn.OnlyTokenB
  )

  /**
   * swapResult.inputAmount   -> actual input after fees
   * swapResult.outputAmount  -> tokens received
   * swapResult.tradeFee      -> fee charged on input mint
   */

  const { execute } = await raydium.cpmm.swap({
    poolInfo,
    poolKeys,
    inputAmount,
    swapResult,
    slippage: 0.001, // 0.1% — range: 1 (100%) to 0.0001 (0.01%)
    baseIn,
    txVersion: TxVersion.V0,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 4659150,
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

## Base-output swap (exact output)

Specify the exact amount of tokens to receive. The SDK calculates how many tokens you need to sell.

```typescript
import {
  ApiV3PoolInfoStandardItemCpmm,
  CpmmKeys,
  CpmmParsedRpcData,
  CurveCalculator,
  FeeOn,
  TxVersion,
} from '@raydium-io/raydium-sdk-v2'
import { PublicKey } from '@solana/web3.js'
import BN from 'bn.js'
import { initSdk } from '../config'

const swapBaseOut = async () => {
  const raydium = await initSdk()

  const poolId = '7JuwJuNU88gurFnyWeiyGKbFmExMWcmRZntn9imEzdny'
  const outputAmount = new BN(1_000_000_000)
  const outputMint = new PublicKey('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')

  let poolInfo: ApiV3PoolInfoStandardItemCpmm
  let poolKeys: CpmmKeys | undefined
  let rpcData: CpmmParsedRpcData

  if (raydium.cluster === 'mainnet') {
    const data = await raydium.api.fetchPoolById({ ids: poolId })
    poolInfo = data[0] as ApiV3PoolInfoStandardItemCpmm
    rpcData = await raydium.cpmm.getRpcPoolInfo(poolInfo.id, true)
  } else {
    const data = await raydium.cpmm.getPoolInfoFromRpc(poolId)
    poolInfo = data.poolInfo
    poolKeys = data.poolKeys
    rpcData = data.rpcData
  }

  if (
    outputMint.toBase58() !== poolInfo.mintA.address &&
    outputMint.toBase58() !== poolInfo.mintB.address
  )
    throw new Error('output mint does not match pool')

  const baseIn = outputMint.toBase58() === poolInfo.mintB.address

  // Clamp output to available reserves
  const reserveKey = baseIn ? 'quoteReserve' : 'baseReserve'
  const clampedOutput = outputAmount.gt(rpcData[reserveKey])
    ? rpcData[reserveKey].sub(new BN(1))
    : outputAmount

  const swapResult = CurveCalculator.swapBaseOutput(
    clampedOutput,
    baseIn ? rpcData.baseReserve : rpcData.quoteReserve,
    baseIn ? rpcData.quoteReserve : rpcData.baseReserve,
    rpcData.configInfo!.tradeFeeRate,
    rpcData.configInfo!.creatorFeeRate,
    rpcData.configInfo!.protocolFeeRate,
    rpcData.configInfo!.fundFeeRate,
    rpcData.feeOn === FeeOn.BothToken || rpcData.feeOn === FeeOn.OnlyTokenB
  )

  /**
   * swapResult.inputAmount   -> input amount needed
   * swapResult.outputAmount  -> output amount received
   * swapResult.tradeFee      -> fee charged on input mint
   */

  const { execute } = await raydium.cpmm.swap({
    poolInfo,
    poolKeys,
    inputAmount: new BN(0), // ignored when fixedOut is true
    fixedOut: true,
    swapResult,
    slippage: 0.001, // 0.1%
    baseIn,
    txVersion: TxVersion.V0,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 465915,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('swapped:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

swapBaseOut()
```

***

## Swap parameters

| Parameter     | Type    | Description                                                                                                  |
| ------------- | ------- | ------------------------------------------------------------------------------------------------------------ |
| `poolInfo`    | object  | Pool info from API or RPC.                                                                                    |
| `poolKeys`    | object  | Pool keys. Required for devnet.                                                                               |
| `inputAmount` | BN      | Amount of input tokens (base-input). Ignored when `fixedOut: true`.                                           |
| `fixedOut`    | boolean | Set `true` for base-output swaps. Default `false`.                                                            |
| `swapResult`  | object  | Pre-computed swap result from `CurveCalculator.swapBaseInput()` or `CurveCalculator.swapBaseOutput()`.         |
| `slippage`    | number  | Slippage tolerance as a decimal. `0.001` = 0.1%. Range: `1` (100%) to `0.0001` (0.01%).                       |
| `baseIn`      | boolean | `true` if swapping mintA → mintB, `false` for mintB → mintA.                                                  |
| `txVersion`   | TxVersion | Transaction version.                                                                                        |

## CurveCalculator

The `CurveCalculator` computes swap amounts off-chain before submitting the transaction.

| Method            | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `swapBaseInput()` | Given exact input amount, compute output and fees.     |
| `swapBaseOutput()`| Given desired output amount, compute required input.   |

Both methods take the same fee parameters from the pool's `configInfo`:

| Parameter          | Description                                          |
| ------------------ | ---------------------------------------------------- |
| `tradeFeeRate`     | Fee taken from swap input, in units of 1e-6.          |
| `creatorFeeRate`   | Additional fee sent to the pool creator.              |
| `protocolFeeRate`  | Share of trade fee sent to Raydium protocol.          |
| `fundFeeRate`      | Share of trade fee sent to Raydium treasury.          |

{% hint style="info" %}
Always fetch fresh RPC data (`getRpcPoolInfo`) before computing swaps to get the latest reserves and avoid stale quotes.
{% endhint %}
