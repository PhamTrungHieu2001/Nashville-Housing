# Nashville-Housing

## Project Overview

This project focuses on cleaning and preparing raw housing data stored in a SQL database for analysis. The primary goal is to identify and rectify inconsistencies, remove duplicates, handle missing values, and transform the data into a standardized format suitable for downstream analysis. This cleaned data can be used for various analyses, including price predictions, market trends, and more.

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
| UniqueID    | FLOAT | ID of the deal |
| ParcelID     | NVARCHAR(255) | ID of the land |
| PropertyAddress  | NVARCHAR(255) | Address of the property |
| SaleDate     | DATE | Date of the deal |
| SalePrice     | FLOAT | Price of the property |
| LegalReference     | NVARCHAR(255) | Legal reference of the deal |
| SoldAsVacant     | NVARCHAR(255) | If the property is sold with vacant possession |
| OwnerAddress     | NVARCHAR(255) | Address of the owner (seller) |

## Contributing

If you'd like to contribute to this project, please fork the repository and use a feature branch. Pull requests are welcome.




