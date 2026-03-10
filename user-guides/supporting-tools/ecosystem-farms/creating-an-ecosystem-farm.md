# How to create an ecosystem farm

Create a permissionless farm on Raydium and configure rewards, emissions, and duration.

> **Info:** Read this entire guide before creating a farm.

## Before you start

### Key requirements

| Requirement | Details |
| ----------- | ------- |
| Pool ID     | Every farm must link to a liquidity pool. The same Pool ID can have multiple farms. |
| Liquidity   | Add sufficient initial liquidity before creating a farm. Low liquidity means high price volatility and more impermanent loss for LPs. |
| Rewards     | Rewards cannot be withdrawn once allocated. Plan carefully. |

### Calculate rewards and APR

APR depends on rewards, token price, and pool liquidity. Consider:

1. **Target TVL** - How much liquidity do you want? Compare with similar pools.
2. **Reward token price** - Price fluctuations directly affect APR. Estimate a range for the farming period.
3. **APR formula**

$$
APR = \frac{Daily Rewards Value}{Pool Liquidity} \times 365
$$

**Example:** `$500/day` rewards ÷ `$100,000` liquidity × `365` = `183% APR`

Changes to liquidity or reward token price affect APR throughout the farming period.

## Create the farm

### Step 1: Connect your wallet and select a pool

1. Navigate to **Liquidity**.
2. Click **Create**.
3. Select **Creating a Farm**.
4. Search for your target pool or paste the Pool ID directly.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FC8gMtDEztO44LVR5XmiM%2FScreen%20Recording%202024-05-15%20at%2018.40.13.gif?alt=media&token=9b265285-6bdd-410a-97e8-96c2f66bd1d8)

5. Verify the Pool ID and pool TVL before proceeding.

If no pool exists for your pair, create one first.

### Step 2: Set rewards and duration

| Parameter     | Requirements |
| ------------- | ------------ |
| Reward tokens | `1–5` tokens per farm |
| Duration      | `7–90` days |
| Start time    | Cannot be changed after creation |

Important:

* Rewards are final once allocated. They cannot be withdrawn.
* Rewards only emit when LP tokens are staked. Consider staking a small amount yourself so APR displays correctly at launch.
* New farms appear on the UI about five minutes after creation with an **Upcoming** tag.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FKXl6oWswyayQlzB6f6RW%2FScreenshot%202024-05-15%20at%2019.32.24.png?alt=media&token=cd15a006-bd95-4322-98c7-d0e2ab4763b8)

### Step 3: Review and confirm

1. Click **Review Farm**.
2. Verify rewards, duration, and start time.
3. Click **Create Farm**.

Your farm goes live in about five minutes. View it under **Show Created** on the Ecosystem Farms tab.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FzW1xdzlASSW6W7Rb47eF%2FScreenshot%202024-05-15%20at%2019.45.05.png?alt=media&token=aa7f856f-6fbd-448d-a6ed-fb53f0ed945b)

## Extend or adjust rewards

Manage existing farms from **Portfolio** → **My created farms** → **Edit Farm**

| Action | When | Details |
| ------ | ---- | ------- |
| **Extend rewards** | `72` hours before period ends | Adds rewards at the same emission rate and extends duration |
| **Change emission rate** | After the current period ends | Starts a new period with adjusted rewards |
| **Add reward token** | Any time | Supports up to five tokens total, each with a different period |

Rewards cannot be withdrawn once allocated.

## Summary

* Rewards are final and cannot be withdrawn.
* Start time cannot be changed after creation.
* Stake some LP tokens yourself to ensure APR displays at launch.
* Extend rewards starting `72` hours before the period ends.

Questions? Join [Discord](https://discord.gg/Raydium) for support.
