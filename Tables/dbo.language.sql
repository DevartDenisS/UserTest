CREATE TABLE [dbo].[language] (
  [language_id] [tinyint] IDENTITY,
  [name] [char](20) NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_language_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([language_id])
)
ON [PRIMARY]
GO