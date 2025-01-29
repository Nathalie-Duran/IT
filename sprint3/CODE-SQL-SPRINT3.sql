
-- NIVELL 1

-- Exercici 1
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials 
-- sobre les targetes de crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i 
-- establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
-- Després de crear la taula serà necessari que ingressis la informació del document denominat 
-- "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.


# Crear la tabla credit_card
CREATE TABLE IF NOT EXISTS CREDIT_CARD (
    id VARCHAR(8) PRIMARY KEY NOT NULL,
    iban VARCHAR(32) NULL,
    pan VARCHAR(20) NULL,
    pin SMALLINT NULL,
    cvv SMALLINT NULL,
    expiring_date varchar(20) NULL
);

## Creo la tabla sin foreign key
## Comprovar la estructura de la tabla
show columns from transactions.credit_card; #comprobar tabla credit_car

## Carregar les dades amb datos_introduir_credit.sql












#Vinculación de transaction.credit_card_id con credit_card.id:
## Cambio el tipo de dato para que sean iguales: VARCHAR(8)
ALTER TABLE transaction CHANGE credit_card_id credit_card_id VARCHAR(8) NOT NULL;


















-- EXERCICI 2 --
-- El departament de Recursos Humans ha identificat un error en el número 
-- de compte de l'usuari amb ID CcU-2938. La informació que ha de mostrar-se 
-- per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

SELECT * 
FROM credit_card
WHERE id = "CcU-2938";












#Cambio:
UPDATE credit_card set
iban = 'R323456312213576817699999'
WHERE id = "CcU-2938";


#Confirmación del cambio:
SELECT * 
FROM credit_card
WHERE id = "CcU-2938";





-- En la taula "transaction" ingressa un nou usuari amb la següent informació:
#Mirar el resgistro de id=b-9999 en la tabla company por si ya existe
SELECT * FROM company WHERE id = "b-9999";
# No existe el registro





#Debo crear primero los registros company.id = "b-9999" y credit_card.id="CcU-9999" por ser claves externas a la tabla transaction:
INSERT INTO company (id)
VALUES ("b-9999");
INSERT INTO credit_card (id)
VALUES ("CcU-9999");













#Creo el nuevo usuario
insert into transaction(id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
values ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "111.11", "0");




















#Visualizo la nueva transacción
SELECT * FROM transaction
WHERE id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";



-- Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. 
-- Recorda mostrar el canvi realitzat.
#Elimino campo pan
ALTER TABLE credit_card
DROP COLUMN pan;







#Visualizo la tabla credit_card
SHOW COLUMNS
FROM credit_card;

-- ####### Nivell 2 #######
-- Exercici 1
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
DELETE
FROM transaction 
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";










#Visualizo el id eliminado.
SELECT * FROM transaction WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";


-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
#Creación de la vista "VistaMarketing"
CREATE VIEW VistaMarketing AS (
								SELECT c.company_name AS "Nom", c.phone AS "Telefon", c.country AS "Pais", ROUND(AVG(t.amount),2) AS "MitjanaDeCompra"
								FROM company c
								JOIN transaction t
								ON c.id = t.company_id
								WHERE t.declined = 0
								GROUP BY c.id
                                );







#Visualización 
SELECT *
FROM VistaMarketing
ORDER BY MitjanaDeCompra DESC;

-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
#Creación de la vista "VistaMarketing"
CREATE VIEW VistaMarketing AS (
								SELECT c.company_name AS "Nom", c.phone AS "Telefon", c.country AS "Pais", ROUND(AVG(t.amount),2) AS "MitjanaDeCompra"
								FROM company c
								JOIN transaction t
								ON c.id = t.company_id
								WHERE t.declined = 0
								GROUP BY c.id
                                );
#Visualización 
SELECT *
FROM VistaMarketing
ORDER BY MitjanaDeCompra DESC;

-- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
SELECT *
FROM VistaMarketing
WHERE Pais = "Germany";


-- ####### Nivell 3 #######
-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
-- Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama ER (Ver PDF).
-- Recordatori: En aquesta activitat, és necessari que descriguis el "pas a pas" de les tasques realitzades. És important realitzar descripcions senzilles, simples i fàcils de comprendre. Per a realitzar aquesta activitat hauràs de treballar amb els arxius denominats "estructura_dades_user" i "dades_introduir_user".


