# AC Service Business Analysis: Findings and Recommendations

## 1. Project Overview

This project analyses AC service booking data from 2024 to 2026 to understand business performance, customer retention, service cancellations, technician activity, and location-level revenue.

The analysis uses Power Query for data preparation, PostgreSQL for SQL analysis, and Power BI for interactive dashboards.

## 2. Key Findings

### Finding 1: AC Installation Generates the Highest Revenue

AC Installation generated approximately ₹2.72 million in recorded revenue, making it the highest-revenue service category in the dataset.

**Business implication:** Installation services may represent an important revenue opportunity.

**Recommendation:** Track installation demand, average billing, and completion rates regularly. Compare these metrics over time before making staffing or pricing decisions.

### Finding 2: Customer Retention Is a Major Opportunity

Approximately 83.8% of identified customers were classified as one-time customers. Repeat and loyal customers together represented approximately 16.2%.

**Business implication:** The business may have an opportunity to increase repeat bookings.

**Recommendation:** Consider post-service follow-ups, seasonal AC maintenance reminders, and targeted offers for previous customers. Measure repeat booking rates to evaluate whether these actions work.

### Finding 3: Cancellations Are Substantial

Among bookings marked either Done or Cancelled, approximately 41.7% were cancelled.

**Business implication:** Cancellations may represent lost service opportunities and operational inefficiency.

**Recommendation:** Record cancellation reasons consistently and investigate patterns by service, location, and booking period. Test appointment confirmations and reminders, then compare cancellation rates before and after implementation.

**Measurement note:** This rate excludes bookings with missing or unresolved statuses. It should not be interpreted as the cancellation percentage of all booking records.

### Finding 4: Cancellation Rates Differ Across Services

Some service categories, including AC Foam / Deep Cleaning, showed relatively high cancellation rates in the available data.

**Business implication:** Cancellation patterns may differ by service type and could require different operational responses.

**Recommendation:** Investigate the reasons for cancellations in higher-rate categories. Check booking confirmation, customer expectations, appointment availability, and service-specific issues before deciding on corrective action.

### Finding 5: Location Revenue and Average Billing Tell Different Stories

Thane and Dombivali were among the leading locations by total revenue. However, high total revenue does not necessarily mean high average billing per booking.

**Business implication:** Revenue performance depends on both booking volume and the value of individual bookings.

**Recommendation:** Review booking volume, average billing, and service mix together when evaluating locations. Avoid prioritising a location using revenue alone.

### Finding 6: Technician Metrics Need Context

Technicians differed in recorded booking volume, revenue, average billing, and completion or cancellation rates.

**Business implication:** These differences may reflect service mix, location assignments, booking volume, and data quality—not just individual technician performance.

**Recommendation:** Compare technicians performing similar services under comparable conditions. Verify assignments and investigate cancellation reasons before making performance-related decisions.

### Finding 7: Data Quality Limits Business-Wide Conclusions

The dataset contains missing service statuses, incomplete lead-source information, inconsistent location and technician entries, and other recording issues. The stakeholder also indicated that the supplied data represents approximately 70% of the business.

**Business implication:** The analysis describes the available records and may not represent the entire business.

**Recommendation:** Introduce consistent booking-status definitions, mandatory lead-source capture, standardised location and technician names, and regular data-quality checks. Reconcile booking records against the business's complete operational records.

## 3. Recommended Priorities

| Priority | Recommended action | Suggested measure |
|---|---|---|
| 1 | Improve booking-status completeness | Percentage of bookings with a valid status |
| 2 | Investigate cancellations | Cancellation rate among Done and Cancelled bookings |
| 3 | Improve customer retention | Percentage of identified customers making repeat bookings |
| 4 | Monitor service profitability and billing | Revenue and average billing by service |
| 5 | Improve lead-source recording | Percentage of bookings with a valid lead source |
| 6 | Compare location performance | Booking volume, revenue, and average billing by location |

## 4. Limitations

- The supplied dataset reportedly covers approximately 70% of the business.
- Missing or unresolved statuses affect cancellation analysis.
- Incomplete lead-source information limits marketing attribution.
- Inconsistent technician and location entries may affect comparisons.
- Revenue is not the same as profit; costs and margins were not available for this analysis.
- The data does not establish the causes of cancellations or differences in technician metrics.
- The 2026 results cover only the period represented in the available dataset and should not be compared with full years without accounting for the different time periods.

## 5. Conclusion

The analysis highlights opportunities to improve customer retention, investigate cancellations, monitor service and location performance, and strengthen operational data quality.

The most important next step is to improve data completeness while tracking a small set of consistent business metrics. This would allow future analysis to support more reliable operational decisions.
