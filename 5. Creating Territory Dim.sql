USE Sales_DataMart_2014

GO

-- Check if the foreign key constraint exists, and if so, drop it
IF EXISTS (SELECT *
           FROM   sys.foreign_keys
           WHERE  NAME = 'fk_fact_sales_dim_territory'
                  AND parent_object_id = Object_id('fact_sales'))
  ALTER TABLE fact_sales
    DROP CONSTRAINT fk_fact_sales_dim_territory;

-- Check if the table 'dim_territory' exists, and if so, drop it
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  NAME = 'dim_territory'
                  AND type = 'U')
  DROP TABLE dim_territory

GO

-- Create a new table 'dim_territory' with specified columns and constraints
CREATE TABLE dim_territory
  (
     territory_key      INT NOT NULL IDENTITY(1, 1),  -- Primary key with auto-increment
     territory_id       INT NOT NULL,                  -- ID for the territory
     territory_name     NVARCHAR(50),                   -- Name of the territory
     territory_country  NVARCHAR(400),                  -- Country of the territory
     territory_group    NVARCHAR(50),                   -- Group of the territory
     source_system_code TINYINT NOT NULL,               -- Code for the source system
     start_date         DATETIME NOT NULL DEFAULT (Getdate()), -- Start date with default value
     end_date           DATETIME,                        -- End date of the record
     is_current         TINYINT NOT NULL DEFAULT (1),   -- Indicator if the record is current
     CONSTRAINT pk_dim_territory PRIMARY KEY CLUSTERED (territory_key) -- Primary key constraint
  );

-- Allow identity column to be manually inserted into
SET IDENTITY_INSERT dim_territory ON

-- Insert a record with default values
INSERT INTO dim_territory
            (territory_key,
             territory_id,
             territory_name,
             territory_country,
             territory_group,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES     (0,
            0,
            'Unknown',
            'Unknown',
            'Unknown',
            0,
            '1900-01-01',
            NULL,
            1)

-- Revert identity column to auto-increment mode
SET IDENTITY_INSERT dim_territory OFF

-- Create a foreign key constraint if the 'fact_sales' table exists
IF EXISTS (SELECT *
           FROM   sys.tables
           WHERE  NAME = 'fact_sales')
  ALTER TABLE fact_sales
    ADD CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
    REFERENCES dim_territory(territory_key);

-- Check if the index 'dim_territory_territory_code' exists, and if so, drop it
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_territory_territory_code'
                  AND object_id = Object_id('dim_territory'))
  DROP INDEX dim_territory.dim_territory_territory_code;

-- Create a new index on the 'territory_id' column
CREATE INDEX dim_territory_territory_id
  ON dim_territory(territory_id);
