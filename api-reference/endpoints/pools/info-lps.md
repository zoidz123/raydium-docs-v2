---
description: "Get pool info by LP mint."
---

# Pool Info by LP Mint

## Endpoint

- **Method:** `GET`
- **Path:** `/pools/info/lps`
- **Group:** Pools

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `lps` | query | Yes | `string` | lp.join(',') |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful response. |
