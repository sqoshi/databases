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