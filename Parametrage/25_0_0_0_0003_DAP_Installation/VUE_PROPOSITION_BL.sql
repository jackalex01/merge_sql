ALTER VIEW [VUE_PROPOSITION_BL]
AS
select
	LI.N_LigneCli,
	LI.N_cde_Cli,
	LI.N_Prod,
	N_Fct_Base = 0,
	LI.Activite,
	LI.N_Position,
	LI.Reference,
	LI.Designation,
	LI.Texte,
	LI.Remise,
	LI.PU_Franc,
	LI.PU_Euro,
	LI.Tva,
	Revient_Franc = P.DernierPrixAchat_Franc,
	Revient_Euro = P.DernierPrixAchat_Euro,
	Qte=LI.Quantite,
	Cde=LI.Quantite,
	cdeavant = (SELECT SUM(Quantite) FROM LIGNECLI LI_AVANT
      		WHERE (LI.N_Cde_Cli = LI_AVANT.N_Cde_Cli) AND 
           	(LI.N_Prod = LI_AVANT.N_Prod)
		AND(( LI_AVANT.N_Position < LI.N_Position )
		OR( ( LI_AVANT.N_Position = LI.N_Position ) AND ( LI_AVANT.N_LigneCli < LI.N_LigneCli ) ))),
    	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (SS_BL.N_Cde_Client = LI.N_Cde_Cli) AND 
           	(SS_BL.N_Produit = LI.N_Prod)), 
    	Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END),
	derniereligne = (SELECT TOP 1 n_ligneCli FROM LIGNECLI LI_LAST
      		WHERE (LI.N_Cde_Cli = LI_LAST.N_Cde_Cli) AND 
           	(LI.N_Prod = LI_LAST.N_Prod)AND
		( LI_LAST.N_Position > LI.N_Position ) ORDER BY LI_LAST.N_Position DESC, LI_LAST.N_LigneCli DESC ),
    	GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 'Non' END),
    	GestionLivraison='Oui',
	LI.Unite,
	LI.CodePoste,
	LI.Libre1
    /* s{Col_Detail_Supp Code=Select Comment=Oui /} *//*
    ,numeric1
    ,numeric2
    ,check1
    ,check2
    ,date1
    ,date2
    ,Libre2
    ,Libre3
    ,Libre4
    ,Numeric3
    ,Numeric4
    ,Fournisseur
    ,Marque
    *//* s{/Col_Detail_Supp Code=Select /} */
    /* s{App_LigneId Code=Select /} */
    ,TypeFiche_Precedent = 104
    ,N_Fiche_Precedent = li.N_Cde_Cli
    ,N_Detail_Precedent =li.N_LigneCli
    ,App_LigneId_Origine = li.App_LigneId
     /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI 
LEFT OUTER JOIN STOCK_PRODUIT S ON (S.N_Depot = LI.N_Depot) AND (S.N_Produit = LI.N_Prod) 
LEFT OUTER JOIN PRODUIT P ON (P.N_Produit = LI.N_Prod)
,Soft_ini Si
WHERE (LI.N_Prod > 0) 
/* s{App_LigneId Code=Where /} */
AND (si.Vente_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */

UNION ALL

select
	LI.N_LigneCli,
	LI.N_cde_Cli,
	0,
	LI.N_Fct_Base,
	LI.Activite,
	LI.N_Position,
	LI.Reference,
	LI.Designation,
	LI.Texte,
	LI.Remise,
	LI.PU_Franc,
	LI.PU_Euro,
	LI.Tva,
	Revient_Franc = F.Total_HT_General_Franc,
	Revient_Euro = F.Total_HT_General_Euro,
	Qte=LI.Quantite,
	Cde=LI.Quantite,
	cdeavant = (SELECT SUM(Quantite) FROM LIGNECLI LI_AVANT
      		WHERE (LI.N_Cde_Cli = LI_AVANT.N_Cde_Cli) AND 
           	(LI.N_Fct_Base = LI_AVANT.N_Fct_Base)
		AND(( LI_AVANT.N_Position < LI.N_Position )
		OR( ( LI_AVANT.N_Position = LI.N_Position ) AND ( LI_AVANT.N_LigneCli < LI.N_LigneCli ) ))),
    	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (SS_BL.N_Cde_Client = LI.N_Cde_Cli) AND 
           	(SS_BL.N_Fct_Base = LI.N_Fct_Base)), 
    	Dispo = (CASE WHEN F.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END),
	derniereligne = (SELECT TOP 1 n_ligneCli FROM LIGNECLI LI_LAST
      		WHERE (LI.N_Cde_Cli = LI_LAST.N_Cde_Cli) AND 
           	(LI.N_Fct_Base = LI_LAST.N_Fct_Base) ORDER BY LI_LAST.N_Position DESC, LI_LAST.N_LigneCli DESC ),
    	GestionStock = (CASE WHEN F.GestionStock = 'Oui' THEN F.GestionStock ELSE 'Non' END),
    	GestionLivraison='Oui',
	LI.Unite,
	LI.CodePoste,
	LI.Libre1
    /* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*
    ,numeric1
    ,numeric2
    ,check1
    ,check2
    ,date1
    ,date2
    ,Libre2
    ,Libre3
    ,Libre4
    ,Numeric3
    ,Numeric4
    ,Fournisseur
    ,Marque
    *//* s{/Col_Detail_Supp Code=Insert /} */
    /* s{App_LigneId Code=Select /} */
    ,TypeFiche_Precedent = 104
    ,N_Fiche_Precedent = li.N_Cde_Cli
    ,N_Detail_Precedent =li.N_LigneCli
    ,App_LigneId_Origine = li.App_LigneId
     /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI 
