CREATE TABLE [dbo].[dm_customer] (
  [customer_id] [int] IDENTITY,
  [first_name] [nvarchar](50) NOT NULL,
  [last_name] [nvarchar](50) NOT NULL,
  [email] [nvarchar](100) NULL,
  PRIMARY KEY CLUSTERED ([customer_id]),
  UNIQUE ([email])
)
ON [PRIMARY]
GO