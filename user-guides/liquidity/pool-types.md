# Overview

### Overview

Raydium offers two liquidity pool types, each suited for different use cases. All pools are powered by [audited](/protocol/protocol-security), [open-source](https://github.com/Raydium-io) smart contracts and can be created via the UI, [SDK](https://github.com/Raydium-io/Raydium-sdk-V2-demo/tree/master/src), or [CPI](https://github.com/Raydium-io/Raydium-cpi-example).


## Concentrated liquidity (CLMM)

LPs choose a specific price range to provide liquidity. More capital efficient since depth concentrates around the current price, but requires active management.

**Best for:** Stable pairs, pegged assets, or advanced LPs who want precise control over their position.

### Features

* Custom price ranges (asymmetric liquidity)
* Fee tiers from 1bps to 400bps
* Token-2022 support
* Anchor compatible
* Integrates with automated managers like Kamino and Krystal

**Note:** Full-range positions are possible but cost more due to tick array initialization fees.

### How price ranges work

LPs earn fees in proportion to their share of liquidity at the current price. If the price moves outside your selected range, your position stops earning fees and may experience significant impermanent loss.

When price moves:

* **Below your min price:** Your position becomes 100% base token
* **Above your max price:** Your position becomes 100% quote token (you've effectively sold all base token)

This is similar to standard AMM behavior but accelerated within your chosen range. Active monitoring is critical—CLMMs offer higher capital efficiency but magnify impermanent loss compared to full-range positions.


## Constant product

Classic `x * y = k` pools. Liquidity spreads across all prices automatically—no range management needed.

**Best for:** New token launches, volatile assets, or LPs who prefer set-and-forget positions.

Raydium has two constant product programs:

<table><thead><tr><th width="213.359375">Program</th><th>Description</th></tr></thead><tbody><tr><td>CPMM</td><td>Current standard. Anchor compatible, Token-2022 support, multiple fee configs. Supports Creator fees.</td></tr><tr><td>AMM v4</td><td>Legacy program (most deployed contract on Solana). Originally shared liquidity with Serum/OpenBook order books, now functions as standard AMM.</td></tr></tbody></table>

## Understanding impermanent loss

When you provide liquidity to a pool, you're essentially becoming a market maker. You earn trading fees, but there's a tradeoff: if the price of your tokens changes significantly, you may end up with less value than if you had simply held the tokens.

This is called **impermanent loss**.

#### How it works

Imagine you deposit $1,000 worth of SOL and $1,000 worth of USDC into a pool (total: $2,000).

If SOL's price doubles:

* The pool automatically rebalances—traders buy your SOL and sell you USDC
* You now have less SOL and more USDC
* Your position might be worth $2,830 instead of $3,000 (if you had just held)
* You "lost" $170 compared to holding

That $170 difference is impermanent loss.

#### Why "impermanent"?

The loss only becomes real when you withdraw. If SOL's price returns to your entry price before you withdraw, the loss disappears. That's why it's called impermanent—it's unrealized until you exit.

#### The tradeoff

You're betting that trading fees earned will outweigh any impermanent loss. High-volume pools with lots of trading activity can generate enough fees to make up for it. Low-volume pools or large price swings may not.

**For CLMM positions:** Impermanent loss is magnified within your selected price range. Tighter ranges mean higher fee earnings but also higher risk if price moves outside your range.


## Which should I use?

#### Use constant product if

* Your token is launching (price discovery hasn't happened)
* You expect high volatility
* You want full-range, passive exposure

#### Use concentrated liquidity if

* Your token already trades elsewhere and you want tighter depth
* You want to deposit asymmetric amounts of base/quote
* You want integration with automated liquidity managers

#### Either works if

* You're using Burn & Earn
* Your token has Token-2022 extensions
* You want to customize the fee tier
