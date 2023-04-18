# PROYECTO-2-LIMPIEZA-DE-DATOS-MYSQL
Proyecto de limpieza de datos en mysql

# 📖 Glosario del proyecto

- JSON: El formato JSON (JavaScript Object Notation) es un formato abierto utilizado como alternativa al XML para la transferencia de datos estructurados entre un servidor de Web y una aplicación Web. Su lógica de organización tiene puntos de semejanza con el XML, pero posee una notación diferente.

- Raw: Son datos crudos, que se descargan de su fuente de origen y no han sido procesados, ni limpiados ni transformados.

# 📊 El cliente

[LearnData] es una empresa de e-learning dedicada a la venta de cursos online de análisis de datos. Su principal objetivo es:

- Comenzar a construir una infraestructura tecnológica para analizar sus datos.
- Limpiar los datos para que los puedan consumir las áreas de negocio.

Utiliza las siguientes herramientas para gestionar su negocio:

- **Wocommerce**: Es un plugin de wordpress que te permite convertir tu web a un sitio de ecommerce y vender productos.
- **Stripe**: Es una plataforma de procesamiento de pagos por internet, al igual que paypal.
- **Wordpress**: Es un sistema de gestión de contenidos(CMS), un software utilizado para construir, modificar y mantener sitios web. Se trata del CMS más popular del mercado, ya que lo utilizan el 65,2% de los sitios web cuyo CMS conocemos. Esto se traduce en el 42,4% de todos los sitios web, casi la mitad de Internet.

# ❓ El problema

LearnData quiere comenzar a analizar sus principales métricas financieras, pero no tiene ningun sistema creado para poder capturar, analizar y tomar mejores decisiones.

# 💾 Los datos

# 💡 La solución

Les creamos una nueva base de datos en MYSQL con todos los datos limpios y listos para consumir a partir de sus datos históricos que nos descargaron en un CSV. Luego ya en una fase dos del proyecto tocaría crear los pipelines necesarios para generar la descarga de datos de forma automática re utilizando los scripts de sql para limpiarlos.

# 📝 El proceso

## Análisis previo del problema

1. ¿Que fuentes de datos tiene la empresa?
    1. La empresa utiliza wordpress con un plugin de wocommerce como plataforma de venta de sus cursos online y luego cuenta con stripe como pasarela de pagos a de más de los pagos de tarjeta de crédito.

2. ¿En que formato se descargan los datos?
    1. Los datos crudos los tendremos en csv directamente descargados de las fuentes.

3. ¿Que datos tenemos?
    1. Tenemos datos de los productos osea cursos que se venden, los clientes, de los pedidos y de los pagos recibidos por stripe.

4. Modelo de datos
    1. Tenemos la tabla de pedidos que se relaciona con la de clientes y productos mediante SKU_producto e id_cliente y por otro lado tenemos la tabla la de pagos de stripe que la relacionaremos con la de pedidos por el numero de pedido.

5. Análisis exploratorio de las tablas.

## Ejecución

1. Crear una nueva base de datos en MYSQL llamada “learndata” + tablas:
    1. dim_clientes; dim_producto;fac_pedidos; fac_pagos_stripe

2. Crear la tabla de productos a partir de los datos en crudo.
    1. Chequear como vienen los datos
    2. Cambiar los nombres de los campos
    3. Insertar los campos a la nueva tabla 

3. Crear la tabla de clientes a partir de los datos en crudo
    1. Chequear como vienen los datos
    2. Cambiar los nombres de los campos
    3. Convertir el campo date_created que viene como timestamp a solo fecha
    4. Extraer del campo billing, todos los descriptivos del cliente que necesitamos aprendiendo a parsear un JSON.
    5. Insertar los campos a la nueva tabla 

4. Crear la tabla de pedidos a partir de los datos en crudo
    1. Chequear como vienen los datos
    2. Cambiar los nombres de los campos
    3. Sustituir el nombre del producto por el id.
    4. Normalizar la columna método de pago.
    5. Convertir a date la columna fecha_pedido
    6. Redondear decimales de la columna coste_articulo a enteros
    7. Insertamos los pedidos a la tabla
    
 5. Crear la tabla de cobros de stripe a partir de los datos en crudo
    1. Chequear como vienen los datos
    2. Cambiar los nombres de los campos
    3. Obtener el número de pedido con la función RIGHT. Quitar el numero de pedido de la descripción que es lo que nos va a permitir unir esta tabla con otras
    4. Pasar a timestamp el campo “created”
    5. Reemplazar las commas por puntos
    6. Convertir el número a decimal con dos lugares despues de la comma.
    7. Insertar tabla en nueva

## 🎉 Conclusiones - ¿Como seguimos?

Una vez finalizado el proceso de creación de una nueva base de datos & limpieza de datos las tablas están listas para ser consumidas por los expertos en visualización de datos. También es necesario determinar con el equipo de ingenieria de datos la realización de los pipelines de datos y automatización de la descarga, limpieza de los mismos.
