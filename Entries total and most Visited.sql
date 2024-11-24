-- Problem Statement:
-- Retrieve the total number of unique visits, the most visited floor, and all resources for each user.
-- Constraint: Consider total visits as how many times a user entered with a unique email ID.

use practice;

drop table if exists entries;

-- create table 'entries' to store user visit information
create table entries (
    name varchar(10),            -- user name
    address varchar(20),         -- user address
    email varchar(50),           -- user email
    floor int,                   -- floor number the user visited
    resources varchar(20)        -- resources used by the user
);

-- insert 10 records into the 'entries' table
insert into entries values
('user1', 'Madanapalle', 'user1@gmail.com', 1, 'MOBILE'),
('user1', 'Madanapalle', 'user12@gmail.com', 2, 'DESKTOP'),
('user1', 'Madanapalle', 'user123@gmail.com', 3, 'CASSET PLAYER'),
('user2', 'Thamballapalle', 'user2@gmail.com', 2, 'LAPTOP'),
('user2', 'Thamballapalle', 'user2@gmail.com', 1, 'MOBILE'),
('user2', 'Thamballapalle', 'user23@gmail.com', 2, 'LAPTOP'),
('user2', 'Thamballapalle', 'user234@gmail.com', 3, 'VIDEO GAME'),
('user3', 'Thirupathi', 'user3@gmail.com', 3, 'CASSET PLAYER'),
('user3', 'Thirupathi', 'user34@gmail.com', 2, 'DESKTOP'),
('user3', 'Thirupathi', 'user34@gmail.com', 2, 'LAPTOP');

-- display all rows in 'entries' table
select * from entries;

-- Query to retrieve total_visits, most_visited_floor, and all resources for each user

with cte as (
    -- step 1: find the most visited floor for each user
    select name, floor, count(floor) as most_visited
    from entries
    group by name, floor
)
-- step 2: calculate total visits (distinct email entries), 
-- most_visited floor, and concatenate all resources used by the user
select e.name, 
       count(distinct e.email) as total_visits, 
       max(c.most_visited) as most_visited,  -- maximum number of visits to the floor
       group_concat(distinct e.resources) as resources  -- concatenates all resources used by the user
from cte c 
join entries e 
    on c.name = e.name
group by e.name;
