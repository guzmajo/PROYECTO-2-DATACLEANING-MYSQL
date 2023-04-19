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


# English Version


# PROJECT-2-DATA-CLEANING-MYSQL
Data cleaning project in MySQL

# 📖 Project glossary

- JSON: The JSON (JavaScript Object Notation) format is an open format used as an alternative to XML for transferring structured data between a Web server and a Web application. Its logic of organization has points of similarity with XML, but it has a different notation.

- Raw: They are raw data, which are downloaded from their source of origin and have not been processed, cleaned, or transformed.

# 📊 The client

[LearnData] is an e-learning company dedicated to selling online courses on data analysis. Its main objective is:

- Start building a technological infrastructure to analyze your data.
- Clean the data so that the business areas can consume it.

It uses the following tools to manage its business:

- **Wocommerce**: It is a WordPress plugin that allows you to convert your website into an e-commerce site and sell products.
- **Stripe**: It is an online payment processing platform, just like PayPal.
- **WordPress**: It is a content management system (CMS), software used to build, modify and maintain websites. It is the most popular CMS on the market, as it is used by 65.2% of the websites whose CMS we know. This translates into 42.4% of all websites, almost half of the Internet.

# ❓ The problem

LearnData wants to start analyzing its main financial metrics, but it has no system created to be able to capture, analyze and make better decisions.

# 💾 The data

# 💡 The solution

We created a new MYSQL database with all the clean and ready-to-use data from their historical data that they downloaded in a CSV. Then in the second phase of the project, it would be necessary to create the necessary pipelines to generate the data download automatically by reusing the SQL scripts to clean them.

# 📝 The process

## Previous analysis of the problem

1. What data sources does the company have?
    1. The company uses WordPress with a wocommerce plugin as a platform for selling its online courses and then has Stripe as a payment gateway in addition to credit card payments.

2. In what format are the data downloaded?
    1. The raw data will be in CSV directly downloaded from the sources.

3. What data do we have?
    1. We have data on the products or courses that are sold, the customers, the orders, and the payments received by Stripe.

4. Data model
    1. We have the order table that is related to the customer and product tables by SKU_product and id_customer and on the other hand we have the stripe payment table that we will relate to the order table by the order number.

5. Exploratory analysis of tables.

## Execution

1. Create a new database in MYSQL called "learndata" + tables:
    1. dim_customers; dim_product; fac_orders; fac_payments_stripe

2. Create the product table from the raw data.
    1. Check how the data comes
    2. Change the field names
    3. Insert the fields into the new table

3. Create the customer table from the raw data
    1. Check how the data comes
    2. Change the field names
    3. Convert the date_created field that comes as timestamp to just a date
    4. Extract from the billing field, all the customer descriptors that we need by learning to parse a JSON.
    5. Insert the fields into the new table

4. Create the order table from the raw data
    1. Check how the data comes
    2. Change the field names
    3. Replace the product name with the id.
    4. Normalize the payment method column.
    5. Convert to date the order_date column
    6. Round decimals of the item_cost column to integers
    7. Insert orders into a table
    
5. Create the stripe payment table from the raw data
    1. Check how the data comes
    2. Change the field names
    3. Get the order number with the RIGHT function. Remove the order number from the description which is what will allow us to join this table with others
    4. Convert to timestamp the "created" field
    5. Replace commas with dots
    6. Convert the number to decimal with two places after the comma.
    7. Insert the table into new

## 🎉 Conclusions - How do we continue?

Once the process of creating a new database & data cleaning is finished, the tables are ready to be consumed by the data visualization experts. It is also necessary to determine with the data engineering team the realization of the data pipelines and automation of the download, and cleaning of them.



