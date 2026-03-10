# CPMM

## Overview

CPMM pools use the classic **x × y = k** formula popularized by early automated market makers. Liquidity is provided across the **entire price range**, meaning liquidity providers (LPs) do not need to actively manage price bounds.

When you provide liquidity, you receive **fungible LP tokens** that represent your proportional ownership of the pool. These LP tokens can be transferred, locked, or used in other protocols.

CPMM pools prioritize simplicity and predictability, making them well suited for long-tail assets, retail liquidity providers, and integrations that prefer minimal configuration.


## Key characteristics

* Full-range liquidity with no price ranges to manage
* Fungible LP tokens representing pool ownership
* Simple user experience compared to concentrated liquidity
* Compatible with both SPL Token and Token-2022 standards


#### Creating a CPMM pool

Creating a CPMM pool initializes a new trading pair and deposits the first liquidity.

### What happens on pool creation

* Tokens are automatically ordered by their mint address
* Initial liquidity is deposited for both tokens
* A small amount of LP tokens is permanently locked to prevent zero-liquidity attacks
* A one-time [pool creation fee](/user-guides/liquidity/pool-fees) is paid in SOL

### Important notes

* The ratio of the initial deposit defines the **starting price**
* Pool creation fees and trading fee tiers are defined by a shared configuration
* Swaps only become active once the configured open time is reached


## Adding liquidity

Adding liquidity means depositing tokens into an existing pool in proportion to its current reserves.

### How deposits work

* You provide one token amount
* The protocol calculates how much of the other token is required
* LP tokens are minted based on your share of the pool
* Slippage protection ensures you do not overpay

### What you receive

* Fungible LP tokens representing your ownership share
* Automatic exposure to trading fees earned by the pool


## Removing liquidity

Removing liquidity burns your LP tokens and returns the underlying assets.

### How withdrawals work

* LP tokens are burned permanently
* You receive both tokens in proportion to your ownership
* Fees earned by the pool are automatically included
* Slippage protection ensures minimum outputs

Fees are embedded directly into the value of LP tokens.


## When to use CPMM pools

CPMM pools are ideal when you want:

* Simple liquidity provisioning
* Minimal configuration and maintenance
* Automatic fee compounding
* Fungible LP positions
* Broad liquidity coverage across all prices

They are often used as the default AMM model for long-tail tokens, community pools, and integrations prioritizing usability over capital efficiency.
