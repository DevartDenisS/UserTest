SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =====================================================
-- View
-- =====================================================

CREATE VIEW [sales].[vw_order_summary]
AS
SELECT
    o.order_id,
    o.order_number,
    c.customer_name,
    e.first_name,
    e.last_name,
    o.total_amount,
    o.order_status
FROM sales.orders o
JOIN sales.customers c
    ON o.customer_id = c.customer_id
JOIN hr.employees e
    ON o.employee_id = e.employee_id;
GO

GRANT SELECT ON [sales].[vw_order_summary] TO [reporting_role]
GO