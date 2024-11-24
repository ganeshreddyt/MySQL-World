-- Use the database 'practice'
use practice;

-- Drop the table if it exists
drop table if exists call_details;

-- Create the table 'call_details'
create table call_details  (
    call_type varchar(10),         -- Type of the call (OUT, INC, SMS)
    call_number varchar(12),       -- Phone number associated with the call
    call_duration int              -- Duration of the call in seconds
);

-- Insert values into 'call_details'
insert into call_details
values 
 ('OUT','181868',13),
 ('OUT','2159010',8),
 ('OUT','2159010',178),
 ('SMS','4153810',1),
 ('OUT','2159010',152),
 ('OUT','9140152',18),
 ('SMS','4162672',1),
 ('SMS','9168204',1),
 ('OUT','9168204',576),
 ('INC','2159010',5),
 ('INC','2159010',4),
 ('SMS','2159010',1),
 ('SMS','4535614',1),
 ('OUT','181868',20),
 ('INC','181868',54),
 ('INC','218748',20),
 ('INC','2159010',9),
 ('INC','197432',66),
 ('SMS','2159010',1),
 ('SMS','4535614',1);

-- Pblm: Display all records ordered by call_number
select * 
from call_details 
order by call_number;

-- Query to find numbers meeting the constraints
select call_number, 
       outgoing_call_cost, 
       incoming_call_cost 
from
    (select call_number, 
            sum(case when call_type = 'OUT' then call_duration else 0 end) as outgoing_call_cost,
            sum(case when call_type = 'INC' then call_duration else 0 end) as incoming_call_cost
     from call_details
     group by call_number) x
where outgoing_call_cost > incoming_call_cost 
      and incoming_call_cost > 0; -- Ensure the number has both incoming and outgoing calls
