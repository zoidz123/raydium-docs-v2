---
description: "Get the V2 paginated pool list."
---

# Pool Info List V2

## Endpoint

- **Method:** `GET`
- **Path:** `/pools/info/list-v2`
- **Group:** Pools

## Parameters

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `poolType` | query | No | `string` | Type of pool. Can be `Concentrated` or `Standard`. Optional — if not set, all types are returned. |
| `mintFilter` | query | No | `string` | Whether to filter by mint. Optional. please refer /main/mint-filter-config |
| `hasReward` | query | No | `boolean` | Whether to return only pools that have rewards. Optional. |
| `sortField` | query | No | `string` | Field to sort by. Optional. |
| `sortType` | query | No | `string` | Sorting order, either ascending (`asc`) or descending (`desc`). Optional. |
| `size` | query | Yes | `integer` | Number of records to return per page. |
| `nextPageId` | query | No | `string` | The `id` returned from the previous page, used for pagination. Optional — if not provided, the first page is returned. |
| `mint1` | query | No | `string` | Filter for pools that include this mint. Optional. |
| `mint2` | query | No | `string` | Filter for pools that include this mint. Optional. |

## Responses

| Code | Description |
| --- | --- |
| `200` | Successful response. |
