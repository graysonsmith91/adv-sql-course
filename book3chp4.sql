-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table

CREATE PROCEDURE update_vehicle(IN vehicle_id int, INOUT b varchar)
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE vehicles v
    SET v.is_sold = true
    WHERE v.vehicle_id = vehicle_id;
   
   status := 'Vehicle sold';
  
  COMMIT;

END
$$;


