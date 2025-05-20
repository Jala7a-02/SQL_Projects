-- Which category contributes the most to overall sales?
WITH overall_sales AS (
SELECT
	p.category,
	SUM(f.sales_amount) AS total_sales 
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL
GROUP BY p.category)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(ROUND((CAST((total_sales) AS float) / SUM(total_sales) OVER () ) * 100,2),'%') AS percent_of_total
FROM overall_sales
ORDER BY total_sales DESC
/*
the bikes category contributes about 96% of the total company sales
meaning the company over-relays on this category
thus any damage or deacrease in this category will affect the company massively
*/