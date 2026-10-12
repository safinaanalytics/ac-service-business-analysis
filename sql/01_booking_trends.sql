-- =========================================================
-- AC SERVICE BUSINESS ANALYSIS
-- Script 01: Booking Trends and Status Summary
-- Purpose: Understand booking volume over time and
--          examine the recorded booking outcomes.
-- Database: PostgreSQL
-- =========================================================

-- 1. Monthly booking volume
SELECT
    DATE_TRUNC('month', booking_date)::date AS booking_month,
    COUNT(*) AS total_bookings
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY DATE_TRUNC('month', booking_date)::date
ORDER BY booking_month;


-- 2. Booking status distribution
SELECT
    COALESCE(NULLIF(TRIM(service_status), ''), 'Missing') AS booking_status,
    COUNT(*) AS booking_count,
    ROUND(
        100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM ac_bookings), 0),
        2
    ) AS percentage_of_all_records
FROM ac_bookings
GROUP BY
    COALESCE(NULLIF(TRIM(service_status), ''), 'Missing')
ORDER BY booking_count DESC;


-- 3. Yearly booking volume
SELECT
    EXTRACT(YEAR FROM booking_date)::int AS booking_year,
    COUNT(*) AS total_bookings
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM booking_date)::int
ORDER BY booking_year;
