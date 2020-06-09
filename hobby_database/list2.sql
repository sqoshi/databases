drop database if exists hobby;
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
DROP TRIGGER IF EXISTS agecheck;//
CREATE TRIGGER agecheck before INSERT on osoba FOR EACH ROW  
IF( NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR) THEN 
DELETE FROM osoba WHERE  NEW.dataUrodzenia > sysdate() - INTERVAL 18 YEAR OR NEW.dataUrodzenia IS NULL; END IF;//
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
    id INT NOT NULL,
    osoba INT NOT NULL,
    typ ENUM('sport', 'nauka', 'inne') NOT NULL ,
    PRIMARY KEY (typ,osoba, id));
COMMIT;

#3
BEGIN;
SET @MIN = current_timestamp()- INTERVAL 122 YEAR;
SET @MAX = current_timestamp()- INTERVAL 18 YEAR;
CREATE table IF NOT EXISTS Hobby.zwierzak SELECT * FROM menagerie.pet;
INSERT INTO osoba(imię,dataUrodzenia,płeć) select distinct owner,DATE(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN)), 
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
ALTER TABLE zwierzak add foreign key (id) REFERENCES osoba(id);
ALTER table Hobby add foreign key (osoba) REFERENCES osoba(id);
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
             SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),  
             SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),
             DATE(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN)),
             (case floor(rand()*2)  when 0 then 'm' when 1 then 'f' end));
		ELSEIF nazwa='sport' THEN
        INSERT INTO sport(nazwa,typ,lokacja) VALUES(
			SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ), 
			(case floor(rand()*3)  when 0 then 'indywidualny' when 1 then 'drużynowy' when 2 then 'mieszany'end),
			SUBSTRING(MD5(RAND()) FROM 1 FOR 8 )); 
			ELSEIF nazwa='nauka' THEN
			INSERT INTO nauka(nazwa,lokacja) VALUES(SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ));
			ELSEIF nazwa='inne' THEN
			INSERT INTO inne(nazwa,lokacja,towarzysze) VALUES(SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),
            (case floor(rand()*2)  when 0 then true when 1 then false end));
			elseif  nazwa='hobby' THEN
			set @en = floor(rand()*3 );
				if @en=0 then set @e='sport';end if;
				if @en=1 then set @e='nauka';end if;
				if @en=2 then set @e='inne';end if;
                SET FOREIGN_KEY_CHECKS=0;
				INSERT INTO hobby(osoba,id,typ) values(floor(rand()*(select count(*) from osoba)+1),floor(rand()*1000000),@e);
                SET FOREIGN_KEY_CHECKS=1;
			END IF;
		END WHILE;
END//
CALL addRandom(1000,'osoba');//
CALL addRandom(300,'sport');//
CALL addRandom(300,'nauka');//
CALL addRandom(550,'inne');//
CALL addRandom(1300,'hobby');//
DELIMITER ;
#drop database Hobby;
#8
PREPARE stmtZ8 FROM 
"
select nazwa
from (Select nazwa, id, 'sport' as typ
		from sport
        union
        select nazwa, id, 'nauka'
        from nauka
        union
        select nazwa, id, 'inne'
        from inne
        ) as t inner join hobby on t.id = hobby.id
where t.typ = ? and hobby.osoba = ?;
";
#9
select * from hobby WHERE osoba = 35;
DROP PROCEDURE IF EXISTS  findHobbies;
DELIMITER //
CREATE procedure findHobbies(IN id_osoby int)
BEGIN
Select nazwa, id, 'sport' as typ
		from sport WHERE id =id_osoby
        union
        select nazwa, id, 'nauka'
        from nauka  WHERE id =id_osoby
        union
        select nazwa, id, 'inne'
        from inne  WHERE id = id_osoby
        union 
        select 'no - name', osoba, typ
        from hobby WHERE osoba =id_osoby;
END//
DELIMITER ;
CALL findHobbies(35);

#10
select * from hobby WHERE osoba = 35;
DROP PROCEDURE IF EXISTS  findHobbies;
DELIMITER //
CREATE procedure findHobbiesModificated(IN id_osoby int)
BEGIN
Select nazwa, id, 'sport' as typ
		from sport WHERE id =id_osoby
        union
        select nazwa, id, 'nauka'
        from nauka  WHERE id =id_osoby
        union
        select nazwa, id, 'inne'
        from inne  WHERE id = id_osoby
        union 
        select 'no - name', osoba, typ
        from hobby WHERE osoba = id_osoby
        union 
        select distinct species, id,'zwierzak'
        from zwierzak WHERE id =id_osoby;
