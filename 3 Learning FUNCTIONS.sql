--1
SELECT
	LOWER(e.FirstName),
	UPPER(e.LastName)
FROM Employees e
WHERE 1=1
	AND e.EmployeeID BETWEEN 3 AND 5


--2 A
SELECT
	e.FirstName,
	CHARINDEX('a', e.FirstName) AS "A POS"
FROM Employees e  

--2 B
SELECT
	e.FirstName,
	CHARINDEX('a', e.FirstName) AS "A POS"
FROM Employees e
WHERE 1=1
	AND e.FirstName NOT LIKE '%a%'


--3
SELECT
	c.CategoryName,
	CHARINDEX ('E', c.Description, 4) AS "E After 4"
FROM Categories c
WHERE 1=1


--4
SELECT
	c.CategoryName,
	CHARINDEX ('E',c.Description, 10) AS "E After 10"
FROM Categories c
WHERE 1=1


--5
SELECT
	s.SupplierID,
	s.CompanyName,
	s.Phone,
	REPLACE(REPLACE(REPLACE(s.Phone, '(', ''), ')',''),' ','-') AS Updated_Phone_Num
FROM Suppliers s
WHERE 1=1


--6
SELECT GETDATE()


--7
SELECT
	o.CustomerID,
	o.OrderID,
	o.OrderDate,
	DATEADD(DD,45,o.OrderDate) AS "OrderDate + 45"
FROM Orders o
WHERE 1=1


--8
SELECT
	e.FirstName,
	DATEDIFF(YYYY,e.BirthDate,GETDATE()) AS "AGE"
FROM Employees e
WHERE 1=1


--9
SELECT
	e.FirstName,
	DATENAME (DW,e.HireDate) AS "HIRE DAY",
	YEAR (e.HireDate) AS "HIRE YEAR"
FROM Employees e
WHERE 1=1


--10
SELECT
	p.ProductID,
	p.UnitPrice,
	CAST(p.UnitPrice *0.12 AS INT) AS "Price_as_int_num",
	CAST(ROUND(p.UnitPrice * 0.12,2)AS DECIMAL(10,2)) AS "up to 2 decimal"
FROM Products p
WHERE 1=1


--11 1
SELECT
	CONCAT_WS(' ',e.EmployeeID,E.LastName) AS "ID AND LastName",
	e.BirthDate
FROM Employees e
WHERE 1=1


--11 2
SELECT
	 CAST(e.EmployeeID AS NVARCHAR) + ' ' + e.LastName AS "ID AND LastName",
	e.BirthDate
FROM Employees e
WHERE 1=1


--12 A
SELECT
	UPPER(e.LastName) AS "Upper Last Name",
	CONVERT(NVARCHAR(8),e.BirthDate,3) AS "BirthDate DD/MM/YY"
FROM Employees e
WHERE 1=1
	AND SUBSTRING(e.LastName,1,1) LIKE '[DK]'


--12 B
SELECT
	UPPER(e.LastName) AS "Upper Last Name",
	CONVERT(NVARCHAR(8),e.BirthDate,3) AS "BirthDate DD/MM/YY"
FROM Employees e
WHERE 1=1
	AND SUBSTRING(e.LastName,1,1) IN ('D','K')


--13
SELECT
CONVERT(NVARCHAR,p.ProductID) + ' ' + 'AND' +' ' + CONVERT(NVARCHAR,p.SupplierID) AS "PRODUCT ver1",
CONCAT(p.ProductID,' ', 'AND', ' ', p.SupplierID) AS "PRODUCT ver2",
CONCAT_WS(' AND ',p.ProductID,p.SupplierID) AS "PRODUCT ver3",
FLOOR(p.UnitPrice*1.165) AS "Full_Price"
FROM Products p
WHERE 1=1
AND FLOOR(p.UnitPrice*1.165) > 40


--14
SELECT
CONCAT(e.LastName,' ',LEN(e.LastName)) AS "LastName_Len",
CONCAT(e.FirstName,' ',LEN(e.FirstName)) AS "FirstName_Len"
FROM Employees e
WHERE 1=1


--15
SELECT
	e.LastName,
REVERSE(e.LastName) AS "Rev_LastName"
FROM Employees e
WHERE 1=1
	AND e.ReportsTo IS NOT NULL


--16
SELECT
	o.OrderID,
	o.OrderDate,
	o.RequiredDate
FROM Orders o
WHERE 1=1
	AND DATEDIFF(Q,o.OrderDate,o.RequiredDate) = 1


--17
SELECT
SUBSTRING(c.CompanyName,1,4) AS "First_4_A"
FROM Customers c
WHERE 1=1
	AND c.CompanyName LIKE 'A%'


--18
SELECT
CONCAT(e.LastName,' ',e.BirthDate) AS "LastName_BirthDate",
CONVERT(CHAR(8),e.HireDate,104) AS "HireDate104",
ISNULL(CAST(e.ReportsTo AS VARCHAR),'No Manager') AS "Manager_Status"
FROM Employees e
WHERE 1=1
	AND LEN(e.LastName) >= LEN(e.FirstName)


