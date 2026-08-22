USE maven_fuzzy_factory;


-- =========================================================
-- 1. OVERALL WEBSITE CONVERSION RATE
-- =========================================================
-- Measures how many website sessions resulted in an order.

SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.website_session_id) AS sessions_with_orders,
    ROUND(
        COUNT(DISTINCT o.website_session_id)
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON ws.website_session_id = o.website_session_id;


-- =========================================================
-- 2. CONVERSION RATE BY TRAFFIC SOURCE
-- =========================================================
-- Compares traffic volume and conversion efficiency
-- across marketing sources.

SELECT
    COALESCE(ws.utm_source, 'Unattributed') AS utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.website_session_id) AS sessions_with_orders,
    ROUND(
        COUNT(DISTINCT o.website_session_id)
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    COALESCE(ws.utm_source, 'Unattributed')
ORDER BY
    conversion_rate DESC;


-- =========================================================
-- 3. CONVERSION RATE BY DEVICE TYPE
-- =========================================================
-- Compares desktop and mobile conversion performance.

SELECT
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.website_session_id) AS sessions_with_orders,
    ROUND(
        COUNT(DISTINCT o.website_session_id)
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    ws.device_type
ORDER BY
    conversion_rate DESC;


-- =========================================================
-- 4. CONVERSION RATE BY SESSION TYPE
-- =========================================================
-- Compares new versus repeat session conversion.

SELECT
    CASE
        WHEN ws.is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END AS session_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.website_session_id) AS sessions_with_orders,
    ROUND(
        COUNT(DISTINCT o.website_session_id)
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    CASE
        WHEN ws.is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END
ORDER BY
    conversion_rate DESC;
