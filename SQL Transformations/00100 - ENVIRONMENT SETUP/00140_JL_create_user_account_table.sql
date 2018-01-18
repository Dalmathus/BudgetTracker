/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store base user information for storing all user foriegn key contraints
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'user_account') DROP TABLE dbo.user_account

CREATE TABLE dbo.user_account
(
    user_account_id        NUMERIC       NOT NULL     IDENTITY(1,1),
    user_details_id        NUMERIC       NOT NULL, 	  
    user_account_status_id NUMERIC       NOT NULL, 	  
    active                 CHAR(1)       NOT NULL     CONSTRAINT [df_user_account_active]         DEFAULT 'Y',
    insert_datetime        DATETIME      NOT NULL     CONSTRAINT [df_user_account_insert_date]    DEFAULT GETDATE(),
    insert_user            NVARCHAR(128) NOT NULL     CONSTRAINT [df_user_account_insert_user]    DEFAULT HOST_NAME(),
    insert_process         NVARCHAR(128) NOT NULL     CONSTRAINT [df_user_account_insert_process] DEFAULT N'SETPROC',
    update_datetime        DATETIME      NULL, 
    update_user            NVARCHAR(128) NULL,  
    update_process         NVARCHAR(128) NULL, 
    CONSTRAINT [pk_user_account]                      PRIMARY KEY NONCLUSTERED (user_account_id),
    CONSTRAINT [fk_user_account__user_details]        FOREIGN KEY (user_details_id)        REFERENCES user_details(user_details_id),
    CONSTRAINT [fk_user_account__user_account_status] FOREIGN KEY (user_account_status_id) REFERENCES user_account_status(user_account_status_id)
)