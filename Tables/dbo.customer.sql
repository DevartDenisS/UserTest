CREATE TABLE [dbo].[customer] (
  [customer_id] [int] IDENTITY,
  [store_id] [int] NOT NULL,
  [first_name] [varchar](45) NOT NULL,
  [last_name] [varchar](45) NOT NULL,
  [email] [varchar](50) NULL DEFAULT (NULL),
  [address_id] [int] NOT NULL,
  [active] [char](1) NOT NULL DEFAULT ('Y'),
  [create_date] [datetime] NOT NULL CONSTRAINT [DF_customer_create_date] DEFAULT (getdate()),
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_customer_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([customer_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_address_id]
  ON [dbo].[customer] ([address_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_store_id]
  ON [dbo].[customer] ([store_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_last_name]
  ON [dbo].[customer] ([last_name])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[customer]
  ADD CONSTRAINT [fk_customer_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[customer]
  ADD CONSTRAINT [fk_customer_store] FOREIGN KEY ([store_id]) REFERENCES [dbo].[store] ([store_id]) ON UPDATE CASCADE
GO