-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?

SELECT 
	d.state,
	COUNT(s.employee_id) AS num_customers
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
WHERE s.sales_type_id = 1
GROUP BY d.state 
ORDER BY num_customers DESC 
LIMIT 5;
