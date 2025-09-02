CREATE TABLE [dbo].[f_Ledger] (
  [prtId] [int] NOT NULL,
  [aKey] [int] NOT NULL,
  [cKey] [int] NOT NULL,
  [SomeData] [nvarchar](100) NULL
)
ON [prtId_Schema] ([prtId])
GO

CREATE INDEX [Idx_aKey]
  ON [dbo].[f_Ledger] ([prtId], [aKey])
  WITH (FILLFACTOR = 100)
  ON [prtId_Schema] ([prtId])
GO

CREATE INDEX [Idx_cKey]
  ON [dbo].[f_Ledger] ([prtId], [cKey])
  WITH (FILLFACTOR = 100)
  ON [prtId_Schema] ([prtId])
GO

CREATE INDEX [Idx_prt_aKey]
  ON [dbo].[f_Ledger] ([prtId], [aKey])
  WITH (FILLFACTOR = 100)
  ON [prtId_Schema] ([prtId])
GO