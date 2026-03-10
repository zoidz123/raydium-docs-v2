# Trade FAQ

Common questions about swaps, perpetuals, slippage, fees, and trading on Raydium.

## Basics

### What is a swap?

A swap exchanges one token for another using Raydium's onchain smart contracts. No intermediary and no custody. You trade directly against liquidity pools.

Exchange rates are calculated by the pool formula based on available liquidity.

### Where does the liquidity come from?

Liquidity comes from Raydium pools. The routing engine automatically finds the best path across multiple pools to minimize slippage and improve execution.

### How do tokens get listed?

Raydium is fully permissionless. Anyone can create a pool and list a token. Always verify the contract address before swapping.

## Fees

### What are the swap fees?

Swap fees range from `0.01%` to `4%` depending on the pool type and configuration.

| Pool type | LPs | RAY buyback | Treasury |
| --------- | --- | ----------- | -------- |
| `AMM v4`  | 88% | 12%         | -        |
| `CPMM`    | 84% | 12%         | 4%       |
| `CLMM`    | 84% | 12%         | 4%       |

### What are network fees?

Solana charges fees to process transactions. Expect fees around `0.0001–0.001 SOL` per transaction.

| Fee type | Amount | Description |
| -------- | ------ | ----------- |
| Base fee | `0.000005 SOL` | Fixed cost per transaction. `50%` is burned and `50%` goes to the validator. |
| Priority fee | Variable | Optional fee to increase transaction priority in the queue. |

Raydium's UI shows recommended priority fee tiers based on recent network activity. You can adjust this in settings.

Higher fees do not guarantee inclusion, but they improve your odds during congestion.

## Price and slippage

### What is price impact?

Price impact is the difference between the market price and your execution price. It depends on your trade size relative to pool liquidity.

Bigger trades create more price impact.

If you see high price impact, try a smaller amount or use a deeper pool.

### What is slippage tolerance?

Slippage tolerance is the maximum difference between your expected price and execution price. If the price moves beyond your tolerance, the swap fails.

You can set it with the gear icon on the swap page.

* Too high means worse execution risk.
* Too low means more failed transactions.

## Perpetuals

Raydium Perps routes orders to Orderly. For deeper product-level detail, see the [Orderly documentation](https://orderly.network/docs/build-on-omnichain/building-on-omnichain).

### What is funding rate?

Funding fees are periodic payments exchanged between long and short positions. This helps keep the perpetual price close to the underlying spot price.

* **Positive funding rate** - Longs pay shorts.
* **Negative funding rate** - Shorts pay longs.

Funding is peer to peer. No fees are collected by the exchange.

**Settlement:** Every eight hours at `00:00`, `08:00`, and `16:00 UTC`.

Important notes:

* During extreme volatility, funding intervals may be shortened to `4h`, `2h`, or `1h`.
* Each market has its own funding rate caps and floors.
* If you hold positions across multiple funding periods, funding payments can materially affect your PnL.

For the full formula, see [Orderly's documentation](https://orderly.network/docs/introduction/trade-on-orderly/perpetual-futures/funding-rate).

### What is initial margin and maintenance margin?

**Initial Margin Ratio (IMR)** is the collateral required to open a position. It determines your maximum leverage.

**Maintenance Margin Ratio (MMR)** is the minimum margin required to keep a position open. If your account falls below this threshold, liquidation triggers.

| Market | Base IMR (max leverage) | Base MMR |
| ------ | ----------------------- | -------- |
| `BTC-PERP` | `1%` (`100x`) | `0.6%` |
| `ETH-PERP` | `1%` (`100x`) | `0.6%` |
| `SOL-PERP` | `1%` (`100x`) | `0.6%` |
| Most alts | `10%` (`10x`) | `5%` |

**Account Margin Ratio** = Total Collateral Value / Total Position Notional

A higher margin ratio means lower risk.

For details, see [Orderly's documentation](https://orderly.network/docs/introduction/trade-on-orderly/perpetual-futures/margin-leverage-and-pnl).

### What is liquidation?

Liquidation occurs when your Account Margin Ratio falls below the Maintenance Margin Ratio. The exchange closes your position to prevent further losses.

Example: You have `$1,000 USDC` and open a `$10,000 BTC` position with `10x` leverage.

* Account Margin Ratio = `10%`
* `BTC-PERP` MMR = `0.6%`
* If losses push your margin ratio below `0.6%`, liquidation triggers.

To reduce liquidation risk:

* monitor your Account Margin Ratio
* add collateral
* reduce position size
* set stop-loss orders

### What is PnL settlement?

PnL settlement moves your profit or loss from perpetual positions into your withdrawable balance.

* Your displayed balance already includes unsettled PnL.
* Settlement is required to withdraw profits.
* Settlement does not affect your margin ratio or open positions.

## Troubleshooting

### Why did my transaction fail?

| Issue | Solution |
| ----- | -------- |
| Insufficient SOL | Keep at least `0.05 SOL` for network fees. |
| Slippage exceeded | Increase slippage tolerance. |
| Timeout | Increase priority fee and retry. |

### What are versioned transactions?

Versioned transactions are a newer transaction format that enables more advanced swap routing. Most wallets support them by default.

If you use a Ledger and see errors, update your Solana app in Ledger Live and re-enable blind signing.

## Tokens

### What is wrapped SOL?

`wSOL` is SOL wrapped for use in smart contracts. It is redeemable `1:1` for SOL.

If a swap leaves you with `wSOL`, go to [Raydium.io/swap](https://Raydium.io/swap) and Raydium prompts you to unwrap it automatically.

### Are tokens on Raydium wrapped?

Some are. `wBTC` and `wETH` are commonly wrapped through Wormhole's Portal bridge. Other tokens may use different bridges.

Always verify the mint address. If you are unsure, ask in [Discord](https://discord.com/invite/6EvFwvCfpx) or [Telegram](https://t.me/Raydiumprotocol).

## Support

### Still have questions?

Join [Discord](https://discord.com/invite/6EvFwvCfpx) or [Telegram](https://t.me/Raydiumprotocol) for support.
