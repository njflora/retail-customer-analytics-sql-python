from pathlib import Path
import pandas as pd

RAW = Path("data/raw")
xlsx_path = RAW / "online_retail_II.xlsx"

sheets = pd.read_excel(xlsx_path, sheet_name=None,
                       dtype={"Invoice": str, "StockCode": str})

for name, df in sheets.items():
    print(name, df.shape)

combined = pd.concat(sheets.values(), ignore_index=True)
combined.to_csv(RAW / "online_retail_II.csv", index=False)
print("Combined:", combined.shape)