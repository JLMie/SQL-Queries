
SELECT*
FROM Trial.dbo.[01Portfolio];

SELECT*
FROM Trial.dbo.t201Portfolio;

SELECT*
FROM Trial.dbo.t301Portfolio;

--All the Excel csv files used on this web are available at the end of the page, The entire content of those files are fictious. 
--The main database "01Portfolio", was created by myself on KNIME software for my master's thesis. All the tables are versions from
--the main one.

-- Exploration
-- See just the "x" first columns. When we have a huge databse it take time to load the entire table, so if we use the following query
-- the software will be displayed so much faster, and you dont need to see all rows and all variables. You will realise about it if that database
-- is the one you want to work with there is no need to wait until the software displayed. 
-- Mencionar todas las funciones que he dao pero que no se expoene aquí por el ir al grano como DROP, DELETE, ALIASING, UPDATE, 
-- Poner en el portfolio lo que más llame la atención. 

SELECT TOP 100 *
FROM Trial.dbo.[01Portfolio];

--Exercise 2.
--How many departments do we have? This is a really simple question but maybe in our databases there is one old, maybe a new one 
--had been not added, or maybe there are on duplicate because in the database we are working with we have a department 
--HR and human. Resource.

SELECT DISTINCT (Department)
FROM Trial.dbo.[01Portfolio];

SELECT DISTINCT (Position)
FROM Trial.dbo.[01Portfolio];

-- Checking the same issue in position. Actually, it's easier commit a mistake in this variable. 
-- How many positions are?

SELECT DISTINCT (Position)
FROM Trial.dbo.[01Portfolio];

-- How many differents Base anual salary are? Just the number, we dont need to know all names. 
SELECT COUNT (DISTINCT Base_anual_salary) 
FROM Trial.dbo.[01Portfolio];

-- Which are they?
SELECT DISTINCT (Base_anual_salary)
FROM Trial.dbo.[01Portfolio];

-- Rename the column count. To refer to this data properly. 
SELECT COUNT (DISTINCT Base_anual_salary) AS BaseAnualSalaryCount
FROM Trial.dbo.[01Portfolio];

--#Pending how to remove until get just two decimal number. 

--What is the average performance score in maximum, minimun, Total anual salary after tax in Technical support A position with Performance score over the average?

SELECT AVG (Performance)
FROM Trial.dbo.[01Portfolio]
WHERE Position = 'Technical support A' AND Department = 'Sales';

SELECT MAX (Total_anual_salary)
FROM Trial.dbo.[01Portfolio]
WHERE Position = 'Technical support A' AND Performance > 42;

SELECT MIN (Total_anual_salary)
FROM Trial.dbo.[01Portfolio]
WHERE Position = 'Technical support A' AND Performance > 42;

SELECT AVG (Performance)
FROM Trial.dbo.[01Portfolio]

-- Exploration.
-- Double where, I mean with two or more conditions. Where Engineer R&D and where they are women with salary. 

-- Position row is named pos_gender due to this database is come from the database I created to mesure a wage gap

-- All the employees in a Engineer R&D Position.

SELECT * 
FROM Trial.dbo.[01Portfolio]
WHERE Position = 'Commercial sales';

--All the employees except employees in a "x" Position. Production Position in this case.

SELECT * 
FROM Trial.dbo.[01Portfolio]
WHERE Department <> 'Production';

--All male employees and older 30. Two conditions needed to output. All male employees and they must be 30 or over 30 years old. 
SELECT * 
FROM Trial.dbo.[01Portfolio]
WHERE Age >= 30 AND Gender= 'Man';

--All employees under 30 or in a Manager C position. We are asking two conditions. One of those conditions are enough to obtein an output.
SELECT * 
FROM Trial.dbo.[01Portfolio]
WHERE Age < 30 OR Position = 'Manager C';

-- We have on our database two position with A, B and C range. So if we need to display both position but just 
-- look at the A range we can use this query.

SELECT * 
FROM Trial.dbo.[01Portfolio]
WHERE Pos_gender LIKE '%A';

-- If we need explore data with no NULL interaction values. 
SELECT* 
FROM Trial.dbo.[01Portfolio]
WHERE Position is NOT NULL;

-- When we need have a look to two or more values in a variable but not all of them.
SELECT* 
FROM Trial.dbo.[01Portfolio]
WHERE Position IN ('Manager B', 'Manager C', 'Administrative');

SELECT* 
FROM Trial.dbo.[01Portfolio]
WHERE Department IN ('IT', 'Production');

