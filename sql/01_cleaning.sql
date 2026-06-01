-- 01_cleaning.sql
-- Purpose: Build a cleaned transaction dataset for sales trend analysis.

WITH cleaned_data AS (
    SELECT
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        DATE(TIMESTAMP(InvoiceDate)) AS order_date,
        FORMAT_DATE('%Y-%m', DATE(TIMESTAMP(InvoiceDate))) AS order_month,
        UnitPrice,
        CustomerID,
        Country,
        Quantity * UnitPrice AS Revenue
    FROM `prime_career.ecommerce_data`
    WHERE
        InvoiceNo NOT LIKE 'C%'          -- exclude cancelled transactions
        AND LENGTH(StockCode) >= 5       -- exclude non-product codes
        AND Quantity > 0                 -- exclude invalid quantities
        AND UnitPrice > 0                -- exclude invalid prices
        AND Quantity NOT IN (80995, 74215) -- exclude extreme quantity outliers
)

SELECT *
FROM cleaned_data;
