CREATE TABLE [dbo].[payment] (
  [payment_id] [int] IDENTITY,
  [customer_id] [int] NOT NULL,
  [staff_id] [tinyint] NOT NULL,
  [rental_id] [int] NULL DEFAULT (NULL),
  [amount] [decimal](5, 2) NOT NULL,
  [payment_date] [datetime] NOT NULL,
  [last_update] [datetime] NOT NULL CONSTRAINT [DF_payment_last_update] DEFAULT (getdate()),
  PRIMARY KEY NONCLUSTERED ([payment_id])
)
ON [PRIMARY]
GO

CREATE INDEX [idx_fk_customer_id]
  ON [dbo].[payment] ([customer_id])
  ON [PRIMARY]
GO

CREATE INDEX [idx_fk_staff_id]
  ON [dbo].[payment] ([staff_id])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[payment]
  ADD CONSTRAINT [fk_payment_customer] FOREIGN KEY ([customer_id]) REFERENCES [dbo].[customer] ([customer_id])
GO

ALTER TABLE [dbo].[payment]
  ADD CONSTRAINT [fk_payment_rental] FOREIGN KEY ([rental_id]) REFERENCES [dbo].[rental] ([rental_id]) ON DELETE SET NULL ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[payment]
  ADD CONSTRAINT [fk_payment_staff] FOREIGN KEY ([staff_id]) REFERENCES [dbo].[staff] ([staff_id])
GO