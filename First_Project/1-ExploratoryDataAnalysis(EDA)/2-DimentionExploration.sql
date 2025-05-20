-- Explore all countries our customers come from.

SELECT DISTINCT Country FROM gold.dim_customers

-- Explore all categories 'the major Division'.

SELECT DISTINCT Category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3
