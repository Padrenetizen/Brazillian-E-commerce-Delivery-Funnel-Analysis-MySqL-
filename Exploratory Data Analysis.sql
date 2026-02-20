-- orders by top 10 customer state
SELECT customer_state,
COUNT(order_id) AS orders
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
GROUP BY customer_state
ORDER BY orders DESC
LIMIT 10;

-- customer count
SELECT COUNT(DISTINCT customer_unique_id) AS customers
FROM brazillian_lagging2;

-- seller count
SELECT COUNT(DISTINCT seller_id) AS sellers
FROM items_lagging;
-- there are 3095 sellers

-- payment installments  by orders count
SELECT payment_installments,
COUNT(order_id) AS orders
FROM payment_lagging
JOIN orders_lagging
USING(order_id)
GROUP BY payment_installments
ORDER BY orders DESC;
-- shows that about 60% of customers preferred to pay for their goods at once rather than pay in installments

-- top 3 most preferred payment types by customers
SELECT payment_type,
COUNT(customer_id) AS customers
FROM payment_lagging
JOIN orders_lagging
USING(order_id)
GROUP BY payment_type
ORDER BY customers DESC
LIMIT 3;
-- the top 3 methods of payment were found to be credit card, boleto, and voucher

-- gross revenue and net revenue by year
SELECT order_year,
SUM(price + freight_value) AS gross_revenue,
SUM(price) AS net_revenue
FROM orders_lagging
JOIN items_lagging
USING(order_id)
GROUP BY order_year
ORDER BY gross_revenue DESC, net_revenue DESC;
-- most sales occured in 2018

-- late deliveries by year
SELECT order_year,
COUNT(order_id) AS late_deliveries
FROM orders_lagging
WHERE order_delivered_customer_time > '20:00:00'
GROUP BY order_year
ORDER BY late_deliveries DESC;
-- the occurence of late deliveries has grown from 29 to 17k 

-- 10 highest orders by customer city
SELECT customer_city,
COUNT(order_id) AS orders
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
GROUP BY customer_city
ORDER BY orders DESC
LIMIT 10;
-- sao paulo has the highest orders

-- customer count by order year
SELECT order_year,
COUNT(DISTINCT customer_unique_id) AS customer_count
FROM brazillian_lagging2
JOIN orders_lagging
USING(customer_id)
GROUP BY order_year
ORDER BY customer_count DESC;

-- payment type by orders
SELECT payment_type,
COUNT(order_id) orders
FROM payment_lagging
JOIN orders_lagging
USING(order_id)
GROUP BY payment_type
ORDER BY orders DESC;