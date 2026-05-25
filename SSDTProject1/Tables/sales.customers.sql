CREATE TABLE [sales].[customers] (
  [customer_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
  [customer_name] [nvarchar](200) NOT NULL,
  [customer_status] [dbo].[status_type] NOT NULL DEFAULT ('ACTIVE'),
  [customer_xml] [xml] (CONTENT dbo.customer_xml_schema) NULL,
  [notes] [nvarchar](max) NULL,
  [created_date] [date] NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([customer_id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [ix_customers_name]
  ON [sales].[customers] ([customer_name])
  ON [PRIMARY]
GO