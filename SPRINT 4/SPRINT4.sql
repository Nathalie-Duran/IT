
create database Empresa;

SET foreign_key_checks = 0;

USE Empresa;
CREATE TABLE IF NOT EXISTS Empresa.transactions (
    id VARCHAR(36) PRIMARY KEY,  
    card_id VARCHAR(10),  
    business_id VARCHAR(10),  
    timestamp DATETIME,  
    amount DECIMAL(10,2),  
    declined TINYINT(1),  
    product_ids VARCHAR(255),  
    user_id INT,  
    lat DECIMAL(10,6),  
    longitude DECIMAL(10,6) ,
    CONSTRAINT fk_card FOREIGN KEY (card_id) REFERENCES Empresa.credit_cards(id) ,  
    CONSTRAINT fk_business FOREIGN KEY (business_id) REFERENCES Empresa.companies(company_id),  
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES Empresa.users(id)
);





LOAD DATA INFILE "C:/nat/SPRINT 4/transactions.csv"
INTO TABLE Empresa.transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;











CREATE TABLE IF NOT EXISTS Empresa.users (
    id INT PRIMARY KEY, 
    name VARCHAR(50), 
    surname VARCHAR(50), 
    phone VARCHAR(20), 
    email VARCHAR(150), 
    birth_date VARCHAR(50), 
    country VARCHAR(50), 
    city VARCHAR(100), 
    postal_code CHAR(10), 
    address VARCHAR(255)
);







use Empresa;
LOAD DATA INFILE "C:/nat/SPRINT 4/users_ca.csv"
into table Empresa.users
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;







LOAD DATA INFILE "C:/nat/SPRINT 4/users_uk.csv" 
into table Empresa.users 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_usa.csv"
into table Empresa.users
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;


update Empresa.users
set birth_date = str_to_date(birth_date, '%b %d, %Y');

alter table Empresa.users modify column birth_date date;





CREATE TABLE IF NOT EXISTS Empresa.credit_cards (
    id VARCHAR(10) PRIMARY KEY,
    user_id INT,
    iban CHAR(34),
    pan CHAR(30),
    pin CHAR(4),
    cvv CHAR(3),
    track1 VARCHAR(76),
    track2 VARCHAR(37),
    expiring_date varchar(10)
);







LOAD DATA INFILE "C:/nat/SPRINT 4/credit_cards.csv"
into table Empresa.credit_cards 
fields terminated by ','
lines terminated by '\n'
ignore 1 lines;




/* Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/

select id, name, surname
from Empresa.users
where id in (
				select user_id 
				from Empresa.transactions
				group by user_id
				having count(transactions.id)>30);

/*Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, 
almenys 4 taules de les quals puguis realitzar les següents consultes:

- Exercici 2 Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.*/


select company_id, company_name, iban, round(avg(amount),2) as mitjana
from Empresa.transactions
	join Empresa.credit_cards on (transactions.card_id=credit_cards.id)
    join Empresa.companies on (transactions.business_id=companies.company_id)
where company_name ='Donec Ltd'
group by company_id, company_name,iban;
    
    
    
    
    
    
    
    ### NIVEL 2


/*Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes 
tres transaccions van ser declinades i genera la següent consulta:*/

create table credit_cards_rechazada as
	select
		card_id,
		case
			when sum(declined) = 3 then 'Denegada'
			else 'Activa'
		end as verificación
	from	
		(select
			card_id, 
			timestamp,
			declined,
			row_number() over(partition by card_id order by timestamp desc ) as fecha # enumera de 1 a N los casos segun el orden
		from Empresa.transactions) 
	as popular
	where fecha <=3
	group by card_id; 


# Afegeixo una FK per relacionar les taules

alter table Empresa.credit_cards_rechazada
	add constraint foreign key (card_id) references Empresa.credit_cards(id);















#Exercici 1 Quantes targetes estan actives? 


SELECT COUNT(DISTINCT card_id) AS tarjetas_activas
FROM Empresa.transactions
WHERE card_id IN (
    SELECT card_id 
    FROM Empresa.credit_cards_rechazada 
    WHERE verificación = 'Activa'
);














-- NIVEL 3




#Creación tabla "products"


CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price VARCHAR(15),
    colour VARCHAR(50),
    weight FLOAT,
    warehouse_id VARCHAR(10)
);










#inserción de datos tabla "products"
LOAD DATA INFILE "C:/nat/SPRINT 4/products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;














# El campo products_id de la tabla transaction contiene los id de los productos con comas en la misma celda

## Transformación transaction.product_id 

# transaction.product_ids (convertir en orders) 
CREATE TABLE orders SELECT product_ids FROM Empresa.transactions;

# Creación de un id a orders
ALTER TABLE orders ADD id INT; #Creación del campo orders.id

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
# ¿Cómo funciona? -> Esta diseñado para un máximo de 4 products_id separado por ",":
# Voy a insentar en las columnas product_id1 | _id2 | _id3 | _id4,  los valores que cumplan la siguiente condición:



INSERT INTO temp_orders (id, product_id1, product_id2, product_id3, product_id4)
SELECT id,
    CASE WHEN LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',','')) + 1 >= 1 THEN CAST(SUBSTRING_INDEX(product_ids, ',', 1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',','')) + 1 >= 2 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 2), ',', -1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',','')) + 1 >= 3 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 3), ',', -1) AS UNSIGNED) ELSE NULL END,
    CASE WHEN LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',',''
    )) + 1 >= 4 THEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 4), ',', -1) AS UNSIGNED) ELSE NULL END
FROM orders;










# Una vez resuelta la separación de los valores, se deben transponer todo a una mismo campo respetando sus ids. 
# Tabla auxiliar "transp_order" para transponer los valores:

CREATE TABLE transp_order (
	id INT NOT NULL,
    product_id INT
    );
    
    
    
    
    
    
    
    
    
    
    
    

# Insertar los valores transpuestos desde "temp_orders" (product_id1 | _id2 | _id3 | _id4) a la tabla "transp_order", exceptuando los datos NULL.


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

ALTER TABLE transactions DROP product_ids;





# Y se crea un order_id (INT). 

ALTER TABLE transactions ADD order_id INT;

# Le asigno un id a transaction.order_id

SET @row_number = 0;
UPDATE transactions SET order_id = (@row_number := @row_number + 1);











SELECT p.id AS idProducte, p.product_name AS productName, p.colour AS color, count(o.product_id) AS quantitatVenuda
FROM orders o
JOIN products p
ON o.product_id = p.id
JOIN transactions t
ON o.id = t.order_id
WHERE t.declined = 0
GROUP BY idProducte
ORDER BY quantitatVenuda DESC;














update Empresa.credit_cards
set expiring_date = str_to_date(expiring_date, '%m/%d/%y');















alter table Empresa.credit_cards modify column expiring_date date;












CREATE TABLE IF NOT EXISTS Empresa.companies (
    company_id VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(150),
    phone VARCHAR(20),
    email VARCHAR(150),
    country VARCHAR(50),
    website VARCHAR(200)
);










LOAD DATA INFILE "C:/nat/SPRINT 4/companies.csv"
into table Empresa.companies 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;












