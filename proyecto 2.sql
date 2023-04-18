
# 1. Crear la nueva base de datos en MYSQL

CREATE SCHEMA learndata ;

# 2. Crear la tabla de clientes para almacenar la información de nuestros clientes.

CREATE TABLE dim_clientes (
    id_cliente int,
    fecha_creacion_cliente DATE,
    nombre_cliente varchar(100),
    apellido_cliente varchar(100),
    email_cliente varchar(100),
    telefono_cliente varchar(100),
    region_cliente varchar(100),
    pais_cliente varchar(100),
    codigo_postal_cliente varchar(100),
    direccion_cliente varchar(255),
    PRIMARY KEY (id_cliente)
   );
   
# 3. Crear la tabla productos para almacenar la información sobre los curso que vendemos.

CREATE TABLE dim_producto (
  id_producto int ,
  sku_producto int NOT NULL,
  nombre_producto varchar(100),
  publicado_producto BOOLEAN ,
  inventario_producto varchar(100),
  precio_normal_producto INT ,
  categoria_producto varchar(100),
  PRIMARY KEY (sku_producto)
);

# 4. Crear la tabla de pedidos donde se almacenarán todas nuestras ventas

CREATE TABLE fac_pedidos (
		id_pedido INT NOT NULL,
  sku_producto INT,
  estado_pedido VARCHAR(50),
  fecha_pedido DATE ,
  id_cliente INT  ,
  tipo_pago_pedido VARCHAR(50) ,
  costo_pedido INT  ,
  importe_de_descuento_pedido decimal(10,0) ,
  importe_total_pedido INT ,
  cantidad_pedido INT  ,
  codigo_cupon_pedido VARCHAR(100),
  PRIMARY KEY (id_pedido),
  FOREIGN KEY (id_cliente) REFERENCES dim_clientes (id_cliente),
  FOREIGN KEY (sku_producto) REFERENCES dim_producto (sku_producto)
);

# 5. Crear la tabla de pagos de stripe qeu recibimos

CREATE TABLE fac_pagos_stripe (
  id_pago int,
  fecha_pago datetime(6) ,
  id_pedido int ,
  importe_pago int ,
  moneda_pago VARCHAR(5),
  comision_pago decimal(10,2) ,
  neto_pago decimal(10,2) ,
  tipo_pago VARCHAR(50),
  PRIMARY KEY (id_pago),
  FOREIGN KEY (id_pedido) REFERENCES fac_pedidos (id_pedido)
)

-- -----------------------------------------------------------------------------------------------------------------------
-- -------- Crear la tabla de productos a partir de los datos en crudo  -----------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------


# 1. Análisis previo para determinar situación de la tabla

SELECT * 
FROM learndata_crudo.raw_productos_wocommerce;

---- Concluimos que los datos de esta tabla vienen bien por lo que no será necesario ninguna transformación extra.

# 2. Creación de nueva tabla con nombres adecuados 

INSERT INTO learndata.dim_producto

SELECT
id as id_producto,
sku as sku_producto,
nombre as nombre_producto,
publicado as publicado_producto,
inventario as inventario_producto,
precio_normal as precio_normal_producto,
categorias as categoria_producto
FROM learndata_crudo.raw_productos_wocommerce;

-- -----------------------------------------------------------------------------------------------------------------------
-- -------- Crear la tabla de clientes a partir de los datos en crudo  -----------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------

INSERT INTO learndata.dim_clientes

SELECT 
id as id_cliente,
DATE(STR_TO_DATE(date_created,"%d/%m/%Y %H:%i:%s")) as fecha_creacion_cliente,
JSON_VALUE(billing,'$[0].first_name') AS nombre_cliente,
JSON_VALUE(billing,'$[0].last_name') AS apellido_cliente,
JSON_VALUE(billing,'$[0].email') AS email_cliente,
JSON_VALUE(billing,'$[0].phone') AS telefono_cliente,
JSON_VALUE(billing,'$[0].Region') AS region_cliente,
JSON_VALUE(billing,'$[0].country') AS pais_cliente,
JSON_VALUE(billing,'$[0].postcode') AS codigo_postal_cliente,
JSON_VALUE(billing,'$[0].address_1') AS direccion_cliente
FROM learndata_crudo.raw_clientes_wocommerce;

# Insertamos los datos limpios y las columnas que queremos a nuestra nueva tabla.

INSERT INTO learndata.fac_pedidos
SELECT
	numero_de_pedido as id_pedido,
	CASE WHEN p.SKU_producto IS NULL THEN 3 ELSE p.SKU_producto END as SKU_producto,
	estado_de_pedido as estado_pedido,
	DATE(fecha_de_pedido) as fecha_pedido,
	`id cliente` AS id_cliente,
	CASE WHEN titulo_metodo_de_pago LIKE '%Stripe%' THEN 'Stripe' ELSE 'Tarjeta' END AS metodo_pago_pedido,
	coste_articulo AS costo_pedido,
	importe_de_descuento_del_carrito AS importe_de_descuento_pedido, 
	importe_total_pedido AS importe_total_pedido,
	cantidad AS cantidad_pedido,
	cupon_articulo AS codigo_cupon_pedido
FROM learndata_crudo.raw_pedidos_wocommerce w
LEFT JOIN learndata.dim_producto p on p.nombre_producto = w.nombre_del_articulo;

# Trato de duplicados -- detectamos que no nos deja insertar la información porque encontramos un duplicado --

SELECT * FROM learndata_crudo.raw_pedidos_wocommerce
WHERE numero_de_pedido = 41624;

----- Debemos primero analizar si podemos detectar porque viene y si no se elimina, reportamos al equipo que corresponda --

DELETE FROM learndata_crudo.raw_pedidos_wocommerce WHERE numero_de_pedido = 41624 and `id cliente` = 1324;

# Una vez eliminado volves a ejecutar la query --

# 9 Insertamos los datos limpios y las columnas que queremos a nuestra nueva tabla.

SET @@SESSION.sql_mode='ALLOW_INVALID_DATES'; 

INSERT INTO learndata.fac_pagos_stripe (fecha_pago,id_pedido,importe_pago,moneda_pago,comision_pago,neto_pago,tipo_pago)

SELECT
TIMESTAMP(created) AS fecha_pago,
RIGHT(description,5) AS id_pedido,
amount AS importe_pago,
currency AS moneda_pago,
CAST(REPLACE(fee,',','.')AS DECIMAL(10,2)) as comision_pago,
CAST(REPLACE(net,',','.') AS DECIMAL(10,2)) as  neto_pago,
type AS tipo_pago
FROM learndata_crudo.raw_pagos_stripe;