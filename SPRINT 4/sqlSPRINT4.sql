
#Creación de la estructura de datos utilizando los csv descargados del sprint 4
CREATE DATABASE empresa;
USE empresa;


#Creación tabla "transaction"
USE empresa;
CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255),
    card_id VARCHAR(255),
    business_id VARCHAR(255),
    timestamp VARCHAR(255),
    amount VARCHAR(255),
    declined VARCHAR(255),
    products_id VARCHAR(255),
    user_id VARCHAR(255),
    lat VARCHAR(255),
    longitude VARCHAR(255)
);
#COMPROBAR SI lOCAL INFILE ESTÁ DESHABILITADO
SHOW VARIABLES LIKE 'local_infile';

#Habilitat temporalment LOCAL INFILE per poder carregar l'arxiu CSV
SET GLOBAL local_infile = 1;



SHOW VARIABLES LIKE 'secure_file_priv';








#inserción de datos tabla "transaction"
USE empresa;
LOAD DATA INFILE "C:/nat/SPRINT 4/transactions.csv"
 INTO TABLE transaction 
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;










#Creación tabla "credit_card"
USE empresa;
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(255),
    user_id VARCHAR(255),
    iban VARCHAR(255),
    pan VARCHAR(255),
    pin VARCHAR(255),
    cvv VARCHAR(255),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(255)
);
#inserción de datos tabla "credit_card"
USE empresa;

LOAD DATA INFILE "C:/nat/SPRINT 4/credit_cards.csv"
INTO TABLE credit_card 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


#Creación tabla "products"
USE empresa;

CREATE TABLE IF NOT EXISTS products (
	id VARCHAR(255),
    product_name VARCHAR(255),
    price VARCHAR(255),
    colour VARCHAR(255),
    weight VARCHAR(255),
    warehouse_id VARCHAR(255)
);

#inserción de datos tabla "products"
LOAD DATA INFILE "C:/nat/SPRINT 4/products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;



#Creación tabla "companies"
USE empresa;

CREATE TABLE IF NOT EXISTS companies (
	id VARCHAR(255),
    company_name VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    country VARCHAR(255),
    website VARCHAR(255)
);

#inserción de datos tabla "companies"
USE empresa;

LOAD DATA INFILE "C:/nat/SPRINT 4/companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


#Creación tabla "users_ca"
USE empresa;

CREATE TABLE IF NOT EXISTS users_ca (
	id VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    birth_date VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255),
    address VARCHAR(255)
);

#inserción de datos tabla "users_ca"
USE empresa;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_ca.csv"
INTO TABLE users_ca
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

#Creación tabla users_uk
USE empresa;

CREATE TABLE IF NOT EXISTS users_uk (
	id VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    birth_date VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255),
    address VARCHAR(255)
);

#inserción de datos tabla "users_uk"
USE empresa;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_uk.csv"
INTO TABLE users_uk
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;












#Creación tabla "users_usa"
CREATE TABLE IF NOT EXISTS users_usa (
	id VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    birth_date VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255),
    address VARCHAR(255)
);

#inserción de datos tabla "users_usa"
USE empresa;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_usa.csv"
INTO TABLE users_usa
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


#Crea una tabla llamada user para unir las tres tablas de acer UNION de las 3 tablas "user"
CREATE TABLE users (
	id VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    birth_date VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255),
    address VARCHAR(255)
);










