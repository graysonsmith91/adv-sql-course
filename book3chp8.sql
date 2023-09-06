-- Adding 5 brand new 2021 Honda CR-Vs to the inventory. They have I4 engines and are classified as a Crossover SUV or CUV. 
-- All of them have beige interiors but the exterior colors are Lilac, Dark Red, Lime, Navy and Sand. The floor price is $21,755 and the MSR price is $18,999.

do $$ 
DECLARE 
  NewVehicleTypeId integer;

-- Insert into vehicletypes Honda CR-V
 
BEGIN
  INSERT INTO
    vehicletypes(body_type, make, model)
  VALUES
    ('CUV', 'Honda', 'CR-V') RETURNING vehicle_type_id INTO NewVehicleTypeId;  
   
-- Insert into vehicles 
   
  INSERT INTO
    vehicles(vin, engine_type, vehicle_type_id, exterior_color, interior_color, floor_price, msr_price, miles_count, year_of_car, is_sold, is_new, dealership_location_id)
  VALUES
    ('XM1NC3WF3F0973902', 'I4', NewVehicleTypeId, 'Lilac', 'Beige', 21755, 18999, 5000, 2021, FALSE, TRUE, 1),
	('IM1NC6JF3L0973979', 'I4', NewVehicleTypeId, 'Dark Red', 'Beige', 21755, 18999, 5000, 2021, FALSE, TRUE, 1),
    ('XL1NC2NF3H0974907', 'I4', NewVehicleTypeId, 'Lime', 'Beige', 21755, 18999, 5000, 2021, FALSE, TRUE, 1),
    ('XM1RC8JF3F0973509', 'I4', NewVehicleTypeId, 'Navy', 'Beige', 21755, 18999, 5000, 2021, FALSE, TRUE, 1),
    ('XM1MC9EF3P0973503', 'I4', NewVehicleTypeId, 'Sand', 'Beige', 21755, 18999, 5000, 2021, FALSE, TRUE, 1);
   
END;

$$ language plpgsql;