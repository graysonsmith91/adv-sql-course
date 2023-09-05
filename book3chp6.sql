-- Because Carnival is a single company, we want to ensure that there is consistency in the data provided to the user. 
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
-- Therefore, any time a new dealership is added or an existing dealership is updated, we want to ensure that the website 
-- URL has the following format: http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

CREATE FUNCTION set_dealership_url() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
	NEW.website = 'http://www.carnivalcars.com/' || replace(LOWER(NEW.business_name), ' ', '_');
  	RETURN NEW;	
END;
$$


CREATE OR REPLACE TRIGGER new_dealership_url
  BEFORE INSERT OR UPDATE 
  ON dealerships
  FOR EACH ROW
  EXECUTE PROCEDURE set_dealership_url();
  

SELECT * FROM dealerships
 
-- Insert working correctly
INSERT INTO dealerships (business_name, phone, city, state, tax_id)
VALUES
  ('Testing This New One', '123-123-1234', 'Nashville', 'Tennessee', 'qq-916-uz-btt2');
  
-- Update working correctly
UPDATE dealerships
SET business_name = 'Povlsen Autos of Ohio'
WHERE business_name = 'Updated Dealership Name';



-- If a phone number is not provided for a new dealership, set the phone number to the default customer care number 777-111-0305.
 
CREATE OR REPLACE FUNCTION set_phone_default() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
	IF NEW.phone IS NULL THEN
    	NEW.phone = '777-111-0305';
  	END IF;
	
  	RETURN NEW;	
END;
$$


CREATE OR REPLACE TRIGGER new_dealership_phone_default
  BEFORE INSERT OR UPDATE 
  ON dealerships
  FOR EACH ROW
  EXECUTE PROCEDURE set_phone_default();
  
INSERT INTO dealerships (business_name, phone, city, state, tax_id)
VALUES
  ('Testing 4', '123-456-7890', 'Nashville', 'Tennessee', 'qq-916-uz-btt2');
 
SELECT * FROM dealerships




 
 