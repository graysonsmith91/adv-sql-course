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