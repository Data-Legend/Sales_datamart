# Building a Sales Data Mart

## Overview

This project utilizes the AdventureWorks2014 database to build a data mart which is structured using a star schema design, comprising the following dimensions: Product, Customer, Territory, Date, along with a fact sales table.

## Objectives

- Creating the structure of the data mart database.
- Designing and creating dimension tables: Product, Customer, Territory, Date.
- Designing and creating a fact sales table.
- Implementing ETL processes using SSIS to populate the data mart.

## Star Schema Design

The star schema is chosen for its simplicity and ease of querying. The central fact table contains sales data, and it is connected to the dimension tables. Below are the key components:

### Dimension Tables

1. **Product**: Contains information about products.
2. **Customer**: Contains information about customers.
3. **Territory**: Contains information about sales territories.
4. **Date**: Contains date-related information.

### Fact Table

- **FactSales**: Contains sales transaction data, including references to the dimension tables.

## ETL Process

The ETL process involves the following steps:

1. **Extract**: Data is extracted from the AdventureWorks2014 database.
2. **Transform**: Data is cleaned, transformed, and formatted as needed.
3. **Load**: Transformed data is loaded into the data mart's dimension and fact tables.

## Implementation Steps

1. **Create Data Mart Database**
    - Designed the schema for the data mart.
    - Created the data mart database in SQL Server.

2. **Create Dimension Tables**
    - Created the Product, Customer, Territory, and Date dimension tables with appropriate attributes.

3. **Create Fact Table**
    - Created the FactSales table to store sales transactions and references to dimension tables.

4. **Develop SSIS Packages**
    - Created SSIS packages to automate the ETL process.
    - Implemented data flow tasks to extract data from AdventureWorks2014.
    - Applied necessary transformations (e.g., data cleaning, formatting).
    - Loaded transformed data into the dimension and fact tables using incremental load.

