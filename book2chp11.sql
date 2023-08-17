-- How many employees are there for each role?

SELECT DISTINCT 
	et.employee_type_name, 
	COUNT(e.employee_type_id) OVER(PARTITION BY e.employee_type_id) employee_type_count 
FROM employees e 
LEFT JOIN employeetypes et ON et.employee_type_id  = e.employee_type_id 
ORDER BY et.employee_type_name;