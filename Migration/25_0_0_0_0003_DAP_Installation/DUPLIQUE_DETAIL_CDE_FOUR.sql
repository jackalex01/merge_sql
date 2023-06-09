ALTER PROCEDURE [dbo].[DUPLIQUE_DETAIL_CDE_FOUR]
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
DECLARE @Texte varchar(max)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int
DECLARE @N_Affaire INT

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

BEGIN TRY 
    BEGIN TRANSACTION
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des cdes fournisseurs */


FOR
SELECT
N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte, N_Affaire,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
,N_Scd_Four
/* s{App_LigneId Code=Cursor_Select /} */
, App_LigneId_Origine = App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Select /} */ 
FROM SCD_FOUR 
WHERE N_Cde_Four = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
, @N_Scd_Four
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SCD_FOUR
(N_Cde_Four,N_Four,N_Prod,Designation,Texte,Ref,Quantite,Unite,
Prix_Ht_Franc,Prix_Ht_Euro,Remise,Total_Franc,Total_Euro,
TVA,Rubrique,N_Depot,N_Position,CodePoste,Libre1,StyleFonte,ColorFond,ColorTexte,N_Affaire,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,App_LigneId_Origine
/* s{/App_LigneId Code=Insert /} */   
)
SELECT
@N_COPIE,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 112
,N_Fiche_Precedent = @N
,N_Detail_Precedent = @N_Scd_Four
,App_LigneId_Origine = @App_LigneId_Origine
/* s{/App_LigneId Code=Insert_Select /} */  



FETCH NEXT FROM @CursorVar
INTO  @N_Cde_Four,@N_Four,@N_Prod,@Designation,@Texte,@Ref,@Quantite,@Unite,
@Prix_Ht_Franc,@Prix_Ht_Euro,@Remise,@Total_Franc,@Total_Euro,
@TVA,@Rubrique,@N_Depot,@N_Position,@CodePoste,@Libre1,@StyleFonte,@ColorFond,@ColorTexte, @N_Affaire,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
, @N_Scd_Four
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 
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


    
    COMMIT    
END TRY 
BEGIN CATCH
    --#region
    /* s{Catch_Error Code=Rollback /} */
    IF XACT_STATE()!=0
    BEGIN
        ROLLBACK TRANSACTION 
    END
    /* s{/Catch_Error Code=Rollback /} */
    
    /* s{Catch_Error Code=Prepare_Message /} */    
    DECLARE @Message nvarchar(4000), @ErrorMessage nvarchar(4000),@Error_Procedure NVARCHAR(200), @ErrorNumber int, @ErrorSeverity int, @ErrorState int, @ErrorLine INT

    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @Error_Procedure = ERROR_PROCEDURE()
            
    SET @Message = dev.MGX_FORMAT_MESSAGE(@ErrorMessage,@Error_Procedure,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorLine,'',@@SPID)
    /* s{/Catch_Error Code=Prepare_Message /} */  
    
    /* s{Catch_Error Code=Show_Error /} */    
    IF @ErrorNumber < 50000
    BEGIN
        ;THROW 50000,@Message,@ErrorState
    END   
    ELSE
    BEGIN
        ;THROW    
    END
    /* s{/Catch_Error Code=Show_Error /} */ 
    --#endregion                         
END CATCH 





GO
