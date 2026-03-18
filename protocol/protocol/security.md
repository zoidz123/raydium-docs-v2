---
description: >-
  Audits, bug bounty details, access controls, and program addresses for
  Raydium.
---

# Security

Raydium's AMM and staking programs have been reviewed by engineers and security teams from across Solana.

## Audits

| Program                             | Auditor           | Date    | Report                                                                                                                                                                    |
| ----------------------------------- | ----------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Order-book AMM                      | Kudelski Security | Q2 2021 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/Kudelski%20Q2%202021/Raydium_Audit.pdf)                                                               |
| Concentrated liquidity (CLMM)       | OtterSec          | Q3 2022 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/OtterSec%20Q3%202022/Raydium%20concentrated%20liquidity%20\(CLMM\)%20program.pdf)                     |
| Updated order-book AMM              | OtterSec          | Q3 2022 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/OtterSec%20Q3%202022/Raydium%20updated%20order-book%20AMM%20program.pdf)                              |
| Staking                             | OtterSec          | Q3 2022 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/OtterSec%20Q3%202022/Raydium%20staking%20program.pdf)                                                 |
| Order-book AMM & OpenBook migration | MadShield         | Q2 2023 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/MadSheild%20Q2%202023/Raydium%20updated%20orderbook%20AMM%20program%20%26%20OpenBook%20migration.pdf) |
| Constant product AMM (CPMM)         | MadShield         | Q1 2024 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/MadShield%20Q1%202024/raydium-cp-swap-v-1.0.0.pdf)                                                    |
| Burn & Earn (liquidity locker)      | Halborn           | Q4 2024 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/Halborn%20Q4%202024/raydium_liquidity_locking.pdf)                                                    |
| LaunchLab                           | Halborn           | Q2 2025 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/Halborn%20Q2%202025/raydium_launch.pdf)                                                               |
| CPMM (update)                       | Sec3              | Q3 2025 | [View](https://github.com/raydium-io/raydium-docs/blob/master/audit/Sec3%20Q3%202025/raydium_cp_swap_pr55.pdf)                                                            |

Members of the [Neodyme](https://neodyme.io) team have also performed extensive reviews via bug bounty agreements.

## Bug bounty

Raydium runs an active bug bounty program in partnership with [Immunefi](https://immunefi.com/).

See the full program and detail pages on [Bug bounty program](/broken/pages/nlJzIxv9QVMn9sd4LKdJ).

## Access controls

Raydium's programs are owned by the BPF Upgradeable Loader, allowing an Upgrade Authority to push updates when necessary.

All program upgrade and admin authority is held under a [Squads multi-sig](https://v3.squads.so/developers/programs/RVhaWTdGUGNjTnVFdmdIWk1DTXB3dzJGZW44b0xXQlNKemRnQ3NYM0Rqd20%3D).

Programs are fully upgradeable and changes are reviewed by core team members before implementation. For larger updates, Raydium engages experienced security whitehats for review via bug bounties.

Raydium does not currently employ a timelock for upgrades. Timelock mechanisms are planned as code moves toward open-sourcing and community governance.

## Core programs

| Program                       | Address                                        |
| ----------------------------- | ---------------------------------------------- |
| LaunchLab                     | `LanMV9sAd7wArD4vJFi2qDdfnVhFxYSUg6eADduJ3uj`  |
| Concentrated liquidity (CLMM) | `CAMMCzo5YL8w4VFF8KVHrK22GGUsp5VTaW7grrKgrWqK` |
| CPMM                          | `CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C` |
| AMM v4                        | `675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8` |
| Staking                       | `EhhTKczWMGQt46ynNeRX1WfeagwwJd7ufHvCDjRxjo5Q` |
| Farm staking                  | `9KEPoZmtHUrBbhWN1v1KWLMkkvwY6WLtAVUCPRtRjP4z` |
| Ecosystem farms               | `FarmqiPv5eAj3j1GMdMCMUGXqPUvmquZtMy86QH6rzhG` |

## References

* [Treasury](treasury.md)
* [Bug bounty program](/broken/pages/nlJzIxv9QVMn9sd4LKdJ)
