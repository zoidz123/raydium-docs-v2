---
description: "Integrate LaunchLab bonding-curve trading."
---

# Buying and selling a token

Once a token is launched, users can buy and sell on the bonding curve until the fundraising goal is reached. This section covers how to integrate trading functionality.

## How bonding curve trading works

LaunchLab uses bonding curves to determine token prices based on supply and demand:

- **Buying** increases the price — each purchase moves the price up along the curve
- **Selling** decreases the price — each sale moves the price down along the curve
- **Price discovery** — early buyers get lower prices, creating incentive for early participation

Trading continues until `totalFundRaisingB` worth of quote tokens have been collected, at which point the pool migrates to a Raydium AMM.

## Buying tokens

Use `buyToken()` to purchase tokens with quote tokens (for example, SOL).

```typescript
import { TxVersion } from '@raydium-io/raydium-sdk-v2'
import { initSdk } from './config'
import { PublicKey } from '@solana/web3.js'
import BN from 'bn.js'

const buyTokens = async () => {
  const raydium = await initSdk()

  const { execute, extInfo } = await raydium.launchpad.buyToken({
    mintA: new PublicKey('token-mint-address'),
    buyAmount: new BN(1_000_000_000),  // 1 SOL in lamports
    slippage: new BN(100),             // 1% slippage
    txVersion: TxVersion.V0,
  })

  console.log('Expected tokens:', extInfo.decimalOutAmount.toString())

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('Transaction:', txId)
}
```

### Buy parameters

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mintA` | PublicKey | Yes | The token mint to buy. |
| `mintAProgram` | PublicKey | No | Token program (SPL or Token-2022). SDK detects if omitted. |
| `buyAmount` | BN | Yes | Amount of quote tokens to spend (for example, lamports for SOL). |
| `poolInfo` | object | No | Pool state data. SDK fetches if omitted. |
| `configInfo` | object | No | Global config data. SDK fetches if omitted. |
| `platformFeeRate` | BN | No | Platform's fee rate. SDK fetches if omitted. |
| `slippage` | BN | No | Maximum slippage in bps (`100 = 1%`). Default: `100`. |
| `minMintAAmount` | BN | No | Minimum tokens to receive. SDK calculates if omitted. |

### Buying exact token amount

Use `buyTokenExactOut()` to specify exactly how many tokens you want to receive.

```typescript
const { execute, extInfo } = await raydium.launchpad.buyTokenExactOut({
  programId: LAUNCHPAD_PROGRAM,
  mintA,
  poolInfo,

  // Specify exact output
  outAmount: new BN('1000000000000'),  // Exact tokens to receive
  maxBuyAmount: new BN('2000000000'),  // Maximum quote tokens to spend

  slippage: new BN(100),
  txVersion: TxVersion.V0,
})
```

## Selling tokens

Use `sellToken()` to sell tokens back for quote tokens.

```typescript
const sellTokens = async () => {
  const raydium = await initSdk()

  const mintA = new PublicKey('token-mint-address')
  const sellAmount = new BN('500000000000')  // Tokens to sell

  const { execute, extInfo } = await raydium.launchpad.sellToken({
    programId: LAUNCHPAD_PROGRAM,

    // Token to sell
    mintA,

    // Sell parameters
    sellAmount,             // Amount of tokens to sell
    slippage: new BN(100),  // 1% slippage tolerance

    txVersion: TxVersion.V0,
  })

  console.log('Expected quote tokens:', extInfo.outAmount.toString())

  await execute({ sendAndConfirm: true })
}
```

### Sell parameters

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mintA` | PublicKey | Yes | The token mint to sell. |
| `sellAmount` | BN | Yes | Amount of tokens to sell. |
| `poolInfo` | object | No | Pool state data. SDK fetches if omitted. |
| `slippage` | BN | No | Maximum slippage in bps (`100 = 1%`). Default: `100`. |
| `minAmountB` | BN | No | Minimum quote tokens to receive. SDK calculates if omitted. |

### Selling for exact quote amount

Use `sellTokenExactOut()` to specify exactly how many quote tokens you want to receive.

