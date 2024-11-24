
-- Write an SQL query to display the correct message from the input comments_and_translations table.
-- Use the translation column if available; otherwise, use the comment column.

-- use the 'practice' database
use practice;

-- drop and recreate the comments_and_translations table
drop table if exists comments_and_translations;
create table comments_and_translations (
    id int,                      -- unique identifier for the record
    comment varchar(100),        -- original comment
    translation varchar(100)     -- translated comment
);

-- insert sample data into the table
insert into comments_and_translations values
(1, 'very good', null),         -- no translation available
(2, 'good', null),              -- no translation available
(3, 'bad', null),               -- no translation available
(4, 'ordinary', null),          -- no translation available
(5, 'cdcdcdcd', 'very bad'),    -- translation available
(6, 'excellent', null),         -- no translation available
(7, 'ababab', 'not satisfied'), -- translation available
(8, 'satisfied', null),         -- no translation available
(9, 'aabbaabb', 'extraordinary'), -- translation available
(10, 'ccddccbb', 'medium');     -- translation available

-- commit the changes
commit;

-- display all rows in the table
select * from comments_and_translations;

-- approach 1: use coalesce to choose the first non-null value
select coalesce(translation, comment) as correct_message
from comments_and_translations;

-- approach 2: use a case statement to achieve the same result
select case when translation is not null then translation
            else comment
       end as correct_message
from comments_and_translations;
