---
description: "Route swaps through Raydium pools using quotes, serialized transactions, and optional priority fee helpers."
---

# How to use Trade API

The Trade API lets you get quotes and execute swaps through Raydium's routing engine. For a complete end-to-end implementation, see the [SDK demo](https://github.com/raydium-io/raydium-sdk-V2-demo).

## Flow overview

Use the Trade API in two steps:

1. Get a quote from the routing engine.
2. Build a transaction from that quote, then sign and send it.

## Get quote

`GET https://transaction-v1.raydium.io/compute/swap-base-in`

Returns a quote for swapping tokens with an exact input amount.

### Query parameters

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `inputMint` | `string` | Yes | Token mint address to swap from |
| `outputMint` | `string` | Yes | Token mint address to swap to |
| `amount` | `string` | Yes | Amount in base units, such as token decimals or lamports for SOL |
| `slippageBps` | `number` | Yes | Slippage tolerance in basis points, for example `50 = 0.5%` |
| `txVersion` | `string` | Yes | Transaction version: `v0` or `legacy` |

### Example response

```json
{
  "id": "cbbcc7e2-a5fa-4040-a260-b229842c93c7",
  "success": true,
  "version": "V1",
  "data": {
    "swapType": "BaseIn",
    "inputMint": "So11111111111111111111111111111111111111112",
    "inputAmount": "100000000",
    "outputMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
    "outputAmount": "13738391",
    "otherAmountThreshold": "13669699",
    "slippageBps": 50,
    "priceImpactPct": 0,
    "referrerAmount": "0",
    "routePlan": [
      {
        "poolId": "3nMFwZXwY1s1M5s8vYAHqd4wGs4iSxXE4LRoUMMYqEgF",
        "inputMint": "So11111111111111111111111111111111111111112",
        "outputMint": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "feeMint": "So11111111111111111111111111111111111111112",
        "feeRate": 1,
        "feeAmount": "10000",
        "remainingAccounts": [
          "DDe2TojkajtXKYJEMKfjY3Xjdw1XhZqr8UEBNgrg512P",
          "AWeEpV2ASCkVmcpK7htwWCqztmKMNdsmquKMa7y96Wif",
          "22ps6VsrEnCwEfGX4nkFV2xz4ohpvF5aTVtSg5FcwGRn"
        ],
        "lastPoolPriceX64": "6841151606851928973"
      },
      {
        "poolId": "3NeUgARDmFgnKtkJLqUcEUNCfknFCcGsFfMJCtx6bAgx",
        "inputMint": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "outputMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
        "feeMint": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "feeRate": 1,
        "feeAmount": "1376",
        "remainingAccounts": [
          "CxPCSxEmvkTyd6tqpVcZv2QscGrzkZKBmH7R9Bs9wocT",
          "9iD8oCrLQFNd1sbhYZg2awLrsZu4f1AAZG6bHuJkLXEx",
          "32D4WyeYS7irtnGpVS2VYja5H8uUpc8zF24kd15oFD2o"
        ],
        "lastPoolPriceX64": "18455174383562030500"
      }
    ]
  }
}
```

### Quote endpoints

| Path | Description |
| --- | --- |
| `/compute/swap-base-in` | Specify the exact input amount |
| `/compute/swap-base-out` | Specify the exact output amount |

## Build the transaction

`POST https://transaction-v1.raydium.io/transaction/swap-base-in`

Builds one or more serialized transactions from a quote response.

### Request body

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `swapResponse` | `object` | Yes | Response returned by the quote endpoint |
| `wallet` | `string` | Yes | User wallet public key |
| `txVersion` | `string` | Yes | Transaction version: `V0` or `LEGACY` |
| `wrapSol` | `boolean` | No | Wrap SOL to wSOL for the input leg |
| `unwrapSol` | `boolean` | No | Unwrap wSOL to SOL for the output leg |
| `inputAccount` | `string` | No | Input token account, omit if the input is SOL |
| `outputAccount` | `string` | No | Output token account, omit if the output is SOL |
| `computeUnitPriceMicroLamports` | `string` | No | Priority fee in micro-lamports |

### Example response

```json
{
  "id": "bca0c725-0037-48ce-8d0a-db39a0f6e020-tx",
  "version": "V1",
  "success": true,
  "data": [
    {
      "transaction": "AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAQADEUxrOZd2...[truncated]"
    }
  ]
}
```

## Optional priority fee helper

`GET https://api-v3.raydium.io/main/auto-fee`

Use this helper if you want a suggested compute unit price instead of setting the priority fee manually.

## Full example

### Install

```bash
yarn add @raydium-io/raydium-sdk-v2
```

### Setup

```typescript
import { Transaction, VersionedTransaction } from '@solana/web3.js'
import { NATIVE_MINT } from '@solana/spl-token'
import axios from 'axios'
import { connection, owner, fetchTokenAccountData } from '../config'
import { API_URLS } from '@raydium-io/raydium-sdk-v2'

// config.ts
export const owner: Keypair = Keypair.fromSecretKey(bs58.decode('<YOUR_WALLET_SECRET_KEY>'))
export const connection = new Connection('<YOUR_RPC_URL>')
```

> Do not use your main wallet private key for testing.

### Get quote

```typescript
const { data: swapResponse } = await axios.get<SwapCompute>(
  `${API_URLS.SWAP_HOST}/compute/swap-base-in?inputMint=${inputMint}&outputMint=${outputMint}&amount=${amount}&slippageBps=${slippage * 100}&txVersion=${txVersion}`
)
```

### Serialize

```typescript
const { data: swapTransactions } = await axios.post(
  `${API_URLS.SWAP_HOST}/transaction/swap-base-in`,
  {
    computeUnitPriceMicroLamports: String(priorityFee),
    swapResponse,
    txVersion,
    wallet: owner.publicKey.toBase58(),
    wrapSol: isInputSol,
    unwrapSol: isOutputSol,
    inputAccount: isInputSol ? undefined : inputTokenAcc?.toBase58(),
    outputAccount: isOutputSol ? undefined : outputTokenAcc?.toBase58(),
  }
)
```

### Deserialize and send

```typescript
const allTxBuf = swapTransactions.data.map((tx) => Buffer.from(tx.transaction, 'base64'))
const allTransactions = allTxBuf.map((txBuf) =>
  isV0Tx ? VersionedTransaction.deserialize(txBuf) : Transaction.from(txBuf)
)

for (const tx of allTransactions) {
  const transaction = tx as VersionedTransaction
  transaction.sign([owner])
  const txId = await connection.sendTransaction(transaction, { skipPreflight: true })

  const { lastValidBlockHeight, blockhash } = await connection.getLatestBlockhash({
    commitment: 'finalized',
  })

  await connection.confirmTransaction(
    { blockhash, lastValidBlockHeight, signature: txId },
    'confirmed'
  )
}
```

## Need help?

Ask in [#dev-chat](https://discord.com/channels/813741812598439958/1009085496279977994) on Discord.
