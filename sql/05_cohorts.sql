-- 05_cohorts.sql
-- Monthly cohort retention. A cohort is the month of a customer's first purchase.
-- Output: one row per cohort and month number, with the share still active.

-- Q1. Retention by cohort and month number (Chart 5)
WITH customer_months AS (
    SELECT DISTINCT customer_id,
           strftime('%Y-%m', invoice_date) AS order_month
    FROM sales_clean
    WHERE customer_id IS NOT NULL
),
cohorts AS (
    SELECT customer_id,
           order_month,
           MIN(order_month) OVER (PARTITION BY customer_id) AS cohort_month
    FROM customer_months
),
indexed AS (
    SELECT customer_id,
           cohort_month,
           (CAST(SUBSTR(order_month, 1, 4) AS INTEGER)
              - CAST(SUBSTR(cohort_month, 1, 4) AS INTEGER)) * 12
         + (CAST(SUBSTR(order_month, 6, 2) AS INTEGER)
              - CAST(SUBSTR(cohort_month, 6, 2) AS INTEGER)) AS month_number
    FROM cohorts
),
activity AS (
    SELECT cohort_month,
           month_number,
           COUNT(*) AS active_customers
    FROM indexed
    GROUP BY cohort_month, month_number
)
SELECT a.cohort_month,
       a.month_number,
       a.active_customers,
       s.active_customers AS cohort_size,
       ROUND(100.0 * a.active_customers / s.active_customers, 1) AS retention_pct
FROM activity AS a
JOIN activity AS s
  ON s.cohort_month = a.cohort_month
 AND s.month_number = 0
ORDER BY a.cohort_month, a.month_number;

-- Q2. Month of each customer's first return (Chart 6)
WITH customer_months AS (
    SELECT DISTINCT customer_id,
           strftime('%Y-%m', invoice_date) AS order_month
    FROM sales_clean
    WHERE customer_id IS NOT NULL
),
cohorts AS (
    SELECT customer_id,
           order_month,
           MIN(order_month) OVER (PARTITION BY customer_id) AS cohort_month
    FROM customer_months
),
indexed AS (
    SELECT customer_id,
           cohort_month,
           (CAST(SUBSTR(order_month, 1, 4) AS INTEGER)
              - CAST(SUBSTR(cohort_month, 1, 4) AS INTEGER)) * 12
         + (CAST(SUBSTR(order_month, 6, 2) AS INTEGER)
              - CAST(SUBSTR(cohort_month, 6, 2) AS INTEGER)) AS month_number
    FROM cohorts
)
SELECT customer_id,
       cohort_month,
       MIN(CASE WHEN month_number > 0 THEN month_number END) AS first_return_month
FROM indexed
GROUP BY customer_id, cohort_month;