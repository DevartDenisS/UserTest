CREATE TABLE [dbo].[t_masked_column] (
  [id] [int] IDENTITY,
  [account_number] [varchar](30) MASKED WITH (FUNCTION = 'default()') NULL,
  [account_id] [int] NOT NULL,
  [update_time] [datetime] NOT NULL
)
GO