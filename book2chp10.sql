-- Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.

SELECT DISTINCT 
	vt.model,
	COUNT(vt.model) OVER(PARTITION BY vt.model) num_model
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE
ORDER BY num_model
LIMIT 1;



-- Which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.

SELECT DISTINCT 
	vt.model,
	COUNT(vt.model) OVER(PARTITION BY vt.model) num_model
FROM vehicles v 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE
ORDER BY num_model DESC
LIMIT 1;



-- Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.

SELECT DISTINCT 
	d.business_name,
	COUNT(s.sale_id) OVER(PARTITION BY d.dealership_id) num_sold_month
FROM sales s
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
WHERE s.purchase_date >= (DATE '2020-07-16' - INTERVAL '90 days')
ORDER BY num_sold_month; 







