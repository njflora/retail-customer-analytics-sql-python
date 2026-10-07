-- 00_exploration.sql
-- Exploratory queries used to find the cleaning rules.
-- See docs/DECISIONS.md for the decisions that came from them.

-- Q4. Which invoice prefixes exist? (found "A", see D9)
SELECT SUBSTR(invoice_no, 1, 1) AS prefix, ...