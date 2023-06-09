ALTER PROCEDURE [PLANNING_OUVERTURE_AFFAIRE_RES]


@N_depot int,
@N_affaire int,
@N_itc int,
@N_produit int,
@N_service int,
@N_famille int,
@Solder int,
@Annee int,
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
	_typ =0,
	Nom = CAST ((Itc.nom_commercial + ' '+isnull(Itc.Prenom,'')) as varchar(50)),
	Affaire =  LEFT(Designation,50),
	Itc.n_itc,
	Periode.*,	
	Solder = Affaire.solder ,
	Ouverture = isnull(Affaire.date_ouverture,''),
	Fermeture = Isnull(Affaire.date_fermeture,'01/01/2099'),
	ITC.N_depot,
	ITC.n_service,
	Affaire.N_famille_affaire
	
	FROM ITC, PERIODE, Affaire
	
	
	WHERE Periode.n_itc = Itc.n_itc
	And Periode.n_affaire = Affaire.n_affaire
	And Year(datedeb)= @Annee
	And ((@N_depot = 0) OR ((@n_Depot > 0) and (AFFAIRE.n_depot=@N_depot)))
	And ((@N_affaire = 0) OR ((@N_affaire > 0) and (Affaire.n_affaire=@N_affaire)))
	And ((@N_itc = 0) OR ((@N_itc > 0) and (ITC.n_Itc=@N_Itc)))
	And ((@N_Service = 0) OR ((@n_Service > 0) and (Itc.n_Service=@N_Service)))
	And ((@N_Famille = 0) OR ((@N_Famille > 0) and (affaire.N_Famille_affaire=@N_Famille)))      
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
	And ((@Mois12 = 1) OR ((@Mois12 = 0) and (Month(DateDeb)<>12 ))) and
	
	( (@Solder = 0 ) or ( (@Solder =1) and (solder<>'Oui') ) or ( (@Solder =2) and (solder='Oui') )  )   and ( (@TypeRes = 0) or  (@TypeRes=1) )

	UNION ALL

	SELECT
	_Typ =1,
	Nom = CAST (Produit.Nom_produit as varchar(50)),
	Affaire =  LEFT(Affaire.Designation,50),
	n_itc=0,
	Periode.*,
	Solder = Affaire.solder ,
	Ouverture = isnull(Affaire.date_ouverture,''),
	Fermeture = Isnull(Affaire.date_fermeture,'01/01/2099'),
	N_depot=0,
	n_service=0,
	Affaire.N_famille_affaire
	
	FROM PRODUIT, PERIODE, Affaire
	
	
	WHERE Periode.n_Produit = PRODUIT.n_Produit
	And Periode.n_affaire = Affaire.n_affaire
	And Year(datedeb)= @Annee
	And ((@N_depot = 0) OR ((@n_Depot > 0) and (AFFAIRE.n_depot=@N_depot)))
	And ((@N_affaire = 0) OR ((@N_affaire > 0) and (Affaire.n_affaire=@N_affaire)))
	And ((@N_produit = 0) OR ((@N_produit > 0) and (Produit.N_Produit=@N_produit)))
	--And ((@N_Service = 0) OR ((@n_Service > 0) and (Itc.n_Service=@N_Service)))
	And ((@N_Famille = 0) OR ((@N_Famille > 0) and (affaire.N_Famille_affaire=@N_Famille)))      
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
	And ((@Mois12 = 1) OR ((@Mois12 = 0) and (Month(DateDeb)<>12 ))) and
	
	( (@Solder = 0 ) or ( (@Solder =1) and (solder<>'Oui') ) or ( (@Solder =2) and (solder='Oui') )  ) and ( (@TypeRes = 0) or  (@TypeRes=2) )
	
	
	
	
	ORDER BY LEFT(Affaire.Designation,50), _Typ, nom ,Datedeb,n_periode desc
END
ELSE
BEGIN
	EXEC PLANNING_OUVERTURE_AFFAIRE @N_depot ,@N_affaire ,@N_itc ,@N_service ,@N_famille ,@Solder ,@Annee 
END

