CREATE TABLE [dbo].[dm_product] (
  [product_id] [int] IDENTITY,
  [product_name] [nvarchar](100) NOT NULL,
  [price] [decimal](10, 2) NOT NULL,
  PRIMARY KEY CLUSTERED ([product_id])
)
ON [PRIMARY]
GO