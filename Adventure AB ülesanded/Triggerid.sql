--92. DDL Trigger SQL serveris

--DDL triggeri vahemik: DDL trigger saab luua konkreetsesse andmebaasi või serveri tasemel.
--Järgnev trigger käivitab vastuseks CREATE_TABLE DDL sündmuse: sp_rename

CREATE TRIGGER trMyFirstTrigger
On Database
For CREATE_TABLE
AS
BEGIN
Print'New table created'
End

--Kui sa järgnevat koodi käivitad, siis trigger läheb automaatselt käima ja prindib välja sõnumi: uus tabel on loodud.
Create Table Test(Id int)

--Ülevapool olev trigger käivitatakse ainult ühe DDL tegevuse juures CREATE_TABLE. 
--Kui soovid, et see trigger käivitatakse mitu korda nagu muuda ja kustuta tabel, siis eralda sündmused ning kasuta koma.
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE,DROP_TABLE
AS
BEGIN
Print 'A table has just been created, modified or deleted'
END

--Allpool olevad kaks triggerit käivitavad koodi DDL sündmuse vastuseks.
--Nüüd vaatame näidet, kuidas ära hoida kasutajatel loomaks, muutmaks või kustatamiseks tabelit. 
--Selleks pead olemasolevat triggerit muutma:
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE,DROP_TABLE
AS
BEGIN
Rollback
Print 'You cannot create, alter or drop table'
END
--Teatud stored procedureid saavad käivitada DDL triggereid. 
--Järgnev trigger käivitub, kui peaksid kasutama sp_rename käsklust süsteemi stored procedurite muutmisel.
CREATE TRIGGER trRenameTable
On Database
For RENAME
AS
BEGIN
Print'You just renamed something'
End

--93. Server-Scoped DDL triggerid

--Käsitletav trigger on andmebaasi vahemikus olev trigger. 
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
--See on nagu andembaasi vahemiku trigger, aga erinevus seisneb, et sa pead lisama koodis sõna ALL peale:
CREATE TRIGGER tr_ServerScopeTrigger
ON ALL SERVER 
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE 
AS 
BEGIN 
ROLLBACK 
Print'You cannot create, alter or drop a table in any database on the server'
END

--1. Tee parem klikk Object Exploreris asuva trigeri peale ning vajuta Disable
--2. Saad tühistada ka koodi kasutades:
DISABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER

--Kuidas lubada Serveri ulatuses olevat DDL trigerit:
--1. Tee parem klikk Object Exploreris asuvale triggerile ja vajuta Enable
--2. Saad kasutada ka koodi:
ENABLE TRIGGER tr_ServerScopeTrigger ON ALL SERVER

--Kuidas kustutada serveri ulatuses olevat DDL trigerit
--1. Tee parem klikk Object Exploreris asuvale triggerile ja vajuta Delete
--2. Saad kasutada ka koodi:
DROP TRIGGER tr_ServerScopeTrigger ON ALL SERVER

