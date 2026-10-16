CREATE TABLE Online_Customers(
	Customer_ID INT,
	Full_Name VARCHAR(70),
	Email VARCHAR(100),
	City VARCHAR(50),
	Signup_Date DATE
);


CREATE TABLE Marketplace_Customers(
	Cutomer_ID INT,
	Full_Name VARCHAR(50),
	Email VARCHAR(50),
	City VARCHAR(50),
	Signup_Date DATE
);

CREATE TABLE Product_Catalog(
	Product_ID INT,
	Product_Name VARCHAR(70),
	Category VARCHAR(100),
	Unit_Price Numeric(10,2),
	Stock_Quantity INT,
	Last_Updated DATE
);

CREATE TABLE Order_Transactions(
	Transaction_ID INT,
	Customer_ID INT,
	Product_ID INT,
	Channel VARCHAR(50),
	Quantity INT,
	Unit_Price NUMERIC(10,2),
	Transaction_Date DATE,
	Payment_Status VARCHAR(100)
);

-- Task A1 — Build and Load
-- Create all four tables described in Section 4 and import all four CSV files into them.

-- Task A2 — Raw Value Inspection
--Before cleaning anything, list every distinct raw value currently stored in `product_catalog.category` 
--and every distinct raw value in `order_transactions.channel`. 
-- Do the same for `online_customers.city` and `marketplace_customers.city`.
SELECT DISTINCT Category 
FROM Product_Catalog;

SELECT DISTINCT Channel
FROM Order_Transactions;

SELECT DISTINCT City 
FROM Online_Customers;

SELECT DISTINCT City 
FROM Marketplace_Customers;

-- Task A3 — First-Look Ranking
-- Without filtering out any bad data yet, retrieve: 
-- (a) the 10 most recently updated products
-- (b) the 10 earliest transactions by date
-- (c) the 10 highest-priced products. 
-- Then write 2–3 sentences on anything that looks suspicious in these previews.
SELECT Product_ID , Product_Name ,
	Last_Updated AS Most_Recently_Updated
FROM Product_Catalog
ORDER BY Last_Updated DESC
LIMIT 10;

SELECT Transaction_ID , Product_ID , Customer_ID,
	Transaction_Date AS Earliest_Transactions
FROM Order_Transactions
ORDER BY Transaction_Date ASC
LIMIT 10;

SELECT Product_ID , Product_Name ,
 	Unit_Price AS Highest_Price_Product
FROM Product_Catalog
ORDER BY Unit_Price DESC
LIMIT 10;

-- Task B1 — Missing Value Audit
-- Retrieve every row across the four tables where a column that should normally hold a value is empty instead 
-- (think about which columns in each table are realistically allowed to be missing, and which are not).
SELECT * FROM Online_Customers
WHERE Full_Name IS NULL 
	OR Email IS NULL
	OR City IS NULL
	OR Signup_Date IS NULL;

SELECT * FROM Marketplace_Customers
WHERE Full_Name IS NULL 
	OR Email IS NULL
	OR City IS NULL
	OR Signup_Date IS NULL;

SELECT * FROM Product_Catalog
WHERE Product_Name IS NULL 
	OR Category IS NULL
	OR Unit_Price IS NULL
	OR Stock_Quantity IS NULL
	OR Last_Updated IS NULL

SELECT * FROM Order_Transactions
WHERE Channel IS NULL 
	OR Quantity IS NULL
	OR Unit_Price IS NULL
	OR Transaction_Date IS NULL
	OR Payment_Status IS NULL;

-- Task B2 — Invalid Numeric Values
-- Find every product with a price or stock level that could not exist in the real world, 
-- and every transaction with a quantity that could not exist in the real world.
SELECT Product_Name , Unit_Price , Stock_Quantity
FROM Product_Catalog
WHERE Unit_Price <= 0 OR Stock_Quantity <= 0;

SELECT Transaction_ID , Quantity
FROM Order_Transactions
WHERE Quantity <= 0;

