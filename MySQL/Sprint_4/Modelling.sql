##########################################################################################################################################################################
																-- SPRINT 4: MODELATGE --
##########################################################################################################################################################################
 -- TAULES A CREAR --
 /* 1.* American_users * i * European_users *
		Columnes: id (PK), name, surname, phone, email, birth_date, country, city, postal_code, address
	2. * Companies *
		Columnes: company_id (PK), company_name, phone, email, country, website, 
	3. * Transactions * (Separat per tabulació)
		Columnes: id (PK), card_id (FK), business_id (FK), timestamp, amount, declined, product_ids (FK), user_id (FK), lat, longitude
	4. * Credit_cards *
		Columnes: id (PK), user_id (FK), iban, pan, pin, cvv, track1, track2, expiring_date
	5. * Products *
		Columnes: id (PK), product_name, price, colour, weight, warehouse_id
	*/

############################################################################################################################################################################
														-- CREACIÓ BASE DADES I TAULES --
############################################################################################################################################################################
CREATE DATABASE Sprint_4; 		-- Creem base de dades
USE Sprint_4;					-- Utilitzem la base de dades per crear taules


-- CREEM TAULES --
CREATE TABLE IF NOT EXISTS Transactions (
	id VARCHAR(50) PRIMARY KEY, 
    card_id VARCHAR(20),
    business_id VARCHAR(10),
    timestamp VARCHAR(20), 
    amount DECIMAL(10,2),
    declined TINYINT(1),
    product_ids VARCHAR(255),
    user_id INT,
    lat FLOAT,
    longitude FLOAT);
    
DESC transactions;
SELECT * FROM transactions;
SHOW TABLE STATUS WHERE Name= "transactions";

CREATE TABLE IF NOT EXISTS American_users (
	id INT PRIMARY KEY, 
    name VARCHAR(20), 
    surname VARCHAR(50),
    phone VARCHAR(20), 
    email VARCHAR(150),
    birth_date VARCHAR(20),
    country VARCHAR(20), 
    city VARCHAR(20),
    postal_code VARCHAR(10),
    address VARCHAR(50));
 
DESC American_users;
SELECT * FROM American_users;
SHOW TABLE STATUS WHERE Name= "American_users";

CREATE TABLE IF NOT EXISTS European_users (
	id INT PRIMARY KEY, 
    name VARCHAR(20), 
    surname VARCHAR(50),
    phone VARCHAR(20), 
    email VARCHAR(150),
    birth_date VARCHAR(20),
    country VARCHAR(20), 
    city VARCHAR(20),
    postal_code VARCHAR(10),
    address VARCHAR(50));

DESC European_users;
SELECT * FROM European_users;
SHOW TABLE STATUS WHERE Name= "European_users";

CREATE TABLE IF NOT EXISTS Credit_cards (
	id VARCHAR(20) PRIMARY KEY,
    user_id INT, 
    iban VARCHAR(50),
    pan VARCHAR(20),
    pin VARCHAR(4),
    cvv INT,
    tranck1 VARCHAR(255),
    tranck2 VARCHAR(255), 
    expering_date VARCHAR(20));

DESC Credit_cards;
SELECT * FROM Credit_cards;
SHOW TABLE STATUS WHERE Name= "Credit_cards";

CREATE TABLE IF NOT EXISTS Company (
	company_id VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(255),
    country VARCHAR(20),
    website VARCHAR(50)
    );
    
DESC Company;
SELECT * FROM Company;
SHOW TABLE STATUS WHERE Name= "Company";

CREATE TABLE IF NOT EXISTS Products (
	id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price VARCHAR(10),
    colour VARCHAR(20),
    weight DECIMAL(4,2),
    warehouse_id VARCHAR(10)
	);

DESC Products;
SELECT * FROM Products;
SHOW TABLE STATUS WHERE Name= "Products";


SHOW TABLES;

###########################################################################################################################################################################
																-- IMPORTAR DADES -- 
