ALTER VIEW [VUE_RECUPERATION_DEVIS_CDE_CLI_GLOBAL]
AS

SELECT
Type = 0,
DEV.N_Devis,
N_Ligne_Devis=0,
CodePoste='',
N_Produit = 0,
N_Fct_Base=0,
Code_Secteur='',
Remise=CAST( NULL AS numeric(18,10) ),
PU_Franc=( DEV.Total_Vente_Franc ),
PU_Euro=( DEV.Total_Vente_Euro ),
Total_Franc=( DEV.Total_Vente_Franc ),
Total_Euro=( DEV.Total_Vente_Euro ),
Designation=DEV.Nom_Devis, 
Texte = DEV.Commentaire,
DesignationFct=NULL,
Quantite=1.0,
Ref='',
Unite='',
Libre1='',
Tva=DEV.Tva_Active
FROM Devis DEV


