---
description: >-
  LaunchLab is Raydium's token launch product built around bonding curves and
  pool migration.
---

# LaunchLab

LaunchLab is Raydium's community-powered token launch platform for traders looking for new tokens and creators who want a simple but powerful way to run customizable launches. It combines bonding-curve price discovery with Raydium's AMM infrastructure, so tokens can launch on a curve and then migrate into open Raydium liquidity.

## Overview

LaunchLab connects token creation, early trading, and post-launch liquidity into one product. It is designed for creators, traders, and third-party platforms that want launch infrastructure on top of Raydium.

Key properties include:

* Permissionless token launches
* No-code launch flows through `JustSendit` mode or more advanced LaunchLab configuration
* Bonding-curve trading before graduation
* Automatic migration into Raydium liquidity after the curve target is hit
* Post-migration liquidity that is locked or burned for long-term integrity
* A community pool where 50% of trading fees go back to the community
* Creator incentives through post-migration fee participation

## Why it exists

LaunchLab gives token launches a familiar lifecycle:

1. Price discovery starts on a bonding curve.
2. Trading demand pushes the curve toward its graduation target.
3. Liquidity migrates into a Raydium AMM pool, where the token continues trading in a standard market structure.

This makes LaunchLab useful both for quick community launches and for more configurable launch flows that need stronger post-launch market structure.

## Best for

* Token creators launching new assets
* Users discovering early-stage launches
* Platforms building launch experiences on Raydium infrastructure

## How it works

1. **Launch** - Create a token with a bonding curve. Buyers purchase on the curve, and price increases as supply is bought.
2. **Graduate** - When the bonding curve reaches its target, liquidity auto-migrates into a Raydium pool.
3. **Trade** - The token continues trading in the Raydium pool after graduation.

For `JustSendit` mode, the default graduation target is **85 SOL**. Once that target is reached, the SOL on the curve and its equivalent token liquidity are migrated into a Raydium AMM pool. The LP tokens are burned, and trading continues in the migrated pool.

## Migration options

After graduation, liquidity migrates into one of Raydium's constant product pool types:

| Pool type | Comment                                                                                                                         |
| --------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `CPMM`    | The standard choice for most launches. It offers simple, passive, full-range liquidity and supports creator fee configurations. |
| `AMM v4`  | The legacy pool interface.                                                                                                      |

## Two modes

* **JustSendit** - Launch quickly with default settings
* **Custom** - Configure curve type, vesting, fee sharing, and other launch parameters

## Who it is for

### Traders

* Access early-stage tokens directly from a bonding curve
* Participate in transparent, onchain launches without gatekeepers
* Earn a share of community pool fees

### Creators

* Launch a token in minutes with no coding
* Choose between `JustSendit` and more customizable LaunchLab flows
* Bootstrap liquidity through the bonding curve and graduate into a Raydium AMM pool once the target is reached
* Earn a share of trading fees after migration, depending on launch settings

### Third-party platforms

* Launch tokens under your own brand and platform
* Access Raydium distribution and LaunchLab discoverability
* Set your own fee structure and build revenue on top of LaunchLab
* Reach Raydium's trader base without building liquidity infrastructure from scratch

## Platform PDA

LaunchLab's **Platform PDA** system allows third-party builders to create their own launch platforms on top of LaunchLab infrastructure.

It enables:

* Custom branding and frontend experiences
* Platform-defined fee structures
* Full Raydium ecosystem discoverability and routing for launched tokens
* Launch infrastructure without rebuilding the migration and liquidity stack

## Integration

LaunchLab is fully permissionless. Teams can build their own frontend, integrate LaunchLab into an existing platform, or create custom launch experiences.

Resources:

* [Developer guides](https://app.gitbook.com/s/xrjzQmqrY8etCBSeqeii/index)
* [Program addresses](../../../developers/resources/program-addresses/)
