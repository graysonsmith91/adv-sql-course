-- DELETE statement to delete one specific record:
DELETE FROM sales WHERE sales.sale_id = 100;



-- A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer, last minute 
-- decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '2436217483'.

SELECT * FROM sales s 
WHERE s.invoice_number = '2436217483'

DELETE FROM sales WHERE sales.invoice_number = '2436217483'