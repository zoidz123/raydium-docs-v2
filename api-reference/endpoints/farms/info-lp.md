---
description: "Search farms by LP mint."
---

# Search Farm by LP Mint

## Endpoint

- **Method:** `GET`
- **Path:** `/farms/info/lp`
- **Group:** Farms

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `lp` | query | Yes | `string` | Stake LP mint address. |
| `pageSize` | query | Yes | `number` | Page size. Maximum 100. |
| `page` | query | Yes | `number` | Page index. |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful response. |
