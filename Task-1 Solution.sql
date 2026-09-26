Create Database Novatech_DB;

Create Table Employee(
	Emp_Id Serial Primary Key,
	Full_Name Varchar(70) Not Null,
	Email Varchar(100) Unique,
	Department Varchar(50),
	Salary Numeric(10,2) Check (salary >= 0),
    date_of_joining Date,
    Is_active Boolean Default TRUE
);

Create Table Department(
	Department_Id Serial Primary Key,
	Department_Name Varchar(50) Unique,
	Location Varchar(50)
);

Create Table Products(
	Product_Id Serial Primary Key,
	Product_Name Varchar(70) Not Null,
	Category Varchar(70),
	Price Numeric(50,4) check (Price > 0),
	Stock_Quantity Int Default 0,
	Order_Date Date Default Current_Date
);

Create Table Orders(
	Order_Id SER PRIMARY KEY,
    Product_Name VARCHAR(100),
    Emp_Name VARCHAR(100),
    Quantity INT CHECK (quantity >= 1),
    Order_Date TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')
)

INSERT INTO Employee
	(Full_Name, Email, Department, Salary, date_of_joining, Is_active)
VALUES
	('Ravi Sharma', 'ravi.sharma@novatech.com', 'Sales', 45000, '2022-03-15', TRUE),
	('Anita Verma', 'anita.verma@novatech.com', 'HR', 52000, '2021-07-01', TRUE),
	('Karan Mehta', 'karan.mehta@novatech.com', 'Engineering', 68000, '2020-11-20', TRUE),
	('Sneha Iyer', 'sneha.iyer@novatech.com', 'Marketing', 41000, '2023-01-10', FALSE),
	('Amitabh Rao', 'amitabh.rao@novatech.com', 'Engineering', 72000, '2019-05-05', TRUE);

INSERT INTO Department
	(Department_Name, Location)
VALUES
	('Sales', 'Mumbai'),
	('HR', 'Delhi'),
	('Engineering', 'Bangalore'),
	('Marketing', 'Pune');

INSERT INTO Products
	(Product_Name, Category, Price, Stock_Quantity)
VALUES
	('Wireless Mouse', 'Electronics', 799, 150),
	('Office Chair', 'Furniture', 5499, 40),
	('Notebook Pack', 'Stationery', 199, 500),
	('LED Monitor', 'Electronics', 8999, 25),
	('Desk Lamp', 'Furniture', 1299, 60);

INSERT INTO Orders
	(Product_Name, Emp_Name, Quantity, Order_Date, Status)
VALUES
	('Wireless Mouse', 'Ravi Sharma', 3, '2024-01-05 10:30:00', 'Delivered'),
	('LED Monitor', 'Ravi Sharma', 1, '2024-01-10 14:00:00', 'Shipped'),
	('Office Chair', 'Sneha Iyer', 2, '2024-01-12 09:15:00', 'Pending'),
	('Notebook Pack', 'Anita Verma', 10, '2024-01-15 11:45:00', 'Delivered'),
	('Desk Lamp', 'Karan Mehta', 4, '2024-01-18 16:20:00', 'Cancelled');

-- Retrieve only the Full_Name column from Employee
SELECT Full_Name
FROM Employee;


-- Retrieve Full_Name, Department and Salary from Employee
SELECT Full_Name, Department, Salary
FROM Employee;


-- Retrieve every column from Products
SELECT *
FROM Products;


-- Retrieve all employees whose Department is Engineering
SELECT *
FROM Employee
WHERE Department = 'Engineering';


-- Retrieve all employees whose Salary is greater than 50000
SELECT *
FROM Employee
WHERE Salary > 50000;


-- Retrieve all products whose Stock_Quantity is less than or equal to 40
SELECT *
FROM Products
WHERE Stock_Quantity <= 40;


-- Retrieve all employees who are in Engineering
-- and have Salary greater than 65000
SELECT *
FROM Employee
WHERE Department = 'Engineering'
AND Salary > 65000;


-- Retrieve all orders whose Status is Pending or Shipped
SELECT *
FROM Orders
WHERE Status = 'Pending'
OR Status = 'Shipped';

-- Update Ravi Sharma's department to Operations
UPDATE Employee
SET Department = 'Operations'
WHERE Full_Name = 'Ravi Sharma';


-- Update Anita Verma's email
UPDATE Employee
SET Email = 'anita.v@novatech.com'
WHERE Full_Name = 'Anita Verma';


-- Update Karan Mehta's department and salary
-- in a single statement
UPDATE Employee
SET Department = 'Product',
    Salary = 70000
WHERE Full_Name = 'Karan Mehta';


-- Increase salary by 5000 for all Engineering employees
UPDATE Employee
SET Salary = Salary + 5000
WHERE Department = 'Engineering';


-- Update every order so that Status becomes Shipped
UPDATE Orders
SET Status = 'Shipped';


-- Set Sneha Iyer's Department to NULL
UPDATE Employee
SET Department = NULL
WHERE Full_Name = 'Sneha Iyer';

-- Delete the product where Product_Name is Desk Lamp
DELETE FROM Products
WHERE Product_Name = 'Desk Lamp';


-- Delete every product whose Stock_Quantity is less than 30
DELETE FROM Products
WHERE Stock_Quantity < 30;


-- Delete all rows from Orders
-- but keep the table structure
DELETE FROM Orders;

-- Remove Is_active column from Employee
ALTER TABLE Employee
DROP COLUMN Is_active;


-- Remove Category and Order_Date columns from Products
-- in a single statement
ALTER TABLE Products
DROP COLUMN Category,
DROP COLUMN Order_Date;


-- Remove Notes column from Orders
-- without producing an error if it does not exist
ALTER TABLE Orders
DROP COLUMN IF EXISTS Notes;

-- Delete the Orders table completely
DROP TABLE Orders;


-- Delete Archive_Employees table
-- without producing an error if it does not exist
DROP TABLE IF EXISTS Archive_Employees;


-- Delete Products and Employee tables
-- in a single statement
DROP TABLE Products, Employee;