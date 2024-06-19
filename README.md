# Nashville-Housing

## Project Overview

- This project focuses on cleaning and preparing raw housing data stored in an SQL database for analysis. The database contains data about housing sales in Nashville. 
- The primary goal is to remove duplicates, handle missing values, and transform the data into a standardized format suitable for downstream analysis.

## Project Structure

The project is structured as follows:

- **data/**: Contains the raw data file in Excel Workbook format.
- **Housing.sql**: Contains SQL scripts used for data cleaning.
- **results.md**: Contains output results.

## Database Schema

The database schema consists of the following table:

### Table: `Housing`

| Column       | Type    | Description                      |
|--------------|---------|----------------------------------|
| UniqueID    | FLOAT | ID of the sale |
| ParcelID     | NVARCHAR(255) | ID of the property |
| PropertyAddress  | NVARCHAR(255) | Address of the property |
| SaleDate     | DATE | Date of the deal |
| SalePrice     | FLOAT | Price of the property |
| LegalReference     | NVARCHAR(255) | Legal reference of the sale |
| SoldAsVacant     | NVARCHAR(255) | If the property is sold with vacant possession |
| OwnerAddress     | NVARCHAR(255) | Address of the owner (seller) |



