-- Práctica 2 · Pruebas del disparador 4
-- Crea una referencia con stock 50 y mínimo 10, registra una compra de 42 unidades y
-- comprueba el stock y el borrador de reposición. Al final borra los datos de prueba.

-- Insertar un nuevo producto en la tabla Varietals
INSERT INTO Varietals (name) VALUES ('NombreVarietal');

-- Insertar un nuevo origen en la tabla Origins (si no existe)
INSERT INTO Origins (name) VALUES ('NombreOrigen');

-- Insertar un nuevo producto en la tabla Products
INSERT INTO Products (product, coffea, varietal, origin, roast, decaf)
VALUES ('NombreProducto', 'A', 'NombreVarietal', 'NombreOrigen', 'N', 'N');

-- Insertar una nueva fila en la tabla References
INSERT INTO References (barcode, product, format, pack_type, pack_unit, quantity, price, cur_stock, min_stock, max_stock)
VALUES ('1234567890123', 'NombreProducto', 'C', 'TipoPack', 'UnidadPack', 100, 10.99, 50, 10, 100);

-- Insertar un nuevo proveedor en la tabla Providers
INSERT INTO Providers (taxID, name, person, email, mobile, address, country)
VALUES ('5544', 'NombreProveedor', 'PersonaContacto', 'correo@proveedor.com', 123456789, 'DirecciónProveedor', 'PaísProveedor');

-- Insertar una nueva línea de suministro en la tabla Supply_Lines
INSERT INTO Supply_Lines (taxID, barcode, cost)
VALUES ('5544', '1234567890123', 8.99);

/*Ahora se inserta un nuevo cliente para la prueba*/
INSERT INTO Clients (username, reg_datetime, user_passw, name, surn1, email, mobile)
VALUES ('cliente1', SYSDATE, 'password123', 'Juan', 'Pérez', 'juan@example.com', 123456789);

/*También es necesario insertar una dirrección*/
INSERT INTO Client_Addresses (username, waytype, wayname, ZIP, town, country)
VALUES ('cliente1', 'Calle', 'Ejemplo 123', '12345', 'Ciudad', 'País');

/*Además de una tarjeta de credito*/
INSERT INTO Client_Cards (cardnum, username, card_comp, card_holder, card_expir)
VALUES (1234567890123456, 'cliente1', 'VISA', 'Juan Pérez', TO_DATE('01-01-2025', 'DD-MM-YYYY'));

/*se inserta una dirreccion de cliente*/
INSERT INTO Orders_Clients (orderdate, username, town, country, dliv_datetime, bill_town, bill_country)
VALUES ('8/4/24', 'cliente1', 'Ciudad', 'País', SYSDATE, 'Ciudad', 'País');

/*y por último se inserta el pedido*/
INSERT INTO Client_Lines (orderdate, username, town, country, barcode, price, quantity, pay_type, pay_datetime, cardnum)
VALUES (
    '8/4/24',
    'cliente1',
    'Ciudad',
    'País',
    '1234567890123',
    10.99,
    '42',
    'Efectivo',
    SYSDATE,
    NULL
);

select * from Replacements where barCode = '1234567890123';
select * from References where barCode = '1234567890123';
select * from Client_Lines where barcode = '1234567890123';

delete from Replacements where barCode = '1234567890123';
delete from Client_Lines where barCode = '1234567890123';
delete from Orders_Clients where username = 'cliente1';
delete from Client_Cards where cardnum = 1234567890123456;
delete from Client_Addresses where username = 'cliente1';
delete from Clients where username = 'cliente1';
delete from Supply_Lines where taxID = '5544' and barCode = '1234567890123';
delete from Providers where taxID = '5544';
delete from References where barCode = '1234567890123';
delete from Products where product = 'NombreProducto';
delete from Origins where name = 'NombreOrigen';
delete from Varietals where name = 'NombreVarietal';
