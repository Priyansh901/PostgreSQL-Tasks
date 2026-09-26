Create Database Novatech_Payroll_Db;

Create Table Staff(
	Staff_ID Serial Primary Key,
	Full_Name Varchar(70) Not Null,
	Email Varchar(70) Not Null Unique,
	Designation Varchar(70),
	Department Varchar(70) Not Null,
	Base_Salary Numeric(10,2) Check (Base_Salary > 15000),
	Bonus Numeric(10,2) Default 0,
	Hire_Date Date Not Null,
	Is_Remote Boolean Default False
);

Create Table Inventory_items(
	item_id Serial PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC CHECK (unit_price > 0),
    quantity_in_stock INT CHECK (quantity_in_stock >= 0) DEFAULT 0,
    reorder_level INT DEFAULT 10,
    last_restocked DATE DEFAULT CURRENT_DATE
);

Create Table Transactions (
    transaction_id Serial PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    staff_name VARCHAR(100) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL DEFAULT 'Purchase',
    quantity INT CHECK (quantity > 0),
    amount NUMERIC CHECK (amount > 0),
    transaction_time TIMESTAMP NOT NULL
);

Insert into Staff(Full_Name,Email,Designation,Department,Base_Salary,Bonus,Hire_Date)
Values
	('Rohit Malhotra','rohit.m@novatech.com','Manager','Warehouse',78000,5000,'2019-04-12'),
	('Devansh Gupta','devansh.g@novatech.com','Clerk','Warehouse',32000,1500,'2022-02-01'),
	('Farhan Ali','farhan.ali@novatech.com','Supervisor','Warehouse',49000,2000,'2023-09-10');

Insert into Staff(Full_Name,Email,Designation,Department,Base_Salary,Hire_Date,Is_Remote)
Values
	('Priya Nair','priya.nair@novatech.com','Accountant','Finance',55000,'2021-08-1',True),
	('Meera Kulkarni','meera.k@novatech.com','Analyst','Finance',61000,'2020-06-25',True);

Insert Into Inventory_items (item_name, category, unit_price, quantity_in_stock, reorder_level)
VALUES
	('Steel Bolts (Box)', 'Hardware', 250, 800, 100),
	('Safety Helmets', 'Safety Gear', 620, 90, 20),
	('Cardboard Sheets', 'Supplies', 30, 3000, 500);

Insert Into Inventory_items (item_name, category, unit_price, quantity_in_stock)
VALUES
	('Packing Tape', 'Supplies', 45, 1200),
	('Forklift Batteries', 'Equipment', 15500, 6);

Insert Into Transactions (item_name, staff_name, quantity, amount, transaction_time)
VALUES
	('Steel Bolts (Box)', 'Rohit Malhotra', 50, 12500, '2024-02-01 09:00:00');

Insert Into Transactions (item_name, staff_name, transaction_type, quantity, amount, transaction_time)
VALUES
	('Forklift Batteries', 'Farhan Ali', 'Purchase', 2, 31000, '2024-02-03 13:20:00'),
	('Packing Tape', 'Devansh Gupta', 'Sale', 100, 4500, '2024-02-05 10:15:00'),
	('Safety Helmets', 'Meera Kulkarni', 'Return', 5, 3100, '2024-02-07 15:45:00'),
	('Cardboard Sheets', 'Rohit Malhotra', 'Sale', 400, 12000, '2024-02-10 11:30:00');

-- Retrieve the `full_name` and `base_salary` columns for every row in `staff`.
Select Full_Name , Base_Salary from Staff;

-- Retrieve every column from `inventory_items` where `quantity_in_stock` is less than 100.
Select * from Inventory_items where quantity_in_stock < 100;

-- Retrieve all staff whose `department` is `'Warehouse'` **and** whose `base_salary` is greater than or equal to 40000.
Select * from Staff where Department = 'Warehouse' And Base_Salary >= 40000;

-- Retrieve all staff whose `department` is `'Finance'` **or** whose `is_remote` value is `true`.
Select * from Staff where Department = 'Finance' And Is_remote= True;

