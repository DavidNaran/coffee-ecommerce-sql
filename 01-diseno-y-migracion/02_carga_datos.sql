-- Práctica 1 · Migración de datos
-- Carga el modelo nuevo a partir de las tres tablas de la base de datos antigua
-- (fsdb.catalogue, fsdb.trolley y fsdb.posts), que estaban sin normalizar.
-- Se ejecuta después de 01_creacion_tablas.sql.

-- TABLA PRODUCTO
INSERT INTO producto (nombre, coffea, varietal, origen, tostado, cafeina)
    SELECT DISTINCT
    product as nombre,
    coffea,
    varietal,
    origin as origen,
    roasting as tostado,
    decaf as cafeina
    FROM fsdb.catalogue WHERE
    product IS NOT NULL
    AND coffea IS NOT NULL
    AND varietal IS NOT NULL
    AND origin IS NOT NULL
    AND roasting IS NOT NULL
    AND decaf IS NOT NULL
    ;

--tabla cantidad
INSERT INTO cantidad (empaquetado, cantidad, magnitud)
    SELECT DISTINCT
    SUBSTR(packaging, 1, INSTR(packaging, ' ')) AS empaquetado,
    SUBSTR(packaging, INSTR(packaging, ' ') + 1, INSTR(packaging, ' ', 1, 2) - INSTR(packaging, ' ') - 1) AS cantidad,
    SUBSTR(packaging, INSTR(packaging, ' ', 1, 2) + 1, LENGTH(packaging) - INSTR(packaging, ' ', 1, 2) - 1) AS magnitud
    FROM fsdb.catalogue WHERE
    packaging IS NOT NULL
    ;

--tabla formatoProducto
INSERT INTO formatoProducto (idProducto, nombreForm, empaquetado, cantidad, magnitud)
    SELECT DISTINCT
    product as idProducto,
    format as nombreForm,
    SUBSTR(packaging, 1, INSTR(packaging, ' ')) AS empaquetado,
    SUBSTR(packaging, INSTR(packaging, ' ') + 1, INSTR(packaging, ' ', 1, 2) - INSTR(packaging, ' ') - 1) AS cantidad,
    SUBSTR(packaging, INSTR(packaging, ' ', 1, 2) + 1, LENGTH(packaging) - INSTR(packaging, ' ', 1, 2) - 1) AS magnitud
    FROM fsdb.catalogue WHERE
    product IS NOT NULL
    AND format IS NOT NULL
    AND packaging IS NOT NULL
    ;
--tabla articulo
INSERT INTO articulo (codigo_barra, producto, empaquetado, cantidad, magnitud, precio, stock, stock_min, stock_max)
    SELECT DISTINCT
    barcode as codigo_barra,
    product as producto,
    SUBSTR(packaging, 1, INSTR(packaging, ' ')) AS empaquetado,
    SUBSTR(packaging, INSTR(packaging, ' ') + 1, INSTR(packaging, ' ', 1, 2) - INSTR(packaging, ' ') - 1) AS cantidad,
    SUBSTR(packaging, INSTR(packaging, ' ', 1, 2) + 1, LENGTH(packaging) - INSTR(packaging, ' ', 1, 2) - 1) AS magnitud,
    retail_price as precio,
    cur_stock as stock,
    min_stock as stock_min,
    max_stock as stock_max
    FROM fsdb.catalogue WHERE
    barcode IS NOT NULL
    AND product IS NOT NULL
    AND packaging IS NOT NULL
    AND retail_price IS NOT NULL
    AND cur_stock IS NOT NULL
    AND min_stock IS NOT NULL
    AND max_stock IS NOT NULL
    ;
--tabla proveedor
INSERT INTO proveedor (nombre_registrado, cif, nombreComercial, email, telefono, cantidadPedidos, tiempoEntrega, cuentaBancaria, dirComer, pais)
    SELECT DISTINCT
    prov_person as nombre_registrado,
    prov_taxid as cif,
    supplier as nombreComercial,
    prov_email as email,
    prov_mobile as telefono,
    0 as cantidadPedidos,
    0 as tiempoEntrega,
    prov_bankacc as cuentaBancaria,
    prov_address as dirComer,
    prov_country as pais
    FROM fsdb.catalogue WHERE
    prov_person IS NOT NULL
    AND prov_taxid IS NOT NULL
    AND supplier IS NOT NULL
    AND prov_email IS NOT NULL
    AND prov_mobile IS NOT NULL
    AND prov_bankacc IS NOT NULL
    AND prov_address IS NOT NULL
    AND prov_country IS NOT NULL
    ;
