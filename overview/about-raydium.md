---
description: "Learn what Raydium is, what you can do on the platform, and how its core products fit together."
---

# About Raydium

## What is Raydium?

Raydium is a decentralized exchange and liquidity infrastructure layer on Solana. It powers the vast majority of onchain trading and token launches across the Solana ecosystem, providing the financial primitives that users, liquidity providers, token creators, and third-party applications build on.

Since launching in 2021, Raydium has processed billions in trading volume and serves as core infrastructure for wallets, aggregators, and applications across Solana.

## How it works

Raydium combines multiple AMM architectures: constant product, concentrated liquidity, and constant product with concentrated mechanics, with permissionless pool creation and token launch infrastructure. Every swap, liquidity provision, and token launch happens fully onchain with Solana-speed finality.

Anyone can create pools, launch tokens with bonding curve mechanics, and add liquidity incentives without permission or approval. This open infrastructure model is what makes Raydium a base layer rather than just an application.

## What you can do

**Trade** - Swap any token pair on Solana or trade perpetual futures with leverage.

**Earn** - Provide liquidity to pools and earn trading fees and token rewards.

**Launch** - Create a token with a bonding curve through LaunchLab or deploy a pool for any asset.

## Who it is for

- [Traders](/overview/trading): Swap tokens, route across liquidity, and trade perpetuals from self-custodial interfaces.
- [Liquidity providers](../user-guides/overview-2/README.md): Find liquidity-specific guidance and common LP questions.
- [Token creators](/overview/core-products/launchlab): Launch tokens, bootstrap liquidity, and move into open market trading with LaunchLab.

## Trading

- [Raydium Swap](/overview/trading/raydium-swap): Raydium's spot trading UI for swapping tokens with routing across available liquidity.
- [Raydium Perps](/overview/trading/raydium-perps): Raydium's perpetual futures UI, built on Orderly, for leveraged trading from a self-custodial workflow.

## Pool types

- [CLMM](/overview/core-products/clmm): Concentrated liquidity. LPs choose a price range to concentrate capital for higher efficiency and more active control.
- [CPMM](/overview/core-products/cpmm): Raydium's current constant product pool design. It is the default for new pool creation and LaunchLab migrations.
- [AMM v4](/overview/core-products/amm-v4): Raydium's legacy constant product AMM. It is battle-tested, widely deployed, and now operates as a traditional AMM.

## LaunchLab

- [LaunchLab](/overview/core-products/launchlab): Raydium's token launch platform for creating tokens on bonding curves and migrating into Raydium liquidity.

## Other tools

* **Permissionless farms** - Add token incentives to eligible pools
* **Burn and Earn** - Lock liquidity permanently while preserving access to fee flow
* **Routing engine** - Route across Raydium pools through the app, API, or SDK

## Where to go next

- [I want to trade](../user-guides/overview-1/raydium-swap.md): Start with Raydium Swap or explore perpetual futures on Raydium Perps.
- [I want to provide liquidity](../user-guides/overview-2/README.md): Start with the liquidity section and branch into the right LP guide for your workflow.
- [I want to launch](../user-guides/overview-5/creating-a-token.md): Create a token, configure a launch, or set up a new liquidity pool.
- [I want to build](../developers/overview.md): Explore Raydium SDK resources, program addresses, and developer integration docs.