-- Here we can see two especific values for different variables and just one of them is a condition to display an output. 
SELECT*
FROM Trial.dbo.[01Portfolio]
WHERE Position = 'Manager B' OR Department = 'Production';

--Counting how many employees work remotely.
SELECT Work_remotely, COUNT (Work_remotely)
FROM Trial.dbo.[01Portfolio]
GROUP BY Work_remotely;

--How many positions in the database are recorded?
SELECT DISTINCT (Position)
FROM Trial.dbo.[01Portfolio] 
GROUP BY Position;

-- How many of those positions are on the database of each?
SELECT Position, COUNT(Position) AS Count_position
FROM Trial.dbo.[01Portfolio]
GROUP BY Position;

--How many employees are in each position divided by Gender?
--The following table shows how many men and women are in all positions in the company over 33 years old sorted in descending order.

SELECT Gender, Position,COUNT(Position) AS Count_Position
FROM Trial.dbo.[01Portfolio]
GROUP BY Gender, Position
ORDER BY Gender, Position DESC;

--A second and third databases are needed to apply the following queries considering those queries join at least two tables. 
--The second database name is t201Portfolio and the third one . In the following query you can display the entire tab. 

SELECT*
FROM Trial.dbo.t301Portfolio

-- Is not commun having an unique database with all data we need to explore and work with. 
-- Usually we need to join two or more tables to get the output we need. As the same time, sometimes everything
-- we need is add a section from another table to the table we are using.
                                           
-- INNER JOIN
-- Join by default include INNER, I will type it to make easier the reading.
-- An INNER JOIN shows everything that is commun or overlapping between Table A and Table B.

SELECT*
FROM Trial.dbo.[01Portfolio]
INNER Join Trial.dbo.t201Portfolio
ON Trial.dbo.[01Portfolio].ID = Trial.dbo.t201Portfolio.ID

--A FULL Inner Join shows everything from tables A and B regardless of whether it has a match based on what we were joining them on.
--Even if table A has an employee ID but there is no employee ID in table B; the function will still show it and vice versa.


-- In the following table as an output we see the age avarege on Production Department between employees 
-- with a score higher than "0.5".
-- This time I need to show the Satisfaction Level score. However, that data is not in the main database I am working with "[01Portfolio]". 
-- There are more data from the employees on "t301Portfolio" as Worklife_Balance, Avg_monthly_hours, Last_evaluation, Satisfaction_level, etc.
-- Let's use JOIN to match just the columns we need to display the information we require.

-- After running the following lines, we get the average age of employees who score more than 0.5 in Satisfaction 
-- in the 'Production Department'.

SELECT Department, AVG(Age) AS AgeAvg
FROM Trial.dbo.[01Portfolio]
INNER Join Trial.dbo.t301Portfolio
     ON Trial.dbo.[01Portfolio].ID = Trial.dbo.t301Portfolio.ID
WHERE Satisfaction_level > '0.50' AND Department = 'Production'
GROUP BY Department;                                           

-- FULL OUTER JOIN
-- The FULL OUTER JOIN keyword returns all records when there is a match in left [01Portfolio] or right t201Portfolio table records.

SELECT*
FROM Trial.dbo.[01Portfolio]
FULL Outer Join Trial.dbo.t201Portfolio
ON Trial.dbo.[01Portfolio].ID = Trial.dbo.t201Portfolio.ID

--So, we will look at everything in the 01Portfolio table regardless of wheter or not it has a match on
--the employee IDs from both tables.

-- LEFT OUTER JOIN 
-- The LEFT JOIN keyword returns all records from the left table (table1), and the matching records
-- from the right table (table2). The result is 0 records from the right side, if there is no match.

SELECT*
FROM Trial.dbo.[01Portfolio]
Left Outer Join Trial.dbo.t201Portfolio
ON Trial.dbo.[01Portfolio].ID = Trial.dbo.t201Portfolio.ID

-- RIGHT OUTER JOIN
-- The RIGHT JOIN keyword returns all records from the right table (table2), and the matching records 
-- from the left table (table1). The result is 0 records from the left side, if there is no match.

SELECT*
FROM Trial.dbo.[01Portfolio]
Right Outer Join Trial.dbo.t201Portfolio
ON Trial.dbo.[01Portfolio].ID = Trial.dbo.t201Portfolio.ID

--Select exactly what columns we need in the output. We have to specify from which table we want the values in case there
--are two with the same name. 

-- CASE STATEMENT, use Cases. 
-- A Case Statement allows you to specify a condition and then it also allows you to specify what you want returned 
-- when that condition is met.

