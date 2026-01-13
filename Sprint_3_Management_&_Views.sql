/* Crear taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç **d'identificar de manera única cada targeta** i 
establir una relació adequada amb les altres dues taules ("transaction" i "company"). */

USE transactions;


###### Creem la taula ######
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(50) PRIMARY KEY,
    iban VARCHAR(50) NOT NULL,
    pan INT NOT NULL, 
    pin INT NOT NULL,
    cvv INT NOT NULL,
    expiring_date DATE);
    
-- Comprovem que s'hagin creat bé les columnes i veiem si la PK també s'ha establert bé. 
    SELECT * FROM credit_card; 
    DESC credit_card;
    
    ##### CARREGUEM EL FITXER DELS REGISTRES ######
    
-- Carreguem dades del fitxer datos_introducir_scrpint3_credi.sql 

    -- Error Code: 1264. Out of range for column "pan" at row 1. 
    ALTER TABLE credit_card
    CHANGE COLUMN pan pan VARCHAR(50) NOT NULL;  -- Evita el problema de la conversió dels números. Hi ha files on el PAN té separacions cada 4 digits i d'altres on estan seguits. 
    
    -- Error Code: 1292. Incorrect date value: '10/30/22 for column 'expiring_date'. 
    -- Modifico la forma en que han de apareixer les dates. 
    ALTER TABLE credit_card
    CHANGE COLUMN expiring_date expiring_date VARCHAR(20) NOT NULL;

#### ESTABLIR RELACIÓ AMB LA FOREIGN KEY ######
-- Establim la relació amb la Foreign key
ALTER TABLE credit_card ENGINE=InnoDB; 			-- Necessari per soportar claus foranies (Foreign Key). NO ERA NECESSARI perquè ja surt per defecta però jo no ho sabia. 

ALTER TABLE transaction 						-- ESTABLEIX RELACIÓ PK <--> FK
ADD CONSTRAINT fk_transaction
FOREIGN KEY (credit_card_id) REFERENCES credit_card (id);

DESC transaction;							-- Confirmar que s'ha creat la FK. 
SHOW TABLE STATUS WHERE Name='credit_card'; 		-- Busca "Engine: InnoDB"
SHOW TABLE STATUS WHERE Name='transaction';

/*Exercici 2:
El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.*/

UPDATE credit_card
SET iban='TR323456312213576817699999'
WHERE ID='CcU-2938';

SELECT * FROM credit_card
WHERE ID= 'CcU-2938';

/*Exercici 3
En la taula "transaction" ingressa una nova transacció amb la següent informació: 
id, credit_card_id, company_id, user_id, lat, longitude, amount, declined   */

-- Insertamos datos de credit_card
SELECT * FROM CREDIT_CARD;
SELECT * FROM transaction;

INSERT INTO transaction (id, 
						 credit_card_id, 
                         company_id, 
                         user_id, 
                         lat, 
                         longitude, 
                         amount, 
                         declined)
VALUES (
		'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 
        'CcU-9999', 
        'b-9999', 
        '9999', 
        829.999, 
        -117.999,
        111.11, 
        '0');
										-- La query de dalt dona error perquè la foreign key constraint falla. Hem de crear l'ID de la PK a la taula credit_card.
                                        
                                        INSERT INTO credit_card (id) VALUES ('CcU-9999');
                                        
                                        /* Dona Error i diu que la columna 'iban' no te valors. L'havia definit com que no pogues tenir valors nuls,
										   però ara ho haure de canviar perquè sino no puc afegir les dades a la taula transaction i per fer-ho haig de fer que la
										   foreign key credit_card_id = 'CcU-9999', es correspongui a una ID existent a la taula credit_card perquè la restricció de foreign key no falli.*/

										ALTER TABLE credit_card
                                        MODIFY COLUMN iban VARCHAR(50);
                                        
                                        ALTER TABLE credit_card
                                        MODIFY COLUMN pan INT(50);
                                        -- Error Code: 1264. OUT OF RANGE VALUE 
											ALTER TABLE credit_card
											MODIFY COLUMN pan BIGINT;
										-- Error Code: 1265. Data truncated for column 'pan' at row 4728
										-- Modifiquem DATA TYPE a varchar
											ALTER TABLE credit_card
											MODIFY COLUMN pan VARCHAR(20);
                                        
                                        ALTER TABLE credit_card
                                        MODIFY COLUMN pin INT;
                                        
                                        ALTER TABLE credit_card
                                        MODIFY COLUMN cvv INT;

-- TORNEM A EXECUTAR:
	-- 1. Afegir identificador a taula credit_card
		INSERT INTO credit_card (id, expiring_date) VALUES ('CcU-9999', '12/10/25');  -- He introduït el dia en que he fet aquest update Tot i que podría fer CURRENT_DATE()
	-- 2.. Introduïr dades a la taula transaction. 
