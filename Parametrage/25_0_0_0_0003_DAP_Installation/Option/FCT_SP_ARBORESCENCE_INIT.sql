ALTER FUNCTION [FCT_SP_ARBORESCENCE_INIT]
(
@N_user integer
)
RETURNS Table
AS
RETURN
(
SELECT TOP 100000 V.*
FROM
	(
	SELECT Type = 0, * FROM RUBRIQUE
	WHERE Application = 0

	UNION ALL

	SELECT Type = 1, * FROM RUBRIQUE
	WHERE Tabl_ = 'AFFAIRE'

	UNION ALL

	SELECT Type = 2, * FROM RUBRIQUE
	WHERE Tabl_ = 'BL'

	UNION ALL

	SELECT Type = 3, * FROM RUBRIQUE
	WHERE Tabl_ = 'BR'

	UNION ALL

	SELECT Type = 4, * FROM RUBRIQUE
	WHERE Tabl_ = 'CLIENT'

	UNION ALL

	SELECT Type = 5, * FROM RUBRIQUE
	WHERE Tabl_ = 'CDE_CLI'

	UNION ALL

	SELECT Type = 6, * FROM RUBRIQUE
	WHERE Tabl_ = 'CDE_FOUR'

	UNION ALL

	SELECT Type = 7, * FROM RUBRIQUE
	WHERE Tabl_ = 'CONTACT'

	UNION ALL

	SELECT Type = 8, * FROM RUBRIQUE
	WHERE Tabl_ = 'CONTFN'

	UNION ALL

	SELECT Type = 9, * FROM RUBRIQUE
	WHERE Tabl_ = 'DEVIS'

	UNION ALL

	SELECT Type = 10, * FROM RUBRIQUE
	WHERE Tabl_ = 'FACT_CLI'

	UNION ALL

	SELECT Type = 11, * FROM RUBRIQUE
	WHERE Tabl_ = 'FAC_FOUR'

	UNION ALL

	SELECT Type = 12, * FROM RUBRIQUE
	WHERE Tabl_ = 'FCT_BASE'

	UNION ALL

	SELECT Type = 13, * FROM RUBRIQUE
	WHERE Tabl_ = 'FOURNISS'

	UNION ALL

	SELECT Type = 14, * FROM RUBRIQUE
	WHERE Tabl_ = 'ITC'

	UNION ALL

	SELECT Type = 15, * FROM RUBRIQUE
	WHERE Tabl_ = 'ORDREF'

	UNION ALL

	SELECT Type = 16, * FROM RUBRIQUE
	WHERE Tabl_ = 'PRODUIT'

	UNION ALL

	SELECT Type = 17, * FROM RUBRIQUE
	WHERE Tabl_ = 'PROJET'

	UNION ALL

	SELECT Type = 18, * FROM RUBRIQUE
	WHERE Tabl_ = 'RF'

	UNION ALL

	SELECT Type = 19, * FROM RUBRIQUE
	WHERE Tabl_ = 'MSTAT'

	UNION ALL

	SELECT Type = 20, * FROM RUBRIQUE
	WHERE Tabl_ = 'MSTOCK'

	UNION ALL

	SELECT Type = 21, * FROM RUBRIQUE
	WHERE (Tabl_ = 'MTRESO') OR (Tabl_ = 'INVENTAIRE')

	UNION ALL

	SELECT Type = 22, * FROM RUBRIQUE
	WHERE Tabl_ = 'MABONNEMENT'

	UNION ALL

	SELECT Type = 23, * FROM RUBRIQUE
	WHERE Tabl_ = 'DEMANDE_ACHAT'

	UNION ALL    
	                                                                          
	SELECT Type = 80, * FROM RUBRIQUE
	WHERE Tabl_ = 'REQUETE' 

	UNION ALL

	SELECT Type = 81, * FROM RUBRIQUE
	WHERE Tabl_ = 'CAMPAGNE' 
    
    UNION ALL 

    SELECT Type = 32, * FROM RUBRIQUE WHERE Tabl_ = 'TB_DAP_DEMANDE_APPRO'

	)V
	
ORDER BY Type, niveau, Parent, Description, N_Rubrique

)



