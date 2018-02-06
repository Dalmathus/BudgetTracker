/************************************************************************************************ 
Date:    2017/12/29   
Author:  James Luxton
Purpose: Create table to store account level transaction categories
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'bank_raw_transaction_data_import'
)
   DROP TABLE dbo.bank_raw_transaction_data_import

CREATE TABLE dbo.bank_raw_transaction_data_import (
   transaction_date DATETIME     NOT NULL,
   amount           MONEY        NOT NULL,
   payee            VARCHAR(20)  NULL,
   particulars      VARCHAR(100) NULL,
   code             VARCHAR(20)  NULL,
   reference        VARCHAR(20)  NULL,
   tran_type        VARCHAR(20)  NULL,
   processed_date   DATETIME     NULL
)