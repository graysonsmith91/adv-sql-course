-- Who are the top 5 employees for generating sales income?

SELECT DISTINCT 
	e.first_name || ' ' || e.last_name employee_name,
	SUM(s.price) OVER(PARTITION BY s.employee_id) total_sales
FROM sales s 
LEFT JOIN employees e ON e.employee_id = s.employee_id 
ORDER BY total_sales DESC
LIMIT 5;



-- Who are the top 5 dealership for generating sales income?

SELECT DISTINCT 
	d.business_name,
	SUM(s.price) OVER(PARTITION BY s.dealership_id) total_sales
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
ORDER BY total_sales DESC
LIMIT 5;



-- Which vehicle model generated the most sales income?

SELECT DISTINCT 
	vt.model,
	SUM(s.price) OVER(PARTITION BY vt.model) total_sales
FROM sales s 
LEFT JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
ORDER BY total_sales DESC 
LIMIT 1;



-- Which employees generate the most income per dealership?

WITH employee_sales AS
	(
		SELECT
			business_name,
			e.first_name || ' ' || e.last_name full_name,
			SUM(s.price) total_sales,
			RANK() OVER (PARTITION BY d.business_name ORDER BY SUM(s.price) DESC) AS sales_rank
			--RANK() OVER (PARTITION BY d.business_name, s.employee_id ORDER BY SUM(s.price) DESC) AS sales_rank
		FROM sales s 
		LEFT JOIN employees e ON e.employee_id = s.employee_id 
		LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
		GROUP BY d.business_name, full_name, s.employee_id, s.dealership_id 
		ORDER BY d.business_name, total_sales DESC
	)
	
	SELECT 
		business_name,
		full_name,
		total_sales
	FROM employee_sales
	WHERE sales_rank = 1;



-- In our Vehicle inventory, show the count of each Model that is in stock.

SELECT DISTINCT 
	vt.model,
	COUNT(vt.model) OVER(PARTITION BY vt.model) AS num_in_stock
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE 
ORDER BY num_in_stock DESC;



-- In our Vehicle inventory, show the count of each Make that is in stock.

SELECT DISTINCT 
	vt.make,
	COUNT(vt.make) OVER(PARTITION BY vt.make) AS num_in_stock
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE 
ORDER BY num_in_stock DESC;



-- In our Vehicle inventory, show the count of each BodyType that is in stock.

SELECT DISTINCT 
	vt.body_type,
	COUNT(vt.body_type) OVER(PARTITION BY vt.body_type) AS num_in_stock
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE 
ORDER BY num_in_stock DESC;


