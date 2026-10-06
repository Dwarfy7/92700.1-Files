use Northwind

--1
CREATE TABLE my_employees (
id INt PRIMARY KEY ,
name VARCHAR (50),
title VARCHAR(50),
deptid INT,
salary MONEY DEFAULT 3500)


--2
SP_HELP my_employees


--3
INSERT INTO my_employees
VALUES(1,'Aviv Cohen','Clerk',10,4000)


select *
from my_employees

--4
INSERT INTO my_employees (id,name,title,deptid,salary)
VALUES (2,'Miriam Levi','Sales Manager',20,3750)


select *
from my_employees


--5
INSERT INTO my_employees
VALUES (3,'AION Romano','OperatiON Manager',30,NULL)


select *
from my_employees


--6
INSERT INTO my_employees (id,name,deptid)
VALUES (4,'Baruch Nave',30)


select *
from my_employees
-- yeah because the title is already null and the salary has a diffault value


--7
INSERT INTO my_employees
VALUES (5,'Danny SalomON','Sales Representative',20,7000)


select *
from my_employees


--8
UPDATE my_employees
SET salary = 4500
WHERE id = 2


select *
from my_employees


--9
UPDATE my_employees
SET name = 'Lukas Kvilitaia',
	deptid = 20
WHERE id = 4


select *
from my_employees


--10
UPDATE my_employees
SET deptid = 10
WHERE deptid = 30


select *
from my_employees


--11
DELETE FROM my_employees
WHERE name = 'AION Romano'


select *
from my_employees


--12
INSERT INTO my_employees (id,name,title)
SELECT e.EmployeeID,e.LastName,e.Title
FROM Employees e
WHERE e.EmployeeID > 5

BEGIN TRAN
COMMIT


select *
from my_employees