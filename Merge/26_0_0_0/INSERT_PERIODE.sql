ALTER   PROCEDURE [dbo].[EGXS_INSERT_PERIODE]
@N_User int,
@TypeEcran int, -- Donne l'origine de la création de la période : 0 si plan de charge par ressource, 1 plan de charge par affaire, 2 agenda, 3 Hendo/Jour 
@DateDeb datetime,
@DateFin datetime,
@HeureDeb int,
@HeureFin int,
@N_Itc int,
@N_Produit int,
@N_Equipement int,
@N_Affaire int,
@Poste varchar(50), -- vide sauf dans le cas d'une nouvelle période sur le plan de charges par Affaire, en visualisation par phases.
@N_planning_A_Planifier int -- Si <> 0 vient du planning à planifier


  --La PS EGXS_INSERT_PERIODE est jouée avant l'appel de la vue VUE_PLANNING_A_PLANIFIER_VERS_PERIODE.
  --Si l'on veut invalider cette vue pour ne prendre en compte que la PS EGXS_INSERT_PERIODE, il faut ajouter le champ "Disable_View = 1" dans la vue.
  --Si ce champ "Disable_View" n'est pas présent ou vaut 0, la vue s'exécutera et prendra "le dessus" par rapport aux informations de la PS EGXS_INSERT_PERIODE.
AS

DECLARE 
@Facturable varchar(3),
@Commentaire varchar(8000),
@Rubrique varchar(25),
@ValeurHeureFixe numeric(18,10),
@ExclureJoursFeries as varchar(3),
@ExclureJoursNonTravailles as varchar(3),
@HeureFixe varchar(3),
@Cout int,
@Couleur int,
@HeureParJour char(31),

@DateFin_Template DATE  


SELECT 
      @DateFin_Template = @DateDeb + DATEADD(DAY ,pap.[Quantite] -1 ,@DateDeb)
FROM [dbo].[PLANNING_A_PLANIFIER] pap
WHERE pap.[N_PLANNING_A_PLANIFIER] = @N_planning_A_Planifier AND pap.[Egxs_Template] = 1 


SET @Facturable = 'Non'
SET @Commentaire = (SELECT pap.[Designation] FROM [dbo].[PLANNING_A_PLANIFIER] pap WHERE pap.[N_PLANNING_A_PLANIFIER] = @N_planning_A_Planifier)
SET @Rubrique = ''
SET @ValeurHeureFixe	= (SELECT nbParDefaut FROM PeriodeConfig)
SET @ExclureJoursFeries	= (SELECT ExclureJoursFeries FROM PeriodeConfig)
SET @ExclureJoursNonTravailles = 'Oui'
SET @HeureFixe = 'Oui'
SET @Cout = 0
SET @Couleur = 0
SET @HeureParJour = ''


INSERT INTO PERIODE
  ( 
    N_UserCreate, 
    DateCreate,
    DateDeb,
    DateFin, 
    HeureDeb, 
    HeureFin,
    N_Itc,
    N_Produit,
	N_Equipement,
    N_Affaire,
    HeureFixe,
    ValeurHeureFixe,
    ExclureJoursFeries,
    ExclureJoursNonTravailles,
    Rubrique,
    Poste,
    Couleur,
    Cout,
    HeureParJour,
    Commentaire,
    Champ1        
  ) 
SELECT
   @N_User, 
   getdate(),
   @DateDeb,
   ISNULL(@DateFin_Template ,@DateFin),
   @HeureDeb,
   @HeureFin, -- Les heures doivent être définies en x2 (ex : 8h ->16 ; 8h30 -> 17)
   @N_Itc,
   @N_Produit,
   isnull(@N_Equipement,0),
   @N_Affaire,
   @HeureFixe,
   @ValeurHeureFixe,
   @ExclureJoursFeries,
   @ExclureJoursNonTravailles,
   @Rubrique,
   @Poste,
   @Couleur,
   @Cout,
   @HeureParJour,
   @Commentaire,
   Champ1 = (SELECT champ1 FROM EGXS_VUE_PLN_LISTE_MODE m WHERE  m.Cle = 1)


DECLARE 
	@N_Periode INT 
SET @N_Periode = SCOPE_IDENTITY()


SELECT @N_Periode 

GO
