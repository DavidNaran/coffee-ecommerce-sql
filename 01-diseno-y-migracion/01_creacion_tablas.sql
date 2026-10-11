-- Práctica 1 · Diseño relacional
-- Crea las 16 tablas y las 2 secuencias del modelo propio (Oracle).
-- Las primeras sentencias borran las tablas de una ejecución anterior.

DROP TABLE resena CASCADE CONSTRAINT;
DROP TABLE pedidoClienteArticulo CASCADE CONSTRAINT;
DROP TABLE pedidoCliente CASCADE CONSTRAINT;
DROP SEQUENCE pedido_id_seq;
DROP TABLE clienteDireccion CASCADE CONSTRAINT;
DROP TABLE tarjetaCliente CASCADE CONSTRAINT;
DROP TABLE tarjeta CASCADE CONSTRAINT;
DROP TABLE clienteRegistrado CASCADE CONSTRAINT;
DROP TABLE descuento CASCADE CONSTRAINT;
DROP TABLE direccion CASCADE CONSTRAINT;
DROP SEQUENCE direccion_id_seq;
DROP TABLE proveedorArticulo CASCADE CONSTRAINT;
DROP TABLE pedidoProveedor CASCADE CONSTRAINT;
DROP TABLE proveedor CASCADE CONSTRAINT;
DROP TABLE articulo CASCADE CONSTRAINT;
DROP TABLE formatoProducto CASCADE CONSTRAINT;
DROP TABLE cantidad CASCADE CONSTRAINT;
DROP TABLE producto CASCADE CONSTRAINT;

CREATE TABLE producto(
    nombre VARCHAR2(50),
    coffea VARCHAR2(20) NOT NULL,
    varietal VARCHAR2(30) NOT NULL,
    origen VARCHAR2(15) NOT NULL,
    tostado CHAR(12) NOT NULL,
    cafeina CHAR(12) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (nombre),
    CONSTRAINT ck_producto_tostado CHECK (tostado IN ('natural', 'high-roast', 'blend')),
    CONSTRAINT ck_producto_cafeina CHECK (cafeina IN ('yes', 'no'))
);

CREATE TABLE cantidad(
    empaquetado VARCHAR2(15),
    cantidad VARCHAR2(15),
    magnitud VARCHAR2(15),
    CONSTRAINT pk_cantidad PRIMARY KEY (empaquetado, cantidad, magnitud)
);

CREATE TABLE formatoProducto(
    idProducto VARCHAR2(50) NOT NULL,
    nombreForm CHAR(20) NOT NULL,
    empaquetado VARCHAR2(10) NOT NULL,
    cantidad VARCHAR2(10) NOT NULL,
    magnitud VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_formatoProducto_producto FOREIGN KEY (idProducto) REFERENCES producto(nombre) ON DELETE CASCADE,
    CONSTRAINT fk_formatoProducto_cantidad FOREIGN KEY (empaquetado, cantidad, magnitud) REFERENCES cantidad(empaquetado, cantidad, magnitud) ON DELETE CASCADE,
    CONSTRAINT ck_formatoProducto_nombreForm CHECK (nombreForm IN ('capsules', 'freeze-dried', 'ground', 'prepared', 'roasted bean', 'raw bean'))
);

CREATE TABLE articulo(
    codigo_barra VARCHAR2(15),
    producto VARCHAR2(50) NOT NULL,
    empaquetado VARCHAR2(10) NOT NULL,
    cantidad VARCHAR2(10) NOT NULL,
    magnitud VARCHAR2(10) NOT NULL,
    precio VARCHAR2(15) NOT NULL,
    stock NUMBER(10) NOT NULL,
    stock_min NUMBER(10) NOT NULL,
    stock_max NUMBER(10) NOT NULL,
    CONSTRAINT pk_articulo PRIMARY KEY(codigo_barra),
    CONSTRAINT fk_articulo_producto FOREIGN KEY (producto) REFERENCES producto(nombre) ON DELETE CASCADE,
    CONSTRAINT fk_articulo_cantidad FOREIGN KEY (empaquetado, cantidad, magnitud) REFERENCES cantidad(empaquetado, cantidad, magnitud) ON DELETE CASCADE,
    CONSTRAINT ck_articulo_stock_min CHECK (stock_min > 4),
    CONSTRAINT ck_articulo_stock_max CHECK (stock_max > 10),
    CONSTRAINT ck_articulo_stock CHECK (stock > 0)
);

