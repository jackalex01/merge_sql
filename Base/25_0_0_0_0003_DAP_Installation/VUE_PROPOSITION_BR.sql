ALTER VIEW [VUE_PROPOSITION_BR]
AS
SELECT 
	SCD.N_Position, SCD.N_Scd_Four, SCD.N_Cde_Four, 
    	SCD.N_Prod, SCD.Rubrique, reference = SCD.Ref, 
    	SCD.Designation, SCD.Texte, SCD.CodePoste, SCD.Libre1,
	SCD.Remise, SCD.Prix_HT_Franc, 
    	SCD.Prix_HT_Euro, SCD.Tva, Qte = SCD.Quantite, 
    	Cde = SCD.Quantite, 
	cdeavant = (SELECT SUM(Quantite) FROM Scd_Four SCD_AVANT
      		WHERE (SCD.N_Cde_Four = SCD_AVANT.N_Cde_Four) AND 
           	(SCD.N_Prod = SCD_AVANT.N_Prod)
		AND(( SCD_AVANT.N_Position < SCD.N_Position )
		OR( ( SCD_AVANT.N_Position = SCD.N_Position ) AND ( SCD_AVANT.N_Scd_Four < SCD.N_Scd_Four ) ))),
    	livre = (SELECT SUM(Qte) FROM SS_BR
      		WHERE (SS_BR.N_Cde_Four = SCD.N_Cde_Four) AND 
           	(SS_BR.N_Produit = SCD.N_Prod)), 
    	Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END),
	derniereligne = (SELECT TOP 1 n_scd_four FROM Scd_Four SCD_LAST
      		WHERE (SCD.N_Cde_Four = SCD_LAST.N_Cde_Four) AND 
           	(SCD.N_Prod = SCD_LAST.N_Prod) ORDER BY N_Position DESC, N_Scd_Four DESC ),
    	GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 'Non' END),
    	GestionLivraison='Oui',
	SCD.Unite
FROM SCD_FOUR SCD 
LEFT OUTER JOIN STOCK_PRODUIT S ON (S.N_Depot = SCD.N_Depot) AND (S.N_Produit = SCD.N_Prod) 
LEFT OUTER JOIN PRODUIT P ON (P.N_Produit = SCD.N_Prod)
WHERE (SCD.N_Prod > 0)

UNION ALL

SELECT 
	SCD.N_Position, SCD.N_Scd_Four, SCD.N_Cde_Four, 
    	SCD.N_Prod, SCD.Rubrique, reference = SCD.Ref, 
    	SCD.Designation, SCD.Texte, SCD.CodePoste, SCD.Libre1, 
	SCD.Remise, SCD.Prix_HT_Franc, 
    	SCD.Prix_HT_Euro, SCD.Tva, Qte = SCD.Quantite, 
    	Cde = SCD.Quantite, 
    	cdeavant = (SELECT SUM(Quantite) FROM Scd_Four SCD_AVANT
      		WHERE (SCD.N_Cde_Four = SCD_AVANT.N_Cde_Four) AND 
           	(SCD.Ref = SCD_AVANT.Ref) AND 
           	(SCD.Designation = SCD_AVANT.Designation)
		AND(( SCD_AVANT.N_Position < SCD.N_Position )
		OR( ( SCD_AVANT.N_Position = SCD.N_Position ) AND ( SCD_AVANT.N_Scd_Four < SCD.N_Scd_Four ) ))),
    	livre = (SELECT SUM(Qte) FROM SS_BR
      		WHERE (SCD.N_Cde_Four = SS_BR.N_Cde_Four) AND 
           	(SCD.Ref = SS_BR.Ref_Produit) AND 
           	(SCD.Designation = SS_BR.Designation)), 
    	Dispo = NULL, 
	derniereligne = (SELECT TOP 1 n_scd_four FROM Scd_Four SCD_LAST
      		WHERE (SCD.N_Cde_Four = SCD_LAST.N_Cde_Four) AND 
           	(SCD.Ref = SCD_LAST.Ref) AND 
           	(SCD.Designation = SCD_LAST.Designation)
		ORDER BY N_Position DESC, N_Scd_Four DESC ),
	GestionStock = 'Non', GestionLivraison = 'Oui', SCD.Unite
FROM SCD_FOUR SCD
WHERE ((SCD.N_Prod IS NULL) OR
    (SCD.N_Prod <= 0)) AND ((SCD.Ref IS NOT NULL) AND 
    (SCD.Ref <> '')) AND ((SCD.Designation IS NOT NULL) AND 
    (SCD.Designation <> '')) AND ( SCD.Quantite IS NOT NULL )

UNION ALL

SELECT 
	SCD.N_Position, SCD.N_Scd_Four, SCD.N_Cde_Four, 0, 
    	SCD.Rubrique, reference = SCD.Ref, SCD.Designation, SCD.Texte, SCD.CodePoste, SCD.Libre1,
    	SCD.Remise, SCD.Prix_HT_Franc, SCD.Prix_HT_Euro, 
    	SCD.Tva, Qte = SCD.Quantite, Cde = NULL, cdeavant = null, livre = NULL, 
    	Dispo = NULL, 
	derniereligne = SCD.N_Scd_Four,
	GestionStock = 'Non', GestionLivraison='Non',SCD.Unite
FROM SCD_FOUR SCD
WHERE 	((SCD.N_Prod IS NULL) OR
    	(SCD.N_Prod <= 0)) AND ((SCD.Ref IS NULL) OR
    	(SCD.Ref = '') OR
    	(SCD.Designation IS NULL) OR
    	(SCD.Designation = '') OR (SCD.Quantite IS NULL))





