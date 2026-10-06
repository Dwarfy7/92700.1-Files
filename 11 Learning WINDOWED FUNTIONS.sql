-- WINDOWED FUNCTIONS

--EXTRA
WITH CTE_TABLE
AS
(SELECT p.ProductID,p.ProductName,p.CategoryID,p.UnitPrice,
	AVG(p.UnitPrice) OVER() AS "AVG Price",
	p.UnitPrice - AVG(p.UnitPrice) OVER() AS "Diff"
FROM Products p 
WHERE p.CategoryID = 1)
SELECT *
FROM CTE_TABLE
WHERE CTE_TABLE.UnitPrice > [AVG Price]


GO

--EXTRA
WITH CTE_TBL
AS
(SELECT p.ProductID , p.ProductName  ,p.CategoryID, p.UnitPrice
	,SUM(unitprice)OVER(PARTITION BY categoryid) AS Sum_by_cat
	,SUM(unitprice)OVER() AS Grand_total
FROM Products p)

SELECT *,
	CONCAT(Sum_by_cat/Grand_total*100,'%') AS "%_Of_Total"
FROM CTE_TBL


GO

--EXTRA
WITH T
AS
(SELECT p.ProductID,p.ProductName,p.CategoryID,p.UnitPrice,
	RANK() OVER(PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) AS "RANK"
FROM Products p)

SELECT *
FROM T
WHERE "RANK" = 1


GO

USE Northwind
--EXTRA
WITH T
AS
(SELECT o.OrderID,o.CustomerID,o.OrderDate AS "DateRank"
FROM Orders o)

SELECT *,
	LAG(DateRank,1) OVER(PARTITION BY T.CustomerID ORDER BY "DateRank") "Date_Before"
FROM T


GO
USE AdventureWorks2025


-- 1 ROW_NUMBER
WITH CTE
AS
(SELECT ROW_NUMBER() OVER(ORDER BY ssh.SalesOrderID ) AS RN,
	*
FROM Sales.SalesOrderHeader ssh)

SELECT *
FROM CTE
WHERE RN BETWEEN 60 AND 80


--2
SELECT c.CustomerID,pp.LastName,pp.FirstName,
	ROW_NUMBER() OVER (ORDER BY pp.LastName) AS RN
FROM Sales.Customer c
	JOIN Person.Person pp
ON pp.BusinessEntityID = c.CustomerID



--3
WITH CTE
AS
(SELECT BusinessEntityID,
	DATEDIFF(YY,BirthDate,GETDATE()) AS AGE
FROM HumanResources.Employee)


SELECT e.BusinessEntityID,pp.LastName,pp.FirstName,e.BirthDate,
	AGE,
	ROW_NUMBER() OVER(PARTITION BY AGE ORDER BY e.BusinessEntityID) AS RN
FROM Person.Person pp 
	JOIN HumanResources.Employee e
ON e.BusinessEntityID = pp.BusinessEntityID
	JOIN CTE
ON CTE.BusinessEntityID = e.BusinessEntityID
WHERE pp.PersonType = 'SP'


--4
WITH CTE
AS
(SELECT  *,
	ROW_NUMBER()OVER(PARTITION BY sso.CustomerID ORDER BY sso.SalesOrderID) AS RN
FROM Sales.SalesOrderHeader sso)

SELECT CTE.CustomerID,cte.SalesOrderID,CTE.OrderDate
FROM CTE
WHERE RN = 1


--5
WITH CTE
AS
(SELECT pp.ProductID,pp.Name, pc.ProductCategoryID,pc.Name AS "Category Name",pp.ListPrice,
	ROW_NUMBER() OVER(PARTITION BY pc.ProductCategoryID ORDER BY pp.ListPrice) AS RN
FROM Production.ProductCategory pc
	JOIN Production.ProductSubcategory ps
ON pc.ProductCategoryID = ps.ProductCategoryID
	JOIN Production.Product pp
ON pp.ProductSubcategoryID = ps.ProductSubcategoryID)

SELECT *
FROM CTE
WHERE RN <=5


