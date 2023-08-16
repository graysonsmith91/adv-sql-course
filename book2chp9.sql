-- Window function example

select distinct
	employees.last_name || ', ' || employees.first_name employee_name,
	sales.employee_id,
	sum(sales.price) over() total_sales,
	sum(sales.price) over(partition by employees.employee_id) total_employee_sales
from
	employees
join
	sales
on
	sales.employee_id = employees.employee_id
order by employee_name



-- Write a query that shows the total purchase sales income per dealership.

SELECT DISTINCT 
	d.business_name,
	SUM(s.price) over(PARTITION BY d.dealership_id) total_dealership_sales 
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1
ORDER BY d.business_name;