--tabla proveedorArticulo
INSERT INTO proveedorArticulo(idArticulo, idProveedor, coste)
    SELECT DISTINCT
    barcode as idArticulo,
    prov_person as idProveedor,
    cost_price as coste
    FROM fsdb.catalogue WHERE
    barcode is not NULL
    AND prov_person is not NULL
    AND cost_price is not NULL
    ;
--tabla dirección
INSERT INTO direccion(idDireccion, tipo, nombre, numImueble, numBloq, escalera, piso, puerta, codigoPostal, ciudad, pais)
SELECT
    direccion_id_seq.NEXTVAL as idDireccion,
    tipo, nombre, numImueble, numBloq, escalera, piso, puerta, codigoPostal, ciudad, pais
FROM ( SELECT DISTINCT
        bill_waytype as tipo,
        bill_wayname as nombre,
        bill_gate as numImueble,
        bill_block as numBloq,
        bill_stairw as escalera,
        bill_floor as piso,
        bill_door as puerta,
        bill_zip as codigoPostal,
        bill_town as ciudad,
        bill_country as pais
    FROM fsdb.trolley
    WHERE bill_waytype IS NOT NULL
        AND bill_wayname IS NOT NULL
        AND bill_zip IS NOT NULL
        AND bill_town IS NOT NULL
        AND bill_country IS NOT NULL
    UNION
    SELECT DISTINCT
        dliv_waytype as tipo,
        dliv_wayname as nombre,
        dliv_gate as numImueble,
        dliv_block as numBloq,
        dliv_stairw as escalera,
        dliv_floor as piso,
        dliv_door as puerta,
        dliv_zip as codigoPostal,
        dliv_town as ciudad,
        dliv_country as pais
    FROM fsdb.trolley
    WHERE dliv_waytype IS NOT NULL
        AND dliv_wayname IS NOT NULL
        AND dliv_zip IS NOT NULL
        AND dliv_town IS NOT NULL
        AND dliv_country IS NOT NULL
);

--tabla tarjeta
INSERT INTO tarjeta(numTarjeta, titular, compania, fechaExp)
    SELECT DISTINCT
    card_number as numTarjeta,
    card_holder as titular,
    card_company as compania,
    card_expiratn as fechaExp
    FROM fsdb.trolley WHERE
    card_number is not NULL
    and card_holder is not NULL
    and card_company is not NULL
    and card_expiratn is not NULL
    ;
--tabla descuento
INSERT INTO descuento(porcentaje, fechaCaducidad)
    SELECT DISTINCT
    discount as porcentaje,
    NULL as fechaCaducidad
    FROM fsdb.trolley
    WHERE discount IS NOT NULL
    ;
--tabla clienteRegistrado
INSERT INTO clienteRegistrado(usuario, contraseña, fecha_reg, preferencia, porcentaje)
    SELECT DISTINCT
    username as usuario,
    user_passw as contraseña,
    TO_DATE(reg_date || ' ' || reg_time, 'YYYY / MM / DD HH:MI:SS AM') as fecha_reg,
    NULL as preferencia,
    discount as porcentaje
    FROM fsdb.trolley WHERE
    username IS NOT NULL
    AND user_passw IS NOT NULL
    AND discount IS NOT NULL
    ;
--tabla clienteDirección
INSERT INTO clienteDireccion(idCliente, idDireccion)
    SELECT DISTINCT
    username as usuario,
    d.idDireccion as idDireccion
    FROM fsdb.trolley t INNER JOIN direccion d ON t.dliv_waytype = d.tipo
    AND t.dliv_wayname = d.nombre
    AND t.dliv_zip = d.codigoPostal
    AND t.dliv_town = d.ciudad
    AND t.dliv_country = d.pais
    WHERE
    username IS NOT NULL
    AND user_passw IS NOT NULL
    AND dliv_waytype IS NOT NULL
    AND dliv_wayname IS NOT NULL
    AND dliv_zip IS NOT NULL
    AND dliv_town IS NOT NULL
    AND dliv_country IS NOT NULL
    ;
