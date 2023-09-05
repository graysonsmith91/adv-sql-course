-- Our first step is to define our trigger function. The keyword NEW allows us to access the data in the newly inserted row.

CREATE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET pickup_date = NEW.purchase_date + integer '7'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$

-- Now that our trigger function has been defined, let's bind it to the Sales table. Note that we are defining our trigger 
-- to automatically execute after each insert into the Sales table.

CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();
  
 SELECT * FROM sales s 
 
INSERT INTO Sales (sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES
  (1, 1, 1, 1, 1, 15000.00, 2000.00, '2023-09-01', '2023-09-10', 'INV12345', 'Credit Card', false);

 
 
-- Create a trigger for when a new Sales record is added, set the purchase date to 3 days from the current date.
 
 CREATE FUNCTION set_purchase_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET purchase_date = current_date + integer '3'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$
 

CREATE TRIGGER new_sale_made_purchase_date
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_purchase_date();
 
 
 INSERT INTO Sales (sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES
  (1, 1, 1, 1, 1, 25000.00, 2000.00, '2023-09-05', '2023-09-10', 'INV123456', 'Credit Card', false);
 
 
 
 
 
 
