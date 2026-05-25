SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =====================================================
-- Scalar function
-- =====================================================

CREATE FUNCTION [dbo].[fn_get_full_name]
(
    @first_name NVARCHAR(100),
    @last_name NVARCHAR(100)
)
RETURNS NVARCHAR(250)
AS
BEGIN
    RETURN @first_name + N' ' + @last_name;
END;
GO