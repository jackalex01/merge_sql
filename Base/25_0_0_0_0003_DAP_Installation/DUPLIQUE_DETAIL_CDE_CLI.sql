ALTER PROCEDURE [DUPLIQUE_DETAIL_CDE_CLI]
@N int, @N_COPIE int
AS

DECLARE @N_LigneCli int
DECLARE @N_Cde_Cli int
DECLARE @N_Client int
DECLARE @Reference varchar(30)
DECLARE @Designation varchar(50)
DECLARE @Quantite numeric(18, 10)
DECLARE @Unite varchar(5)
DECLARE @PU_Franc numeric(18, 10)
DECLARE @PU_Euro numeric(18, 10)
DECLARE @Remise numeric(18, 10)
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
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des cdes Client */


FOR
SELECT
N_Cde_Cli,N_Client,Reference,Designation,Texte,Quantite,Unite,PU_Franc,PU_Euro,
Remise,TVA,Activite,Montant_Franc,Montant_Euro,N_Prod,N_Fct_Base,
N_Depot,N_Position,N_Devis,N_Ligne_Devis,CodePoste,Libre1,N_LigneCli,N_LigneOrigine,StyleFonte,ColorFond,ColorTexte
FROM LIGNECLI 
WHERE N_Cde_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO LIGNECLI
(N_Cde_Cli,N_Client,Reference,Designation,Texte,Quantite,Unite,PU_Franc,PU_Euro,
Remise,TVA,Activite,Montant_Franc,Montant_Euro,N_Prod,N_Fct_Base,
N_Depot,N_Position,N_Devis,N_Ligne_Devis,CodePoste,Libre1,N_LigneOrigine,StyleFonte,ColorFond,ColorTexte)
VALUES
(@N_COPIE,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@StyleFonte,@ColorFond,@ColorTexte)


FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte
END

CLOSE @CursorVar
DEALLOCATE @CursorVar


DECLARE @RLibelle varchar(50)
DECLARE @RPourcent numeric(18, 10)
DECLARE @RMontant_Franc numeric(18, 10)
DECLARE @RMontant_Euro numeric(18, 10)
DECLARE @RDate datetime
DECLARE @RMode varchar(25)
DECLARE @RTerme varchar(25)
DECLARE @RBanque varchar(25)
DECLARE @RBon_A_Payer varchar(3)
DECLARE @RMontantTTC_Franc numeric(18, 10)
DECLARE @RMontantTTC_Euro numeric(18, 10)
DECLARE @RReportTreso varchar(3)

SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le réglement des cdes Client */


FOR
SELECT
Libelle,Pourcent,Montant_Franc,Montant_Euro,
Date,Mode,Terme,Banque,MontantTTC_Franc,MontantTTC_Euro,
ReportTreso
FROM SCDE_CLI 
WHERE N_Cde_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
@RReportTreso


WHILE @@FETCH_STATUS = 0
BEGIN

/*
SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))
*/

INSERT INTO SCDE_CLI
(N_Cde_Cli,Libelle,Pourcent,Montant_Franc,Montant_Euro,
Date,Mode,Terme,Banque,MontantTTC_Franc,MontantTTC_Euro,
ReportTreso)
VALUES
(@N_COPIE,@RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
'Oui')


FETCH NEXT FROM @CursorVar
INTO  @RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
@RReportTreso
END

CLOSE @CursorVar
DEALLOCATE @CursorVar
