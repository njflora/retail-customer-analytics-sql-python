"""
02_load_sqlite.py
Loads cleaned CSV into SQLite database.
Applies decisions D2-D6 and D8 from docs/DECISIONS.md.
Ran from project root: python src/02_load_sqlite.py
"""
import sqlite3
from pathlib import Path
import pandas as pd

CSV_PATH = Path("data/raw/online_retail_II.csv")
DB_PATH = Path("data/retail.db")
SCHEMA_PATH = Path("sql/01_schema.sql")

def pick_most_frequent(data, key, value):
    """For each key, return its most frequent value. Ties go to the most recent value."""
    counts = (
        data.dropna(subset=[key, value])
        .groupby([key, value])
        .agg(n=("invoice_date", "size"), last_seen=("invoice_date", "max"))
        .reset_index()
    )
    counts = counts.sort_values([key, "n", "last_seen"],
                                ascending=[True, False, False])
    return counts.drop_duplicates(subset=key)[[key, value]]

df = pd.read_csv(CSV_PATH, dtype={"Invoice": str, "StockCode": str},
                 parse_dates=["InvoiceDate"])
print("Rows read:", len(df))

df = df.drop_duplicates()                                    # D2
print("Rows after removing duplicates:", len(df))

df = df.rename(columns={
    "Invoice": "invoice_no",
    "StockCode": "stock_code",
    "Description": "description",
    "Quantity": "quantity",
    "InvoiceDate": "invoice_date",
    "Price": "unit_price",
    "Customer ID": "customer_id",
    "Country": "country",
})
df["customer_id"] = df["customer_id"].astype("Int64")       # D6

products = pd.DataFrame({"stock_code": df["stock_code"].unique()})
products = products.merge(pick_most_frequent(df, "stock_code", "description"),
                          on="stock_code", how="left")       # D4

customers = pick_most_frequent(df, "customer_id", "country")  # D4

invoices = (
    df.groupby("invoice_no")
    .agg(customer_id=("customer_id", "first"),
         invoice_date=("invoice_date", "min"),                # D4
         country=("country", "first"))                        # D8
    .reset_index()
)
invoices["invoice_date"] = invoices["invoice_date"].dt.strftime("%Y-%m-%d %H:%M:%S")

lines = df[["invoice_no", "stock_code", "quantity", "unit_price"]]

conn = sqlite3.connect(DB_PATH)
conn.execute("PRAGMA foreign_keys = ON;")
conn.executescript(SCHEMA_PATH.read_text())

customers.to_sql("customers", conn, if_exists="append", index=False)
products.to_sql("products", conn, if_exists="append", index=False)
invoices.to_sql("invoices", conn, if_exists="append", index=False)
lines.to_sql("invoice_lines", conn, if_exists="append", index=False)
conn.commit()

print("\nRow counts:")
for table in ["customers", "products", "invoices", "invoice_lines"]:
    n = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    print(f"  {table}: {n:,}")

db_revenue = conn.execute(
    "SELECT ROUND(SUM(quantity * unit_price), 2) FROM invoice_lines").fetchone()[0]
csv_revenue = round((df["quantity"] * df["unit_price"]).sum(), 2)
print("\nRevenue in database:", db_revenue)
print("Revenue in pandas:  ", csv_revenue)
print("Match:", db_revenue == csv_revenue)

conn.close()