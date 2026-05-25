SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =====================================================
-- Table-valued function
-- =====================================================

CREATE FUNCTION [sales].[fn_get_orders_by_status]
(
    @status NVARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        order_id,
        order_number,
        order_status,
        total_amount
    FROM sales.orders
    WHERE order_status = @status
);
GO