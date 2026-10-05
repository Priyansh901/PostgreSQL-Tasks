CREATE TABLE Sales_Reps(
	Rep_Id SERIAL PRIMARY KEY,
	Full_Name VARCHAR(50) NOT NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	Region VARCHAR(100) NOT NULL,
	Year_Experience INT CHECK (Year_Experience >= 0) DEFAULT 0,
	Target_Amount NUMERIC(20,2) CHECK(Target_Amount > 0),
	Commission_Rate NUMERIC(20,2) CHECK(Commission_Rate>=0.01 AND Commission_Rate<= 0.25),
	Hire_Date DATE NOT NULL,
	Is_Active BOOLEAN DEFAULT TRUE	
);

CREATE TABLE Products_Catalog(
	Product_Id SERIAL PRIMARY KEY,
	Product_Name VARCHAR(50) NOT NULL UNIQUE,
	Category VARCHAR(50) NOT NULL,
	Cost_Price NUMERIC(20,2) CHECK(Cost_Price > 0),
	Selling_Price NUMERIC(20,2) CHECK(Selling_Price > 0),
	Units_in_Stock INT CHECK(Units_in_Stock >= 0) DEFAULT 0,
	Is_Discontinued BOOLEAN DEFAULT FALSE
);

CREATE TABLE Monthly_Sales(
	Sales_Id SERIAL PRIMARY KEY,
	Rep_Name VARCHAR(50) NOT NULL,
	Product_Name VARCHAR(50) NOT NULL,
	Region VARCHAR(50) NOT NULL,
	Units_Sold INT CHECK(Units_Sold > 0),
	Sale_Amount NUMERIC(20,2) CHECK(Sale_Amount > 0),
	Sale_Month VARCHAR(50) NOT NULL,
	Sale_Status VARCHAR(50) NOT NULL DEFAULT 'Confirmed'
);

-- Rows with every column provided
INSERT INTO Sales_Reps (Full_Name, Email, Region, Year_Experience, Target_Amount, Commission_Rate, Hire_Date, Is_Active)
VALUES
('Neha Kapoor', 'neha.k@novatech.com', 'North', 6, 500000, 0.12, '2020-02-14', true),
('Divya Joshi', 'divya.j@novatech.com', 'North', 2, 290000, 0.07, '2023-04-18', false);

-- Row omitting years_experience (defaults to 0)
INSERT INTO Sales_Reps (Full_Name, Email, Region, Target_Amount, Commission_Rate, Hire_Date, Is_Active)
VALUES
('Sanjay Rathi', 'sanjay.r@novatech.com', 'South', 350000, 0.08, '2022-06-01', true);

-- Row omitting commission_rate
INSERT INTO Sales_Reps (Full_Name, Email, Region, Year_Experience, Target_Amount, Hire_Date, Is_Active)
VALUES
('Pooja Deshmukh', 'pooja.d@novatech.com', 'West', 9, 620000, '2019-03-22', true);

-- Row omitting is_active (defaults to true)
INSERT INTO Sales_Reps (Full_Name, Email, Region, Year_Experience, Target_Amount, Commission_Rate, Hire_Date)
VALUES
('Arvind Menon', 'arvind.m@novatech.com', 'East', 4, 410000, 0.10, '2021-10-05');

-- Rows with every column provided
INSERT INTO Products_Catalog (Product_Name, Category, Cost_Price, Selling_Price, Units_in_Stock, Is_Discontinued)
VALUES
('EcoFlask 750ml', 'Lifestyle', 180, 399, 320, false),
('Yoga Mat Pro', 'Fitness', 300, 699, 150, true);

-- Row omitting units_in_stock (defaults to 0)
INSERT INTO Products_Catalog (Product_Name, Category, Cost_Price, Selling_Price, Is_Discontinued)
VALUES
('SmartWatch X2', 'Electronics', 2400, 4999, false);

-- Row omitting is_discontinued (defaults to false)
INSERT INTO Products_Catalog (Product_Name, Category, Cost_Price, Selling_Price, Units_in_Stock)
VALUES
('Bluetooth Speaker Mini', 'Electronics', 650, 1299, 210);

