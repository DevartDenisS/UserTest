CREATE TABLE [hr].[employees] (
  [employee_id] [int] IDENTITY,
  [first_name] [nvarchar](100) NOT NULL,
  [last_name] [nvarchar](100) NOT NULL,
  [email] [nvarchar](200) NULL,
  [phone_number] [dbo].[phone_type] NULL,
  [salary] [decimal](10, 2) NULL,
  [department_id] [int] NULL,
  [manager_id] [int] NULL,
  [created_at] [datetime2] NULL DEFAULT (sysdatetime()),
  [row_version] [timestamp],
  PRIMARY KEY CLUSTERED ([employee_id]),
  UNIQUE ([email]),
  CHECK ([salary]>(0))
)
ON [PRIMARY]
GO

CREATE INDEX [ix_employees_last_name]
  ON [hr].[employees] ([last_name])
  ON [PRIMARY]
GO

ALTER TABLE [hr].[employees]
  ADD CONSTRAINT [fk_employee_department] FOREIGN KEY ([department_id]) REFERENCES [hr].[departments] ([department_id])
GO

ALTER TABLE [hr].[employees]
  ADD CONSTRAINT [fk_employee_manager] FOREIGN KEY ([manager_id]) REFERENCES [hr].[employees] ([employee_id])
GO

EXEC sys.sp_addextendedproperty N'description', N'Employee master table', 'SCHEMA', N'hr', 'TABLE', N'employees'
GO