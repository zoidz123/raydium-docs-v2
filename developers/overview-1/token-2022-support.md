---
description: "Understand Token-2022 support on Raydium CLMM and CPMM pools."
---

# Token-2022 support

[Token-2022](https://spl.solana.com/token-2022) is Solana's extended token standard, [enabling features like transfer fees, metadata, and programmable restrictions](https://spl.solana.com/token-2022/extensions). Raydium's CLMM and CPMM pools support Token-2022 assets.

## Using Token-2022 on Raydium

Token-2022 is treated as an advanced feature:

- Enter the mint address manually to find the token (no search by name/ticker)
- Token logos and names may not display unless manually added
- You'll be prompted to acknowledge risks before interacting
- Once confirmed, swaps can route through Token-2022 pools

Users who haven't confirmed a Token-2022 token will only route through standard SPL pools.

## Transfer fee extension

Some Token-2022 tokens have a **transfer fee** — a percentage taken on every transfer, set by the token creator.

| What to know | Details |
| --- | --- |
| When it applies | Swaps, adding/removing liquidity, any token transfer |
| Who controls it | The token creator (not Raydium) |
| Is it fixed? | No — issuers can change the fee at any time without warning |

Raydium displays transfer fees in the UI when possible, but cannot guarantee accuracy if the issuer updates them.

## Unsupported extensions

The following Token-2022 extensions **cannot** be used to create permissionless CLMM pools:

| Extension | Why it's blocked |
| --- | --- |
| **Permanent delegate** | Allows unlimited burn/transfer authority over any holder's tokens |
| **Non-transferable** | "Soulbound" tokens that can't be moved — incompatible with trading |
| **Default account state** | Forces all new token accounts to be frozen by default |
| **Confidential transfers** | ZK-encrypted balances are incompatible with AMM price discovery |
| **Transfer hook** | Custom transfer logic could interfere with pool operations |

## Integration guidance

- test the exact extension set your token uses in a full wallet flow
- treat issuer-controlled transfer fees as mutable risk
- verify routing, add liquidity, and remove liquidity separately
