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

