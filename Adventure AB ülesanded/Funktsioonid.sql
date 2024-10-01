--32. funktsioonid


--Tabelisiseväärtusega funktsioon e Inline Table Valued function (ILTVF) koodinäide:
Create Function fn_ILTVF_dimEmployee()
Returns Table 
as
Return (Select EmployeeKey, FirstName, Cast(BirthDate as Date) as DOB
From dimEmployee)

--Mitme avaldisega tabeliväärtusega funktsioonid e multi-statement table valued function (MSTVF):
Create Function fn_MSTVF_getEmployees()
Returns @Table Table (EmployeeKey int, FirstName nvarchar(20), DOB Date)
as
Begin
Insert into @Table
Select EmployeeKey, FirstName, Cast(BirthDate as Date)
From dimEmployee
Return
End

--Kui nüüd soovid mõlemat funktsiooni esile kutsuda, siis kasutad koodi:

Select * from fn_ILTVF_GetEmployees()
Select * from fn_MSTVF_GetEmployees()

--33. Funktsioonid

--Skaleeritav funktsioon ilma krüpteerimata:
Create function fn_GetEmployeeNameById(@EmployeeKey int)
Returns nvarchar(20)
as
Begin
Return (Select FirstName from dbo.DimEmployee Where EmployeeKey = @EmployeeKey)
End


--Funktsiooni sisu vaatamise koodinäide: 
sp_helptext fn_GetEmployeeNameById


--Nüüd muudame funktsiooni ja krüpteerime selle ära:
USE [AdventureWorksDW2019]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEmployeeNameById]    Script Date: 26.09.2024 10:45:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fn_GetEmployeeNameById](@EmployeeKey int)
Returns nvarchar(20)
With Encryption
as
Begin
Return (Select FirstName from dbo.DimEmployee Where EmployeeKey = @EmployeeKey)
End

----------------------------------------------------------------------------------------------------------
--Nüüd proovime uuesti kasutada sp_helptext-i ja vaadata, kas saame sisu vaadata. 
--Konsool annab vastuseks: The text for object 'fn_GetEmployeeNameById' is encrypted.' .

USE [AdventureWorksDW2019]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEmployeeNameById]    Script Date: 26.09.2024 10:45:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fn_GetEmployeeNameById](@EmployeeKey int)
Returns nvarchar(20)
With SchemaBinding
as
Begin
Return (Select FirstName from dbo.DimEmployee Where EmployeeKey = @EmployeeKey)
End

--34. Ajutised tabelid

--Näide: #PersonDetails on local temporary tabel koos Id ja Name veeruga.

Create Table #PersonDetails(Id int, Name nvarchar(20))

--Sisesta andmed ajutisse tabelisse:

Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')


--Vaata tabeli sisu ajutise tabeli abil:

Select * from #PersonDetails

--Need luuakse TEMPDB alla. Päri sysobjects käsuga TEMPDB alt. 
--Tabeli nimi on järeliitega alakriipsutatud ja suvaliste numbritega. 
--Selle tulemusel pead päringus kasutama LIKE operaatorit.

Select name from tempdb..sysobjects
where name like '#PersonDetails'


--Kui ajutine tabel on loodud SP sees, siis see kustutakse peale SP lõpuleviimist automaatselt ära. 
--Allpool olevas SP-s luuakse ajutine tabel #PersonsDetails ja edastab andmeid ja lõhub ajutise tabeli automaatselt peale käsu lõpule jõudmist.

Create Procedure spCreateLocalTempTable

as
Begin
Create Table #PersonDetails(Id int, Name nvarchar(20))
Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')

Select * from #PersonDetails
End

--Selleks tuleb tuleb ajuitse tabeli ette panna kaks # märki. EmployeeDetails table on globaalne ajutine tabel.

Create Table ##EmployeeDetails(Id int, Name nvarchar(20))