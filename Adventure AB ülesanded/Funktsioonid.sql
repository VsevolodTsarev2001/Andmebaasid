--32. funktsioonid


--Tabelisisev��rtusega funktsioon e Inline Table Valued function (ILTVF) koodin�ide:
Create Function fn_ILTVF_dimEmployee()
Returns Table 
as
Return (Select EmployeeKey, FirstName, Cast(BirthDate as Date) as DOB
From dimEmployee)

--Mitme avaldisega tabeliv��rtusega funktsioonid e multi-statement table valued function (MSTVF):
Create Function fn_MSTVF_getEmployees()
Returns @Table Table (EmployeeKey int, FirstName nvarchar(20), DOB Date)
as
Begin
Insert into @Table
Select EmployeeKey, FirstName, Cast(BirthDate as Date)
From dimEmployee
Return
End

--Kui n��d soovid m�lemat funktsiooni esile kutsuda, siis kasutad koodi:

Select * from fn_ILTVF_GetEmployees()
Select * from fn_MSTVF_GetEmployees()

--33. Funktsioonid

--Skaleeritav funktsioon ilma kr�pteerimata:
Create function fn_GetEmployeeNameById(@EmployeeKey int)
Returns nvarchar(20)
as
Begin
Return (Select FirstName from dbo.DimEmployee Where EmployeeKey = @EmployeeKey)
End


--Funktsiooni sisu vaatamise koodin�ide: 
sp_helptext fn_GetEmployeeNameById


--N��d muudame funktsiooni ja kr�pteerime selle �ra:
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
--N��d proovime uuesti kasutada sp_helptext-i ja vaadata, kas saame sisu vaadata. 
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

--N�ide: #PersonDetails on local temporary tabel koos Id ja Name veeruga.

Create Table #PersonDetails(Id int, Name nvarchar(20))

--Sisesta andmed ajutisse tabelisse:

Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')


--Vaata tabeli sisu ajutise tabeli abil:

Select * from #PersonDetails

--Need luuakse TEMPDB alla. P�ri sysobjects k�suga TEMPDB alt. 
--Tabeli nimi on j�reliitega alakriipsutatud ja suvaliste numbritega. 
--Selle tulemusel pead p�ringus kasutama LIKE operaatorit.

Select name from tempdb..sysobjects
where name like '#PersonDetails'


--Kui ajutine tabel on loodud SP sees, siis see kustutakse peale SP l�puleviimist automaatselt �ra. 
--Allpool olevas SP-s luuakse ajutine tabel #PersonsDetails ja edastab andmeid ja l�hub ajutise tabeli automaatselt peale k�su l�pule j�udmist.

Create Procedure spCreateLocalTempTable

as
Begin
Create Table #PersonDetails(Id int, Name nvarchar(20))
Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')

Select * from #PersonDetails
End

--Selleks tuleb tuleb ajuitse tabeli ette panna kaks # m�rki. EmployeeDetails table on globaalne ajutine tabel.

Create Table ##EmployeeDetails(Id int, Name nvarchar(20))