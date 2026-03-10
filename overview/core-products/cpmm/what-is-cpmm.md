# What is CPMM

Learn how CPMM works on Raydium, how it differs from AMM v4, and when it is the right pool model.

## Overview

CPMM pools use the classic **x × y = k** formula popularized by early automated market makers. Liquidity is provided across the **entire price range**, meaning liquidity providers (LPs) do not need to actively manage price bounds.

When you provide liquidity, you receive **fungible LP tokens** that represent your proportional ownership of the pool. These LP tokens can be transferred, locked, or used in other protocols.

CPMM pools prioritize simplicity and predictability, making them well suited for long-tail assets, retail liquidity providers, and integrations that prefer minimal configuration.

---

## Best for

CPMM is best for:

* New token launches
* Volatile assets
* LPs who prefer passive, full-range exposure

---

## Key characteristics

* Full-range liquidity with no price ranges to manage
* Fungible LP tokens representing pool ownership
* Simple user experience compared to concentrated liquidity
* Compatible with both SPL Token and Token-2022 standards

---

## CPMM vs AMM v4

Raydium has two constant product programs:

| Program | Description |
| ------- | ----------- |
| `CPMM` | Current standard. Anchor compatible, Token-2022 support, multiple fee configs, and creator fee support. |
| `AMM v4` | Legacy program and one of the most widely deployed Raydium contracts on Solana. It originally shared liquidity with Serum and later OpenBook order books, and now operates as a standard constant product AMM. |

If you are choosing between the two for a new deployment, `CPMM` is generally the modern default. `AMM v4` matters mainly for legacy compatibility and existing ecosystem coverage.

---

## Creating a CPMM pool

Creating a CPMM pool initializes a new trading pair and deposits the first liquidity.

**What happens on pool creation**

* Tokens are automatically ordered by their mint address
* Initial liquidity is deposited for both tokens
* A small amount of LP tokens is permanently locked to prevent zero-liquidity attacks

**Important notes**

* The ratio of the initial deposit defines the **starting price**
* Pool creation fees and trading fee tiers are defined by a shared configuration
* Swaps only become active once the configured open time is reached
* Pool creation and account costs are covered in [CPMM fees](/overview/core-products/cpmm/fees)

---

## Adding liquidity

Adding liquidity means depositing tokens into an existing pool in proportion to its current reserves.

**How deposits work**

* You provide one token amount
* The protocol calculates how much of the other token is required
* LP tokens are minted based on your share of the pool
* Slippage protection ensures you do not overpay

**What you receive**

* Fungible LP tokens representing your ownership share
* Automatic exposure to trading fees earned by the pool

---

## Removing liquidity

Removing liquidity burns your LP tokens and returns the underlying assets.

**How withdrawals work**

* LP tokens are burned permanently
* You receive both tokens in proportion to your ownership
* Fees earned by the pool are automatically included
* Slippage protection ensures minimum outputs

Fees are embedded directly into the value of LP tokens.

---

## When to use CPMM pools

CPMM pools are ideal when you want:

* Simple liquidity provisioning
* Minimal configuration and maintenance
* Automatic fee compounding
* Fungible LP positions
* Broad liquidity coverage across all prices

They are often used as the default AMM model for long-tail tokens, community pools, and integrations prioritizing usability over capital efficiency.
