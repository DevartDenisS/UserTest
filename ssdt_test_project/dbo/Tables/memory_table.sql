CREATE TABLE [dbo].[memory_table] (
    [id]         INT            NOT NULL,
    [value_text] NVARCHAR (100) NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC)
)
WITH (MEMORY_OPTIMIZED = ON);

