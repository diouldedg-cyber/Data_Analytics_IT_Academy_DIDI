-- Creem la base de dades si no existeix carregant el fitxer: structura dades.sql
-- Insertem el registre de dades carregant el fitxer: dades_introduir_sprint2.sql 

USE transactions; -- Si la base de dades ja existeix per l'usuari. 

SELECT * FROM company;
SELECT * FROM transaction;

######################################### DESCRIPCIÓ DE LES TAULES ##############################################

DESC company;   -- Descriu la taula: camps, tipus de variables, i ens indica quina és la PK i quina la FK. 
DESC transaction;  

-- Comprovar si hay duplicados en la tabla o no?
SELECT COUNT(*)
FROM (SELECT DISTINCT *
	  FROM company) AS Companyies_diferents;

SELECT COUNT(*)
FROM (SELECT DISTINCT *
	  FROM transaction) AS Transaccions_uniques;

													-- NOMÉS UTILITZA JOINs --
-- Llista dels països que generen ventes -- 
SELECT country
FROM company 
JOIN transaction ON company.id=transaction.company_id
GROUP BY country;

-- Des de quants països es generen ventes --
SELECT count(DISTINCT country) AS Països_amb_ventes 				-- Compta els països una vegada.
FROM company 
JOIN transaction ON company.id=transaction.company_id;

-- Companyia amb la mitjana de ventes més gran --
SELECT company_name, ROUND(AVG (amount), 2) AS mitjana_ventes
FROM company 
JOIN transaction ON company.id=transaction.company_id
GROUP BY company_id
ORDER BY mitjana_ventes DESC
LIMIT 1;
				
                -- FORMA DINÀMICA: 
-- 1. Calcular la mitjana de ventes per companyia
-- 2. Compara la mitjana de totes les empreses amb la mitjana més alta [max(mean)].    
-- 3. Retornar aquella empresa/-ses amb la mitjana més alta   
                
SELECT company_id, company_name AS Empresa, mitjana_per_empresa
FROM (																		-- Ens retorna una taula amb la mitjana de cada empresa i el seu ID. 
	  SELECT company_id, ROUND(AVG(amount), 2) AS mitjana_per_empresa
	  FROM transaction
	  WHERE declined=0
	  GROUP BY company_id) Mitjana_empresa
JOIN company ON Mitjana_empresa.company_id=company.id
WHERE mitjana_per_empresa = (SELECT ROUND(MAX(Mitjana_total), 2) AS Max_mitjana				-- Retorna el promig més gran. Un únic valor i totes les empreses que tinguin aquell valor es mostren en resultats. 
							 FROM (															
									SELECT company_id, AVG(amount) AS Mitjana_total			-- Fa el promig de cada empresa
									FROM transaction
									WHERE declined=0
                                    GROUP BY company_id) Mitjana_Global);  		
                                    


												-- Únicament utilitza SUBCONSULTES (NO JOINs) --
-- Mostra totes les transaccions realitzades per empreses d'Alemanya. --
SELECT * FROM transaction;
SELECT * FROM company;

SELECT *
FROM transaction 
WHERE declined=0
AND transaction.company_id IN (SELECT id
	   FROM company
	   WHERE country = 'Germany');

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions. --
SELECT company_name AS Empresa, amount
FROM company, transaction 
WHERE company.id=transaction.company_id
	AND amount > (SELECT AVG(amount) AS mitjana
				   FROM transaction
                   WHERE declined=0)
GROUP BY transaction.id;

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses. -- 
SELECT *
FROM transaction
WHERE company_id NOT IN (SELECT id 
			 FROM company);
             
SELECT * 						-- 
FROM transaction 
WHERE EXISTS (SELECT id
			  FROM company
              WHERE id IS NULL);

############################################################ NIVELL 2 #######################################################################################

-- EXERCICIS NIVELL 2:

 /* Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
 Mostra la data de cada transacció juntament amb el total de les vendes. */
 
 SELECT * FROM transaction;

SELECT DATE(timestamp) AS Date_dia, SUM(amount) AS Suma_dia
FROM transaction
GROUP BY Date_dia
ORDER BY Suma_dia DESC
LIMIT 5;

									-- ALTERNATIVA amb funció RANK() OVER (PARTITION column_name ORDER BY column_name) AS new_name --
SELECT company_id, 
		Date_dia, 
        max(Suma_dia) AS max_venta_dia,
        ranking
FROM (
		SELECT 
			  company_id,
			  DATE(timestamp) AS Date_dia,
			  SUM(amount) AS Suma_dia,
			  RANK() OVER (PARTITION BY company_id ORDER BY sum(amount) DESC) AS ranking
		FROM transaction
		GROUP BY company_id, DATE(timestamp)) Rank_ventes_empresa
WHERE ranking BETWEEN 0 AND 5
GROUP BY company_id, Date_dia
ORDER BY company_id AND ranking;


-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà. --
SELECT country, ROUND(AVG(amount), 2) AS mitjana_vendes
FROM transaction 
JOIN company ON transaction.company_id=company.id
WHERE transaction.declined=0
GROUP BY country
ORDER BY mitjana_vendes DESC;

-- la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que "Non Institute".

	-- Mostra el llistat aplicant JOIN i subconsultes.
SELECT transaction.id, company_name, amount 
FROM transaction
JOIN company ON transaction.company_id=company.id
WHERE country IN (
				   SELECT country
                   FROM company
                   WHERE company_name = 'Non Institute');

    -- Mostra el llistat aplicant solament subconsultes.
SELECT id,
       company_id,
       amount
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = (
        SELECT country
        FROM company
        WHERE company_name = 'Non Institute'
    )
);
                
################################################################## NIVELL 3 ################################################################################

-- EXERCICIS NIVELL 3: 

/* Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 
29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat. */

SELECT company_name, phone, country, DATE(timestamp) AS Date_dia, amount
FROM company
JOIN transaction ON company.id=transaction.company_id
WHERE amount BETWEEN 350 AND 400 AND (DATE(timestamp) = '2015-04-29'
									  OR DATE(timestamp) = '2018-07-20'
									  OR DATE(timestamp) = '2024-03-13')
ORDER BY amount DESC;


-- Quantitat de transaccions que realitzen les empreses i un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys.

SELECT company_id, company_name,
		CASE																		-- Es com el IF...ELSE. 
			WHEN Quantitat_transaccions > 400 THEN "Més de 400 transaccions"
			ELSE "Menys de 400 transaccions" 
			END AS Transaccions_per_empresa
FROM 
	(SELECT company_id, count(id) AS Quantitat_transaccions 
	 FROM transaction
	 GROUP BY company_id) num_transaccions
JOIN company ON company.id=num_transaccions.company_id;
