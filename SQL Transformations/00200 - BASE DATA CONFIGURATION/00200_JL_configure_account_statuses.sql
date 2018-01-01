/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Configure account statuses
*************************************************************************************************/
BEGIN TRAN

CREATE TABLE #stg_account_status(
        user_account_status_code NVARCHAR(10),
        user_account_status_desc NVARCHAR(100))

DECLARE @d_insert_datetime DATETIME      = GETDATE(),
        @v_insert_user     NVARCHAR(100) = HOST_NAME(),
        @v_insert_process  NVARCHAR(100) = N'DATALOAD',
		@c_update          CHAR(1)       = 'Y'

 INSERT INTO #stg_account_status (
        user_account_status_code,
        user_account_status_desc)
 VALUES (N'OPEN', N'Open Account'),
        (N'CLOSED', N'Open Closed'),
        (N'ERROR', N'Open in Error')

 INSERT INTO dbo.usr_account_status (
        user_account_status_code,
        user_account_status_desc,
        insert_datetime,
        insert_user,
        insert_process)
 SELECT stg.user_account_status_code,       
        stg.user_account_status_desc,       
        @d_insert_datetime,
        @v_insert_user,
        @v_insert_process
   FROM #stg_account_status stg

IF @c_update = 'Y'
BEGIN
    COMMIT TRAN
END
ELSE	
BEGIN
    ROLLBACK TRAN
END