LEFT OUTER JOIN STOCK_PRODUIT S ON (S.N_Depot = LI.N_Depot) AND (S.N_Fct_Base = LI.N_Fct_Base) 
LEFT OUTER JOIN FCT_BASE F ON (F.N_Fct_Base = LI.N_Fct_Base)
,Soft_ini si
WHERE (LI.N_Fct_Base > 0)
/* s{App_LigneId Code=Where /} */
AND (si.Vente_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */


UNION ALL

select
	LI.N_LigneCli,
	LI.N_cde_Cli,
	N_Prod = 0,
	N_Fct_Base = 0,
	LI.Activite,
	LI.N_Position,
	LI.Reference,
	LI.Designation,
	LI.Texte,
	LI.Remise,
	LI.PU_Franc,
	LI.PU_Euro,
	LI.Tva,
	Revient_Franc = 0,
	Revient_Euro = 0,
	Qte=LI.Quantite,
	Cde=LI.Quantite,
    	cdeavant = (SELECT SUM(Quantite) FROM LIGNECLI LI_AVANT
      		WHERE (LI.N_Cde_Cli = LI_AVANT.N_Cde_Cli) AND 
           	(LI.Reference = LI_AVANT.Reference) AND 
           	(LI.Designation = LI_AVANT.Designation)
		AND(( LI_AVANT.N_Position < LI.N_Position )
		OR( ( LI_AVANT.N_Position = LI.N_Position ) AND ( LI_AVANT.N_Lignecli < LI.N_LigneCli ) ))),
    	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (LI.N_Cde_Cli = SS_BL.N_Cde_Client) AND 
           	(LI.Reference = SS_BL.Ref_Produit) AND 
           	(LI.Designation = SS_BL.Designation)), 
    	Dispo = NULL, 
	derniereligne = (SELECT TOP 1 n_lignecli FROM LIGNECLI LI_LAST
      		WHERE (LI.N_Cde_Cli = LI_LAST.N_Cde_Cli) AND 
           	(LI.Reference = LI_LAST.Reference) AND 
           	(LI.Designation = LI_LAST.Designation)
		ORDER BY N_Position DESC, N_LigneCli DESC ),
	GestionStock = 'Non', GestionLivraison = 'Oui',
	LI.Unite,
	LI.CodePoste,
	LI.Libre1
    /* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*
    ,numeric1
    ,numeric2
    ,check1
    ,check2
    ,date1
    ,date2
    ,Libre2
    ,Libre3
    ,Libre4
    ,Numeric3
    ,Numeric4
    ,Fournisseur
    ,Marque
    *//* s{/Col_Detail_Supp Code=Insert /} */
    /* s{App_LigneId Code=Select /} */
    ,TypeFiche_Precedent = 104
    ,N_Fiche_Precedent = li.N_Cde_Cli
    ,N_Detail_Precedent =li.N_LigneCli
    ,App_LigneId_Origine = li.App_LigneId
     /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI
,Soft_ini Si
WHERE ((LI.N_Prod IS NULL)OR(LI.N_Prod <= 0)) AND 
    ((LI.N_Fct_Base IS NULL)OR(LI.N_Fct_Base <= 0)) AND 
    ((LI.Reference IS NOT NULL) AND 
    (LI.Reference <> '')) AND ((LI.Designation IS NOT NULL) AND 
    (LI.Designation <> '')) AND ( LI.Quantite IS NOT NULL )
    /* s{App_LigneId Code=Where /} */
    AND (si.Vente_Suivi_Avec_LigneId = 'Non')
    /* s{/App_LigneId Code=Where /} */

UNION ALL

