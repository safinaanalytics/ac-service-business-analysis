```sql
-- AC SERVICE BUSINESS ANALYSIS
-- 06: Location and Lead-Source Analysis
-- Database: PostgreSQL
-- Table: ac_bookings


-- =====================================================
-- 1. WHICH LOCATIONS GENERATE THE MOST BOOKINGS?
-- =====================================================

SELECT
    customer_location,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings
FROM ac_bookings
GROUP BY customer_location
ORDER BY total_bookings DESC;


-- =====================================================
-- 2. WHICH LOCATIONS GENERATE THE MOST REVENUE?
-- =====================================================

SELECT
    customer_location,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE billing_amount IS NOT NULL
GROUP BY customer_location
ORDER BY total_revenue DESC NULLS LAST;


-- =====================================================
-- 3. REVENUE BY LOCATION AND YEAR
-- Uses the available booking dates in each year.
-- =====================================================

SELECT
    EXTRACT(YEAR FROM booking_date)::INT AS booking_year,
    customer_location,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE booking_date IS NOT NULL
  AND billing_amount IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM booking_date)::INT,
    customer_location
ORDER BY booking_year, total_revenue DESC NULLS LAST;


-- =====================================================
-- 4. WHICH SERVICES GENERATE REVENUE IN EACH LOCATION?
-- =====================================================

SELECT
    customer_location,
    enquiry_purpose AS service,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE billing_amount IS NOT NULL
GROUP BY customer_location, enquiry_purpose
ORDER BY customer_location, total_revenue DESC NULLS LAST;


-- =====================================================
-- 5. INVESTIGATE THANE'S REVENUE AND AVERAGE BILLING
-- =====================================================

SELECT
    customer_location,
    COUNT(*) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE customer_location = 'Thane'
  AND billing_amount IS NOT NULL
GROUP BY customer_location;


-- Thane service mix

SELECT
    enquiry_purpose AS service,
    COUNT(*) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE customer_location = 'Thane'
  AND billing_amount IS NOT NULL
GROUP BY enquiry_purpose
ORDER BY billed_bookings DESC;


-- =====================================================
-- 6. INVESTIGATE DOMBIVALI'S REVENUE AND SERVICE MIX
-- =====================================================

SELECT
    customer_location,
    COUNT(*) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE customer_location = 'Dombivali'
  AND billing_amount IS NOT NULL
GROUP BY customer_location;


SELECT
    enquiry_purpose AS service,
    COUNT(*) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE customer_location = 'Dombivali'
  AND billing_amount IS NOT NULL
GROUP BY enquiry_purpose
ORDER BY billed_bookings DESC;


-- =====================================================
-- 7. WHICH LEAD SOURCES BRING THE MOST BOOKINGS?
-- =====================================================

SELECT
    COALESCE(
        NULLIF(TRIM(lead_source), ''),
        'Missing Lead Source'
    ) AS lead_source,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings
FROM ac_bookings
GROUP BY 1
ORDER BY total_bookings DESC;


-- =====================================================
-- 8. WHICH LEAD SOURCES GENERATE THE MOST REVENUE?
-- =====================================================

SELECT
    COALESCE(
        NULLIF(TRIM(lead_source), ''),
        'Missing Lead Source'
    ) AS lead_source,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE billing_amount IS NOT NULL
GROUP BY 1
ORDER BY total_revenue DESC NULLS LAST;


-- =====================================================
-- 9. WHICH LEAD SOURCES HAVE THE HIGHEST AVERAGE BILLING?
-- =====================================================

SELECT
    COALESCE(
        NULLIF(TRIM(lead_source), ''),
        'Missing Lead Source'
    ) AS lead_source,
    COUNT(billing_amount) AS billed_bookings,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE billing_amount IS NOT NULL
GROUP BY 1
ORDER BY avg_billing DESC NULLS LAST;


-- =====================================================
-- 10. CHECK LEAD-SOURCE DATA COMPLETENESS
-- =====================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(lead_source) AS records_with_non_null_lead_source,
    COUNT(*) - COUNT(lead_source) AS records_with_null_lead_source,
    ROUND(
        100.0 * (COUNT(*) - COUNT(lead_source))
        / NULLIF(COUNT(*), 0),
        2
    ) AS null_lead_source_percentage
FROM ac_bookings;


-- =====================================================
-- 11. LOCATION COMPLETION VS CANCELLATION
-- Considers only Done and Cancelled bookings.
-- =====================================================

SELECT
    customer_location,

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
GROUP BY customer_location
HAVING COUNT(*) FILTER (
    WHERE service_status IN ('Done', 'Cancelled')
) > 0
ORDER BY completed_bookings DESC;
```
