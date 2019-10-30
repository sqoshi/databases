#1
START transaction;
CREATE DATABASE IF NOT EXISTS Hobby;
CREATE USER IF NOT EXISTS 'piotr62'@'localhost' IDENTIFIED BY '261542';
GRANT SELECT,insert,update ON Hobby.* TO 'piotr62'@'localhost';
REVOKE create,delete,alter ON Hobby.* FROM 'piotr62'@'localhost';
FLUSH PRIVILEGES;
COMMIT;
#2
BEGIN;
Use Hobby;
CREATE TABLE IF NOT EXISTS osoba (
    id INT auto_increment,
    imię VARCHAR(20) NOT NULL,
    dataUrodzenia DATE NOT NULL,
    płeć CHAR(1) NOT NULL
    ,PRIMARY KEY (id)
);
delimiter //
CREATE TRIGGER agecheck before INSERT on osoba FOR EACH ROW  IF( NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR) THEN DELETE FROM osoba WHERE  NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR OR NEW.dataUrodzenia IS NULL; END IF;//
delimiter ;

CREATE TABLE IF NOT EXISTS sport (
    id INT NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(20) NOT NULL,
    typ ENUM('indywidualny', 'drużynowy', 'mieszany') DEFAULT 'drużynowy' NOT NULL,
    lokacja VARCHAR(20),
    PRIMARY KEY (ID)
);
CREATE TABLE IF NOT EXISTS nauka (
    id INT NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(20) NOT NULL,
    lokacja VARCHAR(20),
    PRIMARY KEY (ID)
);
CREATE TABLE IF NOT EXISTS inne (
    id INT NOT NULL auto_increment,
    nazwa VARCHAR(20) NOT NULL,
    lokacja VARCHAR(20),
    towarzysze BOOL DEFAULT TRUE NOT NULL
    ,PRIMARY KEY (ID));
CREATE TABLE IF NOT EXISTS hobby (
    id INT auto_increment NOT NULL,
    osoba INT NOT NULL,
    typ ENUM('sport', 'nauka', 'inne') NOT NULL ,
    PRIMARY KEY (id,osoba,typ)
);
COMMIT;

#3
insert into osoba(imię,dataUrodzenia,płeć) VALUES('imie','1998-01-18','M');
insert into osoba(imię,dataUrodzenia,płeć) VALUES('imie','2001-10-31','M');
select count(*) FROM osoba GROUP BY dataUrodzenia;
select * from osoba;
