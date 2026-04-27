# SQL Drills · Martin James Ng'ang'a

![Week](https://img.shields.io/badge/Programme-Week%205%20of%2015-4169E1?style=flat)&nbsp;![DB](https://img.shields.io/badge/PostgreSQL-18.3-336791?style=flat&logo=postgresql&logoColor=white)&nbsp;![Status](https://img.shields.io/badge/Commits-Daily-success?style=flat)&nbsp;![Location](https://img.shields.io/badge/Nairobi-Kenya%20🇰🇪-red?style=flat)

> *SQL is the difference between an engineer who understands data and one who can actually move it.*

Production-grade SQL practice built on the same datasets powering live APIs — churn prediction, fraud detection, customer segmentation, and climate forecasting. Every query written by hand. Every result verified. Every pattern applied to real business problems.

---

## What This Repository Proves

| Skill | Evidence |
|-------|----------|
| CTEs | Multi-step fraud detection pipelines · chained business logic |
| Window Functions | ARPU ranking by segment · month-over-month churn rate · rolling averages |
| Subqueries | Correlated filters · EXISTS patterns · propensity scoring logic |
| Performance SQL | EXPLAIN ANALYZE · index strategy · materialised views on large datasets |
| Production Patterns | Feature store queries · drift detection · MLOps pipeline SQL |

---

## Datasets

| Dataset | Scale | Live Project |
|---------|-------|-------------|
| Chinook | 11 tables · music store transactions | Core drill exercises — all topics |
| IBM Telco Churn | 7,043 customers · 21 features | [Churn Prediction API](https://github.com/M20Jay) |
| Customer Segmentation | KMeans · 4 segments · ARPU analysis | [Segmentation API](https://customer-segmentation-api-rwmx.onrender.com) |
| Credit Card Fraud | 284,807 transactions · 99.83% class imbalance | Fraud Detection Pipeline |
| UNEP Climate | CO₂ emissions · country-level time series | Climate Forecasting — Week 4 |
| OpenAQ Air Quality | Real-time pollution data | Anomaly Detection — Week 6 |
| *(grows each week)* | | |

---

## Sample — SQL Powering Live Systems

```sql
-- Segment customers by ARPU and rank within each group
-- Powers: Customer Segmentation API · 7,043 customers · 4 segments
SELECT
    customer_id,
    segment_name,
    monthly_charges,
    RANK()  OVER (PARTITION BY segment_name ORDER BY monthly_charges DESC) AS rank_in_segment,
    AVG(monthly_charges) OVER (PARTITION BY segment_name)                  AS avg_arpu_by_segment,
    monthly_charges - AVG(monthly_charges) OVER (PARTITION BY segment_name) AS arpu_vs_segment_avg
FROM customer_segments
ORDER BY segment_name, rank_in_segment;

-- Month-over-month fraud rate with trend direction
-- Powers: Fraud Detection Pipeline · 284,807 transactions
WITH monthly_fraud AS (
    SELECT
        DATE_TRUNC('month', transaction_date)            AS month,
        COUNT(*)                                          AS total,
        SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)   AS fraud_count
    FROM transactions
    GROUP BY month
),
with_rate AS (
    SELECT
        month,
        ROUND(fraud_count::NUMERIC / total * 100, 3)     AS fraud_rate,
        LAG(ROUND(fraud_count::NUMERIC / total * 100, 3))
            OVER (ORDER BY month)                        AS prev_rate
    FROM monthly_fraud
)
SELECT
    month,
    fraud_rate,
    prev_rate,
    ROUND(fraud_rate - prev_rate, 3)                     AS rate_change,
    CASE
        WHEN fraud_rate > prev_rate THEN 'Increasing'
        WHEN fraud_rate < prev_rate THEN 'Decreasing'
        ELSE 'Stable'
    END AS trend
FROM with_rate
ORDER BY month;
```

---

## 15-Week SQL Progression
| Week | Topic | Key Concepts |
|------|-------|-------------|
| 1 | Foundations | SELECT · WHERE · GROUP BY · HAVING · INNER JOIN · LEFT JOIN |
| 2 | CTEs + Window Functions | WITH · ROW_NUMBER · RANK · DENSE_RANK · LAG · LEAD · PARTITION BY |
| 3 | Subqueries + Advanced JOINs | Correlated subqueries · EXISTS · SELF JOIN · FULL OUTER JOIN |
| 4 | Aggregations + Analytics | CASE WHEN · COALESCE · DATE functions · String functions |
| 5 | Performance + Production SQL | Indexes · EXPLAIN ANALYZE · Views · Materialised Views |
| 6 & 7 | Advanced Window Functions | NTILE · PERCENT_RANK · FIRST_VALUE · LAST_VALUE · Rolling averages |
| 8 & 9 | MLOps SQL Patterns | Feature store queries · Drift detection · Time series aggregations |
| 10 & 11 | Interview Patterns | ARPU by segment · Churn cohorts · Fraud rate · Unitel-style questions |
| 12 & 13 | Spark SQL + dbt | BigQuery style · dbt models · Data lineage |
| 14 & 15 | NLP + Advanced Analytics | JSON queries · Full text search · Array operations |
---

**Martin James Ng'ang'a** · MLOps Engineer · Nairobi, Kenya 🇰🇪

[![GitHub](https://img.shields.io/badge/GitHub-M20Jay-181717?style=flat&logo=github)](https://github.com/M20Jay)&nbsp;[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/in/martin-james-nganga)&nbsp;[![Portfolio](https://img.shields.io/badge/Live%20API-Segmentation-success?style=flat)](https://customer-segmentation-api-rwmx.onrender.com)