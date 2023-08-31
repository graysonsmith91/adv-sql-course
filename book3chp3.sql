-- Stored procedure example

CREATE PROCEDURE insert_data(IN a varchar, INOUT b varchar)
LANGUAGE plpgsql
AS $$
BEGIN

INSERT INTO tbl(col) VALUES (a);
INSERT INTO tbl(col) VALUES (b);

END
$$;