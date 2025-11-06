CREATE TABLE [dbo].[inventory] (
  [inventory_id] [int] IDENTITY,
  [film_id] [int] NOT NULL,
  [store_id] [int] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_inventory_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([inventory_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_id]
  ON [dbo].[inventory] ([film_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_id_store_id]
  ON [dbo].[inventory] ([store_id], [film_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[inventory]
  ADD CONSTRAINT [fk_inventory_film] FOREIGN KEY ([film_id]) REFERENCES [dbo].[film] ([film_id]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[inventory]
  ADD CONSTRAINT [fk_inventory_store] FOREIGN KEY ([store_id]) REFERENCES [dbo].[store] ([store_id]) ON UPDATE CASCADE
GO