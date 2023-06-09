ALTER PROCEDURE [FACT_CLI_COMBOLISTE_BL] 
@N_Fact_Cli int, @N_Client int, @N_Cde_Cli int, @N_Affaire int, @N_Depot int
AS
 
SELECT 
Nom_BL, 
Num_BL, 
Date_BL, 
Descriptif,
N_BL
FROM BL
WHERE Parent > 0 AND 
ISNULL( N_Client, 0 ) 		= ISNULL( @N_Client, 0 ) AND 
ISNULL( N_Affaire, 0 ) 		= ISNULL( @N_Affaire, 0 ) AND 
ISNULL( N_Depot, 0 ) 		= ISNULL( @N_Depot, 0 ) AND 
ISNULL( N_Cde_Client, 0 ) 	= ISNULL( @N_Cde_Cli, 0 ) AND
NOT EXISTS ( SELECT FACT.N_FACT_CLI FROM FACT_CLI FACT WHERE FACT.Parent > 0 AND FACT.N_FACT_CLI = BL.N_FACT_CLI )
AND (bl.Stock_Reservation = 'Non' OR bl.Stock_Reservation IS NULL )
ORDER BY Nom_BL
 
 

