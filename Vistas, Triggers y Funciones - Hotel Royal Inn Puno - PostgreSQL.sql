
/*=======================V I E W S============================*/


/*1. VIEW: ver todas las habitaciones que esten libres y todas sus caracteristicas*/
CREATE VIEW view_ver_habitaciones_libres AS
    SELECT h.numero_habitacion, h.piso_habitacion, h.precio_noche, t_h.tipo, t_h.cantidad_adultos, t_h.cantidad_ninios, e_h.estado
    FROM Habitaciones h LEFT JOIN Tipos_habitaciones t_h
        ON (h.id_tipo_habitacion = t_h.id_tipo_habitacion)
        JOIN Estados_habitaciones e_h
        ON (h.id_estado_habitacion = e_h.id_estado_habitacion)
    WHERE e_h.estado = 'libre';

/*2. VIEW: ver toda la informacion de las reservaciones vigentes*/
CREATE VIEW view_ver_reservas_vigentes AS
    SELECT r.id_reservacion, r.fecha_reservacion, r.fecha_ingreso, r.fecha_salida, c.nombres AS "Nombre cliente", c.ap_paterno AS "Ap_paterno cliente", c.ap_materno AS "Ap_materno cliente", c.telefono, e.nombres AS "Nombre empleado", e.ap_paterno, e.ap_materno, te.nombre AS "Tipo empleo"
    FROM Reservaciones r LEFT JOIN Clientes c
        ON (r.id_cliente = c.id_cliente)
        JOIN Empleados e
        ON (r.id_empleado = e.id_empleado)
        LEFT JOIN Tipos_empleados te
        ON (e.id_tipo_empleado = te.id_tipo_empleado)
    WHERE r.estado = 'vigente';

/*3. VIEW: ver toda la informacion  de las facturas*/
CREATE VIEW view_ver_informacion_facturas AS
    SELECT f.cod_factura, f.fecha, f.total_factura, r.id_reservacion, c.nombres AS "Nombre cliente", c.ap_paterno, c.ap_materno, p.nombre AS "Pais cliente", e.nombres AS "Nombre empleado", e.ap_paterno AS "Ap_paterno emppleado", e.ap_materno AS "Ap_matenno empleado"
    FROM Factura f LEFT JOIN Reservaciones r
        ON (f.id_reservacion = r.id_reservacion)
        JOIN Clientes c
        ON (r.id_cliente = c.id_cliente)
        JOIN Paises p
        ON (c.id_pais = p.id_pais)
        JOIN Empleados e
        ON (r.id_empleado = e.id_empleado);

/*4. VIEW: ver lista de todas los pedidos que falten atender*/
CREATE VIEW view_ver_pedidos_atender AS
    SELECT p.id_pedido, p.fecha_pedido, t_p.nombre AS "Tipo pedido", r.id_reservacion, c.nombres AS "Nombre cliente", c.ap_paterno, p.estado
    FROM Pedidos p LEFT JOIN Tipos_pedidos t_p
        ON (p.id_tipo_pedido = t_p.id_tipo_pedido)
        LEFT JOIN Reservaciones r
        ON (p.id_reservacion = r.id_reservacion)
        LEFT JOIN Clientes c
        ON (r.id_cliente = c.id_cliente)
    WHERE p.estado = 'atender';

/*5. VIEW: ver lista de los vehiculos que aun estan en el Garaje*/
CREATE VIEW view_ver_vehiculos_garaje AS
    SELECT v.placa, v.modelo, v.color, r.id_reservacion, c.nombres AS "Nombre cliente", c.ap_paterno AS "Apellido paterno cliente", e.nombres AS "Nombre empleado", e.ap_paterno AS "Apellido paterno empleado", v.condicion AS "Condicion del vehiculo"
    FROM Vehiculos v LEFT JOIN Reservaciones r
        ON (v.id_reservacion = r.id_reservacion)
        LEFT JOIN Clientes c
        ON (r.id_cliente = c.id_cliente)
        LEFT JOIN Empleados e
        ON (v.id_empleado = e.id_empleado)
    WHERE v.condicion = 'garaje';



