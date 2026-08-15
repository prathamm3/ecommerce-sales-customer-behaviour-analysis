USE maven_fuzzy_factory;


-- =========================================================
-- 1. TABLE ROW COUNTS
-- =========================================================

SELECT
    'products' AS table_name,
    COUNT(*) AS row_count
FROM products

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM orders

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM order_items

UNION ALL

SELECT
    'order_item_refunds',
    COUNT(*)
FROM order_item_refunds

UNION ALL

SELECT
    'website_sessions',
    COUNT(*)
FROM website_sessions

UNION ALL

SELECT
    'website_pageviews',
    COUNT(*)
FROM website_pageviews;


-- =========================================================
-- 2. DATE RANGE
-- =========================================================

SELECT
    MIN(created_at) AS first_order,
    MAX(created_at) AS last_order
FROM orders;

SELECT
    MIN(created_at) AS first_session,
    MAX(created_at) AS last_session
FROM website_sessions;

SELECT
    MIN(created_at) AS first_pageview,
    MAX(created_at) AS last_pageview
FROM website_pageviews;


-- =========================================================
-- 3. PRODUCT OVERVIEW
-- =========================================================

SELECT
    product_id,
    product_name,
    created_at
FROM products
ORDER BY created_at;


-- =========================================================
-- 4. TRAFFIC SOURCE DISTRIBUTION
-- =========================================================

SELECT
    utm_source,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY sessions DESC;


-- =========================================================
-- 5. DEVICE DISTRIBUTION
-- =========================================================

SELECT
    device_type,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY device_type
ORDER BY sessions DESC;


-- =========================================================
-- 6. NEW VS REPEAT SESSIONS
-- =========================================================

SELECT
    CASE
        WHEN is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END AS session_type,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY
    CASE
        WHEN is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END
ORDER BY sessions DESC;