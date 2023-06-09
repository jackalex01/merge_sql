ALTER PROCEDURE [DUPLIQUE_DETAIL_CDE_FOUR]
@N int, @N_COPIE int
AS

DECLARE @N_Scd_Four int
DECLARE @N_Cde_Four int
DECLARE @N_Four int
DECLARE @N_Prod int
DECLARE @Designation varchar(50)
DECLARE @Ref varchar(30)
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
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int
DECLARE @N_Affaire int

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des cdes fournisseurs */


FOR
SELECT
N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte, N_Affaire
FROM SCD_FOUR 
WHERE N_Cde_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire



WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SCD_FOUR
(N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte,N_Affaire)
VALUES
(@N_COPIE,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire)


FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire
END

CLOSE @CursorVar
DEALLOCATE @CursorVar


DECLARE @RDate_Reglement datetime
DECLARE @RPourcentage numeric(18, 10)
DECLARE @RCommentaire varchar(50)
DECLARE @RMode_Paiement varchar(25)
DECLARE @RCondition_Paiement varchar(25)
DECLARE @RMontant_Franc numeric(18, 10)
DECLARE @RMontant_Euro numeric(18, 10)
DECLARE @RBanque varchar(25)
DECLARE @RMontantTTC_Franc numeric(18, 10)
DECLARE @RMontantTTC_Euro numeric(18, 10)
DECLARE @RReportTreso varchar(3)

SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le réglement des cdes fournisseurs */


FOR
SELECT
Date_Reglement,Pourcentage,Commentaire,Mode_Paiement,
Condition_Paiement,Montant_Franc,Montant_Euro,
Banque,MontantTTC_Franc,MontantTTC_Euro,ReportTreso
FROM REGL_FOU 
WHERE N_Cde_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RDate_Reglement,@RPourcentage,@RCommentaire,@RMode_Paiement,
@RCondition_Paiement,@RMontant_Franc,@RMontant_Euro,
@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso


WHILE @@FETCH_STATUS = 0
BEGIN

/*
SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))
*/

INSERT INTO REGL_FOU
(N_Cde_Four,Date_Reglement,Pourcentage,Commentaire,Mode_Paiement,
Condition_Paiement,Montant_Franc,Montant_Euro,
Banque,MontantTTC_Franc,MontantTTC_Euro,ReportTreso)
VALUES
(@N_COPIE,@RDate_Reglement,@RPourcentage,@RCommentaire,@RMode_Paiement,
@RCondition_Paiement,@RMontant_Franc,@RMontant_Euro,
@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,'Oui')


FETCH NEXT FROM @CursorVar
INTO  @RDate_Reglement,@RPourcentage,@RCommentaire,@RMode_Paiement,
@RCondition_Paiement,@RMontant_Franc,@RMontant_Euro,
@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso
END

CLOSE @CursorVar
DEALLOCATE @CursorVar
