-- calculate the total sales per month
-- and the running total of sales over time
WITH total_sales_month AS
(
SELECT
	DATETRUNC(MONTH,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
)

-- Running Total Sales For all the Years
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg
FROM total_sales_month;

-- Running Total Sales For Each Year Indevidually
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS moving_avg
FROM (
SELECT
	DATETRUNC(MONTH,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
)t


-- an overall running total and moving average for all years
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER ( ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER ( ORDER BY order_date) AS moving_avg
FROM (
SELECT
	DATETRUNC(YEAR,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t