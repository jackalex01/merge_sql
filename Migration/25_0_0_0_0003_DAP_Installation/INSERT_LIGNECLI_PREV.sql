ALTER PROCEDURE [dbo].[INSERT_LIGNECLI_PREV] 
@N_SCde_Cli int,
@N_LigneCli_Prev int,
@N_Fct_Base int,
@N_LigneOrigine int
AS

DECLARE @N_Cde_Cli integer
SET @N_Cde_Cli = ( SELECT N_Cde_Cli FROM SCDE_CLi WHERE N_Scde_Cli = @N_Scde_Cli )


/*insere le detail de la fonction de base*/
IF( @N_Fct_Base > 0 )
BEGIN

DECLARE 
@Coeff numeric(18,10),
@Prix_Revient_Euro numeric(18,10),
@Prix_Vente_Euro numeric(18,10)

IF( @N_LigneOrigine > 0 )
/*récupération de la définition de la fonction de base dans la cde client*/
BEGIN

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_CDE_CLI WHERE N_LigneCli = @N_LigneOrigine )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI_PREV WHERE N_LigneCli_Prev = @N_LigneCli_Prev )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_LIGNECLI_PREV
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli_Prev,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff,
Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro,
Reference,
Unite,
N_Position,
Texte,
CodePoste,
Libre1,
StyleFonte,
ColorFond,
ColorTexte,
Invisible,
numeric1,
numeric2,
check1,
check2,
date1,
date2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,N_Ligne_Precedent
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
)
select 
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli = @N_Cde_Cli,
N_LigneCli_Prev = @N_LigneCli_Prev,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff = @Coeff,
Prix_Total_Vente_Franc=Prix_Total_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Euro*@Coeff,
Reference,
Unite,
N_Position,
Texte,
CodePoste,
Libre1,
StyleFonte,
ColorFond,
ColorTexte,
Invisible,
numeric1,
numeric2,
check1,
check2,
date1,
date2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 104 
,N_Fiche_Precedent = N_Cde_Cli
,N_Detail_Precedent = N_LigneCli
,N_Ligne_Precedent = N_Ligne
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Insert_Select /} */   
FROM FCT_CDE_CLI
WHERE( N_LigneCli = @N_LigneOrigine )

END

ELSE

BEGIN
/*Récupération de la définition de la fonction de base dans la fiche Fct de Base*/

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT WHERE N_Fct_Base = @N_Fct_Base )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI WHERE N_LigneCli = @N_LigneCli_Prev )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_LIGNECLI_PREV
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli_Prev,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff,
Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro,
Reference,
Unite,
N_Position,
Texte,
CodePoste,
Libre1,
StyleFonte,
ColorFond,
ColorTexte,
Invisible,
numeric1,
numeric2,
check1,
check2,
date1,
date2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,N_Ligne_Precedent
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
)
select 
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli = @N_Cde_Cli,
N_LigneCli = @N_LigneCli_Prev,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff = @Coeff,
Prix_Total_Vente_Franc=Prix_Total_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Euro*@Coeff,
Reference,
Unite,
N_Position,
Texte,
CodePoste,
Libre1,
StyleFonte,
ColorFond,
ColorTexte,
Invisible,
numeric1,
numeric2,
check1,
check2,
date1,
date2,
genesys_lock,
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 117  
,N_Fiche_Precedent = N_Fct_Base
,N_Detail_Precedent = N_Ligne
,N_Ligne_Precedent = 0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Insert_Select /} */
FROM LFCT
WHERE( N_Fct_Base = @N_Fct_Base )
END

END

--IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_CDE_CLI @N_Cde_Cli, @N_LigneCli

GO
