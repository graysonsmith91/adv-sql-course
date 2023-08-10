-- This query finds all sales with the price lower than average

SELECT 
	sale_id,
	sales_type_id,
	vehicle_id, 
	price
FROM sales
WHERE price < (SELECT avg(price) FROM sales);

SELECT * FROM sales s 


