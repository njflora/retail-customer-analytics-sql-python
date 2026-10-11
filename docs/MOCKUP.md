# Output Mock-up

This document defines the final outputs before any analysis is built. Each chart lists the question it answers and the data it needs. The SQL queries in Phase 3 are written to supply exactly these fields.

Status: **Reviewed.** Updated on 11 October 2026 after the SQL analysis. Chart 6 was replaced (see below).

## Notebook Outline

The analysis notebook will follow this order.

1. Introduction: the business question and the working hypothesis
2. Data and method: the source, the cleaning rules and a link to the decision log
3. Overview: headline figures and the monthly revenue trend
4. Revenue concentration: how much revenue comes from the top customers
5. RFM segmentation: customer segments and their value
6. Cohort retention: how many new customers return
7. Findings: the hypothesis tested, with recommendations
8. Limitations and next steps

## Headline Figures

A row of figures at the top of the overview.

| Figure | Definition | Source |
|---|---|---|
| Total revenue | Sum of quantity × price | `sales_clean` |
| Customers | Distinct customer IDs | `sales_clean` |
| Invoices | Distinct invoice numbers | `sales_clean` |
| Repeat purchase rate | Customers with 2 or more invoices ÷ all customers | `sales_clean` |

## Charts

### Chart 1. Monthly Revenue

- **Question:** How does revenue change over time? Is there a seasonal pattern?
- **Type:** Line chart
- **Fields:** Month, revenue
- **Note:** December 2011 is a partial month (data ends on the 9th). It will be marked or excluded.

```
Revenue
  |            /\                  /\
  |      /\   /  \           /\   /  \
  |  ___/  \_/    \_    ___/  \_/    \
  +----------------------------------------> Month
   Dec 2009                        Dec 2011
```

### Chart 2. Revenue Concentration

- **Question:** What share of revenue comes from the top customers?
- **Type:** Cumulative curve (Pareto curve)
- **Fields:** Customers ranked by revenue; cumulative % of customers; cumulative % of revenue
- **Tests:** Hypothesis 1

```
% of revenue
100|              ___________
   |        _____/
   |    ___/
   |  _/      Top 20% of customers = ?% of revenue
   | /
  0+--------------------------> % of customers
   0                       100
```

### Chart 3. RFM Segment Summary (table)

- **Question:** Who are the customer segments and what are they worth?
- **Type:** Table
- **Fields per segment:** Customers, % of customers, revenue, % of revenue, average recency (days), average frequency (invoices), average monetary value (£)

| Segment | Customers | % Customers | Revenue | % Revenue | Avg Recency | Avg Frequency | Avg Monetary |
|---|---|---|---|---|---|---|---|
| Champions | | | | | | | |
| Loyal | | | | | | | |
| At Risk | | | | | | | |
| ... | | | | | | | |

The segment names and score rules will be set in Phase 4.

### Chart 4. Customer Share vs Revenue Share by Segment

- **Question:** Which segments produce more revenue than their size suggests?
- **Type:** Paired horizontal bar chart
- **Fields:** Segment, % of customers, % of revenue

```
Champions  |████ customers
           |██████████████ revenue
At Risk    |██████ customers
           |███████ revenue
Lost       |██████████ customers
           |██ revenue
```

### Chart 5. Cohort Retention Heatmap

- **Question:** What share of each month's new customers buy again in later months?
- **Type:** Heatmap
- **Rows:** Cohort month (month of first purchase)
- **Columns:** Months since first purchase (0, 1, 2 ...)
- **Values:** % of the cohort active in that month
- **Cohorts shown:** January 2010 to November 2011. The December 2009 and December 2011 cohorts are excluded (see D11).
- **Tests:** Hypotheses 2 and 3

```
Cohort      M0    M1    M2    M3   ...
Dec 2009   100%   ?%    ?%    ?%
Jan 2010   100%   ?%    ?%    ?%
Feb 2010   100%   ?%    ?%
...
```

### Chart 6. Cumulative Return Curve

- **Question:** By each month after their first purchase, what share of customers has returned at least once?
- **Type:** Line chart
- **Fields:** Months since first purchase (0 to 12); % of customers who have returned at least once
- **Customers shown:** Those whose first purchase was in 2010. Each of them has at least 12 months of data.
- **Tests:** Hypothesis 2

**Why this chart replaced the average retention curve:** The original Chart 6 showed the average share of a cohort active in each month. The SQL analysis showed that this share stays near 20% (F4). However, 75.8% of customers who first bought in 2010 returned at some point (F5). Customers return in seasonal cycles, not every month. A monthly measure therefore makes loyal customers look lost. The cumulative curve counts each customer once, from the month they first return. It shows how quickly the return rate builds, which answers Hypothesis 2 directly. The monthly view is still shown in the heatmap (Chart 5).

## Output Files

All charts are saved to `output/` as PNG files. The segment table is also saved as CSV.
