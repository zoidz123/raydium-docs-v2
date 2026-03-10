# Estimated APR for CLMM

## Overview

In a CLMM pool, fees are distributed proportionally to in-range liquidity at each tick. Calculating an accurate APR across all ticks and LPs is extremely complex—traditional constant product APR formulas don't apply.

**Projected returns for CLMMs should be considered estimates at best.**

Raydium displays three APR estimation methods:

1. **Overall pool estimated APR** — pool-wide average
2. **Delta method** — based on your position's share of liquidity
3. **Multiplier method** — based on historical price range overlap

---

### Overall pool estimated APR

Assumes trading fees and emissions are distributed across all liquidity in the pool, including out-of-range positions.

$$
APR = \sum(d\_{365}, h\_{24}, s\_{3600}, b\_{0.5}) \times \frac{(perBlockReward \times rewardPrice) + totalTradingFee}{totalLiquidityValue}
$$

---

### Delta method

Calculates estimated APR based on your position's implied change (delta) in pool liquidity, determined by your price range and size.

**Condition**

$$
i\_l \leq i\_c < i\_u
$$

Where:

| Variable | Description   |
| -------- | ------------- |
| $$i\_l$$ | lowerTickId   |
| $$i\_c$$ | currentTickId |
| $$i\_u$$ | upperTickId   |

**Token amounts in a position**

$$
\Delta Y = \Delta L \times (\sqrt{P} - \sqrt{P\_l})
$$

$$
\Delta X = \Delta L \times \left(\frac{1}{\sqrt{P}} - \frac{1}{\sqrt{P\_u}}\right)
$$

**Calculating ΔL**

For estimation of tokenA ($$\Delta X$$) and tokenB ($$\Delta Y$$) we need to know $$\Delta L$$:

$$
(\Delta Y \times pUSDY) + (\Delta X \times pUSDX) = targetAmount
$$

So we take:

$$
(\Delta L \times (\sqrt{P} - \sqrt{P\_l}) \times pUSDY) + (\Delta L \times \left(\frac{1}{\sqrt{P}} - \frac{1}{\sqrt{P\_u}}\right) \times pUSDX) = targetAmount
$$

Then:

$$
\Delta L = \frac{targetAmount}{(\sqrt{P} - \sqrt{P\_l}) \times pUSDY + \left(\frac{1}{\sqrt{P}} - \frac{1}{\sqrt{P\_u}}\right) \times pUSDX}
$$

After calculating for $$\Delta L$$, we can calculate $$\Delta X$$ and $$\Delta Y$$ using:

$$
\Delta Y = \Delta L \times (\sqrt{P} - \sqrt{P\_l})
$$

$$
\Delta X = \Delta L \times \left(\frac{1}{\sqrt{P}} - \frac{1}{\sqrt{P\_u}}\right)
$$

**Estimated daily fee**

$$
Fee = feeTier \times volume24H \times \frac{\Delta L}{L + \Delta L}
$$

Where:

| Variable      | Description                                                                      |
| ------------- | -------------------------------------------------------------------------------- |
| $$volume24H$$ | Average of 24h volume                                                            |
| $$L$$         | Total liquidity (cumulative of liquidityNet from all ticks that $$i \leq i\_c$$) |
| $$\Delta L$$  | Delta liquidity                                                                  |

**Liquidity amounts**

And can be calculated from:

$$
liquidityAmount0 = amount0 \times \frac{\sqrt{P\_u} \times \sqrt{P\_l}}{\sqrt{P\_u} - \sqrt{P\_l}}
$$

$$
liquidityAmount1 = \frac{amount1}{\sqrt{P\_u} - \sqrt{P\_l}}
$$

| Condition                                   | $$\Delta L$$                                            |
| ------------------------------------------- | ------------------------------------------------------- |
| If $$i\_c < i\_l$$                          | $$\Delta L = liquidityAmount0$$                         |
| If $$i\_c > i\_u$$                          | $$\Delta L = liquidityAmount1$$                         |
| If $$i\_c \geq i\_l$$ && $$i\_c \leq i\_u$$ | $$\Delta L = \min(liquidityAmount0, liquidityAmount1)$$ |

---

### Multiplier method

Calculates estimated APR based on how much your price range overlaps with historical trading activity.

**Assumptions**

* Historical price data is used to extrapolate future price data (not the best indicator of future performance, but provides a decent estimate)
* Price fluctuation within the historical range is assumed to be consistent across the time interval, resembling a periodic function with amplitude equal to the upper and lower price boundaries

**Variables**

| Variable       | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| $$u\_{lower}$$ | Lower bound of user's concentrated liquidity price range            |
| $$u\_{upper}$$ | Upper bound of user's concentrated liquidity price range            |
| $$h\_{lower}$$ | Lower bound of historical price range across a specific time period |
| $$h\_{upper}$$ | Upper bound of historical price range across a specific time period |

**Retroactive range intersection**

$$
r\_{lower} = \max(u\_{lower}, h\_{lower})
$$

$$
r\_{upper} = \min(u\_{upper}, h\_{upper})
$$

**Range definitions**

$$
userRange = u\_{upper} - u\_{lower}
$$

$$
histRange = h\_{upper} - h\_{lower}
$$

$$
retroRange = r\_{upper} - r\_{lower}
$$

Where $$retroRange$$ is the retroactive intersection between $$userRange$$ and $$histRange$$.

**Multiplier calculation**

Let $$m$$ = multiplier of rewards or fees that user will receive.

| Condition                  | Multiplier                                                                |
| -------------------------- | ------------------------------------------------------------------------- |
| $$retroRange \leq 0$$      | $$m = 0$$                                                                 |
| $$userRange = retroRange$$ | $$m = \frac{histRange}{retroRange}$$                                      |
| $$histRange = retroRange$$ | $$m = \frac{retroRange}{userRange}$$                                      |
| Otherwise                  | $$m = \frac{retroRange}{tradeRange} \times \frac{retroRange}{userRange}$$ |

---

### Important notes

* These are **estimates**, not guaranteed returns
* Actual returns depend on trading volume, price movements, and competition from other LPs
* Narrower ranges earn more fees when in range, but risk going out of range more often
* Out-of-range positions earn zero fees
