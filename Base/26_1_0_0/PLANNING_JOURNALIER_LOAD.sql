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
Nom_Personne  = Itc.nom_commercial +' '+ isnull(Itc.Prenom,'')  /*+ ' '+cast(Itc.n_itc as varchar(10) ) */,
CouleurTrack = 0,  -- Si 0 = couleur par défaut sinon mettre la valeur de la couleur désirée
Periode.*,
ITC.N_Depot,
ITC.N_Service,
AFFAIRE.N_Famille_Affaire



FROM ITC 
		LEFT OUTER JOIN PERIODE ON ITC.N_ITC = Periode.n_ITC and   @DateJour between DateDeb and DateFin and Periode.N_itc<>0
		 LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
 
WHERE ITC.Actif = 'Oui' AND ITC.Parent > 0
 And ((@N_depot = 0) OR ((@N_Depot > 0) and (Itc.n_depot = @N_depot)))
And ((@N_Service = 0) OR ((@N_Service > 0) and (Itc.N_Service = @N_Service)))
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))
Order by Nom_Personne, heuredeb
