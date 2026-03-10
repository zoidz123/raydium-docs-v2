# Order types

Understand the order types and execution flags available on Raydium Perps.

## Order types

Raydium Perps supports five order types:

**Market** Buys or sells immediately at the best available prices in the order book. A market order will match against existing orders until your size is filled. If there isn’t enough liquidity to fill the full amount, any unfilled portion is canceled.

**Limit** Buys or sells at a price you choose (your **limit price**) or better. A limit order will only fill if the market reaches your price.

**Stop orders (trigger orders)** A stop order stays inactive until the market hits your **trigger (stop) price**. Once triggered, it becomes a live order.

* **Stop Market**: When triggered, it becomes a **market order** and fills at the next available prices.
* **Stop Limit**: When triggered, it becomes a **limit order** at your specified limit price, and will only fill if the market reaches that price.

**Scale orders** A scale order splits one larger order into multiple smaller limit orders placed across a price range. This is useful for entering or exiting positions gradually.

## Order flags

**IOC (Immediate-or-Cancel)** Fills as much as possible right away at your limit price (or better). Any unfilled amount is canceled.

**FOK (Fill-or-Kill)** Either fills the entire order immediately at your limit price (or better), or it’s canceled with no partial fill.

**Post Only** Ensures your order adds liquidity (maker). If it would match immediately when placed, it’s canceled instead of taking liquidity.

**Reduce Only** Prevents an order from increasing your position. It can only reduce (or close) an existing position in that market. If you don’t have a position—or the order would increase it—the order won’t execute as an increase.
