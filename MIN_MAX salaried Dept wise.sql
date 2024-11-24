-- Drop and recreate the employees table
drop table if exists employees;

create table employees
(
    emp_id int primary key,
    emp_name varchar(20),
    dept_id int,
    salary int 
);

-- Insert values into employees
insert into employees values
(1, 'Rajesh', 100, 3400),
(2, 'Abzal', 101, 2400),
(3, 'Pradeep', 102, 3000),
(4, 'Ravi Kumar', 101, 2500),
(5, 'Jagadeesh', 100, 3200),
(6, 'Gopal Chari', 101, 2900),
(7, 'Radhan Varma', 102, 2700),
(8, 'Kumar Varma', 103, 3100);

-- Select all records ordered by department and salary
select * 
from employees 
order by dept_id, salary;

-- Query to get minimum and maximum salaried employees for each department
select dept_id, 
       first_value(emp_name) over(partition by dept_id order by salary) as min_salaried,
       first_value(emp_name) over(partition by dept_id order by salary desc) as max_salaried
from employees;

-- Using row_number() to ensure one row per department for min and max salaried employees
select dept_id, min_salaried, max_salaried 
from (
    select dept_id, 
           first_value(emp_name) over(partition by dept_id order by salary) as min_salaried,
           first_value(emp_name) over(partition by dept_id order by salary desc) as max_salaried,
           row_number() over(partition by dept_id order by dept_id) as rn
    from employees
) x
where x.rn = 1;

-- Use dense_rank() to rank employees within each department based on salary
select *, 
       dense_rank() over(partition by dept_id order by salary) as dense_rnk
from employees;
