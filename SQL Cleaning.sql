		   	  /* The entirety of the content within the files used throughout the entire portfolio is fictitious.*/
		          /* All of the Excel CSV files used to create this section are available in the Github repository. */
					          
       /* The aim of this project is to clean and standrized the data and make the dataset more usable and easier to observe it. */

                                         // CREATING A TABLE WITH MISTAKES AND FIXING 4 ERROR TYPES //

CREATE TABLE Errorstablefix (
EmployeeID varchar(50)
,Plus_per_h_overtime varchar(50)
,Department varchar(50)
,Position varchar(50)
)

Insert into Errorstablefix Values 
('801', '15', 'Naintenance', 'Technical support B')
,('802', '16','Production', 'Operator')
,('805', '19','MarkEting', 'Manager-Updated')

-- Here you can display the table.
SELECT*
FROM Errorstablefix

-- 1.Error: spaces is a wrong place. 
SELECT EmployeeID, TRIM(EmployeeID) AS IDfixed
FROM Errorstablefix

-- 2.Error: an xtra string we dont need. ("-Updated")
Select Position, REPLACE(Position, '-',' ') AS PositionFixed
FROM Errorstablefix

-- 3. Error: A misspelled word. (Naintenance)
Select Department, REPLACE(Department, 'Naintenance','Maintenance') AS PositionFixed
FROM Errorstablefix

-- 4.Error: Double Uppercase. (MArketing)
SELECT Department, UPPER(LEFT(Department, 1)) + SUBSTRING(Department, 2, len(Department)) as FixDepartmentName
FROM Errorstablefix


                                                      // DELETING UNUSED COULMNS //

SELECT*
FROM Trial.dbo.CleaningdataPort

ALTER TABLE Trial.dbo.CleaningdataPort
DROP COLUMN Kids, Emp_Address2


                                                   // POPULATING "EDUCATION FIELD" //

		/* We need a table without the same OldEmployeeID in two rows. However, looking at the values in their columns, 
values in EducationField are missing in one of those duplicate rows. So, EducationField needs to be added to the resultant row. */

						
-- Here, we discover EducationField is the one is missing in one row. 
SELECT*
FROM Trial.dbo.CleaningdataPort
WHERE EducationField is null
ORDER BY OldEmployee_ID

-- We need to join the table itself for removing OldEmployee_ID duplicates and merge the EducationField data are missing.
SELECT a.Employee_ID, a.EducationField, b.Employee_ID, b.EducationField
FROM Trial.dbo.CleaningdataPort a
JOIN Trial.dbo.CleaningdataPort b
     on a.OldEmployee_ID = b.OldEmployee_ID
	 AND a.[Employee_ID] <> b.[Employee_ID]
WHERE a.EducationField is null;

-- Let'apply the changes to the table.
UPDATE a
SET EducationField = ISNULL(a.EducationField, b.EducationField)
FROM Trial.dbo.CleaningdataPort a
JOIN Trial.dbo.CleaningdataPort b
     on a.OldEmployee_ID = b.OldEmployee_ID
	 AND a.[Employee_ID] <> b.[Employee_ID]
WHERE a.EducationField is null


                                                  // SPLITING "ADDRESS" IN DIFFERENT COLUMNS //

SELECT*
FROM Trial.dbo.CleaningdataPort

--Original format: T23,CORK CITY, CORK COUNTY, Country. 
SELECT 
PARSENAME(REPLACE(Emp_Address, ',','.'),4) AS 'Eir/post Code'
,PARSENAME(REPLACE(Emp_Address, ',','.'),3) AS 'Town'
,PARSENAME(REPLACE(Emp_Address, ',','.'),2) AS 'County/Region'
,PARSENAME(REPLACE(Emp_Address, ',','.'),1) AS 'Country'
FROM Trial.dbo.CleaningdataPort;


                                                  // OBTEIN MEANING FROM NUMBERS OUTCOME //

-- How many employees work remotely?
SELECT Work_remotely, COUNT (Work_remotely)
FROM Trial.dbo.[01Portfolio]
GROUP BY Work_remotely;

-- Let's clarify it replacing 0 and 1 for YES and NO respectively. 
SELECT Work_remotely, Employee_ID,
CASE WHEN Work_remotely = 0 THEN 'Yes'
	 ELSE 'No' END AS Work_remotely
FROM Trial.dbo.CleaningdataPort;


                                                        // REMOVING ALL DUPLICATES //

WITH RowNumCTE AS(
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY OldEmployee_ID, 
				  Position,
	              HireDate, 
				  Satisfaction_level 
				  ORDER BY
				    Employee_ID
				       ) row_num

FROM Trial.dbo.CleaningdataPort
)
SELECT* --In case a duplicate rows show up and we want delete them. 
--We would need to replace the previous 'SELECT' for 'DELETE' and remove as well the "*" before run it. 
FROM RowNumCTE
WHERE row_num > 2
ORDER BY Employee_ID

SELECT*
FROM Trial.dbo.CleaningdataPort


                                                        // EXPORTING THE TABLE //

-- Look at Object Explorer,  right click on de database logo -> Task -> Export data -> Next ->  Data source -> 
-- "SQL Server Native Client 11.0" -> Next -> Destination select Microsot Excel -> Next -> Browse -> Type file name ->
-- Open -> Next -> "Copy data from one or more tablets or views" -> Next -> Select the table -> Next -> Check the table 
-- Select error and click ignore -> On Truncation press ignore too -> Next -> Finish.

                                                          THANKS FOR VISITING!

                                           .   . ........ Continuing Learning ........ .   .
					  
					  
