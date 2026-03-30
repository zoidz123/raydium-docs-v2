# Locking liquidity

Lock a CLMM position permanently using the Burn & Earn program and collect trading fees from the locked position via a lock NFT.

***

### How it works

When you lock a CLMM position:

1. Your position NFT is transferred to the Burn & Earn locker program — it cannot be withdrawn.
2. You receive a **lock NFT** that represents your locked position.
3. The lock NFT entitles you to claim trading fees that accumulate on the underlying position.

The locked position continues to earn fees as long as the pool's current price is within its tick range. You cannot modify the position's liquidity or price range after locking.

***

### Locking a position

Use `raydium.clmm.lockPosition()` to permanently lock a CLMM position.

```typescript
import {
  ApiV3PoolInfoConcentratedItem,
  CLMM_PROGRAM_ID,
  DEVNET_PROGRAM_ID,
  PositionInfoLayout,
  getPdaPersonalPositionAddress,
} from '@raydium-io/raydium-sdk-v2'
import { PublicKey } from '@solana/web3.js'
import { initSdk, txVersion } from '../config'

const lockPosition = async () => {
  const raydium = await initSdk()

  const positionNftMint = new PublicKey('your position nft mint')
  const positionPubKey = getPdaPersonalPositionAddress(
    CLMM_PROGRAM_ID, // devnet: DEVNET_PROGRAM_ID.CLMM
    positionNftMint
  ).publicKey
  const pos = await raydium.connection.getAccountInfo(positionPubKey)
  const position = PositionInfoLayout.decode(pos!.data)

  let poolInfo: ApiV3PoolInfoConcentratedItem
  if (raydium.cluster === 'mainnet') {
    poolInfo = (
      await raydium.api.fetchPoolById({ ids: position.poolId.toBase58() })
    )[0] as ApiV3PoolInfoConcentratedItem
  } else {
    const data = await raydium.clmm.getPoolInfoFromRpc(position.poolId.toBase58())
    poolInfo = data.poolInfo
  }

  if (!poolInfo) throw new Error(`clmm pool ${position.poolId.toBase58()} not found`)

  const { execute } = await raydium.clmm.lockPosition({
    // devnet: programId: DEVNET_PROGRAM_ID.CLMM_LOCK_PROGRAM_ID
    // devnet: authProgramId: DEVNET_PROGRAM_ID.CLMM_LOCK_AUTH_ID
    // devnet: poolProgramId: new PublicKey(poolInfo.programId)
    ownerPosition: position,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 46591500,
    // },
  })

  const { txId } = await execute({})
  console.log('position locked:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

lockPosition()
```

#### Lock parameters

| Parameter       | Type      | Description                                                                                       |
| --------------- | --------- | ------------------------------------------------------------------------------------------------- |
| `ownerPosition` | object    | Decoded position info from `PositionInfoLayout.decode()`.                                         |
| `programId`     | PublicKey | Lock program. Mainnet default is auto-resolved. Devnet: `DEVNET_PROGRAM_ID.CLMM_LOCK_PROGRAM_ID`. |
| `authProgramId` | PublicKey | Lock auth program. Devnet: `DEVNET_PROGRAM_ID.CLMM_LOCK_AUTH_ID`.                                 |
| `poolProgramId` | PublicKey | CLMM program ID. Devnet: pass `new PublicKey(poolInfo.programId)`.                                |
| `txVersion`     | TxVersion | Transaction version.                                                                              |

{% hint style="warning" %}
Locking is permanent. Once locked, the position cannot be unlocked or modified. Only the accrued trading fees can be collected via the lock NFT.
{% endhint %}

***

### Collecting fees from a locked position

Use `raydium.clmm.harvestLockPosition()` to claim accumulated trading fees from a locked position using the lock NFT mint address.

```typescript
import {
  CLMM_LOCK_PROGRAM_ID,
  DEVNET_PROGRAM_ID,
  LockClPositionLayoutV2,
  getPdaLockClPositionIdV2,
} from '@raydium-io/raydium-sdk-v2'
import { PublicKey } from '@solana/web3.js'
import { initSdk, txVersion } from '../config'

const harvestLockedPosition = async () => {
  const raydium = await initSdk({ loadToken: true })

  const lockNftMint = new PublicKey('your locked position nft mint')
  const lockPositionId = getPdaLockClPositionIdV2(CLMM_LOCK_PROGRAM_ID, lockNftMint).publicKey
  const res = await raydium.connection.getAccountInfo(lockPositionId)
  const lockData = LockClPositionLayoutV2.decode(res!.data)

  const { execute } = await raydium.clmm.harvestLockPosition({
    // devnet: programId: DEVNET_PROGRAM_ID.CLMM_LOCK_PROGRAM_ID
    // devnet: authProgramId: DEVNET_PROGRAM_ID.CLMM_LOCK_AUTH_ID
    // devnet: clmmProgram: DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID
    lockData,
    txVersion,
    // optional: set up priority fee here
    // computeBudgetConfig: {
    //   units: 600000,
    //   microLamports: 100000,
    // },
  })

  const { txId } = await execute({})
  console.log('harvested locked position:', { txId: `https://explorer.solana.com/tx/${txId}` })
}

harvestLockedPosition()
```

#### Harvest parameters

| Parameter       | Type      | Description                                                        |
| --------------- | --------- | ------------------------------------------------------------------ |
| `lockData`      | object    | Decoded lock position data from `LockClPositionLayoutV2.decode()`. |
| `programId`     | PublicKey | Lock program. Devnet: `DEVNET_PROGRAM_ID.CLMM_LOCK_PROGRAM_ID`.    |
| `authProgramId` | PublicKey | Lock auth program. Devnet: `DEVNET_PROGRAM_ID.CLMM_LOCK_AUTH_ID`.  |
| `clmmProgram`   | PublicKey | CLMM program. Devnet: `DEVNET_PROGRAM_ID.CLMM_PROGRAM_ID`.         |
| `txVersion`     | TxVersion | Transaction version.                                               |
