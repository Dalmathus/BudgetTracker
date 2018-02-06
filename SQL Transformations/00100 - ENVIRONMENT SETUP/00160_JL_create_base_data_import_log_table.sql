/************************************************************************************************ 
Date:    2017/12/29   
Author:  James Luxton
Purpose: Create table to store import logs
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'base_data_import_log'
)
   DROP TABLE dbo.base_data_import_log

CREATE TABLE dbo.base_data_import_log (
   log_id           NUMERIC        NOT NULL IDENTITY(1, 1),
   import_directory NVARCHAR(1000) NOT NULL,
   import_file      NVARCHAR(1000) NOT NULL,
   log_message      NVARCHAR(1000) NOT NULL,
   insert_datetime  DATETIME       NOT NULL CONSTRAINT [df_base_data_import_date] DEFAULT GETDATE(),
   insert_user      NVARCHAR(128)  NOT NULL CONSTRAINT [df_base_data_import_user] DEFAULT HOST_NAME(),
   insert_process   NVARCHAR(128)  NOT NULL CONSTRAINT [df_base_data_import_process] DEFAULT N'SETPROC'
)