ALTER PROCEDURE [DUPLIQUE_DETAIL_FAC_FOUR]
@N int, @N_COPIE int
AS

DECLARE @N_Scd_Four int
DECLARE @Description varchar(50)
DECLARE @Montant_HT_Franc numeric(18, 10)
DECLARE @Montant_HT_Euro numeric(18, 10)
DECLARE @TVA numeric(18, 10)
DECLARE @Quantite numeric(18, 10)
DECLARE @Unite varchar(5)
DECLARE @Remise numeric(18, 10)
DECLARE @N_Activites int
DECLARE @PU_Franc numeric(18, 10)
DECLARE @PU_Euro numeric(18, 10)
DECLARE @N_Depot int
DECLARE @N_Produit int
DECLARE @N_BR int /*le BR ne sera pas repris car une seule facture par BR*/
DECLARE @Ref_Produit varchar(30)
DECLARE @Pourcentage numeric(18, 10)
DECLARE @HT_Franc_Facturer numeric(18, 10)
DECLARE @HT_Euro_Facturer numeric(18, 10)
DECLARE @N_Cde_Four int
DECLARE @PU_Franc_Net numeric(18, 10)
DECLARE @PU_Euro_Net numeric(18, 10)
DECLARE @N_Position numeric(18, 10)
DECLARE @Texte varchar(8000)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int
DECLARE @N_Affaire int

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des factures Fournisseur */


FOR
SELECT
Description,Texte,Montant_HT_Franc,Montant_HT_Euro,TVA,N_SCd_Four,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_BR,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Four,PU_Franc_Net,PU_Euro_Net,
N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte, N_Affaire
FROM SFACFOUR 
WHERE N_Fac_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@N_SCd_Four,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_BR,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SFACFOUR
(N_Fac_Four,Description,Texte,Montant_HT_Franc,Montant_HT_Euro,TVA,N_SCd_Four,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_BR,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Four,PU_Franc_Net,PU_Euro_Net,
N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte, N_Affaire)
VALUES
(@N_COPIE,@Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@N_SCd_Four,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
0,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire)


FETCH NEXT FROM @CursorVar
INTO  @Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@N_SCd_Four,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_BR,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire
END

CLOSE @CursorVar
DEALLOCATE @CursorVar



DECLARE @RDate_Reglement datetime
DECLARE @RPourcentage numeric(18, 10)
DECLARE @RMode_Paiement varchar(25)
DECLARE @RCondition_Paiement varchar(25)
DECLARE @RMontant_Franc numeric(18, 10)
DECLARE @RMontant_Euro numeric(18, 10)
DECLARE @RBanque varchar(25)
DECLARE @RBon_A_Payer varchar(3)
DECLARE @RPayer varchar(3)
DECLARE @RMontantTTC_Franc numeric(18, 10)
DECLARE @RMontantTTC_Euro numeric(18, 10)
DECLARE @RReportTreso varchar(3)

SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le réglement des factures Fournisseur */


FOR
SELECT
Date_Reglement,Pourcentage,Mode_Paiement,Condition_Paiement,
Montant_Franc,Montant_Euro,Banque,Bon_A_Payer,Payer,
MontantTTC_Franc,MontantTTC_Euro,ReportTreso
FROM RFAC_FOU 
WHERE N_Fac_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,@RBon_A_Payer,@RPayer,
@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso


WHILE @@FETCH_STATUS = 0
BEGIN

SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))

INSERT INTO RFAC_FOU
(N_Fac_Four,Date_Reglement,Pourcentage,Mode_Paiement,Condition_Paiement,
Montant_Franc,Montant_Euro,Banque,Bon_A_Payer,Payer,
MontantTTC_Franc,MontantTTC_Euro,ReportTreso)
VALUES
(@N_COPIE,@RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,'Non','Non',
@RMontantTTC_Franc,@RMontantTTC_Euro,'Oui')


FETCH NEXT FROM @CursorVar
INTO  @RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,@RBon_A_Payer,@RPayer,
@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso
END

CLOSE @CursorVar
DEALLOCATE @CursorVar
