CREATE TABLE [dbo].[Department] (
  [DepartmentNumber] [int] NOT NULL,
  [DepartmentName] [varchar](50) NOT NULL,
  [ManagerID] [int] NOT NULL,
  [TestXML] [xml] NULL,
  [TestSpatial] [geography] NULL,
  [ParentDepartmentNumber] [char](10) NULL,
  [SysStartTime] [datetime2] GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
  [SysEndTime] [datetime2] GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
  PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
  CONSTRAINT [PK_Department_Number] PRIMARY KEY CLUSTERED ([DepartmentNumber])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[Department_History], DATA_CONSISTENCY_CHECK = ON))
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- Создание/удаление TRIGGER
CREATE TRIGGER [dbo].[TestTrigger] ON [dbo].[Department] FOR INSERT AS BEGIN PRINT 'Test'END;  
DROP TRIGGER TestTrigger;
GO