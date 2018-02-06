/************************************************************************************************ 
Date:    2018/01/18   
Author:  James Luxton
Purpose: Import raw data into staging table for transactions to be processed into categories
         and assigned to accounts
*************************************************************************************************/

IF EXISTS ( SELECT 1 FROM sys.procedures WHERE name = 'dbp_import_raw_transaction_data' )
   DROP PROCEDURE dbo.dbp_import_raw_transaction_data
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_import_raw_transaction_data @pv_file_path NVARCHAR(100),
                                                     @pv_file_name NVARCHAR(100)
AS
BEGIN

   SET DATEFORMAT DMY

   TRUNCATE TABLE dbo.bank_raw_transaction_data_import

   DECLARE @v_sql           NVARCHAR(MAX),
           @v_cmd           NVARCHAR(1000),
           @v_complete_path NVARCHAR(1000)

   DECLARE @v_year_part  VARCHAR(4) = DATEPART(YEAR, GETDATE()),
           @v_month_part CHAR(2)    = FORMAT(GETDATE(), 'MM'),
           @v_day_part   CHAR(2)    = FORMAT(GETDATE(), 'dd')

   SELECT @v_sql = '
    BULK INSERT dbo.bank_raw_transaction_data_import
    FROM ''' + @pv_file_path + '\' + @pv_file_name + '''
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK
    )'

   EXECUTE sp_executesql @v_sql

   -- File did not load any data. Send to Error and Log Message
   IF NOT EXISTS ( SELECT 1 FROM dbo.bank_raw_transaction_data_import )
   BEGIN
      SELECT @v_complete_path = @pv_file_path + '\Error\' + @v_year_part + '\' + @v_month_part + '\' + @v_day_part
      EXEC master.sys.xp_create_subdir @v_complete_path

      SELECT @v_cmd = 'MOVE ' + @pv_file_path + '\' + @pv_file_name + ' ' + @v_complete_path + '\' + @pv_file_name
      EXEC master.sys.xp_cmdshell @v_cmd

      EXEC dbo.dbp_log_data_import @pv_file_path,
                                   @pv_file_name,
                                   'Import Failed; Transaction data not entered'

      RETURN 1
   END

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    DECLARE @pv_file_path NVARCHAR(100) = 'C:\BudgetTracker\TransactionPool',
            @pv_file_name NVARCHAR(100) = 'Monthly-Expenses-10JAN2018-to-17JAN2018.csv'

    EXEC dbp_import_raw_transaction_data @pv_file_path, @pv_file_name

    SELECT *
      FROM bank_raw_transaction_data_import

ROLLBACK TRANSACTION

*/
