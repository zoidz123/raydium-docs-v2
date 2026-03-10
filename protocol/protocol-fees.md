# Protocol fees

Fees collected by the Raydium protocol.

Raydium collects trading fees across its AMM products and pool creation fees for select pool types.

## Trading fees

Every swap on Raydium incurs a trading fee, split between liquidity providers, RAY buybacks, and the treasury.

| Pool type | LP share | Buyback | Treasury |
| --- | --- | --- | --- |
| CLMM | 84% | 12% | 4% |
| CPMM | 84% | 12% | 4% |
| Standard AMM v4 | 88% | 12% | - |

## Pool creation fees

Creating a Standard AMM v4 or CPMM pool costs `0.15 SOL`.

For destination addresses, see [Treasury](/protocol/treasury).

## Notes

- pool-specific fee tiers still vary by pool configuration
- this page covers protocol-level fee splits, not trader-facing swap fee settings on individual pools
