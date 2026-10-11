# Findings Log

This log records each result as it is found. It tracks the working hypothesis in `docs/PLAN.md`. The final conclusions will be written in the README.

---

## F1. Headline figures

**Source:** `sql/03_overview.sql`, Q1. Data from the `sales_clean` view.

| Figure | Value |
|---|---|
| Revenue from valid product sales | £19,645,617.81 |
| Invoices | 39,516 |
| Identified customers | 5,852 |
| Customers with two or more invoices | 72.4% |

---

## F2. Revenue is highly concentrated

**Source:** `sql/03_overview.sql`, Q3. Revenue from identified customers only.

| Top customers | Number of customers | Share of revenue |
|---|---|---|
| 1% | 59 | 32.1% |
| 10% | 585 | 63.9% |
| 20% | 1,171 | 77.2% |

**Hypothesis 1: supported.** The top 20% of customers produce 77% of revenue. This is close to the 80/20 pattern. The top 59 customers alone produce almost a third of revenue. This fits the source's note that many customers are wholesalers.

---

## F3. Most customers do return

**Source:** `sql/03_overview.sql`, Q1.

**Hypothesis 2: challenged at the overall level.** 72.4% of customers placed two or more orders over the two years. This is the opposite of "most customers never return".

**Caveat:** this figure covers the whole two-year period. Customers who first bought near the end of 2011 had little time to return. The cohort analysis will test retention month by month. Hypothesis 2 will be judged on that result.
