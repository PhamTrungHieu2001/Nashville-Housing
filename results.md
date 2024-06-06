# SQL Query Results
_The following tables only show the first 10 rows of the actual result._

## View data
```sql
SELECT * 
FROM     PortfolioProject.dbo.Housing
```
| UniqueID | ParcelID       | PropertyAddress                        | SaleDate         | SalePrice | LegalReference     | SoldAsVacant | OwnerAddress                                  |
|----------|----------------|----------------------------------------|------------------|-----------|--------------------|--------------|------------------------------------------------|
| 2045     | 007 00 0 125.00| 1808 FOX CHASE DR, GOODLETTSVILLE      | April 9, 2013    | 240000    | 20130412-0036474   | No           | 1808 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 16918    | 007 00 0 130.00| 1832 FOX CHASE DR, GOODLETTSVILLE      | June 10, 2014    | 366000    | 20140619-0053768   | No           | 1832 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 54582    | 007 00 0 138.00| 1864 FOX CHASE DR, GOODLETTSVILLE      | September 26, 2016| 435000    | 20160927-0101718   | No           | 1864 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 43070    | 007 00 0 143.00| 1853 FOX CHASE DR, GOODLETTSVILLE      | January 29, 2016 | 255000    | 20160129-0008913   | No           | 1853 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 22714    | 007 00 0 149.00| 1829 FOX CHASE DR, GOODLETTSVILLE      | October 10, 2014 | 278000    | 20141015-0095255   | No           | 1829 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 18367    | 007 00 0 151.00| 1821 FOX CHASE DR, GOODLETTSVILLE      | July 16, 2014    | 267000    | 20140718-0063802   | No           | 1821 FOX CHASE DR, GOODLETTSVILLE, TN         |
| 19804    | 007 14 0 002.00| 2005 SADIE LN, GOODLETTSVILLE          | August 28, 2014  | 171000    | 20140903-0080214   | No           | 2005 SADIE LN, GOODLETTSVILLE, TN             |
| 54583    | 007 14 0 024.00| 1917 GRACELAND DR, GOODLETTSVILLE      | September 27, 2016| 262000    | 20161005-0105441   | No           | 1917 GRACELAND DR, GOODLETTSVILLE, TN         |
| 36500    | 007 14 0 026.00| 1428 SPRINGFIELD HWY, GOODLETTSVILLE   | August 14, 2015  | 285000    | 20150819-0083440   | No           | 1428 SPRINGFIELD HWY, GOODLETTSVILLE, TN      |

## 1. Standardize date format
Change the date format from "April 9, 2013" to "2013-04-09"
```sql
ALTER TABLE PortfolioProject.dbo.Housing
ALTER COLUMN SaleDate DATE

SELECT SaleDate
FROM     PortfolioProject.dbo.Housing
```
| SaleDate   |
|------------|
| 2013-09-06 |
| 2014-10-29 |
| 2015-01-30 |
| 2016-07-15 |
| 2015-06-22 |
| 2013-08-16 |
| 2013-04-05 |
| 2015-11-02 |
| 2013-01-22 |
| 2015-12-08 |

## 2. Populate 'PropertyAddress' field
If one property doesn't have an address, find another one with the same 'ParcelID' and copy its address.

<table>
<tr><th>BEFORE</th><th>AFTER</th></tr>
  
<tr><td>
  
| ParcelID       | PropertyAddress               |
|----------------|-------------------------------|
| 093 08 0 054.00| 700 GLENVIEW DR, NASHVILLE    |
| 093 08 0 054.00| _NULL_                        |
| 093 08 0 054.00| 700 GLENVIEW DR, NASHVILLE    |
| 107 13 0 107.00| 1205 THOMPSON PL, NASHVILLE   |
| 107 13 0 107.00| _NULL_                        |
| 108 07 0A 026.00| _NULL_                       |
| 108 07 0A 026.00| 908 PATIO DR, NASHVILLE      |
| 108 07 0A 026.00| 908 PATIO DR, NASHVILLE      |
| 109 04 0A 080.00| 2537 JANALYN TRCE, HERMITAGE |
| 109 04 0A 080.00| _NULL_                       |

</td><td>

