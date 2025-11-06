CREATE TABLE [dbo].[address] (
  [address_id] [int] IDENTITY,
  [address] [varchar](50) NOT NULL,
  [address2] [varchar](50) NULL DEFAULT (NULL),
  [district] [varchar](20) NOT NULL,
  [city_id] [int] NOT NULL,
  [postal_code] [varchar](10) NULL DEFAULT (NULL),
  [phone] [varchar](20) NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_address_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([address_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_city_id]
  ON [dbo].[address] ([city_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[address]
  ADD CONSTRAINT [fk_address_city] FOREIGN KEY ([city_id]) REFERENCES [dbo].[city] ([city_id]) ON UPDATE CASCADE
GO