-- Práctica 2 · Pruebas del disparador 1

insert into posts(username, postdate, product, barcode, score, text) values('apolo', '06/04/2024', 'Principio triunfo', 'QIQ88969I514506',4, 'texto de prueba');
update posts set text = 'updatetext' where username = usuario.obtenerusuario and score = 3;

INSERT INTO References (barcode, product, format, pack_type, pack_unit, quantity, price, cur_stock, min_stock, max_stock)
VALUES ('OQO29111I322078', 'Senora burror', 'C', 'Caja', 'Unidad', 100, 10.99, 50, 5, 100);

INSERT INTO Posts (username, postdate, barcode, product, score, title, text, likes, endorsed)
VALUES ('apolo', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'OQO29111I322078', 'Senora burro', 4, 'Título del post', 'BUEN PRODUCTO', 0, NULL);
