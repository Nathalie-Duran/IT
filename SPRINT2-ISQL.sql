-- Exercici 1
SELECT *
FROM company;


SELECT *
FROM transaction;


-- - Exercici 2 Utilitzant JOIN realitzaràs les següents consultes:

-- A) Llistat dels països que estan fent compres.

SELECT distinct c.country as "Paises que realizan compras"
FROM company c
RIGHT JOIN transaction t on t.company_id=c.id
WHERE t.declined=0
ORDER BY c.country ASC;


-- B) Des de quants països es realitzen les compres.

SELECT count(distinct c.country) as "Cantidad de Paises que realizan compras"
FROM company c
RIGHT JOIN transaction t on t.company_id=c.id
WHERE t.declined =0;

-- C) Identifica la companyia amb la mitjana més gran de vendes.

SELECT c.company_name as "Company", ROUND(avg(amount),2) as "Mitjana més gran en Euros"
FROM transaction t
join company c ON c.id=t.company_id
WHERE t.declined=0
GROUP BY c.company_name
ORDER BY ROUND(avg(amount),2) desc
limit 1;

-- Exercici 3 Utilitzant només subconsultes (sense utilitzar JOIN):

-- A) Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT * 
FROM transaction
WHERE company_id IN
					(
                    SELECT id
					FROM company
					WHERE country = "Germany"
                    );


-- B) Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name AS "Empreses que han realitzat transaccions per un amount superior a la mitjana"
FROM company
WHERE id IN (
			SELECT company_id 
			FROM transaction
			WHERE amount > (SELECT avg(amount)
							FROM transaction)
			)
ORDER BY company_name ASC;

-- C) Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses

SELECT DISTINCT company_name AS "Empreses sense transaccions registrades"
FROM company
WHERE NOT EXISTS (
				  SELECT company_id 
				  FROM transaction
				  );


-- NIVELL 2
-- Exercici 1 Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) AS "Data transacció" , round(sum(amount),2) AS "Total vendes en Euros"
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY round(sum(amount),2) DESC
LIMIT 5;


-- Exercici 2 Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT c.country AS "País", round(avg(amount),2) AS "Mitjana de vendes en euros"
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY round(avg(amount),2) DESC;


-- Exercici 3 En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
--  Mostra el llistat aplicant JOIN i subconsultes.

SELECT company_name AS "Company", t.id, t.credit_card_id,t.company_id,t.user_id,t.lat,t.longitude,t.timestamp,t.amount, t.declined
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE country = (
					SELECT country 
					FROM company
					WHERE company_name = "Non Institute"
				   ) AND company_name <> "Non Institute";
                   
-- Mostra el llistat aplicant solament subconsultes.
SELECT (
		SELECT company_name 
        FROM company c 
        WHERE c.id=t.company_id) AS "Company", (SELECT country 
												FROM company c 
                                                WHERE c.id=t.company_id) AS "Country", t.id, t.credit_card_id,t.company_id,t.user_id,t.lat,t.longitude,t.timestamp,t.amount, t.declined
FROM transaction t
WHERE company_id IN (
					SELECT id 
					FROM company
					WHERE country = (
									SELECT country 
									FROM company
									WHERE company_name = "Non Institute"
				     ) AND company_name <> "Non Institute"
										);
    
    
    
-- Nivell 3 
-- Exercici 1 Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros 
-- i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.
SELECT c.company_name AS "Company", c.phone AS "Telèfon", c.country AS "País", DATE(t.timestamp) AS "Data", t.amount AS "Amount en Euros"
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.amount BETWEEN 100 and 200 AND DATE(t.timestamp) IN (
															"2021-04-29", "2021-07-20", "2022-03-13"
															)
ORDER BY  t.amount DESC;


-- Exercici 2 Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.

SELECT company_name AS "Company",
CASE 
WHEN COUNT(t.id) > 4 THEN "Més"
ELSE "Menys"
END AS "Tenen més de 4 transaccions o menys"
FROM transaction t
JOIN company c
ON t.company_id = c.id
GROUP BY Company
ORDER BY Company ASC;




