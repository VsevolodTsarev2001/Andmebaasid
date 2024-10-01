--35. Ineksid serveris

--Hetkel Employee tabelil ei ole olemas Salary veergu, mis tuleb sisestada:

Koodinäide: Select * from dbo.DimEmployee where BaseRate > 5000 and BaseRate < 7000

--Nüüd loome indeksi, mis aitab päringut: Loome indeksi Salary veerule.

Create Index IX_DimEmployee_Salary
ON DimEmployee (BaseRate ASC)

--Object Exploreris laienda Indexes kausta. 
--Alternatiiviks kasuta sp_helptext-i süsteemi SP-de jaoks. Järgnev päring tagastab kõik indeksid tblEmployee tabelis.

Execute sp_help DimEmployee

--Kui soovid kustutada indeksit: Kui kustutad indeksi, siis täpsusta tabeli nimi.

Drop Index DimEmployee.IX_DimEmployee_Salary

-- 36. Klastreeritud ja mitte-klastreeritud indeksid

--Selle tulemusel SQL server ei luba luua rohkem, kui ühte klastreeritud indeksit tabeli kohta. Järgnev skript annab veateate: 
Create clustered index IX_DimEmployee_FirstName
ON DimEmployee(FirstName)

--Nüüd loome klastreeritud indeksi kahe veeruga. Selleks peame enne kustutama praeguse klastreeritud indeksi Id veerus:
Drop index DimEmployee.PK_DimEmplo_3214ECO7OA9D95DB

--Nüüd käivita järgnev kood uue klastreeritud ühendindeksi loomiseks Gender ja BaseRate veeru põhjal:
Create clustered index IX_DimEmployee_Gender_BaseRate
ON DimEmployee(Gender DESC,BaseRate ASC)

--Järgnev kood loob SQL-s mitte-klastreeritud indeksi Name veeru järgi tblEmployee tabelis:
Create NonClustered Index IX_DimEmployee_FirstName
ON DimEmployee(FirstName)

--37. Unikaalne ja mitte-unikaalne indeks


--Loome tabeli Employee, kui seda ei ole loodud:
CREATE TABLE tblEmployee
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(10)
);

--Nüüd on Id veerg UNIQUE CLUSTERED INDEX tüüpi ja igasugune katse kopeerida võtmeväärtusi annab veateate:
Insert into tblEmployee Values (1, 'Mike',4500,'Male','New York')
Insert into tblEmployee Values (1, 'John',2500,'Male','London')

--Kui proovime kustutada Unique Clustered Index-st, siis anna meile veateate: 
Drop index tblEmployee.PK__tblEmplo__3214EC07236943A5

--Nüüd proovime sisestada duplikaatväärtust Id veergu ja veateadet ei näe.
Insert into tblEmployee Values(1,'Mike',4500,'Male','New York')
Insert into tblEmployee Values(1,'John',2500,'Male','London')

--Kui peaksid lisama unikaalse piirangu, siis unikaalne indeks luuakse tagataustal. 
--Selle tõestuseks lisame koodiga unikaalse piirangu City veerule.
ALTER TABLE tblEmployee 
ADD CONSTRAINT UQ_tblEmployee_City 
UNIQUE NONCLUSTERED (City)

--Kui käivitad EXECUTE SP_HELPCONSTRAINT tblEmployee, siis tekib nimekiri UNIQUE NONCLUSTERED indeks.
EXECUTE SP_HELPCONSTRAINT tblEmployee

--Kui soovin ainult viie rea tagasi lükkamist ja viie mitte korduva sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY valikut.
CREATE UNIQUE INDEX IX_tblEmployee_City
ON tblEmployee(City)
WITH IGNORE_DUP_KEY

--38. Nüüd proovime sisestada duplikaatväärtust Id veergu ja veateadet ei näe.

--Loo tabel, kui sul juba ei ole seda:
CREATE TABLE tblEmployee
(
Id int primary key,
FirstName nvarchar(50),
LastName nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(10)
);
--Sisesta näidisandmed:
Insert into tblEmployee Values (1, 'Mike','Sandoz',4500,'Male','New York')
Insert into tblEmployee Values (2, 'Sara','Menco',6500,'Female','London')
Insert into tblEmployee Values (3, 'John','Barber',2500,'Male','Sydney')
Insert into tblEmployee Values (4, 'Pam','Grove',3500,'Female','Toronto')
Insert into tblEmployee Values (5, 'James','Mirch',7500,'Male','London')

--Loo mitte-klastreeritud indeks Salary veerule:

Create NonClustered Index IX_tblEmployee_Salary
On tblEmployee(Salary Asc)

--Järgnev SELECT päring saab kasu Salary veeru indeksist kuna palgad on indeksis langevas järjestuses. 
--Indeksist lähtuvalt on kergem üles otsida palkasid, mis jäävad vahemikku 4000 kuni 8000 ning kasutada reaaadressi.

Select * from tblEmployee where Salary > 4000 and Salary < 8000

--Mitte ainult SELECT käsklus, vaid isegi DELETE ja UPDATE väljendid saavad indeksist kasu.
--Kui soovid uuendada või kustutada rida, siis SQL server peab esmalt leidma rea ja indeks saab aidata seda otsingut kiirendada.

Delete from tblEmployee where Salary = 2500
Update tblEmployee Set Salary = 9000 where Salary = 7500

--Indeksid saavad aidata päringuid, mis küsivad sorteeritud tulemust. 
--Palgad on juba sorteeritud ja andmebaasimootor skanneerib indekseid alates esimesest kuni viimaseni ja tagastab read sorteeritud järjestuses.
--See välistab päringu käivitamisel ridade sorteerimise, mis oluliselt  suurendab  protsessiaega.

Select * from tblEmployee order by Salary

--Salary veeru indeks saab aidata ka allpool olevat päringut. Seda tehakse indeksi tagurpidi skanneerimises.

Select * from tblEmployee order by Salary Desc

--GROUP BY päringud saavad kasu indeksitest. 
--Kui soovid grupeerida töötajaid sama palgaga, siis päringumootor saab kasutada Salary veeru indeksit, et saada juba sorteeritud palkasid.
--Kuna järjestikuses registrikirjes on vastavaid palku, siis tuleb kiiresti lugeda töötajate koguarv igal palgal.

Select Salary, Count(Salary) as Total
from tblEmployee
Group By Salary