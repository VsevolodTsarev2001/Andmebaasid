--92. DDL Trigger SQL serveris

--DDL triggeri vahemik: DDL trigger saab luua konkreetsesse andmebaasi v�i serveri tasemel.
--J�rgnev trigger k�ivitab vastuseks CREATE_TABLE DDL s�ndmuse: sp_rename

CREATE TRIGGER trMyFirstTrigger
On Database
For CREATE_TABLE
AS
BEGIN
Print'New table created'
End

--Kui sa j�rgnevat koodi k�ivitad, siis trigger l�heb automaatselt k�ima ja prindib v�lja s�numi: uus tabel on loodud.
Create Table Test(Id int)

--�levapool olev trigger k�ivitatakse ainult �he DDL tegevuse juures CREATE_TABLE. 
--Kui soovid, et see trigger k�ivitatakse mitu korda nagu muuda ja kustuta tabel, siis eralda s�ndmused ning kasuta koma.
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE,DROP_TABLE
AS
BEGIN
Print 'A table has just been created, modified or deleted'
END

--Allpool olevad kaks triggerit k�ivitavad koodi DDL s�ndmuse vastuseks.
--N��d vaatame n�idet, kuidas �ra hoida kasutajatel loomaks, muutmaks v�i kustatamiseks tabelit. 
--Selleks pead olemasolevat triggerit muutma:
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE,DROP_TABLE
AS
BEGIN
Rollback
Print 'You cannot create, alter or drop table'
END
--Teatud stored procedureid saavad k�ivitada DDL triggereid. 
--J�rgnev trigger k�ivitub, kui peaksid kasutama sp_rename k�sklust s�steemi stored procedurite muutmisel.
CREATE TRIGGER trRenameTable
On Database
For RENAME
AS
BEGIN
Print'You just renamed something'
End

--93. Server-Scoped DDL triggerid

--K�sitletav trigger on andmebaasi vahemikus olev trigger. 
--See ei luba luua, muuta ja kustutada tabeleid andmebaasist sinna, kuhu see on loodud.
CREATE TRIGGER tr_DatabaseScopeTrigger
ON DATABASE 
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE 
AS 
BEGIN
ROLLBACK 
Print'You cannot create, alter or drop a table in the current database'
END

--Loo Serveri-vahemikus olev DDL trigger: 
--See on nagu andembaasi vahemiku trigger, aga erinevus seisneb, et sa pead lisama koodis s�na ALL peale:
CREATE TRIGGER tr_ServerScopeTrigger
ON ALL SERVER 
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE 
AS 
BEGIN 
ROLLBACK 
Print'You cannot create, alter or drop a table in any database on the server'
END

--1. Tee parem klikk Object Exploreris asuva trigeri peale ning vajuta Disable
--2. Saad t�histada ka koodi kasutades:
DISABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER

--Kuidas lubada Serveri ulatuses olevat DDL trigerit:
--1. Tee parem klikk Object Exploreris asuvale triggerile ja vajuta Enable
--2. Saad kasutada ka koodi:
ENABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER

--Kuidas kustutada serveri ulatuses olevat DDL trigerit
--1. Tee parem klikk Object Exploreris asuvale triggerile ja vajuta Delete
--2. Saad kasutada ka koodi:
DROP TRIGGER tr_ServerScopeTrigger ON ALL SERVER

