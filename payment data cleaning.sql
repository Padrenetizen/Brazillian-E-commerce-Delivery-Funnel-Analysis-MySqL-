CREATE TABLE payment_lagging LIKE olist_order_payments_dataset;

INSERT INTO payment_lagging
SELECT *
FROM olist_order_payments_dataset;

SELECT *
FROM payment_lagging;

-- checking for duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, payment_sequential, payment_installments) AS row_num
FROM payment_lagging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, payment_sequential, payment_installments) AS row_num
FROM payment_lagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- no duplicate values were found in this table

SELECT *
FROM payment_lagging;

SELECT payment_type, REPLACE(payment_type, '_', ' ') AS payment
FROM payment_lagging;

UPDATE payment_lagging
SET payment_type = REPLACE(payment_type, '_', ' ');

SELECT payment_type, CONCAT(UPPER(LEFT(payment_type, 1)), LOWER(SUBSTRING(payment_type, 2))) AS payment
FROM payment_lagging;

UPDATE payment_lagging
SET payment_type = CONCAT(UPPER(LEFT(payment_type, 1)), LOWER(SUBSTRING(payment_type, 2)));

-- changing the decimal places
ALTER TABLE payment_lagging
MODIFY payment_value DECIMAL(10,2);

SELECT DISTINCT payment_type
FROM payment_lagging;

-- checking for blanks or null
SELECT payment_value
FROM payment_lagging
WHERE payment_value = '';
-- blanks were not found in this table

SELECT *
FROM payment_lagging;