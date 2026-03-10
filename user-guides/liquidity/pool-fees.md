# Pool fees

## CLMM fees

All costs are Solana rent-exemption fees. There is no Raydium protocol fee for CLMM pool creation or position management.

---

### Pool creation

Creates a liquidity pool for a token pair. The pool exists on-chain and is ready to accept liquidity.

**Cost: 0.06144904 SOL** (non-refundable)

| Account           | Cost (SOL)     | Refundable |
| ----------------- | -------------- | ---------- |
| Pool state        | 0.01163712     | No         |
| Observation state | 0.03209256     | No         |
| Tick array bitmap | 0.0136416      | No         |
| Token vault 0     | 0.00203928     | No         |
| Token vault 1     | 0.00203928     | No         |
| **Total**         | **0.06144904** | —          |

Pools cannot be closed once created. These costs are permanent.

---

### Opening a position

Creates a new LP position for a specific price range. You receive an NFT representing ownership of the position. Opening a position does not require depositing liquidity—you can open an empty position and add liquidity later.

Position costs have two components: a fixed base cost and a variable tick array cost.

#### **Base cost**

Raydium supports two NFT methods for position ownership:

| Method         | Cost (SOL | Notes                           |
| -------------- | --------- | ------------------------------- |
| Token-2022 NFT | \~0.0092  | Uses native Token-2022 metadata |
| SPL + Metaplex | \~0.0215  | Legacy method, higher cost      |

**Token-2022 breakdown:**

| Account           | Cost (SOL)   | Refundable |
| ----------------- | ------------ | ---------- |
| Personal Position | 0.00284664   | Yes        |
| NFT mint          | 0.00277008   | Yes        |
| NFT token account | 0.00207408   | Yes        |
| Metadata funding  | 0.0014616    | Yes        |
| **Total**         | **\~0.0092** | —          |

**SPL + Metaplex breakdown:**

| Account           | Cost (SOL)   | Refundable |
| ----------------- | ------------ | ---------- |
| Personal Position | 0.00284664   | Yes        |
| NFT mint          | 0.0014616    | Yes        |
| NFT token account | 0.00203928   | Yes        |
| Metaplex Metadata | 0.0151156    | No         |
| **Total**         | **\~0.0215** | —          |

### **Tick array cost**

Tick arrays store price tick data for a range of prices. Each array costs **0.07216128 SOL** and covers `60 × tick_spacing` ticks.

Tick arrays are:

* Created when the first position uses that price range
* Shared by all positions in the pool
* Permanent and non-refundable

**You only pay for tick arrays if they don't already exist.** For popular pools like SOL-USDC, tick arrays across common price ranges are already initialized—you pay nothing extra. This cost primarily applies to new pools or positions in rarely-used price ranges.

**Calculating tick arrays needed:**

```
arrays_needed = ceil(range_width / (60 × tick_spacing))
```

The minimum is 1-2 tick arrays per position (for the lower and upper bounds of your range).

| Tick spacing | Ticks per array | Typical use case         |
| ------------ | --------------- | ------------------------ |
| 1            | 60              | Stable pairs (USDC-USDT) |
| 10           | 600             | Major pairs (SOL-USDC)   |
| 60           | 3,600           | Volatile pairs           |
| 120          | 7,200           | High volatility          |

**Example costs (assuming tick arrays don't exist):**

| Tick spacing | Arrays needed | Cost       |
| ------------ | ------------- | ---------- |
| 120          | 1             | 0.0722 SOL |
| 60           | 2             | 0.1443 SOL |
| 10           | 10            | 0.7216 SOL |

**Full range position costs:**

> **Info:** **Note:** The full range position costs provided here are for illustration purposes only. It is generally not recommended to opt for a full range position due to its high cost. If your goal is full range liquidity, it is better to use a constant product pool.

| Tick spacing | Arrays needed | Cost       |
| ------------ | ------------- | ---------- |
| 10           | \~1,479       | \~107 SOL  |
| 60           | \~247         | \~17.8 SOL |
| 120          | \~124         | \~8.9 SOL  |

#### Increase liquidity

Deposits tokens into an existing position. Your position must already be open, and the tick arrays for your price range must exist (they're initialized when the position is opened).

**Cost:** Network transaction fee only

---

#### Decrease liquidity

Withdraws tokens from your position without closing it. The position remains open and can receive more liquidity later.

**Cost:** Network transaction fee only

---

### Close position

Burns the position NFT and closes the position account. You must withdraw all liquidity and collect all fees before closing.

**Cost:** Network transaction fee only

**Refund:** \~0.006–0.02 SOL (position account + NFT accounts)

Tick arrays are not refunded—they remain as shared infrastructure for other LPs.

---

## CPMM fees

This section provides an overview of Solana rent costs associated with creating a CPMM pool and the Raydium protocol fee.

### Pool creation

Creates a new liquidity pool for a token pair. Unlike CLMM, CPMM pools require initial liquidity at creation—you cannot create an empty pool.

**Total cost: \~0.19 SOL** (non-refundable)

**Rent costs: 0.04215672 SOL**

| Account           | Cost (SOL)     | Refundable |
| ----------------- | -------------- | ---------- |
| Pool state        | 0.0053244      | No         |
| Observation state | 0.02925288     | No         |
| LP mint           | 0.0014616      | No         |
| Token vault 0     | 0.00203928     | No         |
| Token vault 1     | 0.00203928     | No         |
| LP Token Account  | 0.00203928     | Yes        |
| **Total**         | **0.04215672** | —          |

**Protocol fee: 0.15 SOL**

A fixed fee paid to Raydium to support protocol infrastructure and prevent pool spam.

Protocol fees are collected at: `DNXgeM9EiiaAbaWvwjHj9fQQLAX5ZsfHyvmYUNRAdNC8`

Pools cannot be closed once created.

---

### **LP token account (Deposit/Withdrawal)**

Each liquidity provider needs an LP token account to hold their LP tokens.

| Cost       | 0.00203928 SOL              |
| ---------- | --------------------------- |
| Created    | On first deposit            |
| Refundable | Yes, when account is closed |

You can close your LP token account after withdrawing all liquidity to reclaim the rent. Accounts with any remaining LP token balance cannot be closed.
