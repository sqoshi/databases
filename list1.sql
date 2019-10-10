
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

#9 czemu nie pojawiaja sie osoby z iloscia 1 ?
select owner,count(owner) from pet group by owner order by count(owner) desc;

#10 WROC TO JEST ZLE
select owner, name, birth from pet where death is null 
and month(birth)>month(now()) order by name desc;

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
