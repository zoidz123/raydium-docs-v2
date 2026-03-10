---
description: "See which collateral assets are supported on Raydium Perps and how deposit limits work."
---

# Multi-collateral deposit

Raydium Perps supports multiple collateral assets for margin, while profit and loss remains settled in USDC.

> **Warning:** These parameters are subject to changes, please refer to [orderly documentation](https://orderly.network/docs/introduction/trade-on-orderly/multi-collateral) to confirm the latest limits.

## Supported collateral

### Global limits

These limits apply **across the entire protocol**, shared by all users.

| Collateral | Chain    | Max collateral (global) |
| ---------- | -------- | ----------------------- |
| USDT       | Arbitrum | 2,000,000               |
| ETH        | Arbitrum | 1,000                   |
| ETH        | Base     | 500                     |
| BNB        | BSC      | 10,000                  |
| USDT       | BSC      | 4,000,000               |
| USD1       | BSC      | 1,000,000               |
| YUSD       | BSC      | 500,000                 |
| ETH        | Ethereum | 500                     |
| USDT       | Ethereum | 3,000,000               |
| USD1       | Ethereum | 1,000,000               |
| YUSD       | Ethereum | 500,000                 |
| WBTC       | Ethereum | 80                      |
| SOL        | SOL      | 40,000                  |

### Per-user limits

These limits apply **per individual account / wallet**.

| Collateral | Max collateral |
| ---------- | -------------- |
| USDT       | 500,000        |
| ETH        | 100            |
| SOL        | 2,000          |
| BNB        | 500            |
| YUSD       | 50,000         |
| WBTC       | 5              |
| USD1       | 500,000        |
