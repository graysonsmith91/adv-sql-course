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



-- A Sales associate needs to update a sales record because her customer want to pay with a Mastercard instead of JCB. 
-- Update Customer, Ernestus Abeau Sales record which has an invoice number of 9086714242.

SELECT * FROM sales s 
LEFT JOIN customers c ON c.customer_id = s.customer_id 
WHERE s.invoice_number = '9086714242'

UPDATE sales
SET payment_method = 'mastercard'
WHERE invoice_number = '9086714242'




