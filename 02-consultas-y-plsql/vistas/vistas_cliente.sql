-- Práctica 2 · Vistas del perfil de cliente
-- El paquete usuario guarda quién es el usuario actual. Sobre él se definen tres vistas:
-- mis_compras y mi_perfil (solo lectura) y mis_comentarios, que se puede modificar y
-- borrar mediante dos disparadores INSTEAD OF (solo si el comentario tiene cero likes).

CREATE OR REPLACE package usuario AS
    PROCEDURE UsuarioActual(username in VARCHAR2);
    FUNCTION ObtenerUsuario RETURN VARCHAR2;
END usuario;
/

CREATE OR REPLACE package body usuario AS
    current_user VARCHAR2(60);
    PROCEDURE UsuarioActual(username in VARCHAR2) IS
    BEGIN
        current_user := username;
    END UsuarioActual;
    FUNCTION ObtenerUsuario RETURN VARCHAR2 IS
    BEGIN
        RETURN current_user;
    END ObtenerUsuario;
END usuario;
/

CREATE OR REPLACE view mis_compras as (
    select * from (select contact as username, orderdate, barcode, price, quantity, pay_type from lines_anonym
                    union
                    select username, orderdate, barcode, price, TO_NUMBER(quantity), pay_type from client_lines)
    where username = usuario.obtenerusuario
);

CREATE OR REPLACE view mi_perfil as (
	select * from (select contact as username, NULL as user_passw, name, surn1, surn2, NULL as email, NULL as mobile, bill_waytype as waytype, bill_wayname as wayname, bill_gate as gate, bill_block as block, bill_stairw as stairw, bill_floor as floor, bill_door as door, bill_ZIP as ZIP, bill_town as town, bill_country as country, card_num as cardnum, card_comp, card_holder, card_expir
					from (select l.contact, card_comp, card_num, card_holder, card_expir, name, surn1, surn2, bill_waytype, bill_wayname, bill_gate, bill_block, bill_stairw, bill_floor, bill_door, bill_ZIP, bill_town, bill_country
					    from
    					lines_anonym l
	    				join
		    			orders_anonym o
			    		on
				    	l.orderdate = o.orderdate
		    			and
			    		l.contact = o.contact)
					union
					select * from (select cc.username, user_passw, name, surn1, surn2, email, mobile, waytype, wayname, gate, block, stairw, floor, door, ZIP, town, country, cardnum, card_comp, card_holder, card_expir
						            from
        		        				(select c.username, user_passw, name, surn1, surn2, email, mobile, waytype, wayname, gate, block, stairw, floor, door, ZIP, town, country
	    		        				from
		        		    			clients c
		    	    		    		join
	    			    		    	client_addresses ca
    					    		    on
						        	    c.username = ca.username) dc
	           		    			join
		    			    	    client_cards cc
			    		        	on
				        		    dc.username = cc.username))
	where username = usuario.obtenerusuario
);

CREATE OR REPLACE view mis_comentarios as (
    select * from posts where username = usuario.obtenerusuario);

CREATE OR REPLACE TRIGGER tr_mis_comentarios_update
    INSTEAD OF
    UPDATE ON mis_comentarios
    for each row
    DECLARE
        too_many_likes exception;
        other_exception exception;
    BEGIN
        IF :new.username != :old.username or :new.postdate != :old.postdate or :new.barcode != :old.barcode or :new.product != :old.product or :new.score != :old.score
         or :new.title != :old.title or :new.likes != :old.likes or :new.endorsed != :old.endorsed then raise other_exception;
         END IF;
        IF :new.likes > 0 THEN raise too_many_likes;
        END IF;
		update posts set text = :new.text where username = usuario.obtenerusuario and likes = 0 and score = :old.score and postdate = :old.postdate and
												barcode = :old.barcode and product = :old.product and title = :old.title and endorsed = :old.endorsed;
    exception
        WHEN too_many_likes then raise_application_error(-20001, 'NO PUEDES ELIMINAR NI MODIFICAR UN COMENTARIO CON MÁS DE 0 LIKES');
        WHEN other_exception then raise_application_error(-20001, 'NO PUEDES MODIFICAR ESTE ATRIBUTO');
    END tr_mis_comentarios_update;
/

CREATE OR REPLACE TRIGGER tr_mis_comentarios_delete
    INSTEAD OF
    DELETE ON mis_comentarios
    for each row
    DECLARE
        too_many_likes exception;
        other_exception exception;
    BEGIN
        IF :old.likes > 0 THEN raise too_many_likes;
        END IF;
		delete from posts where username = usuario.obtenerusuario and likes = 0 and score = :old.score /*and postdate = :old.postdate and
								barcode = :old.barcode and product = :old.product and title = :old.title and endorsed = :old.endorsed*/;
    exception
        WHEN too_many_likes then raise_application_error(-20001, 'NO PUEDES ELIMINAR NI MODIFICAR UN COMENTARIO CON MÁS DE 0 LIKES');
        WHEN other_exception then raise_application_error(-20001, 'NO PUEDES MODIFICAR ESTE ATRIBUTO');
    END tr_mis_comentarios_delete;
/
