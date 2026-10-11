-- Práctica 2 · Disparador 1
-- Al insertar o editar un comentario, marca endorsed = 'Y' si el usuario ha comprado
-- antes esa referencia y 'N' si no.

CREATE OR REPLACE TRIGGER tr_endorsed
    BEFORE
    INSERT OR UPDATE ON posts
    for each row
    DECLARE
       var_endorsed VARCHAR2(1);
    BEGIN
    -- Verificar si el usuario ha comprado el producto antes
    SELECT CASE
               WHEN EXISTS (
                   SELECT 1
                   FROM Client_Lines
                   WHERE username = :NEW.username
                   AND barcode = :NEW.barcode
               ) THEN 'Y' -- El producto ha sido comprado
               ELSE 'N' -- El producto no ha sido comprado
           END
    INTO var_endorsed
    FROM dual;

    dbms_output.put_line('checkpoint: ' || var_endorsed);

    -- Actualizar el campo "endorsed" en la tabla Posts
    :new.endorsed := var_endorsed;

END tr_endorsed;
/
