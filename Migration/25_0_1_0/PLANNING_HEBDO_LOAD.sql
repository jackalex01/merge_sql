CREATE PROCEDURE [dbo].[PLANNING_HEBDO_LOAD]

@DateDebut DateTime,
@DateFin DateTime,
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


SET DateFirst 1

SELECT
_Typ = 0,
Tri = 2,
Num_jour_deb = Case When  datedeb < @datedebut  then 1 else  DATEPART (dw,Datedeb) end,
num_jour_Fin = DATEPART (dw,Datefin),
Nb_jour = DateDiff(Day,(case when datedeb < @datedebut  then @datedebut else datedeb end),DateFin),

N_ITC_PERSONNE = ITC.N_ITC,
Couleur = Periode.couleur,
Texte =Periode.commentaire  ,
Commentaire = Periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  = Itc.nom_commercial +' '+ isnull(Itc.Prenom,'')  /*+ ' '+cast(Itc.n_itc as varchar(10) ) */,

Periode.*,
ITC.N_Depot,
ITC.N_Service,
AFFAIRE.N_Famille_Affaire,
N_PRODUIT_ARTICLE = NULL,
Nom_Produit = NULL,
N_EQUIPEMENT_ARTICLE = null,
Nom_Equipement = null



FROM ITC 
		LEFT OUTER JOIN PERIODE ON ITC.N_ITC = Periode.n_ITC and  ( ( datedeb between @datedebut and @datefin) or (Datedeb<@DateDebut and Datefin>=@DateDebut) ) and Periode.N_itc<>0
		 LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire


WHERE ITC.ACTIF='Oui' and Itc.parent>0
 And ((@N_depot = 0) OR ((@N_Depot > 0) and (Itc.n_depot = @N_depot)))
And ((@N_Service = 0) OR ((@N_Service > 0) and (Itc.N_Service = @N_Service)))
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))



UNION ALL


SELECT
_Typ = 1,
Tr = 2,
Num_jour_deb = Case When  datedeb < @datedebut  then 1 else  DATEPART (dw,Datedeb) end,
num_jour_Fin = DATEPART (dw,Datefin),
Nb_jour = DateDiff(Day,(case when datedeb < @datedebut  then @datedebut else datedeb end),DateFin),

N_ITC_PERSONNE = 0,
Couleur = periode.Couleur,
Texte = periode.commentaire,
Commentaire = periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  = '',

Periode.*,
NULL,
NULL,
affaire.N_Famille_Affaire,
N_PRODUIT_ARTICLE = PRODUIT.N_PRODUIT,
Nom_Produit = PRODUIT.NOM_PRODUIT,
N_EQUIPEMENT_ARTICLE = null,
Nom_Equipement = null


FROM PRODUIT 
		LEFT OUTER JOIN PERIODE ON PRODUIT.N_PRODUIT = Periode.n_PRODUIT and  (( datedeb between @datedebut and @datefin) or (Datedeb<@DateDebut and Datefin>=@DateDebut)) 	and Periode.N_PRODUIT <>0	
		LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
WHERE Produit.parent > 0
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))	


UNION ALL


SELECT
_Typ = 2,
Tr = 2,
Num_jour_deb = Case When  datedeb < @datedebut  then 1 else  DATEPART (dw,Datedeb) end,
num_jour_Fin = DATEPART (dw,Datefin),
Nb_jour = DateDiff(Day,(case when datedeb < @datedebut  then @datedebut else datedeb end),DateFin),

N_ITC_PERSONNE = 0,
Couleur = periode.Couleur,
Texte = periode.commentaire,
Commentaire = periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  = '',

Periode.*,
NULL,
NULL,
affaire.N_Famille_Affaire,
N_PRODUIT_ARTICLE = null,
Nom_Produit = null,
N_EQUIPEMENT_ARTICLE = TB_EQP_EQUIPEMENT.N_EQUIPEMENT,
Nom_Equipement = TB_EQP_EQUIPEMENT.NOM_EQUIPEMENT


FROM TB_EQP_EQUIPEMENT 
		LEFT OUTER JOIN PERIODE ON TB_EQP_EQUIPEMENT.N_EQUIPEMENT = Periode.N_EQUIPEMENT and  (( datedeb between @datedebut and @datefin) or (Datedeb<@DateDebut and Datefin>=@DateDebut)) 	and Periode.N_EQUIPEMENT <>0	
		LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
WHERE TB_EQP_EQUIPEMENT.parent > 0
And ((@N_Famille_affaire = 0) OR ((@N_Famille_affaire > 0) and (Affaire.N_Famille_Affaire = @N_Famille_affaire)))	


ORDER BY _Typ, NOM_PERSONNE, Nom_Produit, Nom_Equipement

GO