INSERT INTO transaction (id, 
						 credit_card_id, 
                         company_id, 
                         user_id, 
                         lat, 
                         longitude,
                         timestamp, 
                         amount, 
                         declined)
VALUES (
		'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 
        'CcU-9999', 
        'b-9999', 
        '9999', 
        829.999, 
        -117.999,
        current_timestamp(),									-- Per què le current_timestamp()? Perquè així queda registrat el moment exacte en el qual s'ha fet el registre.
        111.11, 
        0);
							-- Dona error perquè COMPANY_ID NO esta a COMPANY per tant l'hem de crear. 
								SELECT id FROM company
								WHERE id= 'b-9999';
                                
                                INSERT INTO company (id) VALUES ('b-9999');
-- TORNEM A EXECUTAR QUERY D'INSERCIÓ i confirmem que s'ha afegit correctament a la taula transaction. 
SELECT * FROM transaction
WHERE company_id= 'b-9999';

/* Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat. */

-- 1. Mostrar la taula abans de eliminar la columna. 
SELECT * FROM credit_card;

-- 2. Eliminar la columna
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;

############################################################################## NIVELL 2 ############################################################################3

/* Exercici 1
Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.
 */

 SELECT * 
 FROM transaction
 WHERE ID= '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction
WHERE id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- Exercici 2 --
	-- Objectiu: Crear un VIEW anomenat VISTAMARKETING
		-- 1. Ha de tenir: 
				-- Nom de la companyia
                -- Telèfon de contacte
                -- País de residència
                -- Mitjana de compra per companyia
			-- Ordenar per mitjana de major a menor

-- Syntax for VIEWS:
/* CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition; */
SELECT * FROM transaction;
SELECT * FROM company;

CREATE VIEW VistaMarketing AS						-- Creem la vista 
SELECT company_name, phone, country, average				-- CORREGIR MANTENINT ELS NOMS EN CATALA
FROM company
JOIN (SELECT company_id, ROUND(AVG(amount), 2) AS average			-- Calculem la mitjana per empresa i fem el join
	  FROM transaction 
	  GROUP BY company_id
	  ORDER BY average DESC) Mitjana_empreses
ON company.id=Mitjana_empreses.company_id
ORDER BY average DESC;

SELECT * FROM VistaMarketing;   -- Mostrem la vista

/* Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
 */ 
 SELECT * 
 FROM VistaMarketing 
 WHERE country = 'Germany'; 
 
 #################################################################### NIVELL 3 ######################################################################
 
 -- Exercici 1:
 /* 
  PASOS QUE S'HAN SEGUIT: 
  
1.	Generar la taula de user
2.	Carregar dades fitxer datos introducir sprint3 user.sql
3.	Crear relació entre taula user i la taula transaction.
3.1.	Crear relació entre PK i FK  --- EXPLICAR DIFERENTE --- 
4.	Modificar nom taula user a data_user
5.	Adaptar variables taules i tipus de data als mostrats a l’esquema del company:

5.1.	Taula credit_card
5.1.1.	“Pan” ja estava eliminat
5.1.2.	Modificar “id VARCHAR(50)”  a “id VARCHAR(20)”
5.1.3.	Modificar “pin” INT a “pin VARCHAR (4)
5.1.4.	Afegir columna “fecha_actual”

5.2.	Taula company
5.2.1.	Eliminar columna “website”

5.3.	Taula transaction
5.3.1.	Modificar l’extensió VARCHAR a “credit_card_id”. Modificar llargada de credit_card_id VARCHAR(15) a crèdit_card_id VARCHAR(20)
 */

-- -------------- ------------------------------------------------------
					-- PAS A PAS --
-- ------------- --------------------------------------------------------

-- 1. Generar la taula de user
 -- Codi proporcionat per l'academia--
 CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);
-- -- ------------------------------------
DESC user; 

-- 2. Carreguem dades fitxer datos introducir sprint3 user.sql
SELECT * FROM user;

/* 3.	Crear connexió entre taula user i la taula transaction.
3.1.	Crear connexió entre PK i FK */

SHOW TABLE STATUS WHERE name="user"; 

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id) REFERENCES user(id);

DESC transaction; -- Descriu la taula: camps, tipus de dades,...
-- Modificar tipus dada en columna "id" de la taula user.

/*ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id) REFERENCES user(id);*/
-- ERROR: No ens deixa perquè hi ha dades a la taula transaction que NO estan a user. 

ALTER TABLE user
MODIFY COLUMN id INT;			-- Perquè el "id" inicial era de tipus CHAR

-- 4. Modificar nom taula user a data_user (Ho he fet abans perquè pensava que afectava però NO. La solució esta a sota)
ALTER TABLE user
RENAME TO data_user;

-- Busquem quins són els IDs que no estan a data_user i si ha ...a transaction...Explicar per què el id?? 
SELECT DISTINCT t.user_id
FROM transaction AS t
LEFT JOIN data_user AS u
  ON t.user_id = u.id
