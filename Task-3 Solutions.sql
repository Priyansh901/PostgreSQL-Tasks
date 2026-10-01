Create Table Drivers(
	Driver_id SERIAL PRIMARY KEY,
    Full_name VARCHAR(100) NOT NULL,
    License_number VARCHAR(50) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL,
    Years_experience INT CHECK (years_experience >= 0) DEFAULT 0,
    Rating NUMERIC CHECK (rating >= 1 AND rating <= 5),
    Monthly_salary NUMERIC CHECK (monthly_salary > 10000),
    Joined_on DATE NOT NULL,
    Is_on_duty BOOLEAN DEFAULT False
);

CREATE TABLE Vehicles (
    Vehicle_id SERIAL PRIMARY KEY,
    Vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    Vehicle_type VARCHAR(30) NOT NULL,
    Capacity_kg INT CHECK (capacity_kg > 0),
    Purchase_price NUMERIC CHECK (purchase_price > 0),
    Mileage_km NUMERIC CHECK (mileage_km >= 0) DEFAULT 0,
    Last_service_date DATE DEFAULT CURRENT_DATE,
    Is_active BOOLEAN DEFAULT True
);

CREATE TABLE Deliveries (
    Delivery_id SERIAL PRIMARY KEY,
    Driver_name VARCHAR(100) NOT NULL,
    Vehicle_number VARCHAR(20) NOT NULL,
    Destination_city VARCHAR(50) NOT NULL,
    Distance_km NUMERIC CHECK (distance_km > 0),
    Delivery_status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    Delivery_charge NUMERIC CHECK (delivery_charge > 0),
    Scheduled_time TIMESTAMP NOT NULL
);


INSERT INTO Drivers (Full_name, License_number, City, Years_experience, Rating, Monthly_salary, Joined_on, Is_on_duty)
VALUES
('Vikram Singh', 'DL-0092831', 'Delhi', 8, 4.7, 42000, '2018-05-11', true),
('Imran Khan', 'MH-0033456', 'Mumbai', 3, 3.8, 31000, '2022-07-19', true);


INSERT INTO Drivers (Full_name, License_number, City, Rating, Monthly_salary, Joined_on, Is_on_duty)
VALUES
('Arjun Nair', 'KA-0045521', 'Bangalore', 4.2, 35000, '2021-09-02', true);


INSERT INTO Drivers (full_name, license_number, city, years_experience, monthly_salary, joined_on, is_on_duty)
VALUES
('Suresh Pillai', 'TN-0078123', 'Chennai', 5, 38000, '2020-01-15', false);


INSERT INTO Drivers (Full_name, License_number, City, Years_experience, Rating, Monthly_salary, Joined_on)
VALUES
('Ramesh Yadav', 'UP-0012987', 'Lucknow', 12, 4.9, 46000, '2016-11-30');


INSERT INTO Vehicles (Vehicle_number, Vehicle_type, Capacity_kg, Purchase_price, Mileage_km, Is_active)
VALUES
('MH-12-AB-3344', 'Truck', 8000, 1850000, 42000, true),
('TN-09-GH-4455', 'Van', 1200, 580000, 9000, false);


INSERT INTO Vehicles (Vehicle_number, Vehicle_type, Capacity_kg, Purchase_price, Is_active)
VALUES
('DL-08-CD-1122', 'Van', 1500, 650000, true);


INSERT INTO Vehicles (Vehicle_number, Vehicle_type, Capacity_kg, Purchase_price, Mileage_km)
VALUES
('KA-05-EF-9988', 'Truck', 10000, 2100000, 18500);


INSERT INTO Deliveries (Driver_name, Vehicle_number, Destination_city, Distance_km, Delivery_status, Delivery_charge, Scheduled_time)
VALUES
('Arjun Nair', 'DL-08-CD-1122', 'Jaipur', 280, 'In Transit', 6100, '2024-03-02 09:30:00'),
('Suresh Pillai', 'KA-05-EF-9988', 'Hyderabad', 560, 'Delivered', 11500, '2024-03-03 06:15:00'),
('Imran Khan', 'MH-12-AB-3344', 'Nagpur', 320, 'Cancelled', 7200, '2024-03-05 10:00:00');


INSERT INTO Deliveries (Driver_name, Vehicle_number, Destination_city, Distance_km, Delivery_charge, Scheduled_time)
VALUES
('Vikram Singh', 'MH-12-AB-3344', 'Pune', 150, 4200, '2024-03-01 08:00:00'),
('Ramesh Yadav', 'TN-09-GH-4455', 'Coimbatore', 95, 2800, '2024-03-04 07:45:00');



-- Retrieve the `full_name`, `city`, and `rating` columns for every row in `drivers`.
SELECT Full_name , City , Rating
FROM  Drivers;

-- Retrieve all drivers whose `years_experience` is greater than 2, and whose `city` is either `'Delhi'` or `'Mumbai'`.
SELECT * FROM Drivers
WHERE years_experience > 2 AND city = 'Delhi' OR city = 'Mumbai';

-- Retrieve all drivers whose `rating` is greater than or equal to 4.5 **and** whose `is_on_duty` value is `true`.
SELECT * FROM Drivers
WHERE rating >= 4.5 AND is_on_duty = TRUE;

-- Retrieve all vehicles that are **not** of `vehicle_type` `'Truck'`.
SELECT * FROM Vehicles
WHERE vehicle_type <> 'Truck';

-- Retrieve all vehicles whose `capacity_kg` is greater than 5000 **and** whose `is_active` value is `true`,
-- **or** whose `mileage_km` is less than 10000.
SELECT * FROM Vehicles
WHERE capacity_kg > 5000 AND Is_active = TRUE OR mileage_km < 10000;

