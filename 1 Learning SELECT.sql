-- 9.
SELECT distinct 
	City
FROM Employees

-- 10.
SELECT distinct
	country
from Employees

-- 11.
SELECT distinct
	Title
from Employees

-- 12 א.
SELECT
	c.Country
	, c.City 
FROM Customers c

-- 12 ב.
SELECT distinct
	c.Country
	,c.City
FROM Customers c

-- 12 ג.
/* "distinct" fillters out all the rows that are the same,
making it have less rows. */

-- 13.
SELECT
	e.FirstName
	,e.BirthDate
	,e.BirthDate + 5 AS "BirthDate_In_5_Days"

FROM Employees e

-- 14.
SELECT
	p.ProductName
	,p.UnitPrice
	,p.UnitPrice + 10 AS "UnitPrice+10"
FROM Products p

-- 15.
SELECT
	p.ProductID
	,p.ProductName
	,p.UnitPrice
	,p.UnitPrice * 1.165 AS "Price_AfterTax"
	,p.UnitsInStock
	,p.UnitsOnOrder
	,p.UnitsInStock - p.UnitsOnOrder AS "Sum"
FROM Products p

-- 16.
SELECT
	p.ProductID
	,p.ProductName
	,(p.UnitsInStock - p.UnitsOnOrder) * p.UnitPrice AS "NotOrdered_Units_Value"
FROM Products p