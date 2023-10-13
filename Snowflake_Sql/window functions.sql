CREATE OR REPLACE TABLE EMPLOYEE

(

   EMPID INTEGER NOT NULL PRIMARY KEY,

   EMP_NAME VARCHAR2(20),

   JOB_ROLE STRING,

   SALARY NUMBER(10,2)

);


INSERT INTO EMPLOYEE

VALUES('101','ANAND JHA','Analyst',50000);


INSERT INTO EMPLOYEE

VALUES(102,'ALex', 'Data Enginner',60000);


INSERT INTO EMPLOYEE

VALUES(103,'Ravi', 'Data Scientist',48000);


INSERT INTO EMPLOYEE

VALUES(104,'Peter', 'Analyst',98000);


INSERT INTO EMPLOYEE

VALUES(105,'Pulkit', 'Data Scientist',72000);


INSERT INTO EMPLOYEE

VALUES(106,'Robert','Analyst',100000);


INSERT INTO EMPLOYEE

VALUES(107,'Rishabh','Data Engineer',67000);


INSERT INTO EMPLOYEE

VALUES(108,'Subhash','Manager',148000);


INSERT INTO EMPLOYEE

VALUES(109,'Michaeal','Manager',213000);


INSERT INTO EMPLOYEE

VALUES(110,'Dhruv','Data Scientist',89000);


INSERT INTO EMPLOYEE

VALUES(111,'Amit Sharma','Analyst',72000);


DELETE FROM EMPLOYEE WHERE EMPID = 110;


SELECT * FROM EMPLOYEE;


update employee set job_role='Data Engineer'

where empid=102;


update employee set salary= 50000

where empid=104;


-------------------------------------------------------------WINDOW FUNCTIONS------------------------------------------------------------


-- SYNTAX : window_function_name(<exprsn>) OVER (<partition_by_clause> <order_clause>)
--- display total salary based on job profile

SELECT JOB_ROLE,SUM(SALARY) FROM EMPLOYEE

GROUP BY 1

ORDER BY 2 DESC;


-- display total salary along with all the records ()every row value

SELECT * , SUM(SALARY) OVER() AS TOT_SALARY,

ROUND(SALARY / TOT_SALARY * 100,2) AS PERC_CONTRIBUTION

FROM EMPLOYEE

ORDER BY PERC_CONTRIBUTION DESC;


-- display the MAX salary per job category for all the rows

SELECT *,

MAX(SALARY) OVER(PARTITION BY JOB_ROLE) AS MAX_JOB_SAL,

MIN(SALARY) OVER(PARTITION BY JOB_ROLE) AS MIN_JOB_SAL,

ROUND(SALARY / MAX_JOB_SAL * 100,2) AS MAX_PERC_CONTRIBUTION_JOB_ROLE,

ROUND(SALARY / MIN_JOB_SAL * 100,2) AS MIN_PERC_CONTRIBUTION_JOB_ROLE

FROM EMPLOYEE;

--ORDER BY PERC_CONTRIBUTION_JOB_ROLE DESC;


select *,max(salary) over(partition by JOB_ROLE) as MAX_SAL ,

min(salary) over(partition by JOB_ROLE) as MIN_SAL,

SUM(salary) over(partition by JOB_ROLE) as TOT_SAL

from Employee;




--ARRANGING ROWS WITHIN EACH PARTITION BASED ON SALARY IN DESC ORDDER

select *,max(salary) over(partition by JOB_ROLE ORDER BY SALARY DESC) as MAX_SAL ,

min(salary) over(partition by JOB_ROLE ORDER BY SALARY DESC) as MIN_SAL,

SUM(salary) over(partition by JOB_ROLE) as TOT_SAL

from Employee;


-- ROW_NUMBER() It assigns a unique sequential number to each row of the table ...

SELECT * FROM

(

SELECT *,ROW_NUMBER() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY DESC) AS PART_ROW_NUM

FROM EMPLOYEE

)

WHERE PART_ROW_NUM <=2;


/* The RANK() window function, as the name suggests, ranks the rows within their partition based on the given condition.

   In the case of ROW_NUMBER(), we have a sequential number.

   On the other hand, in the case of RANK(), we have the same rank for rows with the same value.

But there is a problem here. Although rows with the same value are assigned the same rank, the subsequent rank skips the missing rank.

This wouldn’t give us the desired results if we had to return “top N distinct” values from a table.

Therefore we have a different function to resolve this issue. */


SELECT *,ROW_NUMBER() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY DESC) AS ROW_NUM ,

RANK() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY DESC) AS RANK_ROW

FROM EMPLOYEE;


/* The DENSE_RANK() function is similar to the RANK() except for one difference, it doesn’t skip any ranks when ranking rows

Here, all the ranks are distinct and sequentially increasing within each partition.

As compared to the RANK() function, it has not skipped any rank within a partition. */


SELECT * FROM

(

SELECT *,ROW_NUMBER() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY) AS ROW_NUM ,

RANK() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY) AS RANK_ROW,

DENSE_RANK() OVER(PARTITION BY JOB_ROLE ORDER BY SALARY) AS DENSE_RANK_ROW

FROM EMPLOYEE  

)

WHERE DENSE_RANK_ROW <=2;



USE DATABASE DEMO_DATABASE;

DROP TABLE TOP_SCORERS;

--another way to insert data
CREATE OR REPLACE TABLE TOP_SCORERS AS
SELECT
 'James Harden' AS player,
 2335 AS points,
 2020 AS season
