```sql
-- AC SERVICE BUSINESS ANALYSIS
-- 02: Booking and Revenue Analysis
-- Database: PostgreSQL
-- Table: ac_bookings


-- =====================================================
-- 1. MONTHLY BOOKING TRENDS
-- =====================================================

SELECT
    DATE_TRUNC('month', booking_date)::DATE AS booking_month,
    COUNT(*) AS total_bookings
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 2. MONTHLY REVENUE TRENDS
-- =====================================================

SELECT
    DATE_TRUNC('month', booking_date)::DATE AS booking_month,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 3. YEARLY BOOKING AND REVENUE TRENDS
-- =====================================================

SELECT
    EXTRACT(YEAR FROM booking_date)::INT AS booking_year,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing_per_billed_booking
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- =====================================================
-- 4. OVERALL REVENUE AND BILLING SUMMARY
-- =====================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(billing_amount) AS records_with_billing,
    COUNT(*) - COUNT(billing_amount) AS records_without_billing,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing_per_billed_record,
    MIN(billing_amount) AS minimum_billing,
    MAX(billing_amount) AS maximum_billing
FROM ac_bookings;


-- =====================================================
-- 5. REVENUE AND BILLING BY SERVICE
-- =====================================================

SELECT
    enquiry_purpose AS service,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
GROUP BY enquiry_purpose
ORDER BY total_revenue DESC NULLS LAST;


-- =====================================================
-- 6. MOST REQUESTED SERVICES
-- Counts all booking records, including those without billing.
-- =====================================================

SELECT
    enquiry_purpose AS service,
    COUNT(*) AS total_bookings
FROM ac_bookings
GROUP BY enquiry_purpose
ORDER BY total_bookings DESC;


-- =====================================================
-- 7. REVENUE BY CUSTOMER LOCATION
-- =====================================================

SELECT
    customer_location,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
GROUP BY customer_location
ORDER BY total_revenue DESC NULLS LAST;


-- =====================================================
-- 8. YEARLY REVENUE BY LOCATION
-- Uses the available dates in the dataset rather than
-- assuming that every year is complete.
-- =====================================================

SELECT
    EXTRACT(YEAR FROM booking_date)::INT AS booking_year,
    customer_location,
    COUNT(*) AS total_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
WHERE booking_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM booking_date)::INT,
    customer_location
ORDER BY
    booking_year,
    total_revenue DESC NULLS LAST;


-- =====================================================
-- 9. BILLING SUMMARY BY SERVICE STATUS
-- =====================================================

SELECT
    service_status,
    COUNT(*) AS total_bookings,
    COUNT(billing_amount) AS billed_bookings,
    SUM(billing_amount) AS total_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM ac_bookings
GROUP BY service_status
ORDER BY total_bookings DESC;
```