| ParcelID       | PropertyAddress               |
|----------------|-------------------------------|
| 093 08 0 054.00| 700 GLENVIEW DR, NASHVILLE    |
| 093 08 0 054.00| 700 GLENVIEW DR, NASHVILLE    |
| 093 08 0 054.00| 700 GLENVIEW DR, NASHVILLE    |
| 107 13 0 107.00| 1205 THOMPSON PL, NASHVILLE   |
| 107 13 0 107.00| 1205 THOMPSON PL, NASHVILLE   |
| 108 07 0A 026.00| 908 PATIO DR, NASHVILLE      |
| 108 07 0A 026.00| 908 PATIO DR, NASHVILLE      |
| 108 07 0A 026.00| 908 PATIO DR, NASHVILLE      |
| 109 04 0A 080.00| 2537 JANALYN TRCE, HERMITAGE |
| 109 04 0A 080.00| 2537 JANALYN TRCE, HERMITAGE |

</td></tr> </table>

```sql
UPDATE a
SET          a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM     PortfolioProject.dbo.Housing AS a INNER JOIN
                  PortfolioProject.dbo.Housing AS b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE  (a.PropertyAddress IS NULL)
```

## 3. Breaking address into individual columns (Address, City, State)
### 3.1. Breaking 'PropertyAddress' into 'PropertySplitAddress' and 'PropertyCity' using SUBSTRING()
```sql
-- Create 2 new columns to save the property's address and city
ALTER TABLE PortfolioProject.dbo.Housing 
ADD PropertyCity NVARCHAR(255)

ALTER TABLE PortfolioProject.dbo.Housing 
ADD PropertySplitAddress NVARCHAR(255)

-- Add data to the new columns
UPDATE PortfolioProject.dbo.Housing
SET          PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

UPDATE PortfolioProject.dbo.Housing
SET          PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
```
### 3.2. Breaking 'OwnerAddress' into 'OwnerSplitAddress', 'OwnerCity', and 'OwnerState' using PARSENAME()
```sql 
-- Create 3 new columns to save owners' address, city and state
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
```
View the result
```sql
SELECT PropertyAddress, PropertySplitAddress, PropertyCity, OwnerAddress, OwnerSplitAddress, OwnerCity, OwnerState
FROM     PortfolioProject.dbo.Housing
WHERE  (OwnerAddress IS NOT NULL)
```
| PropertyAddress            | PropertySplitAddress | PropertyCity | OwnerAddress                   | OwnerSplitAddress   | OwnerCity | OwnerState |
|----------------------------|----------------------|--------------|--------------------------------|---------------------|-----------|------------|
| 361 FLUSHING DR, NASHVILLE | 361 FLUSHING DR      | NASHVILLE    | 361 FLUSHING DR, NASHVILLE, TN | 361 FLUSHING DR     | NASHVILLE | TN         |
| 359 FLUSHING DR, NASHVILLE | 359 FLUSHING DR      | NASHVILLE    | 359 FLUSHING DR, NASHVILLE, TN | 359 FLUSHING DR     | NASHVILLE | TN         |
| 353 FLUSHING DR, NASHVILLE | 353 FLUSHING DR      | NASHVILLE    | 353 FLUSHING DR, NASHVILLE, TN | 353 FLUSHING DR     | NASHVILLE | TN         |
| 358 FLUSHING DR, NASHVILLE | 358 FLUSHING DR      | NASHVILLE    | 358 FLUSHING DR, NASHVILLE, TN | 358 FLUSHING DR     | NASHVILLE | TN         |
| 448 FOOTHILL DR, NASHVILLE | 448 FOOTHILL DR      | NASHVILLE    | 448 FOOTHILL DR, NASHVILLE, TN | 448 FOOTHILL DR     | NASHVILLE | TN         |
| 448 FOOTHILL DR, NASHVILLE | 448 FOOTHILL DR      | NASHVILLE    | 448 FOOTHILL DR, NASHVILLE, TN | 448 FOOTHILL DR     | NASHVILLE | TN         |
| 508 FOOTHILL DR, NASHVILLE | 508 FOOTHILL DR      | NASHVILLE    | 508 FOOTHILL DR, NASHVILLE, TN | 508 FOOTHILL DR     | NASHVILLE | TN         |
| 501 FOOTHILL DR, NASHVILLE | 501 FOOTHILL DR      | NASHVILLE    | 501 FOOTHILL DR, NASHVILLE, TN | 501 FOOTHILL DR     | NASHVILLE | TN         |
| 507 SHADY OAK DR, NASHVILLE| 507 SHADY OAK DR     | NASHVILLE    | 507 SHADY OAK DR, NASHVILLE, TN| 507 SHADY OAK DR    | NASHVILLE | TN         |
| 335 WIMPOLE DR, NASHVILLE  | 335 WIMPOLE DR       | NASHVILLE    | 335 WIMPOLE DR, NASHVILLE, TN  | 335 WIMPOLE DR      | NASHVILLE | TN         |

