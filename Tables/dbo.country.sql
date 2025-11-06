CREATE TABLE [dbo].[country] (
  [country_id] [smallint] IDENTITY,
  [country] [varchar](50) NOT NULL,
  [last_update] [datetime] NULL CONSTRAINT [DF_country_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([country_id])
)
ON [PRIMARY]
GO