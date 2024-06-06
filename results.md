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
<tr><th>_BEFORE_</th><th>_AFTER_</th></tr>
  
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

SELECT ParcelID, PropertyAddress
FROM     PortfolioProject.dbo.Housing
WHERE  (PropertyAddress IS NULL)
```




## 3. Breaking address into individual columns (Address, City, State)
## 4. Change 'Y' and 'N' to 'Yes' and 'No' in the 'SoldAsVacant' column
## 5. Remove duplicates
## 6. Remove unused columns
