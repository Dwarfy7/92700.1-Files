-- JOIN
--1
SELECT P.ProductName, c.CategoryName
FROM Products p
	INNER JOIN Categories c
ON p.CategoryID = c.CategoryID


--2
SELECT p.ProductName, s.CompanyName
FROM Products p
	INNER JOIN Suppliers s
ON p.SupplierID = s.SupplierID


--3
SELECT o.OrderID, c.CompanyName
FROM Orders o
	INNER JOIN Customers c
ON o.CustomerID = c.CustomerID
WHERE 1=1
	AND c.CompanyName LIKE 'A%'


--4
SELECT r.RegionDescription, t.TerritoryDescription
FROM Region r
	JOIN Territories t
ON r.RegionID = t.RegionID


--5
SELECT p.ProductName, p.UnitPrice, c.CategoryName
FROM Products p
	JOIN Categories c
ON p.CategoryID = c.CategoryID
WHERE 1=1
	AND p.UnitPrice > 50


--6 BUGGED
--7
SELECT p.ProductID, p.UnitPrice, p.SupplierID, c.CategoryName
FROM Products p
	JOIN Categories c
ON p.CategoryID = c.CategoryID
WHERE 1=1
	AND c.CategoryName LIKE '%A%'


--8 
SELECT p.ProductName, c.CategoryName, s.CompanyName
FROM Products p
	JOIN Categories c
ON p.CategoryID = c.CategoryID
	JOIN Suppliers s
ON s.SupplierID = p.SupplierID


--9
SELECT p.ProductName, c."Description", s.City
FROM Products p 
	JOIN Categories c
ON c.CategoryID = p.CategoryID
	JOIN Suppliers s
ON s.SupplierID = p.SupplierID
WHERE 1=1
	AND s.City IN ('LONDON','TOKYO')


--10
SELECT p.ProductID, c."Description",s.Country
FROM Products p
	JOIN Categories c
ON p.CategoryID = c.CategoryID
	JOIN Suppliers s
ON s.SupplierID = p.SupplierID
WHERE 1=1
	AND s.Country LIKE 'A%'


--11
SELECT c.CompanyName, o.OrderID
FROM Customers c 
	LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID


--12
SELECT o.OrderID, o.OrderDate, o.ShipAddress,
c.CustomerID, c.CompanyName, c.Phone
FROM Orders o
	JOIN Customers c
ON o.CustomerID = c.CustomerID
WHERE 1=1
	AND YEAR(o.OrderDate) = '1996'
	AND c.CustomerID LIKE ('[AC]%')


--13
SELECT o.OrderID, o.OrderDate, o.ShipAddress,
c.CustomerID, c.CompanyName, c.Phone,
e.FirstName, e.LastName
FROM Orders o
	JOIN Customers c
ON o.CustomerID = c.CustomerID
	JOIN Employees e
ON e.EmployeeID = o.EmployeeID
WHERE 1=1
	AND YEAR(o.OrderDate) = '1996'
	AND c.CustomerID LIKE ('[AC]%')
ORDER BY o.OrderDate DESC


--14A
SELECT e.EmployeeID, e.LastName AS "EMPName", e.ReportsTo, eM.LastName AS "ManagerName"
FROM Employees e
	 JOIN Employees eM
ON e.ReportsTo = eM.EmployeeID


--14B
SELECT e.EmployeeID, e.LastName AS "EMPName", e.ReportsTo, eM.LastName AS "ManagerName"
FROM Employees e
	LEFT JOIN Employees eM
ON e.ReportsTo = eM.EmployeeID


--15
SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products p
	JOIN Products p2
ON p.UnitPrice > p2.UnitPrice
	AND p2.ProductName = 'ALICE MUTTON'
WHERE 1=1 


--EXTRA HARD 1
SELECT o.OrderID, p.ProductID, p.ProductName,p.UnitPrice
FROM Orders o 
	JOIN [Order Details] od
ON od.OrderID = o.OrderID
	RIGHT JOIN Products p
ON p.ProductID = od.ProductID


--EXTRA HARD 2
SELECT c.CustomerID,c.CompanyName,
		o.OrderID,o.OrderDate,o.EmployeeID,
		e.FirstName + ' ' + e.LastName AS "FullName",
		p.ProductID,p.ProductName,
		od.UnitPrice,od.Discount,od.Quantity,od.UnitPrice*od.Quantity*(1- od.Discount) AS "DiscountPrice"
FROM Customers c
	LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
	LEFT JOIN Employees e
ON e.EmployeeID = o.EmployeeID
	LEFT JOIN [Order Details] od
ON od.OrderID = o.OrderID
	LEFT JOIN Products p
ON p.ProductID = od.ProductID


--EXTRA HARD 3 BUGGED


--EXTRA HARD 4
SELECT e.EmployeeID, e.HireDate
FROM Employees e
	JOIN Employees e5
ON e.HireDate < e5.HireDate
	AND e5.EmployeeID = 5


--EXTRA HARD 5
SELECT e.EmployeeID,e.FirstName,e.LastName,e.HireDate,
		em.EmployeeID,em.LastName,em.HireDate
FROM Employees e
	JOIN Employees em
ON e.ReportsTo = em.EmployeeID
WHERE 1=1
	AND e.HireDate < em.HireDate

	
