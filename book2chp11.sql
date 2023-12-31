-- How many employees are there for each role?

SELECT DISTINCT 
	et.employee_type_name, 
	COUNT(e.employee_type_id) OVER(PARTITION BY e.employee_type_id) employee_type_count 
FROM employees e 
LEFT JOIN employeetypes et ON et.employee_type_id  = e.employee_type_id 
ORDER BY et.employee_type_name;



-- How many finance managers work at each dealership?

SELECT DISTINCT 
	d.business_name, 
	COUNT(e.employee_type_id) OVER(PARTITION BY d.dealership_id) fm_per_dealership
FROM employees e 
LEFT JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
LEFT JOIN dealershipemployees de ON de.employee_id = e.employee_id 
LEFT JOIN dealerships d ON d.dealership_id = de.dealership_id 
WHERE et.employee_type_name = 'Finance Manager'
ORDER BY d.business_name;



-- Get the names of the top 3 employees who work shifts at the most dealerships?

SELECT DISTINCT 
	e.first_name || ' ' || e.last_name full_name,
	COUNT(de.employee_id) OVER(PARTITION BY	de.employee_id) num_jobs
FROM dealershipemployees de
LEFT JOIN dealerships d ON d.dealership_id = de.dealership_id 
LEFT JOIN employees e ON e.employee_id = de.employee_id 
ORDER BY num_jobs DESC
LIMIT 3;



-- Get a report on the top two employees who has made the most sales through leasing vehicles.

SELECT DISTINCT 
	e.first_name || ' ' || e.last_name full_name,
	SUM(s.price) OVER(PARTITION BY e.employee_id) total_lease_sales
FROM sales s 
LEFT JOIN employees e ON e.employee_id = s.employee_id 
WHERE s.sales_type_id = 2
ORDER BY total_lease_sales DESC
LIMIT 2;







