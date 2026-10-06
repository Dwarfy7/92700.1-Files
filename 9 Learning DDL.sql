use master


--1
CREATE DATABASE human_resource_db


use human_resource_db


--2
CREATE TABLE departments
(department_id INT IDENTITY (10,10) CONSTRAINT dep_depid_pk PRIMARY KEY,
department_name VARCHAR(20) CONSTRAINT dep_depname_nn NOT NULL,
"location" VARCHAR(30) CONSTRAINT dep_loc_nn NOT NULL)


--3
CREATE TABLE employees
(Employee_id INT IDENTITY (1,1) CONSTRAINT emp_empid_pk PRIMARY KEY,
Last_Name VARCHAR(20) CONSTRAINT emp_empname_nn NOT NULL,
Hire_date DATETIME DEFAULT GETDATE() NOT NULL,
Salary MONEY DEFAULT 5000,
Email VARCHAR(30) CONSTRAINT emp_email_uk UNIQUE CONSTRAINT emp_email_nn NOT NULL)


--4
ALTER TABLE employees
ADD Department_id INT CONSTRAINT emp_depid_dep_depid_fk FOREIGN KEY REFERENCES departments(department_id)


--6
SELECT *
INTO emp_history
FROM employees


--7
DROP TABLE emp_history