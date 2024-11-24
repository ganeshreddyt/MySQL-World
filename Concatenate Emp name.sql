-- Problem Statement:  
-- Merge adjacent employee names in a single row alternatively. For example, 
-- emp1 and emp2 should appear in one row, emp3 and emp4 in another, and so on.

use practice;

-- create table 'empx' to store employee information
create table if not exists empx (
    emp_id int,      -- employee ID
    emp_name varchar(10) -- employee name
);

-- insert 10 employee records into the 'empx' table
insert into empx values
(1,'emp1'), (2,'emp2'), (3,'emp3'), (4,'emp4'), (5,'emp5'),
(6,'emp6'), (7,'emp7'), (8,'emp8'), (9,'emp9'), (10,'emp10');

-- display all rows in 'empx' table
select * from empx;

-- Q1: Merge adjacent employee names in a single row alternatively
-- For example: emp1, emp2 in one row, emp3, emp4 in another row, and so on.

select result, row_number() over() as row_num 
from (
    -- concatenate adjacent employee names using the LEAD() function
    select concat(emp_name, ', ', lead(emp_name) over()) as result, 
           row_number() over() as row_num 
    from empx
) x
-- filter only odd-numbered rows (which will contain the concatenated pairs)
where x.row_num % 2 = 1;
