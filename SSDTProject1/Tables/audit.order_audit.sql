CREATE TABLE [audit].[order_audit] (
  [audit_id] [int] IDENTITY,
  [order_id] [int] NULL,
  [action_type] [nvarchar](50) NULL,
  [action_date] [datetime2] NULL DEFAULT (sysdatetime()),
  PRIMARY KEY CLUSTERED ([audit_id])
)
ON [PRIMARY]
GO