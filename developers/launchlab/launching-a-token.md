# Launching a token

Deploy a new token backed by a LaunchLab bonding curve.

Token creators use `createLaunchpad()` to deploy a new token backed by a bonding curve. This single transaction:

- mints the token
- creates on-chain metadata
- initializes the bonding curve
- opens trading immediately

No additional setup is required.

***

## How token launches work

When a token is launched, the following steps happen atomically:

1. **Token creation**  
   A new SPL token (or Token-2022 token) is minted with the specified supply.
2. **Metadata creation**  
   On-chain metadata is created via Metaplex using the provided name, symbol, and URI.
3. **Bonding curve initialization**  
   A bonding curve pool is initialized using the configured parameters.
4. **Trading begins**  
   Users can immediately buy and sell the token on the bonding curve.
5. **Migration**  
   Once the fundraising goal is reached, liquidity automatically migrates to a Raydium pool.

***

## Creating a token launch

```ts
import {
  TxVersion,
  LAUNCHPAD_PROGRAM,
  getPdaLaunchpadConfigId,
  CpmmCreatorFeeOn,
} from '@raydium-io/raydium-sdk-v2'
import { initSdk } from './config'
import { Keypair, PublicKey } from '@solana/web3.js'
import { NATIVE_MINT } from '@solana/spl-token'
import BN from 'bn.js'

const createToken = async () => {
  const raydium = await initSdk()

  // Generate a new mint keypair
  const tokenKeypair = Keypair.generate()

  // Derive global config (SOL-quoted, constant product)
  const configId = getPdaLaunchpadConfigId(
    LAUNCHPAD_PROGRAM,
    NATIVE_MINT,
    0,
    0
  ).publicKey

  const { execute, extInfo } = await raydium.launchpad.createLaunchpad({
    programId: LAUNCHPAD_PROGRAM,

    // Token configuration
    mintA: tokenKeypair.publicKey,
    decimals: 6,
    name: 'My token',
    symbol: 'MTK',
    uri: 'https://arweave.net/metadata.json',

    // Platform (optional)
    platformId: new PublicKey('your-platform-id'),

    // Global config
    configId,

    // Migration destination
    migrateType: 'cpmm',

    // Bonding curve parameters
    supply: new BN('1000000000000000'),
    totalSellA: new BN('793100000000000'),
    totalFundRaisingB: new BN('85000000000'),

    // Vesting (optional)
    totalLockedAmount: new BN('0'),
    cliffPeriod: new BN('0'),
    unlockPeriod: new BN('0'),

    // Initial buy (optional)
    createOnly: true,
    buyAmount: new BN('0'),
    slippage: new BN(100),

    // Post-migration creator fee
    creatorFeeOn: CpmmCreatorFeeOn.OnlyTokenB,

    // Transaction settings
    txVersion: TxVersion.V0,
    extraSigners: [tokenKeypair],
  })

  const { txIds } = await execute({ sendAndConfirm: true, sequentially: true })
  console.log('Pool id:', extInfo.address.poolId.toBase58())
  console.log('Token mint:', tokenKeypair.publicKey.toBase58())
}
```

***

### Parameter reference