-- Let's see how is works on our database.
-- Who shows attrition having a high performance score? 
-- To maximaze this query, rename the column (No column name).
-- Group BY 

SELECT ID, Age, Department, Attrition, PerformanceRating, 
JobSatisfaction, WorkLifeBalance, EnvironmentSatisfaction, 
CASE
  WHEN PerformanceRating >3 THEN 'High Performance' 
  ELSE 'None'
  END AS New_Attrition_filter
FROM Trial.dbo.t201Portfolio
ORDER BY PerformanceRating;

-- HAVING Clause
-- The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions. For instance, a condition. 
-- How is the distribution of Salary for each position? Sorted in descending order.

SELECT Department, Pos_gender, COUNT(Pos_gender) AS Number_position, AVG(Total_anual_salary) AS Average_Total_anual_salary
FROM Trial.dbo.[01Portfolio]
GROUP BY Pos_gender, Department
HAVING COUNT (Pos_gender) > 100
ORDER BY AVG(Total_anual_salary) DESC

-- PARTITION BY.
-- Whereas "PARTITION BY" actually divides the result set into partitions and changes how 
-- the window function is calculated and it doesn't reduce the number of 
-- rows returned in our output.

SELECT Department, Pos_gender, work_remotely, Performance, Engagement, Promotion_last_5years
, COUNT(Gender) OVER (PARTITION BY Gender ) as G
FROM Trial.dbo.[01Portfolio] AS t1p
JOIN Trial.dbo.t301Portfolio AS t3p
     ON t1p.ID = t3p.ID

--  GROUP BY. 
--  The GROUP BY statement groups rows that have the same values into summary rows.
--¿How many employees are working remotely?

SELECT Department, Work_remotely, COUNT(Work_remotely) AS Count_remotely
FROM Trial.dbo.[01Portfolio]
WHERE Work_remotely = '0' 
GROUP BY Department, Work_remotely
ORDER BY Work_remotely

--SUBSTRING.

--When we don't need the entire name to select what we are looking for.
--Fuzzy match. One just came to me, if you want to select all the manager without specifying A, B, or C. 
--Let's see the seniority in the company of all Manager, doesn't matter if they have A,B,C or even another connotation. 

SELECT ID, Seniority_in_the_company, SUBSTRING (Position,1,8)
FROM Trial.dbo.[01Portfolio]
WHERE Position LIKE 'Manager%'

-- STORED PROCEDURES.

--The list is showed in my object explorer is not the same than the video one. On mine I can't see where the procedure is. 
-- Remember; "0" means Yes. 

CREATE PROCEDURE Employee_remotely_by_department1
AS
SELECT Department, Work_remotely, COUNT(Work_remotely) AS Count_remotely
FROM Trial.dbo.[01Portfolio]
WHERE Work_remotely = '0' 
GROUP BY Department, Work_remotely
ORDER BY Work_remotely;

-- After run those lines above. Just we need to type the following query and the output will be displayed. 
-- The output show us how many employees work remotly for each department.

EXEC Employee_remotely_by_department1

-- If we need to see in a particular Department as 'Sales' both results. 

ALTER PROCEDURE Employee_remotely_by_department
@Department nvarchar(100)
AS
SELECT Department, Work_remotely, COUNT(Work_remotely) AS Count_remotely
FROM Trial.dbo.[01Portfolio]
WHERE Work_remotely = '0' OR Department = @Department 
GROUP BY Department, Work_remotely
ORDER BY Department;

EXEC Employee_remotely_by_department @Department = 'Sales'

--SUBQUERIES.
--Consulting the Performance score of each employee and comparing with the Avg. 
SELECT ID, Performance, (Select AVG (Performance) From Trial.dbo.[01Portfolio]) AS allAvgPerformance
FROM Trial.dbo.[01Portfolio]

Like this can I filter a column from another table 
--without display that table?

SELECT*
FROM Trial.dbo.[01Portfolio]

SELECT*
FROM Trial.dbo.t201Portfolio

--In databse 01Portfolo we have just DOB (Date of Birth) but in t201Portfolio we have the age already calculated. 
--We need data (Age) from t201Portfolio to relate it with variables we have in the main dataset Trial.dbo.[01Portfolio].
--This query allow us see all Performance score from employees over 30 years old. 

SELECT ID, Performance, Position
FROM Trial.dbo.[01Portfolio]
WHERE ID in (
         Select ID
		 From  Trial.dbo.t201Portfolio
		 Where Age<30)
