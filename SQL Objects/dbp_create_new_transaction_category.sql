/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Create a new transaction category, this process should be called after the category 
         has been input from the user. Assigning the transaction will be handled after this
         process has been run.
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'dbp_create_new_transaction_category') DROP PROCEDURE dbo.dbp_create_new_transaction_category
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_create_new_transaction_category
                 @pn_account_id     NUMERIC(18),
                 @pv_category_desc  NVARCHAR(100)
AS
BEGIN

    DECLARE @d_insert_datetime DATETIME      = GETDATE(),
            @v_insert_user     NVARCHAR(100) = HOST_NAME(),
            @v_insert_process  NVARCHAR(100) = N'INSCAT',
            @c_active          CHAR(1)       = 'Y',
            @c_debug           CHAR(1)       = 'N'

    DECLARE @v_category_code   NVARCHAR(10)

    SELECT @v_category_code = dbo.dbf_create_code_from_desc(@pv_category_desc)
    
    IF NULLIF(LTRIM(@v_category_code), '') IS NOT NULL OR NULLIF(LTRIM(@pv_category_desc), '') IS NOT NULL
    BEGIN  
        INSERT dbo.user_account_transaction_category (
               user_account_id,
               transaction_category_code,
               transaction_category_desc,
               active,
               insert_datetime,
               insert_user,
               insert_process)
        SELECT @pn_account_id,      
               @v_category_code,       
               @pv_category_desc,       
               @c_active,      
               @d_insert_datetime,
               @v_insert_user,
               @v_insert_process
    END
    ELSE
    BEGIN
        RAISERROR (15600,-1,-1, 'Description cannot be blank or null')
        RETURN -1
    END

    IF @c_debug = 'Y'
    BEGIN
        SELECT @v_category_code  [Category Code],
               @pv_category_desc [Category Description],
               @pn_account_id    [Account ID]
    END

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    EXEC dbp_create_new_transaction_category 3, N'Travel Accomodation'
    EXEC dbp_create_new_transaction_category 3, N'12345'
    EXEC dbp_create_new_transaction_category 3, 12345
    EXEC dbp_create_new_transaction_category 3, NULL
    EXEC dbp_create_new_transaction_category 3, N'TEST LONG CODE NOW'
    EXEC dbp_create_new_transaction_category 3, N'Short'
    SELECT * FROM user_account_transaction_category

ROLLBACK TRANSACTION

*/

    