-- Because Carnival is a single company, we want to ensure that there is consistency in the data provided to the user. 
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
-- Therefore, any time a new dealership is added or an existing dealership is updated, we want to ensure that the website 
-- URL has the following format: http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

CREATE FUNCTION set_dealership_url() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
--  UPDATE dealerships 
--  SET website = http://www.carnivalcars.com/{name of the dealership with underscores separating words}
--  WHERE dealership_id = NEW.dealership_id;
	
	NEW.website = 'http://www.carnivalcars.com/' || replace(LOWER(NEW.business_name), ' ', '_')
  	RETURN NEW;	
  --RETURN NULL;
END;
$$


CREATE TRIGGER new_dealership_url
  AFTER INSERT
  ON dealership
  FOR EACH ROW
  EXECUTE PROCEDURE set_dealership_url();
  
 SELECT * FROM dealerships
 
INSERT INTO Sales (sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES
  (1, 1, 1, 1, 1, 15000.00, 2000.00, '2023-09-01', '2023-09-10', 'INV12345', 'Credit Card', false);
  
 
 
 