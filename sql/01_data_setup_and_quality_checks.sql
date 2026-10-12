-- ============================================================
-- AC SERVICE BUSINESS ANALYSIS
-- Script 01: Data Setup and Quality Checks
-- Database: PostgreSQL
-- Purpose: Define the analysis table and assess data readiness
-- ============================================================


-- 1. Create the booking table
-- Run this only when the table does not already exist.

CREATE TABLE IF NOT EXISTS ac_bookings (
    booking_date DATE,
    customer_number TEXT,
    customer_name TEXT,
    lead_source TEXT,
    customer_location TEXT,
    enquiry_purpose TEXT,
    service_category TEXT,
    technician_name TEXT,
    service_status TEXT,
    billing_amount NUMERIC,
    extra_remark TEXT,
    source_file TEXT,
    row_index INTEGER
);


-- 2. Verify the imported record count

SELECT COUNT(*) AS total_records
FROM ac_bookings;


-- 3. Inspect sample records

SELECT *
FROM ac_bookings
LIMIT 10;


-- 4. Check the booking date range

SELECT
    MIN(booking_date) AS first_booking_date,
    MAX(booking_date) AS last_booking_date,
    COUNT(*) FILTER (
        WHERE booking_date IS NULL
    ) AS records_without_booking_date
FROM ac_bookings;


-- 5. Inspect distinct categorical values

SELECT DISTINCT customer_location
FROM ac_bookings
ORDER BY customer_location;

SELECT DISTINCT enquiry_purpose
FROM ac_bookings
ORDER BY enquiry_purpose;

SELECT DISTINCT service_category
FROM ac_bookings
ORDER BY service_category;

SELECT DISTINCT service_status
FROM ac_bookings
ORDER BY service_status;

SELECT DISTINCT lead_source
FROM ac_bookings
ORDER BY lead_source;

SELECT DISTINCT technician_name
FROM ac_bookings
ORDER BY technician_name;


-- 6. Assess completeness of key fields

SELECT
    COUNT(*) AS total_records,

    COUNT(booking_date) AS records_with_booking_date,
    COUNT(customer_number) AS records_with_customer_number,
    COUNT(lead_source) AS records_with_lead_source,
    COUNT(customer_location) AS records_with_location,
    COUNT(enquiry_purpose) AS records_with_service_description,
    COUNT(service_category) AS records_with_service_category,
    COUNT(technician_name) AS records_with_technician,
    COUNT(service_status) AS records_with_status,
    COUNT(billing_amount) AS records_with_billing

FROM ac_bookings;


-- 7. Summarise missing values in key fields

SELECT
    COUNT(*) AS total_records,

    COUNT(*) FILTER (
        WHERE booking_date IS NULL
    ) AS missing_booking_dates,

    COUNT(*) FILTER (
        WHERE customer_number IS NULL
    ) AS missing_customer_numbers,

    COUNT(*) FILTER (
        WHERE lead_source IS NULL
    ) AS missing_lead_sources,

    COUNT(*) FILTER (
        WHERE customer_location IS NULL
    ) AS missing_locations,

    COUNT(*) FILTER (
        WHERE enquiry_purpose IS NULL
    ) AS missing_service_descriptions,

    COUNT(*) FILTER (
        WHERE technician_name IS NULL
    ) AS missing_technicians,

    COUNT(*) FILTER (
        WHERE service_status IS NULL
    ) AS missing_statuses,

    COUNT(*) FILTER (
        WHERE billing_amount IS NULL
    ) AS missing_billing_amounts

FROM ac_bookings;


-- 8. Check potential duplicate records
-- This identifies exact duplicates across the selected fields.
-- It does not establish that every repeated row is an error.

SELECT
    booking_date,
    customer_number,
    enquiry_purpose,
    customer_location,
    technician_name,
    billing_amount,
    COUNT(*) AS duplicate_group_count

FROM ac_bookings

GROUP BY
    booking_date,
    customer_number,
    enquiry_purpose,
    customer_location,
    technician_name,
    billing_amount

HAVING COUNT(*) > 1

ORDER BY duplicate_group_count DESC;


-- 9. Check unusual negative billing values

SELECT *
FROM ac_bookings
WHERE billing_amount < 0
ORDER BY billing_amount;


-- 10. Check blank text values in important fields
-- Blank strings are different from SQL NULL values.

SELECT
    COUNT(*) FILTER (
        WHERE TRIM(COALESCE(lead_source, '')) = ''
    ) AS blank_lead_sources,

    COUNT(*) FILTER (
        WHERE TRIM(COALESCE(customer_location, '')) = ''
    ) AS blank_locations,

    COUNT(*) FILTER (
        WHERE TRIM(COALESCE(enquiry_purpose, '')) = ''
    ) AS blank_service_descriptions,

    COUNT(*) FILTER (
        WHERE TRIM(COALESCE(technician_name, '')) = ''
    ) AS blank_technician_names,

    COUNT(*) FILTER (
        WHERE TRIM(COALESCE(service_status, '')) = ''
    ) AS blank_statuses

FROM ac_bookings;
