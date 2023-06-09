ALTER VIEW [VUE_PLANNING_A_PLANIFIER]
AS
--!JALE!06/10/2015! : Le lien entre le puit et le planifier se fait sur le n_planning_a_planifier
--!JALE!15/05/2014! : Ajout de colonnes
--!JALE!13/12/2012! : La ref dartparam  est planifié à partir du 1/9/2012
/* Cette vue correspond à la partie basse du planning "reste à planifier". Elle peut être modifier si nécessaire pour répondre 
à des besoins spécifiques. Il est nécessaire de garder le nom et l'ordre des colonnes */

/* j.alexandre : 16/03/2011                                                                   
================================================
 * On en lève du puits les dartdev,dartparam... car ils sont comptés automatiquement
 * en charge avec la facture client pour les fiches de marge
================================================
*/
SELECT
/*      0 = Normal au moins 30 jours avant, 1 =A planifier Entre 1 et 30 jours, 2 = En retard  */

STATUT = Case When ISNULL(affaire.champ2,'Non')='Oui' Then SPAP.statut Else Case when DATEDIFF(day, GetDate(), V.Date1) > 30 then 0 else Case when DATEDIFF(day, GetDate(), V.Date1) > 0 then 1  else 2 End  end End,  
Annee = 0, /*  Il y a un filtrage sur la condition suivant Annee=0 OR Année=Annee de visualisation du planning */  		   		
N_cle = v.N_PLANNING_A_PLANIFIER,    		/* Clé Primaire de la table d'origine*/
     
N_affaire = V.N_affaire,	   		/* Clé primaire de l'affaire */
Affaire = Affaire.Designation,	   		/* Nom de l'affaire affiché */	

N_itc = V.N_itc,						/* Clé Primaire de la personne */
Personne = Itc.Nom_commercial + ' ' + Isnull(Prenom,''),  	/* Nom de la personne affiché */

N_Rubrique = V.N_rubrique,			/* Clé Primaire de la rubrique */
Rubrique = Activite.Code_secteur,		/* Nom de la rubrique */

Poste = V.CodePoste,				/* Code Poste */

DateDebut = V.Date1,				/* Date de la programmation souhaitée */

Description = CASE WHEN ISNULL(td.N_TODO,0)>0 THEN td.Objet ELSE V.Designation END,


Total = isnull(V.Quantite,0) ,
Planifier = ISNULL(pl.Planifie,0),--isnull((Select sum(NbHeurePeriode) from Periode P where ACtivite.code_secteur=isnull(p.rubrique,'') AND V.N_affaire=P.N_affaire and isnull(P.facturable,'Non')=ISNULL(V.facturable,'Non') AND ISNULL(p.Poste,'')=ISNULL(v.CodePoste,'') ),0),
Reste = isnull(V.Quantite,0) -ISNULL(pl.Planifie,0),-- isnull((Select sum(NbHeurePeriode) from Periode P where ACtivite.code_secteur=isnull(p.rubrique,'') AND V.N_affaire=P.N_affaire and isnull(P.facturable,'Non')=ISNULL(V.facturable,'Non')),0)
texte = cast('' as varchar(255)),--cast(replace(Replace(dbo.RTFtoText(lc.Texte) ,CHAR(13),' / '),CHAR(10),'')AS varchar (255)),
Client=client.Nom_Client,
Prix_vente=dbo.MFPS_NumToStr(lc.Montant_Euro,2),
v.N_PLANNING_A_PLANIFIER,
v.Date2,
v.Facturable
FROM   PLANNING_A_PLANIFIER  V LEFT OUTER JOIN ITC ON  ITC.N_itc= V.N_itc
                         LEFT OUTER JOIN AFFAIRE on affaire.N_affaire = V.N_affaire
                         LEFT OUTER JOIN CLIENT ON Affaire.n_client = Client.n_client
                         LEFT OUTER JOIN Activite on V.n_rubrique = Activite.n_activites
						 LEFT OUTER JOIN MFPS_VUE_PLANNING_STATUT_A_PLANIFIER_INTERNES SPAP ON Affaire.Champ3=SPAP.Text
						 LEFT OUTER JOIN LIGNECLI lc ON v.n_LigneOrigine=lc.N_LigneCli
						 LEFT OUTER JOIN PRODUIT p ON ISNULL(v.N_Produit,0)=p.N_Produit
						 LEFT OUTER JOIN TODO td ON ISNULL(td.MFPS_N_devisDetail,0)=ISNULL(lc.n_ligne_devis,0) AND td.TypeFiche=126
