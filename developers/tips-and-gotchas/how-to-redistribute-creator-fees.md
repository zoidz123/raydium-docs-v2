# How to redistribute creator fees

By default, CPMM creator fees from LaunchLab pools are attributed to the original token deployer — the wallet that called `createLaunchpad`. Each token creator is set as the `pool_creator` on their CPMM pool and can collect fees directly.

Launchpad platforms can override this by redirecting **all** creator fees to a single platform-controlled wallet using `updatePlatformCpCreator`. The platform then redistributes fees to token creators (or handles them however it wants).

#### Why redirect creator fees?

* **Custom distribution logic** — redistribute a percentage to creators and keep the rest as platform revenue
* **Programmatic control** — use a PDA as the collecting wallet so an on-chain program can govern fee distribution
* **Unified accounting** — all creator fees flow through one wallet for simpler bookkeeping

#### How it works

1. The platform calls `updatePlatformCpCreator` with a wallet address (or PDA)
2. All CPMM pools created through LaunchLab migration **after** this update will have that wallet as `pool_creator`
3. The platform collects fees from all pools using `collectMultiCreatorFees`
4. The platform redistributes fees to original token creators (or applies any custom logic)

The original token creator for each pool can be resolved by deriving the LaunchLab pool PDA from the CPMM pool's mints and reading the `creator` field from the on-chain account data.

#### Setting the platform creator wallet

```typescript
const { execute } = await raydium.launchpad.updatePlatformConfig({
  programId,
  platformAdmin: owner,
  updateInfo: {
    type: 'updatePlatformCpCreator',
    value: new PublicKey('<PLATFORM_WALLET_OR_PDA>'),
  },
  txVersion: TxVersion.V0,
})

await execute({ sendAndConfirm: true })
```

Full example: [updatePlatform.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/launchpad/updatePlatform.ts)

#### Gotchas

**All-or-nothing.** Once `platformCpCreator` is set, **every** pool that migrates from your platform will use that wallet as `pool_creator`. You cannot redirect fees for some pools but not others on the same platform.

**Token creators lose direct access.** After this change, individual token creators can no longer call `collectCreatorFee` on their pools — only the `platformCpCreator` wallet can. Token creators depend on the platform to redistribute their share.

**Forward-looking only.** Changing `platformCpCreator` only affects pools that migrate **after** the update. Pools that already migrated keep their original `pool_creator` and are unaffected.

**Epoch rate limit.** Platform config updates are limited to once per Solana epoch (\~2–3 days). This applies to all `updatePlatformConfig` calls — if you update `platformCpCreator`, you cannot update any other platform config field until the next epoch.

**Creator fees must be enabled on the CPMM config.** The `AmmConfig` used by your platform (`cpConfigId`) must have a non-zero `creator_fee_rate`. If it's zero, there are no creator fees to collect regardless of the `platformCpCreator` setting. To request a custom fee config, contact the Raydium team.

#### Best practices

**Use a PDA as the collecting wallet.** Instead of using a regular keypair, derive a PDA from your platform's on-chain program. This lets you build programmatic fee distribution logic that doesn't depend on a single private key, and gives token creators verifiable guarantees about how fees are handled.

**Verify your setup on-chain.** After calling `updatePlatformCpCreator`, decode the `PlatformConfig` account and confirm `platformCpCreator` is set to the expected address. A zero address (`11111111111111111111111111111111`) means it hasn't been set.

#### Collecting fees

Once `platformCpCreator` is set, the platform wallet can use the Raydium API to find pools with pending creator fees, then batch-collect creator fees from all its pools using `collectMultiCreatorFees`:

```typescript
// Fetch pools with pending creator fees
const res = await axios.get(
  `https://api-v3.raydium.io/cp-creator-fee?wallet=${platformCpCreatorWallet}`
)

// Batch collect
const { execute, transactions } = await raydium.cpmm.collectMultiCreatorFees({
  poolInfoList: res.data.data.map((d) => d.poolInfo),
  programId: CREATE_CPMM_POOL_PROGRAM,
  txVersion: TxVersion.V0,
})

await execute({ sequentially: true })

```

Full example: [collectAllCreatorFee.ts](https://github.com/raydium-io/raydium-sdk-V2-demo/blob/master/src/cpmm/collectAllCreatorFee.ts)

Which tokens you receive depends on the `creatorFeeOn` mode set when the token was launched (see [How to configure CPMM creator fees](how-to-configure-cpmm-creator-fees.md)):

| Mode         | Fees collected in                                            |
| ------------ | ------------------------------------------------------------ |
| `BothToken`  | Both the base and quote token                                |
| `OnlyToken0` | Token 0 only                                                 |
| `OnlyToken1` | Token 1 only (LaunchLab default — typically the quote token) |

When pools use WSOL as the quote token, collected fees arrive as WSOL. Close the WSOL ATA to unwrap to native SOL if needed.

What the platform does with collected fees is entirely up to the developer.

#### Example: redistributing to original token creators

What the platform does with collected fees is entirely up to the developer. The full redistribution flow, if you choose to forward fees to original token creators, is:

**1. Resolve original creators from CPMM pool mints**

CPMM pools created via the LaunchLab migration have corresponding on-chain accounts that contains the `creator` field –– the wallet that originally called the `createLaunchpad` method.

```typescript
import {
  getPdaLaunchpadPoolId,
  LaunchpadPool,
  LAUNCHPAD_PROGRAM,
} from '@raydium-io/raydium-sdk-v2'

for (const pool of poolsWithFees) {
  const mintA = new PublicKey(pool.poolInfo.mintA.address)
  const mintB = new PublicKey(pool.poolInfo.mintB.address)

  // Try both mint orderings — only one will exist on-chain
  const pda1 = getPdaLaunchpadPoolId(LAUNCHPAD_PROGRAM, mintA, mintB).publicKey
  const pda2 = getPdaLaunchpadPoolId(LAUNCHPAD_PROGRAM, mintB, mintA).publicKey

  const accounts = await connection.getMultipleAccountsInfo([pda1, pda2])
  const match = accounts.find((a) => a !== null)

  if (match) {
    const decoded = LaunchpadPool.decode(match.data)
    const originalCreator = decoded.creator // PublicKey
  }
}
```

**2. Calculate each creator's share**

Apply your redistribution percentage to the collected fee amounts. Fee amounts come from the API response (`fee.amountA` / `fee.amountB`) — check both since the fee token depends on the pool's `creatorFeeOn` mode.

**3. Batch transfer to creators**

For SOL-denominated fees: close the WSOL ATA to unwrap, then batch `SystemProgram.transfer` instructions. For SPL token fees: batch `createTransferInstruction` calls, creating recipient ATAs as needed with `createAssociatedTokenAccountIdempotentInstruction`.
