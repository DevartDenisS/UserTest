SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_get_actors_by_lastname]
    @last_name_prefix VARCHAR(45)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    -- Return actors whose last name starts with the given prefix
    SELECT
        actor_id,
        first_name,
        last_name,
        last_update
    FROM dbo.actor
    WHERE last_name LIKE @last_name_prefix + '%'
    ORDER BY last_name, first_name;
END;
GO