GO
--6 = bugged
--7
WITH CTE
AS
(SELECT e.BusinessEntityID,pp.LastName,pp.FirstName,
	FORMAT(sp.SalesLastYear,'C','en-us') AS SalesLastYear,
	ROW_NUMBER() OVER (PARTITION BY e.BusinessEntityID ORDER BY sp.SalesLastYear DESC) AS RN
FROM HumanResources.Employee e
	JOIN Sales.SalesPerson sp
ON e.BusinessEntityID = sp.BusinessEntityID
	JOIN Sales.SalesOrderHeader sso
ON sso.TerritoryID = sp.TerritoryID
	JOIN Person.Person pp
ON pp.BusinessEntityID = e.BusinessEntityID
WHERE sp.SalesLastYear >0)

SELECT *
FROM CTE
WHERE RN = 1
ORDER BY CTE.SalesLastYear DESC


GO
--8
WITH CTE
AS
(SELECT c.CustomerID,pp.FirstName,pp.LastName,st."Group" AS "Territory Group",
	st.Name "Terrirory Name",
	sso.SubTotal AS Total,
	ROW_NUMBER() OVER(PARTITION BY st.name ORDER BY sso.SubTotal) AS RN
FROM Sales.Customer c
	JOIN Person.Person pp
ON pp.BusinessEntityID = c.PersonID
	JOIN Sales.SalesOrderHeader sso
ON c.CustomerID = sso.CustomerID
	JOIN Sales.SalesTerritory st
ON st.TerritoryID = c.TerritoryID)

SELECT *
FROM CTE
WHERE RN <=3


GO
--9
SELECT ROW_NUMBER() OVER(PARTITION BY sso.OrderDate ORDER BY sso.SubTotal DESC) AS "Dailys",
	sso.CustomerID,sso.SalesOrderID,sso.OrderDate,sso.SalesOrderNumber,sso.SubTotal,sso.TotalDue
FROM Sales.SalesOrderHeader sso



-- RANK/DENCE_RANK
--1
SELECT p.ProductID,p.Name,p.ListPrice,
	DENSE_RANK() OVER(ORDER BY p.ListPrice DESC) AS RNK
FROM Production.Product p
WHERE p.ListPrice !=0


--2
SELECT ssp.BusinessEntityID,pp.FirstName + ' ' + pp.LastName AS EmpName,
	ssp.SalesLastYear,
	DENSE_RANK() OVER(ORDER BY ssp.SalesLastYear DESC) AS RNK
FROM Sales.SalesPerson ssp
	JOIN Person.Person pp
ON pp.BusinessEntityID = ssp.BusinessEntityID
WHERE ssp.SalesLastYear != 0

GO
--3
WITH CTE
AS
(SELECT c.CustomerID,pp.FirstName,pp.LastName,
	COUNT(sso.CustomerID) AS NumOfOrders,
	DENSE_RANK() OVER(ORDER BY COUNT(sso.CustomerID) DESC) AS RNK
FROM Sales.Customer c
	JOIN Person.Person PP
ON PP.BusinessEntityID = C.CustomerID
	JOIN Sales.SalesOrderHeader sso
ON c.CustomerID = sso.CustomerID
GROUP BY c.CustomerID,pp.FirstName,pp.LastName)
SELECT *
FROM CTE
WHERE 1=1
	AND RNK <=5


GO
--4
WITH CTE
AS
(SELECT YEAR(sso.OrderDate) AS "YEAR",
	COUNT(sso.CustomerID) AS NumOfOrders,
	DENSE_RANK() OVER(ORDER BY COUNT(sso.CustomerID)) AS RNK
FROM Sales.SalesOrderHeader sso
GROUP BY YEAR(sso.OrderDate))
SELECT*
FROM CTE
WHERE RNK <=2


GO
--5
WITH CTE
AS
(SELECT sso.SalesPersonID,pp.FirstName,pp.LastName,
	DENSE_RANK() OVER(ORDER BY SUM(sso.TotalDue) DESC) RNK,
	FORMAT(SUM(sso.TotalDue),'C','en-us') AS "Total Sales"
FROM Sales.SalesPerson sp
	JOIN Person.Person pp
ON pp.BusinessEntityID = sp.BusinessEntityID
	JOIN Sales.SalesOrderHeader sso
ON sso.SalesPersonID = sp.BusinessEntityID
GROUP BY sso.SalesPersonID,pp.FirstName,pp.LastName)
SELECT *
FROM CTE
WHERE RNK >10


