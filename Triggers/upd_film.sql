DELIMITER $$

CREATE TRIGGER `upd_film`
	AFTER UPDATE
	ON film
	FOR EACH ROW
BEGIN
    IF (old.title != new.title) or (old.description != new.description)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
$$

DELIMITER ;