Use master
Go

if db_id('Sales_DataMart_2014') is not null --Checks if the DB is already existing
Drop database Sales_DataMart_2014  --Drop it if so

Create database Sales_DataMart_2014 --Create the holder DB
Go --End of batch