###########################################################################################################################################################################
-- Carreguem les dades a les taules --
-- Syntax --
/* LOAD DATA LOCAL INFILE '/path/to/file.csv' INTO TABLE table_name FIELDS TERMINATED BY ',' IGNORE 1 ROWS; */	

# TAULA American_users
LOAD DATA LOCAL INFILE "C:\Users\dioul\OneDrive\Escritorio\Fonaments D'anàlisi de dades (FADD)\Curs d'especialització Data Analys\SQL_Sprint_4\american_users.csv" 
INTO TABLE American_users FIELDS TERMINATED BY ',' IGNORE 1 ROWS;   
	-- Error code: 3948. Loading local data is disabled.
	-- L'ACTIVEM --
    SHOW GLOBAL VARIABLES LIKE 'local_infile';
	SET GLOBAL local_infile = 1;

    -- Error: LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.
    -- RESOLEM --
    SHOW VARIABLES LIKE 'basedir';			-- A quin directori esta instal·lat MySQL
	SHOW VARIABLES LIKE 'defaults-file';	-- Indica el directory on es troba 'my.ini'. Sembla ser que NO el tinc. 
    
	LOAD DATA LOCAL INFILE 'C:\Users\dioul\Downloads\american_users.csv'  				-- Restriccions eren per OneDrive. Canviat l'arxiu a una carpeta local d'emmagatzematge local
	INTO TABLE American_users FIELDS TERMINATED BY ',' IGNORE 1 ROWS; 					-- ERROR PERSISTEIX!!!!
    
    SHOW VARIABLES LIKE "secure_file_priv"; 			-- Retorna el directori de treball segur. Des del qual podem carregar els fitxers sense restriccions d'accés.
    /* No em vull limitar a treballar unicament amb un únic directori+
    QUÈ FEM?*/
    /* Estava buscant 'my.ini' en el directori equivocat. Aquest "C:\Program Files\MySQL\MySQL Server 8.0" 
    Però resulta que esta en un altre directori que és el següent: "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini"
    Això ho he descobert després d'executar la consulta de dalt: SHOW VARIABLES LIKE "secure_file_priv"
    
    Ara que hem localitzat l'arxiu, podem fer les modificacions per superar les restriccions d'accés
		
        1. Obrim la app del 'bloc de notes' i l'executem com a administrador (click botó dret--> 'Ejecutar como administrador')
        2. Archivo --> abrir --> Anem el directori que ens ha retornat el SHOW VARIABLE LIKE "secure_file_priv" 
			--> No apareix la carpeta, així que, en el desplegable del tipus de document seleccionem "Todos los archivos"
            --> Seleccionem 'my'
		3. Modifiquem en els següents punts: 
			3.1: CLIENT SECTION: Sota de [client] escrivim 'local_infile=1'
            3.2: SERVER SECTION: Sota de [mysqld] escrivim també 'local_infile=1'
            3.3: SECURITY FILE PRIV. Busquem * secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads" * en el text del fitxer
				 Posem la línia com a comentari amb #
                 -- Sota d'aquesta línia escrivim * security-file-prive="" * sense espai entre les "". 
		4. Reiniciem MySQL.
        */
	SHOW GLOBAL VARIABLES LIKE 'local_infile';   
    SHOW VARIABLES LIKE "secure_file_priv"; 

-- AMERICAN_USERS --
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\american_users.csv" 		-- Canvia el directori perquè he eliminat la database i tornat a fer després de resoldre el problema.  
INTO TABLE American_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 					
IGNORE 1 ROWS;

