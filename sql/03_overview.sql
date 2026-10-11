-- 03_overview.sql
-- Headline figures, monthly revenue and revenue concentration.
-- All queries read from the sales_clean view.

-- Q1. Headline figures for the overview
WITH customer_invoices AS (
    SELECT customer_id,
           COUNT(DISTINCT invoice_no) AS invoices
    FROM sales_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    (SELECT ROUND(SUM(line_total), 2) FROM sales_clean)       AS total_revenue,
    (SELECT COUNT(DISTINCT invoice_no) FROM sales_clean)      AS invoices,
    COUNT(*)                                                  AS customers,
    ROUND(100.0 * SUM(CASE WHEN invoices >= 2 THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                      AS repeat_rate_pct
FROM customer_invoices;

-- Q2. Revenue and invoices by month (Chart 1)
SELECT strftime('%Y-%m', invoice_date) AS month,
       ROUND(SUM(line_total), 2)       AS revenue,
       COUNT(DISTINCT invoice_no)      AS invoices
FROM sales_clean
GROUP BY month
ORDER BY month;

-- Q3. Cumulative share of revenue by customer rank (Chart 2)
WITH customer_revenue AS (
    SELECT customer_id,
           SUM(line_total) AS revenue
    FROM sales_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
ranked AS (
    SELECT customer_id,
           revenue,
           ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rank,
           COUNT(*)     OVER ()                      AS total_customers,
           SUM(revenue) OVER (ORDER BY revenue DESC
                              ROWS BETWEEN UNBOUNDED PRECEDING
                              AND CURRENT ROW)       AS running_revenue,
           SUM(revenue) OVER ()                      AS total_revenue
    FROM customer_revenue
),
pareto AS (
    SELECT rank,
           customer_id,
           ROUND(revenue, 2)                                 AS revenue,
           ROUND(100.0 * rank / total_customers, 2)          AS pct_customers,
           ROUND(100.0 * running_revenue / total_revenue, 2) AS pct_revenue
    FROM ranked
)
SELECT * FROM pareto ORDER BY rank;
-- To read one point, e.g. the top 20%, replace the line above with:
-- SELECT * FROM pareto WHERE pct_customers >= 20 ORDER BY rank LIMIT 1;