-- Transaction example 

do $$ 
DECLARE 
  NewCustomerId integer;
  CurrentTS date;

BEGIN

  INSERT INTO
    customers(
      first_name,
      last_name,
      email,
      phone,
      street,
      city,
      state,
      zipcode,
      company_name
    )
  VALUES
    (
      'Roy',
      'Simlet',
      'r.simlet@remves.com',
      '615-876-1237',
      '77 Miner Lane',
      'San Jose',
      'CA',
      '95008',
      'Remves'
    ) RETURNING customer_id INTO NewCustomerId;

  CurrentTS = CURRENT_DATE;

  INSERT INTO
    sales(
      sales_type_id,
      vehicle_id,
      employee_id,
      customer_id,
      dealership_id,
      price,
      deposit,
      purchase_date,
      pickup_date,
      invoice_number,
      payment_method
    )
  VALUES
    (
      1,
      1,
      1,
      NewCustomerId,
      1,
      24333.67,
      6500,
      CurrentTS,
      CurrentTS + interval '7 days',
      1273592747,
      'solo'
    );

EXCEPTION WHEN others THEN 
  -- RAISE INFO 'name:%', SQLERRM;
  ROLLBACK;

END;

$$ language plpgsql;



-- Write a transaction to:

-- Add a new role for employees called Automotive Mechanic

do $$ 
DECLARE 
  NewEmployeeTypeId integer;

BEGIN

  INSERT INTO
    employeetypes(
      employee_type_name
    )
  VALUES
    (
      'Automotive Mechanic'
    ) RETURNING employee_type_id INTO NewEmployeeTypeId;
   

-- Add five new mechanics, their data is up to you

  INSERT INTO
    employees(
      first_name,
      last_name,
      email_address,
      phone,
      employee_type_id 
    )
  VALUES
    (
      'DeAaron',
      'Fox',
      'dfox@gmail.com',
      '916-876-1237',
      NewEmployeeTypeId
    ),
	(
      'Keegan',
      'Murray',
      'kmurray@gmail.com',
      '916-123-1234',
      NewEmployeeTypeId
    ),
    (
      'Domantas',
      'Sabonis',
      'dsab@gmail.com',
      '916-345-1234',
      NewEmployeeTypeId
    ),
    (
      'Malik',
      'Monk',
      'mmonk@gmail.com',
      '916-999-7589',
      NewEmployeeTypeId
    ),
    (
      'Kevin',
      'Huerter',
      'khuerter@gmail.com',
      '916-354-9345',
      NewEmployeeTypeId
    );


-- Each new mechanic will be working at all three of these dealerships: Meeler Autos of San Diego, Meadley Autos of California and Major Autos of Florida
   
   
   
   
   EXCEPTION WHEN others THEN 
  -- RAISE INFO 'name:%', SQLERRM;
  ROLLBACK;

END;

$$ language plpgsql;



