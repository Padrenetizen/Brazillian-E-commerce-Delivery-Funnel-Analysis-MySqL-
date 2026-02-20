USE brazillian_ecommerce;

CREATE TABLE brazillian_lagging LIKE  olist_customers_dataset;

INSERT INTO brazillian_lagging
SELECT *
FROM olist_customers_dataset;

SELECT *
FROM brazillian_lagging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_id, customer_unique_id, customer_city) AS row_num
FROM brazillian_lagging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_unique_id, customer_city) AS row_num
FROM brazillian_lagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `brazillian_lagging2` (
  `customer_id` text,
  `customer_unique_id` text,
  `customer_zip_code_prefix` text,
  `customer_city` text,
  `customer_state` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO brazillian_lagging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_unique_id, customer_city) AS row_num
FROM brazillian_lagging;

SELECT *
FROM brazillian_lagging2
WHERE row_num > 1;

DELETE
FROM brazillian_lagging2
WHERE row_num > 1;
-- 3222 duplicate rows were removed

SELECT *
FROM brazillian_lagging2;

-- fixing the letter case
SELECT customer_city, CONCAT(UPPER(LEFT(customer_city, 1)), LOWER(SUBSTRING(customer_city, 2))) city_name
FROM brazillian_lagging2;

UPDATE brazillian_lagging2
SET customer_city = CONCAT(UPPER(LEFT(customer_city, 1)), LOWER(SUBSTRING(customer_city, 2)));

ALTER TABLE brazillian_lagging2
DROP COLUMN row_num;

SELECT *
FROM brazillian_lagging2;