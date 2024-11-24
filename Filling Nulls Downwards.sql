-- Use the 'practice' database for executing queries
USE practice;

-- Create the 'brand' table with columns for category and brand_name
CREATE TABLE brand (
  category VARCHAR(20),     -- Category of the brand
  brand_name VARCHAR(20)    -- Name of the brand
);

-- Clear any existing data in the 'brand' table
TRUNCATE TABLE brand;

-- Insert sample data into the 'brand' table
-- Some 'category' values are intentionally NULL for this exercise
INSERT INTO brand VALUES
('chocolates', '5-star'),        -- '5-star' belongs to the 'chocolates' category
(NULL, 'dairy milk'),            -- 'dairy milk' category is missing
(NULL, 'perk'),                  -- 'perk' category is missing
(NULL, 'eclair'),                -- 'eclair' category is missing
('golden Biscuits', 'britannia'),-- 'britannia' belongs to 'golden Biscuits'
(NULL, 'good day'),              -- 'good day' category is missing
(NULL, 'boost');                 -- 'boost' category is missing

-- Display the initial data in the 'brand' table
SELECT * FROM brand;

-- Problem Statement: Clearly outlined the objective: propagating category values downward to fill NULLs.

-- Solution 1: Using a Common Table Expression (CTE) with window functions
-- This approach assigns a row number to each row and uses a MIN() window function
WITH cte1 AS (
  SELECT *, 
         ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn -- Assign a row number
  FROM brand
)
SELECT *,
       MIN(category) OVER (ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS filled_category
FROM cte1;

-- Solution 2: Simplified version of Solution 1
-- Uses MIN() window function directly over rows ordered by the row number
WITH temp AS (
  SELECT *, 
         ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn -- Assign a row number
  FROM brand
)
SELECT *,
       MIN(category) OVER (ORDER BY rn) AS filled_category -- Propagate non-NULL values downward
FROM temp;

-- Solution 3: Filling NULLs using cumulative sums and grouping
WITH cte1 AS (
  SELECT *,
         ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, -- Assign a row number
         CASE WHEN category IS NULL THEN 0 ELSE 1 END AS rn -- Mark non-NULL categories
  FROM brand
),
cte2 AS (
  SELECT *,
         SUM(rn) OVER (ORDER BY id) AS roll_sum -- Generate a cumulative group identifier
  FROM cte1
)
SELECT brand_name,
       MAX(category) OVER (PARTITION BY roll_sum) AS filled_category -- Fill categories within each group
FROM cte2;

-- Solution 4: Filling NULLs using a cumulative sum approach with partitioning
WITH cte AS (
  SELECT *, 
         ROW_NUMBER() OVER () AS rowed -- Assign a row number
  FROM brand
),
cte2 AS (
  SELECT *,
         SUM(CASE WHEN category IS NOT NULL THEN 1 ELSE 0 END) OVER (ORDER BY rowed) AS grouped -- Group by non-NULL categories
  FROM cte
)
SELECT MAX(category) OVER (PARTITION BY grouped) AS filled_category, -- Fill categories within each group
       brand_name
FROM cte2;
