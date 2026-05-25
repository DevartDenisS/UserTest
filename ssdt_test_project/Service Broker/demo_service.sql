CREATE SERVICE [demo_service]
    AUTHORIZATION [dbo]
    ON QUEUE [dbo].[demo_queue]
    ([demo_contract]);

