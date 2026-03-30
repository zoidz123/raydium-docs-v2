---
icon: flask-round-potion
---

# CLMM

The Raydium SDK provides tools for creating and interacting with CLMM (Concentrated Liquidity Market Maker) pools. Create pools, open positions with custom price ranges, manage liquidity, execute swaps, and collect fees — all with a few lines of code.

{% hint style="info" %}
CLMM pools allow liquidity providers to concentrate their liquidity within specific price ranges, improving capital efficiency compared to constant-product pools. For standard x\*y=k pools, see the CPMM guide.
{% endhint %}

#### Installation

```bash
yarn add @raydium-io/raydium-sdk-v2
```

#### Resources

| Resource            | Link                                                                                               |
| ------------------- | -------------------------------------------------------------------------------------------------- |
| SDK source          | [raydium-sdk-V2/clmm](https://github.com/raydium-io/raydium-sdk-V2/tree/master/src/raydium/clmm)   |
| Demo implementation | [raydium-sdk-V2-demo/clmm](https://github.com/raydium-io/raydium-sdk-V2-demo/tree/master/src/clmm) |
| CPI integration     | [raydium-cpi](https://github.com/raydium-io/raydium-cpi)                                           |

#### Program addresses

| Network | Address                                        |
| ------- | ---------------------------------------------- |
| Mainnet | `CAMMCzo5YL8w4VFF8KVHrK22GGUsp5VTaW7grrKgrWqK` |
| Devnet  | `DRayAUgENGQBKVaX8owNhgzkEDyoHTGVEGHVJT1E9pfH` |

#### Related programs

| Program              | Mainnet                                       | Devnet                                         |
| -------------------- | --------------------------------------------- | ---------------------------------------------- |
| Burn & Earn (Locker) | `LockrWmn6K5twhz3y9w1dQERbmgSaRkfnTeTKbpofwE` | `DRay25Usp3YJAi7beckgpGUC7mGJ2cR1AVPxhYfwVCUX` |
| Lock auth            | `kN1kEznaF5Xbd8LYuqtEFcxzWSBk5Fv6ygX6SqEGJVy` | `6Aoh8h2Lw2m5UGxYR8AdAL87jTWYeKoxM52mJRzfYwN`  |
