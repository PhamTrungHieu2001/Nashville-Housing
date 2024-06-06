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
| iso_code     | NVARCHAR(255) | ISO code of the country |
| continent     | NVARCHAR(255) | Continent of the country |
| location     | NVARCHAR(255) | Name of the country |
| date     | DATETIME | Date of the report |
| population     | FLOAT | Population of the country |
| total_cases     | FLOAT | Total number of cases |
| new_cases     | FLOAT | Number of new cases |
| total_deaths     | NVARCHAR(255) | Total number of deaths |
| new_deaths     | NVARCHAR(255) | Number of new deaths |

## Contributing

If you'd like to contribute to this project, please fork the repository and use a feature branch. Pull requests are welcome.




