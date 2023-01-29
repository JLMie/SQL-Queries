
-- Creating a Table with errors on the values and strings. Let's fix it!

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

SELECT*
FROM Errorstablefix
-- We can see 3 error type.  

-- Spaces is a wrong place. 
SELECT EmployeeID, TRIM(EmployeeID) AS IDfixed
FROM Errorstablefix

-- An xtra string we dont need. ("-Updated")
Select Position, REPLACE(Position, '-',' ') AS PositionFixed
FROM Errorstablefix

-- A misspelled word. (Naintenance)
Select Department, REPLACE(Department, 'Naintenance','Maintenance') AS PositionFixed
FROM Errorstablefix

-- Double Uppercase. (MArketing)
SELECT Department, UPPER(LEFT(Department, 1)) + SUBSTRING(Department, 2, len(Department)) as FixDepartmentName
FROM Errorstablefix

-- Let's come back to the database used for cleaninng section.
-- Identifing where NULL values are to start have a look at empty gaps. 
-- Assumption: We already know that some data in Education field from OldEmployee are missing and we need to ask for those data to
-- complete a new dataset.

SELECT*
FROM Trial.dbo.CleaningdataPort
WHERE EducationField is null
ORDER BY OldEmployee_ID

SELECT*
FROM Trial.dbo.CleaningdataPort
-- On the table, we see a long address in a one single field. We need to use the Eircode and the town name but, 
-- We dont want to remove the data left. So, break out Address into three separate in columns.
-- 1. EirCode/Postcode
-- 2. Region
-- 3. Country

SELECT 
PARSENAME(REPLACE(Emp_Address, ',','.'),4) AS 'Eir/post Code'
,PARSENAME(REPLACE(Emp_Address, ',','.'),3) AS 'Town'
,PARSENAME(REPLACE(Emp_Address, ',','.'),2) AS 'County/Region'
,PARSENAME(REPLACE(Emp_Address, ',','.'),1) AS 'Country'
FROM Trial.dbo.CleaningdataPort;



SELECT
FROM Trial.dbo.CleaningdataPort

--Now try to keep what is displayed as a change in the table.








--2 VERSION. Replacing commas for points just in 2/3 to see the differents, like this PARSAME function should work without REPLACE.......


--3 version
--Change Y and N to Yes and No in "Sold as Vacant" field. 


SELECT DISTINCT (Work_remotely), Count (Work_remotely)
FROM Trial.dbo.CleaningdataPort
GROUP BY Work_remotely


SELECT Work_remotely
, CASE WHEN Work_remotely = 'Yes' THEN 'Y'
       WHEN Work_remotely = 'No'  THEN 'N'
	   END
FROM Trial.dbo.CleaningdataPort

SELECT Work_remotely, COUNT (Work_remotely)
FROM Trial.dbo.[01Portfolio]
GROUP BY Work_remotely;

--#PENDING Make more sense having different answer (Y, N, O and 1) and unify them as Yes and No.
--Remove duplicates. DOES NOT WORK WITH THE "WITH LINE" (773)

WITH RowNumCTE AS(
SELECT *,
     ROW_NUMBER() OVER(
	 PARTITION BY OldEmployee_ID, 
	              Kids, 
	              HireDate, 
				  Satisfaction_level 
				  ORDER BY
				    Employee_ID
				       ) row_num

FROM Trial.dbo.CleaningdataPort


WITH RowNumCTEE AS(
SELECT *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID, 
	              PropertyAddress, 
	              SalePrice,
				  SaleDate,
				  LegalReference 
				  ORDER BY
				    UniqueID
				       ) row_num
FROM Trial.dbo.Nashville
--ORDER BY ParcelID
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Delete Unused Columns.

SELECT*
FROM Trial.dbo.CleaningdataPort

ALTER TABLE Trial.dbo.CleaningdataPort
DROP COLUMN Kids, Emp_Address2

EXEC master.sys.sp_MSset_oledb_prop;

