CREATE TABLE orders_lagging LIKE olist_orders_dataset;

INSERT INTO orders_lagging
SELECT *
FROM olist_orders_dataset;

SELECT *
FROM orders_lagging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, order_status, order_estimated_delivery_date) AS row_num
FROM orders_lagging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, order_status, order_estimated_delivery_date) AS row_num
FROM orders_lagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- duplicates were not found in this table

-- fixing the letter case of the order status column
SELECT order_status, CONCAT(UPPER(LEFT(order_status, 1)), LOWER(SUBSTRING(order_status, 2))) AS status
FROM orders_lagging;

UPDATE orders_lagging
SET order_status = CONCAT(UPPER(LEFT(order_status, 1)), LOWER(SUBSTRING(order_status, 2)));

SELECT *
FROM orders_lagging;

ALTER TABLE orders_lagging
ADD COLUMN order_purchase_date DATE,
ADD COLUMN order_purchase_time TIME;

UPDATE orders_lagging
SET order_purchase_date = STR_TO_DATE(TRIM(SUBSTRING(order_purchase_timestamp, 1, 10)), '%Y-%m-%d'),
order_purchase_time = STR_TO_DATE(TRIM(SUBSTRING(order_purchase_timestamp, 12, 8)), '%H:%i:%s');

ALTER TABLE orders_lagging
DROP COLUMN order_purchase_timestamp;

ALTER TABLE orders_lagging
ADD order_approved_date DATE,
ADD order_approved_time TIME;

UPDATE orders_lagging
SET order_approved_date = STR_TO_DATE(TRIM(SUBSTRING(order_approved_at, 1, 10)), '%Y-%m-%d'),
order_approved_time = STR_TO_DATE(TRIM(SUBSTRING(order_approved_at, 12, 8)), '%H:%i:%s')
WHERE order_approved_at IS NOT NULL
AND TRIM(order_approved_at) != '';

SELECT *
FROM orders_lagging;

ALTER TABLE orders_lagging
ADD order_delivered_carrier_date1 DATE,
ADD order_delivered_carrier_time TIME;

UPDATE orders_lagging
SET order_delivered_carrier_date1 = STR_TO_DATE(TRIM(SUBSTRING(order_delivered_carrier_date, 1, 10)), '%Y-%m-%d'),
order_delivered_carrier_time = STR_TO_DATE(TRIM(SUBSTRING(order_delivered_carrier_date, 12, 8)), '%H:%i:%s')
WHERE order_delivered_carrier_date IS NOT NULL
AND TRIM(order_delivered_carrier_date) != '';

ALTER TABLE orders_lagging
DROP COLUMN order_approved_at,
DROP COLUMN order_delivered_carrier_date;

SELECT *
FROM orders_lagging;

ALTER TABLE orders_lagging
ADD order_delivered_customer_date1 DATE,
ADD order_delivered_customer_time TIME;

UPDATE orders_lagging
SET order_delivered_customer_date1 = STR_TO_DATE(TRIM(SUBSTRING(order_delivered_customer_date, 1, 10)), '%Y-%m-%d'),
order_delivered_customer_time = STR_TO_DATE(TRIM(SUBSTRING(order_delivered_customer_date, 12, 8)), '%H:%i:%s')
WHERE order_delivered_customer_date IS NOT NULL
AND TRIM(order_delivered_customer_date) != '';

SELECT order_delivered_customer_date,
order_delivered_customer_time
FROM orders_lagging
WHERE order_delivered_customer_date = NULL;
-- blank or null rows were not found

ALTER TABLE orders_lagging
DROP COLUMN order_delivered_customer_date;

ALTER TABLE orders_lagging
ADD order_estimated_delivery_date1 DATE;

UPDATE orders_lagging
SET order_estimated_delivery_date1 = STR_TO_DATE(TRIM(SUBSTRING(order_estimated_delivery_date, 1, 10)), '%Y-%m-%d');

ALTER TABLE orders_lagging
DROP COLUMN order_estimated_delivery_date;

-- changing the names of the new column to those of the original in schemas

SELECT *
FROM orders_lagging;
