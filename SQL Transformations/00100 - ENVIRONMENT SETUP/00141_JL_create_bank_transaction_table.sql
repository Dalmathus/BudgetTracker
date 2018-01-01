/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store bank transactions
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'bank_transaction') DROP TABLE dbo.bank_transaction

CREATE TABLE dbo.bank_transaction
(
    bank_transaction_id    NUMERIC       NOT NULL    IDENTITY(1,1),
    bank_id                NUMERIC       NOT NULL,
	transaction_type_id    NUMERIC       NOT NULL,
    active                 NCHAR(1)      NOT NULL    CONSTRAINT [df_bank_transaction_active]         DEFAULT 'Y',
    insert_datetime        DATETIME      NOT NULL    CONSTRAINT [df_bank_transaction_insert_date]    DEFAULT GETDATE(),
    insert_user            NVARCHAR(128) NOT NULL    CONSTRAINT [df_bank_transaction_insert_user]    DEFAULT HOST_NAME(),
    insert_process         NVARCHAR(128) NOT NULL    CONSTRAINT [df_bank_transaction_insert_process] DEFAULT N'SETPROC',
    update_datetime        DATETIME      NULL,
    update_user            NVARCHAR(128) NULL, 
    update_process         NVARCHAR(128) NULL,
    CONSTRAINT [pk_bank_transaction]                     PRIMARY KEY NONCLUSTERED (bank_transaction_id),
	CONSTRAINT [fk_bank_transaction__bank_detail]        FOREIGN KEY (bank_id) REFERENCES bank_details(bank_id)
)
