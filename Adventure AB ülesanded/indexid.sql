--35. Ineksid serveris

--Hetkel Employee tabelil ei ole olemas Salary veergu, mis tuleb sisestada:

Koodin�ide: Select * from dbo.DimEmployee where BaseRate > 5000 and BaseRate < 7000

--N��d loome indeksi, mis aitab p�ringut: Loome indeksi Salary veerule.

Create Index IX_DimEmployee_Salary
ON DimEmployee (BaseRate ASC)

--Object Exploreris laienda Indexes kausta. 
--Alternatiiviks kasuta sp_helptext-i s�steemi SP-de jaoks. J�rgnev p�ring tagastab k�ik indeksid tblEmployee tabelis.

Execute sp_help DimEmployee

--Kui soovid kustutada indeksit: Kui kustutad indeksi, siis t�psusta tabeli nimi.

Drop Index DimEmployee.IX_DimEmployee_Salary

-- 36. Klastreeritud ja mitte-klastreeritud indeksid

--Selle tulemusel SQL server ei luba luua rohkem, kui �hte klastreeritud indeksit tabeli kohta. J�rgnev skript annab veateate: 
Create clustered index IX_DimEmployee_FirstName
ON DimEmployee(FirstName)

--N��d loome klastreeritud indeksi kahe veeruga. Selleks peame enne kustutama praeguse klastreeritud indeksi Id veerus:
Drop index DimEmployee.PK_DimEmplo_3214ECO7OA9D95DB

--N��d k�ivita j�rgnev kood uue klastreeritud �hendindeksi loomiseks Gender ja BaseRate veeru p�hjal:
Create clustered index IX_DimEmployee_Gender_BaseRate
ON DimEmployee(Gender DESC,BaseRate ASC)

--J�rgnev kood loob SQL-s mitte-klastreeritud indeksi Name veeru j�rgi tblEmployee tabelis:
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

--N��d on Id veerg UNIQUE CLUSTERED INDEX t��pi ja igasugune katse kopeerida v�tmev��rtusi annab veateate:
Insert into tblEmployee Values (1, 'Mike',4500,'Male','New York')
Insert into tblEmployee Values (1, 'John',2500,'Male','London')

--Kui proovime kustutada Unique Clustered Index-st, siis anna meile veateate: 
Drop index tblEmployee.PK__tblEmplo__3214EC07236943A5

--N��d proovime sisestada duplikaatv��rtust Id veergu ja veateadet ei n�e.
Insert into tblEmployee Values(1,'Mike',4500,'Male','New York')
Insert into tblEmployee Values(1,'John',2500,'Male','London')

--Kui peaksid lisama unikaalse piirangu, siis unikaalne indeks luuakse tagataustal. 
--Selle t�estuseks lisame koodiga unikaalse piirangu City veerule.
ALTER TABLE tblEmployee 
ADD CONSTRAINT UQ_tblEmployee_City 
UNIQUE NONCLUSTERED (City)

--Kui k�ivitad EXECUTE SP_HELPCONSTRAINT tblEmployee, siis tekib nimekiri UNIQUE NONCLUSTERED indeks.
EXECUTE SP_HELPCONSTRAINT tblEmployee

--Kui soovin ainult viie rea tagasi l�kkamist ja viie mitte korduva sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY valikut.
CREATE UNIQUE INDEX IX_tblEmployee_City
ON tblEmployee(City)
WITH IGNORE_DUP_KEY

--38. N��d proovime sisestada duplikaatv��rtust Id veergu ja veateadet ei n�e.

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
--Sisesta n�idisandmed:
Insert into tblEmployee Values (1, 'Mike','Sandoz',4500,'Male','New York')
Insert into tblEmployee Values (2, 'Sara','Menco',6500,'Female','London')
Insert into tblEmployee Values (3, 'John','Barber',2500,'Male','Sydney')
Insert into tblEmployee Values (4, 'Pam','Grove',3500,'Female','Toronto')
Insert into tblEmployee Values (5, 'James','Mirch',7500,'Male','London')

--Loo mitte-klastreeritud indeks Salary veerule:

Create NonClustered Index IX_tblEmployee_Salary
On tblEmployee(Salary Asc)

--J�rgnev SELECT p�ring saab kasu Salary veeru indeksist kuna palgad on indeksis langevas j�rjestuses. 
--Indeksist l�htuvalt on kergem �les otsida palkasid, mis j��vad vahemikku 4000 kuni 8000 ning kasutada reaaadressi.

Select * from tblEmployee where Salary > 4000 and Salary < 8000

--Mitte ainult SELECT k�sklus, vaid isegi DELETE ja UPDATE v�ljendid saavad indeksist kasu.
--Kui soovid uuendada v�i kustutada rida, siis SQL server peab esmalt leidma rea ja indeks saab aidata seda otsingut kiirendada.

Delete from tblEmployee where Salary = 2500
Update tblEmployee Set Salary = 9000 where Salary = 7500

--Indeksid saavad aidata p�ringuid, mis k�sivad sorteeritud tulemust. 
--Palgad on juba sorteeritud ja andmebaasimootor skanneerib indekseid alates esimesest kuni viimaseni ja tagastab read sorteeritud j�rjestuses.
--See v�listab p�ringu k�ivitamisel ridade sorteerimise, mis oluliselt  suurendab  protsessiaega.

Select * from tblEmployee order by Salary

--Salary veeru indeks saab aidata ka allpool olevat p�ringut. Seda tehakse indeksi tagurpidi skanneerimises.

Select * from tblEmployee order by Salary Desc

--GROUP BY p�ringud saavad kasu indeksitest. 
--Kui soovid grupeerida t��tajaid sama palgaga, siis p�ringumootor saab kasutada Salary veeru indeksit, et saada juba sorteeritud palkasid.
--Kuna j�rjestikuses registrikirjes on vastavaid palku, siis tuleb kiiresti lugeda t��tajate koguarv igal palgal.

Select Salary, Count(Salary) as Total
from tblEmployee
Group By Salary