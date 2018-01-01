/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store base user details
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'usr_details') DROP TABLE dbo.usr_details

CREATE TABLE dbo.usr_details
(
    user_details_id NUMERIC       NOT NULL  IDENTITY(1,1),
    first_name      NVARCHAR(100) NOT NULL,
    last_name       NVARCHAR(100) NOT NULL,
    user_name       NVARCHAR(100) NOT NULL,
    password        NVARCHAR(100) NOT NULL,
    active          CHAR(1)       NOT NULL  CONSTRAINT [df_usr_details_active]         DEFAULT 'Y',
    insert_datetime DATETIME      NOT NULL  CONSTRAINT [df_usr_details_insert_date]    DEFAULT GETDATE(),
    insert_user     NVARCHAR(128) NOT NULL  CONSTRAINT [df_usr_details_insert_user]    DEFAULT HOST_NAME(),
    insert_process  NVARCHAR(128) NOT NULL  CONSTRAINT [df_usr_details_insert_process] DEFAULT N'SETPROC',
    update_datetime DATETIME      NULL,
    update_user     NVARCHAR(128) NULL, 
    update_process  NVARCHAR(128) NULL,
    CONSTRAINT [pk_user_details] PRIMARY KEY NONCLUSTERED (user_details_id)
)
