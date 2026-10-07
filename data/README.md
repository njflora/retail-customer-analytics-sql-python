# Data

## Source

**Online Retail II**, UCI Machine Learning Repository.

Chen, D. (2012). Online Retail II [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

**Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0). The data may be shared and adapted with credit to the source.

## Description

The data holds all transactions of a UK-based online retailer from 1 December 2009 to 9 December 2011. The company has no physical shop. It mainly sells gifts for all occasions. The source states that many of its customers are wholesalers.

## How to Get the Data

The raw files are not stored in this repository.

1. Download the zip file from https://archive.ics.uci.edu/dataset/502/online+retail+ii
2. Extract `online_retail_II.xlsx` into `data/raw/`.
3. Run `python src/01_xlsx_to_csv.py` from the project root. This writes `data/raw/online_retail_II.csv`.

## Files

| File | Rows | Notes |
|---|---|---|
| `online_retail_II.xlsx`, sheet "Year 2009-2010" | 525,461 | Original download |
| `online_retail_II.xlsx`, sheet "Year 2010-2011" | 541,910 | Original download |
| `online_retail_II.csv` | 1,067,371 | Both sheets combined by `src/01_xlsx_to_csv.py` |

## Columns

| Column | Type | Description | Notes |
|---|---|---|---|
| `Invoice` | Text | Invoice number | Six digits. A leading "C" marks a cancellation. Read as text to keep the prefix. |
| `StockCode` | Text | Product code | Mostly five digits. Some have a letter suffix (e.g. `85123A`). Some are service codes (e.g. `POST`). |
| `Description` | Text | Product name | 4,382 blanks. 1,232 stock codes have more than one description. |
| `Quantity` | Integer | Units on the line | Negative on cancellations and some adjustments. |
| `InvoiceDate` | Date and time | When the invoice was created | 83 invoices have more than one timestamp. |
| `Price` | Decimal | Unit price in pounds sterling | 6,207 lines have a price of zero or less. |
| `Customer ID` | Integer | Customer number | 243,007 blanks. Read by pandas as a decimal because of the blanks. |
| `Country` | Text | Country of the order | Every invoice has exactly one country. 13 customers have more than one country across their invoices. |

## Data Quality Summary

| Check | Result |
|---|---|
| Total lines | 1,067,371 |
| Date range | 01/12/2009 07:45 to 09/12/2011 12:50 |
| Cancellation lines | 19,494 |
| Quantity of zero or less | 22,950 |
| Price of zero or less | 6,207 |
| Exact duplicate rows | 34,335 |
| Lines with no Customer ID | 243,007 |
| Invoices | 53,628 |
| Invoices with no customer | 8,752 |
| Invoices with more than one customer | 0 |
| Invoices with more than one country | 0 |

The handling of each issue is recorded in `docs/DECISIONS.md`.

## Database Contents

The load script `src/02_load_sqlite.py` builds `data/retail.db`. After the first load the tables hold the following rows.

| Table | Rows | Notes |
|---|---|---|
| `customers` | 5,942 | One row per customer ID |
| `products` | 5,305 | 355 products have no description. Every line for these stock codes was blank. |
| `invoices` | 53,628 | 8,752 have no customer (D3) |
| `invoice_lines` | 1,033,036 | 34,335 exact duplicates removed (D2) |

Total revenue across all lines is £18,855,533.70. This figure includes cancellations and adjustments. It matches the total calculated in pandas.
