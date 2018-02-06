/************************************************************************************************ 
Date:    2018/01/18   
Author:  James Luxton
Purpose: Run in a loop to import any new transactions found in the import directory
*************************************************************************************************/

IF EXISTS ( SELECT 1 FROM sys.procedures WHERE name = 'dbp_process_import_directory' )
   DROP PROCEDURE dbo.dbp_process_import_directory
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_process_import_directory
AS
BEGIN

   DECLARE @dirList AS TABLE ( id INT IDENTITY(1, 1), line NVARCHAR(1000) NULL )

   DECLARE @v_file_path              NVARCHAR(1000),
           @v_cmd                    NVARCHAR(1000),
           @v_file_name              NVARCHAR(1000),
           @n_user_account_id        NUMERIC(18),
           @n_purchase_trans_type_id NUMERIC(18),
           @n_payment_trans_type_id  NUMERIC(18)

   DECLARE @d_insert_datetime DATETIME      = GETDATE(),
           @v_insert_process  NVARCHAR(100) = 'PROCIMPD',
           @v_insert_user     NVARCHAR(100) = HOST_ID()

   SELECT @v_file_path = transaction_pool_directory
     FROM dbo.base_database_environment
    WHERE database_name = DB_NAME()

   SELECT @v_cmd = 'dir ' + @v_file_path + ' /a-d /b'

   INSERT INTO @dirList ( line )
   EXEC xp_cmdshell @v_cmd

   DECLARE files_to_process CURSOR LOCAL FAST_FORWARD FOR
      SELECT line
        FROM @dirList dl
       WHERE dl.line IS NOT NULL
   OPEN files_to_process
   FETCH NEXT FROM files_to_process
    INTO @v_file_name

   WHILE @@FETCH_STATUS = 0
   BEGIN

      BEGIN TRY

         EXECUTE dbo.dbp_import_raw_transaction_data @pv_file_path = @v_file_path,
                                                     @pv_file_name = @v_file_name

         -- Get account the transactions were loaded for
         SELECT @n_user_account_id = ua.user_account_id
           FROM dbo.user_account ua

         INSERT INTO dbo.user_account_transaction
              ( user_account_id,
                transaction_type_id,
                transaction_date,
                transaction_desc,
                transaction_amount,
                insert_datetime,
                insert_user,
                insert_process )
         SELECT @n_user_account_id,
                btt.transaction_type_id,
                di.transaction_date,
                di.reference,
                di.amount,
                @d_insert_datetime,
                @v_insert_user,
                @v_insert_process
           FROM dbo.bank_raw_transaction_data_import di
           JOIN dbo.bank_transaction_type            btt ON di.tran_type = btt.transaction_type_code

         FETCH NEXT FROM files_to_process
          INTO @v_file_name

      END TRY
      BEGIN CATCH

         FETCH NEXT FROM files_to_process
          INTO @v_file_name

      END CATCH

   END

   CLOSE files_to_process
   DEALLOCATE files_to_process
END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    EXEC dbp_process_import_directory 

ROLLBACK TRANSACTION

*/