SELECT * FROM American_users;
-- L'ERROR PERSISTEIX--
/* Consideracións adicionals
	1. Ensure that the file path is correct and accessible from the client machine.
	2. Ensure the MySQL user has the necessary permissions to load data into the target table.
    
    SOLUCIÓ ----> TAMPOC FUNCIONA!!!!!!! Error Code 29. 
    1. Ja NO cal el LOCAL en LOAD DATA INFILE. Perquè hem eliminat la restricció de la ruta segura.
			- Utilitzem LOAD DATA INFILE (sense LOCAL).
			- Ruta amb / o \\, i nom de l'arxiu exactament igual. 
            
RE-ESTABLEIXO LA RUTA SEGURA DE d'ACCÉS. Creem una nova ruta en una carpeta nova. 
Canviem directori a la consulta de dalt pel nou.  -------> ERROR!

Últim pas per què funcioni:
¡¡ En la conexió de WORKBENCH on posa connections, anem a la clau que hi ha el costat i fem click:
		- Seleccionem el nom de la conexició amb la que estem treballant. 
        - Sota de 'Connection Method' hi ha tres pestanyas "Parametres, SSL, Advanced". Seleccionem 'Advanced'
        - A 'Others' escrivim OPT_LOCAL_INFILE=1
        - Guardem i reiniciem Workbench

ARA FUNCIONA!! Però amb el directory segur, així que seguint els passos descrits més a dalt sobre com modificar el document "my.ini"

ESTABLIM EL NOSTRE NOU DIRECTORY PER IMPORTAR I EXPORTAR DADES A SQL:
		"C:\MySQL_import_DATA\"
*/

-- EUROPEAN_USERS --
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\european_users.csv"					-- En comptes de \ posem \\
INTO TABLE European_users 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'			
IGNORE 1 ROWS;

SELECT * FROM european_users;

-- CREDIT_CARDS --
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\credit_cards.csv"					-- En comptes de \ posem \\
INTO TABLE credit_cards 
FIELDS TERMINATED BY ','		
IGNORE 1 ROWS;

SELECT * FROM credit_cards;

-- TRANSACTIONS --
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\transactions.csv"
INTO TABLE transactions
FIELDS TERMINATED BY ';'  		-- las columnes es separen per punt i coma. 
ENCLOSED BY '"'					-- Per englobar product_ids
LINES TERMINATED BY '\n'		-- Salt de línia
IGNORE 1 ROWS;

SELECT * FROM transactions;

-- COMPANY --
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\companies.csv"
INTO TABLE Company
FIELDS TERMINATED BY ','  		-- las columnes es separen per punt i coma. 
IGNORE 1 ROWS;

SELECT * FROM company;

-- PRODUCTS -- 
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\products.csv"
INTO TABLE Products
FIELDS TERMINATED BY ',' 		-- Columnes separades per coma. 
IGNORE 1 ROWS;

SELECT * FROM products;

#############################################################################################################################################################################
															-- Establir víncle entre claus PRIMARIES i FORANIES --  
#############################################################################################################################################################################
-- Entre TRANSACTIONS i CREDIT_CARDS:
ALTER TABLE transactions
ADD CONSTRAINT fk_transsaction_cardID
FOREIGN KEY (card_id) REFERENCES credit_cards(id);

-- Entre TRANSACTIONS i COMPANY:
/* Abans de crear la relació entre *company* i *transactions*, s'hauria de 
canviar el nom de la columna 'business' a la taula transactions per 'company_id' per major claretat. 
*/
ALTER TABLE transactions 
RENAME COLUMN business_id TO company_id;

ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_companyID
FOREIGN KEY (company_id) REFERENCES company(company_id);

-- Entre TRANSACTIONS i PRODUCTS:
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_productID
FOREIGN KEY (product_ids) REFERENCES products(id);			-- ERROR perquè tenim dos tipus de data diferents: products.id INT i transactions.product_ids VARCHAR
	
    -- Modificar el tipus de data de la columna 'id' a products de INT a VARCHAR.
    ALTER TABLE products 
    MODIFY COLUMN id INT;     				/*ERROR: 1452. A la taula TRANSACTIONS tenim més d'un valor en algunes files de la columna 'product_ids'
													   i això viola la relació de 1-1. Per tant, s'ha de crear una taula intermitja per poder conectar la taula products amb 
                                                       transactions. 
                                                       
                                                       Torno a modificar el ID a PORDUCTS de Varchar a INT. */

