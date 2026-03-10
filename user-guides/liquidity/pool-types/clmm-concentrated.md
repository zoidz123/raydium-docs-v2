# CLMM

## Overview

Concentrated liquidity allows liquidity providers (LPs) to allocate capital within a **specific price range** rather than across the entire curve. This can significantly increase capital efficiency, but it also introduces **active management requirements** and additional risk.

Impermanent loss can be significant in CLMM pools. A positive return is not guaranteed. Make sure you understand the risks before providing concentrated liquidity.


## Creating pools

Only **one pool can exist per token pair per fee tier**.

Creating a pool sets initial price. Opening a position opens your **first liquidity position**.

### Costs

[Pool creation costs](/user-guides/liquidity/pool-fees) approximately **0.06 SOL**, plus **position costs** that vary based on the selected price range.


## Fee tiers and tick spacing

Lower fee tiers generally suit **stable or pegged assets**, where tighter spreads attract more volume. Higher fee tiers compensate LPs for the added risk of **volatile or exotic pairs**.

Each fee tier has a corresponding **tick spacing**:

* Lower fee tiers use smaller tick spacing for more granular price points
* Higher fee tiers use larger tick spacing with coarser price points

## Fee split

Liquidity providers earn **84%** of trading fees. The remaining **16%** is allocated to:

* **12%** to RAY buybacks
* **4%** to treasury


## Positions

Each CLMM position is represented by an **NFT minted to your wallet**. This NFT controls ownership of:

* the liquidity in the position
* any uncollected fees and rewards

### Position NFT behavior

If a position NFT is **lost, sold, or burned**, the liquidity it represents is also lost.

### Multiple positions

There is no limit on the number of positions per wallet. You can open multiple positions in the same pool with overlapping or different ranges. Each position is independent.


## Out-of-range positions

When the pool price moves outside your position’s configured range:

* you stop earning fees and farm rewards
* your position becomes **100% one-sided** (entirely token A or entirely token B)
* the position remains open (there is no auto-close mechanism)
* earnings resume automatically if the price returns to your range


## Fees

Trading fees accrue to your position, but they are **not auto-compounded**. They accumulate inside the position until you trigger a collection event.

#### Collecting fees

Fees are accounted for whenever you modify liquidity, but they are only **transferred to your wallet** when you:

* remove any amount of liquidity from the position, or
* call `decrease_liquidity` with **0 liquidity** (claim fees only)

There is no separate “claim fees” instruction. Fee collection is handled through `decrease_liquidity`.

Increasing liquidity updates fee accounting but does **not** transfer fees to you.


## Rewards

[Farming rewards](/user-guides/supporting-tools/ecosystem-farms) (if enabled) behave similarly to fees.

### Earning requirements

* your position must be **in-range** to earn rewards
* rewards are proportional to your liquidity within the active range
* out-of-range positions earn nothing until the price returns in-range

### Collecting rewards

Rewards are collected automatically when you modify your position’s liquidity (including a `decrease_liquidity` of 0).


## Key concepts

* **Price range**: the minimum and maximum prices where your liquidity is active. Tighter ranges can earn more when in-range, but go out-of-range more easily.
* **Quote token convention**: the quote token represents how many quote tokens are needed to purchase 1 base token. Common quote tokens include SOL and USDC.
* **Starting price**: set during pool creation and defines the initial exchange rate (quote per base).


## Summary

CLMM improves capital efficiency by letting LPs concentrate liquidity in a chosen price range. In return, LPs take on more complexity and risk, including the possibility of going out-of-range and becoming one-sided.

Fees and rewards accrue to positions over time, but they are only transferred to your wallet when you reduce liquidity (including a 0-liquidity decrease to claim).

| Feature         | Behavior                                        |
| --------------- | ----------------------------------------------- |
| Fee accrual     | Manual claim (collected with liquidity changes) |
| Position NFT    | Transferable; new owner controls position       |
| Tick spacing    | Tied to fee tier                                |
| Out-of-range    | Stop earning, no auto-close                     |
| Position limits | None; overlapping ranges allowed                |
