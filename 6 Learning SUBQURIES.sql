-- SUBQURIES
--1
SELECT p.ProductName, p.UnitPrice
FROM Products p
WHERE 1=1
	AND p.UnitPrice < (SELECT p2.UnitPrice
					FROM Products p2
					WHERE p2.ProductID = 8)


--2
SELECT p.ProductName,p.UnitPrice
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT p2.UnitPrice
						FROM Products p2
						WHERE p2.ProductName = 'tofu')


--3
SELECT e.LastName, e.HireDate
FROM Employees e
WHERE 1=1
	AND e.HireDate > (SELECT e2.HireDate
						FROM Employees e2
						WHERE e2.EmployeeID = 6)


--4
SELECT p.ProductID,p.ProductName,p.UnitPrice
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT AVG(p2.UnitPrice)
						FROM Products p2)


--5
SELECT p.ProductName,p.UnitsInStock
FROM Products p
WHERE 1=1
	AND p.UnitsInStock < (SELECT MIN(p2.UnitsInStock)
						   FROM Products p2
						   WHERE p2.CategoryID = 5)


--6
SELECT *
FROM Products p
WHERE 1=1
	AND p.CategoryID = (SELECT p2.CategoryID
						FROM Products p2
						WHERE p2.ProductName = 'chai')
	AND p.ProductName != 'CHAI'


--7
SELECT p.ProductName,p.UnitPrice,p.CategoryID
FROM Products p
WHERE 1=1
	AND p.UnitPrice IN (SELECT p2.UnitPrice
						FROM Products p2
						WHERE p2.CategoryID = 5)


--8
SELECT p.ProductName,p.UnitPrice
FROM Products p
WHERE 1=1
	AND p.UnitPrice >  (SELECT MIN(p2.UnitPrice) -- MIN>> because u need bigger then any of theese then do bigger then the min
						FROM Products p2
						WHERE p2.CategoryID = 5)


--9
SELECT p.ProductName,p.UnitPrice
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT MAX(p2.UnitPrice) -- MAX>> because u need bigger then all the priceses in cate5 if 
						FROM Products p2            --its bigger then the max then its bigger then all
						WHERE p2.CategoryID = 5)


--10
SELECT o.OrderID,o.OrderDate
FROM Orders o
WHERE 1=1
	AND o.CustomerID IN (SELECT c.CustomerID
		  FROM Customers c
		  WHERE c.Country IN ('FRANCE','GERMANY','SWEDEN'))
	AND YEAR(o.OrderDate) = '1997'



--11
SELECT p.ProductName,p.ProductID
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT AVG(p2.UnitPrice)
						FROM Products p2
						WHERE p2.UnitsInStock > 50)


--12
SELECT p.ProductName
FROM Products p
WHERE 1=1
	AND p.CategoryID IN (SELECT c.CategoryID
						FROM Categories c
						WHERE c.CategoryName IN ('BEVERAGES','CONDIMENTS'))
    AND p.SupplierID IN (SELECT s.SupplierID
						FROM Suppliers s
						WHERE s.Region IS NULL)


--13
SELECT s.CompanyName
FROM Suppliers s
WHERE 1=1
	AND s.SupplierID IN (SELECT p.SupplierID
						  FROM Products p
						  WHERE p.CategoryID IN (SELECT c.CategoryID
												  FROM Categories c
												  WHERE c.CategoryName = 'beverages'))


-- EXTRA HARD 1
SELECT *
FROM Employees e
WHERE 1=1
	AND e.EmployeeID IN (SELECT m.ReportsTo
						 FROM Employees m)


SELECT *
FROM Employees m
WHERE 1=1
	AND EXISTS (SELECT 1
				FROM Employees e
				WHERE m.EmployeeID = e.ReportsTo)



--EXTRA HARD 2
SELECT *
FROM Customers c
WHERE 1=1
	AND c.CustomerID IN (SELECT o.CustomerID
						 FROM Orders o)



SELECT *
FROM Customers c
WHERE 1=1
	AND EXISTS (SELECT 1
				 FROM Orders o
				 WHERE c.CustomerID = o.CustomerID)


--EXTRA HARD 3
SELECT *
FROM Customers c
WHERE 1=1
	AND c.CustomerID NOT IN(SELECT o.CustomerID
							FROM Orders o)


SELECT *
FROM Customers c
WHERE 1=1
	AND NOT EXISTS(SELECT 1
					FROM Orders o
					WHERE o.CustomerID = c.CustomerID)


--EXTRA HARD 4
SELECT *
FROM Suppliers s
WHERE 1=1
	AND s.SupplierID IN (SELECT p.SupplierID
						 FROM Products p
						 WHERE p.CategoryID IN (1,5))


SELECT *
FROM Suppliers s
WHERE 1=1
	AND EXISTS (SELECT 1
				FROM Products p
				WHERE p.CategoryID IN (1,5)
				AND p.SupplierID = s.SupplierID)


--EXTRA HARD 5
SELECT *
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT AVG(p2.UnitPrice)
						FROM Products p2)


SELECT *
FROM Products p
WHERE 1=1
	AND EXISTS (SELECT 1
				FROM Products p2
				HAVING p.UnitPrice > AVG(p2.UnitPrice))


--EXTRA HARD 6
SELECT p.CategoryID,p.ProductName,p.UnitPrice,p.ProductID
FROM Products p
WHERE 1=1
	AND p.UnitPrice > (SELECT AVG(p2.UnitPrice)
						FROM Products p2
						WHERE p.CategoryID = p2.CategoryID)


SELECT p.CategoryID,p.ProductName,p.UnitPrice,p.ProductID
FROM Products p
WHERE 1=1
	AND EXISTS (SELECT 1
						FROM Products p2
						WHERE p.CategoryID = p2.CategoryID
						HAVING p.UnitPrice > AVG(p2.UnitPrice))


--EXTRA HARD 7
SELECT e.EmployeeID,e.LastName,e.FirstName,e.HireDate,e.ReportsTo
FROM Employees e
WHERE 1=1
	AND e.HireDate < (SELECT m.HireDate
						FROM Employees m
						WHERE e.ReportsTo = m.EmployeeID)


SELECT e.EmployeeID,e.LastName,e.FirstName,e.HireDate,e.ReportsTo
FROM Employees e
WHERE 1=1
	AND EXISTS (SELECT m.HireDate
						FROM Employees m
						WHERE e.ReportsTo = m.EmployeeID
							AND e.HireDate < m.HireDate)


--EXTRA HARD 8
SELECT s.SupplierID,s.CompanyName,s.City
FROM Suppliers s
WHERE 1=1
	AND s.SupplierID IN (SELECT p.SupplierID
						 FROM Products p
						 WHERE p.CategoryID IN (SELECT c.CategoryID
												FROM Categories c
												WHERE c.CategoryName IN ('SEAFOOD','BEVERAGES')))




SELECT s.SupplierID,s.CompanyName,s.City
FROM Suppliers s
WHERE 1=1
	AND EXISTS(SELECT p.SupplierID
						 FROM Products p
						 WHERE s.SupplierID = p.SupplierID
							    AND p.CategoryID IN (SELECT c.CategoryID
												      FROM Categories c
												       WHERE c.CategoryName IN ('SEAFOOD','BEVERAGES')))



--EXTRA HARD 9
SELECT *
FROM Products p 
WHERE 1=1
ORDER BY 1
OFFSET (SELECT COUNT(*)/2-1 FROM products)ROWS 
FETCH NEXT 2 ROWS ONLY