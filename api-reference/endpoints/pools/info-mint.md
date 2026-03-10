---
description: "Get pools by token mint."
---

# Pool Info by Token Mint

## Endpoint

- **Method:** `GET`
- **Path:** `/pools/info/mint`
- **Group:** Pools

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `mint1` | query | Yes | `string` | search mint |
| `mint2` | query | No | `string` | search mint |
| `poolType` | query | Yes | `string` | pool type |
| `poolSortField` | query | Yes | `string` | pool field |
| `sortType` | query | Yes | `string` | sort type |
| `pageSize` | query | Yes | `number` | page size, max 1000 |
| `page` | query | Yes | `number` | Page index. |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful response. |