CREATE TABLE transaction_products (
    transaction_id VARCHAR(50) NOT NULL,
    product_id     INT NOT NULL,
    PRIMARY KEY (transaction_id, product_id), 			-- Clau primaria composta
    CONSTRAINT fk_tp_transaction_id
        FOREIGN KEY (transaction_id)
        REFERENCES transactions(id),
    CONSTRAINT fk_tp_product_id
        FOREIGN KEY (product_id)
        REFERENCES products(id)
);

SELECT * FROM transaction_products;				-- Taula buida. Hem de omplir amb les dades de les columnes corresponents
DESC transaction_products;
/*QUÈ PASA i QUÈ FER? 
La dificultat està en que la columna 'product_ids' de la taula *transactions* conté registres amb múltiples valors separats per coma en una mateixa cel·la.
Aquesta estructura vulnera el principi d’atòmicitat del model relacional (1NF, First Normal Form), 
motiu pel qual no és possible establir una relació vàlida entre la clau primària (PK) i la clau forana (FK).
Per garantir la integritat referencial, cal normalitzar la taula separant els registres amb múltiples identificadors de producte en diverses files, 
de manera que cada fila representi una única associació entre una transacció i un producte.
Un cop desnormalitzades aquestes dades, poden exportar-se a un nou fitxer o taula auxiliar per implementar una relació 1:N entre transactions i products.  */
	
    -- 1. EXTRAIEM les dades crües. 
    SELECT id, product_ids
    FROM transactions
    INTO OUTFILE "C:\\MySQL_import_DATA\\transactions_product_ids_raw.csv"
    FIELDS TERMINATED BY ';'
    LINES TERMINATED BY '\n';
    
    -- 2. Separem les cel·les on hi ha més d'un producte en files. Netejem les dades. 
		-- 2.1: Creem una taula per carregar aquestes dades crues i separar-les.
        CREATE TABLE IF NOT EXISTS raw_tp_ids (								-- Dades crues dels ids de transaction_products (raw_tp_ids)
			id VARCHAR(50) PRIMARY KEY, product_ids VARCHAR(50));			/* IMPORTANT VIGILAR amb el valor límit del tipus de dada. Havia posat en 'products_ids VARCHAR(10)' 
																			i aixó m'ha donat uns mals de cap terribles perquè el CTE m'omitia l'últim valor dels ids i era per això.*/
	
		-- 2.2: Carreguem dades a la taula
			LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\transactions_product_ids_raw.csv"
			INTO TABLE raw_tp_ids
			FIELDS TERMINATED BY ';'
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
            
            SELECT * FROM raw_tp_ids;
            
		-- 2.3: Separem en files individuals
            SELECT id, value  
            FROM raw_tp_ids
            CROSS APPLY STRING_SPLIT(product_ids, ','); 		-- Error: NO ES COMPATIBLE AMB MySQL 
																-- https://learn.microsoft.com/en-us/sql/t-sql/functions/string-split-transact-sql?view=sql-server-ver16
/* L'Alternativa és crear una CTE:
	1. Initiate a CTE using “WITH”
	2. Provide a name for the result soon-to-be defined query
	3. After assigning a name, follow with “AS”
	4. Specify column names (optional step)
	5. Define the query to produce the desired result set
	6. If multiple CTEs are required, initiate each subsequent expression with a comma and repeat steps 2-4.
	7. Reference the above-defined CTE(s) in a subsequent query */
            
