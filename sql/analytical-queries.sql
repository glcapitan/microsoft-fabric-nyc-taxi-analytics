/* ============================================================
   NYC Taxi Analytics Platform — Analytical Queries
   Target: ProjectWarehouse (Microsoft Fabric SQL Warehouse)
   Table:  dbo.nyctaxi_yellow  (analytics-ready, loaded via
           Dataflow Gen2 with lookups resolved in-flight)

   Columns: vendor, tpep_pickup_datetime (date), tpep_dropoff_datetime
            (date), pu_borough, pu_zone, do_borough, do_zone,
            payment_method, passenger_count, trip_distance,
            total_amount

   Note: pickup/dropoff are stored at DATE granularity (time is
   removed during transformation), so analysis is at daily level
   and above.
   ============================================================ */


/* ------------------------------------------------------------
   Q1. Which vendor generated the highest revenue?
   ------------------------------------------------------------ */
SELECT
    vendor,
    SUM(total_amount)                            AS total_revenue,
    COUNT(*)                                     AS total_trips,
    CAST(AVG(total_amount) AS DECIMAL(10,2))     AS avg_revenue_per_trip
FROM dbo.nyctaxi_yellow
GROUP BY vendor
ORDER BY total_revenue DESC;


/* ------------------------------------------------------------
   Q2. What payment method is most common?
   ------------------------------------------------------------ */
SELECT
    payment_method,
    COUNT(*)                                     AS trip_count,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct_of_trips,
    SUM(total_amount)                            AS total_revenue
FROM dbo.nyctaxi_yellow
GROUP BY payment_method
ORDER BY trip_count DESC;


/* ------------------------------------------------------------
   Q3. Which borough has the highest trip volume?
   ------------------------------------------------------------ */
SELECT
    pu_borough,
    COUNT(*)                                     AS pickup_trips,
    SUM(total_amount)                            AS total_revenue,
    CAST(AVG(trip_distance) AS DECIMAL(10,2))    AS avg_trip_distance
FROM dbo.nyctaxi_yellow
GROUP BY pu_borough
ORDER BY pickup_trips DESC;


/* ------------------------------------------------------------
   Q4. How many passengers travel daily?
   ------------------------------------------------------------ */
SELECT
    tpep_pickup_datetime                         AS trip_date,
    SUM(passenger_count)                         AS total_passengers,
    COUNT(*)                                     AS total_trips,
    CAST(AVG(CAST(passenger_count AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS avg_passengers_per_trip
FROM dbo.nyctaxi_yellow
GROUP BY tpep_pickup_datetime
ORDER BY trip_date;


/* ------------------------------------------------------------
   Q5. Busiest origin → destination borough pairs
   ------------------------------------------------------------ */
SELECT
    pu_borough,
    do_borough,
    COUNT(*)                                     AS trip_count,
    CAST(AVG(trip_distance) AS DECIMAL(10,2))    AS avg_distance,
    SUM(total_amount)                            AS total_revenue
FROM dbo.nyctaxi_yellow
GROUP BY pu_borough, do_borough
ORDER BY trip_count DESC;


/* ------------------------------------------------------------
   Q7. Revenue trend by month
   ------------------------------------------------------------ */
SELECT
    YEAR(tpep_pickup_datetime)                   AS trip_year,
    MONTH(tpep_pickup_datetime)                  AS trip_month,
    SUM(total_amount)                            AS total_revenue,
    COUNT(*)                                     AS total_trips
FROM dbo.nyctaxi_yellow
GROUP BY YEAR(tpep_pickup_datetime), MONTH(tpep_pickup_datetime)
ORDER BY trip_year, trip_month;


/* ------------------------------------------------------------
   Q6. Which days of the week are busiest?
   ------------------------------------------------------------ */
SELECT
    DATENAME(WEEKDAY, tpep_pickup_datetime)      AS day_of_week,
    COUNT(*)                                     AS trip_count,
    SUM(total_amount)                            AS total_revenue
FROM dbo.nyctaxi_yellow
GROUP BY DATENAME(WEEKDAY, tpep_pickup_datetime)
ORDER BY trip_count DESC;


/* ============================================================
   OPERATIONAL QUERIES — metadata.processing_log
   ============================================================ */

/* Load history: what has been processed, when, and how much */
SELECT TOP (100)
    pipeline_run_id,
    table_processed,
    rows_processed,
    latest_processed_pickup,
    processed_datetime
FROM metadata.processing_log
ORDER BY processed_datetime DESC;


/* Current watermark: the next run will process the month after this */
SELECT TOP 1
    latest_processed_pickup
FROM metadata.processing_log
WHERE table_processed = 'staging_nyctaxi_yellow'
ORDER BY latest_processed_pickup DESC;


/* Reconciliation: staging months should sum to the presentation total */
SELECT
    SUM(CASE WHEN table_processed = 'staging_nyctaxi_yellow' THEN rows_processed ELSE 0 END) AS staged_rows_total,
    MAX(CASE WHEN table_processed = 'presentation_nyctaxi_yellow' THEN rows_processed END)   AS presentation_rows_latest
FROM metadata.processing_log;
