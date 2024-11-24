-- Use the "practice" database
use practice;

-- Create table "sales" if it doesn't already exist
create table if not exists sales
(
    order_date date,
    sales int
);

-- Insert values into the "sales" table
insert into sales values
('2021-01-01', 20),
('2021-01-02', 32),
('2020-02-29', 79),
('2021-02-28', 13),
('2021-03-14', 33),
('2021-03-25', 41),
('2022-05-04', 20),
('2022-04-30', 65);

-- Print sales table content to verify the inserted data
select * from sales;

--Problem: Query to find monthly and yearly sales and sort them in descending order

-- Simple query to extract the year and month from the order_date
select year(order_date) as order_year, 
       month(order_date) as order_month,
       sales 
from sales;

-- Incorrect approach with a self-join that doesn't provide valid results
-- The join operation in this context is unnecessary and incorrect for summing sales
select t1.order_year, t1.order_month, sum(t1.sales) as total_sales
from (select year(order_date) as order_year, 
             month(order_date) as order_month,
             sales 
      from sales) as t1
join (select year(order_date) as order_year, 
             month(order_date) as order_month,
             sales 
      from sales) as t2
on t1.order_year = t2.order_year
group by t1.order_year, t1.order_month
order by order_year, order_month;

-- Correct approach: No need for a join, we can simply group by year and month
select order_year, order_month, sum(sales) as total_sales
from (select year(order_date) as order_year, 
             month(order_date) as order_month,
             sales 
      from sales) as x
group by order_year, order_month
order by total_sales desc;

-- Advanced answer: Simple and concise solution using GROUP BY directly
-- No need for subqueries or joins
select year(order_date) as order_year, 
       month(order_date) as order_month,
       sum(sales) as total_sales
from sales
group by year(order_date), month(order_date)
order by total_sales desc;
