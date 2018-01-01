/************************************************************************************************ 
Date:    2017/12/29   
Author:  James Luxton
Purpose: Create table to store account level transaction categories
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'usr_account_transaction_category') DROP TABLE dbo.usr_account_transaction_category

CREATE TABLE dbo.usr_account_transaction_category
(
    transaction_category_id   NUMERIC(18)     NOT NULL IDENTITY(1,1),
    user_account_id           NUMERIC(18)     NOT NULL,
    transaction_category_code NVARCHAR(10)    NOT NULL,                      
    transaction_category_desc NVARCHAR(100)   NOT NULL, 
    active                    CHAR(1)         NOT NULL CONSTRAINT [df_trans_category_active]         DEFAULT 'Y',
    insert_datetime           DATETIME        NOT NULL CONSTRAINT [df_trans_category_insert_date]    DEFAULT GETDATE(),
    insert_user               NVARCHAR(128)   NOT NULL CONSTRAINT [df_trans_category_insert_user]    DEFAULT HOST_NAME(),
    insert_process            NVARCHAR(128)   NOT NULL CONSTRAINT [df_trans_category_insert_process] DEFAULT N'SETPROC',
    update_datetime           DATETIME        NULL,
    update_user               NVARCHAR(128)   NULL, 
    update_process            NVARCHAR(128)   NULL,
    CONSTRAINT [pk_trans_category]                     PRIMARY KEY NONCLUSTERED (transaction_category_id),
    CONSTRAINT [fk_trans_category__usr_account]        FOREIGN KEY (user_account_id)                 REFERENCES dbo.usr_account(user_account_id)
)