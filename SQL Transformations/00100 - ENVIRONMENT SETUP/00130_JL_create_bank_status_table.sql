/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store base bank status information
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'bank_status'
)
   DROP TABLE dbo.bank_status

CREATE TABLE dbo.bank_status (
   bank_status_id   NUMERIC       NOT NULL IDENTITY(1, 1),
   bank_status_code NVARCHAR(10)  NOT NULL,
   bank_status_desc NVARCHAR(100) NOT NULL,
   active           CHAR(1)       NOT NULL CONSTRAINT [df_bank_status_active] DEFAULT 'Y',
   insert_datetime  DATETIME      NOT NULL CONSTRAINT [df_bank_status_insert_date] DEFAULT GETDATE(),
   insert_user      NVARCHAR(128) NOT NULL CONSTRAINT [df_bank_status_insert_user] DEFAULT HOST_NAME(),
   insert_process   NVARCHAR(128) NOT NULL CONSTRAINT [df_bank_status_insert_process] DEFAULT N'SETPROC',
   update_datetime  DATETIME      NULL,
   update_user      NVARCHAR(128) NULL,
   update_process   NVARCHAR(128) NULL,
   CONSTRAINT [pk_bank_status] PRIMARY KEY NONCLUSTERED ( bank_status_id )
)