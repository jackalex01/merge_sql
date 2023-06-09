ALTER VIEW [VUE_RECAP_LIVRAISON_CDE_CLI]
AS
SELECT 
	LI.N_Cde_Cli, LI.N_Prod, LI.N_Fct_Base,
	reference = LI.Reference, 
    	LI.Designation, 
	Cde = SUM(LI.Quantite), 
	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (LI.N_Cde_Cli = SS_BL.N_Cde_Client)AND
		      (((N_Produit > 0 )AND(N_Produit = LI.N_Prod))OR((N_Fct_Base > 0 )AND(N_Fct_Base = LI.N_Fct_base)))), 
    	Dispo = (CASE WHEN (( P.GestionStock = 'Oui' )OR( F.GestionStock = 'Oui' )) THEN S.Qte_Stock ELSE NULL END), 
    	GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 
			(CASE WHEN F.GestionStock = 'Oui' THEN F.GestionStock ELSE 'Non' END) END)
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = NULL
    , numeric2 = NULL
    , check1 = NULL
    , check2 = NULL
    , date1 = NULL
    , date2 = NULL
    , Libre2 = NULL
    , Libre3 = NULL
    , Libre4 = NULL
    , Numeric3 = NULL
    , Numeric4 = NULL
    , Fournisseur = NULL
    , Marque = NULL
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , App_LigneId = ''
      /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI 
LEFT OUTER JOIN STOCK_PRODUIT S ON (S.N_Depot = LI.N_Depot)AND((( LI.N_Prod > 0 )AND(S.N_Produit = LI.N_Prod))OR(( LI.N_Fct_Base > 0 )AND(S.N_Fct_Base = LI.N_Fct_Base)))
LEFT OUTER JOIN PRODUIT P ON (P.N_Produit = LI.N_Prod) 
LEFT OUTER JOIN FCT_BASE F ON (F.N_Fct_Base = LI.N_Fct_Base)
,Soft_ini Si 
WHERE ((LI.N_Prod > 0)OR(LI.N_Fct_Base > 0))
/* s{App_LigneId Code=Where /} */
AND (si.Vente_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */
GROUP BY 
	LI.N_Cde_Cli, LI.N_Prod, LI.N_Fct_Base, LI.Reference, 
    	LI.Designation, S.Qte_Stock, P.GestionStock, F.GestionStock

UNION

SELECT 
	LI.N_Cde_Cli, NULL, NULL,
	reference = LI.Reference, 
    	LI.Designation, 
	Cde = SUM(LI.Quantite), 
	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (LI.N_Cde_Cli = SS_BL.N_Cde_Client)AND(LI.Reference = SS_BL.Ref_Produit)AND(LI.Designation = SS_BL.Designation)), 
    	Dispo = NULL, GestionStock = 'Non'
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = NULL
    , numeric2 = NULL
    , check1 = NULL
    , check2 = NULL
    , date1 = NULL
    , date2 = NULL
    , Libre2 = NULL
    , Libre3 = NULL
    , Libre4 = NULL
    , Numeric3 = NULL
    , Numeric4 = NULL
    , Fournisseur = NULL
    , Marque = NULL
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , App_LigneId = ''
      /* s{/App_LigneId Code=Select /} */
FROM LIGNECLI LI
,Soft_ini Si
WHERE (LI.Quantite IS NOT NULL)AND 
      ((LI.N_Prod IS NULL)OR(LI.N_Prod <= 0))AND
      ((LI.N_Fct_Base IS NULL)OR(LI.N_Fct_Base <= 0))AND	
      ((LI.Reference IS NOT NULL)AND(LI.Reference <> ''))AND
      ((LI.Designation IS NOT NULL)AND(LI.Designation <> ''))
      /* s{App_LigneId Code=Where /} */
      AND (si.Vente_Suivi_Avec_LigneId = 'Non')
      /* s{/App_LigneId Code=Where /} */
GROUP BY 
	LI.N_Cde_Cli, LI.Reference, 
    	LI.Designation

/*
UNION

SELECT 
	LI.N_Cde_Cli, LI.N_Prod, LI.N_Fct_Base,
	reference = LI.Reference, 
    	LI.Designation, 
	Cde = SUM(LI.Quantite), 
	livre = (SELECT SUM(Qte) FROM SS_BL
      		WHERE (LI.N_Cde_Cli = SS_BL.N_Cde_Client)AND(N_Fct_Base = LI.N_Fct_Base)), 
    	Dispo = (CASE WHEN F.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END), 
    	GestionStock = (CASE WHEN F.GestionStock = 'Oui' THEN F.GestionStock ELSE 'Non' END)
FROM LIGNECLI LI 
LEFT OUTER JOIN STOCK_PRODUIT S ON (S.N_Depot = LI.N_Depot)AND(S.N_Fct_Base = LI.N_Fct_Base) 
LEFT OUTER JOIN FCT_BASE F ON (F.N_Fct_Base = LI.N_Fct_Base) 
WHERE (LI.N_Fct_Base > 0)
GROUP BY 
	LI.N_Cde_Cli, LI.N_Prod, LI.N_Fct_Base, LI.Reference, 
    	LI.Designation, S.Qte_Stock, F.GestionStock
*/

UNION ALL

/*                                                                  
================================================
 -> Les lignes avec un App_LigneId
================================================
*/
SELECT 
      N_Cde_Cli = r.N_Cde_Cli
    , N_Prod = r.N_Produit
    , N_Fct_Base = r.N_Fct_Base
    , reference = r.reference
    , Designation = r.Designation
    , Cde = r.Cde
    , livre = r.livre
    , Dispo = r.Dispo
    , GestionStock = r.GestionStock
    , numeric1 = NULL
    , numeric2 = NULL
    , check1 = NULL
    , check2 = NULL
    , date1 = NULL
    , date2 = NULL
    , Libre2 = NULL
    , Libre3 = NULL
    , Libre4 = NULL
    , Numeric3 = NULL
    , Numeric4 = NULL
    , Fournisseur = NULL
    , Marque = NULL
    , App_LigneId = r.App_LigneId
FROM dbo.Cde_cli cc
OUTER APPLY dbo.FCTT_CDC_RECAP_LIVRAISON (cc.N_Cde_Cli,0) r
CROSS JOIN dbo.Soft_ini si 
WHERE (si.Vente_Suivi_Avec_LigneId = 'Oui')

