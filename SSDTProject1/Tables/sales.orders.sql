SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [sales].[orders] (
  [order_id] [int] IDENTITY,
  [order_number] [bigint] NULL DEFAULT (NEXT VALUE FOR [dbo].[seq_order_number]),
  [customer_id] [uniqueidentifier] NOT NULL,
  [employee_id] [int] NOT NULL,
  [order_date] [date] NOT NULL,
  [total_amount] [money] NULL,
  [order_status] [nvarchar](20) NULL,
  [order_year] AS (datepart(year,[order_date])) PERSISTED,
  CONSTRAINT [pk_orders] PRIMARY KEY CLUSTERED ([order_id], [order_date]) ON [ps_order_year] ([order_date])
)
ON [ps_order_year] ([order_date])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =====================================================
-- Trigger
-- =====================================================

CREATE TRIGGER [sales].[trg_orders_audit]
ON [sales].[orders]
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
GO

ALTER TABLE [sales].[orders]
  ADD CONSTRAINT [fk_orders_customer] FOREIGN KEY ([customer_id]) REFERENCES [sales].[customers] ([customer_id])
GO

ALTER TABLE [sales].[orders]
  ADD CONSTRAINT [fk_orders_employee] FOREIGN KEY ([employee_id]) REFERENCES [hr].[employees] ([employee_id])
GO