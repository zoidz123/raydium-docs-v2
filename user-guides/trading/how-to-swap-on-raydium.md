---
description: "Understand how swaps work on Raydium, including pool types, fees, slippage, and common issues."
---

# How to swap on Raydium

Raydium swaps execute against onchain liquidity pools. This guide explains how the flow works and what to watch before you confirm a trade.

## How swaps work

Raydium swaps use liquidity pools rather than order books. Each pool holds reserves of two tokens and uses a mathematical formula to determine prices.

When you swap, you deposit one token into the pool and withdraw another. The pool's algorithm calculates how much you receive based on the current reserves and your trade size.

## Constant product formula

Most Raydium pools follow the constant product model: `x × y = k`

* `x` and `y` are the reserves of each token.
* `k` is a constant that must remain unchanged after each trade.

This formula creates a continuous price curve. The pool always has liquidity available at any price, with the execution rate adjusting dynamically based on your trade size relative to pool depth. Smaller trades execute closer to the spot price, while larger trades have more price impact.

## Pool types

**CPMM (constant product)** - Standard pools using the `x × y = k` formula. Supports Token-2022 and multiple fee tiers. Default for new pools and LaunchLab migrations.

**CLMM (concentrated liquidity)** - Liquidity providers choose specific price ranges, improving capital efficiency for stable pairs or actively managed positions.

**AMM v4** - Legacy constant product pools. Originally integrated with OpenBook's order book for hybrid liquidity and now functions as a traditional AMM.

## Concentrated liquidity

Standard constant product pools spread liquidity across all prices from zero to infinity. That means most capital sits idle at prices far from the current market.

Concentrated liquidity lets liquidity providers allocate capital to specific price ranges. Instead of covering every possible price, LPs choose a lower and upper bound where their liquidity is active.

### How it affects swaps

When you swap through a CLMM pool, you trade against liquidity concentrated around the current price. This typically results in better rates and lower price impact than standard pools, assuming sufficient liquidity exists in the active range.

If a large swap moves the price outside the concentrated range, liquidity runs out at that tick and the next price range takes over. Very large swaps may cross multiple price ranges, each with different liquidity depth.

### Trade-offs

* Better capital efficiency means deeper liquidity at active prices.
* Price impact is generally lower for typical trade sizes.
* Liquidity can become thin if price moves outside popular ranges.
* CLMM works especially well for stable pairs such as `USDC/USDT`, where price tends to stay in a tight band.

## Fees

Swap fees range from `0.01%` to `4%` depending on the pool.

* `84%` goes to liquidity providers.
* `16%` goes to protocol fees, including RAY buybacks and treasury.

A small amount of SOL, typically `0.0001–0.001 SOL`, is also required for Solana network fees.

## Price impact

Price impact is how much your trade moves the pool price. It depends on your trade size relative to pool liquidity. Larger trades in smaller pools create higher price impact.

For example, swapping `$100` in a `$10M` pool has minimal impact. Swapping `$100,000` in a `$500,000` pool shifts the price much more aggressively.

Always check price impact before confirming, especially for large trades or low-liquidity tokens.

## Slippage

Slippage is the difference between the quoted price and the execution price. It happens because prices can change between the time you submit a transaction and the time it confirms onchain.

Set a slippage tolerance to define the maximum acceptable difference. If price moves beyond your tolerance, the transaction fails rather than executing at a worse rate.

* **Too low** - Transactions may fail frequently in volatile markets.
* **Too high** - You increase the risk of front-running or sandwich attacks extracting value from your trade.

## Troubleshooting

### Transaction timeout

The transaction did not reach the chain in time. Increase priority fees to improve confirmation speed.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FlfwyFu8bUH94v6QPtGgR%2Fimage.png?alt=media&token=2d324c0c-2253-4bbd-a199-42741f47b8e0)

### Slippage exceeded

Price moved beyond your tolerance. Either increase slippage or wait for less volatile conditions.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FbLSlh6oAzut7Ai6gKpYC%2FScreenshot%202026-01-09%20at%204.07.07%E2%80%AFPM.png?alt=media&token=fc5805b6-7a9e-4785-9d3c-c6c4aea054eb)

### Insufficient SOL

Keep at least `0.05 SOL` in your wallet for network fees.
