SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_dm_add_customer]
@first_name NVARCHAR (50), @last_name NVARCHAR (50), @email NVARCHAR (100)
AS
BEGIN
    BEGIN
        SET NOCOUNT ON;
        INSERT  INTO dm_customer (first_name, last_name, email)
        VALUES                  (@first_name, @last_name, @email);
    END
END

GO