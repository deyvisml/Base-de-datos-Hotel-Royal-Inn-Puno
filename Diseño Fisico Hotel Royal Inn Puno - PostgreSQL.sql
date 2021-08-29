CREATE DATABASE Hotel;

USE Hotel;

CREATE TABLE Paises(
    id_pais SERIAL NOT NULL,
    nombre CHARACTER VARYING(30) NOT NULL,
    codigo_postal CHAR(5) NOT NULL,
    PRIMARY KEY (id_pais)
);

CREATE TABLE Clientes(
    id_cliente SERIAL NOT NULL,
    documento_identificacion CHARACTER VARYING(30) NOT NULL,
    nombres CHARACTER VARYING(30) NOT NULL,
    ap_paterno CHARACTER VARYING(30) NOT NULL,
    ap_materno CHARACTER VARYING(30) NOT NULL,
    direccion CHARACTER VARYING(50),
    telefono CHAR(15),
    correo CHARACTER VARYING(50),
    fecha_nacimiento DATE,
    sexo CHAR(10),
    id_pais INTEGER NOT NULL,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_pais) REFERENCES Paises(id_pais)
);

CREATE TABLE Tipos_empleados(
    id_tipo_empleado SERIAL NOT NULL,
    nombre CHARACTER VARYING(30) NOT NULL,
    sueldo DECIMAL(15, 2),
    PRIMARY KEY (id_tipo_empleado)
);

CREATE TABLE Empleados(
    id_empleado SERIAL NOT NULL,
    docuemnto_identificacion CHAR (8) NOT NULL,
    nombres CHARACTER VARYING(30) NOT NULL,
    ap_paterno CHARACTER VARYING(30),
    ap_materno CHARACTER VARYING(30),
    direccion CHARACTER VARYING(50) NOT NULL,
    telefono CHAR(15) NOT NULL,
    correo CHARACTER VARYING(50),
    fecha_ingreso TIMESTAMP,
    id_tipo_empleado INTEGER NOT NULL,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_tipo_empleado) REFERENCES Tipos_empleados(id_tipo_empleado)
);

CREATE TABLE Tipos_habitaciones(
    id_tipo_habitacion SERIAL NOT NULL,
    tipo CHARACTER VARYING(20),
    cantidad_adultos INTEGER,
    cantidad_ninios INTEGER,
    PRIMARY KEY (id_tipo_habitacion)
);

CREATE TABLE Estados_habitaciones(
    id_estado_habitacion SERIAL NOT NULL,
    estado CHARACTER VARYING(30),
    descripcion TEXT,
    PRIMARY KEY (id_estado_habitacion)
);

CREATE TABLE Habitaciones(
    id_habitacion SERIAL NOT NULL,
    numero_habitacion INTEGER,
    piso_habitacion INTEGER,
    caracteristicas TEXT,
    url_foto_habitacion CHARACTER VARYING(50),
    precio_noche DECIMAL(10, 2),
    id_estado_habitacion INTEGER NOT NULL,
    id_tipo_habitacion INTEGER NOT NULL,
    PRIMARY KEY (id_habitacion),
    FOREIGN KEY (id_estado_habitacion) REFERENCES Estados_habitaciones(id_estado_habitacion),
    FOREIGN KEY (id_tipo_habitacion) REFERENCES Tipos_habitaciones(id_tipo_habitacion)
);

CREATE TABLE Reservaciones(
    id_reservacion SERIAL NOT NULL,
    fecha_reservacion TIMESTAMP,
    fecha_ingreso TIMESTAMP,
    fecha_salida TIMESTAMP,
    fecha_ingreso_cliente TIMESTAMP,
    fecha_salida_cliente TIMESTAMP,
    num_adultos INTEGER,
    num_ninios INTEGER,
    costo_habitaciones DECIMAL(10, 2),
    costo_pedidos DECIMAL(10, 2),
    estado CHARACTER VARYING(15) NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    PRIMARY KEY (id_reservacion),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado) 
);

