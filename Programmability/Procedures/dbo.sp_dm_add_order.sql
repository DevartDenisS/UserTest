SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_dm_add_order]
@customer_id INT, @product_id INT, @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @new_order_id AS INT;
    INSERT  INTO dm_order (customer_id)
    VALUES               (@customer_id);
    SET @new_order_id = SCOPE_IDENTITY();
    INSERT  INTO dm_order_item (order_id, product_id, quantity)
    VALUES                    (@new_order_id, @product_id, @quantity);
END

GO