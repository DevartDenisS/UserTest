CREATE TABLE [dbo].[store] (
  [store_id] [int] IDENTITY,
  [manager_staff_id] [tinyint] NOT NULL,
  [address_id] [int] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_store_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([store_id])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [idx_fk_address_id]
  ON [dbo].[store] ([manager_staff_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_store_address]
  ON [dbo].[store] ([address_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[store]
  ADD CONSTRAINT [fk_store_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id])
GO

ALTER TABLE [dbo].[store]
  ADD CONSTRAINT [fk_store_staff] FOREIGN KEY ([manager_staff_id]) REFERENCES [dbo].[staff] ([staff_id])
GO