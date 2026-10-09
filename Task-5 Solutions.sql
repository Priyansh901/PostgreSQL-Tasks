CREATE TABLE Warehouse_Staff(
	Staff_ID SERIAL PRIMARY KEY,
	Full_Name VARCHAR(60) NOT NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	Shift VARCHAR(60) NOT NULL,
	Years_Experience INT CHECK(Years_Experience >= 0) DEFAULT 0,
	Hourly_Rate NUMERIC(5,2) CHECK(Hourly_Rate >= 50 AND Hourly_Rate <= 800),
	Hire_Date DATE NOT NULL,
	Is_Supervisor BOOLEAN DEFAULT FALSE
);

CREATE TABLE Equipment(
	Equipment_ID SERIAL PRIMARY KEY,
	Equipment_Name VARCHAR(50) NOT NULL UNIQUE,
	Equipment_Type VARCHAR(50) NOT NULL,
	Purchase_Cost NUMERIC(20,2) CHECK(Purchase_Cost > 0),
	Usage_Hours INT CHECK(Usage_Hours >= 0) DEFAULT 0,
	Maintenance_Due BOOLEAN DEFAULT FALSE
);

CREATE TABLE Shift_Logs(
	Log_ID SERIAL PRIMARY KEY,
	Staff_Name VARCHAR(50) NOT NULL,
	Equipment_Name VARCHAR(50) NOT NULL,
	Shift_Type VARCHAR(50) NOT NULL DEFAULT 'Day',
	Units_Handled INT CHECK(Units_Handled > 0),
	Hours_Logged NUMERIC(20,2) CHECK(Hours_Logged > 0),
	Log_Date DATE NOT NULL
);

-- Rows with every column provided
INSERT INTO Warehouse_Staff (Full_Name, Email, Shift, Years_Experience, Hourly_Rate, Hire_Date, Is_Supervisor)
VALUES
('Rohit Malhotra', 'rohit.m@novatech.com', 'Day', 7, 320, '2019-04-12', true),
('Meera Kulkarni', 'meera.k@novatech.com', 'Night', 6, 260, '2020-06-25', false);

-- Row omitting years_experience (defaults to 0)
INSERT INTO Warehouse_Staff (Full_Name, Email, Shift, Hourly_Rate, Hire_Date, Is_Supervisor)
VALUES
('Priya Nair', 'priya.nair@novatech.com', 'Night', 210, '2021-08-19', false);

-- Row omitting is_supervisor (defaults to false)
INSERT INTO Warehouse_Staff (Full_Name, Email, Shift, Years_Experience, Hourly_Rate, Hire_Date)
VALUES
('Devansh Gupta', 'devansh.g@novatech.com', 'Day', 3, 180, '2022-02-01');

-- Row omitting both years_experience and is_supervisor (both default)
INSERT INTO Warehouse_Staff (Full_Name, Email, Shift, Hourly_Rate, Hire_Date)
VALUES
('Farhan Ali', 'farhan.ali@novatech.com', 'Day', 150, '2023-09-10');

-- Rows with every column provided
INSERT INTO Equipment (Equipment_Name, Equipment_Type, Purchase_Cost, Usage_Hours, Maintenance_Due)
VALUES
('Forklift A1', 'Forklift', 1850000, 4200, true),
('Forklift A2', 'Forklift', 1920000, 3100, false);

-- Row omitting usage_hours (defaults to 0)
INSERT INTO Equipment (Equipment_Name, Equipment_Type, Purchase_Cost, Maintenance_Due)
VALUES
('Conveyor Belt C1', 'Conveyor', 920000, false);

-- Row omitting maintenance_due (defaults to false)
INSERT INTO Equipment (Equipment_Name, Equipment_Type, Purchase_Cost, Usage_Hours)
VALUES
('Pallet Jack P3', 'Pallet Jack', 45000, 1800);

-- -- Rows with shift_type provided
INSERT INTO Shift_Logs (Staff_Name, Equipment_Name, Shift_Type, Units_Handled, Hours_Logged, Log_Date)
VALUES
('Priya Nair', 'Conveyor Belt C1', 'Night', 650, 7.5, '2024-04-01'),
('Devansh Gupta', 'Pallet Jack P3', 'Day', 180, 6.0, '2024-04-02'),
('Meera Kulkarni', 'Forklift A2', 'Night', 510, 8.0, '2024-04-02');

-- Rows omitting shift_type (defaults to 'Day')
INSERT INTO Shift_Logs (Staff_Name, Equipment_Name, Units_Handled, Hours_Logged, Log_Date)
VALUES
('Rohit Malhotra', 'Forklift A1', 420, 8.0, '2024-04-01'),
('Farhan Ali', 'Conveyor Belt C1', 300, 5.5, '2024-04-03');

