-- 01_schema.sql
-- Creates the four tables for the Online Retail II database.
-- Running this file deletes and rebuilds every table.

DROP TABLE IF EXISTS invoice_lines;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    country       TEXT    NOT NULL
);

CREATE TABLE products (
    stock_code    TEXT    PRIMARY KEY,
    description   TEXT
);

CREATE TABLE invoices (
    invoice_no    TEXT    PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers (customer_id),
    invoice_date  TEXT    NOT NULL,
    country       TEXT    NOT NULL
);

CREATE TABLE invoice_lines (
    line_id       INTEGER PRIMARY KEY,
    invoice_no    TEXT    NOT NULL REFERENCES invoices (invoice_no),
    stock_code    TEXT    NOT NULL REFERENCES products (stock_code),
    quantity      INTEGER NOT NULL,
    unit_price    REAL    NOT NULL
);

CREATE INDEX idx_lines_invoice  ON invoice_lines (invoice_no);
CREATE INDEX idx_lines_product  ON invoice_lines (stock_code);
CREATE INDEX idx_invoices_customer ON invoices (customer_id);