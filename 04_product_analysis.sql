USE maven_fuzzy_factory;


-- =========================================================
-- 1. PRODUCT REVENUE BY MONTH
-- =========================================================
-- Tracks how each product's revenue changes over time.

SELECT
    DATE_FORMAT(oi.created_at, '%Y-%m') AS month,
    p.product_name,
    ROUND(SUM(oi.price_usd), 2) AS revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    DATE_FORMAT(oi.created_at, '%Y-%m'),
    p.product_name
ORDER BY
    month,
    revenue DESC;


-- =========================================================
-- 2. MONTHLY PRODUCT REVENUE SHARE
-- =========================================================
-- Calculates each product's contribution to total revenue
-- within each month.
--
-- The window function calculates the total revenue for each
-- month without collapsing the individual product rows.

WITH product_monthly AS (
    SELECT
        DATE_FORMAT(oi.created_at, '%Y-%m') AS month,
        p.product_name,
        SUM(oi.price_usd) AS revenue
    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        DATE_FORMAT(oi.created_at, '%Y-%m'),
        p.product_name
)

SELECT
    month,
    product_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue
        / SUM(revenue) OVER (PARTITION BY month)
        * 100,
        2
    ) AS revenue_share
FROM product_monthly
ORDER BY
    month,
    revenue DESC;


-- =========================================================
-- 3. PRODUCT PERFORMANCE SUMMARY
-- =========================================================
-- Provides a product-level summary of volume, revenue,
-- COGS, gross profit, margin and average selling price.

SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price_usd), 2) AS revenue,
    ROUND(SUM(oi.cogs_usd), 2) AS cogs,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd),
        2
    ) AS gross_profit,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd)
        / SUM(oi.price_usd) * 100,
        2
    ) AS gross_margin,
    ROUND(AVG(oi.price_usd), 2) AS average_item_price
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    revenue DESC;