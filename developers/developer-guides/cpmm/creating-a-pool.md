---
description: "Create a CPMM pool with initial liquidity using the Raydium SDK."
---

# Creating a pool

Create a CPMM constant-product pool and seed it with initial liquidity in a single transaction.

There are two ways to create a CPMM pool:

| Method | SDK method | Who can call | Creator fees |
| --- | --- | --- | --- |
| **Permissionless** | `createPool()` | Anyone | Disabled |
| **Permissioned** | `createPoolWithPermission()` | Approved addresses only | Enabled, configurable |

Most integrators use the permissionless path. The permissioned path is designed for launchpads and approved partners that need creator fee revenue from swaps.

***

## Fetching fee configurations

Every CPMM pool references an on-chain `AmmConfig` that defines its fee tier. Fetch the available configs before creating a pool.

```typescript
const feeConfigs = await raydium.api.getCpmmConfigs()
```

You can also view public config IDs at:

- Mainnet: [api-v3.raydium.io/main/cpmm-config](https://api-v3.raydium.io/main/cpmm-config)
- Devnet: [api-v3-devnet.raydium.io/main/cpmm-config](https://api-v3-devnet.raydium.io/main/cpmm-config)

{% hint style="info" %}
Custom fee configs are also supported. Reach out to the team if you need fee customization.
{% endhint %}

***

## Creating a pool

Use `raydium.cpmm.createPool()` to initialize a new pool with two token mints and initial deposit amounts.

```typescript
import {
  CREATE_CPMM_POOL_PROGRAM,
  CREATE_CPMM_POOL_FEE_ACC,
  DEVNET_PROGRAM_ID,
  getCpmmPdaAmmConfigId,
  TxVersion,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import { initSdk } from '../config'

const createPool = async () => {
  const raydium = await initSdk({ loadToken: true })

  const mintA = await raydium.token.getTokenInfo('So11111111111111111111111111111111111111112')
  const mintB = await raydium.token.getTokenInfo('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')

  /**
   * You can also provide mint info directly instead of fetching:
   * {
   *   address: '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R',
   *   programId: 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
   *   decimals: 6,
   * }
   */

  const feeConfigs = await raydium.api.getCpmmConfigs()

  // On devnet, re-derive config IDs from the devnet program
  if (raydium.cluster === 'devnet') {
    feeConfigs.forEach((config) => {
      config.id = getCpmmPdaAmmConfigId(
        DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM,
        config.index
      ).publicKey.toBase58()
    })
  }

  const { execute, extInfo } = await raydium.cpmm.createPool({
    programId: CREATE_CPMM_POOL_PROGRAM,
    // devnet: DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM
    poolFeeAccount: CREATE_CPMM_POOL_FEE_ACC,
    // devnet: DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_FEE_ACC
    mintA,
    mintB,
    mintAAmount: new BN(1_000_000),
    mintBAmount: new BN(1_000_000),
    startTime: new BN(0),
    feeConfig: feeConfigs[0],
    associatedOnly: false,
    ownerInfo: {
      useSOLBalance: true,
    },
    txVersion: TxVersion.V0,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('pool created', {
    txId: `https://explorer.solana.com/tx/${txId}`,
    poolId: extInfo.address.poolId.toBase58(),
  })
}

