USE Sales_DataMart_2014 -- Select the database named Sales_DataMart_2014

go

-- Drop foreign key if it exists on the table fact_sales
IF EXISTS (SELECT * 
           FROM sys.foreign_keys 
           WHERE NAME = 'fk_fact_sales_dim_customer' 
                 AND parent_object_id = Object_id('fact_sales'))
  ALTER TABLE fact_sales
    DROP CONSTRAINT fk_fact_sales_dim_customer;

-- Drop dim_customer table if it exists
IF EXISTS (SELECT * 
           FROM sys.tables 
           WHERE NAME = 'dim_customer')
  DROP TABLE dim_customer

go

-- Create the dim_customer table with specified columns
CREATE TABLE dim_customer
  (
     customer_key       INT NOT NULL IDENTITY(1, 1), -- Primary key with auto-increment
     customer_id        INT NOT NULL,                -- Unique identifier for the customer
     customer_name      NVARCHAR(150),               -- Name of the customer
     address1           NVARCHAR(100),               -- Primary address line
     address2           NVARCHAR(100),               -- Secondary address line (optional)
     city               NVARCHAR(30),                -- City of the customer
     phone              NVARCHAR(25),                -- Phone number of the customer
     -- birth_date date, -- Date of birth (commented out)
     -- marital_status char(10), -- Marital status (commented out)
     -- gender char(1), -- Gender (commented out)
     -- yearly_income money, -- Yearly income (commented out)
     -- education varchar(50), -- Education level (commented out)
     source_system_code TINYINT NOT NULL,            -- Code indicating the source system
     start_date         DATETIME NOT NULL DEFAULT (Getdate()), -- Start date with default value
     end_date           DATETIME NULL,               -- End date (nullable)
     is_current         TINYINT NOT NULL DEFAULT (1), -- Indicates if the record is current
     CONSTRAINT pk_dim_customer PRIMARY KEY CLUSTERED (customer_key) -- Primary key constraint
  );

-- Add foreign key linking customer_key in fact_sales to customer_key in dim_customer
IF EXISTS (SELECT * 
           FROM sys.tables 
           WHERE NAME = 'fact_sales' 
                 AND type = 'u')
  ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key)
    REFERENCES dim_customer(customer_key);

-- Insert a default "Unknown" record in dim_customer
SET IDENTITY_INSERT dim_customer ON

INSERT INTO dim_customer
            (customer_key,
             customer_id,
             customer_name,
             address1,
             address2,
             city,
             phone,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,
             0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             '1900-01-01',
             NULL,
             1)

SET IDENTITY_INSERT dim_customer OFF

-- Drop and create index on customer_id column in dim_customer table
IF EXISTS (SELECT * 
           FROM sys.indexes 
           WHERE NAME = 'dim_customer_customer_id' 
                 AND object_id = Object_id('dim_customer'))
  DROP INDEX dim_customer.dim_customer_customer_id

go

CREATE INDEX dim_customer_customer_id
  ON dim_customer(customer_id);

-- Drop and create index on city column in dim_customer table
IF EXISTS (SELECT * 
           FROM sys.indexes 
           WHERE NAME = 'dim_customer_city' 
                 AND object_id = Object_id('dim_customer'))
  DROP INDEX dim_customer.dim_customer_city

go

CREATE INDEX dim_customer_city
  ON dim_customer(city);
