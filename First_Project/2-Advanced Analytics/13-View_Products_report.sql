/*
=======================================================================
Product Report
=======================================================================
Perpose:
	- This Report consolidate key product metrics and behaviors

Highlights:
	1. Gather essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-performance, Mid-performance and Low-performance.
	3. Aggregate product-level metrics :
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculate valuable KPIs:
		- recency (month since last sale)
		- average order revenue(AOR)
		- average monthly revenue
*/
CREATE VIEW gold.product_report AS
WITH base_query AS (
/*
=============================================================
1) Base Query: Retrive core columns from tables
==========================================================
*/
SELECT
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE f.order_date IS NOT NULL)
, product_aggregation AS (
/*=======================================================================
product Aggregations: Summarize key metrics at the customer level
=========================================================================*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost)
/*=============================================================
3) Final Query: Combine all product results into one output
===============================================================*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH,last_sale_date,GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High Performance'
		WHEN total_sales BETWEEN 10000 AND 50000 THEN 'Mid Performance'
		ELSE 'Low Performance'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- average order revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders

		END AS avg_order_revenue,
	
	-- average monthly Revenue
	CASE 
		WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregation