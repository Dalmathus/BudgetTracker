/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create a table to establish environment base configurations for test server restorations
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'base_database_environment'
)
   DROP TABLE dbo.base_database_environment

CREATE TABLE dbo.base_database_environment (
   environment_id             NUMERIC        NOT NULL IDENTITY(1, 1),
   server_name                NVARCHAR(128)  NULL,
   database_name              NVARCHAR(128)  NULL,
   transaction_pool_directory NVARCHAR(1000) NULL,
   api_key                    NVARCHAR(128)  NULL,
   production_environment     CHAR(1)        NULL,
   active                     CHAR(1)        NOT NULL CONSTRAINT [df_db_env_active] DEFAULT 'Y',
   insert_datetime            DATETIME       NOT NULL CONSTRAINT [df_db_env_insert_date] DEFAULT GETDATE(),
   insert_user                NVARCHAR(128)  NOT NULL CONSTRAINT [df_db_env_insert_user] DEFAULT HOST_NAME(),
   insert_process             NVARCHAR(128)  NOT NULL CONSTRAINT [df_db_env_insert_process] DEFAULT N'SETPROC',
   update_datetime            DATETIME       NULL,
   update_user                NVARCHAR(128)  NULL,
   update_process             NVARCHAR(128)  NULL,
   CONSTRAINT [pk_environment_id] PRIMARY KEY NONCLUSTERED ( environment_id )
)