# S4.01. Creació de Base de Dades

## Descripció del projecte

Aquest projecte té com a objectiu dissenyar i crear una base de dades relacional partint de diversos arxius CSV. S'ha de seguir un esquema d'estrella per dissenyar la base de dades i realitzar diverses consultes SQL que interactuïn amb les taules creades. El projecte es divideix en tres nivells, cada un amb diferents tasques i requisits.

## Objectius

- Dissenyar i crear una base de dades relacional.
- Realitzar consultes SQL avançades sobre les taules de la base de dades.
- Generar una nova taula per gestionar l'estat de les targetes de crèdit basat en les transaccions.
- Unir dades de diferents arxius CSV i realitzar consultes relacionades amb aquests.

## Nivells del projecte

### Nivell 1
- **Descarregar els arxius CSV**: Estudia'ls i crea una base de dades amb un esquema d'estrella que contingui almenys 4 taules.
- **Consultes a realitzar**:
  - **Exercici 1**: Subconsulta per mostrar tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.
  - **Exercici 2**: Mitjana d'amount per IBAN de les targetes de crèdit de la companyia "Donec Ltd", utilitzant almenys 2 taules.

### Nivell 2
- **Crea una nova taula** que reflecteixi l'estat de les targetes de crèdit en funció de les últimes tres transaccions.
- **Consultes a realitzar**:
  - **Exercici 1**: Comptar quantes targetes estan actives.

### Nivell 3
- **Unir les dades** del nou arxiu `products.csv` amb la base de dades creada, utilitzant l'atribut `product_ids` de la taula `transaction`.
- **Consultes a realitzar**:
  - **Exercici 1**: Comptar el nombre de vegades que s'ha venut cada producte.

## Requisits

- MySQL o qualsevol altre sistema de gestió de bases de dades relacionals (RDBMS) per executar els scripts SQL.
- XAMPP, MAMP o qualsevol altra eina per gestionar el servidor SQL local (opcional).
- Workbench o qualsevol altra eina per executar les consultes i veure els resultats (opcional).

## Lliurament

El lliurament del projecte ha de contenir la següent estructura:

1. **Arxius SQL**: Inclou tots els scripts SQL per a la creació de les taules i les consultes realitzades.
2. **Diagrama de la base de dades**: Imatge del diagrama que mostra l'esquema de la base de dades amb totes les taules i les relacions entre elles.
3. **Captura de pantalla del workbench**: Inclou una captura de pantalla de les consultes SQL realitzades en el Workbench (o eina similar) amb els resultats obtinguts.
4. **Link al repositori GitHub**: Col·loca el link del teu repositori de GitHub on s'emmagatzemen tots els arxius.

## Instruccions d'ús

1. **Clona aquest repositori** a la teva màquina local:
   ```bash
   git clone https://github.com/username/repository-name.git

