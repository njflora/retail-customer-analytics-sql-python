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

---

## F4. Monthly retention is low

**Source:** `sql/05_cohorts.sql`. Cohorts from January 2010 to November 2011 (D11).

On average, about 20% of a cohort is active in month 1. The figure is about 21% in month 3 and about 17% in month 12. In any single month, roughly four in five customers from a cohort do not order.

---

## F5. Most new customers return at some point

**Source:** a check on customers whose first order was in 2010.

75.8% of the 3,364 customers who first ordered in 2010 placed a second order before the data ends. Customers who first ordered in 2011 show 53.2%. They had less time to return, so this figure is not directly comparable.

**Hypothesis 2: not supported.** Most customers do return. They return at intervals of several months, not every month. Monthly retention (F4) therefore understates loyalty.

**Hypothesis 3: supported.** Long-term return rates are high. This fits a customer base of wholesalers who restock.

---

## F6. Buying is strongly seasonal

**Source:** `sql/03_overview.sql`, Q2, and `sql/05_cohorts.sql`.

Revenue sits between about £500,000 and £800,000 in most months. It rises through September and October and reaches about £1.4 million in November. This happens in both 2010 and 2011. The November 2010 cohort shows the same pattern. About 10% are active in months 2 and 3, but 25.2% return in month 12. The company sells gift-ware. Its trade customers appear to restock each autumn for Christmas.

---

## F7. Context figures

| Figure | Value |
|---|---|
| Share of revenue from the United Kingdom | 85.5% |
| Next largest markets | EIRE 3.2%, Netherlands 2.8%, Germany 2.0% |
| Share of revenue with no Customer ID | 13.1% |
| Average order value | £497 |

The average order value is high for an online gift shop. This supports the view that many customers are trade buyers.

---

## F8. Fewer new customers arrived in 2011

3,288 customers made their first order between January and November 2010. The same months in 2011 show 1,509. This is a fall of 54%.

**Caveat:** part of this fall is an artefact. Some early 2010 "new" customers were existing customers (see D11). The real fall is smaller than 54%, but its size cannot be measured from this data.