WHERE t.user_id IS NOT NULL
  AND u.id IS NULL;				-- output: User_id [9999]

-- Inserim data que falta: user_id=9999
INSERT data_user(id) VALUES ('9999');

-- Creem relació amb FK:
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id) REFERENCES data_user(id);

-- Canviar el nom de la variable email de data_user a personal_email:
ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

-- 5. Adaptar variables taules i tipus de data als mostrats a l’esquema del company:
	-- 5.1.	Taula credit_card
		-- 5.1.1. “Pan” ja estava eliminat
        
		-- 5.1.2. Modificar “id VARCHAR(50)”  a “id VARCHAR(20)”
					ALTER TABLE credit_card
                    MODIFY COLUMN id VARCHAR(20);  -- ERROR: Cannot change column "id". Used in a foreign key constraint
                    
                    -- Què fer?? 
						-- 1. Eliminar la clau forania de la taula TRANSACTION que és on esta creada.
							  ALTER TABLE transaction
                              DROP FOREIGN KEY fk_transaction;
                              
						-- 2. Modificar la columna de credit_card  
                              ALTER TABLE credit_card
                              MODIFY COLUMN id VARCHAR(20);
                              
                        -- 3. Tornar a crear la clau forania
							  ALTER TABLE transaction
                              ADD CONSTRAINT fk_transaction
                              FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);
                              
                              DESC transaction;
        -- ¡¡ EN AQUEST PROCES S'HA PERDUT UN REGISTRE, AIXÍ QUE S'HA DE TORNAR A INTRODUIR!!
			SELECT * FROM credit_card;   -- Es mante en credit card però no en Transactio. El registre amb credit_card.id = CcU-9999
            SELECT * FROM company 
            WHERE id= 'b-9999'; 	
            SELECT * FROM transaction     -- Doncs sembla ser que no s'ha perdut. Llavors, perquè quan faig select all sobre la taula transaction em retorna 100000 rows i no 100001 rows??¿?
            WHERE credit_card_id= 'CcU-9999'; 
            
            SELECT * FROM transaction;				-- Retorna 100000 registres en comptes de 100001. PER QUÈ? Perquè previament haviem eliminat un registre.
            SELECT * FROM credit_card;				-- Retorna 5001 registres
            SELECT * FROM company;					-- Retorna 101 registres

		-- 5.1.3. Modificar “pin” INT a “pin VARCHAR (4)
					ALTER TABLE credit_card
                    MODIFY COLUMN pin VARCHAR(4);
        
		-- 5.1.4. Afegir columna “fecha_actual”
					ALTER TABLE credit_card
                    ADD COLUMN fecha_actual DATE;
					
                    SELECT * FROM credit_card;  -- Retorna totes les files de la columna fecha_actual NULL
                    
                    -- CORREGIM --
                    UPDATE credit_card
                    SET fecha_actual=CURRENT_DATE()
                    WHERE fecha_actual IS NULL									-- Si només posem aquesta condició dona error. 
							AND (id LIKE 'CcU-%' OR id LIKE 'CcS-%');			-- Introdueix la fecha_actual on els valors són NULL
                    
                    ALTER TABLE credit_card
                    MODIFY COLUMN fecha_actual DATE NOT NULL DEFAULT (CURRENT_DATE);

			DESC credit_card;
			SELECT * FROM credit_card;

/* 5.2.	Taula company
	5.2.1. Eliminar columna “website” */
		   SELECT * FROM company;
           
           ALTER TABLE company
           DROP COLUMN website;


/* 5.3.	Taula transaction
	5.3.1. Modificar l’extensió VARCHAR a “credit_card_id”. Modificar llargada de credit_card_id VARCHAR(15) a crèdit_card_id VARCHAR(20)
*/
		   ALTER TABLE transaction
           MODIFY COLUMN credit_card_id VARCHAR(20);
           
           DESC transaction;
           
/* Exercici 2
L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
	o ID de la transacció
	o Nom de l'usuari/ària
	o Cognom de l'usuari/ària
	o IBAN de la targeta de crèdit usada.
	o Nom de la companyia de la transacció realitzada.
	o Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.
 */

CREATE VIEW InformeTecnico AS
SELECT t.id, 
		CONCAT(du.name,' ',du.surname) AS name_surname,
        cc.iban,
        c.company_name,
        CURRENT_TIMESTAMP() AS today_date,
        t.declined
FROM credit_card  cc
JOIN transaction t ON cc.id=t.credit_card_id
JOIN company c ON c.id=t.company_id
JOIN data_user du ON du.id=t.user_id
ORDER BY t.id;										-- OBSERVACIÓ ALEXEI: 
														-- Considerar a qui va dirigit l'informe. 
                                                        -- Com saps quan es van registre les dades o s'ha fet alguna modificació? Introdeuir un CURRENT_DATE(timestamp)
                                                        -- Quin és l'estat de la transacció per cada usuari: DECLINED 0 or 1
SELECT * FROM InformeTecnico;


