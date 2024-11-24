use practice;

-- drop table if exists
drop table transactions;

truncate table transactions;

create table transactions
(
account_no varchar(10),
trans_date date,
debit_credit varchar(10),
trans_amnt int
);

insert into transactions values
('acc_1', '2022-01-20', 'credit', 100),
('acc_1', '2022-01-23', 'credit', 400),
('acc_1', '2022-01-25', 'credit', 300),
('acc_1', '2022-01-29', 'credit', 200),
('acc_2', '2022-01-20', 'credit', 100),
('acc_2', '2022-01-23', 'credit', 1400),
('acc_2', '2022-01-25', 'debit', 1300),
('acc_3', '2022-01-29', 'credit', 1000),
('acc_4', '2022-01-23', 'credit', 1500),
('acc_4', '2022-01-25', 'debit', 700),
('acc_5', '2022-01-29', 'credit', 900),
('acc_5', '2022-01-30', 'credit', 350),
('acc_5', '2022-01-30', 'credit', 200); 

select * from transactions;

-- Problem Statement: Get the all accnt_no and trans_date whose and where accnt_bal is >= 1000

-- Sol -1 ===== Basically It's my idea =======

with cte as(
select *, sum(
             case when debit_credit = 'credit' then trans_amnt
             else -trans_amnt
             end) over(partition by account_no order by trans_date) as acnt_bal,
		   row_number() over(partition by account_no) as rn
from transactions),
cte2 as(
   select account_no, max(rn) as rn
   from cte
   group by 1
)
select c1.account_no, c1.trans_date, c1.acnt_bal 
from cte c1 join cte2 c2 
on c1.account_no = c2.account_no and c1.rn = c2.rn
where c1.acnt_bal >= 1000;


-- Sol -2  ======= touFIQ bayya's approach (I know unbounded preceding and following by this qs) tq bayya ===========

with cte as(
select *, sum(
             case when debit_credit = 'credit' then trans_amnt
             else -trans_amnt
             end) over(partition by account_no order by trans_date 
                       rows between unbounded preceding and unbounded following) as acnt_bal
from transactions)
select account_no, max(trans_date), acnt_bal as trans_date 
from cte
where acnt_bal >= 1000
group by 1, 3;

-- Sol -3: Idea we can do by subtracting 1000 from all the acnt_bal and fileter pos valus
-- this might also need same logic, but some cases like when acnt_bal is > 1000 for all times 
-- and if at the last trans debit results less than 1000....But Ok!... logic by some other commenter in that vdo








