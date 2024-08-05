USE Sales_DataMart_2014
GO

-- Check if the table 'fact_sales' exists, and if it does, drop it
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'fact_sales')
  DROP TABLE fact_sales;

-- Create a new table 'fact_sales' with the specified columns and constraints
CREATE TABLE fact_sales
  (
     product_key    INT NOT NULL,  -- Foreign key to 'dim_product'
     customer_key   INT NOT NULL,  -- Foreign key to 'dim_customer'
     territory_key  INT NOT NULL,  -- Foreign key to 'dim_territory'
     order_date_key INT NOT NULL,  -- Foreign key to 'dim_date'
     sales_order_id VARCHAR(50) NOT NULL,  -- Unique identifier for sales orders
     line_number    INT NOT NULL,  -- Line number within the sales order
     quantity       INT,  -- Quantity of items sold
     unit_price     MONEY,  -- Price per unit
     unit_cost      MONEY,  -- Cost per unit
     tax_amount     MONEY,  -- Amount of tax
     freight        MONEY,  -- Freight cost
     extended_sales MONEY,  -- Extended sales amount (unit_price * quantity)
     extended_cost  MONEY,  -- Extended cost amount (unit_cost * quantity)
     created_at     DATETIME NOT NULL DEFAULT(Getdate()),  -- Timestamp of record creation
     CONSTRAINT pk_fact_sales PRIMARY KEY CLUSTERED (sales_order_id, line_number  -- Primary key constraint for unique sales order lines
     ),
     CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key) REFERENCES
     dim_product(product_key),  -- Foreign key reference to 'dim_product'
     CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key) REFERENCES
     dim_customer(customer_key),  -- Foreign key reference to 'dim_customer'
     CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
     REFERENCES dim_territory(territory_key),  -- Foreign key reference to 'dim_territory'
     CONSTRAINT fk_fact_sales_dim_date FOREIGN KEY (order_date_key) REFERENCES
     dim_date(date_key)  -- Foreign key reference to 'dim_date'
  );

-- Create indexes on the 'fact_sales' table to improve query performance

-- Drop the existing index 'fact_sales_dim_product' if it exists
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_product'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_product;

-- Create a new index on 'product_key' column
CREATE INDEX fact_sales_dim_product
  ON fact_sales(product_key);

-- Drop the existing index 'fact_sales_dim_customer' if it exists
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_customer'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_customer;

-- Create a new index on 'customer_key' column
CREATE INDEX fact_sales_dim_customer
  ON fact_sales(customer_key);

-- Drop the existing index 'fact_sales_dim_territory' if it exists
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_territory'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_territory;

-- Create a new index on 'territory_key' column
CREATE INDEX fact_sales_dim_territory
  ON fact_sales(territory_key);

-- Drop the existing index 'fact_sales_dim_date' if it exists
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_date'
                  AND object_id = Object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_date;

-- Create a new index on 'order_date_key' column
CREATE INDEX fact_sales_dim_date
  ON fact_sales(order_date_key);
