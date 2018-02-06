/************************************************************************************************ 
Date:    2018/01/18   
Author:  James Luxton
Purpose: Import raw data into staging table for transactions to be processed into categories
         and assigned to accounts
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM sys.procedures
    WHERE name = 'dbp_create_archive_and_error_folders'
)
   DROP PROCEDURE dbo.dbp_create_archive_and_error_folders
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_create_archive_and_error_folders @pv_file_path NVARCHAR(100)
AS
BEGIN

   DECLARE @v_error_path   NVARCHAR(1000) = @pv_file_path + '\Error',
           @v_archive_path NVARCHAR(1000) = @pv_file_path + '\Archive'

   EXEC master.sys.xp_create_subdir @v_error_path
   EXEC master.sys.xp_create_subdir @v_archive_path

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    EXEC dbp_create_archive_and_error_folders @pv_file_path = 'C:\BudgetTracker\TransactionPool'

ROLLBACK TRANSACTION

*/