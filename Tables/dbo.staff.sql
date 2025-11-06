CREATE TABLE [dbo].[staff] (
  [staff_id] [tinyint] IDENTITY,
  [first_name] [varchar](45) NOT NULL,
  [last_name] [varchar](45) NOT NULL,
  [address_id] [int] NOT NULL,
  [picture] [image] NULL DEFAULT (NULL),
  [email] [varchar](50) NULL DEFAULT (NULL),
  [store_id] [int] NOT NULL,
  [active] [bit] NOT NULL DEFAULT (1),
  [username] [varchar](16) NOT NULL,
  [password] [varchar](40) NULL DEFAULT (NULL),
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_staff_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([staff_id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [idx_fk_address_id]
  ON [dbo].[staff] ([address_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_store_id]
  ON [dbo].[staff] ([store_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[staff]
  ADD CONSTRAINT [fk_staff_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[staff]
  ADD CONSTRAINT [fk_staff_store] FOREIGN KEY ([store_id]) REFERENCES [dbo].[store] ([store_id]) ON UPDATE CASCADE
GO