-- Task B4 — Standardizing Inconsistent Text
-- Using what you found in Task A2, bring every `category` value in `product_catalog` and every `channel` 
-- value in `order_transactions` to one consistent spelling/casing per real-world value (you decide the canonical form). 
-- Rows with a genuinely missing value should be left for Task B5.
UPDATE Product_Catalog
SET Category = 'Fitness'
WHERE Category = 'FITNESS' OR Category = 'fitness';

UPDATE Product_Catalog
SET Category = 'Electronics'
WHERE Category = 'electronics' OR Category = 'Electronics' OR Category = 'ELECTRONICS';

UPDATE Product_Catalog
SET Category = 'Stationery'
WHERE Category = 'stationery' OR Category = 'STATIONERY' OR Category = 'Stationery';

UPDATE Product_Catalog
SET Category = 'Furniture'
WHERE Category = 'Furniture' OR Category = 'furniture';

UPDATE Product_Catalog
SET Category = 'Kitchenware'
WHERE Category = 'Kitchenware' OR Category = 'kitchenware';

UPDATE Product_Catalog
SET Category = 'Lifestyle'
WHERE Category = 'LIFESTYLE' or Category = 'Lifestyle' OR Category = 'lifestyle' ;

UPDATE Order_Transactions
SET Channel = 'Marketplace'
WHERE Channel = 'Market place' OR Channel = 'marketplace' OR Channel = 'MARKETPLACE';

UPDATE Order_Transactions
SET Channel = 'Online'
WHERE Channel = 'online' OR Channel = 'Online' OR Channel = 'ONLINE';

-- Task B5 — Handling Missing Values
-- For the rows with a genuinely missing `category` or `payment_status` (found in Task B1), 
-- decide whether to fill them with a clear placeholder value or remove those rows entirely. 
-- Apply your decision, and justify it in 1–2 sentences.
UPDATE Product_Catalog
SET Category = 'Unknown'
WHERE Category IS NULL;

UPDATE Order_Transactions
SET Payment_Status = 'Unknown'
WHERE Payment_Status IS NULL;

-- Task C1 — Derived Revenue
-- For transactions with a valid (positive) quantity, compute a `total_amount` for each (quantity × unit price), 
-- label it clearly, and show the 15 highest-value ones.
SELECT Transaction_ID , Customer_ID,
	(Quantity * Unit_Price) AS Total_Amount FROM Order_Transactions
WHERE Quantity > 0
ORDER BY Total_Amount DESC
LIMIT 15;

-- Task C2 — Benchmark Pricing (Two-Step)
-- First, find the average `unit_price` across the product catalog. Then, in a second query, 
-- list every product priced above that figure, sorted from most to least expensive. 
-- (Your notes do not cover nesting one query inside another — this is meant to be done as two separate steps.)
-- If you know Subquery you can also apply
SELECT Product_ID , Product_Name
FROM Product_Catalog
WHERE Unit_Price > (SELECT AVG(Unit_Price) FROM Product_Catalog)

-- **Task C3 — Pattern-Based Customer Search**
-- In each customer table separately, find customers whose name follows a pattern you choose 
-- (e.g. starts with a certain letter and contains another letter somewhere in it),
-- whose signup date falls in a range you choose, and whose city is one of a short list you choose.
SELECT * FROM Online_Customers
WHERE Full_Name LIKE 'S%a%'
  AND Signup_Date BETWEEN '2023-01-01' AND '2024-12-31'
  AND City IN ('Delhi', 'Mumbai', 'Pune');

SELECT * FROM Marketplace_Customers
WHERE Full_name LIKE 'S%a%'
  AND Signup_Date BETWEEN '2023-01-01' AND '2024-12-31'
  AND City IN ('Delhi', 'Mumbai', 'Pune');

