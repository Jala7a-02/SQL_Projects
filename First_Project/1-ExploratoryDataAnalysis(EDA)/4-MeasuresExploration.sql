-- Finding the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Finding how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Finding the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales


-- Finding the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Finding the total number of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products

-- Finding the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Finding the total number of customers the has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales


------------------------------------------------------------------
-- Generate a report that shows all key metrics of the business --
------------------------------------------------------------------

SELECT 'total sales' AS measure_name ,SUM(sales_amount) AS measure_vlaue FROM gold.fact_sales
UNION ALL
SELECT 'total quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'average price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total Nr. orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'total Nr. ptoducts', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'total Nr. customers', COUNT(customer_key) FROM gold.dim_customers