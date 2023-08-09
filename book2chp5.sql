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
--SELECT
--    d.business_name,  
--    e.first_name, 
--    et.employee_type_name 
--FROM dealerships d
--LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
--INNER JOIN employees e ON de.employee_id = e.employee_id
--RIGHT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
--ORDER BY d.business_name;



