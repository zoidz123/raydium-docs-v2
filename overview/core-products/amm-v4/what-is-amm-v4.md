---
description: "Learn what AMM v4 is, how it differs from CPMM, and when the legacy Raydium AMM still matters."
---

# What is AMM v4

AMMv4 is Raydium's original constant-product automated market maker and the **most widely deployed Raydium contract on Solana**. Often referred to as the **hybrid AMM**, it historically shared idle liquidity with a central limit order book, first Serum and later OpenBook, to improve capital efficiency.

Today, all AMMv4 pools operate purely as **traditional constant-product AMMs**, providing full-range liquidity and fungible LP tokens.

## What makes it different

`AMM v4` is the legacy constant product program in the Raydium ecosystem. For new deployments, `CPMM` is generally the modern default because it adds Anchor compatibility, Token-2022 support, multiple fee configurations, and creator fee support.

`AMM v4` still matters for historical ecosystem coverage, existing pool deployments, and integrations that need compatibility with Raydium's older pool model.

## Best for

- Legacy ecosystem compatibility
- Existing `AMM v4` markets
- Teams working with Raydium's historical pool footprint
