CREATE TABLE items_lagging LIKE olist_order_items_dataset;

INSERT INTO items_lagging
SELECT *
FROM olist_order_items_dataset;

SELECT *
FROM items_lagging;

-- checking for duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_item_id, product_id, shipping_limit_date,
 price, freight_value) AS row_num
FROM items_lagging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, order_item_id ORDER BY order_id) AS row_num
FROM items_lagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- no duplicate rows were found in this table

-- the shipping limit date column is a combination of both date and time, so splitting of the column is required
ALTER TABLE items_lagging
ADD shipping_limit_date2 DATE,
ADD shipping_limit_time TIME;

UPDATE items_lagging
SET shipping_limit_date2 = STR_TO_DATE(TRIM(SUBSTRING(shipping_limit_date, 1, 10)), '%Y-%m-%d'),
    shipping_limit_time = STR_TO_DATE(TRIM(SUBSTRING(shipping_limit_date, 12, 8)), '%H:%i:%s');

-- dropping the old shipping_limit_date column
ALTER TABLE items_lagging
DROP COLUMN shipping_limit_date;
-- going to schemas to change the new shipping_limit_date name to the original

-- change the decimal places of the price and freight value column
ALTER TABLE items_lagging
MODIFY price DECIMAL(10,2);

ALTER TABLE items_lagging
MODIFY freight_value DECIMAL(10,2);

SELECT *
FROM items_lagging;

SELECT *
FROM items_lagging;