/*=======================T R I G G E R S============================*/


/*1. TRIGGER: Despues de Facturar la reservacion, cambia el estado a "limpieza = 2(id)" de todas las habitaciones relacionadas a esa reserva*/

CREATE OR REPLACE FUNCTION after_insert_factura()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    UPDATE Habitaciones
    SET id_estado_habitacion = 2
    WHERE id_habitacion IN (SELECT h.id_habitacion
                            FROM Reservacion_habitacion r_h JOIN Factura f
                                ON (r_h.id_reservacion = f.id_reservacion)
                            WHERE f.id_factura = NEW.id_factura);
END;
$$;

CREATE TRIGGER after_insert_factura
    AFTER INSERT ON Factura
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_factura();


/*2. TRIGGER: Despues de realizar un pedido de una comida, se debe de AUMENTAR esa cantidad de ese pedio comida automaticamente en nuestra tabla pedidos*/

CREATE OR REPLACE FUNCTION after_insert_pedidos_comidas()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    UPDATE Pedidos
    SET costo_pedido = costo_pedido + (SELECT p_c.cantidad*c.precio_unitario
                                        FROM Pedidos_comidas p_c JOIN Comidas c
                                            ON (p_c.id_comida = c.id_comida)
                                        WHERE p_c.id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END;
$$;

CREATE TRIGGER after_insert_pedidos_comidas
    AFTER INSERT ON Pedidos_comidas
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_pedidos_comidas();


/*3. TRIGGER: Despues de realizar un pedido de un postre, se debe de AUMENTAR esa cantidad de ese pedio comida automaticamente en nuestra tabla pedidos*/

CREATE OR REPLACE FUNCTION after_insert_pedidos_postres()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    UPDATE Pedidos
    SET costo_pedido = costo_pedido + (SELECT p_p.cantidad*p.precio_unitario
                                        FROM Pedidos_postres p_p JOIN Postres p
                                            ON (p_p.id_postre = p.id_postre)
                                        WHERE p_c.id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END;
$$;

CREATE TRIGGER after_insert_pedidos_postres
    AFTER INSERT ON Pedidos_postres
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_pedidos_postres();


/*4. TRIGGER: Despues de realizar un pedido de una bebida, se caclula el precio de ese pedido bebida y se le agrega al precio del pedido que corresponde*/

CREATE OR REPLACE FUNCTION after_insert_pedidos_bebidas()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    UPDATE Pedidos
    SET costo_pedido = costo_pedido + (SELECT p_b.cantidad*b.precio_unitario
                                        FROM Pedidos_bebidas p_b JOIN Bebidas b
                                            ON (p_b.id_bebida = b.id_bebida)
                                        WHERE p_b.id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END;
$$;

CREATE TRIGGER after_insert_pedidos_bebidas
    AFTER INSERT ON Pedidos_bebidas
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_pedidos_bebidas();


/*5. TRIGGER: Despues de realizar una reservacion, se debe de cambiar el estado de las habitaciones que pertencen a esa reservaciones a RESERVADO (id = 2)*/

CREATE OR REPLACE FUNCTION after_insert_reservaciones()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    UPDATE Habitaciones
    SET id_estado_habitacion = 2 /*(reservado (id = 2)) idea: tbm otra puede ser cuando llegue el cliente, deberia de cambiar a ocupado*/
    WHERE id_habitacion IN (SELECT id_habitacion
                            FROM Reservacion_habitacion
                            WHERE id_reservacion = NEW.id_reservacion);
END;
$$;

CREATE TRIGGER after_insert_reservaciones
    AFTER INSERT ON Reservaciones
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_reservaciones();



/*=======================F U N C T I O N S============================*/


/*1. FUNCTION: Mostrar las habitaciones del piso X*/
CREATE OR REPLACE FUNCTION habitacionesLibresXPiso(num_piso INTEGER)
    RETURNS TABLE(
        id_habitacion INTEGER, 
        numero_habitacion INTEGER, 
        precio_noche DECIMAL(10, 2), 
        tipo CHARACTER VARYING(20), 
        cantidad_adultos INTEGER, 
        cantidad_ninios INTEGER, 
        piso_habitacion INTEGER,  
        estado CHARACTER VARYING(20)
    )
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT h.id_habitacion, h.numero_habitacion, h.precio_noche, t_h.tipo, t_h.cantidad_adultos, t_h.cantidad_ninios, h.piso_habitacion, e_h.estado
    FROM Habitaciones h LEFT JOIN Estados_habitaciones e_h
        ON (h.id_estado_habitacion = e_h.id_estado_habitacion)
        LEFT JOIN Tipos_habitaciones t_h
        ON (h.id_tipo_habitacion = t_h.id_tipo_habitacion)
    WHERE e_h.estado = 'libre' AND h.piso_habitacion = num_piso;
END;
$$;

SELECT * FROM habitacionesLibresXPiso(1);


/*2. FUNCTION: Cambiar el estado de un vehiculo al ser retirado del garaje y ponerle la fecha de salida*/
CREATE OR REPLACE FUNCTION cambiarEstadoRetirarVehiculoGaraje(num_placa CHAR(6))
    RETURNS BOOL
    LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Vehiculos
    SET condicion = 'retirado', fecha_salida = CURRENT_TIMESTAMP
    WHERE condicion <> 'retirado' AND placa = num_placa;

    RETURN FOUND;
END;
$$;

SELECT * FROM cambiarEstadoRetirarVehiculoGaraje('123456');


/*3. FUNCTION: Mostrar toda la información de todas la(s) reserva(s) de un cliente en base a su DNI*/
CREATE OR REPLACE FUNCTION todasReservacionesCliente(id_card_cliente CHARACTER VARYING(30))
    RETURNS TABLE(
        id_reservacion INTEGER, 
        fecha_reservacion TIMESTAMP, 
        fecha_ingreso TIMESTAMP, 
        fecha_salida TIMESTAMP, 
        costo_habitaciones DECIMAL(10, 2), 
        costo_pedidos DECIMAL(10, 2), 
        total_factura DECIMAL(10, 2),  
        nombre_cliente CHARACTER VARYING(30),
        ap_paterno_cliente CHAR VARYING(30),
        nombre_empleado CHARACTER VARYING(30),
        ap_paterno_empleado CHARACTER VARYING(20)
    )
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT r.id_reservacion, r.fecha_reservacion, r.fecha_ingreso, r.fecha_salida, r.costo_habitaciones, r.costo_pedidos, f.total_factura, c.nombres AS "Nombre cliente", c.ap_paterno AS "Ap_paterno cliente", e.nombres AS "Nombre empleado", e.ap_paterno AS "Ap_paterno empleado"
    FROM Reservaciones r LEFT JOIN Clientes c
        ON (r.id_cliente = c.id_cliente)
        JOIN Empleados e
        ON (r.id_empleado = e.id_empleado)
        LEFT JOIN Factura f
        ON (r.id_reservacion = f.id_reservacion)
    WHERE c.documento_identificacion = id_card_cliente;
END;
$$;

SELECT * FROM todasReservacionesCliente('123456');


/*4. FUNCTION: Cambiar el estado de una reserva Y por la llegada del cliente X que la reservo*/
CREATE OR REPLACE FUNCTION cambiarEstadoReservaVigente(identificador_reservacion INTEGER, id_card_cliente CHARACTER VARYING(30))
    RETURNS BOOL
    LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Reservaciones
    SET estado = 'vigente', fecha_ingreso_cliente = CURRENT_TIMESTAMP
    WHERE id_reservacion = identificador_reservacion AND id_cliente = (SELECT id_cliente
                                                FROM clientes
                                                WHERE documento_identificacion = id_card_cliente);
    
    RETURN FOUND;
END;
$$;

SELECT * FROM cambiarEstadoReservaVigente(123, '12345678');
