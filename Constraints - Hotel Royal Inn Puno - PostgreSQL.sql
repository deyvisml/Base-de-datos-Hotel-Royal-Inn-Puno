/*1. CONSTRAINT: (Tipos_habitaciones) cant_adultos>0, cant_ninios >=0*/

ALTER TABLE Tipos_habitaciones 
ADD CONSTRAINT validar_atributos_tipo_habitacion
CHECK (
    cantidad_adultos > 0
    AND cantidad_ninios >=0
);

/*2. CONSTRAINT: (Habitaciones) numero_habitacion > 0, piso_habitacion > 0, precio_habitacion > 50*/

ALTER TABLE Habitaciones 
ADD CONSTRAINT validar_atributos_habitacion
CHECK (
    numero_habitacion > 0
    AND piso_habitacion > 0
    AND precio_noche >= 50
);

/*3. CONSTRAINT: (Reservaciones) */

ALTER TABLE Reservaciones 
ADD CONSTRAINT validar_atributos_reservacion
CHECK (
    fecha_reservacion < fecha_ingreso
    AND fecha_ingreso < fecha_salida
    AND fecha_ingreso_cliente >= fecha_ingreso
    AND fecha_ingreso_cliente < fecha_salida
    AND fecha_salida_cliente > fecha_ingreso_cliente
    AND num_adultos > 0
    AND num_ninios >= 0
    AND costo_habitaciones >= 50
    AND costo_pedidos >= 0
);

/*4. CONSTRAINT: (Factura)*/

ALTER TABLE Factura 
ADD CONSTRAINT validar_atributos_factura
CHECK (
    subtotal >= 50
    AND iva < subtotal
    AND iva > 0
    AND total_factura > subtotal
);

/*5. CONSTRAINT: (Vehiculos)*/

ALTER TABLE Vehiculos 
ADD CONSTRAINT validar_atributos_vehiculos
CHECK (
    fecha_ingreso < fecha_salida
);

/*6. CONSTRAINT: (Vehiculos)*/

ALTER TABLE Empleados 
ADD CONSTRAINT validar_atributos_empleados
CHECK (
    fecha_ingreso > '2000-01-01'
);

/*7. CONSTRAINT: (Tipos_empleados)*/

ALTER TABLE Tipos_empleados 
ADD CONSTRAINT validar_atributos_tipos_empleados
CHECK (
    sueldo >= 930
);

/*8. CONSTRAINT: (Pedidos)*/

ALTER TABLE Pedidos 
ADD CONSTRAINT validar_atributos_pedidos
CHECK (
    subtotal >= 0
    AND fecha_pedido > '2000-01-01'
    AND costo_pedido >= 0
);

/*9. CONSTRAINT: (Pedidos_comidas)*/

ALTER TABLE Pedidos_comidas 
ADD CONSTRAINT validar_atributos_pedidos_comidas
CHECK (
    cantidad >= 1
);

/*10. CONSTRAINT: (Comidas)*/

ALTER TABLE Comidas 
ADD CONSTRAINT validar_atributos_comidas
CHECK (
    precio_unitario >= 0
);

/*11. CONSTRAINT: (Pedidos_postres)*/

ALTER TABLE Pedidos_postres
ADD CONSTRAINT validar_atributos_pedido_postre
CHECK (
    cantidad >= 1
);

/*12. CONSTRAINT: (Pedidos_postres)*/

ALTER TABLE Postres 
ADD CONSTRAINT validar_atributos_postre
CHECK (
    precio_unitario >= 0
);

/*13. CONSTRAINT: (Pedidos_bebidas)*/

ALTER TABLE Pedidos_bebidas
ADD CONSTRAINT validar_atributos_pedido_bebida
CHECK (
    cantidad >= 1
);

/*14. CONSTRAINT: (Bebidas)*/

ALTER TABLE Bebidas 
ADD CONSTRAINT validar_atributos_bebida
CHECK (
    precio_unitario >= 0
);