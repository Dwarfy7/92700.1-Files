--9
SELECT
	e.EmployeeID,
	e.FirstName,
	e.LastName
FROM Employees e
WHERE 1=1 
	AND E.EmployeeID IN (5,2,1)


--10
SELECT
	e.FirstName,
	e.LastName,
	e.BirthDate
FROM Employees e
WHERE 1=1 
	AND e.EmployeeID NOT IN (7,5,4)


--11
SELECT
	P.ProductID,
	P.ProductName,
	p.CategoryID
FROM Products p
WHERE 1=1
	AND p.CategoryID NOT IN (7,2,1)
ORDER BY P.CategoryID 


--12
SELECT
	e.FirstName,
	e.LastName,
	e.Region
FROM Employees e
WHERE 1=1
	AND e.Region IS NULL


--13
SELECT TOP 3
	p.ProductName,
	p.UnitPrice
FROM Products p
WHERE 1=1
ORDER BY p.UnitPrice DESC


--14
SELECT
	o.OrderID,
	o.OrderDate,
	o.RequiredDate
FROM Orders o
WHERE 1=1 
	AND o.RequiredDate > '1996-10-31'


--15
SELECT
	e.EmployeeID,
	e.LastName,
	e.ReportsTo
FROM Employees e
WHERE 1=1
	AND e.ReportsTo IS NOT NULL
ORDER BY e.EmployeeID


--16
SELECT *
FROM Categories c
WHERE 1=1
	AND c.CategoryName LIKE '%o%'
	

--17
SELECT
	c.CompanyName,
	c.Country
FROM Customers c
WHERE 1=1
	AND c.CompanyName LIKE '%A'


--18
SELECT
	p.ProductName,
	p.CategoryID
FROM Products p
WHERE 1=1
	AND p.ProductName LIKE '%a_'


--19
SELECT
	o.OrderID,
	o.CustomerID,
	o.EmployeeID
FROM Orders o
WHERE 1=1
	AND o.OrderDate BETWEEN '1997-4-1' AND '1997-5-31'
ORDER BY o.OrderDate ASC, o.CustomerID DESC


--20
SELECT
	c.CustomerID,
	c.CompanyName,
	c.Country,
	c.Region,
	c.Phone
FROM Customers c
WHERE 1=1
	AND c.Country LIKE '[GMF]%'
	AND c.Region IS NULL


--21
SELECT
	e.EmployeeID,
	e.FirstName+ ' ' + e.LastName AS "Full Name",
	e.BirthDate,
	e.Country
FROM Employees e
WHERE 1=1
	AND e.LastName LIKE '%[DK]%'
	OR e.BirthDate BETWEEN '1963-1-01' AND '1963-12-31'


--22
SELECT
	p.ProductName,
	p.UnitPrice,
	p.SupplierID
FROM Products p
WHERE 1=1
	AND p.UnitPrice >30
	AND p.SupplierID IN (1,3)


--23
SELECT 
	o.OrderID,
	o.EmployeeID,
	o.OrderDate,
	o.RequiredDate,
	o.ShipName
FROM Orders o
WHERE 1=1
	AND o.EmployeeID = 7
	AND o.ShipName IN ('QUICK-Stop','Du monde entier','Eastern Connection')
	AND o.RequiredDate - o.OrderDate >20


--24
SELECT
	p.ProductID,
	p.ProductName
FROM Products p
WHERE 1=1
	AND (p.SupplierID IN (21,8,16) 
	OR p.UnitPrice <10)
	AND p.UnitsInStock NOT BETWEEN 10 AND 100
ORDER BY p.UnitPrice


--EXTRA HARD 1
SELECT TOP 1 WITH TIES
o.CustomerID,
o.OrderDate
FROM Orders o
WHERE 1=1
	AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
ORDER BY o.OrderDate DESC


--EXTRA HARD 2
SELECT  p.CategoryID, p.ProductName, p.UnitPrice
FROM Products p
WHERE 1=1
ORDER BY  p.UnitPrice DESC
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY