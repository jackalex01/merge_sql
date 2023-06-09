ALTER   PROCEDURE [dbo].[LIGNECLI_PREV_ACTUALISE]
@N_Scde_Cli integer,
@N_User integer
AS

DECLARE @N_Cde_Cli integer
SET @N_Cde_Cli = ( SELECT N_Cde_Cli FROM SCDE_CLI WHERE N_Scde_Cli = @N_Scde_Cli )

DECLARE @Date datetime
SET @Date = ( SELECT Date FROM SCDE_CLI WHERE N_Scde_Cli = @N_Scde_Cli )

DECLARE @N integer

DECLARE @NB integer

DECLARE @HT_Euro_Facturer_Cumul numeric(18,10)
DECLARE @HT_Franc_Facturer_Cumul numeric(18,10)
DECLARE @PourcentageCumul numeric(18,10)

DECLARE @CursorVar CURSOR
-- boucle sur les lignes de la commande

SET @NB = ISNULL( ( SELECT COUNT(*) FROM LIGNECLI WHERE N_Cde_Cli = @N_Cde_Cli ), 0 )

IF( @NB > 0 )
BEGIN

DECLARE @N_Ligne integer

SET @N = 0


SET @CursorVar = CURSOR SCROLL DYNAMIC


FOR
SELECT N_LigneCli FROM LIGNECLI WHERE N_Cde_Cli = @N_Cde_Cli ORDER BY N_LigneCli, N_Position
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Ligne

WHILE @N < @NB

BEGIN

SET @N = @N + 1

IF NOT EXISTS( SELECT N_LigneCli FROM LIGNECLI_PREV WHERE N_Scde_Cli = @N_Scde_Cli AND LIGNECLI_PREV.N_LigneCli = @N_Ligne )
BEGIN


