--1. Get a list of the sales that were made for each sales type.

SELECT 
	s.sale_id,
	st.sales_type_name 
FROM 
	sales s
LEFT JOIN salestypes st 
	ON	st.sales_type_id = s.sales_type_id 
ORDER BY 
	st.sales_type_name 


--2. Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, 
--   first name and last name of the employee who made the sale and the name, city and state of the dealership.
	
SELECT 
	v.vin,
	c.first_name AS customer_first_name,
	c.last_name AS customer_last_name,
	e.first_name AS employee_first_name,
	e.last_name AS employee_last_name,
	d.business_name AS dealership_name,
	d.city,
	d.state 
FROM 
	sales s
JOIN vehicles v ON	v.vehicle_id = s.vehicle_id 
JOIN customers c ON	c.customer_id = s.customer_id 
JOIN employees e ON	e.employee_id = s.employee_id 
JOIN dealerships d ON d.dealership_id = s.dealership_id 


--3. Get a list of all the dealerships and the employees, if any, working at each one.

SELECT 
	d.business_name AS dealership_name,
	e.first_name AS employee_first_name,
	e.last_name AS employee_last_name,
	de.employee_id
FROM 
	dealerships d
JOIN dealershipemployees de ON de.dealership_id = d.dealership_id 
JOIN employees e ON	e.employee_id = de.employee_id 
ORDER BY 
	d.business_name 


--4. Get a list of vehicles with the names of the body type, make, model and color.

--SELECT 
--	vt.body_type,
--	vt.make,
--	vt.model,
--	v.exterior_color 
--FROM 
--	vehicles v
--JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id  


	
	
	
	
	

