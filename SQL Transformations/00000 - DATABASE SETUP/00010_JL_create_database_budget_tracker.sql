/************************************************************************************************ 
Date:    2017/12/27   
Author:  James Luxton
Purpose: Create all databases
*************************************************************************************************/

CREATE DATABASE budget_tracker_prod
CREATE DATABASE budget_tracker_preprod
CREATE DATABASE budget_tracker_test
CREATE DATABASE budget_tracker_dev

USE budget_tracker_dev
EXEC sp_configure 'show advanced options',
                  1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell',
                  1;
GO

RECONFIGURE;
GO

USE budget_tracker_test
EXEC sp_configure 'show advanced options',
                  1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell',
                  1;
GO

RECONFIGURE;
GO

USE budget_tracker_preprod
EXEC sp_configure 'show advanced options',
                  1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell',
                  1;
GO

RECONFIGURE;
GO

USE budget_tracker_prod
EXEC sp_configure 'show advanced options',
                  1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell',
                  1;
GO

RECONFIGURE;
GO