go
--6
WITH CTE
AS
(SELECT a.City,st.CountryRegionCode,
	COUNT(sso.CustomerID) AS NumOfOrders,
	DENSE_RANK() OVER(PARTITION BY st.CountryRegionCode ORDER BY COUNT(sso.CustomerID) DESC) RNK
FROM Sales.SalesTerritory st
	JOIN Sales.SalesOrderHeader sso
ON sso.TerritoryID = st.TerritoryID
	JOIN Person.Address a
ON a.AddressID = sso.ShipToAddressID
GROUP BY a.City,st.CountryRegionCode)
SELECT *
FROM CTE
WHERE 1=1
	AND	CTE.CountryRegionCode IN ('FR','CA','US')
	AND RNK <=3


--7
SELECT a.City,st.CountryRegionCode,
	COUNT(sso.SalesOrderID) AS "Num Of Orders",
	DENSE_RANK() OVER(PARTITION BY CASE WHEN CountryRegionCode IN ('CA','US') THEN 1
	                                    WHEN CountryRegionCode IN ('FR','DE','US') THEN 2
										ELSE 3
								   END
					   ORDER BY COUNT(sso.SalesOrderID)DESC) AS RNK
FROM Person.Address a JOIN Sales.SalesOrderHeader sso
ON sso.ShipToAddressID = a.AddressID
	JOIN  Sales.SalesTerritory st
ON st.TerritoryID = sso.TerritoryID
GROUP BY a.City,st.CountryRegionCode

GO


--8
SELECT pp.BusinessEntityID,pp.FirstName,pp.LastName,pp.PersonType,ep.Rate,
	DENSE_RANK() OVER(PARTITION BY PersonType ORDER BY Rate) RNK
FROM Person.Person pp JOIN HumanResources.Employee e
ON pp.BusinessEntityID = e.BusinessEntityID
	JOIN HumanResources.EmployeePayHistory ep
ON ep.BusinessEntityID = e.BusinessEntityID
WHERE Rate !=0


--NTILE
--1
SELECT p.ProductID,p.ProductNumber,p.Name,p.ListPrice,
	NTILE(5) OVER(ORDER BY p.ListPrice) NTL
FROM Production.Product p
WHERE p.ListPrice !=0


--2
WITH CTE
AS
(SELECT e.BusinessEntityID,e.NationalIDNumber,
	ISNULL(CONCAT(pp.FirstName,' ',pp.LastName,' ',e.JobTitle),'NoTitle') AS FullName,
	E.BirthDate,
	DATEDIFF(YY,e.BirthDate,GETDATE()) AS AGE
FROM HumanResources.Employee e
	JOIN Person.Person pp
ON pp.BusinessEntityID = e.BusinessEntityID)
SELECT *,
	NTILE(10) OVER(ORDER BY AGE) AS "AGE NTL"
FROM CTE


--3
SELECT c.CustomerID,pp.FirstName,pp.LastName,c.StoreID,
	ss.name AS "Store Name",c.TerritoryID,
	NTILE(4) OVER(ORDER BY c.StoreID) NTL
FROM Sales.Store ss
	JOIN Sales.Customer c
ON c.StoreID  = ss.BusinessEntityID
	JOIN Person.Person pp
ON pp.BusinessEntityID = c.PersonID
WHERE c.TerritoryID IN (3,7,9)


--4
WITH CTE
AS
(SELECT p.ProductID,p.Name,p.SafetyStockLevel,p.ListPrice,
	NTILE(3) OVER(ORDER BY p.SafetyStockLevel) NTL
FROM Production.Product p)
SELECT *
FROM CTE 
WHERE NTL = 2


--5
WITH CTE
AS
(SELECT c.Name AS Catagory,
	P.ProductID,p.Name AS "Product Name",
	p.ListPrice,
	NTILE(2) OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC) NTL