--LEFT OUTER JOIN(
--SELECT
--	N_affaire=ISNULL(p.N_affaire,0)
--	,Rubrique=isnull(p.rubrique,'')
--	--,facturable=isnull(P.facturable,'Non')
--	,Poste=ISNULL(p.Poste,'')
--	,Planifie= sum(ISNULL(NbHeurePeriode,0))
--FROM Periode P 
--GROUP BY ISNULL(p.N_affaire,0),isnull(p.rubrique,''),/* isnull(P.facturable,'Non'), */ISNULL(p.Poste,'')
--) AS PL ON PL.N_affaire=V.N_Affaire AND pl.Rubrique=ISNULL(activite.Code_Secteur,'') /* AND pl.facturable=ISNULL(v.Facturable,'Non') */ AND pl.Poste=ISNULL(v.CodePoste,'')

LEFT OUTER JOIN(
SELECT
	n_planning_a_planifier=ISNULL(p.n_planning_a_planifier,0)
	,Planifie= sum(ISNULL(NbHeurePeriode,0))
FROM Periode P 
GROUP BY ISNULL(p.n_planning_a_planifier,0)
) AS PL ON pl.n_planning_a_planifier = ISNULL(v.N_PLANNING_A_PLANIFIER,0)



WHERE  ((isnull(V.Quantite,0)-ISNULL(pl.Planifie,0) >0) or  ISNULL(affaire.champ2,'Non')='Oui')
AND affaire.Solder='Non'
AND (
(ISNULL(p.Ref_Constructeur,'') NOT IN ('DARTDEV','DARTPARAM','PARCDEV','DARTINTCPTA') AND v.Date1<'1/9/2012')
OR
(ISNULL(p.Ref_Constructeur,'') NOT IN ('DARTDEV','PARCDEV','DARTINTCPTA') AND v.Date1>='1/9/2012')
)



UNION ALL

SELECT 
      STATUT = CAST(2 AS INT)
    , Annee = CAST(YEAR(GETDATE()) AS INT)
    , N_cle = t.[N_PLANNING_A_PLANIFIER]
    , N_affaire = CAST(0 AS INT)
    , Affaire = CAST('' AS VARCHAR(50))
    , N_itc = CAST(0 AS INT)
    , Personne = CAST('' AS VARCHAR(101))
    , N_Rubrique = CAST(act.[N_Activites] AS INT)
    , Rubrique = CAST(act.[Code_Secteur] AS VARCHAR(5))
    , Poste = CAST(t.[CodePoste] AS VARCHAR(50))
    , DateDebut = CAST('' AS DATETIME)
    , DESCRIPTION = CAST(act.[Code_Secteur] + ' ' + ISNULL(t.[Designation],'') AS VARCHAR(100))
    , Total = CAST(t.[Quantite] AS NUMERIC(18 ,10))
    , Planifier = CAST(0 AS NUMERIC(38 ,10))
    , Reste = CAST(t.[Quantite] AS NUMERIC(38 ,10))
    , texte = CAST(t.[Designation] AS VARCHAR(255))
    , Client = CAST('' AS VARCHAR(50))
    , Prix_vente = CAST('' AS VARCHAR(50))
    , N_PLANNING_A_PLANIFIER = CAST(t.[N_PLANNING_A_PLANIFIER] AS INT)
    , Date2 = CAST('' AS DATETIME)
    , Facturable = CAST('Non' AS VARCHAR(3))
FROM [dbo].[PLANNING_A_PLANIFIER] T  
LEFT OUTER JOIN [dbo].[Activite] act ON t.[N_Rubrique] =act.[N_Activites]
WHERE t.[Egxs_Template] = 1 




