-- Problem: Calculate total runs scored in each over using the NTILE() function
-- use the 'practice' database
use practice;

-- create table match_runs to store ball-by-ball data
create table match_runs (
    balls int,  -- ball number (sequential)
    runs int    -- runs scored on that ball
);

-- insert sample data into match_runs
insert into match_runs values
(1, 2),   -- 2 runs scored on the 1st ball
(2, 3),   -- 3 runs scored on the 2nd ball
(3, 1),   -- 1 run scored on the 3rd ball
(4, 3),   -- 3 runs scored on the 4th ball
(5, 6),   -- 6 runs scored on the 5th ball
(6, 1),   -- 1 run scored on the 6th ball
(7, 0),   -- no runs scored on the 7th ball
(8, 3),   -- 3 runs scored on the 8th ball
(9, 1),   -- 1 run scored on the 9th ball
(10, 4),  -- 4 runs scored on the 10th ball
(11, 2),  -- 2 runs scored on the 11th ball
(12, 1);  -- 1 run scored on the 12th ball

-- display all rows in the match_runs table
select * from match_runs;

-- calculate total runs for each over using ntile()
select 
    bucket_no as overs,         -- bucket number representing overs
    sum(runs) as total_runs     -- total runs scored in each over
from (
    -- assign each ball to an over using ntile()
    select 
        balls,                  -- ball number
        runs,                   -- runs scored on the ball
        ntile(2) over(order by balls) as bucket_no -- divide rows into 2 overs
    from match_runs
) x
-- group by bucket number to calculate total runs for each over
group by x.bucket_no;

-- New introduction to NTILE() function
-- Thanks to Toufiq Bayya for sharing this amazing concept!
