use practice;

-- Dataset:
drop table travel_items;

create table travel_items
(
id int,
item_name varchar(50),
total_count int
);

insert into travel_items values
(1, 'Water Bottle', 2),
(2, 'Tent', 1),
(3, 'Apple', 4);


select * from travel_items;

-- PROBLEM STATEMENT: Ungroup the given input data. expand the items as specified no.of times and display the result as per expected output.

-- approach) Recursive query.
-- Recaping Recusion syntax....
-- Print 1 to N numbers
with recursive cte as(
   select 1 as n
   union
   select n + 1 from cte where n < 10 )
select * from cte;

 
with recursive cte as(
select 1 as n -- Base condition
union all
select n+1 from cte where n < 10
)
select * from cte;

-- Ungroup Items
with recursive cte as(
select id, item_name, total_count from travel_items -- Base condition can be taken from any table
union all
select id, item_name, total_count-1 from cte where total_count > 1 -- Main condition should has the table name as the cte name
)
select * from cte
order by id;


