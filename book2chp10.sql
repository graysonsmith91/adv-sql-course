-- Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.

SELECT DISTINCT 
	vt.model,
	COUNT(vt.model) OVER(PARTITION BY vt.model) num_model
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE
ORDER BY num_model
LIMIT 1;