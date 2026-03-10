---
description: "Build LaunchLab platform, launch, migration, and fee workflows with the Raydium SDK."
---

# Overview

Use this page to understand what the LaunchLab developer workflow covers before you jump into the implementation guides.

## What LaunchLab supports

LaunchLab lets you build branded launch platforms, deploy tokens onto bonding curves, monitor graduation into Raydium liquidity, and collect creator or platform fees after launch activity.

## Main workflows

### Platform setup

- [Creating a platform](/developers/launchlab/creating-a-platform): Register a launch platform and configure fee settings.

### Token lifecycle

- [Launching a token](/developers/launchlab/launching-a-token): Deploy a token and initialize the bonding curve flow.
- [Buying and selling a token](/developers/launchlab/buying-and-selling-a-token): Execute user-side trading flows against LaunchLab tokens.
- [Monitoring token migration](/developers/launchlab/monitoring-token-migration): Track when a token migrates into Raydium liquidity.

### Revenue and operations

- [Collecting fees](/developers/launchlab/collecting-fees): Claim creator and platform fee balances.

## Useful references

- [Raydium SDK launchpad source](https://github.com/raydium-io/raydium-sdk-V2/tree/master/src/raydium/launchpad)
- [Raydium SDK demo launchpad flows](https://github.com/raydium-io/raydium-sdk-V2-demo/tree/master/src/launchpad)
- [Raydium CPI launch example](https://github.com/raydium-io/raydium-cpi/tree/master/programs/launch-cpi)
