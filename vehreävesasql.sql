-- -------------------------------------------------------------------------------------------------------------------------
-- Schema Maatietokanta
-- -------------------------------------------------------------------------------------------------------------------------
-- Jostain syystä toimii vain jos nämä dropit on täällä ylhäällä/ei ajeta, tein HEidiSQL:llä tämän
-- EN myöskään saanut lisättyä kahta fK:ta esim. kohteeseen
DROP DATABASE maatietokanta;

DROP TABLE mantere;
DROP TABLE maa;
DROP TABLE kohdetyyppi;
DROP TABLE kohde;
DROP TABLE majoitustyyppi;
DROP TABLE majoitus;

DROP VIEW visitedcountries;
DROP VIEW maalista;
DROP VIEW kohteet;

CREATE DATABASE maatietokanta DEFAULT CHARACTER SET utf8 COLLATE utf8_swedish_ci;
USE maatietokanta;



CREATE TABLE mantere(
  mantereID INT NOT NULL PRIMARY KEY,
  manterenimi VARCHAR(45) NOT NULL,
  UNIQUE(mantereID));



CREATE TABLE maa(
  maaID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  maanimi VARCHAR(45) NOT NULL,
  kieli VARCHAR(45),
  väkiluku VARCHAR(45) DEFAULT 'Ei tietoa',
  valuutta VARCHAR(45),
  mantereID INT NOT NULL,
  UNIQUE(maaID),
  FOREIGN KEY (mantereID) REFERENCES mantere(mantereID)
);



CREATE TABLE kohdetyyppi (
  tyyppiID INT NOT NULL PRIMARY KEY,
  tyyppinimi VARCHAR(45) NOT NULL,
  UNIQUE(tyyppiID));



CREATE TABLE kohde (
  kohdeID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  kohdenimi VARCHAR(45) NOT NULL,
  kohde_tyyppiID INT NOT NULL,
  kohde_maaID INT NOT NULL DEFAULT 1,
  UNIQUE(kohdeID),
  INDEX (kohde_tyyppiID),
  INDEX (kohde_maaID));
  
  ALTER TABLE kohde ADD CONSTRAINT 
  FOREIGN KEY (kohde_tyyppiID)
   REFERENCES kohdetyyppi(tyyppiID);



CREATE TABLE majoitustyyppi (
  majoitustyyppiID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  kuvaus VARCHAR(45) NOT NULL,
  UNIQUE(majoitustyyppiID));



CREATE TABLE majoitus (
  majoitusID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  majoitusnimi VARCHAR(45) NOT NULL,
  luokitus INT,
  hinta VARCHAR(45),
  majoitustyyppiID INT NOT NULL,
  CHECK (luokitus<6),
  UNIQUE(majoitusID),
  FOREIGN KEY (majoitustyyppiID) REFERENCES majoitustyyppi(majoitustyyppiID));


CREATE VIEW visitedcountries AS SELECT COUNT(maanimi) AS summa
FROM maa;

CREATE VIEW maalista AS SELECT m.maanimi, ma.manterenimi
FROM maa m JOIN mantere ma ON m.mantereID = ma.mantereID;

CREATE VIEW kohteet AS SELECT COUNT(kohde.kohde_tyyppiID), kohde.kohdenimi
FROM kohde GROUP BY kohde.kohdenimi;


INSERT INTO mantere (mantereID, manterenimi)
VALUES (1, 'Aasia'),
(2, 'Afrikka'),
(3, 'Eurooppa'),
(4, 'Oseania'),
(5, 'Pohjois-Amerikka'),
(6, 'Etelä-Amerikka'),
(7, 'Karibia');

INSERT INTO maa(maanimi, kieli, väkiluku, valuutta, mantereID)
VALUES ('Viro', 'Eesti', '1300000', 'Euro', 3),
('Kreikka', 'Helleeni', '13000000', 'Euro', 3),
('Kuuba', 'Esperanto', '11047000', 'Kuuban peso', 7),
('Argentiina', 'Espanja', '44694198', 'Argentiinan peso', 6),
('Kenia', 'Swahili', '42287195', 'Kenian šillinki', 2),
('Uzbekistan', 'Uzbekki', '28929716', 'Som', 1),
('Kirgisia', 'Kirgiisi', '6019500', NULL, 1),
('Nauru', 'Nauru', '9322', 'Australian dollari', 4),
('Kiribati', 'Kiribati', '104488', 'Kiribatin dollari', 4),
('Georgia', 'Georgia', '3729633', 'Lari', 1);

INSERT INTO kohdetyyppi(tyyppiID, tyyppinimi)
VALUES (1, 'Kaupunki/kaikkea'),
(2, 'Kaupunki/bile'),
(3, 'Kaupunki/ostos'),
(4, 'Kulttuuri'),
(5, 'Ranta'),
(6, 'Aktiviteetti'),
(7, 'Liikunta'),
(8, 'Nähtävyys'),
(9, 'Kylä'),
(10, 'Kalapaikka');

INSERT INTO kohde(kohdenimi, kohde_tyyppiID)
VALUES ('Tallinna', 1),
('Pärnu', 6),
('Superalko Tallinna', 8),
('Suuri Kaukasus', 8),
('Tallinnan laululava', 4),
('Havanna', 1),
('Buenos Aires', 1),
('Ateena', 1),
('Korfu', 5),
('Nairobi', 1);

INSERT INTO majoitustyyppi(majoitustyyppiID, kuvaus)
VALUES (1, 'Hotelli'),
(2, 'Hostelli'),
(3, 'Vuokra-asunto'),
(4, 'Mökki'),
(5, 'Vierashuone'),
(6, 'Sohvamajoitus'),
(7, 'Laiva/vene'),
(8, 'Ajoneuvo'),
(9, 'Teltta'),
(10, 'Juna');

INSERT INTO majoitus(majoitusnimi, luokitus, hinta, majoitustyyppiID)
VALUES ('Marriott Buenos Aires', 5, '200€', 1),
('Kalevin maja', 2, '20€', 2),
('Buenos Aires boathouse', 3, '70€', 7),
('Grand Cru Georgian', 5, '100€', 1),
('Nauru State Hotel', 4, '270€', 1),
('Asuntoauto', 2, '10€', 8),
('Kaverin kaveri', 1, '0€', 6),
('AirBnB', 5, '400€', 3),
('Kaukasuksen lomakylä', 1, '5€', 9),
('Holiday Inn Ateena', 3, '80€', 1);



CREATE INDEX maa_idx1 ON maa(maaID, maanimi);

CREATE INDEX majoitus_idx1 ON majoitus(majoitusnimi, luokitus);



SELECT * FROM mantere;
SELECT * FROM maa;
SELECT * FROM kohdetyyppi;
SELECT * FROM kohde;
SELECT * FROM majoitustyyppi;
SELECT * FROM majoitus;

SELECT * FROM visitedcountries;
SELECT * FROM maalista;
SELECT * FROM kohteet;