# Manipulació de Taules SQL

## Descripció
Aquest projecte forma part d'un sprint per practicar la manipulació de bases de dades SQL, treballant amb taules, índexs i vistes. L'objectiu és consolidar habilitats relacionades amb la gestió de bases de dades mitjançant la resolució d'exercicis pràctics.

La base de dades simula l'operativa d'una empresa de venda en línia i conté informació sobre transaccions, empreses i targetes de crèdit. Durant aquest projecte, es treballarà amb dades relacionades amb targetes de crèdit, transaccions i informació corporativa.

## Estructura del Projecte

Aquest repositori conté els següents elements:

- **scripts/**: Conté l'arxiu `.sql` amb tots els scripts necessaris per a resoldre els exercicis.
- **captures/**: Conté un PDF amb captures de pantalla del Workbench que mostren els scripts i els resultats obtinguts per a cada exercici.

## Recursos
- Objectius: Manipulació de dades, treballar amb vistes i índexs.
- Durada estimada: 3 dies.

## Exercicis

### Nivell 1

#### Exercici 1
Crear una taula anomenada `credit_card` per emmagatzemar detalls sobre targetes de crèdit i establir la relació amb les taules `transaction` i `company`. A més, s'ha d'introduir informació des del document `dades_introduir_credit.sql`. Finalment, mostrar el diagrama de relacions i una descripció breu.

#### Exercici 2
Corregir un error en el número de compte de l'usuari amb ID `CcU-2938`. El valor correcte és: `R323456312213576817699999`. Mostrar que el canvi s'ha realitzat correctament.

#### Exercici 3
Inserir un nou registre a la taula `transaction` amb la informació següent:

```
Id              108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id  CcU-9999
company_id      b-9999
user_id         9999
lat             829.999
longitude       -117.999
amount          111.11
declined        0
```

#### Exercici 4
Eliminar la columna `pan` de la taula `credit_card`. Mostrar els canvis realitzats.

### Nivell 2

#### Exercici 1
Eliminar de la taula `transaction` el registre amb ID `02C6201E-D90A-1859-B4EE-88D2986D3B02`.

#### Exercici 2
Crear una vista anomenada `VistaMarketing` amb els següents detalls:
- Nom de la companyia.
- Telèfon de contacte.
- País de residència.
- Mitjana de compra per companyia.

Ordenar les dades de major a menor mitjana de compra.

#### Exercici 3
Filtrar la vista `VistaMarketing` per mostrar només les companyies amb residència a Alemanya (`Germany`).

### Nivell 3

#### Exercici 1
Revisar els canvis realitzats en la base de dades per un company i generar els comandos necessaris per obtenir el diagrama correcte.

#### Exercici 2
Crear una vista anomenada `InformeTecnico` amb:
- ID de la transacció.
- Nom i cognom de l'usuari.
- IBAN de la targeta de crèdit usada.
- Nom de la companyia associada a la transacció.

Mostrar els resultats ordenats de manera descendent segons l'ID de la transacció.

## Lliurament

1. **Arxiu `.sql`:** Conté tots els scripts necessaris per als exercicis.
2. **PDF amb captures de pantalla:** Mostra els scripts executats i els resultats obtinguts.

## Autor
Natalia Durán Gadea  
21 de gener de 2025

