ALTER PROCEDURE [GENERE_ABONNEMENT_RECONDUCTION_CDE_CLI] 
@N integer, @N_User integer, @Parent integer
AS
--@N est le numéro de la commande fournisseur/abonnement
BEGIN TRANSACTION

IF( EXISTS( SELECT N_Cde_Cli  FROM CDE_CLI WHERE Parent > 0 AND AbtN_Cde_Origine = @N ) ) 
BEGIN
	RAISERROR ('Erreur: abonnement déja reconduit...', 16, 1) 
    	ROLLBACK TRANSACTION
	RETURN
END

DECLARE @MontantEcheanceAbtEuro numeric(18,10)
DECLARE @MontantEcheanceAbtFranc numeric(18,10)
DECLARE @TauxIndice numeric(18,10)
SET @MontantEcheanceAbtEuro = ( SELECT AbtMontantEcheance_Euro FROM CDE_CLI WHERE N_Cde_Cli = @N )
EXECUTE GENERE_ABONNEMENT_CALCULS_INDICES @N, @MontantEcheanceAbtEuro OUTPUT, @TauxIndice OUTPUT
SET @MontantEcheanceAbtFranc = ( SELECT AbtMontantEcheance_Franc FROM CDE_CLI WHERE N_Cde_Cli = @N )
EXECUTE GENERE_ABONNEMENT_CALCULS_INDICES @N, @MontantEcheanceAbtFranc OUTPUT, @TauxIndice OUTPUT

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_CDE_CLI  @CHRONO OUTPUT

INSERT INTO CDE_CLI
(
Nom_Cde,
Descriptif,
N_Commande1,
N_Commande2,
N_Affaire,
Montant_Franc,
Montant_Euro,
TVA_Franc,
TVA_Euro,
Ttc_Franc,
Ttc_Euro,
Marge,
N_Client,
Commentaire,
N_ITC1,
Pourcent1,
N_ITC2,
Pourcent2,
N_ITC3,
Pourcent3,
Libelle1,
Champ1,
Libelle2,
Champ2,
Libelle3,
Champ3,
Libelle4,
Champ4,
Libelle5,
Champ5,
Libelle6,
Champ6,
Libelle7,
Champ7,
Libelle8,
Champ8,
Parent,
Adresse1,
Adresse2,
Adresse3,
N_Ville,
N_Pays,
Adresse1Reglement,
Adresse2Reglement,
Adresse3Reglement,
N_Ville_Reglement,
N_Pays_Reglement,
N_Devise,
Num_Cde_Cli,
N_Devis,
Nom_Ville,
Nom_Pays,
Code_Postal,
Nom_Ville_Reglement,
Nom_Pays_Reglement,
Code_Postal_Reglement,
Nom_Livraison,
Nom_Reglement,
N_Depot,
TauxEuro,
LivraisonPrevue,
Abonnement,
AbtDescriptif,
AbtContrat,
AbtN_Famille,
AbtDateDebut,
AbtDateFin,
AbtPeriodiciteNb,
AbtPeriodiciteType,
AbtConditionsMode,
AbtConditionsTerme,
AbtConditionsBanque,
AbtMontantEcheance_Euro,
AbtMontantEcheance_Franc,
AbtN_Indice,
AbtValeurIndice,
AbtValeurIndiceFloat,
AbtReconductionMode,
AbtReconductionNb,
AbtReconductionType,
AbtN_Cde_Origine,
User_Create,
User_Modif)
SELECT
Nom_Cde=LEFT(CL.Nom_Client,10)+CAST(@CHRONO as varchar(15)),
CD.Descriptif,
CD.N_Commande1,
CD.N_Commande2,
CD.N_Affaire,
CD.Montant_Franc,
CD.Montant_Euro,
CD.TVA_Franc,
CD.TVA_Euro,
CD.Ttc_Franc,
CD.Ttc_Euro,
CD.Marge,
CD.N_Client,
CD.Commentaire,
CD.N_ITC1,
CD.Pourcent1,
CD.N_ITC2,
CD.Pourcent2,
CD.N_ITC3,
CD.Pourcent3,
CD.Libelle1,
CD.Champ1,
CD.Libelle2,
CD.Champ2,
CD.Libelle3,
CD.Champ3,
CD.Libelle4,
CD.Champ4,
CD.Libelle5,
CD.Champ5,
CD.Libelle6,
CD.Champ6,
CD.Libelle7,
CD.Champ7,
CD.Libelle8,
CD.Champ8,
@Parent,
CD.Adresse1,
CD.Adresse2,
CD.Adresse3,
CD.N_Ville,
CD.N_Pays,
CD.Adresse1Reglement,
CD.Adresse2Reglement,
CD.Adresse3Reglement,
CD.N_Ville_Reglement,
CD.N_Pays_Reglement,
CD.N_Devise,
Num_Cde_Cli=@CHRONO,
CD.N_Devis,
CD.Nom_Ville,
CD.Nom_Pays,
CD.Code_Postal,
CD.Nom_Ville_Reglement,
CD.Nom_Pays_Reglement,
CD.Code_Postal_Reglement,
CD.Nom_Livraison,
CD.Nom_Reglement,
CD.N_Depot,
CD.TauxEuro,
CD.LivraisonPrevue,
CD.Abonnement,
CD.AbtDescriptif,
CD.AbtContrat,
CD.AbtN_Famille,
(SELECT DATEADD(day, 1, CD.AbtDateFin )),
(SELECT DATEADD(day, DATEDIFF(day, CD.AbtDateDebut, CD.AbtDateFin ) + 1, CD.AbtDateFin )),
CD.AbtPeriodiciteNb,
CD.AbtPeriodiciteType,
CD.AbtConditionsMode,
CD.AbtConditionsTerme,
CD.AbtConditionsBanque,
@MontantEcheanceAbtEuro,
@MontantEcheanceAbtFranc,
CD.AbtN_Indice,
CD.AbtValeurIndice,
( SELECT Valeur FROM INDICES_CONFIG WHERE N_Indice_Config = CD.AbtN_Indice ),
CD.AbtReconductionMode,
CD.AbtReconductionNb,
CD.AbtReconductionType,
( CASE WHEN ISNULL( CD.AbtN_Cde_Origine, 0 ) = 0 THEN CD.N_Cde_Cli ELSE CD.AbtN_Cde_Origine END ),
@N_user,
@N_User
FROM CDE_CLI CD, CLIENT CL
WHERE CD.n_cde_cli = @N AND CL.N_Client = CD.N_Client


DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT @@IDENTITY )

--duplication du détail

DECLARE @N_LigneCli int
DECLARE @N_Cde_Cli int
DECLARE @N_Client int
DECLARE @Reference varchar(20)
DECLARE @Designation varchar(50)
DECLARE @Quantite numeric
DECLARE @Unite varchar(5)
DECLARE @PU_Franc numeric( 18,10 )
DECLARE @PU_Euro numeric( 18,10 )
DECLARE @Remise numeric( 18,10 )
DECLARE @TVA numeric(18, 10)
DECLARE @Activite varchar(5)
DECLARE @Montant_Franc numeric(18, 10)
DECLARE @Montant_Euro numeric(18, 10)
DECLARE @N_Prod int
DECLARE @N_Fct_Base int
DECLARE @N_Depot int
DECLARE @N_Position numeric(18, 10)
DECLARE @Texte varchar(8000)
DECLARE @N_Devis int
DECLARE @N_Ligne_Devis int
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @N_LigneOrigine int

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des cdes Client */


FOR
SELECT
N_Cde_Cli,N_Client,Reference,Designation,Texte,Quantite,Unite,PU_Franc,PU_Euro,
Remise,TVA,Activite,Montant_Franc,Montant_Euro,N_Prod,N_Fct_Base,
N_Depot,N_Position,N_Devis,N_Ligne_Devis,CodePoste,Libre1,N_LigneCli,N_LigneOrigine
FROM LIGNECLI 
WHERE N_Cde_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine


WHILE @@FETCH_STATUS = 0
BEGIN

SET @PU_Euro = @PU_Euro * @TauxIndice
SET @Montant_Euro = @Montant_Euro * @TauxIndice
SET @PU_Franc = @PU_Franc * @TauxIndice
SET @Montant_Franc = @Montant_Franc * @TauxIndice

INSERT INTO LIGNECLI
(N_Cde_Cli,N_Client,Reference,Designation,Texte,Quantite,Unite,PU_Franc,PU_Euro,
Remise,TVA,Activite,Montant_Franc,Montant_Euro,N_Prod,N_Fct_Base,
N_Depot,N_Position,N_Devis,N_Ligne_Devis,CodePoste,Libre1,N_LigneOrigine)
VALUES
(@NCOPIE,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli)

FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine
END

CLOSE @CursorVar
DEALLOCATE @CursorVar

--insertion du terme de paiement

EXECUTE GENERE_ABONNEMENT_ECHEANCES_CDE_CLI @NCOPIE

UPDATE CDE_CLI
SET AbtResilierMode = 1
WHERE N_Cde_Cli = @N

COMMIT