createPool()
```

***

## Parameters

| Parameter        | Type         | Description                                                                                                  |
| ---------------- | ------------ | ------------------------------------------------------------------------------------------------------------ |
| `programId`      | PublicKey    | CPMM program ID. Use `CREATE_CPMM_POOL_PROGRAM` for mainnet, `DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM` for devnet. |
| `poolFeeAccount` | PublicKey    | Protocol fee account. Use `CREATE_CPMM_POOL_FEE_ACC` for mainnet, `DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_FEE_ACC` for devnet. |
| `mintA`          | TokenInfo    | First token mint info (address, programId, decimals).                                                         |
| `mintB`          | TokenInfo    | Second token mint info. Must differ from `mintA`.                                                             |
| `mintAAmount`    | BN           | Initial deposit amount for token A, in smallest units.                                                        |
| `mintBAmount`    | BN           | Initial deposit amount for token B, in smallest units.                                                        |
| `startTime`      | BN           | Unix timestamp when swaps are enabled. `0` for immediate.                                                     |
| `feeConfig`      | object       | Fee tier config from `getCpmmConfigs()`. Determines trade fees and pool creation fee.                         |
| `associatedOnly` | boolean      | If `true`, only use associated token accounts.                                                                |
| `ownerInfo`      | object       | `{ useSOLBalance: true }` to use native SOL balance for wrapping.                                             |
| `txVersion`      | TxVersion    | Transaction version. `TxVersion.V0` for versioned transactions, `TxVersion.LEGACY` for legacy.                |

## Return value

The `extInfo.address` object contains the derived pool addresses:

| Field         | Description                         |
| ------------- | ----------------------------------- |
| `poolId`      | The created pool's public key.       |
| `mintA`       | Token A mint address.                |
| `mintB`       | Token B mint address.                |
| `lpMint`      | LP token mint address.               |
| `vaultA`      | Pool vault for token A.              |
| `vaultB`      | Pool vault for token B.              |

***

## Creating a pool with permission (creator fees)

The permissioned path uses the on-chain `initialize_with_permission` instruction. It requires a **Permission PDA** that the Raydium admin has created for your address. In return, you get:

- **Creator fees enabled** — a per-swap fee sent to the pool creator, on top of the regular trade fee.
- **Configurable fee token** — choose whether the creator fee is taken from both tokens, only token A, or only token B.
- **Separate creator address** — the payer and the pool creator can be different wallets.

{% hint style="info" %}
To request a Permission PDA for your address, contact the Raydium team. Without one, the `createPoolWithPermission()` call will fail.
{% endhint %}

Use `raydium.cpmm.createPoolWithPermission()` to create a pool with creator fees enabled.

```typescript
import {
  CREATE_CPMM_POOL_PROGRAM,
  CREATE_CPMM_POOL_FEE_ACC,
  DEVNET_PROGRAM_ID,
  getCpmmPdaAmmConfigId,
  FeeOn,
  TxVersion,
} from '@raydium-io/raydium-sdk-v2'
import BN from 'bn.js'
import { initSdk } from '../config'

const createPoolWithPermission = async () => {
  const raydium = await initSdk({ loadToken: true })

  const mintA = await raydium.token.getTokenInfo('So11111111111111111111111111111111111111112')
  const mintB = await raydium.token.getTokenInfo('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')

  const feeConfigs = await raydium.api.getCpmmConfigs()

  if (raydium.cluster === 'devnet') {
    feeConfigs.forEach((config) => {
      config.id = getCpmmPdaAmmConfigId(
        DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM,
        config.index
      ).publicKey.toBase58()
    })
  }

  const { execute, extInfo } = await raydium.cpmm.createPoolWithPermission({
    programId: CREATE_CPMM_POOL_PROGRAM,
    // devnet: DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_PROGRAM
    poolFeeAccount: CREATE_CPMM_POOL_FEE_ACC,
    // devnet: DEVNET_PROGRAM_ID.CREATE_CPMM_POOL_FEE_ACC
    mintA,
    mintB,
    mintAAmount: new BN(1_000_000),
    mintBAmount: new BN(1_000_000),
    startTime: new BN(0),
    feeConfig: feeConfigs[0],
    associatedOnly: false,
    ownerInfo: {
      useSOLBalance: true,
    },
    feeOn: FeeOn.BothToken, // BothToken | OnlyTokenA | OnlyTokenB
    txVersion: TxVersion.V0,
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('pool created with permission', {
    txId: `https://explorer.solana.com/tx/${txId}`,
    poolId: extInfo.address.poolId.toBase58(),
  })
}

createPoolWithPermission()
```

### Additional parameters (vs. permissionless)

| Parameter | Type   | Description                                                                                 |
| --------- | ------ | ------------------------------------------------------------------------------------------- |
| `feeOn`   | FeeOn  | Controls which token the creator fee is charged on. `BothToken`, `OnlyTokenA`, or `OnlyTokenB`. |

All other parameters are the same as the permissionless `createPool()`.

### `FeeOn` enum

| Value          | Behavior                                                       |
| -------------- | -------------------------------------------------------------- |
| `BothToken`    | Creator fee is charged on whichever token is the swap input.    |
| `OnlyTokenA`   | Creator fee is only charged when token A is the swap input.     |
| `OnlyTokenB`   | Creator fee is only charged when token B is the swap input.     |

### Key differences from permissionless

| | `createPool()` | `createPoolWithPermission()` |
| --- | --- | --- |
| Permission required | None | Raydium admin must create a Permission PDA for your address |
| Creator fees | Disabled (`enable_creator_fee: false`) | Enabled (`enable_creator_fee: true`) |
| Creator fee model | Fixed (`BothToken`, unused) | Caller chooses (`BothToken`, `OnlyTokenA`, `OnlyTokenB`) |
| Payer vs. creator | Same wallet | Can be different wallets |

{% hint style="warning" %}
Creator fee collection (via `collectCreatorFees()`) only works on pools created through the permissioned path. Pools created with the standard `createPool()` have creator fees disabled at the program level.
{% endhint %}