END//
DELIMITER ;
#11
delimiter //
DROP TRIGGER IF EXISTS informations_adder;//
CREATE TRIGGER informations_adder before INSERT  on hobby FOR EACH ROW  
		if NEW.typ = 'inne' then INSERT IGNORE INTO inne(id,nazwa,lokacja,towarzysze)
        VALUES(NEW.id,SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),
				(case floor(rand()*2)  when 0 then true when 1 then false end));
		elseif NEW.typ = 'sport' then INSERT IGNORE INTO sport(id,nazwa,typ,lokacja) 
        VALUES(NEW.id,SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ), 
			(case floor(rand()*3)  when 0 then 'indywidualny' when 1 then 'drużynowy' when 2 then 'mieszany'end),
			LEFT(UUID(), 6));
		elseif NEW.typ = 'nauka' then INSERT IGNORE INTO nauka(id,nazwa,lokacja) VALUES(NEW.id,SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ),SUBSTRING(MD5(RAND()) FROM 1 FOR 8 ));
		END IF;//
delimiter ;

 #12
delimiter //
DROP TRIGGER IF EXISTS delete_sport_in_hobby;//
CREATE TRIGGER delete_sport_in_hobby after DELETE on sport FOR EACH ROW  
	delete from hobby where typ='sport' and hobby.id=OLD.id;//
delimiter ;

#13
delimiter //
DROP TRIGGER IF EXISTS delete_nauka_in_hobby;//
CREATE TRIGGER delete_nauka_in_hobby after DELETE on nauka FOR EACH ROW  
	delete from hobby where typ='nauka' and hobby.id=OLD.id;//
    
DROP TRIGGER IF EXISTS update_nauka_in_hobby;//
CREATE TRIGGER update_nauka_in_hobby after UPDATE on nauka FOR EACH ROW  
	delete from hobby where typ='nauka' and hobby.id=OLD.id;//
delimiter ;
#=Test
#INSERT INTO hobby(id,osoba,typ) VALUES(99921,1,'nauka');
#UPDATE nauka set nazwa = 'analiza' where id = 99921;
#select * from nauka where id = '99921';
#select * from hobby where id = '99921';=#

#14
delimiter //
DROP TRIGGER IF EXISTS delete_osoba_hobbies;//
CREATE TRIGGER delete_osoba_hobbies after DELETE on osoba FOR EACH ROW 
BEGIN 
set @a = old.id;
delete from hobby WHERE hobby.osoba = @a;
UPDATE zwierzak SET zwierzak.id = (select osoba.id from osoba order by rand() LIMIT 1) WHERE zwierzak.id = @a;
END//
delimiter ;
SET FOReign_key_Checks=0;
#select * from zwierzak;
#select * from osoba;#mamy id osoby
#delete from osoba where id =1;
#select * from hobby;# hobby osoby i usuwamy je\
INSERT INTO hobby(id,osoba,typ) VALUES(123123,772,'nauka');
#select osoba.id from osoba order by rand() LIMIT 1;
#drop database Hobby;

#15
#mogą isnieć, zaden z adnym sie nie zazebia
delimiter //
drop view if exists test_view;
create view test_view AS
    SELECT  nazwa, id, 'sport' as typ
		from sport
        union
        select nazwa, id, 'nauka'as typ
        from nauka
		union
        select nazwa, id, 'inne' as typ
        from inne;
drop view if exists z16;
create view z16 as select distinct hobby.osoba,test_view.id,test_view.typ,nazwa,count(*)-1
        from hobby 
        right  Join test_view 
        ON hobby.id=test_view.id 
        and hobby.typ=test_view.typ
        group by test_view.typ,test_view.id,nazwa
        order by hobby.id desc;
select * from z16;
//
delimiter ;
select * from hobby;
#17 
DELIMITER $$
DROP view IF EXISTS hobby_view;
CREATE VIEW IF hobby_view AS 
SELECT zwierzak.name,zwierzak.species,osoba.imię, osoba.id as osoba,hobby.id as hobby,hobby.typ from osoba 
left join zwierzak on osoba.id = zwierzak.id 
left JOIN hobby ON osoba.id = hobby.osoba
left JOIN sport ON hobby.id=sport.id 
left join nauka  on hobby.id=nauka.id
left join inne  on hobby.id=inne.id
order by osoba.id ;
select * from hobby_view;$$
delimiter ;

#18
delimiter //
DROP procedure if exists z18;
CREATE PROCEDURE z18()
BEGIN
	select o.id,o.imię,o.dataUrodzenia,count(*) as ilosc_hobby from hobby as h 
	JOIN Osoba as o on h.osoba = o.id group by o.id
	HAVING ilosc_hobby = (select ilosc from (select count(*) as ilosc  from hobby as h1 
	JOIN Osoba as o1 on h1.osoba = o1.id  group by o1.id) as t order by ilosc desc limit 1);
END;
call z18();//
delimiter ;
#drop database Hobby;

