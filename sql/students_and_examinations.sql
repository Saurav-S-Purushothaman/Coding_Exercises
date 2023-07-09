-- Table: Students

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | student_name  | varchar |
-- +---------------+---------+
-- student_id is the primary key for this table.
-- Each row of this table contains the ID and the name of one student in the school.
 

-- Table: Subjects

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | subject_name | varchar |
-- +--------------+---------+
-- subject_name is the primary key for this table.
-- Each row of this table contains the name of one subject in the school.
 

-- Table: Examinations

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | student_id   | int     |
-- | subject_name | varchar |
-- +--------------+---------+
-- There is no primary key for this table. It may contain duplicates.
-- Each student from the Students table takes every course from the Subjects table.
-- Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

-- Find the number of times each student attended each exam.

-- Return the result table ordered by student_id and subject_name.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Students table:
-- +------------+--------------+
-- | student_id | student_name |
-- +------------+--------------+
-- | 1          | Alice        |
-- | 2          | Bob          |
-- | 13         | John         |
-- | 6          | Alex         |
-- +------------+--------------+
-- Subjects table:
-- +--------------+
-- | subject_name |
-- +--------------+
-- | Math         |
-- | Physics      |
-- | Programming  |
-- +--------------+
-- Examinations table:
-- +------------+--------------+
-- | student_id | subject_name |
-- +------------+--------------+
-- | 1          | Math         |
-- | 1          | Physics      |
-- | 1          | Programming  |
-- | 2          | Programming  |
-- | 1          | Physics      |
-- | 1          | Math         |
-- | 13         | Math         |
-- | 13         | Programming  |
-- | 13         | Physics      |
-- | 2          | Math         |
-- | 1          | Math         |
-- +------------+--------------+
-- Output: 
-- +------------+--------------+--------------+----------------+
-- | student_id | student_name | subject_name | attended_exams |
-- +------------+--------------+--------------+----------------+
-- | 1          | Alice        | Math         | 3              |
-- | 1          | Alice        | Physics      | 2              |
-- | 1          | Alice        | Programming  | 1              |
-- | 2          | Bob          | Math         | 1              |
-- | 2          | Bob          | Physics      | 0              |
-- | 2          | Bob          | Programming  | 1              |
-- | 6          | Alex         | Math         | 0              |
-- | 6          | Alex         | Physics      | 0              |
-- | 6          | Alex         | Programming  | 0              |
-- | 13         | John         | Math         | 1              |
-- | 13         | John         | Physics      | 1              |
-- | 13         | John         | Programming  | 1              |
-- +------------+--------------+--------------+----------------+
-- Explanation: 
-- The result table should contain all students and all subjects.
-- Alice attended the Math exam 3 times, the Physics exam 2 times, and the Programming exam 1 time.
-- Bob attended the Math exam 1 time, the Programming exam 1 time, and did not attend the Physics exam.
-- Alex did not attend any exams.
-- John attended the Math exam 1 time, the Physics exam 1 time, and the Programming exam 1 time.

# Write your MySQL query statement below

# first create the table with follwoing data - student id, student name, subject . 
# all the rows in this table should be unique 
# eg. data 1 alice math 
# join this table with examination table and put null value of student id not present in examination table 
# create aggregration in examination table - count no.of subjects attended for each combination of student_id, subject_name

WITH input_table AS (
  SELECT
    st.student_id,
    st.student_name,
    sb.subject_name
  FROM students st
  CROSS JOIN subjects sb
),
output_table AS (
  SELECT
    ex.student_id,
    st.student_name,
    ex.subject_name
  FROM Examinations ex
  INNER JOIN students st ON ex.student_id = st.student_id
)
SELECT distinct
  ip.student_id,
  ip.student_name,
  ip.subject_name,
  COUNT(op.subject_name) OVER (PARTITION BY ip.student_id, ip.subject_name) AS attended_exams
FROM input_table ip
LEFT OUTER JOIN output_table op ON ip.student_id = op.student_id AND ip.subject_name = op.subject_name AND ip.student_name = op.student_name
ORDER BY ip.student_id, ip.subject_name;


-- answer without window functions 
# select st.student_id, st.student_name, sb.subject_name , count(e.subject_name) as attended_exams
# from students st cross join subjects sb
# left outer join examinations e on e.student_id = st.student_id and e.subject_name = sb.subject_name 
# group by st.student_id, st.student_name,sb.subject_name
# order by 
# st.student_id, sb.subject_name; 



