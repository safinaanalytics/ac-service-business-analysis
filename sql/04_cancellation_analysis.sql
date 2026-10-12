```sql
-- AC SERVICE BUSINESS ANALYSIS
-- 04: Cancellation Analysis
-- Database: PostgreSQL
-- Table: ac_bookings


-- =====================================================
-- 1. OVERALL SERVICE STATUS BREAKDOWN
-- =====================================================

SELECT
    COALESCE(service_status, 'Missing Status') AS service_status,
    COUNT(*) AS total_bookings,
    ROUND(
        100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM ac_bookings), 0),
        2
    ) AS percentage_of_all_bookings
FROM ac_bookings
GROUP BY service_status
ORDER BY total_bookings DESC;


-- =====================================================
-- 2. OVERALL CANCELLATION RATE
-- Denominator includes only Done and Cancelled bookings.
-- Other and missing statuses are excluded.
-- =====================================================

SELECT
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
            WHERE service_status = 'Cancelled'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE service_status IN ('Done', 'Cancelled')
            ),
            0
        ),
        2
    ) AS cancellation_rate_pct
FROM ac_bookings;


-- =====================================================
-- 3. MONTHLY CANCELLATION RATE
-- Each month's rate uses that month's Done + Cancelled
-- bookings as the denominator.
-- =====================================================

SELECT
    DATE_TRUNC('month', booking_date)::DATE AS booking_month,

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
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 4. CANCELLATION RATE BY SERVICE
-- =====================================================

SELECT
    enquiry_purpose AS service,

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
GROUP BY enquiry_purpose
HAVING COUNT(*) FILTER (
    WHERE service_status IN ('Done', 'Cancelled')
) > 0
ORDER BY cancellation_rate_pct DESC;


-- =====================================================
-- 5. CANCELLATION RATE BY CUSTOMER LOCATION
-- =====================================================

SELECT
    customer_location,

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
GROUP BY customer_location
HAVING COUNT(*) FILTER (
    WHERE service_status IN ('Done', 'Cancelled')
) > 0
ORDER BY cancellation_rate_pct DESC;


-- =====================================================
-- 6. CANCELLATIONS BY YEAR
-- Uses only years present in the available data.
-- =====================================================

SELECT
    EXTRACT(YEAR FROM booking_date)::INT AS booking_year,

    COUNT(*) FILTER (
        WHERE service_status = 'Done'
    ) AS completed_bookings,

    COUNT(*) FILTER (
        WHERE service_status = 'Cancelled'
    ) AS cancelled_bookings,

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
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 7. BOOKINGS WITH MISSING OR UNRESOLVED STATUS
-- Helps assess the reliability of cancellation metrics.
-- =====================================================

SELECT
    COALESCE(service_status, 'Missing Status') AS service_status,
    COUNT(*) AS total_bookings
FROM ac_bookings
WHERE service_status IS NULL
   OR service_status NOT IN ('Done', 'Cancelled')
GROUP BY service_status
ORDER BY total_bookings DESC;
```
