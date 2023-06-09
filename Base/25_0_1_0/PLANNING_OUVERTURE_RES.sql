ALTER PROCEDURE [PLANNING_OUVERTURE_RES]

@Annee int,
@N_Depot int,
@N_service int,
@N_itc int,
@N_produit int,
@N_affaire int,
@N_famille int,
@Solder int,
@N_user int,
@TypeRes int,
@Mois1 int,
@Mois2 int,
@Mois3 int,
@Mois4 int,
@Mois5 int,
@Mois6 int,
@Mois7 int,
@Mois8 int,
@Mois9 int,
@Mois10 int,
@Mois11 int,
@Mois12 int




AS

IF isnull((Select top 1 GestionRessource from periodeconfig),'Non') ='Oui'
Begin
   
	SELECT
	Typ = 0,
	Nom = CAST ((Itc.nom_commercial + ' '+isnull(Itc.Prenom,'')) as varchar(50)),
	Affaire = Case When isnull(designation,'')='' then '(Aucune affaire)' else LEFT(LTRIM(Designation),50) end,
	Itc.n_itc,
	--N_produit = 0,
	Periode.*,
	Solder = isnull(Affaire.solder,'Non'),
	Ouverture = isnull(Affaire.date_ouverture,''),
	Fermeture = Isnull(Affaire.date_fermeture,'01/01/2099'),
	ITC.N_depot,
	ITC.n_service,
	Affaire.N_famille_affaire
	
	FROM ITC, PERIODE LEFT OUTER JOIN AFFAIRE ON Periode.n_affaire = Affaire.n_affaire
	
	
	WHERE Periode.n_itc = Itc.n_itc
	And @Annee between Year(datedeb) and Year(DateFin)
	And ((@N_depot = 0) OR ((@N_Depot > 0) and (Itc.n_depot = @N_depot)))
	And ((@N_affaire = 0) OR ((@N_affaire > 0) and (Affaire.n_affaire = @N_affaire)))
	And ((@N_itc = 0) OR ((@N_itc > 0) and (ITC.N_Itc = @N_Itc)))
	And ((@N_Service = 0) OR ((@N_Service > 0) and (Itc.N_Service = @N_Service)))
	And ((@N_Famille = 0) OR ((@N_Famille > 0) and (Affaire.N_Famille_affaire = @N_Famille)))
	--And ((@Mois1 = 1) OR ((@Mois1 = 0) and (Month(DateDeb)<>1 )))
	--And ((@Mois2 = 1) OR ((@Mois2 = 0) and (Month(DateDeb)<>2 )))
	--And ((@Mois3 = 1) OR ((@Mois3 = 0) and (Month(DateDeb)<>3 )))
	--And ((@Mois4 = 1) OR ((@Mois4 = 0) and (Month(DateDeb)<>4 )))
	--And ((@Mois5 = 1) OR ((@Mois5 = 0) and (Month(DateDeb)<>5 )))
	--And ((@Mois6 = 1) OR ((@Mois6 = 0) and (Month(DateDeb)<>6 )))
	--And ((@Mois7 = 1) OR ((@Mois7 = 0) and (Month(DateDeb)<>7 )))
	--And ((@Mois8 = 1) OR ((@Mois8 = 0) and (Month(DateDeb)<>8 )))
	--And ((@Mois9 = 1) OR ((@Mois9 = 0) and (Month(DateDeb)<>9 )))
	--And ((@Mois10 = 1) OR ((@Mois10 = 0) and (Month(DateDeb)<>10 )))
	--And ((@Mois11 = 1) OR ((@Mois11 = 0) and (Month(DateDeb)<>11 )))
	--And ((@Mois12 = 1) OR ((@Mois12 = 0) and (Month(DateDeb)<>12 )))
	
	AND ( (@Solder = 0 ) or ( (@Solder =1) and (isnull(Affaire.solder,'Non')='Non') ) or ( (@Solder =2) and (isnull(Affaire.solder,'Non')='Oui') ))   and ( (@TypeRes = 0) or  (@TypeRes=1) ) And (@N_produit=0)
	
	
	UNION ALL
	
	SELECT
	Typ = 1,
	Nom =produit.nom_produit,
	Affaire = Case When isnull(affaire.designation,'')='' then '(Aucune affaire)' else LEFT(LTRIM(affaire.Designation),50) end,
	n_itc=0,
	--N_produit = Periode.n_produit,
	Periode.*,
	Solder = isnull(Affaire.solder,'Non'),
	Ouverture = isnull(Affaire.date_ouverture,''),
	Fermeture = Isnull(Affaire.date_fermeture,'01/01/2099'),
	N_depot=0,
	n_service=0,
	Affaire.N_famille_affaire
	
	FROM PRODUIT, PERIODE LEFT OUTER JOIN AFFAIRE ON Periode.n_affaire = Affaire.n_affaire
	
	
	WHERE Periode.n_produit = Produit.n_produit
	And  @Annee between Year(datedeb) and Year(DateFin)
	--And ((@N_depot = 0) OR ((@N_Depot > 0) and (Itc.n_depot = @N_depot)))
	And ((@N_affaire = 0) OR ((@N_affaire > 0) and (Affaire.n_affaire = @N_affaire)))
	And ((@N_produit = 0) OR ((@N_produit > 0) and (Produit.N_produit = @N_produit)))
	--And ((@N_Service = 0) OR ((@N_Service > 0) and (Itc.N_Service = @N_Service)))
	And ((@N_Famille = 0) OR ((@N_Famille > 0) and (Affaire.N_Famille_affaire = @N_Famille)))
	And ((@Mois1 = 1) OR ((@Mois1 = 0) and (Month(DateDeb)<>1 )))
	And ((@Mois2 = 1) OR ((@Mois2 = 0) and (Month(DateDeb)<>2 )))
	And ((@Mois3 = 1) OR ((@Mois3 = 0) and (Month(DateDeb)<>3 )))
	And ((@Mois4 = 1) OR ((@Mois4 = 0) and (Month(DateDeb)<>4 )))
	And ((@Mois5 = 1) OR ((@Mois5 = 0) and (Month(DateDeb)<>5 )))
	And ((@Mois6 = 1) OR ((@Mois6 = 0) and (Month(DateDeb)<>6 )))
	And ((@Mois7 = 1) OR ((@Mois7 = 0) and (Month(DateDeb)<>7 )))
	And ((@Mois8 = 1) OR ((@Mois8 = 0) and (Month(DateDeb)<>8 )))
	And ((@Mois9 = 1) OR ((@Mois9 = 0) and (Month(DateDeb)<>9 )))
	And ((@Mois10 = 1) OR ((@Mois10 = 0) and (Month(DateDeb)<>10 )))
	And ((@Mois11 = 1) OR ((@Mois11 = 0) and (Month(DateDeb)<>11 )))
	And ((@Mois12 = 1) OR ((@Mois12 = 0) and (Month(DateDeb)<>12 )))
	
	AND ( (@Solder = 0 ) or ( (@Solder =1) and (isnull(Affaire.solder,'Non')='Non') ) or ( (@Solder =2) and (isnull(Affaire.solder,'Non')='Oui') ))  and ( (@TypeRes = 0) or  (@TypeRes=2) )  And (@N_itc=0)
	
	
	
	ORDER BY typ, Nom, Periode.n_itc,Periode.  n_produit, Affaire, Datedeb, n_periode desc



End
Else
Begin
    
    EXEC PLANNING_OUVERTURE_PERSONNE @Annee, @N_Depot, @N_service, @N_itc, @N_affaire, @N_famille, @Solder, @Mois1, @Mois2, @Mois3, @Mois4, @Mois5, @Mois6, @Mois7, @Mois8, @Mois9, @Mois10, @Mois11, @Mois12 

End


