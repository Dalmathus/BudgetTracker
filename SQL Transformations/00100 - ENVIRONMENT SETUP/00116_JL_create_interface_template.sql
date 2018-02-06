/************************************************************************************************ 
Date:    2018/02/06   
Author:  James Luxton
Purpose: Create table to store configurable interface templates
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'base_interface_template'
)
   DROP TABLE dbo.base_interface_template

CREATE TABLE dbo.base_interface_template (
   template_id     NUMERIC        NOT NULL IDENTITY(1, 1),
   template_code   NVARCHAR(10)   NOT NULL,
   template_desc   NVARCHAR(100)  NOT NULL,
   col_01          NVARCHAR(1024) NULL,
   col_02          NVARCHAR(1024) NULL,
   col_03          NVARCHAR(1024) NULL,
   col_04          NVARCHAR(1024) NULL,
   col_05          NVARCHAR(1024) NULL,
   col_06          NVARCHAR(1024) NULL,
   col_07          NVARCHAR(1024) NULL,
   col_08          NVARCHAR(1024) NULL,
   col_09          NVARCHAR(1024) NULL,
   col_10          NVARCHAR(1024) NULL,
   col_11          NVARCHAR(1024) NULL,
   col_12          NVARCHAR(1024) NULL,
   col_13          NVARCHAR(1024) NULL,
   col_14          NVARCHAR(1024) NULL,
   col_15          NVARCHAR(1024) NULL,
   col_16          NVARCHAR(1024) NULL,
   col_17          NVARCHAR(1024) NULL,
   col_18          NVARCHAR(1024) NULL,
   col_19          NVARCHAR(1024) NULL,
   col_20          NVARCHAR(1024) NULL,
   col_21          NVARCHAR(1024) NULL,
   col_22          NVARCHAR(1024) NULL,
   col_23          NVARCHAR(1024) NULL,
   col_24          NVARCHAR(1024) NULL,
   col_25          NVARCHAR(1024) NULL,
   col_26          NVARCHAR(1024) NULL,
   col_27          NVARCHAR(1024) NULL,
   col_28          NVARCHAR(1024) NULL,
   col_29          NVARCHAR(1024) NULL,
   col_30          NVARCHAR(1024) NULL,
   active          CHAR(1)        NOT NULL CONSTRAINT [df_template_active] DEFAULT 'Y',
   insert_datetime DATETIME       NOT NULL CONSTRAINT [df_template_insert_date] DEFAULT GETDATE(),
   insert_user     NVARCHAR(128)  NOT NULL CONSTRAINT [df_template_insert_user] DEFAULT HOST_NAME(),
   insert_process  NVARCHAR(128)  NOT NULL CONSTRAINT [df_template_insert_process] DEFAULT N'SETPROC',
   update_datetime DATETIME       NULL,
   update_user     NVARCHAR(128)  NULL,
   update_process  NVARCHAR(128)  NULL,
   CONSTRAINT [pk_template_id] PRIMARY KEY NONCLUSTERED ( template_id )
)