FROM Production.Product p
	JOIN Production.ProductSubcategory sc
ON sc.ProductSubcategoryID = p.ProductSubcategoryID
	JOIN Production.ProductCategory c
ON c.ProductCategoryID = sc.ProductCategoryID)
SELECT *
FROM CTE 
WHERE NTL = 1


--6
WITH CTE
AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY OnlineOrderFlag,NTL ORDER BY OrderDate,NTL) RN	
FROM( 
	SELECT SalesOrderID,OrderDate,ShipDate,OnlineOrderFlag,
	NTILE(3) OVER(PARTITION BY OnlineOrderFlag ORDER BY OnlineOrderFlag) AS NTL
	FROM Sales.SalesOrderHeader)o)
SELECT *
FROM CTE 
WHERE RN BETWEEN 100 AND 200


--7
SELECT od.SalesOrderID,od.ProductID,od.OrderQty,od.LineTotal,
	NTILE(3) OVER(ORDER BY od.LineTotal) AS NTL
FROM Sales.SalesOrderDetail od
	JOIN Sales.SalesOrderHeader sso
ON sso.SalesOrderID = od.SalesOrderID
WHERE MONTH(sso.OrderDate) = 1
	AND YEAR(sso.OrderDate) = 2024


--8
WITH CTE
AS
(SELECT d.DepartmentID,
	d.Name AS "Dep Name",
	e.BusinessEntityID,
	pp.FirstName,
	pp.LastName,
	DATEDIFF(YY,e.BirthDate,GETDATE()) AS AGE
FROM HumanResources.Department d
	JOIN HumanResources.EmployeeDepartmentHistory ed
ON ed.DepartmentID = d.DepartmentID
	JOIN HumanResources.Employee e
ON e.BusinessEntityID = ed.BusinessEntityID
	JOIN Person.Person pp
ON pp.BusinessEntityID = e.BusinessEntityID)
SELECT *,
	NTILE(2) OVER(PARTITION BY "DEP NAME" ORDER BY AGE) NTL
FROM CTE


--LAG/LEAD
--1
SELECT sso.CustomerID,sso.SalesOrderNumber,sso.OrderDate,
	LAG(sso.OrderDate,1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) LAGDate
FROM Sales.SalesOrderHeader sso


--2
SELECT c.Name AS Category,
	sc.Name AS "Sub Category",
	p.Name AS "Product Name",
	p.ListPrice AS "Product Price",
	LEAD(p.ListPrice) OVER(PARTITION BY c.name ORDER BY p.ProductID DESC) AS "Next Price"
FROM Production.Product p JOIN Production.ProductSubcategory sc
ON sc.ProductSubcategoryID = p.ProductSubcategoryID
	JOIN Production.ProductCategory c
ON c.ProductCategoryID = sc.ProductCategoryID


GO
--3
WITH CTE
AS
(SELECT sso.CustomerID,sso.OrderDate,
	LAG(sso.OrderDate) OVER(PARTITION BY sso.CustomerID ORDER BY ORDERDATE) LagDate
FROM Sales.SalesOrderHeader sso),
	CTE2
AS
(SELECT CTE.CustomerID,
	MAX(DATEDIFF(DD,CTE.LagDate,CTE.OrderDate)) AS DD_Diff
FROM CTE
GROUP BY CTE.CustomerID)
SELECT DISTINCT CTE2.CustomerID,DD_Diff,
	DENSE_RANK() OVER(ORDER BY DD_Diff) RNK
FROM CTE2
WHERE DD_Diff IS NOT NULL
ORDER BY DD_Diff


--4
WITH CTE
AS
(SELECT YEAR(sso.OrderDate) AS "YEAR",
	ISNULL(CAST(sso.SalesPersonID AS VARCHAR),'No Sales Person') AS "Sales Person",
	SUM(sso.SubTotal) AS TOTAL
FROM Sales.SalesOrderHeader sso
GROUP BY YEAR(sso.OrderDate),sso.SalesPersonID),
	CTE2