WITH RECURSIVE split AS (															-- Declara una CTE anomenada split que serà recursiva. Això vol dir que s’anirà cridant a si mateixa per processar progressivament el text restant fins que ja no quedin més valors per extreure.
SELECT id, 																			-- Creem la base de la recursió: 'id' mante l'identificador original de la fila
	trim(substring_index(product_ids, ',', 1)) AS VALUE,							-- Extreu el primer valor abans de la primera coma i elimina espais sobrants. Ex.: '16, 26, 97, 87' → VALUE = '16'
	substring(product_ids, length(substring_index(product_ids, ',', 1)) + 2) AS rest -- Calcula el text restant després del primer valor i la coma (el +2 és per la coma i l’espai). Ex.: rest = '26, 97, 87'
FROM raw_tp_ids
WHERE product_ids IS NOT NULL 														-- Només processa les files amb algun valor.
UNION ALL
SELECT rtp.id,
	trim(substring_index(rest, ',', 1)) AS VALUE,
	substring(rest, length(substring_index(rest, ',', 1)) + 2)						-- Actualitza el camp rest per eliminar el valor ja processat.
FROM raw_tp_ids rtp
JOIN split s ON rtp.id = s.id														 -- Connecta la taula original amb l’estat actual de la recursió (split).
WHERE rest <> ''																	-- La recursió continua mentre hi hagi algun text restant.
)
SELECT id, VALUE AS product_id FROM split											-- El resultat és una taula on cada id apareix tantes vegades com valors tenia la seva llista product_ids.
INTO OUTFILE "C:\\MySQL_import_DATA\\transactions_product_ids_CLEAN.csv"			-- Exportar a un fitxer en un directori segur
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';

-- ARA SÍ! Carreguem les dades a la taula de * transaction_products*
LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\transactions_product_ids_CLEAN.csv"
INTO TABLE transaction_products
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';

SELECT COUNT(DISTINCT product_id) FROM transaction_products;						-- Quants productes diff tenim? 100
SELECT COUNT(id) FROM products;								-- Per confirmar que hi ha 100 productes diferents.

-- Algunes comprovacions més:
SELECT * FROM transaction_products
WHERE transaction_id='00043A49-2949-494B-A5DD-A5BAE3BB19DD';				/* Per què retorna 3 product_id i no 4? L'error estaba en que en el moment de crear la taula de 'raw_tp_ids'
																			en la columna de 'product_ids' la VARCHAR estava limitada a 10 i això s'em menjava l'últim valor en el cas 
                                                                            de que hi haguessin més de 3.*/ 

SELECT product_name 
FROM products
JOIN transaction_products tp
	ON products.id=tp.product_id
JOIN transactions t
	ON tp.transaction_id=t.id
WHERE t.id='00043A49-2949-494B-A5DD-A5BAE3BB19DD'; 

SELECT * FROM transactions
WHERE id= '00043A49-2949-494B-A5DD-A5BAE3BB19DD';

##### Creem la taula Users combinant les taules: American_users & European_users ###########
SELECT * FROM american_users
UNION
SELECT * FROM european_users
ORDER BY id;  					-- Si les uneixo així després no podre accedir a les dades especifiques de cada taula. 

