# Changelog

All notable changes to this project are recorded here. The newest entries are at the top.

## 2026-10-11

### Published
- First push to GitHub, as a private repository: `njflora/retail-customer-analytics-sql-python`.

### Reviewed
A full review was carried out before the first push to GitHub. It found no bugs or inconsistencies.
- The schema in `sql/01_schema.sql` was checked for key and foreign key integrity.
- The load logic in `src/02_load_sqlite.py` was checked against decisions D1 to D9. This covered duplicate removal, the tie-break rules for country and description, the Customer ID type and the non-product stock codes.
- All five SQL files were reviewed. The scoring direction and tie-breaks in `sql/04_rfm.sql` were traced against D10. A score of 5 always means the best result.
- All 25 combinations of R and F scores were traced through the segment rules (D12). Each one falls into exactly one segment.
- The heatmap exclusion was checked against D11. It removes every cell whose calendar month is December 2011, not only the December 2011 cohort.
- The segment counts and percentages in F9 sum to 5,852 customers and 100%. This matches F1.
- Chart 2 and Chart 5 were checked for correct rendering and legibility.
- The `.gitignore` excludes `.venv/`, `data/raw/` and the database file. The commit history is incremental.

### Added
- `sql/02_views.sql` is now built by the load script. The load prints a check of the view: 1,003,434 lines and £19,645,617.81.
- `sql/03_overview.sql`. Headline figures, monthly revenue and revenue concentration. First use of CTEs and window functions.
- `docs/FINDINGS.md`. A log of results against the working hypothesis.
- `sql/04_rfm.sql`. Recency, frequency and monetary value per customer, scored 1 to 5 with `NTILE(5)`.
- `sql/05_cohorts.sql`. Monthly cohort retention, using `MIN() OVER (PARTITION BY customer_id)` for each customer's first month.
- `notebooks/01_analysis.ipynb`. Reads the SQL files through SQLAlchemy. Builds all six charts and the segment summary table.
- `sql/05_cohorts.sql` Q2. Each customer's first return month, for the cumulative return curve.
- Written narrative added to `notebooks/01_analysis.ipynb`: question, method, a note on each chart, findings, recommendations and limitations.
- `README.md`. The project front page: question, findings, charts, method, SQL techniques, data source, limitations and steps to reproduce.

### Results
- F2: the top 20% of customers produce 77.2% of revenue. Hypothesis 1 is supported.
- F3: 72.4% of customers placed two or more orders. Hypothesis 2 is challenged, pending the cohort analysis.
- F4 to F8 added from the cohort analysis. Hypothesis 2 is not supported. Customers return in seasonal cycles. Hypothesis 3 is supported.
- F9 added. The At Risk segment holds £1.68 million of past spend from customers who have stopped ordering.

### Decisions
- D10 added. It records the RFM reference date, scoring direction and tie-break rules.
- D11 added. The December 2009 and December 2011 cohorts are excluded from retention averages and the heatmap.
- D12 added. It defines the six RFM segments.
- D11 revised. The heatmap also excludes activity in December 2011, which held a partial month.

### Changed
- `docs/MOCKUP.md`: Chart 6 changed from an average retention curve to a cumulative return curve. The monthly measure understated loyalty (see F4 and F5). Chart 5 now notes the cohorts excluded by D11.

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
