CREATE TABLE [dbo].[Department_History] (
  [DepartmentNumber] [int] NOT NULL,
  [DepartmentName] [varchar](50) NOT NULL,
  [ManagerID] [int] NOT NULL,
  [TestXML] [xml] NULL,
  [TestSpatial] [geography] NULL,
  [ParentDepartmentNumber] [char](10) NULL,
  [SysStartTime] [datetime2] NOT NULL,
  [SysEndTime] [datetime2] NOT NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [ix_Department_History]
  ON [dbo].[Department_History] ([SysEndTime], [SysStartTime])
  ON [PRIMARY]
GO