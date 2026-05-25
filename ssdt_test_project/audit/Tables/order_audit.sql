CREATE TABLE [audit].[order_audit] (
    [audit_id]    INT           IDENTITY (1, 1) NOT NULL,
    [order_id]    INT           NULL,
    [action_type] NVARCHAR (50) NULL,
    [action_date] DATETIME2 (7) DEFAULT (sysdatetime()) NULL,
    PRIMARY KEY CLUSTERED ([audit_id] ASC)
);

