# Changelog

All notable changes to this project are recorded here. The newest entries are at the top.

## 2026-10-07

### Added
- Project folder structure: `data/`, `docs/`, `notebooks/`, `output/`, `sql/` and `src/`.
- Python virtual environment and `requirements.txt`.
- `.gitignore`. Raw data and database files are excluded from the repository.
- `src/01_xlsx_to_csv.py`. It combines both workbook sheets into one CSV of 1,067,371 rows.
- `notebooks/00_first_look.ipynb`. First profile of the data.
- Documentation: `docs/PLAN.md`, `docs/DECISIONS.md`, `docs/MOCKUP.md`, `data/README.md` and this changelog.

### Changed
- `requirements.txt` re-saved as UTF-8. PowerShell had saved it as UTF-16.
- Default Git branch renamed from `master` to `main`.
- Category analysis removed from scope. The dataset has no category field.

### Decisions
- D1 to D7 agreed. See `docs/DECISIONS.md`.
