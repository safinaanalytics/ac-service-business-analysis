# Data Quality Assessment

## 1. Purpose

This assessment documents data-quality issues identified during the preparation and analysis of AC service booking records. It explains how these issues can affect reporting and what improvements could make future analysis more reliable.

## 2. Key Data Quality Issues

| Issue | Observation | Potential Impact | Recommended Improvement |
|---|---|---|---|
| Missing booking statuses | A substantial number of records have no recorded status. | Completion and cancellation rates may not represent all bookings. | Make status mandatory and update it at each stage of the booking lifecycle. |
| Incomplete lead-source information | Many records do not identify where the enquiry originated. | Marketing performance and lead conversion cannot be reliably compared across all channels. | Record the lead source when an enquiry is created. |
| Inconsistent location names | Location values require standardisation. | The same location may appear as separate categories in reports. | Use a standard location list or controlled dropdown. |
| Inconsistent technician entries | The technician field contains inconsistent and potentially invalid entries. | Technician workload and performance comparisons may be inaccurate. | Maintain an approved technician list and validate assignments. |
| Incomplete service categories | The Service_Category field contains substantial missing data and less specific descriptions. | Service-level comparisons may be misleading. | Maintain standard service categories and consistent service descriptions. |
| Billing-format inconsistencies | Some billing values contain formatting issues or non-numeric text. | Numeric calculations may fail or exclude valid records. | Validate billing entries and store monetary values as numbers. |
| Incomplete business coverage | The stakeholder reported that the dataset covers approximately 70% of overall business activity. | Findings may not represent total bookings or revenue. | Reconcile records across all enquiry and booking channels. |

## 3. Impact on Analysis

These issues can affect:
- The reliability of booking and cancellation metrics.
- Comparisons between services, locations and technicians.
- Customer retention analysis.
- Lead-source and marketing attribution.
- Revenue reporting and reconciliation.

Missing or uncertain information should be explicitly disclosed rather than silently interpreted as zero or assigned an assumed outcome.

## 4. Recommended Data Controls

1. Assign a unique ID to every enquiry and booking.
2. Require essential fields such as enquiry date, lead source, service and status.
3. Use standard lists for service categories, locations and technicians.
4. Separate booking status from payment status.
5. Reconcile completed bookings with billing and payment records.
6. Review missing values and duplicates regularly.
7. Restrict access to customer information and maintain appropriate backups.
8. Produce a periodic data-quality report.

## 5. Limitations

The available records are incomplete and were reported to represent approximately 70% of the business. The findings in this assessment identify risks in the available dataset; they do not establish the full extent or financial impact of each issue.

The recommended controls are proposed improvements and should be implemented in coordination with the business owner and relevant staff.