CREATE TABLE proveedor(
    nombre_registrado VARCHAR2(100),
    cif VARCHAR2(15) NOT NULL,
    nombreComercial VARCHAR2(50) NOT NULL,
    email VARCHAR2(60) NOT NULL,
    telefono VARCHAR2(10) NOT NULL,
    cantidadPedidos NUMBER(10) NOT NULL,
    tiempoEntrega NUMBER(10) NOT NULL,
    cuentaBancaria VARCHAR2(30) NOT NULL,
    dirComer VARCHAR2(120) NOT NULL, -- texto libre, sin normalizar a la tabla direccion
    pais VARCHAR2(60) NOT NULL,
    CONSTRAINT pk_proveedor PRIMARY KEY (nombre_registrado),
    CONSTRAINT unique_proveedor_cif UNIQUE (cif),
    CONSTRAINT unique_proveedor_nombreComercial UNIQUE (nombreComercial),
    CONSTRAINT unique_proveedor_email UNIQUE (email),
    CONSTRAINT unique_proveedor_telefono UNIQUE (telefono),
    CONSTRAINT unique_proveedor_cuentaBancaria UNIQUE (cuentaBancaria),
    CONSTRAINT unique_proveedor_dirComer UNIQUE (dirComer)
);

CREATE TABLE pedidoProveedor(
    proveedor VARCHAR2(20),
    fecha DATE,
    cantidadUnidades NUMBER(10) NOT NULL,
    estado CHAR(15) NOT NULL,
    articulo VARCHAR2(20),
    costePedido VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_pedidoProveedor PRIMARY KEY (proveedor, fecha),
    CONSTRAINT fk_pedidoProveedor_proveedor FOREIGN KEY (proveedor) REFERENCES proveedor(nombre_registrado) ON DELETE SET NULL,
    CONSTRAINT fk_pedidoProveedor_articulo FOREIGN KEY (articulo) REFERENCES articulo(codigo_barra),
    CONSTRAINT ck_pedidoProveedor_cantidadUnidades CHECK (cantidadUnidades > 0),
    CONSTRAINT ck_pedidoProveedor_estado CHECK(estado IN ('placed', 'fulfilled', 'draft'))
);

CREATE TABLE proveedorArticulo(
    idArticulo VARCHAR2(20) NOT NULL,
    idProveedor VARCHAR2(100) NOT NULL,
    coste CHAR(15), -- se guarda como texto
    CONSTRAINT fk_proveedorArticulo_articulo FOREIGN KEY (idArticulo) REFERENCES articulo(codigo_barra) ON DELETE CASCADE,
    CONSTRAINT fk_proveedorArticulo_proveedor FOREIGN KEY (idProveedor) REFERENCES proveedor(nombre_registrado) ON DELETE CASCADE
);

CREATE SEQUENCE direccion_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE TABLE direccion(
    idDireccion NUMBER(10),
    tipo CHAR(10) NOT NULL,
    nombre CHAR(30) NOT NULL,
    numImueble CHAR(3),
    numBloq CHAR(1),
    escalera CHAR(2),
    piso CHAR(7),
    puerta CHAR(2),
    codigoPostal CHAR(5) NOT NULL,
    ciudad CHAR(45) NOT NULL,
    pais CHAR(45) NOT NULL,
    CONSTRAINT pk_direccion PRIMARY KEY (idDireccion)
);

CREATE TABLE descuento(
    porcentaje VARCHAR2(10),
    fechaCaducidad DATE,
    CONSTRAINT pk_descuento PRIMARY KEY (porcentaje)
);

CREATE TABLE clienteRegistrado(
    usuario VARCHAR2(50),
    contraseña VARCHAR2(50) NOT NULL,
    fecha_reg DATE NOT NULL,
    preferencia CHAR(30),
    porcentaje VARCHAR2(10),
    CONSTRAINT pk_clienteRegistrado PRIMARY KEY(usuario),
    CONSTRAINT fk_clienteRegistrado_bonoDescuento FOREIGN KEY (porcentaje) REFERENCES descuento(porcentaje),
    CONSTRAINT ck_clienteRegistrado_preferencia CHECK(preferencia IN ('correo electrónico', 'llamada telefónica', 'sms', 'whatsapp', 'facebook',
                                                        'wechat', 'qqmobile', 'snapchat', 'telegram'))
);

