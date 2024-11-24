-- Use the "practice" database
use practice;

-- Drop the table if it exists to avoid duplication errors
drop table if exists src_dest_distance;

-- Create table "src_dest_distance"
create table src_dest_distance
(
    source varchar(20),
    destination varchar(20),
    distance int
);

-- Insert records into "src_dest_distance"
insert into src_dest_distance values
('Thamballapalle', 'Madanapalle', 36),
('Madanapalle', 'Thamballapalle', 36),
('Madanapalle', 'Thirupathi', 123),
('Thirupathi', 'Madanapalle', 123),
('Thamballapalle', 'Buruju', 2),
('Buruju', 'Thamballapalle', 2),
('Thamballapalle', 'NP Kunta', 36);

-- Delete specific records
delete from src_dest_distance where destination = 'NP Kunta';

-- View table content for verification
select source, destination, distance 
from src_dest_distance;

-- Problem Statement:
-- Write a query to fetch all unique source-destination pairs
-- This means each trip should only appear once, regardless of order.

-- Accurate Solution:
-- Use a CTE to assign row numbers and compare only once for unique pairs
with cte as (
    select *, 
           row_number() over() as rn
    from src_dest_distance
)
select t1.source, t1.destination, t1.distance
from cte t1
join cte t2 
on t1.rn < t2.rn 
   and t1.destination = t2.source 
   and t1.source = t2.destination;
