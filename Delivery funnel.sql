USE brazillian_ecommerce;

-- total customers
SELECT COUNT(DISTINCT customer_unique_id) total_customers
FROM brazillian_lagging2;

SELECT DISTINCT order_status
FROM orders_lagging;

-- customers with approved payment
SELECT COUNT(DISTINCT customer_unique_id) AS customers_approved
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Invoiced';

-- customers who got their orders delivered
SELECT COUNT(DISTINCT customer_unique_id) AS customers_delivered
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Delivered';

-- customers who canceled their orders
SELECT COUNT(DISTINCT customer_unique_id) AS customers_canceled
FROM brazillian_lagging2
JOIN orders_lagging
USING (customer_id)
WHERE order_status = 'Canceled' OR order_status = 'Unavailable';
-- 577 customers canceled their orders

-- high value customers
SELECT COUNT(DISTINCT order_id) AS high_value_customers
FROM items_lagging
WHERE price > '2000';

-- building the funnel
SELECT 'Total Customers' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2

UNION ALL

SELECT 'Approved Payments' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Invoiced'

UNION ALL

SELECT 'Orders Delivered' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Delivered'

UNION ALL

SELECT 'Orders Canceled' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING (customer_id)
WHERE order_status = 'Canceled' OR order_status = 'Unavailable'

UNION ALL

SELECT 'High Value Customers' AS stage, COUNT(DISTINCT order_id) AS users
FROM items_lagging
WHERE price > '2000';

-- funnel conversion rate
WITH funnel AS(
SELECT 'Total Customers' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2

UNION ALL

SELECT 'Approved Payments' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Invoiced'

UNION ALL

SELECT 'Orders Delivered' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
WHERE order_status = 'Delivered'

UNION ALL

SELECT 'Orders Canceled' AS stage, COUNT(DISTINCT customer_unique_id) AS users
FROM brazillian_lagging2
JOIN orders_lagging
USING (customer_id)
WHERE order_status = 'Canceled' OR order_status = 'Unavailable'

UNION ALL

SELECT 'High Value Customers' AS stage, COUNT(DISTINCT order_id) AS users
FROM items_lagging
WHERE price > '2000'
)
SELECT stage,
users,
ROUND(users/LAG(users)OVER()*100,2) AS conversion_rate
FROM funnel;