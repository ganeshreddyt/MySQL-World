-- Generate match schedules for IPL teams:
-- 1. Each team plays with every other team exactly once.
-- 2. Each team plays with every other team exactly twice.

-- drop and recreate the teams table
drop table if exists teams;
create table teams (
    team_code varchar(10),       -- unique team code
    team_name varchar(40)        -- full team name
);

-- insert sample IPL teams
insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderabad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');

-- commit the changes
commit;

-- display the teams table
select * from teams;

-- case 1: each team plays with every other team exactly once
-- using cross join with a condition
select t1.team_name as team_1, t2.team_name as team_2
from teams t1
cross join teams t2
where t1.team_code < t2.team_code
order by t1.team_name, t2.team_name;

-- case 2: each team plays with every other team exactly twice
-- using cross join without conditions
select t1.team_name as team_1, t2.team_name as team_2
from teams t1
cross join teams t2
where t1.team_code <> t2.team_code
order by t1.team_name, t2.team_name;