/* Per tant, hauré de crear una taula nova que em permeti relacionar-les però 
de tal manera que pugui accedir a les dades de cada taula de forma independent.  
*/
-- Taula nova (Taula d'Unió)
SELECT *
FROM (
	SELECT * FROM american_users
	UNION
	SELECT * FROM european_users
	ORDER BY id) users
INTO OUTFILE "C:\\MySQL_import_DATA\\Users.csv"
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n';

CREATE TABLE IF NOT EXISTS Users (
	id INT PRIMARY KEY, 
    name VARCHAR(20), 
    surname VARCHAR(50),
    phone VARCHAR(20), 
    email VARCHAR(150),
    birth_date VARCHAR(20),
    country VARCHAR(20), 
    city VARCHAR(20),
    postal_code VARCHAR(10),
    address VARCHAR(50));

LOAD DATA LOCAL INFILE "C:\\MySQL_import_DATA\\Users.csv"
INTO TABLE Users
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM users;

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_users
FOREIGN KEY (user_id) REFERENCES users(id);



##################################################################### FI ESQUEMA TAULES #################################################################################################


#########################################################################################################################################################################################
																-- EXERCICIS --
#########################################################################################################################################################################################
-- NIVELL 1:

/*Exercici 1 
Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
*/

SELECT CONCAT(u.name,' ', u.surname) name_surname, user_transactions  
FROM (
	SELECT user_id, COUNT(user_id) AS user_transactions
	FROM transactions
	GROUP BY user_id
	ORDER BY user_transactions DESC) transactions_for_user	
JOIN users u
	ON transactions_for_user.user_id=u.id
WHERE user_transactions > 80;


/* Exercici 2
Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
*/
SELECT iban, ROUND(AVG(amount), 2) AS average
FROM transactions t
JOIN credit_cards cc
	ON t.card_id=cc.id
JOIN company c
	ON t.company_id=c.company_id
WHERE company_name= 'Donec Ltd'
GROUP BY cc.iban
ORDER BY average DESC;

-- NIVELL 2:
/*
Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions 
han estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

Exercici 1
Quantes targetes estan actives?
 */
 SELECT COUNT(status)
 FROM card_status
 WHERE status='active';
 
 -- CREACIÓ TAULA: Card_status
/*  1. SELECCIONAR les targetes, l'estat de les seves transaccions, i el timestamp. DE la taula TRANSACCIONS 
	2. Buscar les últimes tres transaccions. funció ROW_NUMBER() OVER (PARTITION column_name ORDER BY column_name)  
    3. Mirar si les tres són declined=1 o hi ha alguna que no
    4. Crear la taula
*/
 
CREATE TABLE card_status AS
SELECT
    card_id,
    CASE
        WHEN SUM(declined) = 3 THEN 'inactive'
        ELSE 'active'
    END AS status
FROM (
    SELECT
        card_id,
        declined,
        timestamp AS date,
        ROW_NUMBER() OVER (					-- Row_number () enumera les transaccións de cada tarjeta 
            PARTITION BY card_id			-- PARTITION BY --> Agafa com a referent card_id. És com un group by la columna indicada. 
            ORDER BY timestamp DESC			-- Ordenem de forma descendent. La transacció més recent és la primera. 
        ) AS ranking
    FROM transactions
) t
WHERE ranking <= 3						-- Es queda amb les 3 últimes transaccions de cada tarjeta. rn=1, rn=2 i rn=3. 
GROUP BY card_id;

 SELECT * FROM card_status;
 
 -- ESTABLIM LA RELACIÓ DE LA NOVA TAULA AMB L'ESQUEMA GENERAL. 
 ALTER TABLE card_status
 ADD CONSTRAINT fk_card_status
 FOREIGN KEY (card_id) REFERENCES credit_cards(id);
 
 
 /* NIVELL 3
Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

			-- RELACIÓ CREADA EN EL MOMENT DE FER EL DISSENY DE L'ESQUEMA. 

Exercici 1
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.
 */
 
SELECT product_name, COUNT(product_id) AS total_sales
FROM transactions t
JOIN transaction_products tp
	ON t.id=tp.transaction_id
JOIN products p
	ON tp.product_id=p.id
GROUP BY p.id
ORDER BY total_sales DESC;
 
 
 # CORRECCIONES/Millores a incorporar més endavant: 
 -- Incloure un decline=0 en el WHERE en companie = Donec Ltd (nivel 1 ejercició 2). Així seleccionem només aquelles transaccions que no han estat rebutjades. 
 -- En la taula USERS afegir la columna Continent on s'especifica el continent que pertanyen els users: America o Europa. 
	-- De cara a un analisis comparatiu entre continents tindrem més fàcilitat per accedir a les dades. Tot i que ho podem fer amb els paísos.
-- Corregir el JOIN solo uno. !! En transactions_products tenemos todos los products
 
 

 
 
 
 
 
