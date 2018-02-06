/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Create a new transaction category, this process should be called after the category 
         has been input from the user. Assigning the transaction will be handled after this
         process has been run.
*************************************************************************************************/

IF EXISTS (
   SELECT 1
     FROM sys.procedures
    WHERE name = 'dbp_assign_category_to_transaction'
)
   DROP PROCEDURE dbo.dbp_assign_category_to_transaction
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_assign_category_to_transaction @pn_transaction_id NUMERIC(18),
                                                        @pn_category_id    NUMERIC(18)
AS
BEGIN

   DECLARE @d_insert_datetime DATETIME      = GETDATE(),
           @v_insert_user     NVARCHAR(100) = HOST_NAME(),
           @v_insert_process  NVARCHAR(100) = N'ASSGNCAT',
           @d_update_datetime DATETIME      = GETDATE(),
           @v_update_user     NVARCHAR(100) = HOST_NAME(),
           @v_update_process  NVARCHAR(100) = N'ASSGNCAT',
           @c_active          CHAR(1)       = 'Y',
           @c_debug           CHAR(1)       = 'N'

   DECLARE @n_account_id NUMERIC(18)

   SELECT *
     FROM bank_transaction
    WHERE bank_transaction_id = @pn_transaction_id

   IF @c_debug = 'Y' BEGIN
                        SELECT 'DEBUG'
   END

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

ROLLBACK TRANSACTION

*/

