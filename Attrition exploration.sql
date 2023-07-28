-- Total employees Attrition Yes/No.
SELECT COUNT(*) AS total_employees_yes
FROM  mid_proyect
WHERE Attrition = 'Yes';

SELECT COUNT(*) AS total_employees_yes
FROM  mid_proyect
WHERE Attrition = 'No';
-- YES: 233  NO: 1233


-- Total of employees per Department, counting employees with Attrition "Yes" and percentage of employees with a value of "Yes" in the "Attrition" column for each department over all employees in the department.
-- Group JobRoles by Department.
SELECT Department, GROUP_CONCAT(DISTINCT JobRole ORDER BY JobRole) AS JobRoles
FROM mid_proyect
GROUP BY Department;
# "GROUP_CONCAT" to concatenate all distinct JobRoles within each department into a single string.
#  DISTINCT to eliminate the duplicates, 

--  % of employees represents each department in order to the total employees.
SELECT Department,
COUNT(*) AS Employee_Count,
(COUNT(*) / (SELECT COUNT(*) FROM mid_proyect)) * 100 AS Percentage
FROM mid_proyect
GROUP BY Department;

SELECT Department,
COUNT(*) AS Employee_Count,
(COUNT(*) / (SELECT COUNT(*) FROM mid_proyect)) * 100 AS Percentage
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY Department;

-- Amount of employees with value Yes in Attrition by JobRole and the % they represent in their JobRole.

SELECT JobRole,
COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS Attrition_Count,
(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS Attrition_Percentage
FROM mid_proyect
GROUP BY JobRole ORDER BY Attrition_Percentage DESC;


-- NOW THE VARIABLES WITH P.VALUE < 0.05 (APPLYING CHI2) 

# 1º Lowest person value. OVERTIME
-- How many Attrition employees had OverTime? 127/233
SELECT COUNT(*) AS total_employees
FROM mid_proyect
WHERE Attrition = 'Yes' AND Overtime = 'Yes';

# 2º Lowest person value. JOBROLE. We saw the data above already.


# 3º Lowest person value.BUSINESSTRAVEL
-- Which is the most repeated value in BusinessTravel? Travel_Rarely, 156/233, Travel_Frequently, 69/233
SELECT BusinessTravel, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY BusinessTravel
ORDER BY count DESC;

# 4º Lowest person value. MARITALSTATUS.
-- Which is the most repeated value in MaritalStatus? Single, 120/233, Married, 84/233
SELECT MaritalStatus, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY MaritalStatus
ORDER BY count DESC;

# 5º lowest person value. and the last one with score <0.05. Life Science 89/233, Medical 63/233, Marketing 35/233.

SELECT EducationField, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY EducationField
ORDER BY count DESC;

-- NOW CUANTITATIVE VARIABLES. 

                -- WORKLIFEBALANCE--
-- Which is the most repeated value in "WorklifeBalance" on employees who left? [3] 127/233
SELECT WorklifeBalance, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY WorklifeBalance
ORDER BY count DESC
LIMIT 4;
				     -- AGE --
-- Which are the most repeated Age on employees who left? 116/233 are between 26 and 35. IN the graph we will see is that is significative because maybe the distribution is normal as the age of all employees. 
SELECT Age, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY Age
ORDER BY count DESC
LIMIT 20;

SELECT Age, COUNT(*) AS count #116
FROM mid_proyect
WHERE Attrition = 'Yes' AND Age BETWEEN 26 AND 35
GROUP BY Age
ORDER BY count DESC;

SELECT Age, COUNT(*) AS count #116
FROM mid_proyect
WHERE Attrition = 'Yes' AND Age BETWEEN 28 AND 33
GROUP BY Age
ORDER BY count DESC;


SELECT COUNT(*) AS total_count
FROM mid_proyect
WHERE Attrition = 'Yes' AND Age BETWEEN 26 AND 35;

		   --  YearsInCurrentRole --
-- Which is the most repeated value in "YearsInCurrentRole" on employees who left? [0, 73], [2,68]
SELECT YearsInCurrentRole, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY YearsInCurrentRole
ORDER BY count DESC;

			-- YearswithCurrManager --
-- Which is the most repeated value in "YearsInCurrentManager" on employees who left? [0, 85], [2,50]
SELECT YearswithCurrManager, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY YearswithCurrManager
ORDER BY count DESC;

                     -- EnviormentSatisfaction -- 
-- Which is the most repeated value in "EnviormentSatisfaction" on employees who left? [1,72][2,43][3,62][4,60]  CURIOUS!! 
SELECT EnvironmentSatisfaction, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY EnvironmentSatisfaction
ORDER BY count DESC;

						-- JobInvolvement --  [1,72][4,60]
SELECT EnvironmentSatisfaction, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY EnvironmentSatisfaction
ORDER BY count DESC;

             -- JobLevel --    [1,143][2,52][3,32] #They are leaving!!
SELECT JobLevel, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY JobLevel
ORDER BY count DESC;

# JobLevel & JobRole
SELECT JobRole, JobLevel, COUNT(*) AS count
FROM mid_proyect
GROUP BY JobLevel, JobRole
ORDER BY JobLevel, JobRole;

SELECT JobLevel, GROUP_CONCAT(DISTINCT JobRole ORDER BY JobRole) AS JobRoles
FROM mid_proyect
GROUP BY JobLevel;

-- JobSatisfaction
SELECT JobSatisfaction, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction
ORDER BY count DESC;

-- "Relationship satisfaction"  [1, 57], [2, 45], [3,71], [4,64] #More employees claim have a good realtionship
SELECT RelationshipSatisfaction, COUNT(*) AS count
FROM mid_proyect
WHERE Attrition = 'Yes'
GROUP BY RelationshipSatisfaction
ORDER BY count DESC;


   -- PROFILE --  147 employees attrition match at least with this 3. 
SELECT *
FROM mid_proyect
WHERE 
    (Age BETWEEN 28 AND 33) +
    (EducationField IN ('Life Science', 'Medical')) +
    (YearsInCurrentRole IN (0, 2)) +
    (YearsWithCurrManager IN (0, 2)) +
    (OverTime = 'Yes') +
    (JobLevel IN (1, 2, 3))
    >= 2
    AND Attrition = 'Yes';


#Overview porcentajes attrition. 
#cómo se reparte la posición, rol y departamento. 
#Perfil.
#curioso. 
#Conclusiones and call to the action. 
