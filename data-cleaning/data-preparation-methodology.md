# Data Preparation and Cleaning Methodology

## 1. Project Context

The AC Service Business Analysis project uses booking records collected across multiple periods. The source files contained inconsistencies, missing values, variations in naming, and data-entry errors that required preparation before analysis.

The objective was to create a consolidated dataset suitable for SQL analysis and Power BI reporting while preserving the underlying business records.

## 2. Data Consolidation

- Combined records from multiple monthly and yearly source files using Power Query.
- Standardised the structure of the consolidated dataset.
- Retained source-file and index information where available to support traceability.
- Used a repeatable transformation workflow to reduce manual consolidation.

## 3. Standardisation

- Standardised location names using a mapping table.
- Applied mapping-based standardisation to service and technician names where appropriate.
- Reviewed inconsistent category values before using them in analysis.
- Preserved detailed service descriptions where they provided more useful information than broader categories.

## 4. Missing and Invalid Values

- Reviewed missing values in key analytical fields, including booking status, lead source, location and technician.
- Identified invalid or misplaced values that required correction or further review.
- Avoided treating missing information as zero or assuming that an unknown outcome represented a cancellation.
- Recognised that incomplete records limit the reliability and completeness of business conclusions.

## 5. Billing Data Preparation

Some billing entries contained formatting inconsistencies, including currency-related text and trailing symbols.

- Cleaned identifiable formatting issues so valid amounts could be analysed numerically.
- Reviewed unusual billing values rather than automatically deleting them.
- Retained plausible outliers unless there was sufficient evidence that they were data-entry errors.
- Preserved records wherever possible rather than removing entire rows because one field was problematic.

## 6. Service Dimension Selection

The `Service_Category` field contained substantial missing data and provided less granular service information.

`Enquiry_Purpose` was selected as the primary service dimension because it had substantially better completeness and more specific service descriptions. Its service-volume patterns were also broadly consistent with `Service_Category` during validation.

## 7. Validation and Analysis Readiness

The prepared dataset was used for SQL-based analysis and Power BI reporting.

Validation focused on:
- Reviewing record counts and key field completeness.
- Checking standardised categories and numerical billing values.
- Investigating missing statuses and incomplete attribution.
- Comparing key measures across analytical views.
- Identifying limitations that should be disclosed when interpreting results.

## 8. Limitations

The available dataset was reported by the business stakeholder to cover approximately 70% of overall business activity. Some booking statuses and lead-source details were also missing.

Therefore, the analysis describes the available records and should not be interpreted as a complete representation of total business performance.

## 9. Tools Used

- Power Query — consolidation, transformation and data cleaning.
- PostgreSQL / SQL — querying and analytical validation.
- Power BI — business reporting and visualisation.