-- Rows with sale_status provided
INSERT INTO Monthly_Sales (Rep_Name, Product_Name, Region, Units_Sold, Sale_Amount, Sale_Month, Sale_Status)
VALUES
('Sanjay Rathi', 'EcoFlask 750ml', 'South', 80, 31920, 'January', 'Confirmed'),
('Pooja Deshmukh', 'Bluetooth Speaker Mini', 'West', 40, 51960, 'February', 'Pending'),
('Divya Joshi', 'SmartWatch X2', 'North', 10, 49990, 'February', 'Cancelled');

-- Rows omitting sale_status (defaults to 'Confirmed')
INSERT INTO Monthly_Sales (Rep_Name, Product_Name, Region, Units_Sold, Sale_Amount, Sale_Month)
VALUES
('Neha Kapoor', 'SmartWatch X2', 'North', 25, 124975, 'January'),
('Arvind Menon', 'Yoga Mat Pro', 'East', 15, 10485, 'February');

-- NovaTech's finance team has exported last quarter's expense data into the attached `quarterly_expenses.csv` file. 
-- The file has the following columns, in this order, with the first row containing the headers:
-- expense_id, department, expense_category, amount, expense_date`

CREATE TABLE Quarterly_Expenses(
	Expense_Id INT PRIMARY KEY,
	Department VARCHAR(50) NOT NULL,
	Expense_Category VARCHAR(50) NOT NULL,
	Amount NUMERIC(20,2) NOT NULL,
	Expense_Date DATE NOT NULL
);

-- Retrieve the `full_name` column from `sales_reps`, displaying it under the alias `rep_name`.
SELECT Full_Name AS Rep_Name
FROM Sales_Reps;

-- Retrieve the `full_name`, `region`, and `target_amount` columns from `sales_reps`, 
-- displaying them under the aliases `rep_name`, `rep_region`, and `yearly_target` respectively.
SELECT
	Full_Name AS Rep_Name,
	Region AS Rep_Region,
	Target_Amount AS Yearly_Target
FROM Sales_Reps;

-- Retrieve each sales rep's `full_name` along with their `target_amount` multiplied by their `commission_rate`, 
-- displaying the calculated column under the alias `expected_commission`.
SELECT Full_Name,
	(Target_Amount * Commission_Rate) AS Expected_Commission
FROM Sales_Reps;

-- Retrieve each product's `product_name` along with its `selling_price` minus its `cost_price`, 
-- displaying the calculated column under the alias `profit_per_unit`.
SELECT Product_Name,
	(Selling_Price - Cost_Price) AS Profit_Per_Unit
FROM Products_Catalog;

-- Retrieve the average `selling_price` across all rows in `products_catalog`, 
-- displaying the result under the alias `average_selling_price`.
SELECT 
	AVG(Selling_Price) AS Average_Selling_Price
FROM Products_Catalog;

-- Retrieve all sales reps whose `region` is `'North'` **and** whose `years_experience` is greater than 3, **or** 
-- whose `commission_rate` is greater than or equal to 0.10.
SELECT * FROM Sales_Reps
WHERE Region = 'North' AND Year_Experience > 3 OR Commission_Rate >= 0.10;

-- Retrieve all products whose `category` is `'Electronics'` **and** whose `units_in_stock` is less than 250,
-- **and** whose `is_discontinued` value is `false`.
SELECT * FROM Products_Catalog
WHERE Category = 'Electronics' AND Units_In_Stock < 250 AND Is_Discontinued = FALSE;

-- Retrieve all sales from `monthly_sales` where `sale_status` is **not** `'Cancelled'`,
-- and whose `sale_amount` is greater than 30000, **or** where `sale_month` is `'February'`.
SELECT * FROM Monthly_Sales
WHERE Sale_Status != 'Cancelled' AND Sale_Amount > 30000 OR Sale_Month = 'February';

-- Retrieve the `rep_name` and `sale_amount` columns from `monthly_sales` for every sale whose `units_sold`
-- is greater than or equal to 10 and less than or equal to 50.
SELECT Rep_Name , Sale_Amount FROM Monthly_Sales
WHERE Units_Sold >= 10 AND Units_Sold <= 50;

-- Update Pooja Deshmukh's record in `sales_reps` so that her `commission_rate` becomes 0.11 
-- and her `target_amount` becomes 680000, in a single statement.
UPDATE Sales_Reps
SET Commission_Rate = 0.11 , Target_Amount = 680000
WHERE Full_Name = 'Pooja Deshmukh';

-- Update every sales rep whose `years_experience` is greater than or equal to 5 **and** whose `is_active` 
-- value is `true` so that `commission_rate` becomes 0.15.
UPDATE Sales_Reps
SET Commission_rate = 0.15
WHERE Year_Experience >= 5 AND Is_Active = TRUE;

-- Update every product whose `units_in_stock` is less than 200 **and** whose `is_discontinued` value is `false` 
-- so that `selling_price` is increased by 5% of its current value.
UPDATE Products_Catalog
SET Selling_Price = Selling_Price * 0.05
WHERE Units_in_Stock < 200 AND Is_Discontinued = FALSE;

-- Update every sale in `monthly_sales` whose `sale_status` is `'Pending'` so that `sale_status` becomes `'Confirmed'`.
UPDATE Monthly_Sales 
SET Sale_Status = 'Confirmed'
WHERE Sale_Status = 'Pending';

-- Update every sale whose `region` is `'North'` **and** whose `sale_month` is `'February'` 
-- so that `sale_amount` is reduced by 2000.
UPDATE Monthly_Sales
SET Sale_Amount = Sale_Amount - 2000
WHERE Region = 'North' AND Sale_Month = 'February';

-- Update Divya Joshi's record so that her `region` column is set to `NULL`.
UPDATE Sales_Reps
SET Region = NULL
WHERE Full_Name = 'Divya Joshi';

-- Delete every sale where `sale_status` is `'Cancelled'` **and** `units_sold` is less than 20.
DELETE FROM Monthly_Sales
WHERE Sale_Status = 'Cancelled' AND Units_Sold < 20;

-- Delete every sales rep whose `is_active` value is `false` **or** 
-- whose `years_experience` is less than 3, **and** whose `region` is `'North'`.
DELETE FROM Sales_Reps
WHERE Is_Active = FALSE OR Year_Experience < 3 AND Region = 'North';

-- Delete all rows from the `quarterly_expenses` table while keeping the table structure intact.
DELETE FROM Quarterly_Expenses;

-- Remove the `is_active` column from `sales_reps`.
ALTER TABLE Sales_Reps
DROP COLUMN Is_Active;

-- Remove the `units_in_stock` and `is_discontinued` columns from `products_catalog` in a single statement.
ALTER TABLE Products_Catalog
DROP COLUMN Units_in_Stock,
DROP COLUMN Is_Discontinued;

-- Remove a column named `discount_applied` from `monthly_sales`, and a column named `approved_by` 
-- from `quarterly_expenses`, each using a method that will not throw an error if the column does not exist.
ALTER TABLE Monthly_Sales
DROP COLUMN IF EXISTS Discount_Applied;

ALTER TABLE Quarterly_Expenses
DROP COLUMN IF EXISTS Approved_By;

-- Delete the `quarterly_expenses` table completely.
DROP TABLE Quarterly_Expenses;

-- Delete the `monthly_sales` and `products_catalog` tables in a single statement, 
-- using a method that will not throw an error if either table does not exist.
DROP TABLE IF EXISTS Monthly_Sales,Products_Catalog;

-- Delete a table named `archived_sales`, a table named `old_products`, and a table named `temp_reps` in a single statement, 
-- using a method that will not throw an error for any table that does not exist.
DROP TABLE IF EXISTS Archived_Sales,Old_Products,Temp_Reps;

-- Delete a database named `novatech_sales_staging_db`, using a method that will not throw an error if the database does not exist. 
-- (Assume you are connected to a different database while running this.)
DROP DATABASE IF EXISTS Novatech_Sales_Staging_DB;

