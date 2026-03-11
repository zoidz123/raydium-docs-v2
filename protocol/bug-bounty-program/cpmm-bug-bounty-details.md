---
description: "Program-specific scope, assets, and testnet references for Raydium's constant product market maker."
---

# CPMM bug bounty details

This page covers program-specific scope, assets, and testnet references for Raydium’s constant product market maker (CPMM), also referred to as CP-Swap.

Raydium’s full bug bounty program with Immunefi can be found at [immunefi.com/bounty/raydium](https://immunefi.com/bounty/raydium/).

## Testnet references

A public testnet deployment of Raydium’s CPMM can be found at:

`https://explorer.solana.com/address/CPMDWBwJDtYax9qW7AyRuVC19Cc4L4Vcy4n2BHAbHkCW?cluster=devnet`

A public testnet deployment of OpenBook’s central limit order book can be found at:

`EoTcMgcDRTJVZDMZWBoU6rhYHZfkNTVEAfz3uUJRcYGj`

> Public testnets are provided for reference only. Testing on mainnet or public testnets is prohibited under this program. All testing must be conducted on private test environments.

## Assets in scope

CPMM contracts maintained by Raydium are considered in scope for this bug bounty program.

- [raydium-io/raydium-cp-swap](https://github.com/raydium-io/raydium-cp-swap/tree/master)

If a critical impact can be caused to any other asset managed by Raydium that is not explicitly listed here, but the impact matches those defined in the impacts in scope section of the bug bounty program overview, researchers are encouraged to submit the issue for consideration.

## Disclosure

If you identify a vulnerability affecting CPMM, use the contact address listed on the official Raydium bug bounty page.

Include:

- A detailed description of the attack vector
- Clear reproduction steps
- A proof of concept for high- and critical-severity issues

The Raydium security team will respond within 24 hours with follow-up questions or next steps.
