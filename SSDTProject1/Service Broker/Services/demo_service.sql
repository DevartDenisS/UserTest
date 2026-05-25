CREATE SERVICE [demo_service]
ON QUEUE [dbo].[demo_queue] (
  [demo_contract]
)
GO