---
description: "CPMM fees include pool creation rent costs and a fixed protocol fee."
---

# CPMM fees

This section provides an overview of Solana rent costs associated with creating a CPMM pool and the Raydium protocol fee.

## Pool creation

Creates a new liquidity pool for a token pair. Unlike CLMM, CPMM pools require initial liquidity at creation. You cannot create an empty pool.

**Total cost: ~0.19 SOL** (non-refundable)

### Rent costs: 0.04215672 SOL

| Account           | Cost (SOL)     | Refundable |
| ----------------- | -------------- | ---------- |
| Pool state        | 0.0053244      | No         |
| Observation state | 0.02925288     | No         |
| LP mint           | 0.0014616      | No         |
| Token vault 0     | 0.00203928     | No         |
| Token vault 1     | 0.00203928     | No         |
| LP token account  | 0.00203928     | Yes        |
| **Total**         | **0.04215672** | -          |

### Protocol fee: 0.15 SOL

A fixed fee paid to Raydium to support protocol infrastructure and prevent pool spam.

Protocol fees are collected at: `DNXgeM9EiiaAbaWvwjHj9fQQLAX5ZsfHyvmYUNRAdNC8`

Pools cannot be closed once created.


## LP token account

Each liquidity provider needs an LP token account to hold LP tokens.

| Cost       | 0.00203928 SOL   |
| ---------- | ---------------- |
| Created    | On first deposit |
| Refundable | Yes, when account is closed |

You can close your LP token account after withdrawing all liquidity to reclaim the rent. Accounts with any remaining LP token balance cannot be closed.
