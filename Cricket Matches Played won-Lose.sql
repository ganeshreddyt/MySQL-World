-- Problem: Calculate the total number of matches played, won, and lost for each team using SQL.
-- use the 'practice' database
use practice;

-- drop the matches table if it already exists
drop table if exists matches;

-- create matches table to store team match data
create table if not exists matches (
    team_A varchar(20),   -- team A name
    team_B varchar(20),   -- team B name
    winner varchar(20)    -- winner of the match
);

-- insert sample match data into the matches table
insert into matches values
('India', 'Australia', 'India'),
('England', 'Newzealand', 'England'),
('South Africa', 'Pakistan', 'South Africa'),
('Newzealand', 'India', 'India'),
('Bangladesh', 'Sri Lanka', 'Sri Lanka'),
('Afghanistan', 'West Indies', 'Afghanistan'),
('Sri Lanka', 'West Indies', 'West Indies'),
('England', 'Pakistan', 'England'),
('India', 'Pakistan', 'India');

-- display all rows in the matches table
select * from matches;

-- Q1: Method 1 - Calculate total matches played, won, and lost for each team (lengthy method)

with all_teams as (
    -- get a list of all teams (team_A and team_B) from both sides of the match
    select team_A as team from matches 
    union 
    select team_B as team from matches
),
total_matches as (
    -- count total matches played by each team
    select a.team, count(a.team) as total_matches_played
    from (select team_A as team from matches union all select team_B as team from matches) a
    group by a.team
),
won_matches as (
    -- count the number of matches each team has won
    select a.team, 
        (case when x.matches_won is null then 0 else x.matches_won end) as won_matchess
    from all_teams a 
    left join (
        select winner, count(winner) as matches_won 
        from matches 
        group by winner
    ) x on a.team = x.winner
)
-- join the total matches and won matches, then calculate lost matches
select t.*, w.won_matchess, 
       (t.total_matches_played - w.won_matchess) as matches_losed
from total_matches t 
join won_matches w on t.team = w.team;

-- Q2: Method 2 - Simple method to calculate total matches played, won, and lost for each team

with cte as (
    -- create a temporary table with match results for each team
    select team_A as team, 
           case when team_A = winner then 1 else 0 end as won from matches
    union all
    select team_B, 
           case when team_B = winner then 1 else 0 end as won from matches
)
-- count the total matches, wins, and losses for each team
select team, 
       count(*) as total_played, 
       sum(won) as total_won, 
       count(*) - sum(won) as total_losed
from cte
group by team;