```typescript
const { execute } = await raydium.launchpad.sellTokenExactOut({
  programId: LAUNCHPAD_PROGRAM,
  mintA,
  poolInfo,

  // Specify exact output
  inAmount: new BN('1000000000'),        // Exact quote tokens to receive
  maxSellAmount: new BN('600000000000'), // Maximum tokens to sell

  slippage: new BN(100),
  txVersion: TxVersion.V0,
})
```

## Advanced: Calculating quotes

Use the `Curve` utility to calculate expected outputs before executing trades (for example, displaying expected amounts in the UI).

```typescript
import { Curve, PlatformConfig } from '@raydium-io/raydium-sdk-v2'

// Fetch required data
const poolInfo = await raydium.launchpad.getRpcPoolInfo({ poolId })
const platformData = await raydium.connection.getAccountInfo(poolInfo.platformId)
const platformInfo = PlatformConfig.decode(platformData!.data)
const mintInfo = await raydium.token.getTokenInfo(mintA)
const slot = await raydium.connection.getSlot()

// Calculate buy quote
const buyQuote = Curve.buyExactIn({
  poolInfo,
  amountB: new BN('1000000000'),  // 1 SOL
  protocolFeeRate: poolInfo.configInfo.tradeFeeRate,
  platformFeeRate: platformInfo.feeRate,
  curveType: poolInfo.configInfo.curveType,
  shareFeeRate: new BN(0),
  creatorFeeRate: platformInfo.creatorFeeRate,
  transferFeeConfigA: mintInfo.extensions.feeConfig,  // For Token-2022
  slot,
})

console.log('Tokens out:', buyQuote.amountA.amount.toString())
console.log('Fees:', {
  protocol: buyQuote.splitFee.protocolFee.toString(),
  platform: buyQuote.splitFee.platformFee.toString(),
  creator: buyQuote.splitFee.creatorFee.toString(),
  share: buyQuote.splitFee.shareFee.toString(),
})

// Calculate sell quote
const sellQuote = Curve.sellExactIn({
  poolInfo,
  amountA: new BN('500000000000'),  // Tokens to sell
  protocolFeeRate: poolInfo.configInfo.tradeFeeRate,
  platformFeeRate: platformInfo.feeRate,
  curveType: poolInfo.configInfo.curveType,
  shareFeeRate: new BN(0),
  creatorFeeRate: platformInfo.creatorFeeRate,
  transferFeeConfigA: mintInfo.extensions.feeConfig,
  slot,
})

console.log('Quote tokens out:', sellQuote.amountB.toString())
```

### Available quote methods

| Method | Description |
| --- | --- |
| `Curve.buyExactIn()` | Calculate tokens received for a given quote token input |
| `Curve.buyExactOut()` | Calculate quote tokens needed for a specific token output |
| `Curve.sellExactIn()` | Calculate quote tokens received for a given token input |
| `Curve.sellExactOut()` | Calculate tokens needed to receive a specific quote token output |

## Referral fees

Integrators can earn referral fees by passing `shareFeeRate` and `shareFeeReceiver` parameters.

```typescript
const { execute } = await raydium.launchpad.buyToken({
  // ... other params ...

  // Referral configuration
  shareFeeRate: new BN(5000),  // 0.5% referral fee
  shareFeeReceiver: new PublicKey('referrer-wallet'),
})
```

> **Note:** `shareFeeRate` cannot exceed `maxShareFeeRate` from the global config. Referral fees are paid in the quote token (for example, SOL) and transferred directly to the `shareFeeReceiver` wallet.

## Checking pool status

Before trading, verify the pool is still in trading status:

```typescript
const poolInfo = await raydium.launchpad.getRpcPoolInfo({ poolId })

if (poolInfo.status === 0) {
  console.log('Pool is active - trading enabled')
} else if (poolInfo.status === 1) {
  console.log('Pool is migrating - trading disabled')
} else if (poolInfo.status === 2) {
  console.log('Pool has migrated - trade on Raydium AMM instead')
}

// Check progress toward migration
const progress = poolInfo.realB.mul(new BN(100)).div(poolInfo.totalFundRaisingB)
console.log(`Fundraising progress: ${progress.toString()}%`)
```
