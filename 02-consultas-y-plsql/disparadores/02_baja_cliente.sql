-- Práctica 2 · Disparador 2
-- Cuando se da de baja un cliente, traslada sus pedidos, sus líneas de pedido y sus
-- comentarios a las tablas anónimas.

CREATE OR REPLACE TRIGGER cliente_baja
AFTER DELETE ON clients
FOR EACH ROW
BEGIN
    INSERT INTO orders_anonym (orderdate, contact, contact2, dliv_datetime, name, surn1,
                                surn2, bill_waytype, bill_wayname, bill_gate, bill_block,
                                bill_stairw, bill_floor, bill_door, bill_ZIP, bill_town,
                                bill_country, dliv_waytype, dliv_wayname, dliv_gate, dliv_block,
                                dliv_stairw, dliv_floor, dliv_door, dliv_ZIP, dliv_town, dliv_country)
    select orderdate, case when :old.email is not null then :old.email else TO_CHAR(:old.mobile) end as contact, :old.mobile as contact2,
            dliv_datetime, :old.name, :old.surn1, :old.surn2, '0', '0', '0', '0', '0', '0', '0', '0', bill_town, bill_country, '0', '0', '0', '0', '0', '0', '0', '0', town, country
	from
	orders_clients
	where username = :old.username;

    INSERT INTO lines_anonym (orderdate, contact, dliv_town, dliv_country, barcode, price, quantity, pay_type, pay_datetime,
                                card_comp, card_num, card_holder, card_expir)
    select orderdate, case when :old.email is not null then :old.email else TO_CHAR(:old.mobile) end as contact, town, country, barcode, price, TO_NUMBER(quantity),
            pay_type, pay_datetime, '0', cardnum, '0', sysdate
    from
	client_lines
	where username = :old.username;

    INSERT INTO AnonyPosts (postdate, barCode, product, score, title, text, likes, endorsed)
    select postdate, barCode, product, score, title, text, likes, endorsed
    from posts
    where username = :old.username;

    DELETE FROM orders_clients where username = :old.username;
    DELETE FROM client_lines where username = :old.username;
    DELETE FROM posts where username = :old.username;
END;
/
