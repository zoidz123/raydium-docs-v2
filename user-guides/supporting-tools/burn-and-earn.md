# How to use Burn and Earn

Lock supported LP positions permanently while keeping the right to claim trading fees through a Raydium Fee Key NFT.

Burn & Earn lets you lock supported LP positions while keeping the right to claim trading fees through a Raydium Fee Key NFT.

Burn & Earn supports **CPMM** and **CLMM** pools. `AMM v4` is not supported.

> **Warning:** For CLMM pools, only full-range positions are recommended. Once locked, you cannot rebalance. If price moves out of range, you stop earning fees permanently.

## How it works

Technically, LP tokens and position NFTs are **locked**, not burned. The liquidity remains in the pool permanently, but you retain the right to claim fees through the Raydium Fee Key NFT.

## Lock a position

1. Create a `CPMM` pool or a `CLMM` full-range position.
2. Navigate to **Liquidity**.
3. Click **Create**.
4. Select **Burn & Earn**.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FFa2armQrlqGDdSud7NeI%2FBurn.gif?alt=media&token=a1ea6930-839a-4c9b-b569-0429d8b54baa)

5. Select the position you want to lock.
6. Verify the NFT address, position size, and pool details, then type the confirmation sentence.
7. Click **Confirm, lock the liquidity permanently**.

Double-check the position details before confirming. Once locked, liquidity cannot be retrieved.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FuWnW0yQJlJvLmBHrQGHV%2FCapture%20d%E2%80%99e%CC%81cran%202024-09-04%20a%CC%80%2014.00.13.png?alt=media&token=3b946dd3-2b33-4aa5-a0ab-e2563d3f0eee)

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2Fa38LiAcy9EeNobQDEXGt%2FCapture%20d%E2%80%99e%CC%81cran%202024-09-04%20a%CC%80%2014.07.31.png?alt=media&token=dfec1cf6-ffc6-40ce-9cab-b05474274202)

You receive a **Raydium Fee Key** NFT that represents your claim to trading fees from the locked position.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2F2oSRZUmsxMpB69Tm7z7b%2Funnamed.png?alt=media&token=3f7a03f1-38fc-4e19-bc5a-3bd1964ef951)

*Raydium Fee Key*

## Claim fees

Locked positions appear on your [Portfolio page](https://Raydium.io/portfolio/) alongside standard positions. Claim accumulated fees the same way you would for any position.

The Fee Key NFT is transferable. If you transfer or sell it, the new owner receives the right to claim fees.

![](https://4071094211-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-MT-qzD26DX_h6l_vXaA-887967055%2Fuploads%2FHOUyEoysaFJ16dl3Bavx%2FCapture%20d%E2%80%99e%CC%81cran%202024-09-04%20a%CC%80%2014.12.53.png?alt=media&token=27583f53-e033-4551-9450-4fac6fde46c8)

## View locked liquidity

The liquidity page displays the percentage of locked liquidity for each pool.

## API access

```text
https://API-v3.Raydium.io/pools/info/list?poolType=standard&poolSortField=default&sortType=desc&pageSize=1&page=1
```

The response includes:

```json
"burnPercent": 99.17
```

> **Warning:** Raydium APIs are public. Third-party platforms may index this data independently. Raydium is not responsible for how external platforms display locked-liquidity information.
