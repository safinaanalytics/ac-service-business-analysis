```sql
-- AC SERVICE BUSINESS ANALYSIS
-- 03: Customer Analysis
-- Database: PostgreSQL
-- Table: ac_bookings


-- =====================================================
-- 1. TOTAL UNIQUE CUSTOMERS
-- =====================================================

SELECT
    COUNT(DISTINCT customer_number) AS unique_customers
FROM ac_bookings
WHERE customer_number IS NOT NULL;


-- =====================================================
-- 2. BOOKINGS PER CUSTOMER
-- =====================================================

SELECT
    customer_number,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_customer_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE customer_number IS NOT NULL
GROUP BY customer_number
ORDER BY total_bookings DESC;


-- =====================================================
-- 3. CUSTOMER TYPE CLASSIFICATION
-- One-time: 1 booking
-- Repeat: 2–3 bookings
-- Loyal: 4 or more bookings
-- Classification is based on all booking records.
-- =====================================================

WITH customer_booking_counts AS (
    SELECT
        customer_number,
        COUNT(*) AS total_bookings
    FROM ac_bookings
    WHERE customer_number IS NOT NULL
    GROUP BY customer_number
),
customer_types AS (
    SELECT
        customer_number,
        total_bookings,
        CASE
            WHEN total_bookings = 1 THEN 'One-time Customer'
            WHEN total_bookings <= 3 THEN 'Repeat Customer'
            ELSE 'Loyal Customer'
        END AS customer_type
    FROM customer_booking_counts
)
SELECT
    customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_customers
FROM customer_types
GROUP BY customer_type
ORDER BY total_customers DESC;


-- =====================================================
-- 4. REVENUE BY CUSTOMER TYPE
-- =====================================================

WITH customer_booking_counts AS (
    SELECT
        customer_number,
        COUNT(*) AS total_bookings
    FROM ac_bookings
    WHERE customer_number IS NOT NULL
    GROUP BY customer_number
),
customer_types AS (
    SELECT
        customer_number,
        CASE
            WHEN total_bookings = 1 THEN 'One-time Customer'
            WHEN total_bookings <= 3 THEN 'Repeat Customer'
            ELSE 'Loyal Customer'
        END AS customer_type
    FROM customer_booking_counts
)
SELECT
    ct.customer_type,
    COUNT(DISTINCT ct.customer_number) AS total_customers,
    COUNT(ab.customer_number) AS total_booking_records,
    COUNT(ab.billing_amount) AS billed_bookings,
    SUM(ab.billing_amount) AS total_revenue,
    ROUND(AVG(ab.billing_amount), 2) AS avg_billing_per_billed_record
FROM customer_types ct
JOIN ac_bookings ab
    ON ct.customer_number = ab.customer_number
GROUP BY ct.customer_type
ORDER BY total_revenue DESC NULLS LAST;


-- =====================================================
-- 5. MONTHLY CUSTOMER ACTIVITY
-- Counts distinct identified customers with bookings
-- in each month. A customer may appear in multiple months.
-- =====================================================

SELECT
    DATE_TRUNC('month', booking_date)::DATE AS booking_month,
    COUNT(*) AS total_bookings,
    COUNT(DISTINCT customer_number) AS unique_customers
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 6. TOP CUSTOMERS BY REVENUE
-- =====================================================

SELECT
    customer_number,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue
FROM ac_bookings
WHERE customer_number IS NOT NULL
GROUP BY customer_number
HAVING COUNT(billing_amount) > 0
ORDER BY total_revenue DESC
LIMIT 20;


-- =====================================================
-- 7. CUSTOMER REPEAT-BUSINESS SUMMARY
-- =====================================================

WITH customer_booking_counts AS (
    SELECT
        customer_number,
        COUNT(*) AS total_bookings
    FROM ac_bookings
    WHERE customer_number IS NOT NULL
    GROUP BY customer_number
)
SELECT
    COUNT(*) AS total_identified_customers,
    COUNT(*) FILTER (
        WHERE total_bookings = 1
    ) AS one_time_customers,
    COUNT(*) FILTER (
        WHERE total_bookings >= 2
    ) AS customers_with_repeat_bookings,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE total_bookings >= 2
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage
FROM customer_booking_counts;
```