--EXTRA
SELECT
CONCAT_WS(' ',e.EmployeeID,e.FirstName,e.LastName) AS "ID_FullName",
FORMAT(e.HireDate,'dd-MM-yy') AS "Hire dd-MM-yy",
DATEDIFF(YY,e.BirthDate,CURRENT_DATE) AS "AGE",
REPLACE(REPLACE(e.HomePhone,'(',''),')','') AS "Phone NO ()",
LOWER(CONCAT(LEFT(e.LastName,4),RIGHT(e.FirstName,2),'@gmail.com')) AS "Email"
FROM Employees e

--EXTRA CASE

SELECT 
DATEDIFF(YY,e.HireDate,GETDATE()) AS "Working Years",
CASE WHEN DATEDIFF(YY,e.HireDate,GETDATE())>32 THEN 'Go Home'
ELSE 'Keep Working' 
END AS "Senoir Or Not"
FROM Employees e


--EXTRA HARD 1
SELECT
CONCAT(e.EmployeeID,' - ',e.LastName,' ',e.FirstName) AS "ID_FullName",
FORMAT(e.BirthDate,'dd-MM-yy') AS "BirthDate dd-MM-yy",
DATEDIFF(YY,e.HireDate,GETDATE()) AS "Senioraty",
LOWER(CONCAT(LEFT(e.LastName,4), RIGHT(e.FirstName,3),'@gmail.com')) AS "EMP Gmail",
SUBSTRING(e.HomePhone,CHARINDEX('(',e.HomePhone)+1,CHARINDEX(')',e.homephone)-2) AS "Phone1",
SUBSTRING(e.HomePhone,CHARINDEX(')',e.homephone)+2) AS "Phone2"
FROM Employees e
WHERE 1=1


--EXTRA HARD 2
SELECT e.EmployeeID, e.LastName,
ISNULL(CONVERT(nvarchar,e.ReportsTo),'No Manager') AS "Manager"
FROM Employees e


--EXTRA HARD 3
SELECT e.EmployeeID, e.LastName, e.HireDate,
CASE WHEN e.ReportsTo = 2 THEN 'Fuller'
WHEN e.ReportsTo = 5 THEN 'buchanan'
ELSE 'Big Boss'
END AS "BossName"
FROM Employees e


--EXTRA HARD 4
SELECT od.OrderID, od.ProductID,
	od.UnitPrice*od.Quantity AS "TotalPrice",
CASE WHEN od.UnitPrice*od.Quantity > 5000 THEN ROUND(CAST(od.UnitPrice*od.Quantity*0.7 AS MONEY),2)
	 WHEN od.UnitPrice*od.Quantity > 3000 THEN ROUND(CAST(od.UnitPrice*od.Quantity*0.8 AS MONEY),2)
	 WHEN od.UnitPrice*od.Quantity > 1000 THEN ROUND(CAST(od.UnitPrice*od.Quantity*0.9 AS MONEY),2)
   ELSE ROUND(CAST(od.UnitPrice*od.Quantity AS MONEY),2)
END AS "TotalPrice_Sale"
FROM [Order Details] od


--EXTRA HARD 5
SELECT p.ProductID, p.ProductName, p.SupplierID, p.UnitPrice, p.UnitsInStock,
	CAST(IIF(p.SupplierID = 12 AND p.UnitsInStock > 20,p.UnitPrice*0.7,
				p.UnitPrice) AS MONEY) AS "Supplier_Stock"
FROM Products p


--EXTRA HARD 6
SELECT o.OrderID, o.OrderDate, o.CustomerID,
	CASE WHEN DATEDIFF(DD,o.OrderDate,o.RequiredDate) > 28 THEN 'We are really sorry'
	ELSE CAST(DATEDIFF(DD,o.OrderDate,o.RequiredDate)AS VARCHAR)+ ' '+'Days passed'
END AS "Apology_IfNeed"
FROM Orders o


--EXTRA HARD 7
SELECT o.OrderID,
	CONCAT(LEFT(o.CustomerID,2),o.OrderID)AS "ID2+ORDER",
	YEAR(o.OrderDate) AS "OrderYear",
	DATEDIFF(YY,o.OrderDate,GETDATE()) AS "YearsPassed",
CASE WHEN DATEDIFF(YY,o.OrderDate,GETDATE()) > 18 THEN 'Order Not Active'
	ELSE 'Order Acrive' 
END AS 'Order Status'
FROM Orders o
WHERE 1=1
	AND (o.CustomerID LIKE '%[A-F]%' 
	OR o.CustomerID LIKE '%[T-Z]%')
	AND DATEPART(Q,o.OrderDate) IN (1,3)
ORDER BY YEAR(o.OrderDate),o.OrderID


