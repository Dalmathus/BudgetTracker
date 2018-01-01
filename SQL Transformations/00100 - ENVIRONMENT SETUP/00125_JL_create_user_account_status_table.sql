/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store base user account statuses
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'usr_account_status') DROP TABLE dbo.usr_account_status

CREATE TABLE dbo.usr_account_status
(
    user_account_status_id   NUMERIC       NOT NULL IDENTITY(1,1),
    user_account_status_code NVARCHAR(10)  NOT NULL,
    user_account_status_desc NVARCHAR(100) NOT NULL,
    active                   CHAR(1)       NOT NULL CONSTRAINT [df_user_account_status_active]         DEFAULT 'Y',
    insert_datetime          DATETIME      NOT NULL CONSTRAINT [df_user_account_status_insert_date]    DEFAULT GETDATE(),
    insert_user              NVARCHAR(128) NOT NULL CONSTRAINT [df_user_account_status_insert_user]    DEFAULT HOST_NAME(),
    insert_process           NVARCHAR(128) NOT NULL CONSTRAINT [df_user_account_status_insert_process] DEFAULT N'SETPROC',
    update_datetime          DATETIME      NULL,
    update_user              NVARCHAR(128) NULL, 
    update_process           NVARCHAR(128) NULL,
    CONSTRAINT [pk_user_account_status] PRIMARY KEY NONCLUSTERED (user_account_status_id)
)