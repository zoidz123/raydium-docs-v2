# Trading basics

Learn what perpetual futures are, how leverage works, and what risks to understand before trading.

## What are perpetual futures (perps)?

**Perpetual futures (“perps”)** are leveraged contracts that let you trade on an asset’s price—**without owning the asset itself**. Unlike traditional futures, **perps don’t expire**, so you can keep a position open as long as you maintain enough margin.

### Why trade perps instead of spot?

#### **1) Trade up or down**

With spot, you generally profit only if the price goes up. With perps, you can:

* **Go long** if you think price will rise
* **Go short** if you think price will fall

Example: If you believe BTC will drop, you can open a **short** on BTC-PERP and potentially benefit if the price declines.

#### **2) Use leverage to get more exposure with less upfront capital**

Leverage lets you control a larger position with a smaller amount of collateral.

Example: If BTC is 90,000 USDC, buying 1 BTC on spot costs 90,000 USDC. With **10× leverage** on BTC-PERP, you can open a similar-sized position with about **9,000 USDC** in collateral (plus fees and depending on margin requirements).

### Raydium Perpetual Futures

#### **Multi-asset collateral, USDC-settled P&L**

Raydium Perps supports depositing **USDC, native SOL, and USDT** as collateral.

**Profit and loss (P\&L) is still calculated and settled in USDC**, meaning your P\&L is denominated in USDC even if your collateral is in SOL or USDT.

#### **Cross-margin only**

Raydium Perps uses **cross-margin**, so your collateral is shared across all open positions and contributes to a single account-wide margin ratio.

If you want separate margin “accounts,” you’ll need to use a **different wallet**.

#### **Leverage options**

Raydium Perps supports leverage **up to 100×**, depending on the market.

**One-way mode (one position per market)**

Raydium Perp uses **one-way mode**:

* you can’t hold both a long and a short on the same market at the same time
* placing an opposite-side order will reduce or flip your position

### Risks of trading with leverage

Leverage can magnify both gains and losses. Before trading perps, make sure you’re comfortable with these risks:

#### **Losses can exceed your initial margin on a position**

A small move against you can lead to a large loss relative to your collateral—especially at higher leverage.

#### **Liquidation risk**

If your margin ratio falls below required levels, your position may be **liquidated** to help prevent further losses. Liquidations can happen quickly in fast markets, even with small price moves at high leverage.

#### **Volatility and slippage**

Crypto markets can move rapidly. In volatile conditions, orders may fill at worse prices than expected (**slippage**), which can increase losses and raise liquidation risk.
