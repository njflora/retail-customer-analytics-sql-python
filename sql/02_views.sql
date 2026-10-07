-- 02_views.sql
-- Creates the sales_clean view: one row per valid product sale.
-- Rules come from D1 and D9 in docs/DECISIONS.md.

DROP VIEW IF EXISTS sales_clean;

CREATE VIEW sales_clean AS
SELECT
    l.line_id,
    l.invoice_no,
    i.invoice_date,
    i.customer_id,
    i.country,
    l.stock_code,
    p.description,
    l.quantity,
    l.unit_price,
    l.quantity * l.unit_price AS line_total
FROM invoice_lines AS l
JOIN invoices AS i ON l.invoice_no = i.invoice_no
JOIN products AS p ON l.stock_code = p.stock_code
WHERE l.invoice_no NOT LIKE 'C%'                     -- D1: no cancellations
  AND l.quantity > 0                                 -- D1
  AND l.unit_price > 0                               -- D1
  AND l.stock_code NOT IN (                          -- D9: non-product codes
      'POST', 'DOT', 'C2', 'C3',
      'M', 'm', 'D', 'S', 'B', 'ADJUST', 'ADJUST2',
      'AMAZONFEE', 'BANK CHARGES', 'CRUK',
      'TEST001', 'TEST002'
  );