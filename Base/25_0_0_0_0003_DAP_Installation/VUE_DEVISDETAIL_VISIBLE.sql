ALTER VIEW [VUE_DEVISDETAIL_VISIBLE]
AS
SELECT 
	profondeur = 0
   ,N_DevisDetail = D.N_DevisDetail
   ,D.N_Position
   ,D.Description
   ,D.Ref
   ,D.N_Devis
   ,D.CodePoste
   ,CodePosteNonIndente = D.CodePoste
   ,CodePosteNonIndenteT = D.CodePoste
   ,Texte = D.Texte
   ,D.N_Rubrique
   ,D.Quantite
   ,D.Unite
   ,D.Prix_U_Franc
   ,D.Prix_U_Euro
   ,D.Prix_Total_Franc
   ,D.Prix_Total_Euro
   ,D.Prix_U_Vente_Franc
   ,D.Prix_U_Vente_Euro
   ,D.Prix_U_Vente_net_Franc
   ,D.Prix_U_Vente_net_Euro
   ,D.Coeff
   ,D.Remise
   ,D.Prix_Total_Vente_Franc
   ,D.Prix_Total_Vente_Euro
   ,D.Prix_Produit_Franc
   ,D.Prix_Produit_Euro
   ,D.Prix_MO_Franc
   ,D.Prix_MO_Euro
   ,Rubrique = A.Code_Secteur
   ,D.N_Produit
   ,D.N_Fct_Base
   ,D.n_LigneOrigine
   ,D.Libre1
   ,D.Tva
   ,D.StyleFonte
   ,D.ColorFond
   ,D.ColorTexte
   ,D.Fournisseur
   ,D.Prix_U_Base_Franc
   ,D.Prix_U_Base_Euro
   ,D.RemiseFourn
   ,D.Marque
   ,D.options
   ,D.Invisible
   ,D.Libre2
   ,D.Libre3
   ,D.Libre4
   ,D.numeric1
   ,D.numeric2
   ,D.numeric3
   ,D.numeric4
   ,D.date1
   ,D.date2
   ,D.check1
   ,D.check2
   ,D.genesys_lock
   ,D.CodePoste_Visible
   ,D.N_Dev_Arborescence
   ,D.Titre
FROM DEVISDETAIL_VISIBLE D
LEFT OUTER JOIN dbo.Activite A ON  D.N_Rubrique = A.N_Activites




