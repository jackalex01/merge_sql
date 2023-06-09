ALTER PROCEDURE [GENERE_ABONNEMENT_FACT_CLI] 
@N integer, @N_User integer,@Parent integer
AS
--@N est le numéro de la commande client/abonnement
BEGIN TRANSACTION

/*Calcul la date d'échéance*/
DECLARE @NbrJours int
DECLARE @FDM_Le int
DECLARE @Type int
DECLARE @Date_Facturation datetime
DECLARE @Date_Echeance datetime
DECLARE @Condition_Paiement varchar(25)
DECLARE @Mode_Paiement varchar(25)
DECLARE @Banque varchar(25)
DECLARE @Pourcentage numeric(18,10)
DECLARE @Ligne int

SELECT TOP 1 
	@Date_Facturation = R.Date,
 	@Condition_Paiement = R.Terme,
 	@Mode_Paiement = R.Mode,
	@Banque = R.Banque,
	@Pourcentage = R.Pourcent,
	@Ligne = R.N_Scde_Cli
FROM SCDE_CLI R 
WHERE R.N_Cde_Cli = @N AND R.Facture = 'Non' 
ORDER BY R.Date

IF( @Ligne IS NULL )
BEGIN
    RAISERROR ('Erreur: pas d''échéance disponible....', 16, 1) 
    ROLLBACK TRANSACTION
    RETURN
END

SELECT 
@NbrJours=Nbr_Jours , 
@FDM_Le=FDM_Le, 
@Type=Type
FROM CON_PAIE CON_PAIE
WHERE ( Condition_Paiement = @Condition_Paiement )
EXECUTE CALCUL_DATE_ECHEANCE @Date_Facturation, @Type, @NbrJours, @FDM_Le, @Date_Echeance OUTPUT

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_FACT_CLI  @CHRONO OUTPUT

INSERT INTO FACT_CLI
(
Nom_Fac_Cli,
N_Client,
N_Affaire,
N_Cde_Cli,
Date_Facture,
Date_Echeance,
Montant_Cde_Franc,
Montant_Cde_Euro,
Banque,
Mode,
Terme,
Descriptif_Cde,
Date_Cde,
Parent,
N_Devise,
Num_Fact_Cli,
TauxEuro,
N_Depot,
Pourcentage,
N_Ligne,
Nom_Livraison,
Adresse1,
Adresse2,
Adresse3,
N_Ville,
N_Pays,
Nom_Ville,
Nom_Pays,
Code_Postal,
Nom_reglement,
Adresse1Reglement,
Adresse2Reglement,
Adresse3Reglement,
N_Ville_Reglement,
N_Pays_Reglement,
Nom_Ville_Reglement,
Nom_Pays_Reglement,
Code_Postal_Reglement,
User_Create,
User_Modif)
SELECT
Nom_Fac_Cli=LEFT(CL.Nom_Client,10)+CAST(@CHRONO as varchar(15)),
CL.N_Client,
CD.N_Affaire,
CD.N_Cde_Cli,
Date_Facture=@Date_Facturation,
Echeance=@Date_Echeance,
CD.Montant_Franc,
CD.Montant_Euro,
@Banque,
@Mode_Paiement,
@Condition_Paiement,
CD.Descriptif,
CD.Date_Cde,
Parent=@Parent,
CD.N_Devise,
Num_Fact_Cli=@CHRONO,
CD.TauxEuro,
CD.N_Depot,
@Pourcentage,
@Ligne,
CD.Nom_Livraison,
CD.Adresse1,
CD.Adresse2,
CD.Adresse3,
CD.N_Ville,
CD.N_Pays,
CD.Nom_Ville,
CD.Nom_Pays,
CD.Code_Postal,
CD.Nom_reglement,
CD.Adresse1Reglement,
CD.Adresse2Reglement,
CD.Adresse3Reglement,
CD.N_Ville_Reglement,
CD.N_Pays_Reglement,
CD.Nom_Ville_Reglement,
CD.Nom_Pays_Reglement,
CD.Code_Postal_Reglement,
@N_user,
@N_User
FROM CDE_CLI CD, CLIENT CL
WHERE n_cde_cli = @N AND CD.N_Client = CL.N_Client

DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT @@IDENTITY )


