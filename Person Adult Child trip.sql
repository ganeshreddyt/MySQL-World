-- Use the 'practice' database
use practice;

-- Drop the table if it exists
drop table if exists family;

-- Create the table 'family'
create table family 
(
    person varchar(5),    -- Person ID
    type varchar(10),     -- Type (Adult or Child)
    age int               -- Age of the person
);

-- Insert values into the 'family' table
insert into family values 
('A1','Adult',54),
('A2','Adult',53),
('A3','Adult',52),
('A4','Adult',58),
('A5','Adult',54),
('C1','Child',20),
('C2','Child',19),
('C3','Child',22),
('C4','Child',15);

-- Display all records in the 'family' table
select * from family;

-- Problemd 1: Query to pair Adults and Children based on the given conditions
-- Match Adults (type = 'Adult') and Children (type = 'Child') for a ride.
-- The matching criteria: Higher-aged adults should pair with younger-aged children in descending adult age and ascending child age order.

with cte1 as (
   select *, 
          row_number() over(order by age desc) as rn 
   from family
   where type = 'Adult'
),
cte2 as (
   select *, 
          row_number() over(order by age) as rn 
   from family
   where type = 'Child'
)
select t1.person as adult_person, 
       t2.person as child_person
from cte1 t1 
left join cte2 t2
on t1.rn = t2.rn;

-- Problem 2: Make pairs of Adults and Children based on their person IDs (person).
-- Each Adult (A%) must pair with their corresponding Child (C%) based on the person ID pattern (e.g., A1 pairs with C1, A2 pairs with C2, etc.).

-- Query to pair Adults and Children based on their person IDs
with cte as (
   select *, 
          row_number() over(partition by type order by person) as rn
   from family
)
select 
       min(case when person like 'A%' then person end) as adult_person,
       min(case when person like 'C%' then person end) as child_person
from cte 
group by rn;

