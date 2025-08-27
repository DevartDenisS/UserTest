SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_dm_get_customer_orders]
@customer_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT   o.order_id,
             o.order_date,
             p.product_name,
             oi.quantity,
             p.price,
             (oi.quantity * p.price) AS total_price
    FROM     dm_order AS o
             INNER JOIN
             dm_order_item AS oi
             ON o.order_id = oi.order_id
             INNER JOIN
             dm_product AS p
             ON oi.product_id = p.product_id
    WHERE    o.customer_id = @customer_id
    ORDER BY o.order_date DESC;
END

GO