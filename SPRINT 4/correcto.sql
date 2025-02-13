
create database Empres;

SET foreign_key_checks = 0;

USE Empres;
create table if not exists Empres.transactions (
        id varchar(255) primary key,
        card_id varchar(20) ,
        business_id varchar(15) ,
        date varchar(100),
        amount decimal(10, 2),
        declined boolean,
        product_ids varchar(20),
        user_id smallint,
        lat varchar(100),
        longitude varchar(100)
    );

LOAD DATA INFILE "C:/nat/SPRINT 4/transactions.csv"
into table Empres.transactions
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;


create table if not exists Empres.users (
        id smallint primary key,
        name varchar(100),
        surname varchar(100),
        phone varchar(150),
        email varchar(150),
        birth_date varchar(100),
        country varchar(150),
        city varchar(150),
        postal_code varchar(100),
        address varchar(255)           
    );
SET foreign_key_checks = 1;

use Empres;
LOAD DATA INFILE "C:/nat/SPRINT 4/users_ca.csv"
into table Empres.users
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_uk.csv" 
into table Empres.users 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

LOAD DATA INFILE "C:/nat/SPRINT 4/users_usa.csv"
into table Empres.users
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# Afegeixo la FK entre transaction i users
alter table Empres.transactions add constraint foreign key (user_id) references users(id);

update Empres.users
set birth_date = str_to_date(birth_date, '%b %d, %Y');

alter table Empres.users modify column birth_date date;

create table if not exists Empres.credit_cards (
        id varchar (20) primary key,
        user_id smallint,
        iban varchar(50),
        pan varchar(50),
        pin varchar(4),
        cvv varchar(4),
        track1 varchar(150),
        track2 varchar(150),
        expering_date varchar(100)
        );

LOAD DATA INFILE "C:/nat/SPRINT 4/credit_cards.csv"
into table Empres.credit_cards 
fields terminated by ','
lines terminated by '\n'
ignore 1 lines;


alter table Empres.transactions add constraint foreign key (card_id) references credit_cards(id);

update Empres.credit_cards
set expering_date = str_to_date(expering_date, '%m/%d/%y');

alter table Empres.credit_cards modify column expering_date date;

create table if not exists Empres.companies (
        company_id varchar(15) primary key,
        company_name varchar(255),
        phone varchar(15),
        email varchar(100),
        country varchar(100),
        website varchar(255)
    );


LOAD DATA INFILE "C:/nat/SPRINT 4/companies.csv"
into table Empres.companies 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

alter table Empres.transactions add constraint foreign key (business_id) references companies(company_id);

set foreign_key_checks=1;



#Creación tabla "products"
CREATE TABLE products (
	id VARCHAR(255) primary key,
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


/* Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/

select id, name, surname
from Empres.users
where id in (
				select user_id 
				from Empres.transactions
				group by user_id
				having count(transactions.id)>30);

/*Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, 
almenys 4 taules de les quals puguis realitzar les següents consultes:

- Exercici 2 Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.*/


select company_id, company_name, iban, round(avg(amount),2) as mitjana
from Empres.transactions
	join Empres.credit_cards on (transactions.card_id=credit_cards.id)
    join Empres.companies on (transactions.business_id=companies.company_id)
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
			date,
			declined,
			row_number() over(partition by card_id order by date desc ) as fecha # enumera de 1 a N los casos segun el orden
		from Empres.transactions) 
	as popular
	where fecha <=3
	group by card_id; 

set foreign_key_checks=0;
alter table Empres.credit_cards_rechazada
	add constraint foreign key (card_id) references Empres.credit_cards(id);
set foreign_key_checks=1;

#Exercici 1 Quantes targetes estan actives? 

select 
	count(distinct credit_cards_rechazada.card_id) as tarjetas_activas
from Empres.transactions
	join Empres.credit_cards_rechazada on (transactions.card_id=credit_cards_rechazada.card_id)
where credit_cards_rechazada.verificación='Activa';


-- NIVEL 3

# El campo products_id de la tabla transaction contiene los id de los productos con comas en la misma celda

## Transformación transaction.product_id 

# transaction.product_id (convertir en orders) 
CREATE TABLE orders SELECT product_ids FROM Empres.transactions;

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
#¿Cómo funciona? -> Esta diseñado para un máximo de 4 products_id separado por ",":
#Voy a insentar en las columnas product_id1 | _id2 | _id3 | _id4,  los valores que cumplan la siguiente condición:



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



SELECT p.id AS idProducte, p.product_name AS productName, p.colour AS color, count(o.product_id) AS quantitatVenuda
FROM orders o
JOIN product p
ON o.product_id = p.id
JOIN transaction t
ON o.id = t.order_id
WHERE t.declined = 0
GROUP BY idProducte
ORDER BY quantitatVenuda DESC;




