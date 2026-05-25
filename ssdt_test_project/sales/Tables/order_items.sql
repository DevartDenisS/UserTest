CREATE TABLE [sales].[order_items] (
  [order_item_id] [int] IDENTITY,
  [order_id] [int] NOT NULL,
  [product_name] [nvarchar](200) NULL,
  [quantity] [int] NULL,
  [price] [decimal](10, 2) NULL,
  PRIMARY KEY CLUSTERED ([order_item_id]),
  CONSTRAINT [chk_quantity] CHECK ([quantity]>(0))
)
ON [PRIMARY]
GO

CREATE COLUMNSTORE INDEX [ix_order_items_columnstore]
  ON [sales].[order_items] ([product_name], [quantity], [price])
GO

;