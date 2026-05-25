CREATE PARTITION SCHEME [ps_order_year]
    AS PARTITION [pf_order_year]
    TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);

