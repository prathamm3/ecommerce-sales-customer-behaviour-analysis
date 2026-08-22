USE maven_fuzzy_factory;


-- =========================================================
-- 1. OVERALL BUSINESS KPIs
-- =========================================================
-- Calculates gross revenue, COGS, gross profit, margin and AOV.

SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(cogs_usd), 2) AS total_cogs,
    ROUND(
        SUM(price_usd - cogs_usd),
        2
    ) AS gross_profit,
    ROUND(
        SUM(price_usd - cogs_usd)
        / SUM(price_usd) * 100,
        2
    ) AS gross_margin,
    ROUND(
        AVG(price_usd),
        2
    ) AS average_order_value
FROM orders;


-- =========================================================
-- 2. MONTHLY SALES PERFORMANCE
-- =========================================================
-- Tracks order volume, gross revenue, COGS, gross profit and
-- average order value over time.

SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS orders,
    ROUND(SUM(price_usd), 2) AS revenue,
    ROUND(SUM(cogs_usd), 2) AS cogs,
    ROUND(
        SUM(price_usd - cogs_usd),
        2
    ) AS gross_profit,
    ROUND(
        AVG(price_usd),
        2
    ) AS average_order_value
FROM orders
GROUP BY
    DATE_FORMAT(created_at, '%Y-%m')
ORDER BY
    month;


-- =========================================================
-- 3. PRODUCT SALES PERFORMANCE
-- =========================================================
-- Measures units sold, revenue, COGS, gross profit and
-- average selling price by product.

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
        AVG(oi.price_usd),
        2
    ) AS average_item_price
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    revenue DESC;
