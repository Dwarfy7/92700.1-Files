-- GROUP FUNCTIONS
--1
SELECT MIN(e.LastName)
FROM Employees e


--2
SELECT MAX(e.FirstName)
FROM Employees e


--3
SELECT COUNT(*)
FROM Employees e


--4
SELECT COUNT(e.Region)
FROM Employees e


--5
SELECT AVG(p.UnitPrice)
FROM Products p


--6
SELECT MAX(p.UnitPrice) AS "MAX",
	   AVG(p.UnitPrice) AS"AVG"
FROM Products p


--7
SELECT CONVERT(VARCHAR,MIN(e.BirthDate),113) AS "MIN_BirthDate",
	   CONVERT(VARCHAR,MAX(e.BirthDate),113) AS "MAX_BirhDate"
FROM Employees e


--8
SELECT COUNT(c.CustomerID)
FROM Customers c


--9
SELECT COUNT(DISTINCT o.CustomerID)
FROM Orders o


--10
SELECT p.CategoryID,
	MAX(p.UnitPrice) AS "MAX",
	MIN(p.UnitPrice) AS "MIN",
	AVG(p.UnitPrice) AS "AVG"
FROM Products p
GROUP BY p.CategoryID


--11
SELECT p.SupplierID, 
	MAX(p.UnitPrice)
FROM Products p
GROUP BY p.SupplierID
ORDER BY p.SupplierID DESC


--12
SELECT p.SupplierID,
	AVG(p.UnitsInStock) AS "AVG_STOCK"
FROM Products p
GROUP BY p.SupplierID
ORDER BY "AVG_STOCK" DESC


--13
SELECT c.Country,c.City,
	COUNT(*) "Customer_Num"
FROM Customers c
GROUP BY c.Country,c.City


--14
SELECT p.CategoryID, 
	AVG(p.UnitPrice)
FROM Products p
WHERE p.UnitPrice > 40
GROUP BY p.CategoryID


--15
SELECT c.City, 
	COUNT(c.City)
FROM Customers c
WHERE c.City IN ('BERLIN','LONDON','PARIS','RIO DE JANEIRO')
GROUP BY c.city


--16
SELECT p.CategoryID, p.SupplierID, 
	MAX(p.UnitPrice) AS "MAX",
	MIN(p.UnitPrice) AS "MIN",
	AVG(p.UnitPrice) AS "AVG",
	COUNT(*) AS "COUNT"
FROM Products p
GROUP BY p.CategoryID, p.SupplierID


--17
SELECT p.CategoryID,
	MAX(p.UnitPrice)
FROM Products p
GROUP BY p.CategoryID
HAVING MAX(p.UnitPrice) > 40


--18
SELECT p.SupplierID,
	AVG(p.UnitPrice) AS "AVG"
FROM Products p
GROUP BY p.SupplierID
HAVING AVG(p.UnitPrice) > 40


--19
SELECT p.CategoryID, c.CategoryName,
	SUM(p.UnitsOnOrder) AS "Total_Orders" , 
	SUM(p.UnitsInStock) AS "Total_Stock"
FROM Products p
	JOIN Categories c
ON c.CategoryID = p.CategoryID
WHERE 1=1
	AND c.CategoryName LIKE '%C%'
GROUP BY p.CategoryID, c.CategoryName
HAVING SUM(p.UnitsOnOrder) > 100
ORDER BY c.CategoryName 


-- BONUS 20
SELECT c.Region,c.City,
	COUNT(*) AS "Customers"
FROM Customers c
WHERE 1=1
	AND c.City LIKE '%[mL]%'
	AND c.Region IS NOT NULL
GROUP BY c.Region,c.City
HAVING COUNT(*) >=2


--BONUS 21
SELECT e.LastName, 
	COUNT(o.OrderID) AS "Order_Count",
	MAX(o.OrderDate) AS "LastDate"
FROM Employees e
	JOIN Orders o
ON e.EmployeeID = o.EmployeeID
WHERE 1=1
GROUP BY e.LastName
HAVING COUNT(o.OrderID) >100


-- EXTRA HARD 1
SELECT c.CategoryID,c.CategoryName,
	COUNT(p.UnitsInStock) AS "Num_Of_Units_InStock",
	AVG(p.UnitPrice) AS "AVG_Price"
FROM Categories c
	JOIN Products p
ON c.CategoryID = p.CategoryID
WHERE 1=1
	AND c.CategoryID BETWEEN 1 AND 5
GROUP BY c.CategoryID,c.CategoryName
HAVING COUNT(p.UnitsInStock) > 10
ORDER BY "AVG_Price"


-- EXTRA HARD 2
SELECT c.CustomerID,c.CompanyName,c.Phone,
	COUNT(o.OrderID) AS "Orders"
FROM Customers c
	LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID,c.CompanyName,c.Phone


-- EXTRA HARD 3
SELECT c.CustomerID,c.CompanyName,c.Phone,
	COUNT(o.OrderID) AS "Orders"
FROM Customers c
	LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID,c.CompanyName,c.Phone
HAVING COUNT(o.OrderID) =0


-- EXTRA HARD 4
SELECT c.CustomerID,c.CompanyName,c.Phone,
	COUNT(o.OrderID) AS "Orders",
	SUM(od.UnitPrice*od.Quantity) AS "Paid"
FROM Customers c
	LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
	LEFT JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP BY c.CustomerID,c.CompanyName,c.Phone
ORDER BY "Paid"


-- EXTRA HARD 5
SELECT e.EmployeeID,e.LastName+' '+e.FirstName AS "FullName",
	YEAR(o.OrderDate) AS "YEAR",
	COUNT(o.OrderID) AS "OrdersDone"
FROM Employees e
	JOIN Orders o
ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID,e.LastName+' '+e.FirstName ,YEAR(o.OrderDate)
ORDER BY e.EmployeeID


-- EXTRA HARD 6
SELECT TOP 3 e.EmployeeID,e.LastName+' '+e.FirstName AS "FullName",
	YEAR(o.OrderDate) AS "YEAR",
	COUNT(o.OrderID) AS "OrdersDone"
FROM Employees e
	JOIN Orders o
ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID,e.LastName+' '+e.FirstName ,YEAR(o.OrderDate)
ORDER BY COUNT(o.OrderID) DESC


-- EXTRA HARD 7
SELECT m.EmployeeID,m.LastName,
	COUNT(e.ReportsTo) "His Employees"
FROM Employees e 
	JOIN Employees m
ON e.ReportsTo = m.EmployeeID
GROUP BY m.EmployeeID,m.LastName


-- EXTRA HARD 8
SELECT YEAR(OrderDate) AS "YEAR",
	COUNT(o.OrderID) AS "Orders Done",
	SUM(od.UnitPrice) AS "Total Price",
	AVG(od.UnitPrice) as "AVG Price"
FROM Orders o
	JOIN [Order Details] od
ON o.OrderID = od.OrderID
GROUP BY YEAR(OrderDate)
