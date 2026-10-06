--SET OPERATORS ADV
--1
SELECT  cost.ProductID,cost.StartDate,cost.EndDate,cost.StandardCost
FROM Production.ProductCostHistory cost

UNION

SELECT p.ProductID,NULL,NULL,p.StandardCost
FROM Production.Product p


--2
SELECT s.SalesOrderID,s.OrderDate,s.ShipDate,s.Status,s.CustomerID,FORMAT(s.TotalDue,'C','en-US') AS TotalDue
FROM Sales.SalesOrderHeader s
WHERE S.ShipDate = '2023-3-12'

UNION

SELECT NULL,NULL,NULL,NULL,NULL,FORMAT(SUM(TotalDue),'C','en-US')
FROM Sales.SalesOrderHeader s2
WHERE S2.ShipDate = '2023-3-12'


--3
SELECT S.SalesOrderID,
	CAST(S.ProductID AS VARCHAR) AS ProductID,
	CAST(S.OrderQty AS VARCHAR) AS OrderQty,
	CAST(S.UnitPrice AS VARCHAR) AS UnitPrice,
	CAST(S.UnitPriceDiscount AS VARCHAR) AS UnitPriceDiscount,
	FORMAT(S.LineTotal,'C','en-us') AS LineTotal
FROM Sales.SalesOrderDetail S

UNION

SELECT so.SalesOrderID,' ',' ',' ','TOTAL -->',
	FORMAT(so.TotalDue,'C','en-us')
FROM Sales.SalesOrderHeader So
ORDER BY SalesOrderID,ProductID DESC


--4 A
SELECT sh.CustomerID
FROM Sales.SalesOrderHeader sh
WHERE sh.OrderDate = '2023-8-27'

UNION ALL

SELECT ssh.CustomerID
FROM Sales.SalesOrderHeader ssh
WHERE ssh.OrderDate = '2024-6-24'


--4 B
SELECT sh.CustomerID
FROM Sales.SalesOrderHeader sh
WHERE sh.OrderDate = '2023-8-27'

INTERSECT

SELECT ssh.CustomerID
FROM Sales.SalesOrderHeader ssh
WHERE ssh.OrderDate = '2024-6-24'


--4 C
SELECT sh.CustomerID
FROM Sales.SalesOrderHeader sh
WHERE sh.OrderDate = '2023-8-27'

EXCEPT

SELECT ssh.CustomerID
FROM Sales.SalesOrderHeader ssh
WHERE ssh.OrderDate = '2024-6-24'


--5
SELECT pc.Name AS Category,
	pp.Name AS "Product",
	FORMAT(pp.ListPrice,'C','en-us') AS ListPrice
FROM Production.Product pp
	JOIN Production.ProductSubcategory ps
ON ps.ProductSubcategoryID = pp.ProductSubcategoryID
	JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID

UNION

SELECT pc2.Name + ' ' + '-->',
	'AVG Price:' + ' ' + FORMAT(AVG(pp2.ListPrice),'C','en-us'),
	'TOTAL:' + ' ' + FORMAT(SUM(pp2.ListPrice),'C','en-us')
FROM Production.Product pp2
	JOIN Production.ProductSubcategory ps2
ON ps2.ProductSubcategoryID = pp2.ProductSubcategoryID
	JOIN Production.ProductCategory pc2
ON pc2.ProductCategoryID = ps2.ProductCategoryID
GROUP BY pc2.Name + ' ' + '-->'
ORDER BY Category,Product