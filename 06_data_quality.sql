USE maven_fuzzy_factory;


-- =========================================================
-- 1. DUPLICATE ORDER IDs
-- =========================================================
-- Each order_id should be unique.

SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 2. ORDER ITEMS WITHOUT A MATCHING ORDER
-- =========================================================
-- Checks referential integrity between order_items and orders.

SELECT
    COUNT(*) AS orphaned_order_items
FROM order_items AS oi
LEFT JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- =========================================================
-- 3. REFUNDS WITHOUT A MATCHING ORDER ITEM
-- =========================================================
-- Checks referential integrity between refunds and order_items.

SELECT
    COUNT(*) AS orphaned_refunds
FROM order_item_refunds AS r
LEFT JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;


-- =========================================================
-- 4. NULL VALUES IN IMPORTANT ORDER FIELDS
-- =========================================================
-- Checks for missing values in key financial and identifier
-- fields.

SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(website_session_id IS NULL) AS null_session_id,
    SUM(price_usd IS NULL) AS null_price,
    SUM(cogs_usd IS NULL) AS null_cogs
FROM orders;