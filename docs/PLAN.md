# Project Plan

## Purpose

This project provides evidence of practical SQL and Python skills. It uses real transaction data from a UK online retailer. The core logic is written in SQL. Python is used for further analysis and for the charts.

## Business Question

A small group of customers may produce most of the revenue. Many new customers may never return. This project asks where the retailer should focus its retention effort.

## Working Hypothesis

1. Revenue is concentrated in a small share of customers.
2. Most customers in each monthly cohort do not make a second purchase.
3. Retention may still be higher than a typical online shop. The data source states that many customers are wholesalers.

The hypothesis is provisional. It will be tested in Phase 4. Any change will be recorded in the changelog.

## Data

Online Retail II from the UCI Machine Learning Repository. It holds 1,067,371 invoice lines from 1 December 2009 to 9 December 2011. Full details are in `data/README.md`.

## Tools

| Purpose | Tool |
|---|---|
| Database | SQLite |
| Language | Python 3.10 |
| Python libraries | pandas, SQLAlchemy, matplotlib, seaborn |
| Notebooks | Jupyter in VS Code |
| Database viewer | DB Browser for SQLite |
| Version control | Git and GitHub |
| Optional | Azure SQL Database, scikit-learn |

## Repository Structure

| Folder | Contents |
|---|---|
| `data/` | Data dictionary. The raw files are not committed. |
| `docs/` | Plan, decision log and output mock-up |
| `notebooks/` | Profiling and analysis notebooks |
| `output/` | Exported charts and summary tables |
| `sql/` | Schema, views and analysis queries |
| `src/` | Python scripts that convert and load the data |

## Method

### Phase 1: Setup and Data Profiling (complete)

1. Create the project folder, virtual environment and Git repository.
2. Download the dataset. Convert the Excel workbook to CSV with `src/01_xlsx_to_csv.py`.
3. Profile the data in `notebooks/00_first_look.ipynb`.
4. Record the design decisions in `docs/DECISIONS.md`.

### Phase 2: Database Build (in progress)

5. Write the schema in `sql/01_schema.sql`. There are four tables: `customers`, `products`, `invoices` and `invoice_lines`. Country is stored on `invoices` (see D8).
6. Write the load script `src/02_load_sqlite.py`. It applies decisions D2 to D6.
7. Validate the load. Row counts and revenue totals must match the CSV.
8. Create the `sales_clean` view in `sql/02_views.sql`. This applies decision D1.

### Phase 3: SQL Analysis

9. Write aggregate queries. These cover monthly revenue, revenue by country, top products and the repeat purchase rate.
10. Write the RFM query. A CTE calculates recency, frequency and monetary value for each customer.
11. Score each RFM measure from 1 to 5 with the `NTILE(5)` window function.
12. Write the cohort query. `MIN() OVER (PARTITION BY customer_id)` finds each customer's first purchase month. The query then counts active customers per cohort and month.

### Phase 4: Python Analysis

13. Read the query results into pandas through SQLAlchemy.
14. Map the RFM scores to named segments.
15. Build the charts listed in `docs/MOCKUP.md`.
16. Test the working hypothesis.

### Phase 5: Write-up

17. Write the README. It states the question, the method and the headline finding.
18. Push the repository to GitHub.

### Phase 6: Optional Extensions

19. Move the database to Azure SQL Database.
20. Compare the rule-based segments with KMeans clusters.

## Deliverables

- A SQLite database built entirely by script. The database file is not committed.
- SQL files for the schema, the views and the analysis.
- A narrated analysis notebook.
- Charts saved in `output/`.
- A README with the findings.

## Out of Scope

- Product category analysis. The dataset has no category field (see D7).
- Sales forecasting.
