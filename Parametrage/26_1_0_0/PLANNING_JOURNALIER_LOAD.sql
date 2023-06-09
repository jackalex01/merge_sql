ALTER PROCEDURE [PLANNING_JOURNALIER_LOAD] 

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

N_ITC_PERSONNE = ITC.N_ITC,
Couleur = Periode.couleur,
Texte =Periode.commentaire  ,
Commentaire = Periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  = ITC.Initial_commercial   /*+ ' '+cast(Itc.n_itc as varchar(10) ) */,

Periode.*,
itc.*



FROM ITC 
		LEFT OUTER JOIN PERIODE ON ITC.N_ITC = Periode.n_ITC and   @DateJour between DateDeb and DateFin and Periode.N_itc<>0
		 LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
WHERE ITC.ACTIF='Oui' and Itc.parent>0 and ISNULL(ITC.Champ1,'Non')='Oui' 

Order by ISNULL(Cast(ITC.Champ2 as int),0),Nom_Personne, heuredeb

