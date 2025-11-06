CREATE TABLE [dbo].[film_actor] (
  [actor_id] [int] NOT NULL,
  [film_id] [int] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_film_actor_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([actor_id], [film_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_actor_actor]
  ON [dbo].[film_actor] ([actor_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_film_actor_film]
  ON [dbo].[film_actor] ([film_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[film_actor]
  ADD CONSTRAINT [fk_film_actor_actor] FOREIGN KEY ([actor_id]) REFERENCES [dbo].[actor] ([actor_id]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[film_actor]
  ADD CONSTRAINT [fk_film_actor_film] FOREIGN KEY ([film_id]) REFERENCES [dbo].[film] ([film_id]) ON UPDATE CASCADE
GO