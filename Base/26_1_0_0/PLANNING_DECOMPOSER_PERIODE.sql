ALTER PROCEDURE [PLANNING_DECOMPOSER_PERIODE] 
@N_periode INT,
@N_user int
AS

DECLARE 
    @Date datetime,
    @OptionTranferer varchar(3),
	@HeureParjour varchar(31),
	@Tmp_HeureParjour varchar(31),
	@Index int,
	@Asc_Jour varchar(1),
	@Nb numeric(18,10),
	@Nb_Premiere_Periode numeric(18,10),
	@Nombre int,
	@DateFin datetime


/*  Récupération des éléméents pour pouvoir Décomposer la periode */
SELECT 
	@Date = P.dateDeb,
	@DateFin=P.DateFin,
	@HeureParjour=P.HeureParjour
FROM PERIODE P
WHERE P.N_Periode = @N_Periode



/*  Modification de la periode + Insertion des nouvelles periodes */

--Initialisation de l'index
SET @Index=1

--Initialise la variable de stockage des heures par jour
SET @Tmp_HeureParjour=''


--Boucle sur la longueur de HeureParJou (1 caractere = 1 journée)
WHILE @Date<=@DateFin
BEGIN
	--Récupère le caractère 
	SET @Asc_Jour=Substring(@HeureParjour,@Index,1)
	
	--Récupère la valeur du caractère
	SET @Nombre=COnvert(int,ASCII(@Asc_Jour))	

	--Deduit la valeur numeric (Gestion particulière pour les sans valeur, 1/4, 1/2, 3/4)	
	IF (@Nombre>=1) AND @Nombre<=187
	BEGIN
		SET @Nb=@Nombre	
	END
	ELSE
	BEGIN
		--Gestion du 1/4
		IF @Nombre=188
		BEGIN
			SET @Nb=0.25
		END
		--Gestion du 1/2
		IF @Nombre=189
		BEGIN
			SET @Nb=0.5
		END
		--Gestion du 3/4
		IF @Nombre=190
		BEGIN
			SET @Nb=0.75
		END
		--Gestion du vide
		IF @Nombre=255
		BEGIN
			SET @Nb=0
		END
	END

	--Dans le cas de index=1 alors on update
	If @Index=1
	BEGIN
		--Mémorise le nombre d'heure de la première période
		SET @Nb_Premiere_Periode=@Nb

		--Mise a jour
		UPDATE PERIODE
			SET Datedeb=@date
			,DateFin=@Date
			,HeureParjour=@Asc_Jour
			,NbHeurePeriode=@Nb
			,N_groupe=@N_periode
		WHERE N_periode=@N_periode
	END

	--Dans le cas de index>1 et que le nombre d'heures est >0 alors on insert
	If @Index>1 And @Nb>0 
	BEGIN
		INSERT INTO Periode
           ([N_itc]
           ,[N_affaire]
           ,[n_produit]
           ,[typ]
           ,[Ordre]
           ,[datedeb]
           ,[DateFin]
           ,[Rubrique]
           ,[Couleur]
           ,[commentaire]
           ,[NbHeurePeriode]
           ,[HeureFixe]
           ,[HeureParJour]
           ,[ValeurHeureFixe]
           ,[OrdreItc]
           ,[OrdreProduit]
           ,[Poste]
           ,[Valider]
           ,[HeureDeb]
           ,[HeureFin]
           ,[Facturable]
           ,[Facture]
           ,[Cout]
           ,[N_PLANNING_A_PLANIFIER]
           ,[Categorie]
           ,[N_userCreate]
           ,[DateCreate]
           ,[N_userModif]
           ,[DateModif]
		   ,[N_Groupe]	)
		SELECT 
			[N_itc]
			,[N_affaire]
			,[n_produit]
			,[typ]
			,[Ordre]
			,[datedeb]=@Date
			,[DateFin]=@Date
			,[Rubrique]
			,[Couleur]
			,[commentaire]
			,[NbHeurePeriode]=@Nb
			,[HeureFixe]
			,[HeureParJour]=@Asc_Jour
			,[ValeurHeureFixe]
			,[OrdreItc]
			,[OrdreProduit]
			,[Poste]
			,[Valider]
			,[HeureDeb]
			,[HeureFin]
			,[Facturable]
			,[Facture]
			,[Cout]
			,[N_PLANNING_A_PLANIFIER]
			,[Categorie]
			,[N_userCreate]
			,[DateCreate]
			,[N_userModif]=@N_user
			,[DateModif]=COnvert(varchar(20),Getdate(),103)
			,[N_groupe]=@N_periode
		FROM [Periode]
		WHERE N_periode=@N_periode

	END
	
	SET @Index=@Index+1
	
	SET @Date=DATEADD(DAY,1,@date)
END

--Si la première période =0 Alors on la supprime
IF @Nb_Premiere_Periode=0
BEGIN
	DELETE PERIODE
	WHERE N_Periode=@N_periode
END