UNION ALL
(SELECT
 'Damian Lillard' AS player,
 1978 AS points,
 2020 AS season)
UNION ALL
(SELECT
 'Devin Booker' AS player,
 1863 AS points,
 2020 AS season)
UNION ALL
(SELECT
 'James Harden' AS player,
 2818 AS points,
 2019 AS season)
UNION ALL
(SELECT
 'Paul George' AS player,
 1978 AS points,
 2019 AS season)
UNION ALL
(SELECT
 'Kemba Walker' AS player,
 2102 AS points,
 2019 AS season)
UNION ALL
(SELECT
 'Damian Lillard' AS player,
 2067 AS points,
 2019 AS season)
UNION ALL
( SELECT
'Richard Bartner' AS player,
 2067 AS points,
 2019 AS season)
UNION ALL
(SELECT
 'Devin Booker' AS player,
 1700 AS points,
 2019 AS season)
UNION ALL
(SELECT
 'Paul George' AS player,
 1033 AS points,
 2020 AS season)
UNION ALL
(SELECT
 'Kemba Walker' AS player,
 1145 AS points,
 2020 AS season)
UNION ALL
(SELECT
 'Adam Gilchrist' AS player,
 1145 AS points,
 2020 AS season);
 

SELECT * FROM TOP_SCORERS ORDER BY SEASON;

SELECT distinct season FROM TOP_SCORERS;

SELECT SEASON,
MAX(POINTS) AS MAXM_PNTS,
MIN(POINTS) AS MIMN_PNTS
FROM TOP_SCORERS
GROUP BY 1
ORDER BY 1;
--MAXM PNTS - 2,818 MINM PNTS - 1700 -- 2019
 --MAXM PNTS - 2,335 MINM PNTS - 1033 - 2020
 

DESCRIBE TABLE AJ_WINDOW_DEMO;
---YEAR-OVER-YEAR CHANGE
SELECT DISTINCT
 player,
 FIRST_VALUE(POINTS) OVER (ORDER BY SEASON DESC) AS first_season_2019, -- 2019
 LAST_VALUE(POINTS) OVER (ORDER BY SEASON DESC) AS last_season_2020, --20209
 ((last_season_2020 - first_season_2019) / first_season_2019) * 100 AS PER_CHANGE
 --(100 * ((LAST_VALUE(points) OVER (PARTITION BY player ORDER BY season ASC) -
FIRST_VALUE(points) OVER (PARTITION BY player ORDER BY season ASC)) / FIRST_VALUE(points)
OVER (PARTITION BY player ORDER BY season ASC))) AS per_change
FROM
 TOP_SCORERS
ORDER BY 1;

SELECT DISTINCT
 player,
 FIRST_VALUE(POINTS) OVER (PARTITION BY PLAYER ORDER BY SEASON ) AS first_season,
 LAST_VALUE(POINTS) OVER (PARTITION BY PLAYER ORDER BY SEASON ) AS last_season
FROM TOP_SCORERS
ORDER BY 1;

--We used FIRST_VALUE and LAST_VALUE to find the scores for each player in the
--earliest and most recent seasons of data.
-- Then we computed the percent difference using:
-- 100 * ((new value - old value) / old value) per_difference
--- How to get top 3 results for each group?

SELECT
 season,
 ROW_NUMBER() OVER (PARTITION BY season ORDER BY points DESC) AS
ROW_NUMBER_points_rank,
 RANK() OVER (PARTITION BY season ORDER BY points DESC) AS RANK_points_rank,
 DENSE_RANK() OVER (PARTITION BY season ORDER BY points DESC) AS
DENSE_RANK_points_rank,
 player,
 points
FROM
TOP_SCORERS;


--153 ms - row_number
--179 ms - rank
-- 132 ms - dense_rank
SELECT
 season,
 --ROW_NUMBER() OVER (PARTITION BY season ORDER BY points DESC) AS
ROW_NUMBER_points_rank,
 --RANK() OVER (PARTITION BY season ORDER BY points DESC) AS RANK_points_rank,
 DENSE_RANK() OVER (PARTITION BY season ORDER BY points DESC) AS
DENSE_RANK_points_rank,
 player,
 points
FROM
TOP_SCORERS;


SELECT
 *
FROM
 (
 SELECT
 season,
 ROW_NUMBER() OVER (PARTITION BY season ORDER BY points DESC) AS
ROW_NUMBER_points_rank,
 RANK() OVER (PARTITION BY season ORDER BY points DESC) AS RANK_points_rank,
 DENSE_RANK() OVER (PARTITION BY season ORDER BY points DESC) AS
DENSE_RANK_points_rank,
 player,
 points
 FROM
 TOP_SCORERS
 )
WHERE
 (points_rank <= 3);

 
-- In this example, we used RANK to rank each player by points over each season.
-- Then we used a subquery to then return only the top 3 ranked players for each season.
-- How to find a running total?
select
 season,
 player,
 points,
 --SUM( <expr1> ) OVER ( [ PARTITION BY <expr2> ] [ ORDER BY <expr3> [ ASC | DESC ] [
<window_frame> ] ] )
 SUM(top_scorers.points) OVER (PARTITION BY player ORDER BY season ASC) AS
running_total_points
FROM
 TOP_SCORERS
ORDER BY PLAYER ASC, SEASON ASC;

--To find the running total simply use SUM with an OVER clause where you specify your groupings
--(PARTITION BY),
-- and the order in which to add them (ORDER BY).