-- Crear Base de datos
CREATE DATABASE IF NOT EXISTS sistema_boletos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE sistema_boletos;

-- =========================
-- USUARIOS Y ROLES
-- =========================

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    dni_usuario CHAR(13) NOT NULL UNIQUE,
    primer_nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB;

CREATE TABLE Roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol ENUM('cliente','vendedor','admin') NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Usuarios_Roles (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_ur_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ur_rol FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tipos de usuario
CREATE TABLE Clientes (
    id_usuario INT PRIMARY KEY,
    CONSTRAINT fk_clientes_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Vendedores (
    id_usuario INT PRIMARY KEY,
    nombre_negocio VARCHAR(150) NULL,
    rtn VARCHAR(20) NULL,
    telefono_contacto VARCHAR(20) NULL,
    CONSTRAINT fk_vendedores_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Administradores (
    id_usuario INT PRIMARY KEY,
    
    CONSTRAINT fk_admins_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- EVENTOS Y CATEGORÍAS
-- =========================

CREATE TABLE Eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT NOT NULL,                           -- FK a Vendedores
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL,
    categoria VARCHAR(100),
    lugar VARCHAR(100),
    tipo_evento VARCHAR(50),                            -- Pendiente definir tipos de evento
    estado ENUM('activo','cancelado','finalizado') DEFAULT 'activo',
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_eventos_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedores(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Cambios Tabla de eventos
ALTER TABLE Eventos
ADD categoria VARCHAR(50) NOT NULL DEFAULT 'general';

ALTER TABLE Eventos
ADD precio_base DECIMAL(10,2) NOT NULL;

ALTER TABLE Eventos
ADD cantidad_boletos INT NOT NULL;


-- Categorías internas por evento 
CREATE TABLE Categorias_Evento (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    nombre_categoria VARCHAR(100) NOT NULL,             -- p.ej. VIP, General, Palco
    precio DECIMAL(10,2) NOT NULL,
    con_asiento TINYINT(1) NOT NULL DEFAULT 0,          -- 1: con asiento numerado; 0: sin asiento
    cantidad_asientos INT NULL,                                     -- capacidad opcional por categoría
    CONSTRAINT fk_catevento_evento FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento)
        ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY uq_categoria_por_evento (id_evento, nombre_categoria)
) ENGINE=InnoDB;

-- =========================
-- BOLETOS
-- =========================

CREATE TABLE Boletos (
    id_boleto INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    id_categoria INT NOT NULL,
    codigo VARCHAR(64) NOT NULL UNIQUE,                 -- para QR/validación
    asiento VARCHAR(20) NULL,                           -- puede ser NULL cuando no aplica
    precio DECIMAL(10,2) NOT NULL,                      
    estado ENUM('pendiente','pagado','validado','usado') NOT NULL DEFAULT 'pendiente',
    id_cliente INT NULL,                                -- se llena cuando se vende
    -- FKs
    CONSTRAINT fk_boletos_evento FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_boletos_categoria FOREIGN KEY (id_categoria) REFERENCES Categorias_Evento(id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_boletos_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_usuario)
        ON UPDATE CASCADE ON DELETE SET NULL,
    -- Evita asientos duplicados dentro de la misma categoría del evento.
    -- Permite múltiples NULL (boletos sin asiento), que es lo que queremos.
    UNIQUE KEY uq_asiento_por_categoria (id_evento, id_categoria, asiento)
) ENGINE=InnoDB;

-- =========================
-- COMPRAS Y PAGOS
-- =========================

CREATE TABLE Compras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('tarjeta','paypal','otro') NULL,
    estado ENUM('pendiente','completado','cancelado') NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_compras_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Detalle_Compras (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_boleto INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_compra FOREIGN KEY (id_compra) REFERENCES Compras(id_compra)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_boleto FOREIGN KEY (id_boleto) REFERENCES Boletos(id_boleto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    -- Un boleto no debería pertenecer a más de una compra
    UNIQUE KEY uq_boleto_unico_en_compra (id_boleto)
) ENGINE=InnoDB;

CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto DECIMAL(10,2) NOT NULL,
    metodo ENUM('tarjeta','paypal','otro') NOT NULL,
    estado ENUM('exitoso','fallido') NOT NULL DEFAULT 'exitoso',
    CONSTRAINT fk_pagos_compra FOREIGN KEY (id_compra) REFERENCES Compras(id_compra)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- ÍNDICES
-- =========================
CREATE INDEX idx_usuarios_correo ON Usuarios(correo);
CREATE INDEX idx_eventos_vendedor ON Eventos(id_vendedor);
CREATE INDEX idx_boletos_estado ON Boletos(estado);
CREATE INDEX idx_boletos_cliente ON Boletos(id_cliente);
CREATE INDEX idx_compras_cliente ON Compras(id_cliente);