CREATE TABLE Factura(
	id_factura SERIAL NOT NULL,
	cod_factura CHAR(13) NOT NULL,
	fecha TIMESTAMP NOT NULL,
	subtotal DECIMAL(10,2),
	iva DECIMAL(10,2),
	total_factura DECIMAL(10,2),
	id_reservacion INTEGER NOT NULL,
	id_empleado INTEGER NOT NULL,
	PRIMARY KEY(id_factura),
	FOREIGN KEY(id_reservacion) REFERENCES Reservaciones(id_reservacion),
	FOREIGN KEY(id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Vehiculos(
    placa CHAR(6) NOT NULL,
    modelo CHARACTER VARYING(15),
    color CHARACTER VARYING(15),
    condicion CHARACTER VARYING(15),
    fecha_ingreso TIMESTAMP,
    fecha_salida TIMESTAMP,
    id_reservacion INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    PRIMARY KEY (placa),
    FOREIGN KEY (id_reservacion) REFERENCES Reservaciones(id_reservacion),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Reservacion_habitacion(
	id_reservacion INTEGER NOT NULL,
	id_habitacion INTEGER NOT NULL,
	PRIMARY KEY(id_reservacion, id_habitacion),
	FOREIGN KEY(id_reservacion) REFERENCES Reservaciones(id_reservacion),
	FOREIGN KEY(id_habitacion) REFERENCES Habitaciones(id_habitacion)
);

CREATE TABLE Tipos_pedidos(
	id_tipo_pedido SERIAL NOT NULL,
	nombre CHARACTER VARYING(20) NOT NULL,
	PRIMARY KEY(id_tipo_pedido)
);

CREATE TABLE Pedidos(
	id_pedido SERIAL NOT NULL,
	subtotal DECIMAL(10, 2),
	estado CHAR(10),
	fecha_pedido TIMESTAMP,
    	costo_pedido DECIMAL(10, 2),
	id_reservacion INTEGER NOT NULL,
	id_empleado INTEGER NOT NULL,
	id_tipo_pedido INTEGER NOT NULL,
	PRIMARY KEY(id_pedido),
	FOREIGN KEY(id_reservacion) REFERENCES Reservaciones(id_reservacion),
	FOREIGN KEY(id_empleado) REFERENCES Empleados(id_empleado),
	FOREIGN KEY(id_tipo_pedido) REFERENCES Tipos_pedidos(id_tipo_pedido)
);

CREATE TABLE Tipos_comidas(
	id_tipo_comida SERIAL NOT NULL,
	nombre CHARACTER VARYING(30) NOT NULL,
	descripcion TEXT,
	PRIMARY KEY(id_tipo_comida)
);

CREATE TABLE Comidas(
	id_comida SERIAL NOT NULL,
	nombre CHARACTER VARYING(30) NOT NULL,
	precio_unitario DECIMAL(10,2),
	url_foto CHARACTER VARYING(50),
	id_tipo_comida INTEGER NOT NULL,
	PRIMARY KEY(id_comida),
	FOREIGN KEY(id_tipo_comida) REFERENCES Tipos_comidas(id_tipo_comida)
);

CREATE TABLE Pedidos_comidas(
	id_pedido INTEGER NOT NULL,
	id_comida INTEGER NOT NULL,
	cantidad INTEGER,
	PRIMARY KEY(id_pedido, id_comida),
	FOREIGN KEY(id_pedido) REFERENCES Pedidos(id_pedido),
	FOREIGN KEY(id_comida) REFERENCES Comidas(id_comida)
);

CREATE TABLE Postres(
    id_postre SERIAL NOT NULL,
    nombre CHARACTER VARYING(30) NOT NULL,
    precio_unitario DECIMAL(10, 2),
    PRIMARY KEY (id_postre)
);

CREATE TABLE Pedidos_postres(
    id_pedido INTEGER NOT NULL,
    id_postre INTEGER NOT NULL,
    cantidad INTEGER,
    PRIMARY KEY (id_pedido, id_postre),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_postre) REFERENCES Postres(id_postre)
);

CREATE TABLE Tipos_bebidas(
    id_tipo_bebida SERIAL NOT NULL,
    nombre CHARACTER VARYING(50) NOT NULL,
    descripcion TEXT,
    PRIMARY KEY (id_tipo_bebida)
);

CREATE TABLE Bebidas(
    id_bebida SERIAL NOT NULL,
    nombre CHARACTER VARYING(30) NOT NULL,
    precio_unitario DECIMAL(10, 2),
    url_foto CHARACTER VARYING(50),
    id_tipo_bebida INTEGER,
    PRIMARY KEY (id_bebida),
    FOREIGN KEY (id_tipo_bebida) REFERENCES Tipos_bebidas(id_tipo_bebida)
);

CREATE TABLE Pedidos_bebidas(
    id_pedido INTEGER NOT NULL,
    id_bebida INTEGER NOT NULL,
    cantidad INTEGER,
    PRIMARY KEY (id_pedido, id_bebida),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_bebida) REFERENCES Bebidas(id_bebida)
);