## 4. Change 'Y' and 'N' to 'Yes' and 'No' in the 'SoldAsVacant' column
Method 1: Using CASE
```sql
UPDATE PortfolioProject.dbo.Housing
SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'Y'
			THEN 'Yes'
		WHEN SoldAsVacant = 'N'
			THEN 'No'
		ELSE SoldAsVacant
		END
```
Method 2: Using WHERE
```sql
UPDATE PortfolioProject.dbo.Housing
SET          SoldAsVacant = 'Yes'
WHERE  (SoldAsVacant = 'Y')

UPDATE PortfolioProject.dbo.Housing
SET          SoldAsVacant = 'No'
WHERE  (SoldAsVacant = 'N')
```
View the result
```sql
SELECT SoldAsVacant, COUNT(SoldAsVacant) AS Num
FROM     PortfolioProject.dbo.Housing
GROUP BY SoldAsVacant;
```
| SoldAsVacant | Num   |
|--------------|-------|
| Yes          | 4669  |
| No           | 51704 |

## 5. Remove duplicates
1. Create a CTE that counts the number of duplicates
2. Delete duplicate records that have the same 'ParcelID', 'SaleDate', 'SalePrice', and 'LegalReference'
```sql
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

DELETE FROM duplicates
WHERE  (row_num > 1)
```

## 6. Remove unused columns
```sql
ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress,
	PropertyAddress

SELECT * 
FROM     PortfolioProject.dbo.Housing
```
| UniqueID | ParcelID        | SaleDate   | SalePrice | LegalReference   | SoldAsVacant | PropertyCity | PropertySplitAddress | OwnerSplitAddress | OwnerCity | OwnerState |
|----------|------------------|------------|-----------|------------------|--------------|--------------|----------------------|-------------------|-----------|------------|
| 7975     | 069 04 0 002.00  | 2013-09-06 | 30000     | 20130909-0094625 | No           | NASHVILLE    | 3806 FAIRVIEW DR     | 3806 FAIRVIEW DR  | NASHVILLE | TN         |
| 22701    | 069 04 0 003.00  | 2014-10-29 | 30000     | 20141104-0101893 | No           | NASHVILLE    | 3804 FAIRVIEW DR     | 3804 FAIRVIEW DR  | NASHVILLE | TN         |
| 26206    | 069 04 0 006.00  | 2015-01-30 | 63300     | 20150204-0010485 | No           | NASHVILLE    | 4005 CEDAR CIR       | 4005 CEDAR CIR    | NASHVILLE | TN         |
| 51953    | 069 04 0 012.00  | 2016-07-15 | 140000    | 20160718-0073753 | No           | NASHVILLE    | 4008 CEDAR CIR       | 4008 CEDAR CIR    | NASHVILLE | TN         |
| 33007    | 069 04 0 014.00  | 2015-06-22 | 83500     | 20150625-0061179 | No           | NASHVILLE    | 4002 CEDAR CIR       | 4002 CEDAR CIR    | NASHVILLE | TN         |
| 6983     | 069 04 0 022.00  | 2013-08-16 | 10000     | 20130819-0086794 | No           | NASHVILLE    | 4013 MEADOW RD       | 4013 MEADOW RD    | NASHVILLE | TN         |
| 2041     | 069 04 0 026.00  | 2013-04-05 | 82000     | 20130410-0035461 | No           | NASHVILLE    | 4006 MEADOW RD       | 4006 MEADOW RD    | NASHVILLE | TN         |
| 40580    | 069 04 0 048.00  | 2015-11-02 | 65000     | 20151109-0113634 | No           | NASHVILLE    | 3721 FAIRVIEW DR     | 3721 FAIRVIEW DR  | NASHVILLE | TN         |
| 238      | 069 04 0 065.00  | 2013-01-22 | 52500     | 20130123-0007440 | No           | NASHVILLE    | 3602 W HAMILTON RD   | 3602 W HAMILTON RD| NASHVILLE | TN         |
| 41913    | 069 04 0 065.00  | 2015-12-08 | 65500     | 20151210-0124354 | No           | NASHVILLE    | 3602 W HAMILTON RD   | 3602 W HAMILTON RD| NASHVILLE | TN         |
