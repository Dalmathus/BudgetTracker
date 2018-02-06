/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Create a new user account login
*************************************************************************************************/

IF EXISTS ( SELECT 1 FROM sys.procedures WHERE name = 'dbp_create_user_account' )
   DROP PROCEDURE dbo.dbp_create_user_account
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE dbo.dbp_create_user_account @pv_first_name NVARCHAR(100),
                                             @pv_last_name  NVARCHAR(100),
                                             @pv_user_name  NVARCHAR(100),
                                             @pv_password   NVARCHAR(100)
AS
BEGIN
   DECLARE @n_user_details_id   NUMERIC(18),
           @n_open_accnt_status NUMERIC(18)

   DECLARE @d_insert_datetime DATETIME      = GETDATE(),
           @v_insert_user     NVARCHAR(100) = HOST_NAME(),
           @v_insert_process  NVARCHAR(10)  = N'CREATEUSER'

   -- Check to see if first name is populated correctly
   IF LEN(LTRIM(@pv_first_name)) < 1
   BEGIN
      RAISERROR(15600, -1, -1, 'First name not set')
      RETURN -1
   END

   -- Check to see if last name is populated correctly
   IF LEN(LTRIM(@pv_last_name)) < 1
   BEGIN
      RAISERROR(15600, -1, -1, 'Last name not set')
      RETURN -1
   END

   -- Check to see if user name is populated correctly
   IF LEN(LTRIM(@pv_user_name)) < 1
   BEGIN
      RAISERROR(15600, -1, -1, 'User name not set')
      RETURN -1
   END

   -- Check to see if the username already exists within the system
   IF EXISTS (
      SELECT 1
        FROM dbo.user_details
       WHERE user_name = @pv_user_name
         AND active = N'Y'
   )
   BEGIN
      RAISERROR(15600, -1, -1, 'Username already in use')
      RETURN -1
   END

   -- Check to see if password meets required criteria (Currently anything not whitespace)
   IF LEN(LTRIM(@pv_password)) < 1
   BEGIN
      RAISERROR(15600, -1, -1, 'Password must be set')
      RETURN -1
   END

   -- Collect required ids
   SELECT @n_open_accnt_status = user_account_status_id
     FROM dbo.user_account_status
    WHERE user_account_status_code = 'OPEN'

   -- Insert into User Details
   INSERT dbo.user_details
        ( first_name,
          last_name,
          user_name,
          password,
          insert_datetime,
          insert_user,
          insert_process )
   SELECT @pv_first_name,
          @pv_last_name,
          @pv_user_name,
          @pv_password,
          @d_insert_datetime,
          @v_insert_user,
          @v_insert_process

   SELECT @n_user_details_id = SCOPE_IDENTITY()

   -- Create the user account
   INSERT dbo.user_account
        ( user_details_id,
          user_account_status_id,
          insert_datetime,
          insert_user,
          insert_process )
   SELECT @n_user_details_id,
          @n_open_accnt_status,
          @d_insert_datetime,
          @v_insert_user,
          @v_insert_process

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    EXEC dbo.dbp_create_user_account N'û%r♠╝ß∞', N'LUXTON', 'DEBUG1', 'PW'
    EXEC dbo.dbp_create_user_account 'û%r♠╝ß∞', N'LUXTON', 'DEBUG2', 'PW'
    EXEC dbo.dbp_create_user_account N'JAMES', N'LUXTON', 'DEBUG3', 'PW'

    SELECT a.user_account_id          [Account Number],
           d.first_name               [First Name],
           d.last_name                [Last Name],
           d.user_name                [Username],
           d.password                 [Password],
           s.user_account_status_code [Account Code],
           s.user_account_status_desc [Account Desc]
      FROM dbo.user_details        d
      JOIN dbo.user_account        a ON a.user_details_id = d.user_details_id
      JOIN dbo.user_account_status s ON s.user_account_status_id = a.user_account_status_id

ROLLBACK TRANSACTION

*/
