# Liquidity FAQ

Common questions about liquidity, LP tokens, CLMM positions, farms, and common liquidity errors.

## General

### What is APR and where does yield come from?

APR displayed on Raydium is an extrapolation of pool and farm yield based on daily, weekly, or monthly performance. Past performance does not guarantee future results.

Yield comes from:

* **Maker fees** - Fees paid by swaps through the pool.
* **Farm emissions** - Additional token rewards for pools with active farms.

For `CLMM` pools, Raydium displays three APR estimation methods. See the estimated APR documentation for more detail.

### Can I withdraw my liquidity at any time?

Yes.

For constant product pools, you need to unstake LP tokens first if they are deposited into a farm.

For `CLMM` pools, you can withdraw directly from your position.

### Why did my transaction fail?

Common causes include:

* **Insufficient SOL** - Keep at least `0.05 SOL` in your wallet for network fees.
* **Slippage tolerance** - The transaction fails if price moves past your slippage tolerance.
* **Pending approval** - Check your wallet for a transaction approval prompt.

## Constant product pools

### What is the benefit of providing liquidity?

Liquidity providers earn a share of trading fees from every swap in the pool.

When you add liquidity, you receive LP tokens representing your share of the pool.

If a farm exists for your pool, you can stake LP tokens to earn additional token rewards.

### What are LP tokens?

LP tokens represent your proportional share of a liquidity pool. For example, contributing to a `SOL-RAY` pool gives you `SOL-RAY` LP tokens in your wallet.

### Are my staked LP tokens still earning fees?

Yes. Trading fees compound directly into the value of LP tokens, even while they are staked in a farm.

### Can I lock my LP tokens?

You can permanently lock liquidity using Burn & Earn.

Alternatively, you can manually burn LP tokens or the associated token account. Burned liquidity cannot be retrieved.

### How are pool vaults credited when new pools are created?

When a new pool is created, a small fraction of initial liquidity is credited to the asset vaults rather than minted as LP tokens. This ensures the pool is never empty.

```text
liquidity_init = liquidity - 10^(lp_decimals)
```

### I can't find my LP tokens

Check the **Standard** tab under **My Positions** on the portfolio page.

## Concentrated liquidity pools

### What is the benefit of providing liquidity on CLMM pools?

`CLMM` lets you concentrate liquidity within a custom price range. This can earn more fees with less capital than a constant product pool.

The tradeoff is that both yield and impermanent loss are amplified within your chosen range.

### Where are my LP tokens?

`CLMM` positions do not use LP tokens. Instead, you receive a position NFT representing your liquidity and price range.

Important:

* If the NFT is burned or lost, the associated liquidity cannot be retrieved.
* Position NFTs can be transferred or sold. The liquidity goes with them.
* When you close a position, the NFT mint rent is refunded.

### How do I earn farm emissions on CLMM pools?

No additional action is required. If an active farm exists on the pool, rewards are distributed automatically alongside trading fees.

### How do I check remaining farm emissions?

On the farm page, hover over the token symbol under pending rewards to see the reward period.

Farm owners can extend rewards, but they cannot shorten them.

## Ecosystem farms

### What are ecosystem farms?

Ecosystem farms are permissionless incentive programs that let projects or users bootstrap liquidity by offering token rewards on a pool.

### Can I withdraw rewards after creating a farm?

No. Rewards allocated to farms are final and cannot be withdrawn once the farm is created.

### Can I extend or adjust my farm?

You can add rewards or extend the farming period starting `72` hours before the current period ends.

To reduce the rewards rate, wait until the current period is near completion, then create a new period with adjusted emissions.

## Errors

### I can't see my pool

Pools may take a few minutes to appear in the UI after creation.

If you created a pool with a delayed start time, enter the base and quote tokens on the swap page to see the countdown.

### Pool already exists error

A pool already exists for this token pair, and fee tier for `CLMM`. Use the existing pool instead of creating a new one.

### Token verify error or freeze authority enabled

Your token has freeze authority enabled. Disable it programmatically or use a tool such as [Squads](https://app.squads.so/).