select
	LI.N_LigneCli,
	LI.N_cde_Cli,
	N_Prod = 0,
	N_Fct_Base = 0,
	LI.Activite,
	LI.N_Position,
	LI.Reference,
	LI.Designation,
	LI.Texte,
	LI.Remise,
	LI.PU_Franc,
	LI.PU_Euro,
	LI.Tva,
	Revient_Franc = 0,
	Revient_Euro = 0,
	Qte=LI.Quantite,
	Cde=NULL,
    	cdeavant = NULL,
    	livre = NULL, 
    	Dispo = NULL, 
	derniereligne = LI.N_LigneCli,
	GestionStock = 'Non', 
	GestionLivraison = 'Non',
	LI.Unite,
	LI.CodePoste,
	LI.Libre1
    /* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*
    ,numeric1
    ,numeric2
    ,check1
    ,check2
    ,date1
    ,date2
    ,Libre2
    ,Libre3
    ,Libre4
    ,Numeric3
    ,Numeric4
    ,Fournisseur
    ,Marque
    *//* s{/Col_Detail_Supp Code=Insert /} */
    /* s{App_LigneId Code=Select /} */
    ,TypeFiche_Precedent = 104
    ,N_Fiche_Precedent = li.N_Cde_Cli
    ,N_Detail_Precedent =li.N_LigneCli
    ,App_LigneId_Origine = li.App_LigneId
     /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI
,Soft_ini Si
WHERE ((LI.N_Prod IS NULL)OR(LI.N_Prod <= 0)) AND 
    ((LI.N_Fct_Base IS NULL)OR(LI.N_Fct_Base <= 0)) AND 
    ((LI.Reference IS NOT NULL) AND 
    (LI.Reference <> '')) AND ((LI.Designation IS NOT NULL) AND 
    (LI.Designation <> '')) AND ( LI.Quantite IS NOT NULL )
    /* s{App_LigneId Code=Where /} */
    AND (si.Vente_Suivi_Avec_LigneId = 'Non')
    /* s{/App_LigneId Code=Where /} */

UNION ALL

/*                                                                  
================================================
 -> Les lignes avec un App_LigneId
================================================
*/
SELECT 
      LI.N_LigneCli
    , LI.N_cde_Cli
    , LI.N_Prod
    , N_Fct_Base = 0
    , LI.Activite
    , LI.N_Position
    , LI.Reference
    , LI.Designation
    , LI.Texte
    , LI.Remise
    , LI.PU_Franc
    , LI.PU_Euro
    , LI.Tva
    , Revient_Franc = P.DernierPrixAchat_Franc
    , Revient_Euro = P.DernierPrixAchat_Euro
    , Qte = LI.Quantite
    , Cde = LI.Quantite
    , cdeavant = (SELECT 
                        SUM(Quantite)
                  FROM LIGNECLI LI_AVANT
                  WHERE (LI.N_Cde_Cli = LI_AVANT.N_Cde_Cli) AND (LI.App_LigneId = LI_AVANT.App_LigneId) AND ((LI_AVANT.N_Position < LI.N_Position) OR ((LI_AVANT.N_Position = LI.N_Position) AND (LI_AVANT.N_LigneCli < LI.N_LigneCli))))
    , livre = (SELECT 
                     SUM(Qte)
               FROM SS_BL
               WHERE (SS_BL.N_Cde_Client = LI.N_Cde_Cli) AND (SS_BL.App_LigneId = LI.App_LigneId))
    , Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END)
    , derniereligne = (SELECT 
                             TOP 1 n_ligneCli
                       FROM LIGNECLI LI_LAST
                       WHERE (LI.N_Cde_Cli = LI_LAST.N_Cde_Cli) AND (LI.App_LigneId = LI_LAST.App_LigneId) AND (LI_LAST.N_Position > LI.N_Position)
                       ORDER BY  LI_LAST.N_Position DESC
                                ,LI_LAST.N_LigneCli DESC)
    , GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 'Non' END)
    , GestionLivraison = 'Oui'
    , LI.Unite
    , LI.CodePoste
    , LI.Libre1
    /* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*
    ,numeric1
    ,numeric2
    ,check1
    ,check2
    ,date1
    ,date2
    ,Libre2
    ,Libre3
    ,Libre4
    ,Numeric3
    ,Numeric4
    ,Fournisseur
    ,Marque
    *//* s{/Col_Detail_Supp Code=Insert /} */
    /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 104
    , N_Fiche_Precedent = li.N_Cde_Cli
    , N_Detail_Precedent = li.N_LigneCli
    , App_LigneId_Origine = li.App_LigneId
    /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI
LEFT OUTER JOIN STOCK_PRODUIT S ON  (S.N_Depot = LI.N_Depot) AND (S.N_Produit = LI.N_Prod)
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = LI.N_Prod)
,Soft_ini Si
WHERE (si.Vente_Suivi_Avec_LigneId = 'Oui')








