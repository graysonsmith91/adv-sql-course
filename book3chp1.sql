-- UPDATE statement to change a customer
UPDATE  public.customers
SET email = 'juliasmith@gmail.com'
WHERE customer_id = 67;



-- Kristopher Blumfield an employee of Carnival has asked to be transferred to a different dealership location. 
-- She is currently at dealership 9. She would like to work at dealership 20. Update her record to reflect her transfer.

SELECT * FROM employees e 
LEFT JOIN dealershipemployees de ON de.dealership_employee_id = e.employee_id 
WHERE de.employee_id = 9

UPDATE dealershipemployees
SET dealership_id = 20
WHERE employee_id = 9