AS
(SELECT *,
		LAG(TOTAL,1,0) OVER(PARTITION BY "Sales Person" ORDER BY "Sales Person","YEAR") AS Prev_Total,
		TOTAL-LAG(TOTAL,1,0) OVER(PARTITION BY "Sales Person" ORDER BY "Sales Person","YEAR") AS Total_Diff
FROM CTE)
SELECT CTE2.YEAR,CTE2.[Sales Person],
	FORMAT(TOTAL,'C') AS TOTAL,
	FORMAT(Prev_Total,'C') AS Prev_Total,
	REPLACE(REPLACE(FORMAT(Total_Diff,'C'),'(','--'),')','') AS Total_Diff
FROM CTE2


go
--5
WITH CTE
AS
(SELECT pp.FirstName + ' '+ pp.LastName AS FullName,
	spq.QuotaDate,spq.SalesQuota
FROM Sales.SalesPerson sp JOIN Person.Person pp
ON pp.BusinessEntityID = sp.BusinessEntityID
	JOIN Sales.SalesPersonQuotaHistory spq
ON spq.BusinessEntityID = sp.BusinessEntityID)
SELECT FullName,
	CONVERT(VARCHAR,QuotaDate,103) QuotaDate,
	SalesQuota,
	LAG(SalesQuota) OVER(PARTITION BY FullName ORDER BY QuotaDate) AS Prev_Quota
FROM CTE


go
--6
WITH CTE
AS
(SELECT sc.Name,
	YEAR(sso.OrderDate) AS "YEAR",
	SUM(sod.OrderQty) AS QTYSUM
FROM Production.ProductSubcategory sc JOIN Production.Product p
ON p.ProductSubcategoryID = sc.ProductSubcategoryID
	JOIN Sales.SpecialOfferProduct sop
ON sop.ProductID = p.ProductID
	JOIN Sales.SalesOrderDetail sod
ON sod.ProductID = sop.ProductID
	JOIN Sales.SalesOrderHeader sso
ON sso.SalesOrderID = sod.SalesOrderID
GROUP BY sc.Name,YEAR(sso.OrderDate))
SELECT CTE.Name,CTE.YEAR,
	LAG(CAST(QTYSUM AS VARCHAR),1,'-0-') OVER (PARTITION BY CTE.Name ORDER BY "YEAR") AS Prev_QTY,
	CTE.QTYSUM AS QTY,
	LEAD(CAST(QTYSUM AS VARCHAR),1,'-1-') OVER (PARTITION BY CTE.Name ORDER BY "YEAR") AS Next_QTY
FROM CTE
GROUP BY CTE.Name,YEAR,CTE.QTYSUM
--ORDER BY CTE.Name

SELECT [SubCategory name]
,[Order Year]
,LAG(Qty)OVER(PARTITION BY [SubCategory name] ORDER BY [Order Year]) AS "Previous Qty"
,Qty as "Current Qty"
,LEAD(Qty)OVER(PARTITION BY [SubCategory name] ORDER BY [Order Year]) AS "Next Qty"
FROM(
SELECT SC.Name AS "SubCategory name"
,YEAR(OH.OrderDate) AS "Order Year"
,SUM(OD.OrderQty) AS "Qty"
FROM Production.ProductSubcategory SC JOIN Production.Product P
ON SC.ProductSubcategoryID=P.ProductSubcategoryID
JOIN Sales.SalesOrderDetail OD
ON OD.ProductID=P.ProductID
JOIN Sales.SalesOrderHeader OH
ON OH.SalesOrderID=OD.SalesOrderID
GROUP BY SC.Name,YEAR(OH.OrderDate))O


--7
WITH CTE
AS
(SELECT YEAR(sso.OrderDate) AS "YEAR",
	DATEPART(Q,sso.OrderDate) AS QTR,
	FORMAT(SUM(sso.TotalDue),'C') AS Total
FROM Sales.SalesOrderHeader sso
GROUP BY YEAR(sso.OrderDate),DATEPART(Q,sso.OrderDate))
SELECT *,
	LAG(Total) OVER(PARTITION BY "YEAR" ORDER BY "YEAR",QTR) AS Last_QTR
FROM CTE


