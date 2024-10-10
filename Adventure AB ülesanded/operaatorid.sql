--87. Except operaator
--Kasutame kahte tabelit, milles on andmed:
Create Table TableA
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(10)
)
Go
Insert into TableA values (1, 'Mark', 'Male')
Insert into TableA values (2, 'Mary', 'Female')
Insert into TableA values (3, 'Steve', 'Male')
Insert into TableA values (4, 'John', 'Male')
Insert into TableA values (5, 'Sara', 'Female')
Go
Create Table TableB
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(10)
)
Go
Insert into TableB values (4, 'John', 'Male')
Insert into TableB values (5, 'Sara', 'Female')
Insert into TableB values (6, 'Pam', 'Female')
Insert into TableB values (7, 'Rebeka', 'Female')
Insert into TableB values (8, 'Jordan', 'Male')
Go

--Pane t�hele, et j�rgnev rida tagastab unikaalse ridade arvu vasakust tabelist, mida ei ole paremas tabelis.
Select Id, Name, Gender
From TableA 
Except
Select Id, Name, Gender
From TableB

--Except operaatorit saab kasutada ka �he tabeli peal. Kasutame tblEmployee tabelit:
Create table tblEmployees
(
Id int identity primary key,
Name nvarchar(100),
Gender nvarchar(10),
Salary int
)
Go

Insert into tblEmployees values ('Mark', 'Male', 52000)
Insert into tblEmployees values ('Mary', 'Female', 55000)
Insert into tblEmployees values ('Steve', 'Male', 45000)
Insert into tblEmployees values ('John', 'Male', 40000)
Insert into tblEmployees values ('Sara', 'Female', 48000)
Insert into tblEmployees values ('Pam', 'Female', 60000)
Insert into tblEmployees values ('Tom', 'Male', 58000)
Insert into tblEmployees values ('George', 'Male', 65000)
Insert into tblEmployees values ('Tina', 'Female', 67000)
Insert into tblEmployees values ('Ben', 'Male', 80000)
Go

--Order by n�uet v�ib kasutada ainult kord peale paremat p�ringut:
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 50000
Except
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 60000
order By Name

--88. Erinevus Except ja not in operaatoril

--J�rgnev p�ring tagastab read vasakust p�ringust, mis ei ole paremas tabelis
Select Id, Name, Gender From TableA 
Except 
Select Id, Name, Gender From TableB

--Sama tulemuse v�ib saavutada NOT IN operaatoriga:
Select Id, Name, Gender From TableA
Where Id NOT IN (Select Id from TableB)

--N��d k�ivita j�rgnev EXCEPT p�ring:
Select Id, Name, Gender From TableA 
Except 
Select Id, Name, Gender From TableB
--N��d k�ivita NOT IN operaatoriga kood:
Select Id, Name, Gender From TableA
Where Id NOT IN (Select Id from TableB)

--J�rgnevas p�ringus on meelega veergude arv erinev:
Select Id, Name, Gender From TableA 
Except 
Select Id, Name From TableB

--J�rgnevas p�ringus alamp�ring tagastab mitu veergu:
Select Id, Name, Gender From TableA
Where Id NOT IN (Select Id, Name from TableB)

--98. Where ja Having erinevused

--Selle harjutuse jaoks kasutame Sales tabelit.
Create table Sales
(
	Product nvarchar(50),
	SaleAmount int
)
Go

Insert into Sales values ('iPhone', 500)
Insert into Sales values ('Laptop', 800)
Insert into Sales values ('iPhone', 1000)
Insert into Sales values ('Speakers', 400)
Insert into Sales values ('Laptop', 600)
Go

--Kui soovime ainult neid tooteid, kus m��k kokku on suurem kui 1000�, siis kasutame filtreerimaks tooteid HAVING tingimust.
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
HAVING SUM(SaleAmount)>1000

--Kui kasutame WHERE klasulit HAVING-u asemel, siis saame s�ntaksivea. 
--P�hjuseks on WHERE-i mitte t��tamine kokku arvutava funktsiooniga, mis sisaldab SUM, MIN, MAX, AVG jne.
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY Product
WHERE SUM(SaleAmount) > 1000

--Kalkuleeri iPhone-i ja Speakerite m��ki ja kasuta selleks HAVING klauslit. 
--See n�ide p�rib k�ik read Sales tabelis, mis n�itavad summat ning eemaldavad k�ik tooted peale iPhone-i ja Speakerite.
SELECT Product, SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE Product in ('iPhone', 'Speakers')
GROUP BY Product
