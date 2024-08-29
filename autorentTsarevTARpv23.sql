Create database autorentTsarev;
use autorentTsarev;
CREATE TABLE auto(
autoID int not null Primary key IDENTITY(1,1),
regNumber char(6) UNIQUE,
markID int,
varv varchar(20),
v_aasta int,
kaigukastID int,
km decimal(6,2)
);
SELECT * FROM auto
INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km) VALUES
('AB1234', 6, 'Punane', 2010, 1, 1500),
('BC2345', 7, 'Sinine', 2015, 2, 900),
('CD3456', 8, 'Must', 2020, 3, 500),
('DE4567', 9, 'Valge', 2018, 4, 750),
('EF5678', 10, 'Hall', 2022, 5, 200);

-----------------------------
CREATE TABLE mark(
markID int not null Primary key IDENTITY(1,1),
autoMark varchar(30) UNIQUE
);
-----------------------------
INSERT INTO mark (autoMark) VALUES 
('Ziguli'),
('Lambordzini'),
('BMW'),
('Audi'),
('Mercedes');
SELECT * FROM mark;
 --------------------------------------------------------
CREATE TABLE kaigukast(
kaigukastID int not null Primary key IDENTITY(1,1),
kaigukast varchar(30) UNIQUE
);
INSERT INTO kaigukast (kaigukast) VALUES 
('Automaat'),
('Manual'),
('Poolautomaat'),
('Variomatic'),
('CVT');
SELECT * FROM kaigukast;
-----------------------------------------------------
ALTER TABLE auto
ADD FOREIGN KEY (markID) REFERENCES mark(markID);
ALTER TABLE auto
ADD FOREIGN KEY (kaigukastID) REFERENCES kaigukast(kaigukastID);
----------------------------------------------------
--algus
CREATE TABLE klient (
    klientID int NOT NULL PRIMARY KEY,
    kliendiNimi varchar(50),
    telefon varchar(20),
    aadress varchar(50),
    soiduKogemus varchar(30)
);
------------------------------
INSERT INTO klient (klientID, kliendiNimi, telefon, aadress, soiduKogemus) VALUES
(1, 'Mari Maasikas', '5551234', 'Tallinn, Estonia', '5 aastat'),
(2, 'Jaan Kask', '5555678', 'Tartu, Estonia', '10 aastat'),
(3, 'Tiina Tamme', '5559012', 'Pärnu, Estonia', '2 aastat'),
(4, 'Kalev Kask', '5553456', 'Narva, Estonia', '8 aastat'),
(5, 'Anna Karu', '5557890', 'Viljandi, Estonia', '1 aasta');

---------------------------------------------
CREATE TABLE tootaja (
    tootajaID int NOT NULL PRIMARY KEY,
    tootajaNimi varchar(50),
    ametID int
);
------------------------------------------------
INSERT INTO tootaja (tootajaID, tootajaNimi, ametID) VALUES
(1, 'Jüri Ploom', 1),
(2, 'Eva Maasikas', 2),
(3, 'Mati Tamm', 3),
(4, 'Liina Kask', 4),
(5, 'Peeter Puudus', 5);

-----------------------------------------------
CREATE TABLE rendiLeping (
    lepingID int NOT NULL PRIMARY KEY,
    rendiAlgus date,
    rendiLopp date,
    klientID int,
    regNumber varchar(6),
    rendiKestvus int,
    hindKokku decimal(5,2),
    tootajaID int,
    FOREIGN KEY (klientID) REFERENCES klient(klientID),
    FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID)
);
--------------------------------------------------
INSERT INTO rendiLeping (lepingID, rendiAlgus, rendiLopp, klientID, regNumber, rendiKestvus, hindKokku, tootajaID) VALUES
(1, '2024-08-01', '2024-08-05', 1, 'AB1234', 5, 200.00, 1),
(2, '2024-09-01', '2024-09-10', 2, 'BC2345', 10, 350.00, 2),
(3, '2024-10-01', '2024-10-15', 3, 'CD3456', 15, 500.00, 3),
(4, '2024-11-01', '2024-11-07', 4, 'DE4567', 7, 275.00, 4),
(5, '2024-12-01', '2024-12-12', 5, 'EF5678', 12, 450.00, 5);

--------------------------------------------------
-- Täiendav tabel: amet
CREATE TABLE amet (
    ametID int NOT NULL PRIMARY KEY,
    ametNimetus varchar(50)
);
---------------------------------------------------------
INSERT INTO amet (ametID, ametNimetus) VALUES 
(1, 'Müügijuht'),
(2, 'Teenindaja'),
(3, 'Raamatupidaja'),
(4, 'Tehnik'),
(5, 'Juhataja');

---------------------------------------------------------
-- Muudame tabelit tootaja, et lisada välisvõti ametID jaoks
ALTER TABLE tootaja
ADD FOREIGN KEY (ametID) REFERENCES amet(ametID);
---------------------------------------------
-- ülesanne
--1
SELECT auto.regNumber, kaigukast.kaigukast 
FROM auto
INNER JOIN kaigukast ON auto.kaigukastID = kaigukast.kaigukastID;
--2
SELECT auto.regNumber, mark.autoMark 
FROM auto
INNER JOIN mark ON auto.markID = mark.markID;
--3
SELECT rendiLeping.regNumber, tootaja.tootajaNimi 
FROM rendiLeping
INNER JOIN tootaja ON rendiLeping.tootajaID = tootaja.tootajaID;
--4
SELECT COUNT(*) AS totalCars, SUM(hindKokku) AS totalCost 
FROM rendiLeping;
--5
SELECT klient.kliendiNimi, auto.regNumber, auto.varv 
FROM rendiLeping
INNER JOIN klient ON rendiLeping.klientID = klient.klientID
INNER JOIN auto ON rendiLeping.regNumber = auto.regNumber;
---------------------------------------------------------------------
--user - tootaja password - 123456
GRANT SELECT, INSERT ON rendiLeping TO tootaja;
----------------------------------------------------
-- procedure
--add rendiLeping
CREATE PROCEDURE addRendiLeping
    @rendiAlgus DATE,
    @rendiLopp DATE,
    @klientID INT,
    @regNumber VARCHAR(6),
    @rendiKestvus INT,
    @hindKokku DECIMAL(5,2),
    @tootajaID INT
AS
BEGIN
    INSERT INTO rendiLeping (rendiAlgus, rendiLopp, klientID, regNumber, rendiKestvus, hindKokku, tootajaID)
    VALUES (@rendiAlgus, @rendiLopp, @klientID, @regNumber, @rendiKestvus, @hindKokku, @tootajaID);
END;
--delete leping
CREATE PROCEDURE deleteLeping
    @lepingID INT
AS
BEGIN
    DELETE FROM rendiLeping WHERE lepingID = @lepingID;
END;
--update rendiLopp
CREATE PROCEDURE updateRendiLopp
    @lepingID INT,
    @newRendiLopp DATE
AS
BEGIN
    UPDATE rendiLeping
    SET rendiLopp = @newRendiLopp
    WHERE lepingID = @lepingID;
END;
--update kokku hind
CREATE PROCEDURE updateHindKokku
    @lepingID INT,
    @newHindKokku DECIMAL(5,2)
AS
BEGIN
    UPDATE rendiLeping
    SET hindKokku = @newHindKokku
    WHERE lepingID = @lepingID;
END;
--controll 
EXEC addRendiLeping '2024-08-01', '2024-08-05', 1, 'AB1234', 5, 200.00, 1;
EXEC deleteLeping 1;
EXEC updateRendiLopp 1, '2024-08-10';
EXEC updateHindKokku 1, 250.00;







