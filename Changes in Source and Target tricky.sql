-- Question 2:
-- Using the source and target tables, write a query to classify records into three categories:
-- 1. New to source: Rows in the source table but not in the target table.
-- 2. New to target: Rows in the target table but not in the source table.
-- 3. Mismatch: Rows where IDs match but names differ between the two tables.

-- drop and recreate the source and target tables
drop table if exists source;
create table source (
    id int,            -- unique identifier for the record
    name varchar(1)    -- name of the record
);

drop table if exists target;
create table target (
    id int,            -- unique identifier for the record
    name varchar(1)    -- name of the record
);

-- insert sample data into the source table
insert into source values (1, 'A');
insert into source values (2, 'B');
insert into source values (3, 'C');
insert into source values (4, 'D');

-- insert sample data into the target table
insert into target values (1, 'A');
insert into target values (2, 'B');
insert into target values (4, 'X');
insert into target values (5, 'F');

-- commit the changes
commit;

-- display the source and target tables
select * from source;
select * from target;

-- use ctes to classify changes between source and target
with 
cte1 as (
    -- rows that are in source but not in target
    select s.id, s.name, 'new to source' as change_type
    from source s
    left join target t on s.id = t.id
    where t.id is null
),
cte2 as (
    -- rows that are in target but not in source
    select t.id, t.name, 'new to target' as change_type
    from source s
    right join target t on s.id = t.id
    where s.id is null
),
cte3 as (
    -- rows where id matches but name is different
    select s.id, s.name, 'mismatch' as change_type
    from source s
    join target t on s.id = t.id
    where s.name <> t.name
)
-- combine all the changes
select * from cte1
union 
select * from cte2
union 
select * from cte3;
