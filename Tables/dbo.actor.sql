CREATE TABLE [dbo].[actor] (
  [actor_id] [int] IDENTITY,
  [first_name] [varchar](45) NOT NULL,
  [last_name] [varchar](45) NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_actor_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([actor_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_actor_last_name]
  ON [dbo].[actor] ([last_name])
  ON [PRIMARY]
GO