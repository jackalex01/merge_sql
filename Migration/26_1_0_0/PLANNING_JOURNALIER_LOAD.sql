ALTER PROCEDURE [dbo].[PLANNING_JOURNALIER_LOAD] 

@DateJour datetime,
@N_user int,
@N_service int,
@N_depot int,
@N_Famille_affaire int

AS

/*
SELECT

Couleur = Periode.couleur,
Texte =Periode.commentaire  ,
Commentaire = Periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  = Itc.nom_commercial + isnull(Itc.Prenom,''),

Periode.*



FROM PERIODE LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
		LEFT OUTER JOIN ITC ON ITC.N_ITC = Periode.n_ITC
WHERE    @DateJour between DateDeb and DateFin 

Order by Nom_Personne, heuredeb*/


SELECT
	_Typ = 0,
	N_ITC_PERSONNE = ITC.N_ITC,
	Couleur = Periode.couleur,
	Texte =Periode.commentaire  ,
	Commentaire = Periode.commentaire,
	Solder = Affaire.solder,
	Nom_Personne  = Itc.nom_commercial +' '+ isnull(Itc.Prenom,'')  /*+ ' '+cast(Itc.n_itc as varchar(10) ) */,
	CouleurTrack = 0,  -- Si 0 = couleur par défaut sinon mettre la valeur de la couleur désirée
	Periode.*,
	ITC.N_Depot,
	ITC.N_Service,
	AFFAIRE.N_Famille_Affaire,
	N_PRODUIT_ARTICLE = NULL,
	n_produit_ =NULL,
	Nom_Produit = '',
	N_EQUIPEMENT_ARTICLE = NULL,
	Nom_Equipement = NULL

FROM ITC 
		LEFT OUTER JOIN PERIODE ON ITC.N_ITC = Periode.n_ITC and   @DateJour between DateDeb and DateFin and Periode.N_itc<>0
		 LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
 
WHERE ITC.Actif = 'Oui' AND ITC.Parent > 0
 And ((@N_depot = 0) OR ((@N_Depot > 0) and (Itc.n_depot = @N_depot)))
And ((@N_Service = 0) OR ((@N_Service > 0) and (Itc.N_Service = @N_Service)))
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))

UNION ALL

SELECT
	_Typ = 1,
	N_ITC_PERSONNE = NULL,
	Couleur = periode.Couleur,
	Texte = periode.commentaire,
	Commentaire = Periode.commentaire,
	Solder = Affaire.solder,
	Nom_Personne  = NULL,
	CouleurTrack = 0,  -- Si 0 = couleur par défaut sinon mettre la valeur de la couleur désirée
	Periode.*,
	NULL,
	NULL,
	AFFAIRE.N_Famille_Affaire,
	N_PRODUIT_ARTICLE = PRODUIT.N_PRODUIT,
	n_produit_ = PRODUIT.N_PRODUIT,
	NOM_PRODUIT = PRODUIT.NOM_PRODUIT,
	N_EQUIPEMENT_ARTICLE = NULL,
	Nom_Equipement = NULL


FROM PRODUIT 
		LEFT OUTER JOIN PERIODE ON PRODUIT.N_PRODUIT = Periode.n_PRODUIT and   @DateJour between DateDeb and DateFin and Periode.N_itc<>0
		LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
WHERE Produit.parent > 0
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))	

UNION ALL

SELECT
	_Typ = 1,
	N_ITC_PERSONNE = NULL,
	Couleur = periode.Couleur,
	Texte = periode.commentaire,
	Commentaire = Periode.commentaire,
	Solder = Affaire.solder,
	Nom_Personne  = NULL,
	CouleurTrack = 0,  -- Si 0 = couleur par défaut sinon mettre la valeur de la couleur désirée
	Periode.*,
	NULL,
	NULL,
	AFFAIRE.N_Famille_Affaire,
	N_PRODUIT_ARTICLE = NULL,
	n_produit_ = NULL,
	NOM_PRODUIT = NULL,
	N_EQUIPEMENT_ARTICLE = TB_EQP_EQUIPEMENT.N_EQUIPEMENT,
	Nom_Equipement = TB_EQP_EQUIPEMENT.NOM_EQUIPEMENT 

FROM TB_EQP_EQUIPEMENT 
		LEFT OUTER JOIN PERIODE ON TB_EQP_EQUIPEMENT.N_EQUIPEMENT = Periode.N_EQUIPEMENT and @DateJour between DateDeb and DateFin and Periode.N_itc<>0	and Periode.N_EQUIPEMENT <>0	
		LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
WHERE TB_EQP_EQUIPEMENT.parent > 0
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))


ORDER BY _Typ, NOM_PERSONNE, Nom_Produit, Nom_Equipement

GO
