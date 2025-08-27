CREATE TABLE [dbo].[dm_order] (
  [order_id] [int] IDENTITY,
  [customer_id] [int] NOT NULL,
  [order_date] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([order_id])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[dm_order]
  ADD CONSTRAINT [fk_order_customer] FOREIGN KEY ([customer_id]) REFERENCES [dbo].[dm_customer] ([customer_id])
GO