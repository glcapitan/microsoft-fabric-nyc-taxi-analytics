# Data Dictionary — `dbo.nyctaxi_yellow`

**Location:** `ProjectWarehouse` (Microsoft Fabric SQL Warehouse)
**Grain:** one row per completed taxi trip
**Load method:** Dataflow Gen2 (`df_pres_processing_nyctaxi`), Append
**Lineage:** raw NYC Yellow Taxi trip records + taxi zone lookup (Bronze, `ProjectLakehouse`) → cleansed, standardized, and enriched in Dataflow Gen2 → landed here

---

## Columns

| # | Column | Data Type | Description | Source / Derivation | Example Values |
|---|---|---|---|---|---|
| 1 | `vendor` | varchar | Technology provider that recorded the trip | Vendor ID resolved to name via lookup in Dataflow Gen2 | `VeriFone`, `Creative Mobile Technologies` |
| 2 | `tpep_pickup_datetime` | datetime2 | Date and time the meter was engaged | Raw source field, type-enforced | `2024-03-23 14:05:00` |
| 3 | `tpep_dropoff_datetime` | datetime2 | Date and time the meter was disengaged | Raw source field, type-enforced | `2024-03-23 14:32:00` |
| 4 | `pu_borough` | varchar | Borough of the pickup location | Pickup location ID joined to taxi zone lookup | `Manhattan`, `EWR` |
| 5 | `pu_zone` | varchar | Taxi zone of the pickup location | Pickup location ID joined to taxi zone lookup | `Times Sq/Theatre District` |
| 6 | `do_borough` | varchar | Borough of the dropoff location | Dropoff location ID joined to taxi zone lookup | `EWR`, `Manhattan` |
| 7 | `do_zone` | varchar | Taxi zone of the dropoff location | Dropoff location ID joined to taxi zone lookup | `Newark Airport` |
| 8 | `payment_method` | varchar | How the passenger paid | Payment type code resolved to label; unmapped codes default to `Unknown` | `Cash`, `Credit Card`, `Unknown` |
| 9 | `passenger_count` | int | Number of passengers on the trip (driver-entered) | Raw source field; nulls possible where not recorded | `1`, `4`, `null` |
| 10 | `trip_distance` | decimal | Trip distance in miles as reported by the meter | Raw source field, type-enforced | `17.23`, `21.95` |
| 11 | `total_amount` | decimal | Total amount charged to the passenger | Raw source field, type-enforced | `106.48`, `128.26` |

> **Verify data types** against the actual warehouse schema:
> `SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'nyctaxi_yellow';`
> Types above are the expected post-Dataflow types — adjust if the warehouse reports differently.

---

## Derived Fields (Semantic Model Layer)

Fields created downstream of the warehouse, in the `nyctaxi_yellow` semantic model:

| Field | Description | Derivation |
|---|---|---|
| `Pickup Date` | Calendar date of pickup, supporting daily/monthly trend analysis | Derived from `tpep_pickup_datetime` |

---

## Data Quality Notes

- **Negative amounts** — the raw source contains negative `total_amount` values (refunds/voids and disputed trips); analytical queries aggregating revenue should be aware of their presence in raw data and how the Dataflow handles them
- **Null passenger counts** — `passenger_count` is driver-entered and occasionally missing; passenger aggregations treat nulls as unrecorded rather than zero
- **`Unknown` payment method** — payment codes with no lookup match are preserved as `Unknown` rather than dropped, keeping trip counts complete
- **Timezone** — timestamps reflect local New York time as provided by the source

---

## Related Documentation

- [Pipeline Architecture](pipeline-architecture.md) — how this table is loaded
- [Semantic Model](semantic-model.md) — how this table is consumed
- [Analytical Queries](../sql/analytical-queries.sql) — reference queries against this table
