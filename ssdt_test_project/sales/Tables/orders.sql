CREATE TABLE [sales].[orders] (
    [order_id]     INT              IDENTITY (1, 1) NOT NULL,
    [order_number] BIGINT           DEFAULT (NEXT VALUE FOR [dbo].[seq_order_number]) NULL,
    [customer_id]  UNIQUEIDENTIFIER NOT NULL,
    [employee_id]  INT              NOT NULL,
    [order_date]   DATE             NOT NULL,
    [total_amount] MONEY            NULL,
    [order_status] NVARCHAR (20)    NULL,
    [order_year]   AS               (datepart(year,[order_date])) PERSISTED,
    CONSTRAINT [pk_orders] PRIMARY KEY CLUSTERED ([order_id] ASC, [order_date] ASC) ON [ps_order_year] ([order_date]),
    CONSTRAINT [fk_orders_customer] FOREIGN KEY ([customer_id]) REFERENCES [sales].[customers] ([customer_id]),
    CONSTRAINT [fk_orders_employee] FOREIGN KEY ([employee_id]) REFERENCES [hr].[employees] ([employee_id])
) ON [ps_order_year] ([order_date]);


GO

-- =====================================================
-- Trigger
-- =====================================================

CREATE TRIGGER sales.trg_orders_audit
ON sales.orders
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO audit.order_audit
    (
        order_id,
        action_type
    )
    SELECT
        i.order_id,
        'INSERT'
    FROM inserted i;

END;
