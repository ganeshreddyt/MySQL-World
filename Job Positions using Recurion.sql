-- Drop and create job_positions table
drop table if exists job_positions;
create table job_positions
(
    id          int,
    title       varchar(100),
    batches     varchar(10),
    levels      varchar(10),
    payscale    int,
    totalpost   int
);

-- Insert values into job_positions
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

-- Drop and create job_employees table
drop table if exists job_employees;
create table job_employees
(
    id              int,
    name            varchar(100),
    position_id     int
);

-- Insert values into job_employees
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

-- Verify table content
select * from job_positions;
select * from job_employees;

-- Problem: Calculate filled positions and vacancies for each position

-- Correct Query
select 
    jp.title as position_title,
    jp.totalpost as total_vacancies,
    count(je.id) as filled_positions,
    (jp.totalpost - count(je.id)) as remaining_vacancies
from 
    job_positions jp
left join 
    job_employees je 
on 
    jp.id = je.position_id
group by 
    jp.id, jp.title, jp.totalpost
order by 
    jp.id;
