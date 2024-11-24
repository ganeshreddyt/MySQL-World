-- Problem Statement:
-- Fill the succeeding null values in the 'category' column with appropriate values based on the previous non-null value in the column.

use practice;

drop table if exists products;

-- create products table
create table products (
    prod_id int,        -- product ID
    prod_name varchar(20), -- product name
    category varchar(20)   -- category of the product
);

-- insert values into products table
insert into products values
(100, 'Water Bottle', 'Class C'),
(101, 'Lemon Juice', null),
(102, 'Orange Juice', null),
(103, 'Boost', 'Class B'),
(104, 'Bornvita', null),
(105, 'Horlicks', null),
(106, 'Gluco Plus', null),
(107, 'Salad', 'Class A'),
(108, 'Energy Drink', null);

-- Method 1: Using a simple case with previous category (does not work as expected)
set @val = (select category from products limit 1);  -- Assigning initial category value
-- This query does not work as expected due to limitations with variables in select statements
-- select prod_id, prod_name, 
--        case when category is null then @val
--             else @val = category end as category
-- from products;

-- Method 2: Recursive CTE approach (complex but illustrates the logic)
with recursive cte as (
    select *, 1 as rn 
    from products
    union all
    select p.prod_id, p.prod_name,
           case when p.category is null then (select lag(category, 1) over() from cte)
                else p.category end as category, 
           rn + 1
    from cte c join products p on 1 = 1 
    where rn < 10
)
select * from cte;

-- Solution 1: Using window functions and COUNT() for filling nulls
with cte as (
    select *, count(category) over(order by prod_id) as cnt
    from products
),
cte2 as (
    select category, cnt
    from cte 
    where category is not null
)
select c1.*, c2.category
from cte c1 
join cte2 c2 on c1.cnt = c2.cnt;

-- Solution 2: Using FIRST_VALUE() window function to carry forward previous category
with cte as (
    select *, count(category) over(order by prod_id) as cnt
    from products
)
select *, first_value(category) over(partition by cnt) as category2
from cte;

-- Solution 3: Using MAX() aggregate function to fill the null categories
with cte as (
    select *, count(category) over(order by prod_id) as cnt
    from products
)
select *, max(category) over(partition by cnt) as category2
from cte;

-- Solution 4: Recursive CTE with row number calculation (Alternative solution)
with recursive cte as (
    select 1 as rn, 1 as rw
    union all
    select case when category is null then c.rn
               else c.rn + 1 
    end as rn, rw + 1 as rw 
    from cte c 
    join products p on 1 = 1
    where rw < (select count(*) from products)
)
select * from cte;
