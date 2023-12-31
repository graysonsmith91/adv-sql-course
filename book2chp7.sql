-- First, you can create a CTE to get cars that require an oil change service.

with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v

	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
)



-- Once that is defined, you can now query that set of results as part of a larger query to get all of the information needed.

select
	vs.vehicle_id,
	vs.miles_count,
	s.purchase_date,
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs -- Use the CTE
join sales s
	on s.vehicle_id  = vs.vehicle_id
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
order by
	vs.vehicle_id,
	s.purchase_date desc
;



-- Since multiple people can purchase the same car over time, the service manager only wants the last purchaser. You can break 
-- this part of the SQL out into another CTE. You can use multiple CTEs as part of the query. You separate them with a comma.

with vehicles_needing_service as
(
	select
		v.vehicle_id,
		v.year_of_car,
		v.miles_count,
		TO_CHAR(o.date_occured, 'YYYY-MM-DD') date_of_last_change
	from vehicles v

	join oilchangelogs o
		on v.vehicle_id = o.vehicle_id
	where o.date_occured < '2022-01-01'
),
last_purchase as (
	select
		s.vehicle_id,
		max(s.purchase_date) purchased
	from sales s
	group by s.vehicle_id
)



-- Now you have another CTE that can be used to filter down the results to get the info about the last purchase only.

select
	vs.vehicle_id,       -- Get vehicle id from first CTE
	vs.miles_count,      -- Get miles from first CTE
	lp.purchased,        -- Get purchase date from second CTE
	e.first_name || ' ' || e.last_name seller,
	c.first_name || ' ' || c.last_name purchaser,
	c.email
from vehicles_needing_service vs
join last_purchase lp   -- Join the second CTE
	on lp.vehicle_id  = vs.vehicle_id
join sales s
	on lp.vehicle_id = s.vehicle_id
	and lp.purchased = s.purchase_date
join employees e
	on s.employee_id = e.employee_id
join customers c
	on s.customer_id = c.customer_id
;


-- Top 5 dealerships by sales

SELECT
	d.dealership_id,
	d.business_name,
	COUNT(d.business_name) AS number_of_sales
FROM sales s
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
GROUP BY d.dealership_id
ORDER BY number_of_sales DESC; 



-- For the top 5 dealerships, which employees made the most sales?

WITH top_5_dealerships AS 
(
    SELECT
        d.dealership_id,
        d.business_name,
        COUNT(s.sale_id) AS number_of_sales
    FROM sales s
    LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
    GROUP BY d.dealership_id, d.business_name
    ORDER BY number_of_sales DESC
    LIMIT 5
)

SELECT
    t5.business_name,
    e.first_name || ' ' || e.last_name full_name,
    COUNT(s.sale_id) AS employee_sales
FROM top_5_dealerships t5
JOIN sales s ON s.dealership_id = t5.dealership_id
JOIN employees e ON e.employee_id = s.employee_id 
WHERE s.sales_type_id = 1
GROUP BY t5.business_name, e.first_name, e.last_name  
ORDER BY t5.business_name, employee_sales DESC;



-- Same as above but showing top 1 for each business but using a window function

WITH ranked AS 

(			  
SELECT 
	business_name,
	model,
	COUNT(*) AS total_sales,
	ROW_NUMBER() OVER(PARTITION BY business_name ORDER BY COUNT(*) DESC) AS model_rank	
FROM sales
	LEFT JOIN vehicles USING(vehicle_id)
	LEFT JOIN vehicletypes USING(vehicle_type_id)
	LEFT JOIN dealerships USING(dealership_id)
WHERE dealership_id IN 
	(SELECT dealership_id 
	FROM sales
	GROUP BY dealership_id
	ORDER BY COUNT(*) DESC
	LIMIT 5)
GROUP BY business_name, model
)

SELECT *
FROM ranked
WHERE model_rank = 1 
ORDER BY business_name, model_rank;



-- For the top 5 dealerships, which vehicle models were the most popular in sales?

WITH top_5_dealerships AS 
(
    SELECT
        d.dealership_id,
        d.business_name,
        COUNT(s.sale_id) AS number_of_sales
    FROM sales s
    LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
    GROUP BY d.dealership_id, d.business_name
    ORDER BY number_of_sales DESC
    LIMIT 10
)

SELECT 
	d.business_name,
	vt.model,
	COUNT(vt.model) AS count_of_model
FROM top_5_dealerships t5
LEFT JOIN dealerships d ON d.dealership_id = t5.dealership_id
LEFT JOIN sales s ON s.dealership_id = t5.dealership_id
LEFT JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
GROUP BY d.business_name, vt.model
ORDER BY d.business_name, count_of_model DESC;



-- For the top 5 dealerships, were there more sales or leases?

WITH top_5_dealerships AS 
(
    SELECT
        d.dealership_id,
        d.business_name,
        COUNT(s.sale_id) AS number_of_sales
    FROM sales s
    LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
    GROUP BY d.dealership_id, d.business_name
    ORDER BY number_of_sales DESC
    LIMIT 5
)

SELECT 
	d.business_name,
	COUNT(CASE WHEN s.sales_type_id = 1 THEN 1 ELSE NULL END) AS number_of_purchases,
    COUNT(CASE WHEN s.sales_type_id = 2 THEN 1 ELSE NULL END) AS number_of_leases,
    COUNT(CASE WHEN s.sales_type_id = 3 THEN 1 ELSE NULL END) AS number_of_rents
FROM top_5_dealerships t5
LEFT JOIN dealerships d ON d.dealership_id = t5.dealership_id
LEFT JOIN sales s ON s.dealership_id = t5.dealership_id
GROUP BY d.business_name;



-- For all used cars, which states sold the most? The least?

-- States with most sold

WITH used_cars AS 
(
	SELECT 
		* 
	FROM vehicles v 
	WHERE v.is_new = FALSE AND v.is_sold = TRUE
)

SELECT 
	d.state,
	COUNT(d.state) AS number_sold
FROM used_cars uc
LEFT JOIN sales s ON s.vehicle_id = uc.vehicle_id
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
GROUP BY d.state
ORDER BY number_sold DESC;

-- States with least sold

WITH used_cars AS 
(
	SELECT 
		* 
	FROM vehicles v 
	WHERE v.is_new = FALSE AND v.is_sold = TRUE
)

SELECT 
	d.state,
	COUNT(d.state) AS number_sold
FROM used_cars uc
LEFT JOIN sales s ON s.vehicle_id = uc.vehicle_id
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id 
GROUP BY d.state
ORDER BY number_sold ASC;



-- For all used cars, which model is greatest in the inventory? Which make is greatest inventory?

-- Model with greatest inventory 

WITH used_cars AS 
(
	SELECT 
		* 
	FROM vehicles v 
	WHERE v.is_new = FALSE AND v.is_sold = FALSE
)

SELECT
	vt.model,
	COUNT(vt.model) AS number_of_model
FROM used_cars uc
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = uc.vehicle_type_id
GROUP BY vt.model 
ORDER BY number_of_model DESC
LIMIT 1;

-- Make with greatest inventory

WITH used_cars AS 
(
	SELECT 
		* 
	FROM vehicles v 
	WHERE v.is_new = FALSE AND v.is_sold = FALSE
)

SELECT
	vt.make,
	COUNT(vt.make) AS number_of_make
FROM used_cars uc
LEFT JOIN vehicletypes vt ON vt.vehicle_type_id = uc.vehicle_type_id
GROUP BY vt.make 
ORDER BY number_of_make DESC
LIMIT 1;

