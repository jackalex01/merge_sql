ALTER VIEW [VUE_RECAP_LIVRAISON_CDE_FOUR]
AS
SELECT SCD.N_Cde_Four, SCD.N_Prod, reference = SCD.Ref, 
    SCD.Designation, Cde = SUM(SCD.Quantite), livre =
        (SELECT SUM(Qte)
      FROM SS_BR
      WHERE (SCD.N_Cde_Four = SS_BR.n_cde_four) AND 
           (N_Produit = SCD.N_Prod)), 
    Dispo = (CASE WHEN P.GestionStock = 'Oui' THEN S.Qte_Stock ELSE
     NULL END), 
    GestionStock = (CASE WHEN P.GestionStock = 'Oui' THEN P.GestionStock
     ELSE 'Non' END)
FROM SCD_FOUR SCD LEFT OUTER JOIN
    STOCK_PRODUIT S ON (S.N_Depot = SCD.N_Depot) AND 
    (S.N_Produit = SCD.N_Prod) LEFT OUTER JOIN
    PRODUIT P ON (P.N_Produit = SCD.N_Prod)
WHERE (SCD.N_Prod > 0)
GROUP BY SCD.N_Cde_Four, SCD.N_Prod, SCD.Ref, 
    SCD.Designation, S.Qte_Stock, P.GestionStock
UNION
SELECT SCD.N_Cde_Four, SCD.N_Prod, reference = SCD.Ref, 
    SCD.Designation, Cde = SUM(SCD.Quantite), livre =
        (SELECT SUM(Qte)
      FROM SS_BR
      WHERE (SCD.N_Cde_Four = SS_BR.n_cde_four) AND 
           (SCD.Ref = SS_BR.Ref_Produit) AND 
           (SCD.Designation = SS_BR.Designation)), 
    Dispo = NULL, GestionStock = 'Non'
FROM SCD_FOUR SCD
WHERE (SCD.Quantite IS NOT NULL) AND 
    ((SCD.N_Prod IS NULL) OR
    (SCD.N_Prod <= 0)) AND ((SCD.Ref IS NOT NULL) AND 
    (SCD.Ref <> '')) AND ((SCD.Designation IS NOT NULL) AND 
    (SCD.Designation <> ''))
GROUP BY SCD.N_Cde_Four, SCD.N_Prod, SCD.Ref, 
    SCD.Designation

