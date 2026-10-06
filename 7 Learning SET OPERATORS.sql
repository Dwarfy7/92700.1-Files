--3
SELECT c.City
FROM Customers c
UNION
SELECT e.City
FROM Employees e


--4
SELECT c.City
FROM Customers c
UNION ALL
SELECT e.City
FROM Employees e


--5
SELECT c.City
FROM Customers c
INTERSECT
SELECT e.City
FROM Employees e


--6
SELECT e.City
FROM Employees e
EXCEPT
SELECT c.City
FROM Customers c