-- Payroll has exported shift attendance into the attached `employee_attendance.csv` file. 
--The file has the following columns, in this order, with the first row containing the headers:
-- attendance_id, emp_name, department, work_date, hours_worked, attendance_status`
-- Create a table named `employee_attendance` with matching columns and appropriate data types, 
-- ready to receive this data. Then import `employee_attendance.csv` into this table using PostgreSQL's import tooling.

CREATE TABLE Employee_Attendance(
	Attendance_ID SERIAL PRIMARY KEY,
	Emp_Name VARCHAR(50) NOT NULL,
	Department VARCHAR(50) NOT NULL,
	Work_Date DATE NOT NULL,
	Hours_Worked NUMERIC(10,2),
	Attendance_Status VARCHAR(20) NOT NULL
);

-- Retrieve each staff member's `full_name` along with their `hourly_rate` multiplied by 8, 
-- displaying the calculated column under the alias `daily_pay`
SELECT Full_Name,
	(Hourly_Rate * 8) AS Daily_Pay
FROM Warehouse_Staff;

-- Retrieve each staff member's `full_name` along with their `hourly_rate` multiplied by 8 and then multiplied by 26, 
-- displaying the calculated column under the alias `monthly_pay`.
SELECT Full_Name,
	(Hourly_Rate * 8 * 26) AS Monthly_Pay
FROM Warehouse_Staff;

-- Retrieve each piece of equipment's `equipment_name` along with its `purchase_cost` divided by its `usage_hours`, 
-- displaying the calculated column under the alias `cost_per_hour`. Exclude any equipment whose `usage_hours` is 0.
SELECT Equipment_Name ,
	(Purchase_Cost / Usage_Hours) AS Cost_Per_Hour
FROM Equipment 
WHERE Usage_Hours != 0;

-- Retrieve each shift log's `staff_name` along with its `units_handled` modulus 50, 
-- displaying the calculated column under the alias `leftover_units`.
SELECT Staff_Name,
	(Units_Handled % 50) AS Leftover_Units
FROM Shift_Logs;

-- Retrieve each staff member's `full_name` along with their `hourly_rate` raised to the power of 2, 
-- displaying the calculated column under the alias `rate_squared`.
SELECT Full_Name,
	(Hourly_Rate ^ 2) AS Rate_Squared
FROM Warehouse_Staff;

-- Retrieve all staff whose `hourly_rate` is not equal to 210, using the `<>` operator.
SELECT * FROM Warehouse_Staff
WHERE Hourly_Rate <> 210;

-- Retrieve all staff whose `hourly_rate` is not equal to 210, using the `!=` operator.
SELECT * FROM Warehouse_Staff
WHERE Hourly_Rate != 210;

-- Retrieve all equipment whose `purchase_cost` is greater than or equal to 900000.
SELECT * FROM Equipment
WHERE Purchase_Cost >= 900000;

-- Retrieve all shift logs whose `hours_logged` is less than or equal to 6.0.
SELECT * FROM Shift_Logs
WHERE Hours_Logged <= 6.0;

-- Retrieve all staff whose `shift` is `'Day'` AND whose `years_experience` is greater than 4.
SELECT * FROM Warehouse_Staff
WHERE Shift = 'Day' AND Years_Experience > 4;

-- Retrieve all staff whose `shift` is `'Night'` OR whose `is_supervisor` value is `true`.
SELECT * FROM Warehouse_Staff
WHERE Shift = 'Night' OR Is_Supervisor = TRUE;

-- Retrieve all staff whose `shift` is NOT `'Night'`.
SELECT * FROM Warehouse_Staff
WHERE NOT Shift = 'Night';

-- Retrieve all equipment whose `maintenance_due` value is `true` AND whose `equipment_type` is `'Forklift'`,
-- OR whose `usage_hours` is greater than 4000.
SELECT * FROM Equipment 
WHERE Maintenance_Due = TRUE AND Equipment_Type = 'Forklift' OR Usage_Hours = 4000;

-- Retrieve all shift logs where NOT (`shift_type` is `'Day'` AND `units_handled` is less than 300)
SELECT * FROM shift_logs
WHERE NOT Shift_Type = 'Day' AND NOT Units_Handled < 300;

-- Retrieve all staff whose `hourly_rate` is between 150 and 260, inclusive.
SELECT * FROM Warehouse_Staff
WHERE hourly_rate BETWEEN 150 AND 260;

-- Retrieve all staff whose `hourly_rate` is NOT between 150 and 260.
SELECT * FROM Warehouse_Staff
WHERE hourly_rate NOT BETWEEN 150 AND 260;

-- Retrieve all staff whose `full_name` starts with the letter `'R'`.
SELECT * FROM Warehouse_Staff
WHERE Full_Name Like 'R%';

-- Retrieve all staff whose `email` contains the word `'nair'` anywhere within it.
SELECT * FROM Warehouse_Staff
WHERE EMAIL LIKE 'nair';

-- Retrieve all equipment whose `equipment_name` does NOT start with `'Forklift'`.
SELECT * FROM Equipment
WHERE Equipment_Name NOT LIKE 'Forklift';

-- Retrieve all staff whose `shift` is one of `'Day'` or `'Night'` using the IN operator, and whose `is_supervisor` value is `true`.
SELECT * FROM Warehouse_Staff
WHERE Shift IN ('Day','Night') AND is_supervisor = TRUE;

-- Retrieve all equipment whose `equipment_type` is NOT one of `'Forklift'` or `'Conveyor'`, using the NOT IN operator.
SELECT * FROM Equipment
WHERE equipment_type NOT IN ('Forklift','Conveyor');

-- Retrieve all shift logs whose `log_date` is between `'2024-04-01'` and `'2024-04-02'`, 
-- inclusive, AND whose `units_handled` is greater than 200.
SELECT * FROM Shift_Logs
WHERE log_date BETWEEN '2024-04-01' AND '2024-04-02' AND units_handled > 200;

-- Retrieve the `full_name` and `hourly_rate` columns from `warehouse_staff` for every staff member whose `hourly_rate`
-- is between 150 and 300, AND whose `shift` is `'Day'`, displaying `hourly_rate` under the alias `rate_per_hour`.
SELECT Full_Name , 
Hourly_Rate AS rate_per_hour
FROM warehouse_staff
WHERE hourly_rate BETWEEN 150 AND 300 AND shift = 'Day' ;

-- Retrieve each shift log's `staff_name` along with its `hours_logged` multiplied by 320 (a flat rate), 
-- displaying the calculated column under the alias `shift_earnings`, 
-- for every log whose `shift_type` is IN `('Day', 'Night')` AND whose `units_handled` is greater than or equal to 300.
SELECT Staff_Name,
	(Hours_Logged * 320) AS shift_earnings
FROM Shift_Logs
WHERE shift_type IN ('Day', 'Night') AND units_handled >= 300;

-- Update Priya Nair's record in `warehouse_staff` so that her `hourly_rate` 
-- becomes 230 and her `shift` becomes `'Day'`, in a single statement.
UPDATE warehouse_staff
SET hourly_rate = 230 , shift = 'Day'
WHERE Full_Name = 'Priya Nair';

-- Give every staff member whose `shift` is `'Night'` an `hourly_rate` increase of 15, added on top of their current value.
UPDATE warehouse_staff
SET hourly_rate = hourly_rate + 15
WHERE shift = 'Night';

-- Update every staff member whose `years_experience` is greater than or equal to 5 AND whose `is_supervisor`
-- value is `false` so that `is_supervisor` becomes `true`.
UPDATE warehouse_staff
SET is_supervisor = TRUE
WHERE years_experience >= 5 AND is_supervisor = FALSE;

-- Update every piece of equipment whose `usage_hours` is greater than 3500 OR whose 
-- `maintenance_due` value is already `true` so that `maintenance_due` becomes `true`.
UPDATE Equipment
SET maintenance_due = TRUE
WHERE usage_hours > 3500 OR maintenance_due = TRUE;

-- Update every shift log whose `shift_type` is `'Day'` AND whose `units_handled` 
-- is between 150 and 400 so that `units_handled` is increased by 10%.
UPDATE Shift_Logs
SET units_handled = units_handled * 0.1
WHERE shift_type = 'Day' AND units_handled BETWEEN 150 AND 400;

-- Update Devansh Gupta's record so that his `shift` column is set to `NULL`.
UPDATE warehouse_staff
SET shift = NULL
WHERE Full_Name = 'Devansh Gupta';\

-- Delete every shift log whose `units_handled` is less than 200 AND whose `shift_type` is `'Day'`.
DELETE FROM Shift_Logs
WHERE units_handled < 200 AND shift_type = 'Day';

-- Delete every staff member whose `hourly_rate` is NOT between 150 and 300, OR whose `years_experience` is less than 2.
DELETE FROM warehouse_staff
WHERE hourly_rate NOT BETWEEN 150 AND 300 OR years_experience < 2;

-- Delete all rows from the `employee_attendance` table while keeping the table structure intact.
DELETE FROM employee_attendance;

-- Remove the `is_supervisor` column from `warehouse_staff`.
ALTER TABLE warehouse_staff
DROP COLUMN is_supervisor;

-- Remove the `usage_hours` and `maintenance_due` columns from `equipment` in a single statement.
ALTER TABLE equipment
DROP COLUMN usage_hours,
DROP COLUMN maintenance_due;

-- Remove a column named `supervisor_remarks` from `shift_logs`, and a column named `approved_by` from `employee_attendance`, 
-- each using a method that will not throw an error if the column does not exist.
ALTER TABLE shift_logs
DROP COLUMN IF EXISTS supervisor_remarks;

ALTER TABLE employee_attendance
DROP COLUMN IF EXISTS approved_by;

-- Delete the `employee_attendance` table completely.
DROP TABLE employee_attendance;

-- Delete the `shift_logs` and `equipment` tables in a single statement, 
-- using a method that will not throw an error if either table does not exist.
DROP TABLE IF EXISTS shift_logs , equipment;

-- Delete a table named `archived_logs`, a table named `old_equipment`, and a table named `temp_staff` in a single statement, 
-- using a method that will not throw an error for any table that does not exist.
DROP TABLE IF EXISTS archived_logs , old_equipment , temp_staff;

-- Delete a database named `novatech_warehouse_staging_db`, 
-- using a method that will not throw an error if the database does not exist. 
-- (Assume you are connected to a different database while running this.)
DROP DATABASE IF EXISTS novatech_warehouse_staging_db;
