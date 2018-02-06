/************************************************************************************************ 
Date:    2018/01/18   
Author:  James Luxton
Purpose: Configure environment variables
*************************************************************************************************/
BEGIN TRAN

DELETE FROM base_database_environment

CREATE TABLE #stg_base_environment (
   server_name                NVARCHAR(256),
   database_name              NVARCHAR(256),
   transaction_pool_directory NVARCHAR(2000),
   api_key                    NVARCHAR(256),
   production_environment     CHAR(1)
)

DECLARE @d_insert_datetime DATETIME      = GETDATE(),
        @v_insert_user     NVARCHAR(100) = HOST_NAME(),
        @v_insert_process  NVARCHAR(100) = N'DATALOAD',
        @c_update          CHAR(1)       = 'Y'

INSERT INTO #stg_base_environment
     ( server_name,
       database_name,
       transaction_pool_directory,
       api_key,
       production_environment )
VALUES
     ( N'JAMES\BUDGETTRACKER', N'budget_tracker_dev', N'C:\BudgetTracker\TransactionPool', NULL, 'N' ),
     ( N'JAMES\BUDGETTRACKER', N'budget_tracker_test', N'C:\BudgetTracker\TransactionPool', NULL, 'N' ),
     ( N'JAMES\BUDGETTRACKER', N'budget_tracker_preprod', N'C:\BudgetTracker\TransactionPool', NULL, 'N' ),
     ( N'JAMES\BUDGETTRACKER', N'budget_tracker_prod', N'C:\BudgetTracker\TransactionPool', NULL, 'Y' )

INSERT INTO dbo.base_database_environment
     ( server_name,
       database_name,
       transaction_pool_directory,
       api_key,
       production_environment,
       insert_datetime,
       insert_user,
       insert_process )
SELECT stg.server_name,
       stg.database_name,
       stg.transaction_pool_directory,
       stg.api_key,
       stg.production_environment,
       @d_insert_datetime,
       @v_insert_user,
       @v_insert_process
  FROM #stg_base_environment stg

IF @c_update = 'Y' BEGIN
                      COMMIT TRAN
END ELSE BEGIN
            ROLLBACK TRAN
END