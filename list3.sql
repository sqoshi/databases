#1
use Hobby;
DELIMITER $$
BEGIN;
ALTER TABLE osoba add index(imię);
ALTER TABLE osoba add index(dataUrodzenia);
ALTER TABLE sport add index(id,nazwa);
ALTER TABLE inne add index(nazwa,id);
ALTER TABLE hobby add index(osoba,id,typ);
COMMIT;$$
Delimiter ;
#show index from hobby;

#2 explain before statement to check 
select płeć from osoba where imię LIKE 'A%'; #index 
select nazwa from sport where typ ='drużynowy'order by nazwa;#filesort,where
select s1.id,s2.id from sport as s1 inner join sport as s2 on s1.lokacja=s2.lokacja and s1.id < s2.id ;#where, joinbuffer
insert into sport(nazwa,typ,lokacja) values('szermierka','indywidualny','krakow');
insert into sport(nazwa,typ,lokacja) values('medytacja','indywidualny','krakow');
select * from osoba where dataUrodzenia < '2000-01-01'; #where
select *,count(*) from hobby group by id order by count(*) desc limit 1;#index, temporary,filesort
select imię from zwierzak z join osoba o on z.id=o.id where species='dog' order by z.birth desc limit 1;#where,filesort

#3
delimiter $$
drop table zawody;
CREATE TABLE IF NOT EXISTS zawody(
id int auto_increment,
nazwa varchar(25),
pensja_min int,
pensja_max int,
primary key(id));
CREATE TABLE IF NOT EXISTS praca(
id_zawod int,
id_osoba int,
zarobki int);
#drop procedure addBeruf;$$
drop procedure if exists addBeruf;
CREATE Procedure addBeruf()
BEGIN
    DECLARE i INT DEFAULT 0;
	WHILE(i<10) DO
    insert into zawody(nazwa,pensja_min,pensja_max) values(
	ELT(i+1, 'Prawnik', 'Stolarz', 'Lekarz',
    'Programista', 'Tester Oprorgamowania', 'Nauczyciel',
    'Malarz', 'Policjant', 'Mechanik','Piłkarz'),
	(RAND()*3700 + 1400),
	(RAND()*4000 + 5800));
    SET i = i+1;
    END WHILE;
eND;
call addBeruf();
select * from zawody;
#drop procedure connect_praca_zawod;
DROP PROCEDURE IF EXISTS connect_praca_zawod;
create procedure connect_praca_zawod()
BEGIN
DECLARE finished INTEGER DEFAULT 0;
DECLARE id_osoby INT;
DECLARE my_first_cursor CURSOR FOR (select id from osoba);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN my_first_cursor;
getPerson: LOOP
	SET @x = floor(RAND()*10+1);
	FETCH my_first_cursor INTO id_osoby;
    IF finished then leave getPerson; END IF;
    INSERT INTO praca(id_zawod,id_osoba,zarobki) VALUES(
    @x,
    id_osoby,
    (select floor(RAND()*(t2.pensja_max-t1.pensja_min)+pensja_min)
	as summary from (SELECT pensja_min,id from zawody where id = @x)as t1 
	join (SELECT pensja_max,id from zawody where id = @x) as t2 on t1.id=t2.id)
    );
    END LOOP;
CLOSE my_first_cursor;
END;
call connect_praca_zawod();
$$
delimiter ;



#4
delimiter $$
drop procedure if exists z4;
CREATE PROCEDURE z4 (IN kol ENUM('id', 'imie', 'dataUrodzenia', 'plec','nazwisko'), IN agg VARCHAR(20), OUT X VARCHAR(100))
BEGIN
    SET @temp = NULL;
    SET @arg = kol;
    CASE LOWER(agg)
        WHEN 'avg' THEN
			IF(kol = 'dataUrodzenia') THEN
            SET @query = CONCAT('SELECT YEAR(CURDATE()) - AVG(YEAR(DATEDIFF(CURDATE() ,', kol, ')))	 FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
        WHEN 'count' THEN
			IF(kol = 'imie' OR kol = 'plec') THEN
            SET @query = CONCAT('SELECT COUNT(', kol, ') FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
        WHEN 'max' THEN
			IF(kol = 'dataUrodzenia') THEN
            SET @query = CONCAT('SELECT MAX(', kol, ') FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
        WHEN 'min' THEN
			IF(kol = 'dataUrodzenia') THEN
            SET @query = CONCAT('SELECT MIN(', kol, ') FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
        WHEN 'group_concat' THEN
			IF(kol <> 'id') THEN
            SET @query = CONCAT('SELECT GROUP_CONCAT(', kol, ') FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
		WHEN 'std' THEN
			IF(kol = 'dataUrodzenia') THEN
            SET @query = CONCAT('SELECT STD( YEAR( DATEDIFF( CURDATE(),', kol, '))) FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
		WHEN 'var_pop' THEN
			IF(kol = 'dataUrodzenia') THEN
            SET @query = CONCAT('SELECT VAR_POP( YEAR (DATEDIFF( CURDATE(),', kol, '))) FROM osoba INTO @temp');
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Function Fail';
    END CASE;
    SET X = @temp;
END
$$
DELIMITER ;
set @wynik ='';
CALL z4('dataUrodzenia', 'avg', @wynik);
SELECT @wynik;

#5
delimiter //
CREATE TABLE IF NOT EXISTS hasła(
id_osoby INT,
hash_hasła varchar(200));//
drop procedure if EXISTS find_birthday;
create procedure find_birthday(IN imię VARCHAR(25), IN hasło VARCHAR(25))
BEGIN
IF((select count(*) from hasła where md5(hasło) IN (hash_hasła))>0) THEN
select o.dataUrodzenia from osoba as o 
join hasła as h on o.id=id_osoby 
where h.hash_hasła = md5(hasło) and o.imię = imię;
ELSE select date_format(
    from_unixtime(
         rand() * 
            (unix_timestamp(date(NOW()))) + 
             unix_timestamp(date(NOW())-interval 100 YEAR)), '%Y-%m-%d') as randomdate;
END IF;
END
//
delimiter ;
