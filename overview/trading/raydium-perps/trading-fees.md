# Trading fees

Review maker, taker, and withdrawal fees for Raydium Perps.

## Trading fees

* **Maker (limit orders): 0 bps**
* **Taker (market orders): volume-tiered (see below)**
* **Orderly infrastructure:** included in the taker fee, and **Orderly takes a 1 bps cut** from taker volume.

## Withdrawals

* **1 USDC flat fee per withdrawal** (charged by Orderly Network)

## Taker fee tiers

Fee tier is based on trailing 30-day volume.

| Tier | 30 D Volume | Taker (bps) |
| ---- | ----------- | ----------- |
| 1    |             | 4.5         |
| 2    | ≥$500k      | 4.0         |
| 3    | >$2M        | 3.5         |
| 4    | >$5M        | 3.0         |
| 5    | >$25M       | 2.5         |
| 6    | >$50M       | 2.25        |
| 7    | >$80M       | 2.0         |
