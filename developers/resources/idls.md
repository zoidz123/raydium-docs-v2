# IDLs

Reference Raydium IDL files and understand which programs expose public Anchor-compatible interfaces.

Raydium provides **IDL (Interface Definition Language)** files for most of its modern programs. These IDLs define program instructions, accounts, and data structures and can be used with tools such as **Anchor** or custom SDKs.

## Official repository

[github.com/raydium-io/raydium-idl](https://github.com/raydium-io/raydium-idl)

## Programs with Available IDLs

### CLMM (Concentrated Liquidity Market Maker)

Concentrated liquidity pools used by Raydium’s CLMM AMM.

Program source:
[github.com/raydium-io/raydium-clmm](https://github.com/raydium-io/raydium-clmm)

IDL:
[github.com/raydium-io/raydium-idl/tree/master/raydium_clmm](https://github.com/raydium-io/raydium-idl/tree/master/raydium_clmm)

Mainnet program address:

```text
CAMMCzo5YL8w4VFF8KVHrK22GGUsp5VTaW7grrKgrWqK
```

### CPMM (Constant Product Market Maker)

Constant product liquidity pools used by Raydium’s newer AMM implementation.

Program source:
[github.com/raydium-io/raydium-cp-swap](https://github.com/raydium-io/raydium-cp-swap)

IDL:
[github.com/raydium-io/raydium-idl/tree/master/raydium_cpmm](https://github.com/raydium-io/raydium-idl/tree/master/raydium_cpmm)

Mainnet program address:

```text
CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C
```

### LaunchLab

Raydium’s token launch and bonding curve infrastructure.

The LaunchLab program exposes an **IDL stored on-chain**, which can be fetched directly from the program account.

Mainnet program address:

```text
LanMV9sAd7wArD4vJFi2qDdfnVhFxYSUg6eADduJ3uj
```

Explorer link:

[solscan.io/account/LanMV9sAd7wArD4vJFi2qDdfnVhFxYSUg6eADduJ3uj](https://solscan.io/account/LanMV9sAd7wArD4vJFi2qDdfnVhFxYSUg6eADduJ3uj)

## Legacy Programs

### AMM v4 (Legacy Constant Product)

Raydium’s original AMM implementation integrated with the OpenBook order book.

This program **predates Anchor and did not ship with an official IDL**. Developers typically rely on the program source or reconstructed layouts when interacting with it.

Program source:
[github.com/raydium-io/raydium-amm](https://github.com/raydium-io/raydium-amm)

Mainnet program address:

```text
675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8
```

## Other Raydium Programs

The following Raydium programs exist but **do not currently have public Anchor IDLs**:

| Program | Mainnet Address |
| --- | --- |
| Stable Swap AMM | `5quBtoiQqxF9Jv6KYKctB59NT3gtJD2Y65kdnB1Uev3h` |
| Burn & Earn (LP Locker) | `LockrWmn6K5twhz3y9w1dQERbmgSaRkfnTeTKbpofwE` |
| AMM Routing | `routeUGWgWzqBWFcrCfv8tritsqukccJPu3q5GPP3xS` |
| Staking | `EhhTKczWMGQt46ynNeRX1WfeagwwJd7ufHvCDjRxjo5Q` |
| Farm Staking | `9KEPoZmtHUrBbhWN1v1KWLMkkvwY6WLtAVUCPRtRjP4z` |
| Ecosystem Farm | `FarmqiPv5eAj3j1GMdMCMUGXqPUvmquZtMy86QH6rzhG` |

These addresses correspond to the official Raydium program list.

## Summary

Programs with developer-friendly IDLs:

- CLMM
- CPMM
- LaunchLab (IDL available on-chain)

Legacy / non-Anchor programs:

- AMM v4
- Stable Swap
- Staking and farm infrastructure
