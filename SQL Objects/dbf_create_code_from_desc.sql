/************************************************************************************************ 
Date:    2017/12/28   
Author:  James Luxton
Purpose: Transforms a string to a uppercase code with all vowels stripped.
         For use when creating codes based off user input. 
         Please don't use this for config scripts because they dont really make sense
*************************************************************************************************/

IF EXISTS (SELECT 1 FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name = 'dbf_create_code_from_desc') DROP FUNCTION dbo.dbf_create_code_from_desc
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION dbo.dbf_create_code_from_desc (
                @pv_string_desc     NVARCHAR(100))
RETURNS NVARCHAR(10)
AS
BEGIN

    IF LEN(@pv_string_desc) <= 10 
    BEGIN
        RETURN UPPER(@pv_string_desc)
    END
    ELSE
    BEGIN
        RETURN UPPER(LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@pv_string_desc, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', ''), ' ', ''), 10))
    END

    RETURN 'UNDEFINED'

END
GO

SET QUOTED_IDENTIFIER ON

/*
DEBUG CODE

BEGIN TRANSACTION

    SELECT dbo.dbf_create_code_from_desc(N'Groceries')
    SELECT dbo.dbf_create_code_from_desc(N'Flights and Trips')
    SELECT dbo.dbf_create_code_from_desc(N'RENT')
    SELECT dbo.dbf_create_code_from_desc(N'hOUSING')
    SELECT dbo.dbf_create_code_from_desc(N'12345')
    SELECT dbo.dbf_create_code_from_desc(NULL)
    SELECT dbo.dbf_create_code_from_desc('')

ROLLBACK TRANSACTION

*/




