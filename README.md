## Brazilian E-Commerce Delivery Funnel Analysis (MySQL)

## Project Overview

This project analyzes customer order fulfillment using the **Brazilian E-Commerce Public Dataset by Olist** from Kaggle.

The objective was to build a **Delivery Funnel Analysis** in MySQL to track how customers move from placing an order to successfully receiving their package.

This project highlights operational performance and identifies drop-offs between payment, approval, and delivery stages.

---

## Business Problem

In e-commerce, revenue doesn’t end at payment — it ends at Successful delivery.

This analysis answers:

How many customers complete purchases?
How many orders are approved?
How many orders are successfully delivered?
What percentage of customers do not receive their packages?
What is the percentage of high value customers
Where is the biggest drop-off in the fulfillment process?

---

## Funnel Stages

The funnel was structured as:

Total Customers
Customers With Approved Payments
Purchase Delivered
Orders Delivered
Orders Not Delivered (Canceled / Unavailable)

Each stage was calculated using SQL aggregations and combined using `UNION ALL` for a consolidated funnel output.

---

## Tools Used

* MySQL
* SQL (CTEs, Joins, Aggregations)
* CSV data import
* Git & GitHub

---

## SQL Techniques Demonstrated

* `COUNT(DISTINCT customer_id)`
* `USING` across customers, orders, and payments tables
* `CASE WHEN order_status = 'delivered'`
* Funnel construction using `UNION ALL`
* Conversion rate calculation
* Drop-off percentage analysis

---

## Example Funnel Logic

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
---

## Key Insights

* Delivery success rate
* Percentage of customers who did not receive their orders
* Operational drop-off between approval and fulfillment
* Fulfillment efficiency measurement

---

## Business Value

This project demonstrates how SQL can be used to:

* Monitor operational efficiency
* Evaluate logistics performance
* Identify potential customer dissatisfaction risks
* Support decision-making for supply chain improvements

---

## Future Improvements

* Segment delivery success by state
* Analyze late vs on-time deliveries
* Payment method vs delivery success comparison
* Build a Power BI or Tableau dashboard

---
  
## Author

**Paul Ojame**
Aspiring Business Intelligence Analyst
Skilled in SQL, Funnel Analysis, and Data Visualization
