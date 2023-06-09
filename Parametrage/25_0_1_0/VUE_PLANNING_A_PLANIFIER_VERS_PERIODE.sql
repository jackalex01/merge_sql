ALTER VIEW [VUE_PLANNING_A_PLANIFIER_VERS_PERIODE]
AS
SELECT     
	N_PLANNING_A_PLANIFIER,
	PLANNING_A_PLANIFIER.N_Affaire,
	N_Cde_Cli   Reference, 
	PLANNING_A_PLANIFIER.Designation,  
	Quantite= CASE WHEN Egxs_Template = 1 THEN Quantite ELSE  [dbo].[MFPS_FCT_Planning_QUANTITE]( CASE WHEN  ISNULL(affaire.champ2,'Non')='Oui' then convert(varchar(20),getdate(),103) Else Date1 END,N_PLANNING_A_PLANIFIER,Quantite) END,
	N_Rubrique,  
	N_Produit, 
	N_Fct_Base , 
	N_Position,           
	Unite,
	Texte=PLANNING_A_PLANIFIER.Designation, 
	PLANNING_A_PLANIFIER.n_devis,     
	CodePoste, 
	Libre1,
	n_LigneOrigine ,
	PLANNING_A_PLANIFIER.StyleFonte,  
	ColorFond=activite.[color],   
	PLANNING_A_PLANIFIER.ColorTexte,  
	Date1=CASE WHEN  ISNULL(affaire.champ2,'Non')='Oui' then convert(varchar(20),getdate(),103) Else Date1 END,
	Date2=dbo.[MFPS_FCT_Planning_Date2]( CASE WHEN  ISNULL(affaire.champ2,'Non')='Oui' then convert(varchar(20),getdate(),103) Else Date1 END,N_PLANNING_A_PLANIFIER,Quantite),
	N_User_Create, 
	Statut,      
	PLANNING_A_PLANIFIER.N_ITC,       
	Facturable,
	Code_Secteur ,
	Personne=Nom_commercial,
	Affaire =affaire. Designation
FROM         dbo.PLANNING_A_PLANIFIER 
              LEFT OUTER JOIN ACTIVITE ON PLANNING_A_PLANIFIER.N_rubrique = ACTIVITE.N_Activites
	LEFT OUTER JOIN ITC ON ITC.N_ITC = PLANNING_A_PLANIFIER.N_itc
	LEFT OUTER JOIN AFFAIRE ON AFFAIRE.N_affaire = PLANNING_A_PLANIFIER.N_affaire

