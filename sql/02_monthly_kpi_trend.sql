-- 02_monthly_kpi_trend.sql
-- Purpose: Calculate average daily revenue, customers, and orders by month.

WITH cleaned_data AS (
    SELECT
        InvoiceNo,
        StockCode,
        Description,
        Quantity,
        DATE(TIMESTAMP(InvoiceDate)) AS order_date,
        UnitPrice,
        COALESCE(CAST(CustomerID AS STRING), 'Guest') AS CustomerID,
        Country,
        Quantity * UnitPrice AS Revenue
    FROM `ecommerce_data`
    WHERE
        InvoiceNo NOT LIKE 'C%'
        AND LENGTH(StockCode) >= 5
        AND Quantity > 0
        AND UnitPrice > 0
        AND Quantity NOT IN (80995, 74215)
),
date_series AS (
    SELECT
        DATE_ADD(DATE '2010-12-01', INTERVAL n DAY) AS order_date
    FROM UNNEST(
        GENERATE_ARRAY(
            0,
            DATE_DIFF(DATE '2011-12-09', DATE '2010-12-01', DAY)
        )
    ) AS n
),
daily_stats AS (
    SELECT
        d.order_date,
        FORMAT_DATE('%Y-%m', d.order_date) AS order_month,
        COALESCE(SUM(c.Revenue), 0) AS daily_revenue,
        COUNT(DISTINCT c.CustomerID) AS daily_customers,
        COUNT(DISTINCT c.InvoiceNo) AS daily_orders
    FROM date_series d
    LEFT JOIN cleaned_data c
        ON c.order_date = d.order_date
    GROUP BY
        d.order_date,
        order_month
)

SELECT
    order_month,
    ROUND(AVG(daily_revenue), 2) AS avg_daily_revenue,
    ROUND(AVG(daily_customers), 2) AS avg_daily_customers,
    ROUND(AVG(daily_orders), 2) AS avg_daily_orders
FROM daily_stats
GROUP BY order_month
ORDER BY order_month;
