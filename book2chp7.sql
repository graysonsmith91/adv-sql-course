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

