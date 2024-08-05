USE Sales_DataMart_2014
-- Select the database to work with

go

-- dropping the foreign keys if existing on the fact sales
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_product'
                  AND parent_object_id = Object_id('fact_sales'))
  ALTER TABLE fact_sales
    DROP CONSTRAINT fk_fact_sales_dim_product;
-- Check if the foreign key 'fk_fact_sales_dim_product' exists on 'fact_sales' table
-- If it exists, drop the foreign key constraint

-- Drop and create the table
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  NAME = 'dim_product'
                  AND type = 'U')
  DROP TABLE dim_product
-- Check if the table 'dim_product' exists and if it does, drop it

go

CREATE TABLE dim_product
  (
     product_key         INT NOT NULL IDENTITY(1, 1),-- Surrogate key, auto-incrementing
     product_id          INT NOT NULL,-- alternate key, business key for identifying products
     product_name        NVARCHAR(50),-- name of the product
     Product_description NVARCHAR(400),-- description of the product
     product_subcategory NVARCHAR(50),-- subcategory of the product
     product_category    NVARCHAR(50),-- category of the product
     color               NVARCHAR(15),-- color of the product
     model_name          NVARCHAR(50),-- model name of the product
     reorder_point       SMALLINT,-- point at which the product needs to be reordered
     standard_cost       MONEY,-- standard cost of the product
     -- Metadata
     source_system_code  TINYINT NOT NULL,-- code indicating the source system of the data
     -- SCD (Slowly Changing Dimension)
     start_date          DATETIME NOT NULL DEFAULT (Getdate()),-- start date, defaults to current date
     end_date            DATETIME,-- end date
     is_current          TINYINT NOT NULL DEFAULT (1),-- flag indicating if the record is current
     CONSTRAINT pk_dim_product PRIMARY KEY CLUSTERED (product_key)
     -- Primary key constraint on product_key, clustered index
  );

-- Insert unknown record
SET IDENTITY_INSERT dim_product ON
-- Allow manual insertion of values into an identity column

INSERT INTO dim_product
            (product_key,
             product_id,
             product_name,
             Product_description,
             product_subcategory,
             product_category,
             color,
             model_name,
             reorder_point,
             standard_cost,
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
             'Unknown',
             0,
             0,
             0,
             '1900-01-01',
             NULL,
             1)
-- Insert a default "Unknown" record into the dim_product table
-- This record is often used for unknown or missing product data

SET IDENTITY_INSERT dim_product OFF
-- Turn off manual identity insertion

-- create foreign key
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'fact_sales')
  ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key)
    REFERENCES
    dim_product(product_key);
-- Create a foreign key constraint linking fact_sales to dim_product on product_key

-- create indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_product_product_id'
                  AND object_id = Object_id('dim_product'))
  DROP INDEX dim_product.dim_product_product_id;
-- Check if an index on dim_product.product_id exists, and drop it if it does

CREATE INDEX dim_product_product_id
  ON dim_product(product_id);
-- Create a new index on dim_product.product_id

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_prodct_product_category'
                  AND object_id = Object_id('dim_product'))
  DROP INDEX dim_product.dim_prodct_product_category
-- Check if an index on dim_product.product_category exists, and drop it if it does

CREATE INDEX dim_prodct_product_category
  ON dim_product(product_category);
-- Create a new index on dim_product.product_category

