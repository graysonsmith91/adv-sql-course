-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table

CREATE OR REPLACE PROCEDURE update_vehicle(IN vehicleId int)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE vehicles
    SET is_sold = true
    WHERE vehicle_id = vehicleId;
   
    COMMIT;
END
$$;

CALL update_vehicle(1); 

DROP PROCEDURE update_vehicle(integer)

SELECT * FROM vehicles v 



-- Carnival would also like to handle the case for when a car gets returned by a customer. When this occurs they must add 
-- the car back to the inventory and mark the original sales record as sale_returned = TRUE

CREATE OR REPLACE PROCEDURE return_vehicle(IN vehicle_id int, OUT status varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE sales s
    SET s.sale_returned = true
    WHERE s.vehicle_id = vehicle_id;
   
    status := 'Vehicle returned';
  
    COMMIT;
END
$$;

