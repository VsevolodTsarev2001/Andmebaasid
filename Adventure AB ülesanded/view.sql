--39. View SQL serveris

--Skript loomaks tblEmployee table:
Create Table tblEmployee
(
Id int Primary Key,
Name nvarchar(30),
Salary int,
Gender nvarchar(10),
DepartmentId int
);

--Skript tblDepartment loomiseks:
CREATE TABLE tblDepartment
(
DeptId int Primary Key,
DeptName nvarchar(20)
);

--Andmete sisestamine:
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

Insert into tblEmployee values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee values (6,'Ben', 4800, 'Male', 3)

--Selleks, et saada soovitud tulemus, me peaksime ühendama kaks tabelit omavahel.
--Kui JOIN-d on sulle uus teema, siis vaata eelnevaid harjutusi JOIN-de kohta.
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--loome view, kus kasutame JOIN-i:
Create View vWEmployeesByDepartment
as
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--Kui soovime näha andmeid läbi view, siis selleks saab kasutada SELECT käsklust:

SELECT * from vWEmployeesByDepartment

--View, mis tagastab ainult IT osakonna töötajad:

Create View vWITDepartment_Employees
as
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.Departmentid = tblDepartment.DeptId
where tblDepartment.DeptName = 'IT'

--View, kus ei ole Salary veergu:

Create View vWEmployeesNonConfidentialData
as
Select Id, Name, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.Departmentid = tblDepartment.DeptId

--View-d saab kasutada esitlemaks ainult koondandmeid ja peitma üksikasjalikke andmeid.
--View, mis tagastab summeeritud andmed töötajate koondarvest.


Create View vWEmployeesCountByDepartment
as
Select DeptName, COUNT(Id) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
Group By DeptName

-- 40. View uuendused

--Skript loomaks tblEmployee table:
Create Table tblEmployee
(
Id int Primary Key,
Name nvarchar(30),
Salary int,
Gender nvarchar(10),
DepartmentId int
);

--Andmete sisestamine:
Insert into tblEmployee values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee values (6,'Ben', 4800, 'Male', 3)

--tagastab peaaegu kõik veerud, aga va Salary veerg.
Create view vWEmployeesDataExceptSalary
as
Select Id, Name, Gender, Departmentid
from tblEmployee

--Nüüd päri andmed läbi view:
Select * from vWEmployeesDataExceptSalary

--Järgnev päring uuendab Name veerus olevat nime Mike Mikey peale.
--Uuendame view-d, aga SQL server uuendab tblEmployee tabelis olevat infot.
--Selleks peab kasutama SELECT väljendit:
Update vWEmployeesDataExceptSalary
Set Name = 'Mikey' Where Id = 2

--Samas on võimalik sisestada ja kustutada ridu baastabelis ning kasutada view-d.
Delete from vWEmployeesDataExceptSalary where Id = 2
Insert into vWEmployeesDataExceptSalary values (2, 'Mikey', 'Male', 2)

--Loome view, mis ühendab kaks eelpool käsitletud tabelit ja annab sellise tulemuse:
Create view vWEmployeesDetailsByDepartment
as
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--Tee päring ja peaksid nägema tulemust, mis on välja toodud üleval pildil:
Select * from vWEmployeesDetailsByDepartment

--Nüüd uuendame John osakonda HR pealt IT peale. Hetkel on kaks töötajat HR osakonnas.
--Kood:
Update vWEmployeesDetailsByDepartment
set DeptName='IT' where Name = 'John'