--duplication du détail
DECLARE @Designation varchar(50)
DECLARE @HT_Franc numeric(18, 10)
DECLARE @HT_Euro numeric(18, 10)
DECLARE @TVA numeric(18, 10)
DECLARE @Quantite numeric
DECLARE @Unite varchar(5)
DECLARE @Remise numeric( 18,10 )
DECLARE @N_Activites int
DECLARE @PU_Franc numeric( 18,10 )
DECLARE @PU_Euro numeric( 18,10 )
DECLARE @N_Depot int
DECLARE @N_Produit int
DECLARE @N_Fct_Base int
DECLARE @Ref_Produit varchar(30)
DECLARE @HT_Franc_Facturer numeric(18, 10)
DECLARE @HT_Euro_Facturer numeric(18, 10)
DECLARE @N_Cde_Cli int
DECLARE @PU_Franc_Net numeric(18, 10)
DECLARE @PU_Euro_Net numeric(18, 10)
DECLARE @N_Position numeric(18, 10)
DECLARE @Texte varchar(8000)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @N_LigneCli int


DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des factures Client */


FOR
SELECT
SCD.Designation,
SCD.Texte,
SCD.Montant_Franc,
SCD.Montant_Euro,
SCD.Tva,
SCD.Quantite,
SCD.Unite,
SCD.Remise,
( SELECT TOP 1 A.N_Activites FROM Activite A WHERE ( SCD.Activite = A.Code_Secteur )AND( A.Parent = 0 ) ),
SCD.PU_Franc,
SCD.PU_Euro,
SCD.N_Depot,
SCD.N_Prod,
SCD.N_Fct_Base,
SCD.Reference,
@Pourcentage,
@Pourcentage*SCD.Montant_Franc/100,
@Pourcentage*SCD.Montant_Euro/100,
SCD.N_Cde_Cli,
SCD.PU_Franc*((100-ISNULL(SCD.Remise,0))/100),
SCD.PU_Euro*((100-ISNULL(SCD.Remise,0))/100),
SCD.N_Position,
SCD.CodePoste,
SCD.Libre1,
SCD.N_LigneCli
FROM LIGNECLI SCD
WHERE n_cde_cli = @N
ORDER BY N_Position, N_LigneCli
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position, @CodePoste, @Libre1, @N_LigneCli


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SFCT_CLI
(N_Fact_Cli,Designation,Texte,HT_Franc,HT_Euro,TVA,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_Fct_Base,N_BL,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Cli,PU_Franc_Net,PU_Euro_Net,
N_Position,CodePoste, Libre1, N_LigneCli, N_SS_BL, N_LigneOrigine)
VALUES
(@NCOPIE,@Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,0,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli, 0,0)


FETCH NEXT FROM @CursorVar
INTO  @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli
END

CLOSE @CursorVar
DEALLOCATE @CursorVar

/*
INSERT INTO SFCT_CLI
(
N_Fact_Cli,
Designation,
Texte,
HT_Franc,
HT_Euro,
TVA,
Quantite,
Unite,
Remise,
N_Activites,
PU_Franc,
PU_Euro,
N_Depot,
N_Produit,
N_Fct_Base,
Ref_Produit,
Pourcentage,
HT_Franc_Facturer,
HT_Euro_Facturer,
N_Cde_Cli,
PU_Franc_Net,
PU_Euro_Net,
N_Position, 
CodePoste, 
Libre1, 
N_LigneCli)
SELECT
@NCOPIE,
SCD.Designation,
SCD.Texte,
SCD.Montant_Franc,
SCD.Montant_Euro,
SCD.Tva,
SCD.Quantite,
SCD.Unite,
SCD.Remise,
( SELECT TOP 1 A.N_Activites FROM Activite A WHERE ( SCD.Activite = A.Code_Secteur )AND( A.Parent = 0 ) ),
SCD.PU_Franc,
SCD.PU_Euro,
SCD.N_Depot,
SCD.N_Prod,
SCD.N_Fct_Base,
SCD.Reference,
@Pourcentage,
@Pourcentage*SCD.Montant_Franc/100,
@Pourcentage*SCD.Montant_Euro/100,
SCD.N_Cde_Cli,
SCD.PU_Franc*(100-ISNULL(SCD.Remise,0)/100),
SCD.PU_Euro*(100-ISNULL(SCD.Remise,0)/100),
SCD.N_Position,
SCD.CodePoste,
SCD.Libre1,
SCD.N_LigneCli
FROM LIGNECLI SCD
WHERE n_cde_cli = @N
ORDER BY N_Position, N_LigneCli
*/

--insertion du terme de paiement

INSERT INTO RFAC_CLI
(N_Fact_Cli,
Date_Reglement,
Pourcentage,
Mode_Paiement,
Condition_Paiement,
Montant_Franc,
Montant_Euro,
Banque,
MontantTTC_Franc,
MontantTTC_Euro,
ReportTreso)
SELECT
F.N_Fact_Cli,
F.Date_Facture,
100,
F.Mode,
F.Terme,
F.HT_Franc,
F.HT_Euro,
F.Banque,
F.Total_TTc_Franc,
F.Total_TTc_Euro,
'Oui'
FROM FACT_CLI F
WHERE F.N_Fact_Cli = @NCOPIE

COMMIT














