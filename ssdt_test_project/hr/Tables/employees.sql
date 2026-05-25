CREATE TABLE [hr].[employees] (
    [employee_id]   INT                IDENTITY (1, 1) NOT NULL,
    [first_name]    NVARCHAR (100)     NOT NULL,
    [last_name]     NVARCHAR (100)     NOT NULL,
    [email]         NVARCHAR (200)     NULL,
    [phone_number]  [dbo].[phone_type] NULL,
    [salary]        DECIMAL (10, 2)    NULL,
    [department_id] INT                NULL,
    [manager_id]    INT                NULL,
    [created_at]    DATETIME2 (7)      DEFAULT (sysdatetime()) NULL,
    [row_version]   ROWVERSION         NOT NULL,
    PRIMARY KEY CLUSTERED ([employee_id] ASC),
    CHECK ([salary]>(0)),
    CONSTRAINT [fk_employee_department] FOREIGN KEY ([department_id]) REFERENCES [hr].[departments] ([department_id]),
    CONSTRAINT [fk_employee_manager] FOREIGN KEY ([manager_id]) REFERENCES [hr].[employees] ([employee_id]),
    UNIQUE NONCLUSTERED ([email] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_employees_last_name]
    ON [hr].[employees]([last_name] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'description', @value = N'Employee master table', @level0type = N'SCHEMA', @level0name = N'hr', @level1type = N'TABLE', @level1name = N'employees';

