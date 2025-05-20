/*
analyze the yearly performance of products by comparing
each product's sales to both its average sales performance and previous year's sales
*/
WITH yearly_performance AS(
SELECT
	YEAR(f.order_date) AS order_date,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY
	YEAR(f.order_date),
	p.product_name)
SELECT
	order_date,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS avg_diff,
	CASE
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS diff_flag,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS years_diff,
	CASE
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) > 0 THEN 'increasing'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) < 0 THEN 'decreasing'
		ELSE 'no changes'
	END AS previous_year_changes
FROM yearly_performance
ORDER BY product_name, order_date
