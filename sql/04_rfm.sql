-- 04_rfm.sql
-- Recency, frequency and monetary value for each customer,
-- with a score from 1 (lowest) to 5 (best) for each measure.

WITH reference AS (
    SELECT DATE(MAX(invoice_date), '+1 day') AS ref_date
    FROM sales_clean
),
rfm AS (
    SELECT s.customer_id,
           CAST(JULIANDAY(r.ref_date) - JULIANDAY(MAX(s.invoice_date))
                AS INTEGER)                  AS recency_days,
           COUNT(DISTINCT s.invoice_no)      AS frequency,
           ROUND(SUM(s.line_total), 2)       AS monetary
    FROM sales_clean AS s
    CROSS JOIN reference AS r
    WHERE s.customer_id IS NOT NULL
    GROUP BY s.customer_id, r.ref_date
)
SELECT customer_id,
       recency_days,
       frequency,
       monetary,
       NTILE(5) OVER (ORDER BY recency_days DESC, frequency ASC) AS r_score,
       NTILE(5) OVER (ORDER BY frequency ASC, monetary ASC)      AS f_score,
       NTILE(5) OVER (ORDER BY monetary ASC)                     AS m_score
FROM rfm
ORDER BY monetary DESC;