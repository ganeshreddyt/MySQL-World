-- Drop the table if it exists
drop table if exists business_operations;

-- Create the table business_operations
create table if not exists business_operations
(
    operation_date date,
    city_id int
);

-- Insert values into business_operations
insert into business_operations values
 ('2020-01-01', 3),
 ('2020-06-30', 1),
 ('2020-11-26', 4),
 ('2020-01-02', 2),
 ('2021-09-10', 1),
 ('2022-07-21', 5),
 ('2021-06-23', 6),
 ('2023-08-30', 4),
 ('2023-12-11', 3),
 ('2021-02-23', 7),
 ('2022-04-30', 4);

-- Problem: Display the table contents ordered by operation_date and city_id
select * 
from business_operations 
order by operation_date, city_id;

-- Attempted approach (didn't work as intended)
select year(t1.operation_date) as year_formed,
       count(case when t2.city_id <> t1.city_id then 1 else 0 end) as new_location_cnt
from business_operations t1 
join business_operations t2
    on t1.operation_date < t2.operation_date
group by year_formed
order by year_formed;

-- Correct approach using a correlated subquery
select year(b.operation_date) as year_formed,
       sum(case 
               when city_id not in (select city_id 
                                    from business_operations 
                                    where operation_date < b.operation_date) 
               then 1 
               else 0 
           end) as new_bsn_cnt
from business_operations b
group by year_formed
order by year_formed;