#Inserto estructura_datoss_user.sql y datos_introducir_user (1).sql

#cambio del nombre de la tabla por el mismo del diagrama

rename table user to data_user;




rename table user to data_user;


#Aparece un error debido al usuario 9999 que no aparece en la tabla data_user
ALTER TABLE transaction
ADD CONSTRAINT fk_user_transaction
FOREIGN KEY (user_id)
REFERENCES data_user(id);

#Comprovación
SELECT user_id 
FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);



#Desactivació del mode segur per poder eliminar el registre
SET SQL_SAFE_UPDATES = 0;

#Elimnació de les dades de l'usuari 9999 per solucionar el problema
DELETE FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);


alter table transaction add constraint fk_data_user_id foreign key (user_id) references data_user(id);


#Modificación de las tablas para adaptarse al modelo del ejercicio
alter table transactions.company drop website;
alter table transactions.credit_card add column fecha_actual DATE;
alter table transactions.data_user change email personal_email varchar(150);





##Tabla data_user: 
#Invertir la relación de la FK user.id de la tabla transaction.
-- Para ello debo averiguar el nombre de la FK existente, eliminarla y luego crear una nueva desde transaction hacia data_user 
SHOW CREATE TABLE data_user;
#Eliminar la FK data_user_ibfk_1
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE data_user DROP FOREIGN KEY data_user_ibfk_1;
## La borré desde el diagrama E/R y ahora no lo puedo hacer con código.


-- Agrego la FK con la dirección correcta
-- Agregar FK: transaction -> data_user (N a 1)
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_data_user
FOREIGN KEY (user_id)
REFERENCES data_user (id);






##Tabla transaction:
#Cambiar credit_card_id de NOT NULL a que permita valores nulos y que el tipo de dato sea VARCHAR(15)
ALTER TABLE transaction CHANGE credit_card_id credit_card_id VARCHAR (15);
#Visualización
SHOW COLUMNS 
FROM transaction;














#Eliminar la Foreign Key fk_transaction_credit_card
ALTER TABLE transaction DROP FOREIGN KEY fk_transaction_credit_card;











##Tabla credit_card:
#Cambiar el tipo de los siguientes campos:
-- id a VARCHAR(20) | iban a VARCHAR(50) | pin a VARCHAR(4) | cvv a INT |  expiring_date a VARCHAR (10).
ALTER TABLE credit_card MODIFY COLUMN id VARCHAR(20);
ALTER TABLE credit_card MODIFY COLUMN iban VARCHAR(50);
ALTER TABLE credit_card MODIFY COLUMN pin VARCHAR(4);
ALTER TABLE credit_card MODIFY COLUMN cvv INT;
ALTER TABLE credit_card MODIFY COLUMN expiring_date VARCHAR(10);
#Visualización:
SHOW COLUMNS 
FROM credit_card;





#Foreign Keys
-- Agregar FK: transaction -> credit_card (N a 1)
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card (id);













-- Cambiar nombre transaction_ibfk_1 a fk_transaction_company
#Eliminar transaction_ibfk_1
ALTER TABLE transaction
DROP FOREIGN KEY transaction_ibfk_1;
#Crearla nuevamente con el nombre fk_transaction_company
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_company
FOREIGN KEY (company_id)
REFERENCES company (id);


/*Exercici 2 L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
    ID de la transacció
    Nom de l'usuari/ària
    Cognom de l'usuari/ària
    IBAN de la targeta de crèdit usada.
    Nom de la companyia de la transacció realitzada.
    Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/
#Creación de la vista informeTecnico
CREATE VIEW informeTecnico AS
							(select 
								transaction.id as Transaccion, 
								data_user.name as Nombre_usuario, 
								data_user.surname as Apellido,
								data_user.country as Pais_usuario, 
								iban as IBAN_tarjeta, 
								company_name as Nombre_empresa,
								company.country as Pais_empresa,
								declined as Transferencia_denagada
							from transactions.transaction
								join data_user on transaction.user_id=data_user.id
								join credit_card on transaction.credit_card_id=credit_card.id
								join company on transaction.company_id=company.id
							order by Transaccion desc);






#Visualización
SELECT *
FROM InformeTecnico






































