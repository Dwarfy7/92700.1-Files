-- ADV SQL CTE



--Special Exrecise
WITH CTE_tbl
AS
(SELECT od.OrderID,p.ProductID,p.ProductName,
	od.UnitPrice*od.Quantity*(1-od.Discount) AS "Total_Price"
FROM [Order Details] od
	JOIN Products p
ON p.ProductID = od.ProductID)

SELECT *,
	ROUND(CAST(CASE WHEN Total_Price < 1000 THEN Total_Price
	WHEN Total_Price < 3000 THEN Total_Price * 0.9
	WHEN Total_Price < 5000 THEN Total_Price * 0.8
	ELSE Total_Price * 0.7 END AS float),2)AS "AfterSale",
CASE WHEN Total_Price < 1000 THEN '0%'
	WHEN Total_Price < 3000 THEN '10%'
	WHEN Total_Price < 5000 THEN '20%'
	ELSE '30%' END AS "Sale"
FROM CTE_tbl

go
--1
USE AdventureWorks2025

GO  


WITH CTE
AS
(SELECT sso.SalesOrderID,sso.CustomerID,sso.OrderDate,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) RN,
	ISNULL(CAST(sso.SalesPersonID AS VARCHAR),'No Sales Person')AS SalesPersonID ,
	sso.SubTotal,sso.TaxAmt,sso.TotalDue
FROM Sales.SalesOrderHeader sso)
SELECT *
FROM CTE
WHERE RN <=2


GO
--2
WITH CTE
AS
(SELECT AVG(so.DiscountPct) OVER (PARTITION BY Category) AS "AVG Cat Discount"
FROM Sales.SpecialOffer so)
SELECT MAX(CTE.[AVG Cat Discount]) AS "MAX AVG Discount"
FROM CTE


go
--3
WITH CTE23
AS
(SELECT DISTINCT t.Name AS "Territory",
	YEAR(sso.OrderDate) AS "YEAR",
	COUNT(sso.SalesOrderID) OVER(PARTITION BY t.Name) AS "Orders Done",
	SUM(sso.TotalDue) OVER(PARTITION BY t.Name) AS "Sales"
FROM Sales.SalesOrderHeader sso JOIN Sales.SalesTerritory t
ON t.TerritoryID = sso.TerritoryID
WHERE YEAR(sso.OrderDate) = '2023'),
	CTE24
AS
(SELECT DISTINCT t.Name AS "Territory",
	YEAR(sso.OrderDate) AS "YEAR",
	COUNT(sso.SalesOrderID) OVER(PARTITION BY t.Name) AS "Orders Done",
	SUM(sso.TotalDue) OVER(PARTITION BY t.Name) AS "Sales"
FROM Sales.SalesOrderHeader sso JOIN Sales.SalesTerritory t
ON t.TerritoryID = sso.TerritoryID
WHERE YEAR(sso.OrderDate) = '2024')
SELECT CTE23.Territory,CTE23.YEAR,CTE23.[Orders Done],
	FORMAT(CTE23.Sales,'C') AS Sales,
	CTE24.YEAR,CTE24.[Orders Done],
	FORMAT(CTE24.Sales,'C') AS Sales,
	CTE23.[Orders Done]-CTE24.[Orders Done] AS "23 Orders Diff To 24",
	REPLACE(REPLACE(FORMAT(CTE23.Sales-CTE24.Sales,'C'),'(','--'),')','') AS "23 Sales Diff To 24"
FROM CTE23 JOIN CTE24
ON CTE23.Territory = CTE24.Territory

GO

--4
WITH CTE
AS
(SELECT sso.SalesPersonID,
	COUNT(sso.SalesOrderID) AS "Orders Done"
FROM Sales.SalesPerson sp JOIN Sales.SalesOrderHeader sso
ON sso.SalesPersonID = sp.BusinessEntityID
GROUP BY sso.SalesPersonID)
SELECT AVG([Orders Done]) AS "AVG Sales Per Person"
FROM CTE


go
--5
WITH CTE
AS
(SELECT sso.SalesPersonID,
	YEAR(sso.OrderDate) AS YEAR,
	SUM(sso.TotalDue) AS "Total Sales"
FROM Sales.SalesOrderHeader sso
WHERE SalesPersonID IS NOT NULL
GROUP BY sso.SalesPersonID,YEAR(sso.OrderDate)),
	CTE2
AS
(SELECT spq.BusinessEntityID,YEAR(spq.QuotaDate) AS "Quota_YEAR",
	SUM(spq.SalesQuota) AS SalesQuota
FROM Sales.SalesPersonQuotaHistory spq
GROUP BY spq.BusinessEntityID,YEAR(spq.QuotaDate))
SELECT CTE.SalesPersonID,
	CONCAT(pp.FirstName,' ',pp.LastName) AS "EMP Name",
	CTE.YEAR,CTE.[Total Sales],
	CTE2.Quota_YEAR,CTE2.SalesQuota,
	REPLACE(REPLACE(FORMAT(CTE.[Total Sales]-CTE2.SalesQuota,'C'),'(','--'),')','') AS "Diff To Quota"
FROM CTE JOIN CTE2 
ON CTE.SalesPersonID = CTE2.BusinessEntityID
	AND CTE.YEAR = CTE2.Quota_YEAR
	JOIN Person.Person pp
ON pp.BusinessEntityID = cte.SalesPersonID
ORDER BY CTE.SalesPersonID,Quota_YEAR

GO
--6
WITH F_AGE
AS
(SELECT e.OrganizationLevel,
	AVG(DATEDIFF(YY,e.BirthDate,GETDATE())) AS "AVG F AGE"
FROM HumanResources.Employee e
WHERE e.Gender = 'F'
GROUP BY e.OrganizationLevel
),
	M_AGE
AS
(SELECT e.OrganizationLevel,
	AVG(DATEDIFF(YY,e.BirthDate,GETDATE())) AS "AVG M AGE"
FROM HumanResources.Employee e
WHERE e.Gender = 'M'
GROUP BY e.OrganizationLevel
)
SELECT M_AGE.OrganizationLevel,M_AGE.[AVG M AGE],F_AGE.[AVG F AGE]
FROM M_AGE JOIN F_AGE
ON M_AGE.OrganizationLevel = F_AGE.OrganizationLevel


--7 BUGGED