-- Example

CREATE VIEW employee_dealership_names AS
  SELECT 
    e.first_name,
    e.last_name,
    d.business_name
  FROM employees e
  INNER JOIN dealershipemployees de ON e.employee_id = de.employee_id
  INNER JOIN dealerships d ON d.dealership_id = de.dealership_id;
  
 SELECT
	*
FROM
	employee_dealership_names;



-- Create a view that lists all vehicle body types, makes and models.
-- I added engine type to do a join

CREATE VIEW	vehicle_info AS 
	SELECT 
		v.engine_type, vt.body_type, vt.make, vt.model  
	FROM vehicles v 
	LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
	
SELECT * FROM vehicle_info



-- Create a view that shows the total number of employees for each employee type.

CREATE VIEW num_employeeTypes AS
	SELECT DISTINCT 
		et.employee_type_name,
		COUNT(e.employee_type_id) OVER(PARTITION BY e.employee_type_id) num_employees
	FROM employees e 
	LEFT JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
	ORDER BY num_employees DESC;

SELECT * FROM num_employeeTypes 



-- Create a view that lists all customers without exposing their emails, phone numbers and street address.

CREATE VIEW vw_customers_masked AS 
	SELECT 
		c.customer_id,
		c.first_name,
		c.last_name,
		c.city,
		c.state,
		c.zipcode,
		c.company_name
	FROM customers c
	
SELECT * FROM vw_customers_masked 



-- Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.

CREATE VIEW	vw_2018_sales AS
	SELECT DISTINCT 
		st.sales_type_name,
		COUNT(s.sales_type_id) OVER(PARTITION BY s.sales_type_id) num_sales
	FROM sales s 
	LEFT JOIN salestypes st ON st.sales_type_id = s.sales_type_id  
	WHERE s.purchase_date >= '2018-01-01' AND s.purchase_date <= '2018-12-31'

SELECT * FROM vw_2018_sales



-- Create a view that shows the employee at each dealership with the most number of sales.

CREATE VIEW top_employees AS

	WITH employee_sales AS
	(
		SELECT
			business_name,
			e.first_name || ' ' || e.last_name full_name,
			COUNT(*) num_sales,
			RANK() OVER (PARTITION BY business_name ORDER BY COUNT(*) DESC) AS sales_rank
		FROM sales s 
		LEFT JOIN employees e ON e.employee_id = s.employee_id 
		LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
		GROUP BY d.business_name, full_name, s.employee_id, s.dealership_id 
		ORDER BY d.business_name, num_sales DESC
	)
	
	SELECT 
		business_name,
		full_name,
		num_sales
	FROM employee_sales
	WHERE sales_rank = 1;

SELECT * FROM top_employees
