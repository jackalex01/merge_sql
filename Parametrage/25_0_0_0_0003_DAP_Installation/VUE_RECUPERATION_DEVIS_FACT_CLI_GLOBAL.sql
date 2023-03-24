ALTER VIEW [VUE_RECUPERATION_DEVIS_FACT_CLI_GLOBAL]
AS

SELECT
Type = 0,
DEV.N_Devis,
CodePoste='',
N_Produit = 0,
N_Fct_Base=0,
N_Activites= CAST( NULL as integer ),
Remise=CAST( NULL AS numeric(18,10) ),
PU_Franc=( DEV.Total_Vente_Franc ),
PU_Euro=( DEV.Total_Vente_Euro ),
Total_Franc=( DEV.Total_Vente_Franc ),
Total_Euro=( DEV.Total_Vente_Euro ),
Designation=DEV.Nom_Devis, 
Texte = DEV.Commentaire,
DesignationFct=NULL,
Quantite=1.0,
Ref_Produit='',
Unite='',
Libre1='',
Tva=DEV.Tva_Active
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM Devis DEV








