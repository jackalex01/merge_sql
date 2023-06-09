CREATE  VIEW [dbo].[VUE_PLANNING_A_PLANIFIER_VERS_PERIODE]
AS
SELECT     

	N_PLANNING_A_PLANIFIER,
	PLANNING_A_PLANIFIER.N_Affaire,
	N_Cde_Cli   Reference, 
	PLANNING_A_PLANIFIER.Designation,  
	Quantite,    
	N_Rubrique,  
	N_Produit,
	PLANNING_A_PLANIFIER.N_Equipement, 
	N_Fct_Base , 
	N_Position,           
	Unite,
	Texte = PLANNING_A_PLANIFIER.Designation, --Texte, 
	PLANNING_A_PLANIFIER.n_devis,     
	CodePoste, 
	Libre1,
	n_LigneOrigine ,
	PLANNING_A_PLANIFIER.StyleFonte,  
	PLANNING_A_PLANIFIER.ColorFond,   
	PLANNING_A_PLANIFIER.ColorTexte,  
	Date1,
	Date2, 
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

GO