-- Retrieve all deliveries where `delivery_status` is `'Delivered'`
-- **and** `distance_km` is greater than 200, **or** where `delivery_status` is `'Cancelled'`.
SELECT * FROM Deliveries 
WHERE Delivery_status = 'Delivered' AND Distance_km > 200 OR Delivery_status = 'Cancelled';

-- Retrieve all deliveries whose `delivery_charge` is greater than 3000 **and** less than 8000.
SELECT * FROM Deliveries 
WHERE Delivery_charge > 3000 AND Delivery_charge < 8000;

-- Retrieve the `driver_name`, `destination_city`, and `delivery_charge` columns 
-- for every delivery where `delivery_status` is **not** `'Cancelled'` **and** `distance_km` is greater than or equal to 100.
SELECT Driver_name , Destination_city , Delivery_charge 
FROM Deliveries
WHERE Delivery_status != 'Cancelled' AND Distance_km >= 100;

-- Retrieve all drivers whose `city` is **not** `'Mumbai'`, 
-- and whose `monthly_salary` is greater than 40000 or whose `years_experience` is greater than 10.
SELECT * FROM Drivers
WHERE City != 'Mumbai' AND Monthly_salary > 40000 OR Years_experience > 10;

-- Update Suresh Pillai's record in `drivers` so that his `rating` becomes 4.4 and his `monthly_salary` becomes 41000, 
-- in a single statement.
UPDATE Drivers 
SET Rating = 4.4 , Monthly_salary = 41000
WHERE Full_name = 'Suresh Pillai';

-- Give every driver whose `city` is `'Delhi'` **or** `'Lucknow'` a `monthly_salary` increase of 2000, 
-- added on top of their current value.
UPDATE Drivers
SET Monthly_salary = Monthly_salary + 2000
WHERE City = 'Delhi' OR City = 'Lucknow';

-- Update every driver whose `years_experience` is greater than or equal to 5 **and** whose `rating` is greater than or equal to 4 
-- so that `is_on_duty` becomes `true`.
UPDATE Drivers
SET Is_on_duty = True
WHERE Years_experience >= 5 AND Rating >= 4;

-- Update every vehicle whose `mileage_km` is greater than 15000 so that `is_active` becomes `false` and `last_service_date` 
-- becomes `'2024-03-10'`, in a single statement.
UPDATE Vehicles
SET Is_active = False , Last_service_date = '2024-03-10'
WHERE Mileage_km > 15000;

-- Update every delivery whose `delivery_status` is `'Scheduled'` so that `delivery_status` becomes `'In Transit'`.
UPDATE Deliveries
SET Delivery_status = 'In Transit'
Where Delivery_status = 'Scheduled';

-- Update every delivery whose `destination_city` is `'Nagpur'` **or** `'Coimbatore'` 
-- so that `delivery_charge` is reduced by 10% of its current value.
UPDATE Deliveries
SET Delivery_charge = Delivery_charge - (Delivery_charge * 0.10)
WHERE Destination_city = 'Nagpur' OR Destination_city = 'Coimbatore';

-- Update Imran Khan's record so that his `city` column is set to `NULL`.
UPDATE Drivers
SET City = NULL
WHERE Full_name = 'Imran Khan';

-- Update every row in `vehicles` so that `mileage_km` increases by 500.
UPDATE Vehicles
SET Mileage_km = Mileage_km + 500;

-- Delete every delivery where `delivery_status` is `'Cancelled'` **and** `delivery_charge` is greater than 5000.
DELETE FROM Deliveries 
WHERE Delivery_status = 'Cancelled' AND Delivery_charge > 5000;

-- Delete every driver whose `rating` is less than 4 **or** whose `years_experience` 
-- is less than 4, **and** whose `is_on_duty` value is `false`.
DELETE FROM Drivers
WHERE Rating < 4 OR Years_experience < 4 AND Is_on_duty = False;

-- Delete all rows from the `deliveries` table while keeping the table structure intact.
DELETE FROM Deliveries;

-- Remove the `is_on_duty` column from `drivers`.
ALTER TABLE Drivers
DROP COLUMN Is_on_duty;

-- Remove the `mileage_km` and `last_service_date` columns from `vehicles` in a single statement.
ALTER TABLE Vehicles
DROP COLUMN Mileage_km,
DROP COLUMN last_service_date;

-- Remove a column named `tracking_code` from `deliveries`, and a column named `fuel_type` from `vehicles`, 
-- each using a method that will not throw an error if the column does not exist.
ALTER TABLE Deliveries
DROP COLUMN IF EXISTS Tracking_code;

ALTER TABLE Vehicles
DROP COLUMN IF EXISTS Fuel_type;

-- Delete the `deliveries` table completely.
DROP TABLE Deliveries;

-- Delete the `drivers` and `vehicles` tables in a single statement, 
-- using a method that will not throw an error if either table does not exist.
DROP TABLE IF EXISTS Drivers , Vehicles;

-- Delete a table named `archived_deliveries`, a table named `old_vehicles`, and a table named `temp_drivers` in a single statement, 
-- using a method that will not throw an error for any table that does not exist.
DROP TABLE IF EXISTS archived_deliveries, old_vehicles, temp_drivers;

-- Delete a database named `novatech_logistics_staging_db`, using a method that will not throw an error if the database does not exist. 
-- (Assume you are connected to a different database while running this.)
DROP DATABASE IF EXISTS Novatech_Logistics_Staging_DB;

