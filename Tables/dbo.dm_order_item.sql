CREATE TABLE [dbo].[dm_order_item] (
  [order_item_id] [int] IDENTITY,
  [order_id] [int] NOT NULL,
  [product_id] [int] NOT NULL,
  [quantity] [int] NOT NULL,
  PRIMARY KEY CLUSTERED ([order_item_id])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[dm_order_item]
  ADD CONSTRAINT [fk_orderitem_order] FOREIGN KEY ([order_id]) REFERENCES [dbo].[dm_order] ([order_id])
GO

ALTER TABLE [dbo].[dm_order_item]
  ADD CONSTRAINT [fk_orderitem_product] FOREIGN KEY ([product_id]) REFERENCES [dbo].[dm_product] ([product_id])
GO