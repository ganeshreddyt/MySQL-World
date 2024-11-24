-- Set the number to be checked for primality
set @var = 61;  

-- Begin a recursive Common Table Expression (CTE)
with recursive cte as (
    -- Base case: Start with n = 1 and is_factor = 0
    select 1 as n, 0 as is_factor
    
    union
    
    -- Recursive case: Increment n by 1 and check if @var is divisible by n
    select n + 1, 
           if(@var % (n + 1) = 0, 1, 0) as is_factor  -- Check if n + 1 is a factor of @var
    from cte
    where n + 1 <= @var  -- Continue until n reaches @var
)
-- Final query to determine if @var is a prime number
select 
    if(sum(is_factor) = 2,  -- A prime number has exactly two factors: 1 and itself
       'prime number', 
       'not a prime number') as result
from cte;
