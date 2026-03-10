# How to create a token

Create and launch a token on LaunchLab in minutes.

Creating a token on LaunchLab is straightforward. There are two modes:

* **JustSendit** - Simple and streamlined with standard bonding-curve settings.
* **LaunchLab** - Full customization of token and curve parameters.

## JustSendit mode

1. Navigate to LaunchLab on Raydium and click **Launch token**.
2. Enter a **Name** and **Ticker**. Description is optional.
3. Add an **image or GIF** with a minimum size of `128 × 128` and a maximum file size of `5 MB`.
4. Optionally add social links under **Socials & more**.
5. Click **Sign-in to Create token** to confirm your wallet.
6. Click **Create Token**.
7. Optionally make an initial buy. This can help discourage snipers.
8. Confirm the launch.

Your token is now live on the bonding curve. It graduates to a Raydium AMM pool when the curve reaches `85 SOL`.

## LaunchLab mode

1. Toggle to **LaunchLab** at the top of the create token page.
2. Complete the name, ticker, and image fields.
3. Click **Next Step** to open advanced options:
   * **Total supply** and **SOL raise target** with a minimum of `30 SOL`. Lower targets migrate faster but with less liquidity.
   * **% of supply on curve** between `51–80%`. The remaining supply migrates to the AMM pool at graduation.
   * **Vesting** to optionally lock and vest a portion of supply with a custom cliff and duration. Confirm the destination wallet after launch from your token creation page.
   * **Post-migration fee share** to earn `10%` of LP trading fees after graduation. Enabling this migrates your token to a `CPMM` pool instead of `AMM v4`. You receive a **Fee Key NFT** to claim fees from the portfolio page.
4. Complete the launch flow and confirm.

Your token graduates when the bonding curve reaches your configured SOL target.

## Tip

Click **Share** on the token page to [earn referral fees](/user-guides/launchlab/earn-referral-fees) from trades made through your link.
