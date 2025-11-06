CREATE TABLE [dbo].[film_category] (
  [film_id] [int] NOT NULL,
  [category_id] [tinyint] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_film_category_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([film_id], [category_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_category_category]
  ON [dbo].[film_category] ([category_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_category_film]
  ON [dbo].[film_category] ([film_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[film_category]
  ADD CONSTRAINT [fk_film_category_category] FOREIGN KEY ([category_id]) REFERENCES [dbo].[category] ([category_id]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[film_category]
  ADD CONSTRAINT [fk_film_category_film] FOREIGN KEY ([film_id]) REFERENCES [dbo].[film] ([film_id]) ON UPDATE CASCADE
GO