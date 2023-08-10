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