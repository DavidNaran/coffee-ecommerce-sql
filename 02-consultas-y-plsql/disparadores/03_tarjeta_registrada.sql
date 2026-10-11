-- Práctica 2 · Disparador 3
-- Impide una compra anónima con una tarjeta que ya está guardada para un cliente registrado.

CREATE OR REPLACE TRIGGER tr_card_number
    BEFORE
    INSERT ON lines_anonym
    for each row
    DECLARE
       bad_cardnum exception;
       tarjeta_exist number;
    BEGIN
    -- Verificar si algun usuario tiene ya la tarjeta de crédito

    select count('x') into tarjeta_exist
    from Client_Cards
    where cardnum = :new.card_num;

    dbms_output.put_line('checkpoint: ' || tarjeta_exist);

    if tarjeta_exist = 1 then raise bad_cardnum;
    end if;
    EXCEPTION
        WHEN bad_cardnum then raise_application_error(-20001, 'La tarjeta de crédito está registrada para un cliente');

END tr_card_number;
/
