-- Use a self join to list all sales that will be picked up on the same day,
-- including the full name of customer picking up the vehicle.
SELECT
    CONCAT  (c.first_name, ' ', c.last_name) AS last_name,
    s1.invoice_number,
    s1.pickup_date
FROM sales s1
INNER JOIN sales s2
    ON s1.sale_id <> s2.sale_id 
    AND s1.pickup_date = s2.pickup_date
INNER JOIN customers c
   ON c.customer_id = s1.customer_id
GROUP BY c.first_name, c.last_name, s1.invoice_number, s1.pickup_date
ORDER BY s1.pickup_date;



-- Get employees and customers who have interacted through a sale.
-- Include employees who may not have made a sale yet.
-- Include customers who may not have completed a purchase.
SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name
FROM employees e
FULL OUTER JOIN sales s ON e.employee_id = s.employee_id
FULL OUTER JOIN customers c ON s.customer_id = c.customer_id;



-- Get a list of all dealerships and which roles each of the employees hold.
SELECT
    d.business_name,  
    e.first_name, 
    et.employee_type_name 
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON de.employee_id = e.employee_id
RIGHT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
ORDER BY d.business_name;



-- Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT 
    d.business_name,
    COUNT(CASE WHEN s.sales_type_id = 1 THEN 1 ELSE NULL END) AS number_of_purchases,
    COUNT(CASE WHEN s.sales_type_id = 2 THEN 1 ELSE NULL END) AS number_of_leases
FROM dealerships d
LEFT JOIN sales s ON s.dealership_id = d.dealership_id
GROUP BY d.business_name
ORDER BY d.business_name;



-- Produce a report that determines the most popular vehicle model that is leased.
SELECT 
	vt.model, 
	COUNT(vt.model) AS number_of_leases
FROM sales s 
LEFT JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE s.sales_type_id = 2
GROUP BY vt.model
ORDER BY number_of_leases DESC
LIMIT 1;



-- What is the most popular vehicle make in terms of number of sales?
SELECT 
	vt.make , 
	COUNT(vt.make) AS number_of_purchases
FROM sales s 
LEFT JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE s.sales_type_id = 1
GROUP BY vt.make
ORDER BY number_of_purchases DESC
LIMIT 1;

--NISSAN

-- Which employee type sold the most of that make?
SELECT 
	et.employee_type_name,
	vt.make,
	COUNT(vt.make) AS vehicles_sold
FROM sales s
LEFT JOIN employees e ON e.employee_id = s.employee_id 
LEFT JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
LEFT JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE vt.make = 'Nissan' AND s.sales_type_id = 1
GROUP BY vt.make, et.employee_type_name
ORDER BY vehicles_sold DESC
LIMIT 1;




