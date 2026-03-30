# Collecting fees and rewards

Harvest accumulated trading fees and farm reward emissions from your CLMM positions.

***

### How fees work in CLMM

Unlike CPMM pools where fees accumulate in pool vaults and appreciate LP token value, CLMM pools track fees **per position**. Each position accrues its share of trading fees based on:

* The position's liquidity share within the active tick range.
* The volume of swaps that pass through the position's price range.

Fees are collected separately from liquidity — you do not need to remove liquidity to claim fees.

***

### Harvesting fees and rewards

Use `raydium.clmm.harvestAllRewards()` to collect all pending trading fees and reward emissions across your positions.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  CLMM_PROGRAM_ID,
  DEVNET_PROGRAM_ID,
  ClmmPositionLayout,
} from '@raydium-io/raydium-sdk-v2'
import { initSdk, txVersion } from '../config'

const harvestAllRewards = async () => {
  const raydium = await initSdk()

  const allPosition = await raydium.clmm.getOwnerPositionInfo({
    programId: CLMM_PROGRAM_ID, // devnet: DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID
  })
  const nonZeroPosition = allPosition.filter((p) => !p.liquidity.isZero())
  if (!nonZeroPosition.length)
    throw new Error(
      `user do not have any non zero positions, total positions: ${allPosition.length}`
    )

  const positionPoolInfoList = (await raydium.api.fetchPoolById({
    ids: nonZeroPosition.map((p) => p.poolId.toBase58()).join(','),
  })) as ApiV3PoolInfoConcentratedItem[]

  const allPositions = nonZeroPosition.reduce(
    (acc, cur) => ({
      ...acc,
      [cur.poolId.toBase58()]: acc[cur.poolId.toBase58()]
        ? acc[cur.poolId.toBase58()].concat(cur)
        : [cur],
    }),
    {} as Record<string, ClmmPositionLayout[]>
  )

  const { execute } = await raydium.clmm.harvestAllRewards({
    allPoolInfo: positionPoolInfoList.reduce(
      (acc, cur) => ({
        ...acc,
        [cur.id]: cur,
      }),
      {}
    ),
    allPositions,
    ownerInfo: {
      useSOLBalance: true,
    },
    programId: CLMM_PROGRAM_ID, // devnet: DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txIds } = await execute({ sequentially: true })
  console.log('harvested all clmm rewards:', { txIds })
}

harvestAllRewards()
```

#### Harvest parameters

| Parameter      | Type      | Description                                                      |
| -------------- | --------- | ---------------------------------------------------------------- |
| `allPoolInfo`  | object    | Map of pool ID to pool info for all pools with positions.        |
| `allPositions` | object    | Map of pool ID to array of positions in that pool.               |
| `ownerInfo`    | object    | `{ useSOLBalance: true }` to receive native SOL instead of wSOL. |
| `programId`    | PublicKey | CLMM program ID.                                                 |
| `txVersion`    | TxVersion | Transaction version.                                             |

{% hint style="info" %}
If you have positions across many pools, `harvestAllRewards` may generate multiple transactions. Use `execute({ sequentially: true })` to send them in order.
{% endhint %}
