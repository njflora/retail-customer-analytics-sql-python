-- 00_exploration.sql
-- Exploratory queries used to find the cleaning rules.
-- See docs/DECISIONS.md for the decisions that came from them.
-- Run each query on its own in DB Browser (highlight it, then Ctrl + Return).

-- Q1. Look at the first rows of the invoices table
SELECT *
FROM invoices
LIMIT 10;

-- Q2. Count invoices with no customer (see D3)
SELECT COUNT(*) AS invoices_without_customer
FROM invoices
WHERE customer_id IS NULL;

-- Q3. Join lines to their invoice and product
SELECT l.invoice_no,
       i.invoice_date,
       l.stock_code,
       p.description,
       l.quantity,
       l.unit_price,
       l.quantity * l.unit_price AS line_total
FROM invoice_lines AS l
JOIN invoices AS i ON l.invoice_no = i.invoice_no
JOIN products AS p ON l.stock_code = p.stock_code
LIMIT 10;

-- Q4. Which invoice prefixes exist? (found the undocumented prefix "A", see D9)
SELECT SUBSTR(invoice_no, 1, 1) AS prefix,
       COUNT(*) AS invoices
FROM invoices
WHERE invoice_no GLOB '[A-Z]*'
GROUP BY prefix;

-- Q5. Stock codes that do not start with five digits (found non-product codes, see D9)
SELECT l.stock_code,
       p.description,
       COUNT(*) AS lines,
       ROUND(SUM(l.quantity * l.unit_price), 2) AS revenue
FROM invoice_lines AS l
JOIN products AS p ON l.stock_code = p.stock_code
WHERE l.stock_code NOT GLOB '[0-9][0-9][0-9][0-9][0-9]*'
GROUP BY l.stock_code, p.description
ORDER BY lines DESC;
