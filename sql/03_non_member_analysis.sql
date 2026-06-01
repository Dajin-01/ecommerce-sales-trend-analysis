-- 03_non_member_analysis.sql
-- Purpose: Analyze non-member transaction share, revenue share, and average revenue per invoice.

WITH filtered_data AS (
    SELECT
        InvoiceNo,
        StockCode,
        Quantity,
        UnitPrice,
        CustomerID,
        FORMAT_DATE('%Y-%m', DATE(TIMESTAMP(InvoiceDate))) AS Month,
        Quantity * UnitPrice AS Revenue
    FROM `prime_career.ecommerce_data`
    WHERE
        InvoiceNo NOT LIKE 'C%'
        AND LENGTH(StockCode) >= 5
        AND Quantity > 0
        AND Quantity NOT IN (80995, 74215)
        AND UnitPrice > 0
),
invoice_data AS (
    SELECT
        Month,
        InvoiceNo,
        CustomerID,
        SUM(Revenue) AS InvoiceRevenue
    FROM filtered_data
    GROUP BY
        Month,
        InvoiceNo,
        CustomerID
)

SELECT
    Month,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN CustomerID IS NULL THEN InvoiceNo
        END) / COUNT(DISTINCT InvoiceNo) * 100,
        2
    ) AS NonMember_Transaction_Rate,
    ROUND(
        SUM(CASE
            WHEN CustomerID IS NULL THEN InvoiceRevenue
            ELSE 0
        END) / SUM(InvoiceRevenue) * 100,
        2
    ) AS NonMember_Revenue_Rate,
    ROUND(
        AVG(CASE
            WHEN CustomerID IS NULL THEN InvoiceRevenue
        END),
        2
    ) AS NonMember_Avg_Revenue
FROM invoice_data
GROUP BY Month
ORDER BY Month;