-- **Task C4 — Exclusion Filtering**
-- From `order_transactions`, find every transaction that is outside a date range you choose, 
-- does **not** have a payment status from a short list you choose, and does have some payment status recorded at all 
-- (i.e. it isn't one of the missing ones from Section B).
SELECT Transaction_ID , Customer_ID , Transaction_Date , Payment_Status 
FROM Order_Transactions
WHERE Transaction_Date NOT BETWEEN '2024-06-01' AND '2024-08-31'
AND Payment_Status NOT IN ('Refunded', 'Failed')
OR Payment_Status IS NOT NULL;

-- **Task C5 — Choose Your Own Operators**
-- Write one query that answers this business question exactly as worded: *
-- "Which products are priced unusually low or unusually high compared to the rest of the catalog, 
-- and are not from the Stationery or Kitchenware categories?"* You decide what counts as "unusually low or high" 
-- and which operators best express the full condition.
SELECT Category , Unit_Price 
FROM Product_Catalog
WHERE (Unit_Price < 5000 OR Unit_Price > 20000) AND Category NOT IN ('Stationery' ,'Kitchen ware"');

-- **Task D1 — Master Customer List (UNION)**
-- Combine `customer_id` and `full_name` from both customer tables into one deduplicated list, sorted alphabetically by name.
SELECT Customer_ID , Full_Name
FROM Online_Customers

UNION

SELECT Cutomer_ID , Full_Name
FROM Marketplace_Customers
ORDER BY Full_Name;

-- **Task D2 — Full Combined List (UNION ALL)
-- Run the same combination as D1 but keep every row, duplicates included
SELECT Customer_ID , Full_Name
FROM Online_Customers

UNION ALL

SELECT Cutomer_ID , Full_Name
FROM Marketplace_Customers
ORDER BY Full_Name;

-- **Task D3 — Multi-Channel Customers (INTERSECT)**
-- Find the customers (`customer_id` + `full_name`) who appear in **both** customer tables — 
-- these are your multi-channel shoppers. Sort by `customer_id`.
SELECT Customer_ID , Full_Name 
FROM Online_Customers

INTERSECT 

SELECT Cutomer_ID , Full_Name 
FROM Marketplace_Customers;

-- **Task D4 — Channel-Exclusive Customers (EXCEPT)**
-- Write two separate queries: 
-- (a) customers who exist only in `online_customers` and never in `marketplace_customers
-- (b) customers who exist only in `marketplace_customers` and never in `online_customers`. 
SELECT * FROM Online_Customers

EXCEPT

SELECT * FROM Marketplace_Customers
-------------------------------------------
SELECT * FROM Marketplace_Customers

EXCEPT

SELECT * FROM Online_Customers;

-- **Task D5 — Filtered Set Combination**
-- *Which customers signed up during 2024 and belong to only one of the two channels?"* 
-- You will need to apply a filter to each individual `SELECT` **before** combining them — 
-- think about which set operator fits "belongs to only one channel," and 
-- why filtering has to happen inside each `SELECT` rather than after the combination.
(
SELECT * FROM Online_Customers 
WHERE Signup_Date > '2024-01-01' 
AND Signup_Date < '2025-01-01'

EXCEPT 

SELECT * FROM Marketplace_Customers 
WHERE Signup_Date > '2024-01-01' 
AND Signup_Date < '2025-01-01'

)

UNION

(
SELECT * FROM Marketplace_Customers 
WHERE Signup_Date > '2024-01-01' 
AND Signup_Date < '2025-01-01'

EXCEPT 

SELECT * FROM Online_Customers 
WHERE Signup_Date > '2024-01-01' 
AND Signup_Date < '2025-01-01'
);

-- **Task E1 — Top Spender Investigation**
-- Using your cleaned, valid transactions, find the 10 highest-value ones (reuse your approach from C1). 
SELECT Transaction_ID , Customer_ID,
	(Quantity * Unit_Price) AS Total_Amount FROM Order_Transactions
WHERE Quantity > 0
ORDER BY Total_Amount DESC
LIMIT 10;

-- **Task E2 — Category Price Comparison**
-- Pick two product categories. For each, retrieve its 5 most expensive products. 
SELECT Product_Name , Category, Unit_Price
FROM Product_Catalog
WHERE Category IN ('Life Style' , 'Stationery')
ORDER BY Unit_Price DESC
LIMIT 5;


















