ALTER VIEW [VUE_RECAP_LIVRAISON_CDE_FOUR]
AS


SELECT 
	SCD.N_Cde_Four, 
	SCD.N_Prod, 
	reference = SCD.Ref, 
    SCD.Designation, 
	Cde = SUM(SCD.Quantite), 
	livre = (SELECT SUM(Qte) FROM SS_BR WHERE (SCD.N_Cde_Four = SS_BR.n_cde_four) AND (N_Produit = SCD.N_Prod) AND isnull(SS_BR.REF_Produit,'') = isnull(SCD.REF,'') AND (ss_br.designation = scd.Designation)), 
    Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END), 
    GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 'Non' END)
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
FROM SCD_FOUR SCD LEFT OUTER JOIN
    STOCK_PRODUIT S ON (S.N_Depot = SCD.N_Depot) AND 
    (S.N_Produit = SCD.N_Prod) LEFT OUTER JOIN
    PRODUIT P ON (P.N_Produit = SCD.N_Prod)
,Soft_ini Si
WHERE (SCD.N_Prod > 0)
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */
GROUP BY SCD.N_Cde_Four, SCD.N_Prod, SCD.Ref, SCD.Designation, S.Qte_Stock, P.GestionStock


UNION


SELECT 
		SCD.N_Cde_Four, 
		SCD.N_Prod, 
		reference = SCD.Ref, 
		SCD.Designation, 
		Cde = SUM(SCD.Quantite), 
		livre = (SELECT SUM(Qte) FROM SS_BR WHERE (SCD.N_Cde_Four = SS_BR.n_cde_four) AND (isnull(SCD.Ref,'') = isnull(SS_BR.Ref_Produit,'')) AND (SCD.Designation = SS_BR.Designation)), 
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
FROM SCD_FOUR SCD
,Soft_ini Si
WHERE	(SCD.Quantite IS NOT NULL) AND 
		((SCD.N_Prod IS NULL) OR (SCD.N_Prod <= 0)) AND 
		--((SCD.Ref IS NOT NULL) AND (SCD.Ref <> '')) AND 
		((SCD.Designation IS NOT NULL) AND (SCD.Designation <> ''))
        /* s{App_LigneId Code=Where /} */
        AND (si.Achat_Suivi_Avec_LigneId = 'Non')
        /* s{/App_LigneId Code=Where /} */
GROUP BY SCD.N_Cde_Four, SCD.N_Prod, SCD.Ref, SCD.Designation


UNION ALL

/*                                                                  
================================================
 -> Les lignes avec un App_LigneId
================================================
*/

SELECT 
      SCD.N_Cde_Four
    , SCD.N_Prod
    , reference = SCD.Ref
    , SCD.Designation
    , Cde = SUM(SCD.Quantite)
    , livre = (SELECT 
                     SUM(Qte)
               FROM SS_BR
               WHERE (SCD.N_Cde_Four = SS_BR.n_cde_four) AND (App_LigneId = SCD.App_LigneId))
    , Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE NULL END)
    , GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock ELSE 'Non' END)
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
    , App_LigneId = scd.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM SCD_FOUR SCD
LEFT OUTER JOIN STOCK_PRODUIT S ON  (S.N_Depot = SCD.N_Depot) AND (S.N_Produit = SCD.N_Prod)
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = SCD.N_Prod)
    ,Soft_ini Si
WHERE (si.Achat_Suivi_Avec_LigneId = 'Oui')
GROUP BY SCD.N_Cde_Four
        ,SCD.N_Prod
        ,SCD.Ref
        ,SCD.Designation
        ,SCD.App_LigneId
        ,S.Qte_Stock
        ,P.GestionStock


