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



-- Write a query that shows the purchase sales income per dealership for July of 2020.

SELECT DISTINCT 
	d.business_name,
	SUM(s.price) over(PARTITION BY d.dealership_id) sales_per_month
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1 AND s.purchase_date >= '2020-07-01' AND s.purchase_date < '2020-08-01' AND s.sales_type_id = 1
ORDER BY d.business_name;



-- Write a query that shows the purchase sales income per dealership for all of 2020.

SELECT DISTINCT 
	d.business_name,
	SUM(s.price) over(PARTITION BY d.dealership_id) total_sales_2020
FROM sales s 
LEFT JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1 AND s.purchase_date >= '2020-01-01' AND s.purchase_date <= '2020-12-31' AND s.sales_type_id = 1
ORDER BY d.business_name;





