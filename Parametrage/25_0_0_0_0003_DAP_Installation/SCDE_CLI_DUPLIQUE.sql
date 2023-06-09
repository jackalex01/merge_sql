ALTER PROCEDURE [SCDE_CLI_DUPLIQUE]
@N_Scde_Cli integer,
@N_User integer
AS

-- result = 0 alors erreur / result = 1 alors OK
-- si Msg <> '' alors on affiche.

/*
  { MessageBox() Flags }
  MB_OK = $00000000;
  MB_OKCANCEL = $00000001;
  MB_ABORTRETRYIGNORE = $00000002;
  MB_YESNOCANCEL = $00000003;
  MB_YESNO = $00000004;
  MB_RETRYCANCEL = $00000005;

  MB_ICONHAND = $00000010;
  MB_ICONQUESTION = $00000020;
  MB_ICONEXCLAMATION = $00000030;
  MB_ICONASTERISK = $00000040;
  MB_USERICON = $00000080;
  MB_ICONWARNING                 = MB_ICONEXCLAMATION;
  MB_ICONERROR                   = MB_ICONHAND;
  MB_ICONINFORMATION             = MB_ICONASTERISK;
  MB_ICONSTOP                    = MB_ICONHAND;

  MB_DEFBUTTON1 = $00000000;
  MB_DEFBUTTON2 = $00000100;
  MB_DEFBUTTON3 = $00000200;
  MB_DEFBUTTON4 = $00000300;

  MB_APPLMODAL = $00000000;
  MB_SYSTEMMODAL = $00001000;
  MB_TASKMODAL = $00002000;
  MB_HELP = $00004000;                          { Help Button }

  MB_NOFOCUS = $00008000;
  MB_SETFOREGROUND = $00010000;
  MB_DEFAULT_DESKTOP_ONLY = $00020000;

  MB_TOPMOST = $00040000;
  MB_RIGHT = $00080000;
  MB_RTLREADING = $00100000;

  MB_SERVICE_NOTIFICATION = $00200000;
  MB_SERVICE_NOTIFICATION_NT3X = $00040000;

  MB_TYPEMASK = $0000000F;
  MB_ICONMASK = $000000F0;
  MB_DEFMASK = $00000F00;
  MB_MODEMASK = $00003000;
  MB_MISCMASK = $0000C000;
*/

INSERT INTO SCDE_CLI
( N_Cde_Cli, 
Libelle, 
Pourcent, 
Montant_Franc, 
Montant_Euro, 
Date, 
Mode, 
Terme, 
Banque, 
Facture, 
MontantTTC_Franc, 
MontantTTC_Euro, 
ReportTreso, 
Libre1, 
Libre2, 
Libre3, 
Libre4, 
numeric1, 
numeric2, 
check1, 
check2, 
date1, 
date2, 
genesys_lock, 
StyleFonte, 
ColorFond, 
ColorTexte, 
PourcentCumul, 
Montant_Franc_Cumul, 
Montant_Euro_Cumul, 
MontantTTC_Franc_Cumul, 
MontantTTC_Euro_Cumul, 
Validation )  
SELECT
N_Cde_Cli, 
LEFT( Libelle + ' COPIE', 50 ), 
Pourcent, 
Montant_Franc, 
Montant_Euro, 
Date, 
Mode, 
Terme, 
Banque, 
Facture = 'Non', 
MontantTTC_Franc, 
MontantTTC_Euro, 
ReportTreso = 'Non',
Libre1, 
Libre2, 
Libre3, 
Libre4, 
numeric1, 
numeric2, 
check1, 
check2, 
date1, 
date2, 
genesys_lock = 'Non', 
StyleFonte, 
ColorFond, 
ColorTexte, 
PourcentCumul, 
Montant_Franc_Cumul, 
Montant_Euro_Cumul, 
MontantTTC_Franc_Cumul, 
MontantTTC_Euro_Cumul, 
Validation = 'Non'
FROM SCDE_CLI
WHERE N_Scde_Cli = @N_SCde_Cli

DECLARE @N_Scde_Cli_COPIE integer
SET @N_Scde_Cli_COPIE = ( SELECT SCOPE_IDENTITY() )

DECLARE @N_Cde_Cli integer
SET @N_Cde_Cli = ( SELECT N_Cde_Cli FROM SCDE_CLI WHERE N_Scde_Cli = @N_Scde_Cli )


DECLARE @NB integer
SET @NB = ISNULL( ( SELECT COUNT(*) FROM LIGNECLI_PREV LI WHERE N_SCde_Cli = @N_SCde_Cli ), 0 )

IF NOT ( @NB = 0 ) 

BEGIN

DECLARE @N integer
SET @N = 0

DECLARE @N_LigneCli_Prev integer

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour valider/vérifier le détail du prévisionnel de la Cde Client */


FOR
SELECT
N_LigneCli_Prev
FROM LIGNECLI_PREV 
WHERE N_SCde_Cli = @N_SCde_Cli
ORDER BY N_Position, N_LigneCli_Prev
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_LigneCli_Prev


WHILE @N < @NB
BEGIN

SET @N = @N + 1

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
StyleFonte,
ColorFond,
ColorTexte,
numeric1,
numeric2,
date1,
date2,
check1,
check2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque,
Pourcentage,
PourcentageCumul,
HT_Franc_Facturer_Cumul,
HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Prec,
HT_Euro_Facturer_Prec,
HT_Franc_Facturer,
HT_Euro_Facturer
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent
,N_Fiche_Precedent
,N_Detail_Precedent
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */
)
SELECT
@N_Scde_Cli_COPIE,
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
StyleFonte,
ColorFond,
ColorTexte,
numeric1,
numeric2,
date1,
date2,
check1,
check2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque,
Pourcentage,
PourcentageCumul,
HT_Franc_Facturer_Cumul,
HT_Euro_Facturer_Cumul,
HT_Franc_Facturer_Prec,
HT_Euro_Facturer_Prec,
HT_Franc_Facturer,
HT_Euro_Facturer
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 1041
,N_Fiche_Precedent = @N_Scde_Cli
,N_Detail_Precedent = N_LigneCli_Prev
,App_LigneId_Origine = App_LigneId_Origine
/* s{/App_LigneId Code=Insert_Select /} */
FROM LIGNECLI_PREV
WHERE N_LigneCli_Prev =  @N_LigneCli_Prev

FETCH NEXT FROM @CursorVar
INTO  @N_LigneCli_Prev

END

CLOSE @CursorVar
DEALLOCATE @CursorVar

END

EXEC RECAP_PREV_CDE_CLI @N_Cde_Cli

SELECT Result = 1, Msg = 'OK!', Caption = 'Information - after duplique scde_Cli', Flags = 64


