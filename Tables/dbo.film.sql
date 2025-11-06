CREATE TABLE [dbo].[film] (
  [film_id] [int] IDENTITY,
  [title] [varchar](255) NOT NULL,
  [description] [text] NULL DEFAULT (NULL),
  [release_year] [varchar](4) NULL,
  [language_id] [tinyint] NOT NULL,
  [original_language_id] [tinyint] NULL DEFAULT (NULL),
  [rental_duration] [tinyint] NOT NULL DEFAULT (3),
  [rental_rate] [decimal](4, 2) NOT NULL DEFAULT (4.99),
  [length] [smallint] NULL DEFAULT (NULL),
  [replacement_cost] [decimal](5, 2) NOT NULL DEFAULT (19.99),
  [rating] [varchar](10) NULL DEFAULT ('G'),
  [special_features] [varchar](255) NULL DEFAULT (NULL),
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_film_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([film_id]),
  CONSTRAINT [CHECK_special_features] CHECK ([special_features] IS NULL OR [special_features] like '%Trailers%' OR [special_features] like '%Commentaries%' OR [special_features] like '%Deleted Scenes%' OR [special_features] like '%Behind the Scenes%'),
  CONSTRAINT [CHECK_special_rating] CHECK ([rating]='NC-17' OR [rating]='R' OR [rating]='PG-13' OR [rating]='PG' OR [rating]='G')
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [idx_fk_language_id]
  ON [dbo].[film] ([language_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_original_language_id]
  ON [dbo].[film] ([original_language_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[film]
  ADD CONSTRAINT [fk_film_language] FOREIGN KEY ([language_id]) REFERENCES [dbo].[language] ([language_id])
GO

ALTER TABLE [dbo].[film]
  ADD CONSTRAINT [fk_film_language_original] FOREIGN KEY ([original_language_id]) REFERENCES [dbo].[language] ([language_id])
GO