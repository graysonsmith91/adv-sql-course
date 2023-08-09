--1. Get a list of sales records where the sale was a lease.

SELECT 
	* 
FROM 
	sales s
WHERE 
	sales_type_id =2;


--2. Get a list of sales where the purchase date is within the last five years.

SELECT 
	s.purchase_date 
FROM
	sales s
WHERE 
	s.purchase_date >= current_date - INTERVAL '5 years';


--3. Get a list of sales where the deposit was above 5000 or the customer payed with American Express.

SELECT 
	* 
FROM 
	sales s 
WHERE 
	s.deposit > 5000 OR s.payment_method = 'americanexpress'; 


--4. Get a list of employees whose first names start with "M" or ends with "d".

SELECT 
	e.first_name 
FROM 
	employees e 
WHERE 
	e.first_name ILIKE 'm%' OR e.first_name ILIKE '%d';

-- ILIKE is case insensitive


--5. Get a list of employees whose phone numbers have the 604 area code.

SELECT 
	e.phone
FROM 
	employees e 
WHERE 
	e.phone LIKE '604%';


