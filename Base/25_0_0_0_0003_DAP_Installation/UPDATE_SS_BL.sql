ALTER PROCEDURE [UPDATE_SS_BL] 
@N_BL int,
@N_SS_BL int,
@N_Fct_Base int,
@N_Fct_BaseOld int,
@N_LigneCli int,
@N_LigneCliOld int,
@N_LigneOrigine int,
@N_LigneOrigineOld int
AS

IF(( @N_Fct_BaseOld <> @N_Fct_Base )OR( @N_LigneCliOld <> @N_LigneCli )OR( @N_LigneOrigineOld <> @N_LigneOrigine ))
BEGIN

/*supprime les détails de l'ancienne fonction de base*/
IF( @N_Fct_BaseOld > 0 )
BEGIN
DELETE FCT_BL
WHERE( N_BL = @N_BL )
END


/*insere le detail de la nouvelle fonction de base*/
IF( @N_Fct_Base > 0 )
BEGIN

IF( @N_LigneOrigine > 0 ) 

BEGIN

/*Récupération de la définition de la fonction de base dans le BL*/
INSERT INTO FCT_BL
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_BL,
N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
)
select 
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli = @N_BL,
N_LigneCli = @N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
FROM FCT_BL
WHERE(  N_SS_BL = @N_LigneOrigine )

END

ELSE

BEGIN

IF( @N_LigneCli > 0 ) 
/*Récupération de la définition de la fonction de base dans la cde client*/
INSERT INTO FCT_BL
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_BL,
N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
)
select 
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli = @N_BL,
N_LigneCli = @N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
FROM FCT_CDE_CLI
WHERE(  N_LigneCli = @N_LigneCli )

ELSE

/*Récupération de la définition de la fonction de base dans la fonction de base*/
INSERT INTO FCT_BL
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_BL,
N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
)
select 
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli = @N_BL,
N_LigneCli = @N_SS_BL,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
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
FROM LFCT
WHERE( N_Fct_Base = @N_Fct_Base )

END

END

END


IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_BL @N_BL, @N_SS_BL

/*recalcul des totaux*/
EXECUTE TOTAUX_BL @N_BL

/*ventilation par rubrique*/
EXECUTE RECAP_RUBRIQUE_BL @N_BL
