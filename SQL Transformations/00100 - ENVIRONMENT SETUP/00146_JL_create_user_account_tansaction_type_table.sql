/************************************************************************************************ 
Date:    2018/02/06   
Author:  James Luxton
Purpose: Create table to store transaction types
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'bank_transaction_type'
)
   DROP TABLE dbo.bank_transaction_type

CREATE TABLE dbo.bank_transaction_type (
   transaction_type_id   NUMERIC(18)   NOT NULL IDENTITY(1, 1),
   transaction_type_code NVARCHAR(10)  NOT NULL,
   transaction_type_desc NVARCHAR(100) NOT NULL,
   active                CHAR(1)       NOT NULL CONSTRAINT [df_bank_transaction_type_active] DEFAULT 'Y',
   insert_datetime       DATETIME      NOT NULL CONSTRAINT [df_bank_transaction_type_insert_date] DEFAULT GETDATE(),
   insert_user           NVARCHAR(128) NOT NULL CONSTRAINT [df_bank_transaction_type_insert_user] DEFAULT HOST_NAME(),
   insert_process        NVARCHAR(128) NOT NULL CONSTRAINT [df_bank_transaction_type_insert_process] DEFAULT N'SETPROC',
   update_datetime       DATETIME      NULL,
   update_user           NVARCHAR(128) NULL,
   update_process        NVARCHAR(128) NULL,
   CONSTRAINT [pk_trans_type] PRIMARY KEY NONCLUSTERED ( transaction_type_id )
)