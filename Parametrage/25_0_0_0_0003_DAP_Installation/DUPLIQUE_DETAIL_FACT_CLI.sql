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
DECLARE @Texte varchar(max)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @N_LigneCli int
DECLARE @N_SS_BL int
DECLARE @N_LigneOrigine int
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte INT

DECLARE @numeric1 NUMERIC(18,10)
DECLARE @numeric2 NUMERIC(18,10)
DECLARE @date1 datetime
DECLARE @date2 datetime
DECLARE @check1 VARCHAR(3)
DECLARE @check2 VARCHAR(3)
DECLARE @Libre2 VARCHAR(100)
DECLARE @Libre3 VARCHAR(100)
DECLARE @Libre4 VARCHAR(100)
DECLARE @numeric3 NUMERIC(18,10)
DECLARE @numeric4 NUMERIC(18,10)
DECLARE @Fournisseur VARCHAR(50)
DECLARE @Marque VARCHAR (50)

DECLARE
    /* s{App_LigneId Code=Declare /} */
    @App_LigneId_Origine varchar(50)
    /* s{/App_LigneId Code=Declare /} */ 
DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des factures Client */


FOR
SELECT
Designation,Texte,HT_Franc,HT_Euro,TVA,N_SCde_Cli,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_Fct_Base,N_BL,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Cli,PU_Franc_Net,PU_Euro_Net,
N_Position, CodePoste, Libre1, N_LigneCli, N_SS_BL, N_SFact_Cli, N_LigneOrigine, StyleFonte, ColorFond, ColorTexte,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
/* s{App_LigneId Code=Cursor_Select /} */
, App_LigneId_Origine = App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Select /} */ 
FROM SFCT_CLI 
WHERE N_Fact_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position, @CodePoste, @Libre1, @N_LigneCli, @N_SS_BL, @N_SFact_Cli, @N_LigneOrigine, @StyleFonte, @ColorFond, @ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SFCT_CLI
(N_Fact_Cli,Designation,Texte,HT_Franc,HT_Euro,TVA,N_SCde_Cli,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_Fct_Base,N_BL,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Cli,PU_Franc_Net,PU_Euro_Net,
N_Position,CodePoste, Libre1, N_LigneCli, N_SS_BL, N_LigneOrigine, StyleFonte, ColorFond, ColorTexte,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,App_LigneId_Origine
/* s{/App_LigneId Code=Insert /} */   
)
SELECT 
@N_COPIE,@Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli, @N_SS_BL,@N_SFact_Cli, @StyleFonte, @ColorFond, @ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 105
,N_Fiche_Precedent = @N
,N_Detail_Precedent = @N_SFact_Cli
,App_LigneId_Origine = @App_LigneId_Origine
/* s{/App_LigneId Code=Insert_Select /} */   



FETCH NEXT FROM @CursorVar
INTO  @Designation,@Texte,@HT_Franc,@HT_Euro,@TVA,@N_SCde_Cli,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@N_Fct_Base,@N_BL,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Cli,@PU_Franc_Net,@PU_Euro_Net,
@N_Position,@CodePoste, @Libre1, @N_LigneCli, @N_SS_BL, @N_SFact_Cli, @N_LigneOrigine, @StyleFonte, @ColorFond, @ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 
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
MontantTTC_Franc,MontantTTC_Euro,ReportTreso ,
Libre1, Libre2, Libre3, Libre4, numeric1, numeric2, check1, check2, date1, date2, StyleFonte, ColorFond, ColorTexte 
FROM RFAC_CLI 
WHERE N_Fact_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,@RBon_A_Payer,@RPayer,
@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso, 
@Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte 


WHILE @@FETCH_STATUS = 0
BEGIN

SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))

INSERT INTO RFAC_CLI
(N_Fact_Cli,Date_Reglement,Pourcentage,Mode_Paiement,Condition_Paiement,
Montant_Franc,Montant_Euro,Banque,Bon_A_Payer,Payer,
MontantTTC_Franc,MontantTTC_Euro,ReportTreso,
Libre1, Libre2, Libre3, Libre4, numeric1, numeric2, check1, check2, date1, date2, StyleFonte, ColorFond, ColorTexte )
VALUES
(@N_COPIE,@RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,'Non','Non',
@RMontantTTC_Franc,@RMontantTTC_Euro,'Oui',
@Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte )


FETCH NEXT FROM @CursorVar
INTO  @RDate_Reglement,@RPourcentage,@RMode_Paiement,@RCondition_Paiement,
@RMontant_Franc,@RMontant_Euro,@RBanque,@RBon_A_Payer,@RPayer,
@RMontantTTC_Franc,@RMontantTTC_Euro,@RReportTreso,
@Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte 
END

CLOSE @CursorVar
DEALLOCATE @CursorVar












