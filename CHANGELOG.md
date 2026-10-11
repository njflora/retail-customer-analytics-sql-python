# Changelog

All notable changes to this project are recorded here. The newest entries are at the top.

## 2026-10-11

### Added
- `sql/02_views.sql` is now built by the load script. The load prints a check of the view: 1,003,434 lines and £19,645,617.81.
- `sql/03_overview.sql`. Headline figures, monthly revenue and revenue concentration. First use of CTEs and window functions.
- `docs/FINDINGS.md`. A log of results against the working hypothesis.
- `sql/04_rfm.sql`. Recency, frequency and monetary value per customer, scored 1 to 5 with `NTILE(5)`.
- `sql/05_cohorts.sql`. Monthly cohort retention, using `MIN() OVER (PARTITION BY customer_id)` for each customer's first month.

### Results
- F2: the top 20% of customers produce 77.2% of revenue. Hypothesis 1 is supported.
- F3: 72.4% of customers placed two or more orders. Hypothesis 2 is challenged, pending the cohort analysis.
- F4 to F8 added from the cohort analysis. Hypothesis 2 is not supported. Customers return in seasonal cycles. Hypothesis 3 is supported.

### Decisions
- D10 added. It records the RFM reference date, scoring direction and tie-break rules.
- D11 added. The December 2009 and December 2011 cohorts are excluded from retention averages and the heatmap.

## 2026-10-07

### Added
- Project folder structure: `data/`, `docs/`, `notebooks/`, `output/`, `sql/` and `src/`.
- Python virtual environment and `requirements.txt`.
- `.gitignore`. Raw data and database files are excluded from the repository.
- `src/01_xlsx_to_csv.py`. It combines both workbook sheets into one CSV of 1,067,371 rows.
- `notebooks/00_first_look.ipynb`. First profile of the data.
- `sql/01_schema.sql`. Four tables with primary keys, foreign keys and three indexes.
- `src/02_load_sqlite.py`. It builds the database from the CSV and applies decisions D2 to D6 and D8. It ends with a row count and a revenue reconciliation.
- Country check added to `notebooks/00_first_look.ipynb`. This is the evidence for D8.
- Documentation: `docs/PLAN.md`, `docs/DECISIONS.md`, `docs/MOCKUP.md`, `data/README.md` and this changelog.

### Changed
- `requirements.txt` re-saved as UTF-8. PowerShell had saved it as UTF-16.
- Default Git branch renamed from `master` to `main`.
- Category analysis removed from scope. The dataset has no category field.

### Results
- First full load completed. Revenue in the database matches pandas at £18,855,533.70.

### Decisions
- D1 to D9 agreed. See `docs/DECISIONS.md`.
- D1 revised. The `sales_clean` view now keeps sales with no customer, so that revenue totals stay complete (see D3).
- D9 added after exploratory SQL found non-product stock codes and an undocumented invoice prefix "A".
- D8 added after profiling showed that every invoice has one country. Country is now stored on `invoices`.
