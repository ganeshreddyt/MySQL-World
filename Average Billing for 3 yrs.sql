use practice;

create table billing
(
      customer_id               int
    , customer_name             varchar(1)
    , billing_id                varchar(5)
    , billing_creation_date     date
    , billed_amount             int
);

insert into billing values (1, 'A', 'id1', '2020-10-10', 100);
insert into billing values (1, 'A', 'id2', '2020-11-11', 150);
insert into billing values (1, 'A', 'id3', '2021-10-11', 100);
insert into billing values (2, 'B', 'id4', '2019-11-10', 150);
insert into billing values (2, 'B', 'id5', '2020-11-11', 200);
insert into billing values (2, 'B', 'id6', '2021-12-10', 250);
insert into billing values (3, 'C', 'id7', '2018-02-02', 100);
insert into billing values (3, 'C', 'id8', '2019-05-10', 250);
insert into billing values (3, 'C', 'id9', '2021-06-01', 300);

-- Problem Statement: Calculate avg billing for all the customers for the last 3 years

select * from billing;

-- Solution:
select customer_id, customer_name, sum(billed_amount) / 3 as avg_bill
       from billing
       where year(billing_creation_date) between 2019 and 2021
	   group by customer_id, customer_name

