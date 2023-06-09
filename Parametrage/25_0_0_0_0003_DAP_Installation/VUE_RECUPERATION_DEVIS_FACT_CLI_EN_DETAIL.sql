ALTER VIEW [VUE_RECUPERATION_DEVIS_FACT_CLI_EN_DETAIL]
AS

SELECT 
	N_Devis = T.N_Devis
   ,TYPE = 5
   ,N_Position = ROW_NUMBER() OVER (ORDER BY t.CodePoste, t.N_Position ) * 100
   ,N_Ligne_Devis = T.N_DevisDetail
   ,CodePoste = T.CodePoste
   ,N_Produit = T.N_Produit
   ,N_Fct_Base = T.N_Fct_Base
   ,Code_Secteur = act.Code_Secteur
   ,N_Activites = act.N_Activites
   ,Secteur = act.Secteur
   ,Manuel = act.Manuel
   ,Remise = t.Remise
   ,PU_Franc = T.Prix_U_Vente_Franc
   ,PU_Euro = T.Prix_U_Vente_Euro
   ,Total_Franc = T.Prix_Total_Vente_Franc
   ,Total_Euro = T.Prix_Total_Vente_Euro
   ,Designation = left(T.Description,50)
   ,Texte = T.Texte
   ,DesignationFct = left(T.Description,50)
   ,Quantite = T.Quantite
   ,QuantiteFct = T.Quantite
   ,Ref_Produit = T.Ref
   ,Unite = T.Unite
   ,Libre1 = T.Libre1
   ,Tva = T.Tva
   ,numeric1 = T.numeric1
   ,numeric2 = T.numeric2
   ,date1 = T.date1
   ,date2 = T.date2
   ,check1 = T.check1
   ,check2 = T.check2
   ,genesys_lock = T.genesys_lock
   ,Libre2 = T.Libre2
   ,Libre3 = T.Libre3
   ,Libre4 = T.Libre4
   ,numeric3 = T.numeric3
   ,numeric4 = T.numeric4
   ,CodePoste_Visible = T.CodePoste_Visible
   ,N_Dev_Arborescence_Origine = T.N_Dev_Arborescence
   ,Titre = T.Titre
   ,StyleFonte = CASE WHEN ISNULL(t.Titre,0)<>0 THEN mef.StyleFonte ELSE DD.StyleFonte END 
   ,ColorFond = CASE WHEN ISNULL(t.Titre,0)<>0 THEN mef.ColorFond ELSE DD.ColorFond END 
   ,ColorTexte = CASE WHEN ISNULL(t.Titre,0)<>0 THEN mef.ColorTexte ELSE DD.ColorTexte END 
    /* s{App_LigneId Code=Select /} */
    ,TypeFiche_Precedent = 123
    ,N_Fiche_Precedent = t.N_Devis
    ,N_Detail_Precedent = t.N_DevisDetail
    ,App_LigneId_Origine = dd.App_LigneId
     /* s{/App_LigneId Code=Select /} */
FROM VUE_DEV_DEVISDETAIL_VISIBLE T
LEFT OUTER JOIN DEVISDETAIL DD ON T.N_DevisDetail = DD.N_DevisDetail 
LEFT OUTER JOIN DEVIS d ON  d.N_Devis = T.N_Devis
LEFT OUTER JOIN Activite act ON  ISNULL(t.N_Rubrique,0) = act.N_Activites
LEFT OUTER JOIN TB_DEV_ARBORESCENCE tda ON  ISNULL(t.N_Dev_Arborescence,0) = tda.N_Dev_Arborescence
LEFT OUTER JOIN VUE_DEV_ARBORESCENCE_MISE_EN_FORME mef ON  mef.Niveau = tda.Niveau
WHERE  (ISNULL(T.Options,0) = 0)


