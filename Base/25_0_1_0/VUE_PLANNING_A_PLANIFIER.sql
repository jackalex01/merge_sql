ALTER VIEW [VUE_PLANNING_A_PLANIFIER]
AS

/* Cette vue correspond à la partie basse du planning "reste à planifier". Elle peut être modifier si nécessaire pour répondre 
à des besoins spécifiques. Il est nécessaire de garder le nom et l'ordre des colonnes */

SELECT
/*      0 = Normal au moins 30 jours avant, 1 =A planifier Entre 1 et 30 jours, 2 = En retard  */

STATUT = Case when DATEDIFF(day, GetDate(), Date1) > 30 then 0 else Case when DATEDIFF(day, GetDate(), Date1) > 0 then 1  else 2 End  end,  
Annee = 0, /*  Il y a un filtrage sur la condition suivant Annee=0 OR Année=Annee de visualisation du planning */  		   		
N_cle = N_PLANNING_A_PLANIFIER,    		/* Clé Primaire de la table d'origine*/
     
N_affaire = V.N_affaire,	   		/* Clé primaire de l'affaire */
Affaire = Affaire.Designation,	   		/* Nom de l'affaire affiché */	

N_itc = V.N_itc,						/* Clé Primaire de la personne */
Personne = Itc.Nom_commercial + ' ' + Isnull(Prenom,''),  	/* Nom de la personne affiché */

N_Rubrique = V.N_rubrique,			/* Clé Primaire de la rubrique */
Rubrique = Activite.Code_secteur,		/* Nom de la rubrique */

Poste = V.CodePoste,				/* Code Poste */

DateDebut = Date1,				/* Date de la programmation souhaitée */

Description = V.Designation,


Total = isnull(V.Quantite,0) ,
Planifier = isnull((Select sum(NbHeurePeriode) from Periode P where V.N_PLANNING_A_PLANIFIER=P.N_PLANNING_A_PLANIFIER),0),
Reste = isnull(V.Quantite,0) - isnull((Select sum(NbHeurePeriode) from Periode P where V.N_PLANNING_A_PLANIFIER=P.N_PLANNING_A_PLANIFIER),0)

FROM   PLANNING_A_PLANIFIER  V LEFT OUTER JOIN ITC ON  ITC.N_itc= V.N_itc
                         LEFT OUTER JOIN AFFAIRE on affaire.N_affaire = V.N_affaire
                         LEFT OUTER JOIN CLIENT ON Affaire.n_client = Client.n_client
                         LEFT OUTER JOIN Activite on V.n_rubrique = Activite.n_activites


WHERE  isnull(V.Quantite,0) - isnull((Select sum(NbHeurePeriode) from Periode P where V.N_PLANNING_A_PLANIFIER=P.N_PLANNING_A_PLANIFIER),0) >0




   