CREATE TABLE tarjeta(
    numTarjeta VARCHAR2(30),
    titular VARCHAR2(50) NOT NULL,
    compania VARCHAR2(50) NOT NULL,
    fechaExp CHAR(7) NOT NULL,
    CONSTRAINT pk_tarjeta PRIMARY KEY (numTarjeta)
);

CREATE TABLE tarjetaCliente(
    numTarjeta VARCHAR2(30),
    idCliente VARCHAR2(50),
    CONSTRAINT fk_tarjetaCliente_tarjeta FOREIGN KEY (numTarjeta) REFERENCES tarjeta(numTarjeta),
    CONSTRAINT fk_tarjetaCliente_cliente FOREIGN KEY (idCliente) REFERENCES clienteRegistrado(usuario)
);

CREATE TABLE clienteDireccion(
    idCliente VARCHAR2(50),
    idDireccion NUMBER(10),
    CONSTRAINT fk_clienteDireccion_cliente FOREIGN KEY (idCliente) REFERENCES clienteRegistrado(usuario),
    CONSTRAINT fk_clienteDireccion_direccion FOREIGN KEY (idDireccion) REFERENCES direccion(idDireccion)
);

CREATE SEQUENCE pedido_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE TABLE pedidoCliente(
    idPedido NUMBER(10),
    correo VARCHAR2(60),
    telefono VARCHAR2(10),
    fecha DATE, -- sin NOT NULL: no viene en la tabla proporcionada
    tipoPago CHAR(15) NOT NULL,
    fechaPago DATE NOT NULL,
    tarjeta VARCHAR(20),
    fechaEntrega DATE NOT NULL, -- no está en el enunciado, pero sí en los datos de origen
    nombre VARCHAR2(35) NOT NULL,
    apellido1 VARCHAR2(30) NOT NULL,
    apellido2 VARCHAR2(30),
    direccion NUMBER(10),
    CONSTRAINT pk_pedidoCliente PRIMARY KEY (idPedido),
    CONSTRAINT fk_pedidoCliente_direccion FOREIGN KEY (direccion) REFERENCES direccion(idDireccion),
    CONSTRAINT fk_pedidoCliente_tarjeta FOREIGN KEY (tarjeta) REFERENCES tarjeta(numTarjeta),
    CONSTRAINT ck_pedidoCliente_correoytelefono CHECK (correo IS NOT NULL OR telefono IS NOT NULL),
    CONSTRAINT ck_pedidoCliente_tipoPago CHECK(tipoPago IN ('credit card', 'bank transfer', 'COD'))
);

CREATE TABLE pedidoClienteArticulo (
    idRegistrado VARCHAR2(50),
    idPedido NUMBER(10),
    idArticulo VARCHAR2(20) NOT NULL,
    unidad NUMBER(10) NOT NULL,
    CONSTRAINT fk_pedidoClienteArticulo_cliente FOREIGN KEY (idRegistrado) REFERENCES clienteRegistrado(usuario),
    CONSTRAINT fk_pedidoClienteArticulo_pedido FOREIGN KEY (idPedido) REFERENCES pedidoCliente(idPedido),
    CONSTRAINT fk_pedidoClienteArticulo_articulo FOREIGN KEY (idArticulo) REFERENCES articulo(codigo_barra),
    CONSTRAINT ck_pedidoClienteArticulo CHECK (unidad > 0)
);

CREATE TABLE resena(
    cliente VARCHAR2(50),
    articulo VARCHAR2(20),
    producto VARCHAR2(50) NOT NULL,
    puntuacion NUMBER(1) NOT NULL,
    titulo VARCHAR2(50),
    texto VARCHAR2(2000),
    fecha DATE, -- no está en el enunciado, pero sí en los datos de origen
    meGusta NUMBER(38) NOT NULL,
    refrenda VARCHAR2(50),
    CONSTRAINT pk_resena PRIMARY KEY (titulo, texto, fecha),
    CONSTRAINT fk_resena_cliente FOREIGN KEY (cliente) REFERENCES clienteRegistrado(usuario),
    CONSTRAINT fk_resena_articulo FOREIGN KEY (articulo) REFERENCES articulo(codigo_barra),
    CONSTRAINT fk_resena_producto FOREIGN KEY (producto) REFERENCES producto(nombre) ON DELETE CASCADE,
    CONSTRAINT ck_puntuacion CHECK (puntuacion BETWEEN 0 and 6),
    CONSTRAINT ck_meGusta CHECK (meGusta BETWEEN 0 and 1000000000)
);
