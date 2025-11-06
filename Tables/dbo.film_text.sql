CREATE TABLE [dbo].[film_text] (
  [film_id] [smallint] NOT NULL,
  [title] [varchar](255) NOT NULL,
  [description] [text] NULL,
  PRIMARY KEY NONCLUSTERED ([film_id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO