CREATE PARTITION SCHEME [ps_order_year]
  AS PARTITION [pf_order_year] ALL TO ([PRIMARY])
GO