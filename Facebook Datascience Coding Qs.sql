-- Problem Statement:
-- Find the count and percentage of each user activity (upload, comment, publish) for each day.
-- Additionally, identify how many posts published in the past 7 days received more emojis than likes.

use practice;

drop table if exists user_activity;

-- create user_activity table
create table user_activity (
    full_name varchar(20),   -- user full name
    UID varchar(9),          -- unique user ID
    activity varchar(10),    -- activity performed by the user
    Date date                -- date of the activity
);

-- clear all data from the user_activity table
truncate table user_activity;

-- insert records into user_activity table
insert into user_activity values
('Madhavan', '33x9010', 'comment', '2023-08-20'),
('Joseph', '33x9011', 'publish', '2023-08-20'),
('Gopi Nath', '33x9012', 'upload', '2023-08-20'),
('Guru', '33x9013', 'comment', '2023-08-20'),
('Guru', '33x9013', 'publish', '2023-08-21'),
('Joseph', '33x9011', 'publish', '2023-08-21'),
('Gopi Nath', '33x9012', 'upload', '2023-08-21'),
('Madhavan', '33x9010', 'upload', '2023-08-22'),
('Madhavan', '33x9010', 'upload', '2023-08-22'),
('Gopi Nath', '33x9012', 'upload', '2023-08-22');

-- post reactions table creation
create table post_reactions (
    post_id varchar(10),   -- post identifier
    reactions varchar(10), -- reaction type (Like, Emoji, etc.)
    UID varchar(20),       -- user ID who reacted
    Date date              -- date of the reaction
);

-- insert records into post_reactions table
insert into post_reactions values
('px1', 'Like', '33x9010', '2023-08-20'),
('px2', 'Like', '33x9011', '2023-08-20'),
('px3', 'Emoji', '33x9013', '2023-08-20'),
('px4', 'Heart', '33x9012', '2023-08-22'),
('px5', 'Heart', '33x9011', '2023-08-21'),
('px6', 'Emoji', '33x9013', '2023-08-20');

-- Retrieve count and percentage of each activity (upload, comment, publish) per day
with cte1 as (
    select Date, 
           sum(case when Activity = 'comment' then 1 else 0 end) as comment_cnt,
           sum(case when Activity = 'publish' then 1 else 0 end) as publish_cnt,
           sum(case when Activity = 'upload' then 1 else 0 end) as upload_cnt
    from user_activity
    group by Date
),
cte2 as (
    select Date, count(UID) as total_act_cnt
    from user_activity
    group by Date
)
select t1.*, 
       round(t1.comment_cnt / t2.total_act_cnt, 2) * 100 as comment_percent,
       round(t1.publish_cnt / t2.total_act_cnt, 2) * 100 as publish_percent,
       round(t1.upload_cnt / t2.total_act_cnt, 2) * 100 as upload_percent
from cte1 t1 
join cte2 t2 on t1.Date = t2.Date;

-- Query to find how many posts published in the last 7 days received more emojis than likes
with cte as (
    select p.post_id, 
           sum(case when p.reactions = 'Like' then 1 else 0 end) as like_cnt,
           sum(case when p.reactions = 'Emoji' then 1 else 0 end) as emoji_cnt
    from user_activity u 
    join post_reactions p 
    on u.UID = p.UID and p.reactions in ('Like', 'Emoji')
    where datediff('2023-08-22', u.Date) < 7 and u.activity = 'publish'
    group by p.post_id
)
select count(post_id) as post_cnt
from cte
where emoji_cnt > like_cnt;