#Uso UNION para unir las tres tablas de usuarios
INSERT INTO users (id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address 
FROM users_ca
UNION ALL
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address 
FROM users_uk
UNION ALL
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address 
FROM users_usa;



#Eliminación de las tablas users_ca, users_uk, users_usa
DROP TABLE empresa.users_ca;
DROP TABLE empresa.users_uk;
DROP TABLE empresa.users_usa;




# Modifico el tipo de dato de las tablas para hacer un uso eficiente del espacio 
# companies -> "company". 
ALTER TABLE companies RENAME company;
ALTER TABLE company MODIFY id VARCHAR (6) PRIMARY KEY NOT NULL;
ALTER TABLE company MODIFY company_name VARCHAR(35) NOT NULL;
ALTER TABLE company MODIFY phone VARCHAR(14) NOT NULL;   
ALTER TABLE company MODIFY email VARCHAR(40) NOT NULL;   
ALTER TABLE company MODIFY country VARCHAR(15) NOT NULL;   
ALTER TABLE company MODIFY website VARCHAR(32) NOT NULL; 









# "credit_card".
ALTER TABLE credit_card MODIFY id VARCHAR(8) PRIMARY KEY NOT NULL;
ALTER TABLE credit_card MODIFY iban VARCHAR(32) NOT NULL;
ALTER TABLE credit_card MODIFY pan VARCHAR(20) NOT NULL;
ALTER TABLE credit_card MODIFY pin INT NOT NULL;
ALTER TABLE credit_card MODIFY cvv INT NOT NULL;
ALTER TABLE credit_card MODIFY track1 VARCHAR(46) NOT NULL;
ALTER TABLE credit_card MODIFY track2 VARCHAR(32) NOT NULL;
ALTER TABLE credit_card MODIFY expiring_date DATE;



# products -> "product".
ALTER TABLE products RENAME product;
ALTER TABLE product MODIFY id INT PRIMARY KEY NOT NULL;
ALTER TABLE product MODIFY product_name VARCHAR(30) NOT NULL;
ALTER TABLE product MODIFY colour VARCHAR(7) NOT NULL;
ALTER TABLE product MODIFY weight FLOAT NOT NULL;
ALTER TABLE product MODIFY warehouse_id VARCHAR(7) NOT NULL;

# Sacar el signo "$" al campo price antes de cambiar a FLOAT
UPDATE product
SET price = REPLACE(price, '$', '');
ALTER TABLE product MODIFY price FLOAT NOT NULL;





# "transaction"
ALTER TABLE transaction MODIFY id VARCHAR(255) PRIMARY KEY NOT NULL;
ALTER TABLE transaction CHANGE card_id credit_card_id VARCHAR(8) NOT NULL;
ALTER TABLE transaction CHANGE business_id company_id VARCHAR(6) NOT NULL;
ALTER TABLE transaction MODIFY timestamp DATETIME NOT NULL;
ALTER TABLE transaction MODIFY amount DECIMAL(10,2) NOT NULL;
ALTER TABLE transaction CHANGE id id INT PRIMARY KEY NOT NULL;
ALTER TABLE transaction MODIFY user_id INT NOT NULL;
ALTER TABLE transaction MODIFY lat FLOAT NOT NULL;
ALTER TABLE transaction MODIFY longitude FLOAT NOT NULL;

#Corrección de la linea que da error
SHOW KEYS FROM transaction WHERE Key_name = 'PRIMARY';
# id ya es PK




# users -> user
ALTER TABLE users RENAME user;
ALTER TABLE user MODIFY id INT PRIMARY KEY NOT NULL;
ALTER TABLE user MODIFY name VARCHAR(10) NOT NULL;
ALTER TABLE user MODIFY surname VARCHAR(11) NOT NULL;
ALTER TABLE user MODIFY phone VARCHAR(15) NOT NULL;
ALTER TABLE user MODIFY email VARCHAR(40) NOT NULL;
ALTER TABLE user MODIFY country VARCHAR(14) NOT NULL;
ALTER TABLE user MODIFY city VARCHAR(24) NOT NULL;
ALTER TABLE user MODIFY postal_code VARCHAR(24) NOT NULL;
ALTER TABLE user MODIFY address VARCHAR(36) NOT NULL;








# Tabla user Campo birth_date -> STR_TO_DATE
ALTER TABLE user ADD COLUMN birth_date_temp DATE; 
UPDATE user SET birth_date_temp = STR_TO_DATE(birth_date, '%b %d, %Y');
ALTER TABLE user DROP birth_date;
ALTER TABLE user CHANGE birth_date_temp birth_date DATE NOT NULL;







# Creación de FK 
alter table empresa.transaction add constraint foreign key (user_id) references user(id);
alter table empresa.transaction add constraint foreign key (credit_card_id) references credit_card(id);
alter table empresa.transaction add constraint foreign key (company_id) references company(id);



# El campo products_id de la tabla transaction contiene los id de los productos con comas en la misma celda

## Transformación transaction.product_id 

# transaction.product_id (convertir en orders) 
CREATE TABLE orders SELECT products_id FROM transaction;




# Creación de un id a orders
ALTER TABLE orders ADD id INT; #Creación del campo orders.id



SET @row_number = 0;

UPDATE orders 
SET id = (SELECT @row_number := @row_number + 1);







# Asignación de un id

SET @row_number = 0;

UPDATE orders 
SET id = (SELECT @row_number := @row_number + 1);
























































# Creación de una tabla temporal "temp_orders" donde coloco el valor luego de cada ","
CREATE TABLE temp_orders (
	id INT,
	product_id1 INT,
	product_id2 INT,
	product_id3 INT,
   	product_id4 INT
    );
    
    
    
    
    
    
    
    
#[X] Separo los números delimitados por "," en campos.
#¿Cómo funciona? -> Esta diseñado para un máximo de 4 products_id separado por ",":
#Voy a insentar en las columnas product_id1 | _id2 | _id3 | _id4,  los valores que cumplan la siguiente condición:
## 1 valor:
#Si el largo de products_id menos el largo el largo de products_id (reemplazando la "," por un caracter vacío) es igual a 0, 
#significa que no hay una "," por lo tanto solo debo castear toda la cadena a INT y colocarla en el campo product_id1
## 2 valores:
#Si el largo de products_id menos el largo el largo de products_id (reemplazando la "," por un caracter vacío) es igual a 1, 
#significa que hay una "," por lo tanto casteo el valor que esté a la izquierda de la "," al siguiente campo (product_id2)
## 3 valores:
#Si el largo de products_id menos el largo el largo de products_id (reemplazando la "," por un caracter vacío) es igual a 2, 
#significa que hay dos "," por lo tanto casteo el valor que esté a la izquierda de la última "," al siguiente campo (product_id3)
#(Los anteriores ya se habrán decantado en product_id1, product_id2)
## 4 valores:
#Si el largo de products_id menos el largo el largo de products_id (reemplazando la "," por un caracter vacío) es igual a 3, 
#significa que hay tres "," por lo tanto casteo el valor que esté a la izquierda de la última "," al siguiente campo (product_id4)
#(Los anteriores ya se habrán decantado en product_id1, product_id2 y product_id3)
## ¿Qué pasa cuando no se cumplen los 4 valores? Se complentan los campos vacios con un NULL.



INSERT INTO temp_orders (id, product_id1, product_id2, product_id3, product_id4)
SELECT id,
    CASE WHEN LENGTH(products_id) - LENGTH(REPLACE(products_id, ',','')) + 1 >= 1 THEN CAST(SUBSTRING_INDEX(products_id, ',', 1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(products_id) - LENGTH(REPLACE(products_id, ',','')) + 1 >= 2 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(products_id, ',', 2), ',', -1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(products_id) - LENGTH(REPLACE(products_id, ',','')) + 1 >= 3 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(products_id, ',', 3), ',', -1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(products_id) - LENGTH(REPLACE(products_id, ',',''
    )) + 1 >= 4 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(products_id, ',', 4), ',', -1) AS UNSIGNED) ELSE NULL END
FROM orders;













# Una vez resuelta la separación de los valores, se deben transponer todo a una mismo campo respetando sus ids. 
# Tabla auxiliar "transp_order" para transponer los valores:

CREATE TABLE transp_order (
	id INT NOT NULL,
    product_id INT
    );
    
    
    
    
    
    
    
    
    
    
    
    
    

# Insertar los valores transpuestos desde "temp_orders" (product_id1 | _id2 | _id3 | _id4) a la tabla "transp_order", 
# exceptuando los datos NULL.
INSERT INTO transp_order (id, product_id)
SELECT id, product_id1 
FROM temp_orders
WHERE product_id1 IS NOT NULL 
UNION ALL
SELECT id, product_id2 
FROM temp_orders 
WHERE product_id2 IS NOT NULL
UNION ALL
SELECT id, product_id3 
FROM temp_orders
WHERE product_id3 IS NOT NULL
UNION ALL
SELECT id, product_id4 
FROM temp_orders
WHERE product_id4 IS NOT NULL;




# Eliminación de la tabla original "orders" la cual será reemplazada con "transp_order"

DROP table orders;

# Renombrar la tabla "transp_order" a su valor final "orders".

ALTER TABLE transp_order RENAME orders;

# Borrar tabla temporal "temp_orders"

DROP TABLE temp_orders;

# En la tabla "transaction" ahora esa columna de comas se borra (products_id).

ALTER TABLE transaction DROP products_id;





# Y se crea un order_id (INT). 

ALTER TABLE transaction ADD order_id INT;

# Le asigno un id a transaction.order_id

SET @row_number = 0;
UPDATE transaction SET order_id = (@row_number := @row_number + 1);











-- NIVEL 1


/* Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/


select id, name, surname
from empresa.user
where id in (
				select user_id 
				from empresa.transaction
				group by user_id
				having count(order_id)>30);















/*-- Exercici 2
Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.*/


select company_id, company_name, iban, round(avg(amount),2) as mitjana
from empresa.transaction
	join empresa.credit_card on (transaction.credit_card_id=credit_card.id)
    join empresa.company on (transaction.company_id=company.id)
where company_name ='Donec Ltd'
group by company_id, company_name,iban;






















-- NIVEL 2

/*Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

Exercici 1
Quantes targetes estan actives?
*/
create table credit_cards_rechazada as
	select credit_card_id,
		case
			when sum(declined) = 3 then 'Denegada'
			else 'Activa'
		end as verificación
	from	
		(select
			credit_card_id, 
			timestamp,
			declined,
			row_number() over(partition by credit_card_id order by timestamp desc ) as fecha # enumera de 1 a N los casos segun el orden
		from empresa.transaction) 
	as popular
	where fecha <=3
	group by credit_card_id; 







select 
	count(distinct credit_cards_rechazada.credit_card_id) as tarjetas_activas
from empresa.transaction
	join empresa.credit_cards_rechazada on (transaction.credit_card_id=credit_cards_rechazada.credit_card_id)
where credit_cards_rechazada.verificación='Activa';























-- NIVEL 3

/*Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

Exercici 1
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/









SELECT p.id AS idProducte, p.product_name AS productName, p.colour AS color, count(o.product_id) AS quantitatVenuda
FROM orders o
JOIN product p
ON o.product_id = p.id
JOIN transaction t
ON o.id = t.order_id
WHERE t.declined = 0
GROUP BY idProducte
ORDER BY quantitatVenuda DESC;





