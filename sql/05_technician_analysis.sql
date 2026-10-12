```sql
-- AC SERVICE BUSINESS ANALYSIS
-- 05: Technician Analysis
-- Database: PostgreSQL
-- Table: ac_bookings


-- =====================================================
-- 1. OVERALL TECHNICIAN PERFORMANCE SUMMARY
-- =====================================================

SELECT
    technician_name,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing,

    COUNT(*) FILTER (
        WHERE service_status = 'Done'
    ) AS completed_bookings,

    COUNT(*) FILTER (
        WHERE service_status = 'Cancelled'
    ) AS cancelled_bookings,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE service_status = 'Done'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE service_status IN ('Done', 'Cancelled')
            ),
            0
        ),
        2
    ) AS completion_rate_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE service_status = 'Cancelled'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE service_status IN ('Done', 'Cancelled')
            ),
            0
        ),
        2
    ) AS cancellation_rate_pct

FROM ac_bookings
GROUP BY technician_name
ORDER BY total_bookings DESC;


-- =====================================================
-- 2. TOP TECHNICIANS BY REVENUE
-- =====================================================

SELECT
    technician_name,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE technician_name IS NOT NULL
GROUP BY technician_name
HAVING COUNT(billing_amount) > 0
ORDER BY total_revenue DESC
LIMIT 20;


-- =====================================================
-- 3. TECHNICIANS WITH THE HIGHEST AVERAGE BILLING
-- Minimum 100 billed bookings to reduce small-sample effects.
-- =====================================================

SELECT
    technician_name,
    COUNT(*) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE technician_name IS NOT NULL
  AND billing_amount IS NOT NULL
GROUP BY technician_name
HAVING COUNT(*) >= 100
ORDER BY avg_billing DESC;


-- =====================================================
-- 4. COMPLETED VS CANCELLED BOOKINGS BY TECHNICIAN
-- =====================================================

SELECT
    technician_name,

    COUNT(*) FILTER (
        WHERE service_status = 'Done'
    ) AS completed_bookings,

    COUNT(*) FILTER (
        WHERE service_status = 'Cancelled'
    ) AS cancelled_bookings,

    COUNT(*) FILTER (
        WHERE service_status IN ('Done', 'Cancelled')
    ) AS resolved_bookings,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE service_status = 'Done'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE service_status IN ('Done', 'Cancelled')
            ),
            0
        ),
        2
    ) AS completion_rate_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE service_status = 'Cancelled'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE service_status IN ('Done', 'Cancelled')
            ),
            0
        ),
        2
    ) AS cancellation_rate_pct

FROM ac_bookings
WHERE technician_name IS NOT NULL
GROUP BY technician_name
HAVING COUNT(*) FILTER (
    WHERE service_status IN ('Done', 'Cancelled')
) > 0
ORDER BY cancellation_rate_pct DESC;


-- =====================================================
-- 5. TECHNICIAN SERVICE MIX
-- Which services are recorded against each technician?
-- =====================================================

SELECT
    technician_name,
    enquiry_purpose AS service,
    COUNT(*) AS total_bookings,
    COUNT(*) FILTER (
        WHERE service_status = 'Done'
    ) AS completed_bookings,
    COUNT(*) FILTER (
        WHERE service_status = 'Cancelled'
    ) AS cancelled_bookings,
    SUM(billing_amount) AS total_revenue
FROM ac_bookings
WHERE technician_name IS NOT NULL
GROUP BY technician_name, enquiry_purpose
ORDER BY technician_name, total_bookings DESC;


-- =====================================================
-- 6. TECHNICIAN WORKLOAD BY LOCATION
-- =====================================================

SELECT
    technician_name,
    customer_location,
    COUNT(*) AS total_bookings,
    COUNT(*) FILTER (
        WHERE service_status = 'Done'
    ) AS completed_bookings,
    COUNT(*) FILTER (
        WHERE service_status = 'Cancelled'
    ) AS cancelled_bookings,
    SUM(billing_amount) AS total_revenue
FROM ac_bookings
WHERE technician_name IS NOT NULL
GROUP BY technician_name, customer_location
ORDER BY technician_name, total_bookings DESC;


-- =====================================================
-- 7. TECHNICIAN BILLING BY SERVICE
-- Compare billing within the same service category.
-- =====================================================

SELECT
    technician_name,
    enquiry_purpose AS service,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE technician_name IS NOT NULL
  AND billing_amount IS NOT NULL
GROUP BY technician_name, enquiry_purpose
HAVING COUNT(billing_amount) > 0
ORDER BY service, avg_billing DESC;


-- =====================================================
-- 8. TECHNICIAN DATA QUALITY CHECK
-- Inspect missing names and entries needing verification.
-- =====================================================

SELECT
    COALESCE(
        NULLIF(TRIM(technician_name), ''),
        'Missing Technician'
    ) AS technician_entry,
    COUNT(*) AS total_bookings
FROM ac_bookings
GROUP BY 1
ORDER BY total_bookings DESC;
```
