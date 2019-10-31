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
CREATE TRIGGER agecheck before INSERT on osoba FOR EACH ROW  
IF( NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR) THEN DELETE FROM osoba WHERE  NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR OR NEW.dataUrodzenia IS NULL; END IF;//
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
BEGIN;
SET @MIN = current_timestamp()- INTERVAL 122 YEAR;
SET @MAX = current_timestamp()- INTERVAL 18 YEAR;
CREATE table IF NOT EXISTS Hobby.zwierzak SELECT * FROM menagerie.pet;
INSERT INTO osoba(imię,dataUrodzenia,płeć) select distinct owner,  DATE(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN)), 
(case floor(rand()*2) 
 when 0 then 'm'
 when 1 then 'f' end)
 from zwierzak group by owner;
COMMIT;

#4
BEGIN;
ALTER TABLE osoba ADD column nazwisko varchar(50) after imię;
ALTER TABLE zwierzak ADD COLUMN id int NOT NULL DEFAULT(0);
SET SQL_SAFE_UPDATES = 0;
UPDATE zwierzak z INNER JOIN osoba o ON o.imię=z.owner SET z.id=o.id;
ALTER TABLE zwierzak drop COLUMN owner;
COMMIt;

#5 not finished
BEGIN;
select * from zwierzak;
ALTER TABLE zwierzak add foreign key (id) REFERENCES osoba(id);
ALTER table Hobby add foreign key (osoba) REFERENCES osoba(id);
#ALTER table Hobby add foreign key (id,typ) REFERENCES ;
COMMIT;

#6
ALTER TABLE inne auto_increment=7000;

#7

DELIMITER //
CREATE procedure addRandom(IN num int , IN nazwa varchar(20))
BEGIN
    DECLARE i int DEFAULT 1;
    WHILE i <= num DO
    set i=i+1;
		IF nazwa='osoba' THEN
            INSERT INTO osoba(imię,nazwisko,dataUrodzenia,płeć) 
             VALUES( 
             LEFT(UUID(), 8),  
             LEFT(UUID(), 10),
             DATE(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN)),
             (case floor(rand()*2)  when 0 then 'm' when 1 then 'f' end));
		ELSEIF nazwa='sport' THEN
        INSERT INTO sport(nazwa,typ,lokacja) VALUES(
			LEFT(UUID(), 5), 
             (case floor(rand()*3)  when 0 then 'indywidualny' when 1 then 'drużynowy' when 2 then 'mieszany'end),
             LEFT(UUID(), 6));  
             ELSEIF nazwa='nauka' THEN
             INSERT INTO nauka(nazwa,lokacja) VALUES(LEFT(UUID(), 5),LEFT(UUID(), 5));
             ELSEIF nazwa='inne' THEN
			INSERT INTO inne(nazwa,lokacja,towarzysze) VALUES(LEFT(UUID(), 5),LEFT(UUID(), 5),LEFT(UUID(), 5));
            elseif  nazwa='hobby' THEN
            INSERT INTO hobby
                
  END IF;
   END WHILE;
END//
DELIMITER ;
CALL addRandom(10,'sport');
select * from hobby;