-- Retrieve all staff who are **not** in the `'Warehouse'` department.
Select * from staff where Department != 'Warehouse';

-- Retrieve all inventory items whose `category` is `'Supplies'` **and** whose `unit_price` is less than 40.
Select * from Inventory_Items where Category = 'Supplies' And Unit_Price < 40;

-- Retrieve all transactions where `transaction_type` is `'Sale'` **and** `amount` is greater than 5000, **or** where `transaction_type` is `'Return'`.
Select * from Transactions Where transaction_type = 'Sale' Or transaction_type = 'Return' And amount > 5000;

-- Retrieve all staff whose `base_salary` is greater than 45000 **and** less than 70000.
Select * from Staff Where Base_Salary > 45000 And Base_Salary < 70000;

-- Retrieve the `item_name`, `unit_price`, and `quantity_in_stock` columns for every inventory item whose `unit_price` is not equal to 45.
Select Item_name , Unit_Price , quantity_in_stock from Inventory_Items Where unit_price != 45;

-- Update Priya Nair's record in `staff` 
-- so that her `designation` becomes `'Senior Accountant'` and her `base_salary` becomes 60000, in a single statement.
Update Staff
Set Designation = 'Senior Accountant',
	Base_Salary = 60000
Where Full_Name = 'Priya Nair';

-- Give every staff member in the `'Warehouse'` 
-- department a bonus increase of 1000, added on top of their current `bonus` value.
Update Staff
Set Bonus = Bonus+1000
where Department = 'Warehouse';

-- Update every staff member 
-- whose `base_salary` is less than 40000 **and** whose `department` is `'Warehouse'` so that `is_remote` becomes `false`.
Update Staff
Set Is_remote = False
Where Base_Salary < 40000 And Department = 'Warehouse';

-- Update the `inventory_items` table so that every item with `quantity_in_stock` 
-- less than 100 has its `quantity_in_stock` increased by 200.
Update Inventory_Items
Set quantity_in_stock = quantity_in_stock + 200
Where quantity_in_stock < 100;

-- Update every transaction where `transaction_type` is `'Purchase'` so that `transaction_type` becomes `'Restock'`.
Update Transactions
Set transaction_type = 'Restock'
Where transaction_type = 'Purchase';

-- Update Devansh Gupta's record so that his `department` column is set to `NULL`.
UPDATE Staff
SET Department = Null
WHERE Full_Name = 'Devansh Gupta';

-- Update every row in `inventory_items` so that `last_restocked` becomes `'2024-02-15'`.
Update Inventory_Items
Set last_restocked = '2024-02-15';

-- Delete every transaction where `transaction_type` is `'Return'` **and** `amount` is less than 4000.
Delete From Transactions 
Where transaction_type = 'Return' And amount < 4000;

-- Delete every staff record where `department` is `'Finance'` **or** `base_salary` is less than 35000.
Delete From Staff
Where Department = 'Finance' Or Base_Salary < 35000;

-- Delete all rows from the `transactions` table while keeping the table structure intact.
Delete from Transactions;

-- Remove the `is_remote` column from `staff`.
Alter Table Staff
Drop Column Is_remote;

-- Remove the `reorder_level` and `last_restocked` columns from `inventory_items` in a single statement.
Alter Table Inventory_Items
Drop Column reorder_level,
Drop Column last_restocked;

-- Remove a column named `discount_code` from `transactions`, 
-- using a method that will not throw an error if the column does not exist.
Alter Table Transactions
Drop Column if Exists discount_code;

-- Delete the `transactions` table completely.
Drop Table Transactions;

-- Delete the `staff` and `inventory_items` tables in a single statement, 
-- using a method that will not throw an error if either table does not exist.
Drop Table if Exists Staff , Inventory_Items;

-- Delete a database named `novatech_payroll_old_db`, using a method that 
-- will not throw an error if the database does not exist. (Assume you are connected to a different database while running this.)
Drop Database if Exists Novatech_Payroll_Old_DB;




























