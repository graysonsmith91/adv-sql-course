-- Part 1: Normalizing the Carnival Database
-- Carnival's intern Monique had extra time to really get familiar with database normalization and data relationships and found that she could improve her ERD. Below is the ERD that she thinks will improve the quality of her database. Use this ERD as the basis for the following group work. For the first part of this project, your team is tasked with creating a script to apply these changes.
​
-- Use the Carnival ERD to identify the tables that are still missing in your database.
​
-- Which tables need to be created after reviewing the ERD?
	-- VehicleBodyType
	-- VehicleModel
	-- VehicleMake
	
-- What levels of normalization will these new tables be supporting?
	-- 3NF
​
-- Do any of these tables have a foreign key in another table? What is the child table that would hold the foreign key(s).
	-- Foreign key in Vehicle types table
​
​
-- Consider
-- What needs to be created or modified? Don't just consider tables, but foreign keys and other table modifications as well.
	-- Create 3 tables - VehicleBodyType, VehicleModel, VehicleMake
		-- VehicleBodyType should have incrementing primary key 'vehicle_body_type_id' (int) and 'name' (varchar (20))
		-- VehicleModel should have incrementing primary key 'vehicle_model_id' (int) and 'name' (varchar (20))
		-- VehicleMake should have incrementing primary key 'vehicle_make_id' (int) and 'name' (varchar (20))
	-- Vehicletypes fields should be replaced with foreign keys from new tables.
	
-- What data needs needs to change or move? See note on Data Migration below
	-- Data should migrate from current vehicletypes table to newly created tables.
		-- Keys from new tables should migrate back to vehicletypes.
		
-- What needs to be deleted?
	-- Nothing needs to be deleted because of the migration.
		-- Delete prior varchar columns
	
-- Does order matter? What order should tasks be completed in?
	-- Create new tables
	-- Migrate information to new tables
	-- Return information to pre-existing vehicletypes tables. 
	-- Delete old varchar columns from Vehicletypes table.
	
	
​
-- Part 2: Optimizing Carnival Database
-- The second part of this team project is designed for your team to analyze the entire database and create a .SQL script file that will execute the improvements to make the database better. Consider Carnival's business as well. Are there Views, Stored Procedures or Triggers that will help Carnival operate more effiecently?
	
	-- Drop empty phone number column in Customers table
	-- Normalize city, state, zipcode
	
-- Discuss the improvements as a team and why they would provide a benefit to the business. Please draw on all the knowledge you have gotten from this course to implement your ideas! Once you have found some improvements, create a .Sql script to implement those improvements.
​
do $$

BEGIN

DROP TABLE IF EXISTS VehicleBodyType CASCADE;
DROP TABLE IF EXISTS VehicleModel CASCADE;
DROP TABLE IF EXISTS VehicleMake CASCADE;

-- Initializing new tables
CREATE TABLE VehicleBodyType (
	vehicle_body_type_id SERIAL PRIMARY KEY,
	name varchar (20)
	);
	
CREATE TABLE VehicleModel (
	vehicle_model_id SERIAL PRIMARY KEY,
	name varchar (20)
	);
	
CREATE TABLE VehicleMake (
	vehicle_make_id SERIAL PRIMARY KEY,
	name varchar (20)
	);

-- Inserting relevant data for new tables.
INSERT INTO VehicleBodyType (name)
SELECT DISTINCT(body_type) FROM vehicletypes_og;

INSERT INTO VehicleModel (name)
SELECT DISTINCT(model) FROM vehicletypes_og;

INSERT INTO VehicleMake (name)
SELECT DISTINCT(make) FROM vehicletypes_og;
		
	-- Creating vehicletypes vehicle_body_type_id column, establishing constraint, populating data.
-- Create new column on vehicletypes table
ALTER TABLE vehicletypes_og
ADD COLUMN vehicle_body_type_id INT;

-- Create constraint referencing key in newly created table
ALTER TABLE vehicletypes_og
ADD CONSTRAINT body_type_id FOREIGN KEY (vehicle_body_type_id) REFERENCES VehicleBodyType (vehicle_body_type_id);

-- Update new column on vehicletypes with appropriate values from foreign table.
UPDATE vehicletypes_og
SET vehicle_body_type_id = VehicleBodyType.vehicle_body_type_id
FROM VehicleBodyType
WHERE vehicletypes_og.body_type = VehicleBodyType.name;

	-- Creating vehicletypes vehicle_model_id column, establishing constraint, populating data
-- Create new column on vehicletypes table
ALTER TABLE vehicletypes_og
ADD COLUMN vehicle_model_id INT;

-- Create constraint referencing key in newly created table
ALTER TABLE vehicletypes_og
ADD CONSTRAINT vehicle_model_id FOREIGN KEY (vehicle_model_id) REFERENCES VehicleModel (vehicle_model_id);

-- Update new column on vehicletypes with appropriate values from foreign table.
UPDATE vehicletypes_og
SET vehicle_model_id = VehicleModel.vehicle_model_id
FROM VehicleModel
WHERE vehicletypes_og.model = VehicleModel.name;

	-- Creating vehicletypes vehicle_make_id column, establishing constraint, populating data
-- Create new column on vehicletypes table
ALTER TABLE vehicletypes_og
ADD COLUMN vehicle_make_id INT;

-- Create constraint referencing key in newly created table
ALTER TABLE vehicletypes_og
ADD CONSTRAINT make_id FOREIGN KEY (vehicle_make_id) REFERENCES VehicleMake (vehicle_make_id);

-- Update new column on vehicletypes with appropriate values from foreign table.
UPDATE vehicletypes_og
SET vehicle_make_id = VehicleMake.vehicle_make_id
FROM VehicleMake
WHERE vehicletypes_og.make = VehicleMake.name;

-- Dropping old columns
ALTER TABLE vehicletypes_og
DROP COLUMN body_type,
DROP COLUMN make,
DROP COLUMN model;

COMMIT;

END;

$$ language plpgsql;


-- Creating table in original format for transaction testing.
​
CREATE TABLE vehicletypes_og (
	vehicle_type_id int,
	make varchar (20),
	model varchar (20),
	body_type varchar (20));
​
INSERT INTO vehicletypes_og (
	vehicle_type_id,
	make,
	model,
	body_type)
SELECT vt.vehicle_type_id AS vehicle_type_id, vma.name AS make, vmo.name AS model, vbt.name AS body_type
FROM vehicletypes AS vt
	LEFT JOIN vehiclemake AS vma USING (vehicle_make_id) 
	LEFT JOIN vehiclemodel AS vmo USING (vehicle_model_id)
	LEFT JOIN vehiclebodytype AS vbt USING (vehicle_body_type_id);

-- Testing vehicletypes_og table

SELECT * FROM vehicletypes_og

-- Creating a view for how the original vehicletypes table looked 

CREATE VIEW vehicletypes_og AS
SELECT 
	vehicle_type_id,
	vehiclemake.name AS make,
	vehiclemodel.name AS model,
	vehiclebodytype.name AS body_type
FROM vehicletypes
	LEFT JOIN vehiclemake USING (vehicle_make_id)
	LEFT JOIN vehiclemodel USING (vehicle_model_id)
	LEFT JOIN vehiclebodytype USING (vehicle_body_type_id);
	

