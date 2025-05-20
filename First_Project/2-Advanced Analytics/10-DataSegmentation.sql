/*
Segment products into cost ranges 
and count how many products fall into each segment
*/
WITH product_segment AS (
SELECT
	product_key,
	product_name,
	cost,
	CASE
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
		ELSE 'Above 1000'
	END AS cost_rang
FROM gold.dim_products)

SELECT
	cost_rang,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_rang
ORDER BY total_products DESC
----------------------------------------------------------------
/*
Group customers into three segments based on their spending beaviour
	- VIP : customers with at least 12 months of history and spending more than 5000
	- Regular : customers with at least 12 months of history and spending  5000 or less
	- New : customers with a life span less than 12 months
*/
WITH customer_spending AS (
SELECT
	c.customer_key,
	SUM(f.sales_amount) as total_spending,
	MIN(order_date) AS first_date,
	MAX(order_date) AS last_date,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key 
GROUP BY c.customer_key ),
customer_segment AS (
SELECT 
	customer_key,
	total_spending,
	life_span,
	CASE
		WHEN life_span > 12 AND total_spending > 5000 THEN 'VIP'
		WHEN life_span > 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS activity
FROM customer_spending )

SELECT 
	activity,
	count(*) AS total_customers
FROM customer_segment
GROUP BY activity
ORDER BY total_customers DESC