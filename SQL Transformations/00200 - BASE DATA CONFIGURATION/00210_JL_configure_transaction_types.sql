/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Configure transaction types
*************************************************************************************************/
BEGIN TRAN

CREATE TABLE #stg_transaction_types ( transaction_type_code NVARCHAR(10), transaction_type_desc NVARCHAR(100))

DECLARE @d_insert_datetime DATETIME      = GETDATE(),
        @v_insert_user     NVARCHAR(100) = HOST_NAME(),
        @v_insert_process  NVARCHAR(100) = N'DATALOAD',
        @c_update          CHAR(1)       = 'Y'

INSERT INTO #stg_transaction_types ( transaction_type_code, transaction_type_desc )
VALUES
     ( N'PAY', N'Payment' ),
     ( N'PUR', N'Purchase' ),
     ( N'ERROR', N'Error' )

INSERT INTO dbo.bank_transaction_type
     ( transaction_type_code,
       transaction_type_desc,
       insert_datetime,
       insert_user,
       insert_process )
SELECT stg.transaction_type_code,
       stg.transaction_type_desc,
       @d_insert_datetime,
       @v_insert_user,
       @v_insert_process
  FROM #stg_transaction_types stg

IF @c_update = 'Y' BEGIN
                      COMMIT TRAN
END ELSE BEGIN
            ROLLBACK TRAN
END