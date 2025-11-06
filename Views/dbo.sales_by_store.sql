SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--
-- View structure for view sales_by_store
--

CREATE VIEW [dbo].[sales_by_store]
AS
SELECT
  s.store_id
 ,c.city+','+cy.country AS store
 ,m.first_name+' '+ m.last_name AS manager
 ,SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS cy ON c.country_id = cy.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY   
  s.store_id
, c.city+ ','+cy.country 
, m.first_name+' '+ m.last_name
GO