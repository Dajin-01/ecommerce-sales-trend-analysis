-- 04_cohort_retention.sql
-- Purpose: Calculate monthly customer retention by first purchase cohort.

WITH cleaned_data AS (
    SELECT *
    FROM `ecommerce_data`
    WHERE
        InvoiceNo NOT LIKE 'C%'
        AND LENGTH(StockCode) >= 5
        AND Quantity > 0
        AND Quantity NOT IN (80995, 74215)
        AND UnitPrice > 0
        AND CustomerID IS NOT NULL
),
first_purchase AS (
    SELECT
        CustomerID,
        FORMAT_DATE('%Y-%m', MIN(DATE(TIMESTAMP(InvoiceDate)))) AS FirstPurchaseMonth
    FROM cleaned_data
    GROUP BY CustomerID
),
monthly_purchase AS (
    SELECT
        CustomerID,
        FORMAT_DATE('%Y-%m', DATE(TIMESTAMP(InvoiceDate))) AS PurchaseMonth
    FROM cleaned_data
    GROUP BY
        CustomerID,
        FORMAT_DATE('%Y-%m', DATE(TIMESTAMP(InvoiceDate)))
),
retention AS (
    SELECT
        fp.FirstPurchaseMonth AS CohortMonth,
        mp.PurchaseMonth,
        COUNT(DISTINCT mp.CustomerID) AS RetainedCustomers
    FROM first_purchase fp
    JOIN monthly_purchase mp
        ON fp.CustomerID = mp.CustomerID
    GROUP BY
        fp.FirstPurchaseMonth,
        mp.PurchaseMonth
)

SELECT
    r.CohortMonth,
    r.PurchaseMonth,
    r.RetainedCustomers,
    ROUND(
        r.RetainedCustomers / (
            SELECT COUNT(DISTINCT fp.CustomerID)
            FROM first_purchase fp
            WHERE fp.FirstPurchaseMonth = r.CohortMonth
        ) * 100,
        2
    ) AS RetentionRate
FROM retention r
WHERE
    r.CohortMonth != '2011-11'
    AND r.PurchaseMonth != '2011-12'
ORDER BY
    r.CohortMonth,
    r.PurchaseMonth;