--tabla tarjetaCliente
INSERT INTO tarjetaCliente(numTarjeta, idCliente)
    SELECT DISTINCT
    card_number as numTarjeta,
    username as idCliente
    FROM fsdb.trolley
    WHERE card_number is not null
    and username is not null
    ;
--tabla pedidoCliente
INSERT INTO pedidoCliente(idPedido, correo, telefono, fecha, tipoPago, fechaPago, tarjeta, fechaEntrega, nombre, apellido1, apellido2, direccion)
    SELECT
    pedido_id_seq.NEXTVAL as idPedido,
    correo, telefono, fecha, tipoPago, fechaPago, tarjeta, fechaEntrega, nombre, apellido1, apellido2, direccion
    FROM (SELECT DISTINCT
    client_email as correo,
    client_mobile as telefono,
    TO_DATE(orderdate || ' ' || ordertime, 'YYYY / MM / DD HH:MI:SS AM') as fecha,
    payment_type as tipoPago,
    TO_DATE(payment_date || ' ' || payment_time, 'YYYY / MM / DD HH:MI:SS AM') as fechaPago,
    card_number as tarjeta,
    TO_DATE(dliv_date || ' ' || dliv_time, 'YYYY / MM / DD HH:MI:SS AM') as fechaEntrega,
    client_name as nombre,
    client_surn1 as apellido1,
    client_surn2 as apellido2,
    d.idDireccion as direccion
    FROM fsdb.trolley t INNER JOIN direccion d ON t.bill_waytype = d.tipo
    AND t.bill_wayname = d.nombre
    AND t.bill_zip = d.codigoPostal
    AND t.bill_town = d.ciudad
    AND t.bill_country = d.pais
    WHERE orderdate is not null
    and ordertime is not null
    and payment_type is not null
    and payment_date is not null
    and payment_time is not null
    and dliv_date is not null
    and dliv_time is not null
    and client_name is not null
    and client_surn1 is not null
    AND bill_waytype IS NOT NULL
    AND bill_wayname IS NOT NULL
    AND bill_zip IS NOT NULL
    AND bill_town IS NOT NULL
    AND bill_country IS NOT NULL
    );
--tabla pedidoClienteArticulo
 INSERT INTO pedidoClienteArticulo(idRegistrado, idPedido, idArticulo, unidad)
    SELECT DISTINCT
    username as idRegistrado,
    p.idPedido as idPedido,
    barcode as idArticulo,
    quantity as unidad
    from fsdb.trolley t inner join pedidoCliente p on t.client_name = p.nombre
    and t.client_surn1 = p.apellido1
    and t.payment_type = p.tipoPago
    and TO_DATE(t.payment_date || ' ' || t.payment_time, 'YYYY / MM / DD HH:MI:SS AM') = p.fechaPago
    and TO_DATE(t.orderdate || ' ' || t.ordertime, 'YYYY / MM / DD HH:MI:SS AM') = p.fecha
    and TO_DATE(t.dliv_date || ' ' || t.dliv_time, 'YYYY / MM / DD HH:MI:SS AM') = p.fechaEntrega
    inner join articulo a on t.barcode = a.codigo_barra
    where username is not null
    and client_name is not null
    and client_surn1 is not null
    and payment_type is not null
    and payment_date is not null
    and orderdate is not null
    and dliv_date is not null
    and barcode is not null
    and quantity is not null
    ;
--tabla reseña
INSERT INTO resena(cliente, articulo, producto, puntuacion, titulo, texto, fecha, meGusta, refrenda)
    SELECT DISTINCT
    username as cliente,
    barcode as articulo,
    product as producto,
    score as puntuacion,
    title as titulo,
    text as texto,
    TO_DATE(post_date || ' ' || post_time, 'YYYY / MM / DD HH:MI:SS AM') as fecha,
    likes as meGusta,
    endorsed as refrenda
    from fsdb.posts post inner join clienteRegistrado c on post.username = c.usuario
    inner join articulo a on post.barcode = a.codigo_barra
    inner join producto p on post.product = p.nombre
    where
    username is not null
    and product is not null
    and score is not null
    and title is not null
    and text is not null
    and post_date is not null
    and post_time is not null
    and likes is not null
    ;
