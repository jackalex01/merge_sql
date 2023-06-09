ALTER PROCEDURE [GENERE_ABONNEMENT_RECONDUCTION_CDE_FOUR] 
@N integer, @N_User integer, @Parent integer
AS
--@N est le numéro de la commande fournisseur/abonnement
BEGIN TRANSACTION

IF( EXISTS( SELECT N_Cde_Four  FROM CDE_FOUR WHERE Parent > 0 AND AbtN_Cde_Origine = @N ) ) 
BEGIN
	RAISERROR ('Erreur: abonnement déja reconduit...', 16, 1) 
    	ROLLBACK TRANSACTION
	RETURN
END

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_CDE_FOUR  @CHRONO OUTPUT

INSERT INTO CDE_FOUR
(
Nom_Cde_Four,
Nom_Fournisseur,
Ref_Devis,
N_Affaire,
N_ITC,
Contact,
Banque,
Adresse_Livraison1,
Adresse_Livraison2,
Adresse_Livraison3,
Parent,
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
N_Four,
Code_Postal,
N_Ville,
N_Pays,
N_Devise,
Descriptif,
N_Cde,
Commentaire,
Num_Cde_Four,
Intention,
Nom_Livraison,
Nom_Ville,
Nom_Pays,
N_Depot,
TauxEuro,
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
AbtReconductionMode,
AbtReconductionNb,
AbtReconductionType,
AbtN_Cde_Origine,
User_Create,
User_Modif)
SELECT
Nom_Cde_Four=LEFT(FO.Nom_Fournisseur,10)+CAST(@CHRONO as varchar(15)),
FO.Nom_Fournisseur,
CF.Ref_Devis,
CF.N_Affaire,
CF.N_ITC,
CF.Contact,
CF.Banque,
CF.Adresse_Livraison1,
CF.Adresse_Livraison2,
CF.Adresse_Livraison3,
@Parent,
CF.Libelle1,
CF.Champ1,
CF.Libelle2,
CF.Champ2,
CF.Libelle3,
CF.Champ3,
CF.Libelle4,
CF.Champ4,
CF.Libelle5,
CF.Champ5,
CF.Libelle6,
CF.Champ6,
CF.Libelle7,
CF.Champ7,
CF.Libelle8,
CF.Champ8,
CF.N_Four,
CF.Code_Postal,
CF.N_Ville,
CF.N_Pays,
CF.N_Devise,
CF.Descriptif,
CF.N_Cde,
CF.Commentaire,
Num_Cde_Four=@CHRONO,
CF.Intention,
CF.Nom_Livraison,
CF.Nom_Ville,
CF.Nom_Pays,
CF.N_Depot,
CF.TauxEuro,
CF.Abonnement,
CF.AbtDescriptif,
CF.AbtContrat,
CF.AbtN_Famille,
(SELECT DATEADD(day, 1, CF.AbtDateFin )),
(SELECT DATEADD(day, DATEDIFF(day, CF.AbtDateDebut, CF.AbtDateFin ), CF.AbtDateFin )),
CF.AbtPeriodiciteNb,
CF.AbtPeriodiciteType,
CF.AbtConditionsMode,
CF.AbtConditionsTerme,
CF.AbtConditionsBanque,
CF.AbtMontantEcheance_Euro,
CF.AbtMontantEcheance_Franc,
CF.AbtN_Indice,
CF.AbtValeurIndice,
CF.AbtReconductionMode,
CF.AbtReconductionNb,
CF.AbtReconductionType,
( CASE WHEN ISNULL( CF.AbtN_Cde_Origine, 0 ) = 0 THEN CF.N_Cde_Four ELSE CF.AbtN_Cde_Origine END ),
@N_user,
@N_User
FROM CDE_FOUR CF, FOURNISS FO
WHERE CF.n_cde_four = @N AND FO.N_Fourniss = CF.N_Four

DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT @@IDENTITY )

--duplication du détail

/*
INSERT INTO SCD_FOUR
(N_Cde_Four,
N_Four,
N_Prod,
Designation,
Texte,
Ref,
Quantite,
Unite,
Prix_Ht_Franc,
Prix_Ht_Euro,
Remise,
Total_Franc,
Total_Euro,
TVA,
Rubrique,
N_Depot,
N_Position)
SELECT
@NCOPIE,
SCD.N_Four,
SCD.N_Prod,
SCD.Designation,
SCD.Texte,
SCD.Ref,
SCD.Quantite,
SCD.Unite,
SCD.Prix_HT_Franc,
SCD.Prix_HT_Euro,
SCD.Remise,
SCD.Total_Franc,
SCD.Total_Euro,
SCD.Tva,
SCD.Rubrique,
SCD.N_Depot,
SCD.N_Position
FROM SCD_FOUR SCD
WHERE n_cde_four = @N
ORDER BY N_Position, N_Scd_Four
*/

DECLARE @N_Scd_Four int
DECLARE @N_Cde_Four int
DECLARE @N_Four int
DECLARE @N_Prod int
DECLARE @Designation varchar(50)
DECLARE @Ref varchar(20)
DECLARE @Quantite numeric(18, 10)
DECLARE @Unite varchar(5)
DECLARE @Prix_Ht_Franc numeric(18, 10)
DECLARE @Prix_Ht_Euro numeric(18, 10)
DECLARE @Remise numeric(18, 10)
DECLARE @Total_Franc numeric(18, 10)
DECLARE @Total_Euro numeric(18, 10)
DECLARE @TVA numeric(18, 10)
DECLARE @Rubrique varchar(5)
DECLARE @N_Depot int
DECLARE @N_Position numeric(18, 10)
DECLARE @Texte varchar(8000)

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des cdes fournisseurs */


FOR
SELECT
N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position
FROM SCD_FOUR 
WHERE N_Cde_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position



WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SCD_FOUR
(N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position)
VALUES
(@NCOPIE,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position)


FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position
END

CLOSE @CursorVar
DEALLOCATE @CursorVar
--insertion du terme de paiement

EXECUTE GENERE_ABONNEMENT_ECHEANCES_CDE_FOUR @NCOPIE

UPDATE CDE_FOUR
SET AbtResilierMode = 1
WHERE N_Cde_Four = @N

COMMIT













