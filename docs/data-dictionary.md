# Data Dictionary — `dbo.nyctaxi_yellow`

**Location:** `ProjectWarehouse` (Microsoft Fabric SQL Warehouse)
**Grain:** one row per completed taxi trip
**Load method:** stored procedure `dbo.process_presentation` (T-SQL, append); Dataflow Gen2 alternative retained deactivated
**Lineage:** monthly parquet files (`ProjectLakehouse` Files) → `stg.nyctaxi_yellow` + `stg.taxi_zone_lookup` (warehouse staging) → cleansed and transformed by `dbo.process_presentation` → appended here

---

## Columns

| # | Column | Data Type | Description | Source / Derivation | Example Values |
|---|---|---|---|---|---|
| 1 | `vendor` | varchar | Technology provider that recorded the trip | Vendor ID mapped to name via CASE in `dbo.process_presentation` | `VeriFone`, `Creative Mobile Technologies` |
| 2 | `tpep_pickup_datetime` | date | Date the meter was engaged (time element removed during transformation) | Formatted to date in `dbo.process_presentation` | `2024-03-23` |
| 3 | `tpep_dropoff_datetime` | date | Date the meter was disengaged (time element removed during transformation) | Formatted to date in `dbo.process_presentation` | `2024-03-23` |
| 4 | `pu_borough` | varchar | Borough of the pickup location | LEFT JOIN of pickup location ID to `stg.taxi_zone_lookup` | `Manhattan`, `EWR` |
| 5 | `pu_zone` | varchar | Taxi zone of the pickup location | LEFT JOIN of pickup location ID to `stg.taxi_zone_lookup` | `Times Sq/Theatre District` |
| 6 | `do_borough` | varchar | Borough of the dropoff location | LEFT JOIN of dropoff location ID to `stg.taxi_zone_lookup` | `EWR`, `Manhattan` |
| 7 | `do_zone` | varchar | Taxi zone of the dropoff location | LEFT JOIN of dropoff location ID to `stg.taxi_zone_lookup` | `Newark Airport` |
| 8 | `payment_method` | varchar | How the passenger paid | Payment type code mapped via CASE (Credit Card, Cash, No Charge, Dispute, Unknown, Voided Trip); unmapped codes default to `Unknown` | `Cash`, `Credit Card`, `Unknown` |
| 9 | `passenger_count` | int | Number of passengers on the trip (driver-entered) | Raw source field; nulls possible where not recorded | `1`, `4`, `null` |
| 10 | `trip_distance` | decimal | Trip distance in miles as reported by the meter | Raw source field, type-enforced | `17.23`, `21.95` |
| 11 | `total_amount` | decimal | Total amount charged to the passenger | Raw source field, type-enforced | `106.48`, `128.26` |

> **Verify data types** against the actual warehouse schema:
> `SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'nyctaxi_yellow';`
> Types above are the expected post-Dataflow types — adjust if the warehouse reports differently.

---

## Granularity Note

Pickup and dropoff are stored at **date granularity** — the time element is deliberately removed during transformation. Analyses at daily, monthly, and route level are supported; intraday (hour-of-day) analysis is not possible from the presentation table and would require retaining the source timestamps (see the roadmap in the main README).

---

## Data Quality Notes

- **Out-of-month dates cleansed at staging** — raw monthly files contain stray records outside the target month (dates as far back as 2002 were observed); a parameterized stored procedure deletes rows outside the month being processed before promotion
- **Negative amounts** — the raw source contains negative `total_amount` values (refunds/voids/disputes); date cleansing does not remove these, so revenue aggregations include them — worth verifying and documenting the desired treatment
- **Null passenger counts** — `passenger_count` is driver-entered and occasionally missing; passenger aggregations treat nulls as unrecorded rather than zero
- **`Unknown` payment method** — codes outside 1–6 (and code 5 itself) surface as `Unknown` rather than being dropped, keeping trip counts complete
- **Timezone** — dates reflect local New York time as provided by the source

---

## Related Documentation

- [Pipeline Architecture](pipeline-architecture.md) — how this table is loaded
- [Semantic Model](semantic-model.md) — how this table is consumed
- [Analytical Queries](../sql/analytical-queries.sql) — reference queries against this table
