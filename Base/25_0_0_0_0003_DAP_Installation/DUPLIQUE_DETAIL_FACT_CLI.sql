ALTER PROCEDURE [DUPLIQUE_DETAIL_FACT_CLI]
@N int, @N_COPIE int
AS

DECLARE @N_SFact_Cli int
DECLARE @Designation varchar(50)
DECLARE @HT_Franc numeric(18, 10)
DECLARE @HT_Euro numeric(18, 10)
DECLARE @TVA numeric(18, 10)
DECLARE @N_SCde_Cli int
DECLARE @Quantite numeric(18, 10)
DECLARE @Unite varchar(5)
DECLARE @Remise numeric(18, 10)
DECLARE @N_Activites int
DECLARE @PU_Franc numeric(18, 10)
DECLARE @PU_Euro numeric(18, 10)
DECLARE @N_Depot int
DECLARE @N_Produit int
DECLARE @N_Fct_Base int
DECLARE @N_BL int
DECLARE @Ref_Produit varchar(30)
DECLARE @Pourcentage numeric(18, 10)
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
DECLARE @N_SS_BL int
DECLARE @N_LigneOrigine int
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int


DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des factures Client */


FOR
SELECT
Designation,Texte,HT_Franc,HT_Euro,TVA,N_SCde_Cli,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_Fct_Base,N_BL,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Cli,PU_Franc_Net,PU_Euro_Net,
N_Position, CodePoste, Libre1, N_LigneCli, N_SS_BL, N_SFact_Cli, N_LigneOrigine, StyleFonte, ColorFond, ColorTexte
FROM SFCT_CLI 
WHERE N_Fact_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position, @CodePoste, @Libre1, @N_LigneCli, @N_SS_BL, @N_SFact_Cli, @N_LigneOrigine, @StyleFonte, @ColorFond, @ColorTexte


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SFCT_CLI
(N_Fact_Cli,Designation,Texte,HT_Franc,HT_Euro,TVA,N_SCde_Cli,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_Fct_Base,N_BL,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Cli,PU_Franc_Net,PU_Euro_Net,
N_Position,CodePoste, Libre1, N_LigneCli, N_SS_BL, N_LigneOrigine, StyleFonte, ColorFond, ColorTexte)
VALUES
(@N_COPIE,@Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli, @N_SS_BL,@N_SFact_Cli, @StyleFonte, @ColorFond, @ColorTexte)


FETCH NEXT FROM @CursorVar
INTO  @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli, @N_SS_BL, @N_SFact_Cli, @N_LigneOrigine, @StyleFonte, @ColorFond, @ColorTexte
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

/* boucle pour dupliquer le réglement des factures Client */


FOR
SELECT
Date_Reglement,Pourcentage,Mode_Paiement,Condition_Paiement,
Montant_Franc,Montant_Euro,Banque,Bon_A_Payer,Payer,
MontantTTC_Franc,MontantTTC_Euro,ReportTreso
FROM RFAC_CLI 
WHERE N_Fact_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,@RBon_A_Payer,@RPayer,
@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso


WHILE @@FETCH_STATUS = 0
BEGIN

SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))

INSERT INTO RFAC_CLI
(N_Fact_Cli,Date_Reglement,Pourcentage,Mode_Paiement,Condition_Paiement,
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








