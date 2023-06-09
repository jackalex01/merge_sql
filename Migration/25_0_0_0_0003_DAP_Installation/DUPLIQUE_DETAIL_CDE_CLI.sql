ALTER PROCEDURE [dbo].[DUPLIQUE_DETAIL_CDE_CLI]
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
DECLARE @Texte varchar(max)
DECLARE @N_Devis int
DECLARE @N_Ligne_Devis int
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
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

/* boucle pour dupliquer le détail des cdes Client */


FOR
SELECT
N_Cde_Cli,N_Client,Reference,Designation,Texte,Quantite,Unite,PU_Franc,PU_Euro,
Remise,TVA,Activite,Montant_Franc,Montant_Euro,N_Prod,N_Fct_Base,
N_Depot,N_Position,N_Devis,N_Ligne_Devis,CodePoste,Libre1,N_LigneCli,N_LigneOrigine,StyleFonte,ColorFond,ColorTexte,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
/* s{App_LigneId Code=Cursor_Select /} */
, App_LigneId_Origine = App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Select /} */ 
FROM LIGNECLI 
WHERE N_Cde_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO LIGNECLI
(
    N_Cde_Cli
   ,N_Client
   ,Reference
   ,Designation
   ,Texte
   ,Quantite
   ,Unite
   ,PU_Franc
   ,PU_Euro
   ,Remise
   ,TVA
   ,Activite
   ,Montant_Franc
   ,Montant_Euro
   ,N_Prod
   ,N_Fct_Base
   ,N_Depot
   ,N_Position
   ,N_Devis
   ,N_Ligne_Devis
   ,CodePoste
   ,Libre1
   ,N_LigneOrigine
   ,StyleFonte
   ,ColorFond
   ,ColorTexte
   ,numeric1
   ,numeric2
   ,date1
   ,date2
   ,check1
   ,check2
   ,Libre2
   ,Libre3
   ,Libre4
   ,numeric3
   ,numeric4
   ,Fournisseur
   ,Marque
    /* s{App_LigneId Code=Insert /} */
    ,TypeFiche_Precedent 
    ,N_Fiche_Precedent
    ,N_Detail_Precedent 
    ,App_LigneId_Origine
	/* s{/App_LigneId Code=Insert /} */   
   
)
SELECT 
     N_Cde_Cli = @N_COPIE
    ,N_Client = @N_Client
    ,Reference = @Reference
    ,Designation = @Designation
    ,Texte = @Texte
    ,Quantite = @Quantite
    ,Unite = @Unite
    ,PU_Franc = @PU_Franc
    ,PU_Euro = @PU_Euro
    ,Remise = @Remise
    ,TVA = @TVA
    ,Activite = @Activite
    ,Montant_Franc = @Montant_Franc
    ,Montant_Euro = @Montant_Euro
    ,N_Prod = @N_Prod
    ,N_Fct_Base = @N_Fct_Base
    ,N_Depot = @N_Depot
    ,N_Position = @N_Position
    ,N_Devis = @N_Devis
    ,N_Ligne_Devis = @N_Ligne_Devis
    ,CodePoste = @CodePoste
    ,Libre1 = @Libre1
    ,N_LigneOrigine = @N_LigneCli
    ,StyleFonte = @StyleFonte
    ,ColorFond = @ColorFond
    ,ColorTexte = @ColorTexte
    ,numeric1 = @numeric1
    ,numeric2 = @numeric2
    ,date1 = @date1
    ,date2 = @date2
    ,check1 = @check1
    ,check2 = @check2
    ,Libre2 = @Libre2
    ,Libre3 = @Libre3
    ,Libre4 = @Libre4
    ,numeric3 = @numeric3
    ,numeric4 = @numeric4
    ,Fournisseur = @Fournisseur
    ,Marque = @Marque
    /* s{App_LigneId Code=Insert_Select /} */
    ,TypeFiche_Precedent = 104
    ,N_Fiche_Precedent = @N
    ,N_Detail_Precedent = @N_LigneCli
    ,App_LigneId_Origine = @App_LigneId_Origine 
	/* s{/App_LigneId Code=Insert_Select /} */   


FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Cli,@N_Client,@Reference,@Designation,@Texte,@Quantite,@Unite,@PU_Franc,@PU_Euro,
@Remise,@TVA,@Activite,@Montant_Franc,@Montant_Euro,@N_Prod,@N_Fct_Base,
@N_Depot,@N_Position,@N_Devis,@N_Ligne_Devis,@CodePoste,@Libre1,@N_LigneCli,@N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 
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
ReportTreso, Libre1, Libre2, Libre3, Libre4, numeric1, numeric2, check1, check2, date1, date2, StyleFonte, ColorFond, ColorTexte 
FROM SCDE_CLI 
WHERE N_Cde_Cli = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
@RReportTreso, @Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte 


WHILE @@FETCH_STATUS = 0
BEGIN

/*
SET @RDate_Reglement = (select(convert(datetime,convert(varchar(15),getdate(),103))))
*/

INSERT INTO SCDE_CLI
(N_Cde_Cli,Libelle,Pourcent,Montant_Franc,Montant_Euro,
Date,Mode,Terme,Banque,MontantTTC_Franc,MontantTTC_Euro,
ReportTreso, Libre1, Libre2, Libre3, Libre4, numeric1, numeric2, check1, check2, date1, date2, StyleFonte, ColorFond, ColorTexte)
VALUES
(@N_COPIE,@RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
'Oui',  @Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte )


FETCH NEXT FROM @CursorVar
INTO  @RLibelle,@RPourcent,@RMontant_Franc,@RMontant_Euro,
@RDate,@RMode,@RTerme,@RBanque,@RMontantTTC_Franc,@RMontantTTC_Euro,
@RReportTreso,  @Libre1, @Libre2, @Libre3,@Libre4, @numeric1, @numeric2, @check1, @check2, @date1, @date2, @StyleFonte, @ColorFond, @ColorTexte 
END

CLOSE @CursorVar
DEALLOCATE @CursorVar





GO
