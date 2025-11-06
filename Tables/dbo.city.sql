CREATE TABLE [dbo].[city] (
  [city_id] [int] IDENTITY,
  [city] [varchar](50) NOT NULL,
  [country_id] [smallint] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_city_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([city_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_country_id]
  ON [dbo].[city] ([country_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[city]
  ADD CONSTRAINT [fk_city_country] FOREIGN KEY ([country_id]) REFERENCES [dbo].[country] ([country_id]) ON UPDATE CASCADE
GO