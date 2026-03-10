---
description: "Get a paginated list of pools."
---

# Pool Info List

## Endpoint

- **Method:** `GET`
- **Path:** `/pools/info/list`
- **Group:** Pools

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `poolType` | query | Yes | `string` | pool type |
| `poolSortField` | query | Yes | `string` | pool field |
| `sortType` | query | Yes | `string` | sort type |
| `pageSize` | query | Yes | `number` | page size, max 1000 |
| `page` | query | Yes | `number` | Page index. |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful response. |
