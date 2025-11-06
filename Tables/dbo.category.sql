CREATE TABLE [dbo].[category] (
  [category_id] [tinyint] IDENTITY,
  [name] [varchar](25) NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_category_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([category_id])
)
ON [PRIMARY]
GO