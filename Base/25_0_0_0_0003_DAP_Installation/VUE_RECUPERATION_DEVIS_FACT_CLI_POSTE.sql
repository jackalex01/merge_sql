ALTER VIEW [VUE_RECUPERATION_DEVIS_FACT_CLI_POSTE]
AS

SELECT
Type = 0,
n_Ligne_Devis = 0,
D.N_Position, 
Designation=D.Description, D.Ref,
D.N_Devis, D.CodePoste,
D.Texte,
D.Quantite, D.Unite,
PU_Franc=D.Prix_U_Vente_Franc, 
PU_Euro=D.Prix_U_Vente_Euro,
D.Remise,
Total_Franc=D.Prix_Total_Vente_Franc, 
Total_Euro=D.Prix_Total_Vente_Euro,
Code_Secteur='',
D.N_Produit,
D.N_Fct_Base, D.n_LigneOrigine, D.Libre1, D.Tva,
D.Marque
FROM DEVISDETAIL_TOTAUX D
WHERE ISNULL( D.Invisible, 'Non' ) = 'Non' AND ISNULL( D.Options, 0 ) = 0



