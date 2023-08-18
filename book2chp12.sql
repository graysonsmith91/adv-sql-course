-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?

SELECT 
	c.state,
	COUNT(s.customer_id) AS num_customers
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
LEFT JOIN customers c ON c.customer_id = s.customer_id 
WHERE s.sales_type_id = 1
GROUP BY c.state 
ORDER BY num_customers DESC 
LIMIT 5;



-- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?

SELECT 
	c.zipcode,
	COUNT(s.customer_id) AS num_customers
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
LEFT JOIN customers c ON c.customer_id = s.customer_id 
WHERE s.sales_type_id = 1
GROUP BY c.zipcode
ORDER BY num_customers DESC 
LIMIT 5;

