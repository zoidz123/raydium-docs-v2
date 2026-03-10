---
description: "Get a routed swap quote for an exact input amount."
---

# Get swap quote

## Endpoint

- **Method:** `GET`
- **Path:** `/compute/swap-base-in`
- **Group:** Trade API

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `inputMint` | query | Yes | `string` | Token mint address to swap from. |
| `outputMint` | query | Yes | `string` | Token mint address to swap to. |
| `amount` | query | Yes | `string` | Amount in base units, such as token decimals or lamports for SOL. |
| `slippageBps` | query | Yes | `number` | Slippage tolerance in basis points. For example, 50 = 0.5%. |
| `txVersion` | query | Yes | `string` | Transaction version. |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful quote response. |
