CREATE TABLE [dbo].[table_PK] (
  [uk] [int] NOT NULL,
  [c1] [int] NULL,
  [c2] [nvarchar](50) NOT NULL DEFAULT ('Test'),
  PRIMARY KEY CLUSTERED ([uk])
)
ON [PRIMARY]
GO