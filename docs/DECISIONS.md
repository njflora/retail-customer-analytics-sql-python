# Decision Log

This log records each design decision, the finding behind it and the reason for it. The findings come from `notebooks/00_first_look.ipynb`.

---

## D1. Load the data in full and clean it in SQL

**Date agreed:** 7 October 2026

**Finding:** The data contains several kinds of row that are not normal sales.

| Row type | Lines |
|---|---|
| Cancellations (invoice starts with "C") | 19,494 |
| Quantity of zero or less | 22,950 |
| Price of zero or less | 6,207 |
| No Customer ID | 243,007 |

**Decision:** These rows are loaded into the database. A view named `sales_clean` excludes them. The analysis reads from the view.

**Reason:** The cleaning rules stay visible in SQL. They can be changed without reloading the data. Revenue totals can still be checked against the source.

---

## D2. Remove exact duplicate rows at load

**Date agreed:** 7 October 2026

**Finding:** 34,335 rows are identical to an earlier row in every column. This is 3.2% of all lines.

**Decision:** Exact duplicates are removed when the data is loaded.

**Reason:** A line that matches another in every field, including the time to the minute, is most likely a double entry.

**Risk:** Some duplicates may be genuine repeat scans of the same item. The effect on the results is expected to be small.

---

## D3. Keep rows that have no customer

**Date agreed:** 7 October 2026

**Finding:** 243,007 lines (22.8%) have no Customer ID.

**Decision:** These rows are kept. Their `customer_id` is stored as NULL.

**Reason:** They are still real revenue. Monthly revenue totals stay complete. The RFM and cohort analysis exclude them through the `sales_clean` view.

---

## D4. Choose one value where the data holds several

**Date agreed:** 7 October 2026

**Finding:** Three relationships do not hold one value per key.

| Table | Problem | Keys affected |
|---|---|---|
| `products` | A stock code has more than one description | 1,232 stock codes |
| `customers` | A customer has more than one country | 13 customers |
| `invoices` | An invoice has more than one timestamp | 83 invoices |

**Decision:**
- Each stock code takes its most frequent description.
- Each customer takes their most frequent country.
- Each invoice takes its earliest timestamp.
- Where two values are equally frequent, the most recent one is used.

**Reason:** A primary key must identify exactly one row. Each table needs one agreed value per key. The rules are simple and can be explained in one line each.

---

## D5. Give each invoice line its own ID

**Date agreed:** 7 October 2026

**Finding:** No column, or set of columns, uniquely identifies an invoice line. The same product can appear twice on one invoice.

**Decision:** `invoice_lines` has a surrogate key named `line_id`. SQLite numbers it automatically.

**Reason:** Every table should have a primary key. A surrogate key is the standard solution when no natural key exists.

---

## D6. Store Customer ID as a whole number

**Date agreed:** 7 October 2026

**Finding:** pandas reads Customer ID as a decimal, for example `13085.0`. This happens because the column contains blanks.

**Decision:** Customer ID is stored as an INTEGER in the database.

**Reason:** An ID is a label, not a measurement. Decimal IDs can also fail to match in joins.

---

## D7. Remove category analysis from scope

**Date agreed:** 7 October 2026

**Finding:** The original plan included revenue by product category. The dataset has no category field.

**Decision:** Category analysis is out of scope.

**Reason:** Building categories from product descriptions would need manual rules. That work would not add SQL or Python evidence in proportion to the time it takes.
