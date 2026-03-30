# Creating a pool

Create a CLMM concentrated-liquidity pool with a defined initial price in a single transaction.

***

### Fetching fee configurations

Every CLMM pool references an on-chain `AmmConfig` that defines its fee tier and tick spacing. Fetch the available configs before creating a pool.

```typescript
const clmmConfigs = await raydium.api.getClmmConfigs()
```

Each config includes:

| Field             | Description                                                     |
| ----------------- | --------------------------------------------------------------- |
| `id`              | On-chain config account address.                                |
| `tradeFeeRate`    | Fee taken from swap input, in units of 1e-6.                    |
| `tickSpacing`     | Minimum distance between ticks. Smaller = more granular ranges. |
| `protocolFeeRate` | Share of trade fee sent to Raydium protocol.                    |
| `fundFeeRate`     | Share of trade fee sent to Raydium treasury.                    |

You can also view public config IDs at:

* Mainnet: [api-v3.raydium.io/main/clmm-config](https://api-v3.raydium.io/main/clmm-config)
* Devnet: [api-v3-devnet.raydium.io/main/clmm-config](https://api-v3-devnet.raydium.io/main/clmm-config)

***

### Creating a pool

Use `raydium.clmm.createPool()` to initialize a new pool with two token mints and an initial price.

```typescript
import { CLMM_PROGRAM_ID, DEVNET_PROGRAM_ID } from '@raydium-io/raydium-sdk-v2'
import { PublicKey } from '@solana/web3.js'
import Decimal from 'decimal.js'
import { initSdk, txVersion } from '../config'

const createPool = async () => {
  const raydium = await initSdk({ loadToken: true })

  const mint1 = await raydium.token.getTokenInfo('4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R')
  const mint2 = await raydium.token.getTokenInfo('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB')

  /**
   * You can also provide mint info directly instead of fetching:
   * {
   *   address: '4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R',
   *   programId: 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
   *   decimals: 6,
   * }
   */

  const clmmConfigs = await raydium.api.getClmmConfigs()

  const { execute } = await raydium.clmm.createPool({
    programId: CLMM_PROGRAM_ID,
    // devnet: DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID
    mint1,
    mint2,
    ammConfig: {
      ...clmmConfigs[0],
      id: new PublicKey(clmmConfigs[0].id),
      fundOwner: '',
      description: '',
    },
    initialPrice: new Decimal(1),
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({ sendAndConfirm: true })
  console.log('clmm pool created:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

createPool()
```

{% hint style="info" %}
Unlike CPMM pools, CLMM pools are created without initial liquidity. After creating the pool, open a position and deposit liquidity separately — see Opening and closing positions.
{% endhint %}

***

### Parameters

| Parameter      | Type       | Description                                                                                         |
| -------------- | ---------- | --------------------------------------------------------------------------------------------------- |
| `programId`    | PublicKey  | CLMM program ID. Use `CLMM_PROGRAM_ID` for mainnet, `DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID` for devnet. |
| `mint1`        | ApiV3Token | First token mint info (address, programId, decimals).                                               |
| `mint2`        | ApiV3Token | Second token mint info. Must differ from `mint1`.                                                   |
| `ammConfig`    | object     | Fee tier config from `getClmmConfigs()`. Determines trade fees and tick spacing.                    |
| `initialPrice` | Decimal    | Initial price of mint1 in terms of mint2.                                                           |
| `txVersion`    | TxVersion  | Transaction version. `TxVersion.V0` for versioned transactions, `TxVersion.LEGACY` for legacy.      |
