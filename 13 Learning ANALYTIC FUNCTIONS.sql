-- ADV ANALYTIC FUNCTIONS
--1
use Northwind
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	SUM(p.UnitPrice) OVER() AS "SUM"
FROM Products p


--2
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	SUM(p.UnitPrice) OVER(PARTITION BY CategoryID) AS "Cat SUM"
FROM Products p 


--3
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	SUM(p.UnitPrice) OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS "Cat SUM"
FROM Products p 


--4
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	SUM(p.UnitPrice) OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC
											ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Cat SUM"
FROM Products p 


--5
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	SUM(p.UnitPrice) OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC
										ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Cat SUM"
FROM Products p 


--6
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	RANK() OVER(ORDER BY UnitPrice) AS RNK,
	DENSE_RANK() OVER(ORDER BY UnitPrice) AS DRNK,
	ROW_NUMBER() OVER(ORDER BY UnitPrice) AS RN,
	NTILE(10) OVER(ORDER BY UnitPrice) AS NTL
FROM Products p 


--7
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice) AS RNK,
	DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice) AS DRNK,
	ROW_NUMBER() OVER(PARTITION BY CategoryID ORDER BY UnitPrice) AS RN,
	NTILE(10) OVER(PARTITION BY CategoryID ORDER BY UnitPrice) AS NTL
FROM Products p 


--8
SELECT p.ProductName,p.UnitPrice,p.CategoryID,
	LAG(p.UnitPrice) OVER(ORDER BY UnitPrice) AS PrevPrice,
	LEAD(p.UnitPrice) OVER(ORDER BY UnitPrice) AS NextPrice
FROM Products p 
WHERE p.CategoryID = 1
ORDER BY P.UnitPrice
