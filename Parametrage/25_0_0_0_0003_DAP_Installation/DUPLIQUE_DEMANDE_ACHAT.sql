ALTER PROCEDURE [DUPLIQUE_DEMANDE_ACHAT] 
@N integer, @N_User integer
AS

BEGIN


/*détermine le dépot adéquat en fonction des droits
si droits restreint à une agence on force la copie sur cette agence*/
DECLARE 
@Creation int,
@N_DepotFiche int

SET @N_DepotFiche = ( SELECT N_Depot FROM DEMANDE_ACHAT da WHERE da.N_Demande_Achat = @N)
IF ISNULL( @N_DepotFiche, 0 ) = 0 SET @N_DepotFiche = (SELECT N_Depot FROM Depot WHERE Depot_Principal = 'Oui')
IF((SELECT Admin FROM USERS WHERE N_User = @N_User)<>'Oui')
BEGIN
	EXECUTE DROIT_CREATION_FICHE 127, @N_User, @N_DepotFiche, @Creation OUTPUT
	DECLARE @N_DepotUser int
	IF( @Creation IS NULL OR @Creation <> 1 ) 
		BEGIN
		/* par défaut, le dépôt d'appartenance de l'utilisateur */
		SET @N_DepotUser = ( SELECT I.N_Depot
		From USERS U, ITC I
		WHERE( U.N_User = @N_User )AND( U.N_ITC = I.N_ITC )AND( I.Parent > 0 )AND( I.Actif = 'Oui' ))
		/* on prend le dépôt du user */
		IF ISNULL( @N_DepotUser, 0 ) <> 0 SET @N_DepotFiche = @N_DepotUser
		END
END

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_DEMANDE_ACHAT @CHRONO OUTPUT


INSERT INTO DEMANDE_ACHAT
  (
    -- N_Demande_Achat -- this column value is auto-generated,
    Nom_Demande_Achat
   ,N_Affaire
   ,N_ITC
   ,Date_Dem
   ,Date_Liv
   ,Adresse_Livraison1
   ,Adresse_Livraison2
   ,Adresse_Livraison3
   ,Parent
   ,Champ1
   ,Champ2
   ,Champ3
   ,Champ4
   ,Champ5
   ,Champ6
   ,Champ7
   ,Champ8
   ,N_Four
   ,Code_Postal
   ,N_Ville
   ,N_Pays
   ,N_Devise
   ,Descriptif
   ,Commentaire
   ,Num_Demande_Achat
   ,Intention
   ,Nom_Livraison
   ,Nom_Ville
   ,Nom_Pays
   ,N_Depot
   ,Cloturer
   ,TauxEuro
   ,StyleFonte
   ,ColorFond
   ,ColorTexte
   ,User_Create
   ,Date_Create
   ,User_Modif
   ,Date_Modif
   ,N_Statut
   ,Champ9
   ,Champ10
   ,Champ11
   ,Champ12
   ,Champ13
   ,Champ14
   ,Champ15
   ,Champ16
   ,Champ17
   ,Champ18
   ,Champ19
   ,Champ20
   ,Champ21
   ,Champ22
   ,Champ23
   ,Champ24
   ,Champ25
   ,Champ26
   ,Champ27
   ,Champ28
   ,Nom_Adresse_Cde
   ,Adresse1_Cde
   ,Adresse2_Cde
   ,Adresse3_Cde
   ,Code_Postal_Cde
   ,Nom_Ville_Cde
   ,Nom_Pays_Cde
   ,N_Ville_Cde
   ,N_Pays_Cde
   ,Resultat
   ,DateResultat
   ,DemandeComplete
   ,CommandeComplete
   ,AlertePlanning
  )
SELECT 
	Nom_Demande_Achat =CAST(@CHRONO AS VARCHAR(10)) +'DP'+'000'
	,N_Affaire = t.N_Affaire
	,N_ITC = T.N_ITC
	,Date_Dem = CAST(CONVERT(varchar(20),GETDATE(),103) AS DATETIME)
	,Date_Liv = CAST(CONVERT(varchar(20),GETDATE(),103) AS DATETIME)
	,Adresse_Livraison1 = T.Adresse_Livraison1
	,Adresse_Livraison2 = T.Adresse_Livraison2
	,Adresse_Livraison3 = T.Adresse_Livraison3
	,Parent = t.Parent
	,Champ1 = T.Champ1
	,Champ2 = T.Champ2
	,Champ3 = T.Champ3
	,Champ4 = T.Champ4
	,Champ5 = T.Champ5
	,Champ6 = T.Champ6
	,Champ7 = T.Champ7
	,Champ8 = T.Champ8
	,N_Four = T.N_Four
	,Code_Postal = T.Code_Postal
	,N_Ville = T.N_Ville
	,N_Pays = T.N_Pays
	,N_Devise = T.N_Devise
	,Descriptif = T.Descriptif
	,Commentaire = T.Commentaire
	,Num_Demande_Achat = @CHRONO
	,Intention = T.Intention
	,Nom_Livraison = T.Nom_Livraison
	,Nom_Ville = T.Nom_Ville
	,Nom_Pays = T.Nom_Pays
	,N_Depot = T.N_Depot
	,Cloturer = 'Non'
	,TauxEuro = T.TauxEuro
	,StyleFonte = T.StyleFonte
	,ColorFond = T.ColorFond
	,ColorTexte = T.ColorTexte
	,User_Create = @N_User
	,Date_Create = CAST(CONVERT(varchar(20),GETDATE(),103) AS DATETIME)
	,User_Modif = @N_User
	,Date_Modif = CAST(CONVERT(varchar(20),GETDATE(),103) AS DATETIME)
	,N_Statut = NULL
	,Champ9 = T.Champ9
	,Champ10 = T.Champ10
	,Champ11 = T.Champ11
	,Champ12 = T.Champ12
	,Champ13 = T.Champ13
	,Champ14 = T.Champ14
	,Champ15 = T.Champ15
	,Champ16 = T.Champ16
	,Champ17 = T.Champ17
	,Champ18 = T.Champ18
	,Champ19 = T.Champ19
	,Champ20 = T.Champ20
	,Champ21 = T.Champ21
	,Champ22 = T.Champ22
	,Champ23 = T.Champ23
	,Champ24 = T.Champ24
	,Champ25 = T.Champ25
	,Champ26 = T.Champ26
	,Champ27 = T.Champ27
	,Champ28 = T.Champ28
	,Nom_Adresse_Cde = T.Nom_Adresse_Cde
	,Adresse1_Cde = T.Adresse1_Cde
	,Adresse2_Cde = T.Adresse2_Cde
	,Adresse3_Cde = T.Adresse3_Cde
	,Code_Postal_Cde = T.Code_Postal_Cde
	,Nom_Ville_Cde = T.Nom_Ville_Cde
	,Nom_Pays_Cde = T.Nom_Pays_Cde
	,N_Ville_Cde = T.N_Ville_Cde
	,N_Pays_Cde = T.N_Pays_Cde
	,Resultat = 0
	,DateResultat = CAST(CONVERT(varchar(20),GETDATE(),103) AS DATETIME)
	,DemandeComplete = 'Non'
	,CommandeComplete = 'Non'
	,AlertePlanning = 'Non'
FROM DEMANDE_ACHAT T 
WHERE T.N_Demande_Achat = @N

DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT @@IDENTITY )

EXECUTE DUPLIQUE_DETAIL_DEMANDE_ACHAT @N, @NCOPIE

/* Duplique la liste des fournisseurs consultéss */
EXECUTE [DUPLIQUE_FOURNISSEURS_DEMANDE_ACHAT] @N, @NCOPIE


END





