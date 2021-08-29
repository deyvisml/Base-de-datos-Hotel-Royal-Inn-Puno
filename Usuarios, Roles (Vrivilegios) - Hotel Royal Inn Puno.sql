/* Creacion de los usuarios*/
CREATE USER administrador_bd WITH PASSWORD 'administrador_bd';
CREATE USER recepcionista WITH PASSWORD 'recepcionista';
CREATE USER camarero WITH PASSWORD 'camarero';
CREATE USER seg_garage WITH PASSWORD 'seg_garage';

/* Creacion de rol para el administrador*/
alter role administrador_bd WITH superuser	CREATEDB CREATEROLE;

/* Creacion de los previlegios para los usuarios*/
GRANT ALL PRIVILEGES ON DATABASE hotel_royal_inn_puno TO administrador_bd;
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE reservaciones, clientes, pedidos, factura TO recepcionista;
GRANT SELECT, UPDATE ON TABLE pedidos TO camarero;
GRANT SELECT, UPDATE ON TABLE vehiculos TO seg_garage;