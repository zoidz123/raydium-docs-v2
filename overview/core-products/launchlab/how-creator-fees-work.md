---
description: "When enabled, creators will receive **10% of all LP fees** generated from the liquidity pool after their token graduates from the bonding curve."
---

# How creator fees work

* The Fee Key is only minted **after the token has graduated** and liquidity has been successfully migrated to the AMM pool.
* **Do NOT burn or transfer the Fee Key NFT** unless you're intentionally passing on the rights — if lost or burned, the ability to claim fees is permanently forfeited.

LaunchLab allows token creators (deployers) to earn a share of trading fees from their token's liquidity pool. This feature is **platform-configurable**—platforms building on LaunchLab (like Raydium or Bonk) can enable creator fees and set their own rates.

#### Pre-migration fees

During the bonding curve phase, creators can earn a portion of trading fees on each swap. These fees accumulate in a vault and can be claimed anytime from the Portfolio page.

Fee rates are set by the platform and paid in the quote token (e.g., SOL).

#### Post-migration fees

After graduation, creators can continue earning from LP trading fees. When enabled, this works through Raydium's [Burn & Earn](/user-guides/supporting-tools/how-to-use-burn-and-earn) program:

1. When the bonding curve goal is reached, liquidity migrates to a CPMM pool.
2. LP tokens are distributed according to the platform's configuration—a portion is burned, and the remainder is locked in Burn & Earn.
3. A **Fee Key NFT** is minted to the creator's wallet, representing the right to claim their share of LP trading fees.
4. Fees can be claimed anytime from the Portfolio page by the wallet holding the Fee Key.

**Raydium's LaunchLab defaults:** 90% of LP tokens are burned, 10% go to the creator. Other platforms integrating with LaunchLab can configure different splits between burned, creator, and platform shares.

If post-migration fee share is not enabled, tokens graduate to an AMMv4 pool instead of CPMM. Creators can also earn additional fees (based on the launch parameters `creatorFeeOn` and platformConfig), if this parameters is enabled creators can claim fees on top of the LP trading fees through a CLI interface. Resource available [here](/developers/launchlab/collecting-fees).

#### Important

* The Fee Key NFT is only minted after successful migration to the AMM pool.
* **Do not burn or transfer the Fee Key NFT** unless intentionally passing on the rights—if lost, fee claiming rights are permanently forfeited.
