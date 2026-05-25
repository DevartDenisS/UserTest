CREATE TABLE [sales].[customers] (
    [customer_id]     UNIQUEIDENTIFIER                         DEFAULT (newid()) NOT NULL,
    [customer_name]   NVARCHAR (200)                           NOT NULL,
    [customer_status] [dbo].[status_type]                      DEFAULT ('ACTIVE') NOT NULL,
    [customer_xml]    XML(CONTENT [dbo].[customer_xml_schema]) NULL,
    [notes]           NVARCHAR (MAX)                           NULL,
    [created_date]    DATE                                     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([customer_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_customers_name]
    ON [sales].[customers]([customer_name] ASC);

