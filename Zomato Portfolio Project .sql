-- create database zomato;
create database zomato;

use zomato;

drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
         (3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-02-09'),
        (2,'2015-01-15'),
		(3,'2014-11-04');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) VALUES 
(1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

--  1) What is the total sales amount 
-- Dataset required : 
--   1) sales : to get how many sales were happen
--   2) product : to get price of each product  
--   approach : Join two datasets on equivalent of product_id

-- it gets individual price with respective to the product id and name
select userid, created_date, p.product_id, product_name, price from 
      sales s join product p on s.product_id = p.product_id;

-- final output
select sum(price) as total_sales from 
      sales s join product p on s.product_id = p.product_id;
 
 
--  2) What is total amount spent by each customer on zomato
--  group by customer_id for Q1 gives sol for this qs, bcz it categorized per each user...

select userid, sum(price) from
       sales s join product p on s.product_id = p.product_id
       group by userid;
       
-- 3) How many days has each customer visited zomato
-- approach : use count() method
-- required dataset - sales dataset

-- important constraint is if we go with count(userid) and group by user_id it will produce wrong answer 
-- when user visits more than once in a day

select userid, count(distinct(created_date)) as visited_days
       from sales
       group by userid;


-- 4) What is the first product purchased by each customer
 select userid, created_date, product_id from
     (select *, 
          rank() over(partition by userid order by created_date) as rn from sales) a  
          -- ouput won't change if we done with rank or row_number()...
	  where rn = 1;
      
-- 4.1) what is the most purchased item in the menu and how many times it purchased by the customers

-- 4.1.1) most purchased product 
-- which has more count values it has been considered as most purchased one..

  select product_id, count(product_id) as cnt
       from sales
       group by product_id
       order by cnt desc limit 1;

-- 4.1.2) How many times each customer purchased that most purchased or demand product.. 

-- use above query as subquery and retrive as many cols you want according to grouping..

select userid, count(userid) as purchased_cnt from sales 
      where product_id  = (select product_id
						   from sales
				           group by product_id
						   order by count(product_id) desc limit 1)
	group by userid;
     

-- 5) what is the favourite product for each customer ?

with cte as(
     select userid, product_id, count(product_id) as prod_cnt
     from sales
     where userid in (select distinct userid from sales)
	 group by userid, product_id
     order by userid, prod_cnt desc)
select x.userid, x.product_id, p.product_name, p.price from
(select c.*, 
       row_number() over(partition by userid) as  rnk from cte c) x join product p 
       on x.product_id = p.product_id
where x.rnk = 1;


-- 6) which item was first purchased by the each customer after they became a member ?

select * from sales order by userid, created_date;
select * from goldusers_signup;

with cte as(
select x.*, 
       rank() over(partition by x.userid order by x.created_date) as rnk from
(select s.userid, s.product_id, s.created_date, g.gold_signup_date 
       from sales s join goldusers_signup g 
       on s.userid = g.userid
       where s.created_date > g.gold_signup_date) x
)
select userid, product_id, created_date, gold_signup_date
       from cte
       where rnk = 1;
       
       
-- 7) which item was purchsed just before the customer became a member?

with cte as(
select x.*, 
       rank() over(partition by x.userid order by x.created_date desc) as rnk from
(select s.userid, s.product_id, s.created_date, g.gold_signup_date 
       from sales s join goldusers_signup g 
       on s.userid = g.userid
       where s.created_date < g.gold_signup_date) x
)
select userid, product_id, created_date, gold_signup_date
       from cte
       where rnk = 1;
       
-- 8) what is the total orders and amount spent for each member before they became a member?

with cte as(
select s.userid, count(s.product_id) as total_orders, sum(p.price) as total_amt_spend
       from sales s join goldusers_signup g on s.userid = g.userid
       join product p on p.product_id = s.product_id
       where s.created_date <= g.gold_signup_date
       group by s.userid)

select u.userid, case when cte.total_orders is not null then cte.total_orders else 0 end as total_orders_before_mem,
				 case when cte.total_amt_spend is not null then cte.total_amt_spend else 0 end as total_amt_spend_before_mem
                 from users u left join cte 
       on u.userid = cte.userid;
       

-- 9) If buying each product generates points 
--    for eg 5rs = 2 zomato point and each product has different purchasing points
--    for p1 5rs = 1 zomato point,
--    for p2 10rs = 5 zomato points (which means 2rs = 1 point)
--    for p3 5rs = 1 zomato point

-- problem statement :- calc points collected by each customer and for which product most points have been
-- given till now...

-- problem statement 1) :- points collected by each customer.....
-- required data sets...

select * from sales order by userid;
select * from product;
 
 select userid, sum(zomato_pnts) as total_pts_earned from 
 (select s.userid, s.product_id, sum(p.price) as total_amt_spend,
       case when s.product_id = 1 then round(sum(p.price) / 5, 0)
            when s.product_id = 2 then round((sum(p.price) / 10) * 5, 0)
            when s.product_id = 3 then round(sum(p.price) / 5, 0)
		end as zomato_pnts
	   from sales s join product p 
       on s.product_id = p.product_id
       group by s.userid, s.product_id
       order by s.userid) x
group by userid;
     

-- problem statement 2) :- The product that has been given most no.of zomato points till now

select * from sales order by userid;
select * from product;

select x.* from
(select s.product_id, sum(p.price) as total_revenue_generated,
        case when s.product_id = 1 then round(sum(p.price) / 5, 0)
            when s.product_id = 2 then round((sum(p.price) / 10) * 5, 0)
            when s.product_id = 3 then round(sum(p.price) / 5, 0)
		end as zomato_pnts
       from sales s join product p
       on s.product_id = p.product_id
       group by s.product_id
       order by zomato_pnts desc) x
limit 1;


-- 10) In the first one year after a customer joins the gold program (including their join date) irrespective 
-- of what the customer has purchased, they earn 5 zomato points for every 10 rs spent, who earned more 
-- and what was their points earnings in their first year after golden singnup ?

-- required data sets 

select * from sales order by userid;
select * from goldusers_signup;
select * from product;

 select x.* from
 (select s.userid, sum(p.price) as total_amt_spend,
       round(sum(p.price) / 2, 0) as zomato_points
       from sales s join product p on s.product_id = p.product_id
       join goldusers_signup g on g.userid = s.userid 
       where s.created_date between g.gold_signup_date and adddate(g.gold_signup_date, interval 1 year)
       group by s.userid
       order by zomato_points desc) x
limit 1;


-- 11) Rank all the transactions of the customer ?

select * from sales;

select userid, created_date, product_id,
       rank() over(partition by userid order by created_date) as rnk
       from sales;
  
-- 12) Rank all the transaction for each customer whenever they were a zomato gold member
-- for every non gold member transation mark as "na"

-- required datasets are :-

select * from sales; 
select * from goldusers_signup;
select * from users;

select x.userid, x.created_date, 
       case when x.gold_signup_date is not null then
		    dense_rank() over(partition by userid order by x.created_date desc) 
            else "n/a"
	  end as rnk from
(select s.userid, s.created_date, s.product_id, g.gold_signup_date
       from sales s left join goldusers_signup g 
       on s.userid = g.userid and s.created_date > g.gold_signup_date  
       order by s.userid) x;
 
       



    
       
