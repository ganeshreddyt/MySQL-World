-- Create the applicants table
create table if not exists applicants
(
    candidate_id int,
    skills varchar(20)   -- tinytext
);

-- Insert data into the applicants table
insert into applicants values
(101, 'Python'),
(101, 'SQL'),
(101, 'Power BI'),
(102, 'Python'),
(103, 'Python'),
(103, 'SQL'),
(110, 'Python'),
(110, 'SQL'),
(110, 'Power BI'),
(105, 'SQL'),
(105, 'Python'),
(105, 'Power BI'),
(109, 'C/C++');  -- This candidate does not meet the requirements

-- Problem Statement: Find the candidates best suited for an open Data Science job.
-- The requirement is that candidates must be proficient in Python, SQL, and Power BI.

-- Print the applicants table content
select candidate_id, skills from applicants;

-- Display applicants ordered by candidate_id for reference
select * from applicants order by candidate_id;

-- Query to list candidates who possess all the required skills: Python, SQL, and Power BI
select candidate_id
from applicants
where skills in ('Python', 'SQL', 'Power BI')  -- Filter for required skills
group by candidate_id
having count(distinct skills) = 3  -- Check if the candidate has all 3 distinct skills
order by candidate_id;
