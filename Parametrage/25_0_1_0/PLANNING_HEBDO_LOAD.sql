ALTER PROCEDURE [PLANNING_HEBDO_LOAD]

@DateDebut DateTime,
@DateFin DateTime,
@N_user int,
@N_service int,
@N_depot int,
@N_Famille_affaire int

AS


--!JALE!12/05/2016! : Ajout du filtres des periodes non valideées
--!JALE!04/10/2013! : Gestion de l'ecotaxe dans la couleur du track (Facturation et validation)
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
DECLARE
@MFPS_Service_Code INT,
@Code_Famille_affaire varchar (20),
@Periode_NonVal varchar (3)

DECLARE 
    @TB_CP_RTT TABLE (N_Itc INT, Compteur varchar (100))

INSERT INTO @TB_CP_RTT
(
    N_Itc
    ,Compteur
)
SELECT 
    i.N_ITC
    ,Compteur =  dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(i.N_itc,'ARTT',0,5,'')) +' | '+dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(i.N_itc,'ARTTF',0,5,''))--+''/*+ ' '+cast(Itc.n_itc as varchar(10) ) 
FROM Itc i
WHERE i.ACTIF = 'Oui' 
AND i.parent > 0 
AND ISNULL(i.Champ1,'Non') = 'Oui' 

SET @MFPS_Service_Code=ISNULL((SELECT MFPS_Service_Code FROM Service where N_service=@N_service),0)

SELECT 
	@Code_Famille_affaire= fa.Code_Famille
FROM famille_affaire fa
WHERE fa.N_Famille_Affaire=@N_Famille_affaire

IF ISNULL(@Code_Famille_affaire,'')='NON_VAL'
BEGIN
	SET @Periode_NonVal = 'Oui'
END
ELSE
BEGIN
	SET @Periode_NonVal='Non'
END

/*                                                                  
================================================
 -> Récupération des 
================================================
*/

SET DateFirst 1

SELECT
 --texte= CASE WHEN CHARINDEX( CHAR(10),t.texte,1) < 80 AND CHARINDEX( CHAR(10),t.texte,1)>0 AND CHARINDEX( CHAR(13),t.texte,1)>0 THEN 
 --	SUBSTRING(t.TEXTe,1,CHARINDEX( CHAR(13),t.texte,1)-1)+ REPLICATE(' ',70) +  SUBSTRING(t.TEXTe,CHARINDEX(CHAR(13), t.texte,1),8000)
	
 --	ELSE t.texte END,
 t.*


