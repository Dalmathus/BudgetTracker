/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store account transactions
*************************************************************************************************/

IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'user_account_transaction' )
   DROP TABLE dbo.user_account_transaction

CREATE TABLE dbo.user_account_transaction (
   transaction_id          NUMERIC        NOT NULL IDENTITY(1, 1),
   user_account_id         NUMERIC        NOT NULL,
   transaction_type_id     NUMERIC        NOT NULL,
   transaction_category_id NUMERIC        NULL,
   transaction_desc        NVARCHAR(1000) NULL,
   transaction_date        DATETIME       NOT NULL,
   transaction_amount      MONEY          NOT NULL,
   active                  NCHAR(1)       NOT NULL CONSTRAINT [df_user_account_transaction_active] DEFAULT 'Y',
   insert_datetime         DATETIME       NOT NULL CONSTRAINT [df_user_account_transaction_insert_date] DEFAULT GETDATE(),
   insert_user             NVARCHAR(128)  NOT NULL CONSTRAINT [df_user_account_transaction_insert_user] DEFAULT HOST_NAME(),
   insert_process          NVARCHAR(128)  NOT NULL CONSTRAINT [df_user_account_transaction_insert_process] DEFAULT N'SETPROC',
   update_datetime         DATETIME       NULL,
   update_user             NVARCHAR(128)  NULL,
   update_process          NVARCHAR(128)  NULL,
   CONSTRAINT [pk_user_account_transaction] PRIMARY KEY NONCLUSTERED ( transaction_id ),
   CONSTRAINT [fk_user_account_transaction__user_account] FOREIGN KEY ( user_account_id ) REFERENCES dbo.user_account ( user_account_id )
)