SET @HT_Euro_Facturer_Cumul = ( SELECT TOP 1 HT_Euro_Facturer_Cumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

SET @HT_Franc_Facturer_Cumul = ( SELECT TOP 1 HT_Franc_Facturer_Cumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

SET @PourcentageCumul = ( SELECT TOP 1 PourcentageCumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

INSERT INTO LIGNECLI_PREV
(
N_Scde_Cli,
N_LigneCli,
Reference,
Designation,
Quantite,
PU_Franc,
PU_Euro,
Remise,
Tva,
Activite,
Montant_Franc,
Montant_Euro,
N_Prod,
N_Fct_Base,
N_Depot,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Libre2,
Libre3,
Libre4,
numeric1,
numeric2,
numeric3,
numeric4,
date1,
date2,
check1,
check2,
genesys_lock,
Fournisseur,
Marque,
StyleFonte,
ColorFond,
ColorTexte,
HT_Euro_Facturer_Prec,
HT_Franc_Facturer_Prec,
HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Cumul,
PourcentageCumul
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
)
SELECT
@N_Scde_Cli,
N_LigneCli,
Reference,
Designation,
Quantite,
PU_Franc,
PU_Euro,
Remise,
Tva,
Activite,
Montant_Franc,
Montant_Euro,
N_Prod,
N_Fct_Base,
N_Depot,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Libre2,
Libre3,
Libre4,
numeric1,
numeric2,
numeric3,
numeric4,
date1,
date2,
check1,
check2,
genesys_lock,
Fournisseur,
Marque,
StyleFonte,
ColorFond,
ColorTexte,
HT_Euro_Facturer_Prec = @HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Prec = @HT_Franc_Facturer_Cumul,
HT_Euro_Facturer_Cumul = @HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Cumul = @HT_Franc_Facturer_Cumul,
PourcentageCumul = @PourcentageCumul
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 104 
,N_Fiche_Precedent = N_Cde_Cli
,N_Detail_Precedent = N_LigneCli
,App_LigneId_Origine = App_LigneId
/* s{/App_LigneId Code=Insert_Select /} */   
FROM LIGNECLI
WHERE N_LigneCli = @N_Ligne

END


FETCH NEXT FROM @CursorVar
INTO  @N_Ligne

END

CLOSE @CursorVar
DEALLOCATE @CursorVar

END

-- boucle sur les lignes de prévisionnel précédent

SET @NB = ISNULL( ( SELECT COUNT(*) FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE LI.N_Scde_Cli = SCD.N_Scde_Cli AND SCD.N_Cde_Cli = @N_Cde_Cli AND ( ( SCD.Date < @Date )OR( SCD.N_Scde_Cli < @N_Scde_Cli ) ) ), 0 )

IF( @NB > 0 )
BEGIN
	
DECLARE @N_Ligne_Prev integer

SET @N = 0


SET @CursorVar = CURSOR SCROLL DYNAMIC


FOR
SELECT N_LigneCli, N_LigneCli_Prev FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE LI.N_Scde_Cli = SCD.N_Scde_Cli AND SCD.N_Cde_Cli = @N_Cde_Cli AND ( ( SCD.Date < @Date )OR( SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY N_LigneCli, N_Position
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Ligne, @N_Ligne_Prev

WHILE @N < @NB

BEGIN

SET @N = @N + 1

IF NOT EXISTS( SELECT N_LigneCli FROM LIGNECLI_PREV WHERE N_Scde_Cli = @N_Scde_Cli AND LIGNECLI_PREV.N_LigneCli = @N_Ligne )
BEGIN


SET @HT_Euro_Facturer_Cumul = ( SELECT TOP 1 HT_Euro_Facturer_Cumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

SET @HT_Franc_Facturer_Cumul = ( SELECT TOP 1 HT_Franc_Facturer_Cumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

SET @PourcentageCumul = ( SELECT TOP 1 PourcentageCumul FROM LIGNECLI_PREV LI, SCDE_CLI SCD WHERE SCD.N_Cde_Cli = @N_Cde_Cli AND LI.N_Scde_Cli = SCD.N_Scde_Cli AND LI.N_LigneCli = @N_Ligne AND ( ( SCD.Date < @Date )OR( SCD.Date = @Date AND SCD.N_Scde_Cli < @N_Scde_Cli ) ) ORDER BY SCD.DATE DESC, SCD.N_Scde_Cli DESC )

INSERT INTO LIGNECLI_PREV
(
N_Scde_Cli,
N_LigneCli,
Reference,
Designation,
Quantite,
PU_Franc,
PU_Euro,
Remise,
Tva,
Activite,
Montant_Franc,
Montant_Euro,
N_Prod,
N_Fct_Base,
N_Depot,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Libre2,
Libre3,
Libre4,
numeric1,
numeric2,
numeric3,
numeric4,
date1,
date2,
check1,
check2,
genesys_lock,
Fournisseur,
Marque,
StyleFonte,
ColorFond,
ColorTexte,
HT_Euro_Facturer_Prec,
HT_Franc_Facturer_Prec,
HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Cumul,
PourcentageCumul
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
)
SELECT
@N_Scde_Cli,
N_LigneCli,
Reference,
Designation,
Quantite,
PU_Franc,
PU_Euro,
Remise,
Tva,
Activite,
Montant_Franc,
Montant_Euro,
N_Prod,
N_Fct_Base,
N_Depot,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Libre2,
Libre3,
Libre4,
numeric1,
numeric2,
numeric3,
numeric4,
date1,
date2,
check1,
check2,
genesys_lock,
Fournisseur,
Marque,
StyleFonte,
ColorFond,
ColorTexte,
HT_Euro_Facturer_Prec = @HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Prec = @HT_Franc_Facturer_Cumul,
HT_Euro_Facturer_Cumul = @HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Cumul = @HT_Franc_Facturer_Cumul,
PourcentageCumul = @PourcentageCumul
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 1041
,N_Fiche_Precedent = N_Scde_Cli
,N_Detail_Precedent = N_LigneCli_Prev
,App_LigneId_Origine = App_LigneId
/* s{/App_LigneId Code=Insert_Select /} */   
FROM LIGNECLI_PREV
WHERE N_LigneCli_Prev = @N_Ligne_Prev

END

FETCH NEXT FROM @CursorVar
INTO  @N_Ligne, @N_Ligne_Prev

END

CLOSE @CursorVar
DEALLOCATE @CursorVar

END
GO
