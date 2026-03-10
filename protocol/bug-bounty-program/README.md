# Overview

Rewards, scope, and disclosure rules for Raydium's bug bounty program.

Find and report bugs to Raydium to earn rewards.

> Raydium’s official bug bounty program is hosted on [Immunefi](https://immunefi.com/bounty/raydium/).
>
> Raydium maintains a public bug bounty program covering select open-source smart contracts. The program is focused on preventing theft, loss, or freezing of funds.
>
> UI-only issues are not eligible for rewards. All vulnerability disclosures must be submitted through the official Immunefi program or via the disclosure channels listed below.

## Rewards

Rewards are determined based on impact severity using the [Immunefi vulnerability severity classification system v2.2](https://immunefi.com/immunefi-vulnerability-severity-classification-system-v2-3/).

| Smart contracts | Reward |
| --- | --- |
| Critical | USD 50,000 to USD 505,000 |
| High | USD 40,000 |
| Medium | USD 5,000 |

- All reports must include a proof of concept (PoC) demonstrating exploitability.
- Code is required. Explanations or statements alone are not accepted.
- Critical and high severity reports must also include a suggested fix.

Critical smart contract vulnerabilities are capped at 10% of economic damage, primarily considering funds at risk, as well as PR and branding impact at the team’s discretion. A minimum payout of USD 50,000 applies to all critical vulnerabilities.

Payouts are handled directly by Raydium and are denominated in USD. Payouts may be facilitated in RAY, SOL, or USDC.

## Impacts in scope

Only the following impacts are considered in scope. All other impacts are out of scope, even if they affect assets listed elsewhere.

### Critical

- Direct theft of user funds, whether at rest or in motion, excluding unclaimed yield
- Permanent freezing of user funds
- Vulnerabilities that enable draining or theft of funds without user transaction approval

### High

- Theft of unclaimed yield
- Permanent freezing of unclaimed yield
- Temporary freezing of user funds
- Vulnerabilities that intentionally or unintentionally alter the value of user funds

### Medium

- Smart contracts unable to operate due to lack of token funds
- Block stuffing for profit
- Griefing attacks with no direct profit motive but user or protocol harm
- Theft of gas
- Unbounded gas consumption

## Out of scope and rules

The following vulnerabilities are not eligible for rewards.

- Attacks already exploited by the reporter
- Attacks requiring access to leaked private keys or credentials
- Attacks requiring access to privileged addresses such as governance or strategist addresses

Smart contracts and blockchain:

- Incorrect data supplied by third-party oracles
- Basic economic governance attacks such as 51% attacks
- Lack of liquidity
- Best-practice critiques
- Sybil attacks
- Centralization risks

The oracle exclusion does not exclude oracle manipulation or flash-loan attacks.

## Prohibited activities

The following actions are strictly prohibited.

- Testing against mainnet or public testnet contracts
- Testing involving pricing oracles or third-party smart contracts
- Phishing or social engineering attacks
- Testing third-party systems or applications such as browser extensions or SSO providers
- Denial-of-service attacks
- Automated testing that generates excessive traffic
- Public disclosure of unpatched vulnerabilities under embargo

> Public testnets are provided for reference only. All testing must be performed on private test environments.

## Disclosure and contact

For vulnerabilities not submitted via Immunefi, email the address listed on the official Raydium bug bounty pages.

Include:

- A detailed description of the attack vector
- A proof of concept for high and critical severity issues

The team will respond within 24 hours with next steps or follow-up questions.

- [CLMM bug bounty details](/protocol/bug-bounty-program/clmm-bug-bounty-details): Scope and references for the CLMM program.
- [AMM v4 bug bounty details](/protocol/bug-bounty-program/amm-v4-bug-bounty-details): Scope and references for the hybrid AMM program.
- [CPMM bug bounty details](/protocol/bug-bounty-program/cpmm-bug-bounty-details): Scope and references for the CP-Swap program.
