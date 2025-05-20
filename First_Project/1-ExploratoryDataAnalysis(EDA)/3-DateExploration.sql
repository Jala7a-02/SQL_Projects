-- finding the date of the first and last order
-- how many years of sales available

SELECT 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_year
from gold.fact_sales


-- finding the youngest and oldest customers

SELECT
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS oldest_customer,
	MAX(birthdate) AS youngest_birthday,
	DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS youngest_customer
FROM gold.dim_customers