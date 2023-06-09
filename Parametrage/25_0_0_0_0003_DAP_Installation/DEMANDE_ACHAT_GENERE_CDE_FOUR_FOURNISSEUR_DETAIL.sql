ALTER PROCEDURE [DEMANDE_ACHAT_GENERE_CDE_FOUR_FOURNISSEUR_DETAIL]
@N_Da_Fournisseurs integer,
@N_User integer,
@N_Depot integer,
@N_Cde_Four integer
AS

BEGIN


DECLARE @Prix_Ht_Franc numeric(18,10)
DECLARE @Prix_Ht_Euro numeric(18,10)
DECLARE @Remise numeric(18,10)
DECLARE @QuantiteCde numeric(18,10)
DECLARE @N_Da_Detail integer


DECLARE @N_Position numeric(18,10)
SET @N_Position = 0.0


DECLARE @Compteur integer
SET @Compteur = 0
DECLARE @CompteurMax integer
SET @CompteurMax = ISNULL( ( SELECT COUNT(*) FROM DA_FOURNISSEURS_DETAIL DAF, DA_DETAIL DAT
WHERE DAF.N_Da_Fournisseurs = @N_Da_Fournisseurs AND DAF.N_Da_Detail = DAT.N_Da_Detail AND ISNULL( DAF.QuantiteCde, 0.0 ) <> 0.0 ), 0 )


DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC


/* boucle pour créer les cdes fournisseurs */
FOR

SELECT DAF.Prix_Ht_Franc, DAF.Prix_Ht_Euro, DAF.Remise, DAF.QuantiteCde, DAF.N_Da_Detail FROM DA_FOURNISSEURS_DETAIL DAF, DA_DETAIL DAT
WHERE DAF.N_Da_Fournisseurs = @N_Da_Fournisseurs AND DAF.N_Da_Detail = DAT.N_Da_Detail AND ISNULL( DAF.QuantiteCde, 0.0 ) <> 0.0
ORDER BY DAT.N_Position DESC

OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@QuantiteCde,@N_Da_Detail

WHILE @Compteur <  @CompteurMax
BEGIN

SET @N_Position = @N_Position + 100.0
SET @Compteur = @Compteur + 1


INSERT INTO SCD_FOUR
(N_Cde_Four,
Designation,
N_Depot, 
N_Four, 
N_Prod,
Unite,
Tva,
Texte,
Ref,
N_Position,
Quantite,
Prix_HT_Euro,
Prix_HT_Franc,
Remise,
Total_Euro,
Total_Franc,
Libre1,
CodePoste,
N_Affaire,
Rubrique
/* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*
,numeric1
,numeric2
,check1
,check2
,date1
,date2
,Libre2
,Libre3
,Libre4
,Numeric3
,Numeric4
*//* s{/Col_Detail_Supp Code=Insert /} */
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent
,N_Fiche_Precedent
,N_Detail_Precedent
,App_LigneId_Origine
/* s{/App_LigneId Code=Insert /} */

)
SELECT
@N_Cde_Four,
DAT.Designation,
@N_Depot,
( SELECT N_Fourniss FROM DA_FOURNISSEURS WHERE N_Da_Fournisseurs = @N_Da_Fournisseurs ),
DAT.N_Prod,
DAT.Unite,
DAT.Tva,
DAT.Texte,
DAT.Ref,
@N_Position,
@QuantiteCde,
@Prix_HT_Euro,
@Prix_HT_Euro,
@Remise,
@QuantiteCde*( @Prix_HT_Euro * (100.00 - ISNULL( @Remise, 0.00 ) )/100.00 ),
@QuantiteCde*( @Prix_HT_Euro * (100.00 - ISNULL( @Remise, 0.00 ) )/100.00 ),
DAT.Libre1,
DAT.CodePoste,
DAT.N_Affaire,
( SELECT Code_Secteur FROM ACTIVITE WHERE N_Activites = DAT.N_Rubrique )
/* s{Col_Detail_Supp Code=Insert_Select Comment=Oui /} *//*
,numeric1 = dat.numeric1
,numeric2 = dat.numeric2
,check1 = dat.check1
,check2 = dat.check2
,date1 = dat.date1
,date2 = dat.date2
,Libre2 = dat.Libre2
,Libre3 = dat.Libre3
,Libre4 = dat.Libre4
,Numeric3 = dat.Numeric3
,Numeric4 = dat.Numeric4
*//* s{/Col_Detail_Supp Code=Insert_Select /} */
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 127 
,N_Fiche_Precedent = dat.N_Demande_Achat
,N_Detail_Precedent = dat.N_Da_Detail
,App_LigneId_Origine = dat.App_LigneId
/* s{/App_LigneId Code=Insert_Select /} */
FROM DA_DETAIL DAT
WHERE N_Da_Detail = @N_Da_Detail

FETCH NEXT FROM @CursorVar
INTO  @Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@QuantiteCde,@N_Da_Detail
END

CLOSE @CursorVar
DEALLOCATE @CursorVar



INSERT INTO REGL_FOU
(
N_Cde_Four,
Date_Reglement,
Pourcentage,
Commentaire,
Mode_Paiement,
Condition_Paiement,
Montant_Franc,
Montant_Euro,
Banque,
Facture,
MontantTTC_Franc,
MontantTTC_Euro,
ReportTreso
)
SELECT
CF.N_Cde_Four,
CF.Date_Com,
100.0,
'Terme de paiement 100%',
FO.Mode_Paiement,
FO.Terme_Paiement,
CF.HT_Franc,
CF.HT_Euro,
( CASE WHEN ISNULL( FO.Banque_Paiement, '' ) <> '' THEN FO.Banque_Paiement ELSE SOFT.Banque END ),
'Non',
CF.Total_TTC_Franc,
CF.Total_TTC_Euro,
'Oui'
FROM CDE_FOUR CF, FOURNISS FO, SOFT_INI SOFT
WHERE CF.N_Cde_Four = @N_Cde_Four AND FO.N_Fourniss = CF.N_Four

END

