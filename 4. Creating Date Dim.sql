USE Sales_DataMart_2014

GO

-- Drop the foreign key constraint if it exists
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_date'
                  AND parent_object_id = Object_id('fact_sales'))
  ALTER TABLE fact_sales
    DROP CONSTRAINT fk_fact_sales_dim_date;

-- Drop the table 'dim_date' if it exists
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'dim_date')
  DROP TABLE dim_date;

-- Create the 'dim_date' table with specified columns and constraints
CREATE TABLE dim_date
  (
     date_key            INT NOT NULL,                    -- Primary key for the date dimension
     full_date           DATE NOT NULL,                   -- Full date value
     calendar_year       INT NOT NULL,                    -- Year of the date
     calendar_quarter    INT NOT NULL,                    -- Quarter of the year
     calendar_month_num  INT NOT NULL,                    -- Month number of the year
     calendar_month_name NVARCHAR(15) NOT NULL,           -- Month name
     CONSTRAINT pk_dim_date PRIMARY KEY CLUSTERED (date_key) -- Primary key constraint on 'date_key'
  );
