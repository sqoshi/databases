#1
show tables;

#2
select name,owner from pet;

#3
select birth from pet;

#4
select name,birth from pet where month(birth)<=6 ;

#5
select distinct species from pet where sex='m';

#6
select name,date from event where remark IS NOT NULL order by date desc;

#7
select distinct owner from pet where name like '%ffy%';

#8
select owner, name from pet where death is null;

#9
select owner,count(owner) from pet group by owner having count(owner)>1;

#10 VERY VERY HARD AND ITS NOT LAST XD
select owner, name, birth from pet where death is not null and  ;

#11 
select name, birth from pet where birth between '1992/01/01' and '1994/06/01';

#12 utnie jesli beda 2 takie same 
select birth,name from pet
where death is null group by name order by birth asc limit 2;

select * from pet where death is null;

#13
select * from pet where death is null
 and birth = (select max(birth) from pet where death is null);
 
 #14
 select * from pet as p JOIN event as e on p.name=e.name
 where date > (select date from event where name = 'Slim' and type ='vet') order by date asc;
 
 #15
 select * from pet where death is not null order by birth;
 
 #16
select p1.name,p2.name,p1.species,p2.species from pet as p1
 cross join pet as p2 where p1.name<p2.name and p1.species=p2.species; 

#17
alter table event add column performer varchar(50) after date;

#18
SET SQL_SAFE_UPDATES = 0;
update event SET performer=case
 when  type != 'vet' and type != 'litter' then name 
 else (case floor(rand()*2) when 0 then 'Shajiu' when 1 then 'Hu Lee Co' end)  end;

#19
update pet set owner='Diane' where species='cat';

#20
select species,count(species) from pet group by species order by count(Species) desc;

#21
delete from pet as  p where p.death is not null;

#22
alter table pet drop column death;

#23
BEGIN;
insert into pet (name,owner,species,sex,birth) 
values('Newton','Bob','dog','m','2012-04-17'),
('Rex','Stephen','dog','m','2018-06-27'),
('Fury','Stephen','hamster','m','2019-01-01'),
('Greta','Mia','goat','f','2018-08-23'),
('Grot','Mia','goat','f','2018-08-23'),
('Pluffy','Mia','sheep','f','2017-03-19'),
('Gamer','Mia','goat','f','2018-08-23');
insert into event(name,date,performer,type,remark)
values('Newton','2014-06-07','Jack Sparrow','exhibition', 'Gold Medal'),
('Fury','2019-02-04','Stephen','race', 'Hamster wheel '),
('Rex','2018-07-28','President','conference', 'Yellow Order'),
('Pluffy','2019-06-19','Hu Lee Co','litter', '3 sheep, 2 female ,1 male'),
('Gamer','2019-10-10','Shajiu','vet', 'Teeth Control'),
('Grot','2019-10-10','Shajiu','vet', 'Teeth Control'),
('Greta','2019-10-10','Shajiu','vet', 'Teeth Control ');
COMMIt;