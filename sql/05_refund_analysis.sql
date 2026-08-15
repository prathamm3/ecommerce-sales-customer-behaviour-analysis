USE maven_fuzzy_factory;


-- =========================================================
-- 1. OVERALL REFUND SUMMARY
-- =========================================================
-- Measures the number of refunds, refunded items,
-- total refund value and average refund value.

SELECT
    COUNT(*) AS refund_records,
    COUNT(DISTINCT order_item_id) AS refunded_items,
    ROUND(
        SUM(refund_amount_usd),
        2
    ) AS total_refund_amount,
    ROUND(
        AVG(refund_amount_usd),
        2
    ) AS average_refund
FROM order_item_refunds;


-- =========================================================
-- 2. REFUNDS BY PRODUCT
-- =========================================================
-- Compares absolute refund volume and value by product.

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT r.order_item_id) AS refunded_items,
    ROUND(
        SUM(r.refund_amount_usd),
        2
    ) AS refund_amount
FROM order_item_refunds AS r
JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    refund_amount DESC;


-- =========================================================
-- 3. REFUND RATE BY PRODUCT
-- =========================================================
-- Compares refunded items with total units sold so products
-- with different sales volumes can be compared fairly.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(*) AS units_sold
    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name
),

product_refunds AS (
    SELECT
        p.product_id,
        COUNT(DISTINCT r.order_item_id) AS refunded_items,
        ROUND(
            SUM(r.refund_amount_usd),
            2
        ) AS refund_amount
    FROM order_item_refunds AS r
    JOIN order_items AS oi
        ON r.order_item_id = oi.order_item_id
    JOIN products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        p.product_id
)

SELECT
    ps.product_id,
    ps.product_name,
    ps.units_sold,
    COALESCE(
        pr.refunded_items,
        0
    ) AS refunded_items,
    COALESCE(
        pr.refund_amount,
        0
    ) AS refund_amount,
    ROUND(
        COALESCE(
            pr.refunded_items,
            0
        )
        / ps.units_sold * 100,
        2
    ) AS refund_rate
FROM product_sales AS ps
LEFT JOIN product_refunds AS pr
    ON ps.product_id = pr.product_id
ORDER BY
    refund_rate DESC;


-- =========================================================
-- 4. NET REVENUE AND NET GROSS PROFIT
-- =========================================================
-- Calculates net revenue and net gross profit after refunds.
--
-- Revenue and refunds are aggregated separately to avoid
-- double-counting caused by joining orders to multiple
-- refund records.

WITH revenue AS (
    SELECT
        SUM(price_usd) AS gross_revenue,
        SUM(cogs_usd) AS gross_cogs
    FROM orders
),

refunds AS (
    SELECT
        SUM(refund_amount_usd) AS total_refunds
    FROM order_item_refunds
)

SELECT
    ROUND(
        gross_revenue,
        2
    ) AS gross_revenue,

    ROUND(
        total_refunds,
        2
    ) AS refunds,

    ROUND(
        gross_revenue - total_refunds,
        2
    ) AS net_revenue,

    ROUND(
        gross_cogs,
        2
    ) AS gross_cogs,

    ROUND(
        gross_revenue
        - total_refunds
        - gross_cogs,
        2
    ) AS net_gross_profit,

    ROUND(
        (
            gross_revenue
            - total_refunds
            - gross_cogs
        )
        / (
            gross_revenue
            - total_refunds
        ) * 100,
        2
    ) AS net_margin
FROM revenue
CROSS JOIN refunds;