**Token configuration**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mintA` | `PublicKey` | Yes | Public key of the new token mint. Generate a new keypair and include it in `extraSigners`. |
| `decimals` | `number` | No | Number of decimal places. Default: `6`. |
| `name` | `string` | Yes | Token name used in on-chain metadata. |
| `symbol` | `string` | Yes | Token ticker symbol. Max 10 characters. |
| `uri` | `string` | Yes | Metadata JSON URL (Arweave, IPFS, or any public URL). |

***

### **Platform and global config**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `platformId` | `PublicKey` | No | Platform configuration to launch on. Defaults to Raydium official platform. |
| `configId` | `PublicKey` | Yes | Global config defining quote token and curve type. |
| `configInfo` | `object` | No | Pre-fetched config data. Automatically fetched if omitted. |

***

### **Bonding curve parameters**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `supply` | `BN` | No | Total token supply. Minimum: `10,000,000` (pre-decimals). |
| `totalSellA` | `BN` | No | Tokens sold on the bonding curve. Must be ≥ 20% of supply. |
| `totalFundRaisingB` | `BN` | No | Quote token amount to raise before migration. |
| `migrateType` | `string` | Yes | Migration destination: `cpmm` or `amm`. |

**Understanding supply distribution**

```txt
supply = totalSellA + totalLockedAmount + migrateAmount
```

- `totalSellA`: tokens sold via the bonding curve
- `totalLockedAmount`: tokens reserved for vesting
- `migrateAmount`: tokens migrated to the AMM pool (must be ≥ 20% of supply)

**Vesting parameters (optional)**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `totalLockedAmount` | `BN` | No | Tokens reserved for vesting. Max 30% of supply. |
| `cliffPeriod` | `BN` | No | Seconds after migration before vesting starts. |
| `unlockPeriod` | `BN` | No | Linear vesting duration in seconds. |

> Note: the vesting start time is automatically set to the migration block timestamp. Vesting recipients are configured separately using `createVesting()`.

***

### **Initial buy parameters (optional)**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `createOnly` | `boolean` | No | `true` creates the token only. `false` creates and executes an initial buy. |
| `buyAmount` | `BN` | No | Quote token amount to spend on the initial buy. Required if `createOnly` is `false`. |
| `slippage` | `BN` | No | Maximum slippage in basis points (`100 = 1%`). |
| `minMintAAmount` | `BN` | No | Minimum tokens to receive. Auto-calculated if omitted. |

***

**Post-migration settings**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `creatorFeeOn` | `CpmmCreatorFeeOn` | No | Which token(s) creator fees are collected in after migration. |

**`CpmmCreatorFeeOn` options**

| Value | Description |
| --- | --- |
| `OnlyTokenB` | Creator fees are collected only in the quote token (recommended). |
| `BothToken` | Creator fees are collected in both the launched token and the quote token. |

***

**Referral parameters (optional)**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `shareFeeRate` | `BN` | No | Referrer share of trading fees (bps × 100). Cannot exceed `maxShareFeeRate` from the global config. |
| `shareFeeReceiver` | `PublicKey` | No | Wallet that receives referral fees. Applies to the initial buy only. |

***

### Token-2022 launches

LaunchLab supports Token-2022 tokens with transfer fee extensions. Transfer fees are automatically collected on every token transfer.

```ts
const { execute, extInfo } = await raydium.launchpad.createLaunchpad({
  // Standard parameters...

  // Enable Token-2022 with transfer fees
  transferFeeExtensionParams: {
    transferFeeBasePoints: 100,     // 1% transfer fee (100 bps)
    maxinumFee: new BN('1000000'),  // Maximum fee per transfer in token units
  },

  // Token-2022 launches must migrate to CPMM
  migrateType: 'cpmm',
})
```

**Important notes for Token-2022 launches**

- migration is always `cpmm` (AMMv4 does not support Token-2022)
- after migration, transfer fee authorities are transferred to the platform’s `transferFeeExtensionAuth` wallet
- the platform can modify fee rates or claim accumulated withheld fees

***

### Getting available configs

Global configs determine which quote tokens and curve types are available. Fetch configs from the API or derive them directly.

**From API**

```ts
const configs = await raydium.api.fetchLaunchConfigs()

// Find a specific config
const solConfig = configs.find(c => c.key.mintB === NATIVE_MINT.toBase58())
```

**Direct derivation**

```ts
import { getPdaLaunchpadConfigId, LAUNCHPAD_PROGRAM } from '@raydium-io/raydium-sdk-v2'
import { NATIVE_MINT } from '@solana/spl-token'

const configId = getPdaLaunchpadConfigId(
  LAUNCHPAD_PROGRAM,
  NATIVE_MINT, // Quote token
  0,           // Curve type: 0 = constant product, 1 = fixed price, 2 = linear
  0            // Config index
).publicKey
```

**Common configurations**

| Quote token | Curve type | Description |
| --- | --- | --- |
| SOL (`NATIVE_MINT`) | `0 (constant product)` | Standard launch denominated in SOL |
| USD1 (mainnet) | `0 (constant product)` | Stablecoin-denominated launch |
| sUSDC (devnet) | `0 (constant product)` | Stablecoin-denominated launch |

***

### Pool lifecycle

After creation, the pool progresses through these states:

| Status | Value | Description |
| --- | --- | --- |
| Trading | `0` | Bonding curve is active. Users can buy and sell tokens. |
| Migrate | `1` | Fundraising goal reached. Migration to AMM in progress. |
| Migrated | `2` | Migration complete. Token now trades on Raydium AMM. |

The transition from **trading** to **migrate** happens automatically when `totalFundRaisingB` worth of quote tokens have been raised.

***

### Deriving the pool id

After creation, you can derive the pool id for use in trading functions:

```ts
import { getPdaLaunchpadPoolId, LAUNCHPAD_PROGRAM } from '@raydium-io/raydium-sdk-v2'
import { NATIVE_MINT } from '@solana/spl-token'

const { publicKey: poolId } = getPdaLaunchpadPoolId(
  LAUNCHPAD_PROGRAM,
  mintA,
  NATIVE_MINT
)

console.log('Pool id:', poolId.toBase58())
```

***

## Next steps

Once your token is launched:

1. share the pool — users can trade using `buyToken()` and `sellToken()`
2. monitor progress — track fundraising progress toward `totalFundRaisingB`
3. claim fees — use `claimCreatorFee()` to collect bonding curve trading fees
4. post-migration — claim LP fees using `harvestLockLiquidity()`