FROM 
(

SELECT
Num_jour_deb = Case When  datedeb < @datedebut  then 1 else  DATEPART (dw,Datedeb) end,
num_jour_Fin = DATEPART (dw,Periode.Datefin),
Nb_jour = DateDiff(Day,(case when datedeb < @datedebut  then @datedebut else datedeb end),Periode.DateFin),
N_ITC_PERSONNE = ITC.N_ITC,
Couleur = Periode.couleur,
Texte = --CAST(NULL as VARCHAR(8000)),
REPLACE(Cast(ISNULL(Periode.categorie,'')+' '+ 

		CASE WHEN 
			ISNULL(periode.N_affaire,0)<>102 AND ISNULL(periode.rubrique,'')<>'DEMO'
		THEN
			CASE WHEN
				ISNULL(RUBRIQUE,'')<>'VIS' AND Not ISNULL(RUBRIQUE,'')like 'DIV%' AND Not ISNULL(RUBRIQUE,'')='VISD'
			THEN 
				CASE WHEN 
					affaire.N_affaire<> 38 
				THEN 
					LEFT(ISNULL(C.Code_postal,'XX'),2)+ ' ' + ISNULL(C.Nom_client,'Nom Client') +Char(13)+Char(10)+ISNULL(Affaire.designation,'')+Char(13)+Char(10)+ ISNULL(Cast(Periode.commentaire as varchar(8000)),'') 
				ELSE 
					Rubrique 
				END 
			ELSE 
				ISNULL(Cast(Periode.commentaire as varchar(8000)),'') 
			END 
		ELSE
			CASE WHEN 
				ISNULL((SELECT champ5 from users where N_user=@N_user),'Non')='Oui' 
			THEN
			
				ISNULL(periode.champ2,'') + ' ' + ISNULL(periode.champ4,'') + CHAR(13)+CHAR(10)+ cast(ISNULL(periode.commentaire,'')  AS varchar(8000))
			
			ELSE
			
			    ISNULL(periode.RUBRIQUE,'') + ' dans le ' + ISNULL(periode.champ2,'')  + CHAR(13)+CHAR(10)+ cast(ISNULL(periode.commentaire,'')  AS varchar(8000))  

			END
		END

	as varchar(8000)),'''','''''')

 ,
Commentaire = Periode.commentaire,
Solder = Affaire.solder,
Nom_Personne  =ITC.Initial_commercial+REPLICATE(' ',4-LEN(ITC.Initial_commercial))+ ' ' + ISNULL(cr.Compteur,''),-- ' ' + cp.RTT +' | '+cp.RTTF ,--+dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(ITC.N_itc,'ARTT',0,5,'')) +' | '+dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(ITC.N_itc,'ARTTF',0,5,''))+''/*+ ' '+cast(Itc.n_itc as varchar(10) ) */,

	N_Periode = Periode.N_Periode
	--,N_itc = Periode.N_itc
	,N_affaire = Periode.N_affaire
	,n_produit = Periode.n_produit
	,typ = Periode.typ
	,Ordre = Periode.Ordre
	,datedeb = Periode.datedeb
	,DateFin = Periode.DateFin
	,Rubrique = Periode.Rubrique
	--,Couleur = Periode.Couleur
	--,commentaire = Periode.commentaire
	,NbHeurePeriode = Periode.NbHeurePeriode
	,HeureFixe = Periode.HeureFixe
	,HeureParJour = Periode.HeureParJour
	,ValeurHeureFixe = Periode.ValeurHeureFixe
	,OrdreItc = Periode.OrdreItc
	,OrdreProduit = Periode.OrdreProduit
	--,Poste = Periode.Poste
	,Valider = Periode.Valider
	,HeureDeb = Periode.HeureDeb
	,HeureFin = Periode.HeureFin
	,Facturable = Periode.Facturable
	,Facture = Periode.Facture
	,Cout = Periode.Cout
	,N_PLANNING_A_PLANIFIER = Periode.N_PLANNING_A_PLANIFIER
	,Categorie = Periode.Categorie
	,N_userCreate = Periode.N_userCreate
	,DateCreate = Periode.DateCreate
	,N_userModif = Periode.N_userModif
	,DateModif = Periode.DateModif
	,N_Groupe = Periode.N_Groupe
	,MFP_GEST_REPOS_N_TODO = Periode.MFP_GEST_REPOS_N_TODO
	,MFPS_DEMO_N_TODO = Periode.MFPS_DEMO_N_TODO
	,MFPS_INSTH_N_TODO = Periode.N_Todo
	,N_Multi = Periode.N_Multi
	,MFPS_Commentaire = Periode.MFPS_Commentaire
	,N_Demande_Conge = Periode.N_Demande_Conge,
 N_ITC = itc.N_ITC,
 Nom_commercial = itc.Nom_commercial,
 Initial_commercial = itc.Initial_commercial,
 Parent = itc.Parent,
 Titre = itc.Titre,
 Prenom = itc.Prenom,
 Adresse1 = itc.Adresse1,
 Adresse2 = itc.Adresse2,
 Adresse3 = itc.Adresse3,
 N_Ville = itc.N_Ville,
 N_Pays = itc.N_Pays,
 Telephone = itc.Telephone,
 Tel_Direct = itc.Tel_Direct,
 Fax_Direct = itc.Fax_Direct,
 Tel_Auto = itc.Tel_Auto,
 Tel_Portable = itc.Tel_Portable,
 Poste = itc.Poste,
 N_Fonction = itc.N_Fonction,
 N_Service = itc.N_Service,
 --Commentaire = itc.Commentaire,
 Libelle1 = itc.Libelle1,
 Champ1 = itc.Champ1,
 Libelle2 = itc.Libelle2,
 Champ2 = itc.Champ2,
 Libelle3 = itc.Libelle3,
 Champ3 = itc.Champ3,
 Libelle4 = itc.Libelle4,
 Champ4 = itc.Champ4,
 Libelle5 = itc.Libelle5,
 Champ5 = itc.Champ5,
 Libelle6 = itc.Libelle6,
 Champ6 = itc.Champ6,
 Libelle7 = itc.Libelle7,
 Champ7 = itc.Champ7,
 Libelle8 = itc.Libelle8,
 Champ8 = itc.Champ8,
 Photo = itc.Photo,
 [Standard] = itc.[Standard],
 Internet = itc.Internet,
 BBS = itc.BBS,
 Taux_Horaire_Franc = itc.Taux_Horaire_Franc,
 Taux_Horaire_Euro = itc.Taux_Horaire_Euro,
 Cadre = itc.Cadre,
 Num_ITC = itc.Num_ITC,
 Taux_Km_Franc = itc.Taux_Km_Franc,
 Taux_Km_Euro = itc.Taux_Km_Euro,
 Nom_Ville = itc.Nom_Ville,
 Nom_Pays = itc.Nom_Pays,
 Code_Postal = itc.Code_Postal,
 StyleFonte = itc.StyleFonte,
 ColorFond = itc.ColorFond,
 ColorTexte = itc.ColorTexte,
 N_Depot = itc.N_Depot,
 User_Create = itc.User_Create,
 Date_Create = itc.Date_Create,
 User_Modif = itc.User_Modif,
 Date_Modif = itc.Date_Modif,
 Actif = itc.Actif,
 TypeContrat = itc.TypeContrat,
 DateEntree = itc.DateEntree,
 DateSortie = itc.DateSortie,
 NbHeuresHebdos = itc.NbHeuresHebdos,
 matricule = itc.matricule,
 Champ9 = itc.Champ9,
 Champ10 = itc.Champ10,
 Champ11 = itc.Champ11,
 Champ12 = itc.Champ12,
 Champ13 = itc.Champ13,
 Champ14 = itc.Champ14,
 Champ15 = itc.Champ15,
 Champ16 = itc.Champ16,
 Champ17 = itc.Champ17,
 Champ18 = itc.Champ18,
 Champ19 = itc.Champ19,
 Champ20 = itc.Champ20,
 Champ21 = itc.Champ21,
 Champ22 = itc.Champ22,
 Champ23 = itc.Champ23,
 Champ24 = itc.Champ24,
 Champ25 = itc.Champ25,
 Champ26 = itc.Champ26,
 Champ27 = itc.Champ27,
 Champ28 = itc.Champ28,
 typePhoto = itc.typePhoto,
 CC_NUM = itc.CC_NUM,
 CT_NUM = itc.CT_NUM,
 CG_NUM = itc.CG_NUM,
 JO_NUM = itc.JO_NUM,
 MFPS_Service_Plus = itc.MFPS_Service_Plus,
 MFPS_Service_Code = itc.MFPS_Service_Code,
 User_Dest1_Demande_Conge = itc.User_Dest1_Demande_Conge,
 User_Dest2_Demande_Conge = itc.User_Dest2_Demande_Conge,
 User_Dest3_Demande_Conge = itc.User_Dest3_Demande_Conge,
 AlertePlanning = itc.AlertePlanning,
couleurTrack=
CASE WHEN
	ISNULL(PERIODE.Facture,0) > 0 OR EXISTS (SELECT 
	                                         	N_SFACT_PLANNING
	                                         FROM SFACT_PLANNING
	                                         WHERE  N_periode = Periode.N_periode) 
THEN 
	(SELECT 
	 	TOP 1 Color
	 FROM activite
	 WHERE  Code_secteur = 'ZP_F')
ELSE 
	CASE WHEN
		ISNULL(PEriode.Facturable,'Non') = 'Non' AND ISNULL(Periode.valider,'Non') = 'Oui' 
	THEN 
		16711808
	ELSE 
		CASE WHEN
			(ISNULL(Periode.valider,'Non') = 'Oui' AND ISNULL(periode.N_Todo,0)=0)
			OR (ISNULL(periode.N_Todo,0)>0 AND ISNULL(tds.Nbre_Valide,0)>=ISNULL(tds.Nbre_Fac,0))                                        
		THEN 
			(SELECT 
			 	TOP 1 Color
			 FROM activite
			 WHERE  Code_secteur = 'ZP_V')
		ELSE 
		
			CASE WHEN
				ISNULL(Affaire.[AlertePlanning],'Non') = 'Oui' 
			THEN 
				(SELECT 
				 	TOP 1 Color
					FROM activite
					WHERE  Code_secteur = 'ZP_SI')
			ELSE 
				CASE WHEN
					ISNULL(PEriode.categorie,'') = '' OR ISNULL(PEriode.categorie,'') = '@' 
				THEN 
					(SELECT 
					 	TOP 1 Color
						FROM activite
						WHERE  Code_secteur = 'ZP_CF')
				ELSE 
					0
				END
			END
			
		END
	END
END




FROM ITC 
		LEFT OUTER JOIN PERIODE ON ITC.N_ITC = Periode.n_ITC and  ( ( datedeb between @datedebut and @datefin) or (Datedeb<@DateDebut and Datefin>=@DateDebut) ) and Periode.N_itc<>0
		LEFT OUTER JOIN AFFAIRE ON affaire.N_affaire=Periode.n_affaire
		LEFT OUTER JOIN CLIENT C ON C.N_client=Affaire.N_client
		LEFT OUTER JOIN Activite act ON periode.Rubrique=act.Code_Secteur AND act.Parent>=0
		LEFT OUTER JOIN [EGXS_VUE_PLN_TODO_SUIVI] tds ON periode.N_Todo=tds.N_TODO
        LEFT OUTER JOIN @TB_CP_RTT cr ON cr.N_ITC = ITC.N_ITC    
        --LEFT OUTER JOIN 
        --(
            
        -- SELECT 
        --     ITC.N_ITC
        --    ,Nom_Personne  =ITC.Initial_commercial
        --    ,RTT = dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(ITC.N_itc,'ARTT',0,5,'')) 
        --    ,RTTF = dbo.MFP_NumToStr(dbo.MFP_GEST_REPOS_RECALCUL_REPOS(ITC.N_itc,'ARTTF',0,5,''))
        -- FROM Itc itc   
            
        --) AS cp ON cp.N_itc=itc.N_ITC
WHERE ITC.ACTIF = 'Oui' AND Itc.parent > 0 AND ITC.Champ1 = 'Oui' AND (@N_service = 0
                                                                                    OR (@N_service > 0
                                                                                       AND ((@MFPS_Service_Code = 0 AND ITC.N_service = @N_service)
                                                                                           OR (@MFPS_Service_Code > 0
                                                                                              AND (@MFPS_Service_Code & ITC.MFPS_Service_Code = @MFPS_Service_Code)))))
 
AND (@Periode_NonVal = 'Non' OR ((PERIODE.Valider='Non' OR Periode.Valider IS NULL) AND @Periode_NonVal='Oui'))
) AS T

ORDER BY ISNULL(Cast(T.Champ2 as int),0),Nom_Personne, heuredeb
OPTION (RECOMPILE)



