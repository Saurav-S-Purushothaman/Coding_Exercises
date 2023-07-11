-- Table: Employee

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | name        | varchar |
-- | department  | varchar |
-- | managerId   | int     |
-- +-------------+---------+
-- id is the primary key column for this table.
-- Each row of this table indicates the name of an employee, their department, and the id of their manager.
-- If managerId is null, then the employee does not have a manager.
-- No employee will be the manager of themself.
 

-- Find the managers with at least five direct reports.

-- Return the result table in any order.

-- The result format is in the following example.


# NORMAL SOLUTION 
WITH first_table as (
SELECT 
  em.managerId, 
  count(em.managerId) cnt , em2.name
FROM 
  Employee em 
INNER JOIN Employee em2 ON em.managerId = em2.id
GROUP BY em.managerId
HAVING cnt >= 5)
SELECT
  name 
FROM first_table; 

# SOLUTION USING WINDOW FUNCTION.ALSO TRYING TO REMOVE SELF JOINS 
# SINCE SELF JOINS ARE EXPENSIVE 

WITH first_table AS (
  SELECT 
    id,
    managerId, 
    COUNT(*) OVER (PARTITION BY managerId) AS cnt,
    name
  FROM 
    Employee
)
SELECT 
  name
FROM 
  first_table
WHERE 
  id IN (
    SELECT 
      managerId
    FROM 
      first_table
    WHERE 
      cnt >= 5
  );