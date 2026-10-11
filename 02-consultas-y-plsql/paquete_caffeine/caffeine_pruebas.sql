-- Práctica 2 · Datos de prueba del paquete caffeine
-- Inserta dos proveedores, tres referencias y sus pedidos de reposición.
-- Las fechas están escritas como día/mes/año (NLS_DATE_FORMAT = 'DD/MM/YYYY').

Insert into Varietals(name) values ('Arabica');

Insert into Origins (name) values ('Italy');

INSERT INTO Products (product, coffea, varietal, origin, roast, decaf)
VALUES ('Italian Espresso', 'A', 'Robusta', 'Italy', 'B', 'N');

INSERT INTO Products (product, coffea, varietal, origin, roast, decaf)
VALUES ('Colombian Supremo', 'A', 'Arabica', 'Colombia', 'N', 'N');

INSERT INTO Products (product, coffea, varietal, origin, roast, decaf)
VALUES ('French Vanilla Roast', 'C', 'Arabica', 'Indonesia', 'H', 'Y');

INSERT INTO Providers (taxID, name, person, email, mobile, bankAcc, address, country)
VALUES ('SP-1234', 'Ita.Coffee Company', 'Maria Rossi', 'mrossi@italiancoffee.com', 673734637, 'IT01A12345678901234', 'Via Roma, 100 - Rome', 'Italy');

INSERT INTO Providers (taxID, name, person, email, mobile, bankAcc, address, country)
VALUES ('CO-9876', 'Colombian Coffee Farmers', 'Juan Valdez', 'jvaldez@colombiancoffee.com', 573123456, 'CO FIDUCODE XXXXXXX', 'Calle 10 #5-21, Bogota', 'Colombia');

INSERT INTO References (barCode, product, format, pack_type, pack_unit, quantity, price, cur_stock, min_stock, max_stock)
VALUES ('CFF-001', 'Italian Espresso', 'C', 'Jar', '250g', 20, 7.99, 15, 10, 20);

INSERT INTO References (barCode, product, format, pack_type, pack_unit, quantity, price, cur_stock, min_stock, max_stock)
VALUES ('CFF-002', 'Colombian Supremo', 'G', 'Bag', '1kg', 10, 19.99, 8, 5, 15);

INSERT INTO References (barCode, product, format, pack_type, pack_unit, quantity, price, cur_stock, min_stock, max_stock)
VALUES ('CFF-003', 'French Vanilla Roast', 'B', 'Box', '10 x 250g', 20, 9.99, 12, 8, 18);

/*supply_lines SP-1234*/
INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('SP-1234', 'CFF-001', 6.50);

INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('SP-1234', 'CFF-003', 7.25);

INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('SP-1234', 'CFF-002', 13.99);

/*Supply_lynes CO-9876*/
INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('CO-9876', 'CFF-002', 15.49);

INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('CO-9876', 'CFF-001', 8.75);

INSERT INTO Supply_Lines (taxID, barCode, cost)
VALUES ('CO-9876', 'CFF-003', 5.99);

/*se prueba el primer proceso*/
INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-003', '2/8/2023', 'D', 2, NULL, 13.79);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-002', '30/1/2023', 'D', 2, NULL, 13.79);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-001', '22/2/2024', 'D', 5, NULL, 90.20);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-003', '3/12/2022', 'D', 5, NULL, 90.20);

/*se prueba el segundo proceso*/

/*proveedor SP-1234*/
INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-002', '4/1/2024', 'P', 5, '8/1/2024', 90.20);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-002', '21/10/2023', 'P', 3, '27/10/2023', 31.55);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-002', '15/8/2023', 'P', 2, '25/8/2023', 24.15);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-003', '10/2/2024', 'P', 5, '13/2/2024', 34.50);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-003', '1/12/2023', 'P', 2, '6/12/2023', 16.20);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-003', '4/3/2024', 'P', 8 , '6/3/2024', 58.00);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-001', '8/9/2023', 'P', 2, '11/9/2023', 15.95);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-001', '27/11/2023', 'P', 6, '1/12/2023', 33.00);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('SP-1234', 'CFF-001', '1/1/2024', 'P', 1, '10/1/2024', 7.25);

/*proveedor CO-9876*/
INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-001', '20/3/2024', 'P', 3, '25/3/2024', 23.97);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-001', '2/10/2023', 'P', 1, '12/10/2023', 9.99);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-001', '28/1/2024', 'P', 5, '1/2/2024', 41.25);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-002', '14/11/2023', 'P', 1, '17/11/2023', 17.69);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-002', '7/9/2023', 'P', 6, '9/9/2023', 79.20);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-003', '20/8/2023', 'P', 2, '23/8/2023', 13.79);

INSERT INTO Replacements (taxID, barCode, orderdate, status, units, deldate, payment)
VALUES ('CO-9876', 'CFF-003', '16/3/2024', 'P', 1, '17/3/2024', 6.5);
