/************************************************************************************************ 
Date:    2018/02/04   
Author:  James Luxton
Purpose: Logs a entry into the import log table
*************************************************************************************************/

IF EXISTS ( SELECT 1 FROM sys.procedures WHERE name = 'dbp_log_data_import' )
   DROP PROCEDURE dbo.dbp_log_data_import
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_log_data_import @pv_file_path   NVARCHAR(1000),
                                         @pv_file_name   NVARCHAR(1000),
                                         @pv_log_message NVARCHAR(1000)
AS
BEGIN

   INSERT INTO dbo.base_data_import_log
        ( import_directory,
          import_file,
          log_message,
          insert_datetime,
          insert_user,
          insert_process )
   SELECT @pv_file_path,
          @pv_file_name,
          @pv_log_message,
          GETDATE(),
          HOST_NAME(),
          'LOGIMPORT'

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    EXEC dbp_log_data_import 'asd', 'LAWL', 'asdad'

ROLLBACK TRANSACTION

*/
