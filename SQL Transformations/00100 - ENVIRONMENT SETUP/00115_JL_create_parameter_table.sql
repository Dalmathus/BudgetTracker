/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create table to store configurable database/system parameters
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'base_system_parameters') DROP TABLE dbo.base_system_parameters

CREATE TABLE dbo.base_system_parameters
(
    parameter_id    NUMERIC         NOT NULL IDENTITY(1,1),
    parameter_code  NVARCHAR(10)    NOT NULL,
    parameter_desc  NVARCHAR(100)   NOT NULL,
    parameter_value NVARCHAR(1024)  NULL,
    active          CHAR(1)         NOT NULL CONSTRAINT [df_parameters_active]         DEFAULT 'Y',
    insert_datetime DATETIME        NOT NULL CONSTRAINT [df_parameters_insert_date]    DEFAULT GETDATE(),
    insert_user     NVARCHAR(128)   NOT NULL CONSTRAINT [df_parameters_insert_user]    DEFAULT HOST_NAME(),
    insert_process  NVARCHAR(128)   NOT NULL CONSTRAINT [df_parameters_insert_process] DEFAULT N'SETPROC',
    update_datetime DATETIME        NULL, 
    update_user     NVARCHAR(128)   NULL, 
    update_process  NVARCHAR(128)   NULL,
    CONSTRAINT [pk_parameter_id] PRIMARY KEY NONCLUSTERED (parameter_id)
)