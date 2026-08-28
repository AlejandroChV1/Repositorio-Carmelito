-- =========================================================
-- PROYECTO BASE DE DATOS
-- SISTEMA DE GESTIÓN DE VENTAS E INVENTARIO
-- BAZAR CARMELITO
-- MOTOR: SQLite
-- =========================================================

PRAGMA foreign_keys = ON;

-- =========================================================
-- 1. NEGOCIO
-- =========================================================

CREATE TABLE IF NOT EXISTS negocio (
    id_negocio VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nit VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200),
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    fecha_registro DATE,
    estado BOOLEAN NOT NULL DEFAULT 1
);


-- =========================================================
-- 2. CATEGORIA
-- =========================================================

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    id_categoria_padre VARCHAR(10),
    estado BOOLEAN NOT NULL DEFAULT 1,

    FOREIGN KEY (id_categoria_padre)
        REFERENCES categoria(id_categoria)
);


-- =========================================================
-- 3. PRESENTACION
-- =========================================================

CREATE TABLE IF NOT EXISTS presentacion (
    id_presentacion VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    estado BOOLEAN NOT NULL DEFAULT 1
);


-- =========================================================
-- 4. MARCA
-- =========================================================

CREATE TABLE IF NOT EXISTS marca (
    id_marca VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    estado BOOLEAN NOT NULL DEFAULT 1
);


-- =========================================================
-- 5. PRODUCTO
-- =========================================================

CREATE TABLE IF NOT EXISTS producto (
    id_producto VARCHAR(10) PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    codigo_barras VARCHAR(50) UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    id_categoria VARCHAR(10) NOT NULL,
    id_presentacion VARCHAR(10) NOT NULL,
    id_marca VARCHAR(10),
    estado BOOLEAN NOT NULL DEFAULT 1,
    fecha_registro DATETIME,
    fecha_actualizacion DATETIME,

    FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    FOREIGN KEY (id_presentacion)
        REFERENCES presentacion(id_presentacion),

    FOREIGN KEY (id_marca)
        REFERENCES marca(id_marca)
);


-- =========================================================
-- 6. PROVEEDOR
-- =========================================================

CREATE TABLE IF NOT EXISTS proveedor (
    id_proveedor VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nombre_contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200),
    nit VARCHAR(20),
    fecha_registro DATE,
    estado BOOLEAN NOT NULL DEFAULT 1
);


-- =========================================================
-- 7. PRODUCTO_PROVEEDOR
-- =========================================================

CREATE TABLE IF NOT EXISTS producto_proveedor (
    id_producto_proveedor VARCHAR(15) PRIMARY KEY,
    id_producto VARCHAR(10) NOT NULL,
    id_proveedor VARCHAR(10) NOT NULL,
    codigo_proveedor VARCHAR(50),
    precio_referencia DECIMAL(10,2),
    tiempo_entrega_estimado INTEGER,
    estado BOOLEAN NOT NULL DEFAULT 1,

    FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor),

    UNIQUE (id_producto, id_proveedor)
);


-- =========================================================
-- 8. ROL
-- Debe crearse antes de USUARIO porque usuario utiliza id_rol
-- =========================================================

CREATE TABLE IF NOT EXISTS rol (
    id_rol VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    estado BOOLEAN NOT NULL DEFAULT 1
);


-- =========================================================
-- 9. USUARIO
-- =========================================================

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario VARCHAR(10) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    id_rol VARCHAR(10) NOT NULL,
    fecha_registro DATETIME,
    ultimo_acceso DATETIME,
    estado BOOLEAN NOT NULL DEFAULT 1,

    FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol)
);


-- =========================================================
-- 10. COMPRA
-- =========================================================

CREATE TABLE IF NOT EXISTS compra (
    id_compra VARCHAR(10) PRIMARY KEY,
    id_proveedor VARCHAR(10) NOT NULL,
    id_usuario VARCHAR(10) NOT NULL,
    fecha_compra DATETIME NOT NULL,
    numero_documento VARCHAR(50),
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    descuento_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL,
    observacion TEXT,

    FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor),

    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);


-- =========================================================
-- 11. DETALLE_COMPRA
-- =========================================================

CREATE TABLE IF NOT EXISTS detalle_compra (
    id_detalle_compra VARCHAR(10) PRIMARY KEY,
    id_compra VARCHAR(10) NOT NULL,
    id_producto VARCHAR(10) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_compra)
        REFERENCES compra(id_compra),

    FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);


-- =========================================================
-- 12. VENTA
-- =========================================================

CREATE TABLE IF NOT EXISTS venta (
    id_venta VARCHAR(10) PRIMARY KEY,
    numero_venta VARCHAR(30) NOT NULL UNIQUE,
    fecha_venta DATE NOT NULL,
    hora_venta TIME NOT NULL,
    id_usuario VARCHAR(10) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    descuento_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL,
    observacion TEXT,

    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);


-- =========================================================
-- 13. DETALLE_VENTA
-- =========================================================

CREATE TABLE IF NOT EXISTS detalle_venta (
    id_detalle_venta VARCHAR(10) PRIMARY KEY,
    id_venta VARCHAR(10) NOT NULL,
    id_producto VARCHAR(10) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),

    FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);


-- =========================================================
-- 14. INVENTARIO
-- =========================================================

CREATE TABLE IF NOT EXISTS inventario (
    id_inventario VARCHAR(10) PRIMARY KEY,
    id_producto VARCHAR(10) NOT NULL UNIQUE,
    stock_actual DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock_maximo DECIMAL(10,2),
    ultima_actualizacion DATETIME,

    FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);


-- =========================================================
-- 15. TIPO_MOVIMIENTO
-- =========================================================

CREATE TABLE IF NOT EXISTS tipo_movimiento (
    id_tipo_movimiento VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    naturaleza VARCHAR(20) NOT NULL,
    descripcion TEXT,
    estado BOOLEAN NOT NULL DEFAULT 1,

    CHECK (naturaleza IN ('ENTRADA', 'SALIDA'))
);


-- =========================================================
-- 16. MOVIMIENTO_INVENTARIO
-- =========================================================

CREATE TABLE IF NOT EXISTS movimiento_inventario (
    id_movimiento_inventario VARCHAR(10) PRIMARY KEY,
    id_producto VARCHAR(10) NOT NULL,
    id_tipo_movimiento VARCHAR(10) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    stock_anterior DECIMAL(10,2),
    stock_posterior DECIMAL(10,2),
    fecha_movimiento DATETIME NOT NULL,
    id_usuario VARCHAR(10) NOT NULL,
    id_venta VARCHAR(10),
    id_compra VARCHAR(10),
    observacion TEXT,

    FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    FOREIGN KEY (id_tipo_movimiento)
        REFERENCES tipo_movimiento(id_tipo_movimiento),

    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario),

    FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),

    FOREIGN KEY (id_compra)
        REFERENCES compra(id_compra)
);