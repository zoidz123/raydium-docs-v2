# CPMM

The Raydium SDK provides tools for creating and interacting with CPMM (Constant Product Market Maker) pools. Create pools, manage liquidity, lock LP tokens, and execute swaps, all with a few lines of code.

{% hint style="info" %}
CPMM pools use the classic x\*y=k constant product formula. For concentrated liquidity with custom price ranges, see the CLMM guide.
{% endhint %}

#### Installation

```bash
yarn add @raydium-io/raydium-sdk-v2
```

#### Resources

| Resource            | Link                                                                                               |
| ------------------- | -------------------------------------------------------------------------------------------------- |
| SDK source          | [raydium-sdk-V2/cpmm](https://github.com/raydium-io/raydium-sdk-V2/tree/master/src/raydium/cpmm)   |
| Demo implementation | [raydium-sdk-V2-demo/cpmm](https://github.com/raydium-io/raydium-sdk-V2-demo/tree/master/src/cpmm) |
| CPI integration     | [raydium-cpi](https://github.com/raydium-io/raydium-cpi)                                           |

#### Program addresses

| Network | Address                                        |
| ------- | ---------------------------------------------- |
| Mainnet | `CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C` |
| Devnet  | `DRaycpLY18LhpbydsBWbVJtxpNv9oXPgjRSfpF2bWpYb` |

#### Related programs

| Program              | Mainnet                                       | Devnet                                         |
| -------------------- | --------------------------------------------- | ---------------------------------------------- |
| Burn & Earn (Locker) | `LockrWmn6K5twhz3y9w1dQERbmgSaRkfnTeTKbpofwE` | `DRay25Usp3YJAi7beckgpGUC7mGJ2cR1AVPxhYfwVCUX` |
