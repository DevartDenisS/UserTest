
-- =====================================================
-- Stored procedure
-- =====================================================

CREATE PROCEDURE sales.usp_get_customer_orders
(
    @customer_id UNIQUEIDENTIFIER
)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        o.order_id,
        o.order_number,
        o.order_date,
        o.total_amount
    FROM sales.orders o
    WHERE o.customer_id = @customer_id;

END;
