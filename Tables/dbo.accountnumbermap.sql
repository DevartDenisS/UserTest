CREATE TABLE [dbo].[accountnumbermap] (
  [id] [int] IDENTITY,
  [account_number] [varchar](30) NOT NULL,
  [account_id] [int] NOT NULL,
  [accountnumbertype_id] [int] NULL,
  [update_time] [datetime] NOT NULL DEFAULT (suser_sname()),
  [update_by] [varchar](35) NULL DEFAULT (suser_sname()),
  CONSTRAINT [pk__accountn__3213e83f45b4effa] PRIMARY KEY CLUSTERED ([id])
)
GO