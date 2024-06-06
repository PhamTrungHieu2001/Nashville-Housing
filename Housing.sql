-- VIEW DATA
SELECT * 
FROM     PortfolioProject.dbo.Housing

----------------------------------------------------------------------------------------------------------------
-- 1. STANDARDIZE DATE FORMAT
--  April 9, 2013 => 2013-04-09
 
ALTER TABLE PortfolioProject.dbo.Housing
ALTER COLUMN SaleDate DATE

SELECT SaleDate
FROM     PortfolioProject.dbo.Housing

----------------------------------------------------------------------------------------------------------------
-- 2. POPULATE PROPERTY ADDRESS DATA
-- Using self join to fill the address of properties that have the same ParcelID

UPDATE a
SET          a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM     PortfolioProject.dbo.Housing AS a INNER JOIN
                  PortfolioProject.dbo.Housing AS b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE  (a.PropertyAddress IS NULL)

SELECT ParcelID, PropertyAddress
FROM     PortfolioProject.dbo.Housing
WHERE  (PropertyAddress IS NULL)

----------------------------------------------------------------------------------------------------------------
-- 3. BREAKING ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

-- 3.1. Breaking 'PropertyAddress' into 'PropertySplitAddress' and 'PropertyCity' using SUBSTRING()
-- "1808  FOX CHASE DR, GOODLETTSVILLE" => "1808  FOX CHASE DR", "GOODLETTSVILLE"

-- Create new columns
ALTER TABLE PortfolioProject.dbo.Housing 
ADD PropertyCity NVARCHAR(255)

ALTER TABLE PortfolioProject.dbo.Housing 
ADD PropertySplitAddress NVARCHAR(255)

-- Add data to the new columns
UPDATE PortfolioProject.dbo.Housing
SET          PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

UPDATE PortfolioProject.dbo.Housing
SET          PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

-- 3.2. Breaking 'OwnerAddress' into 'OwnerSplitAddress', 'OwnerCity', and 'OwnerState' using PARSENAME()
-- "1808  FOX CHASE DR, GOODLETTSVILLE, TN" => "1808  FOX CHASE DR", "GOODLETTSVILLE", "TN"
 
-- Create new columns to save owners' address, city and state
ALTER TABLE PortfolioProject.dbo.Housing 
ADD OwnerSplitAddress NVARCHAR(255)

ALTER TABLE PortfolioProject.dbo.Housing 
ADD OwnerCity NVARCHAR(255)

ALTER TABLE PortfolioProject.dbo.Housing 
ADD OwnerState NVARCHAR(255)

-- Add data to the new columns
UPDATE PortfolioProject.dbo.Housing
SET          OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ', ', '.'), 3)

UPDATE PortfolioProject.dbo.Housing
SET          OwnerCity = PARSENAME(REPLACE(OwnerAddress, ', ', '.'), 2)

UPDATE PortfolioProject.dbo.Housing
SET          OwnerState = PARSENAME(REPLACE(OwnerAddress, ', ', '.'), 1)

----------------------------------------------------------------------------------------------------------------
-- 4. CHANGE 'Y' AND 'N' TO 'YES' AND 'NO' IN THE "SOLD AS VACANT" FIELD

-- Method 1
UPDATE PortfolioProject.dbo.Housing
SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'Y'
			THEN 'Yes'
		WHEN SoldAsVacant = 'N'
			THEN 'No'
		ELSE SoldAsVacant
		END

-- Method 2
UPDATE PortfolioProject.dbo.Housing
SET          SoldAsVacant = 'Yes'
WHERE  (SoldAsVacant = 'Y')

UPDATE PortfolioProject.dbo.Housing
SET          SoldAsVacant = 'No'
WHERE  (SoldAsVacant = 'N')

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant) AS Expr1
FROM     PortfolioProject.dbo.Housing
GROUP BY SoldAsVacant;
----------------------------------------------------------------------------------------------------------------
-- 5. REMOVE DUPLICATES
-- Create a CTE that counts the number of duplicates	
WITH duplicates
AS (
	SELECT *
		,ROW_NUMBER() OVER (
			PARTITION BY ParcelID
			,SaleDate
			,SalePrice
			,LegalReference ORDER BY UniqueID
			) AS row_num
	FROM PortfolioProject.dbo.Housing
	)

-- Delete duplicate records that have the same ParcelID, SaleDate, SalePrice, and LegalReference
DELETE FROM duplicates
WHERE  (row_num > 1)

----------------------------------------------------------------------------------------------------------------
-- 6. REMOVE UNUSUED COLUMNS 

ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress,
	PropertyAddress,
	TaxDistrict

