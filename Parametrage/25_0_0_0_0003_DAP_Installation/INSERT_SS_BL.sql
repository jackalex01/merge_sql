ALTER PROCEDURE [INSERT_SS_BL] 
@N_BL int,
@N_SS_BL int,
@N_Fct_Base int,
@N_LigneCli int,
@N_LigneOrigine int
AS


/*insere le detail de la fonction de base*/
IF( @N_Fct_Base > 0 )
BEGIN

IF( @N_LigneOrigine > 0 )
/*récupération de la définition de la fonction de base dans le BL*/
BEGIN

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
N_BL = @N_BL,
N_SS_BL = @N_SS_BL,
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
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 103 
,N_Fiche_Precedent = N_BL
,N_Detail_Precedent = N_SS_BL
,N_Ligne_Precedent =  N_Ligne
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Insert_Select /} */   
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
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 104
,N_Fiche_Precedent = N_Cde_Cli
,N_Detail_Precedent = N_LigneCli
,N_Ligne_Precedent =  N_Ligne
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Insert_Select /} */   
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
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 117
,N_Fiche_Precedent = N_Fct_Base
,N_Detail_Precedent = N_Ligne
,N_Ligne_Precedent =  0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Insert_Select /} */   
FROM LFCT
WHERE( N_Fct_Base = @N_Fct_Base )

END

END


IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_BL @N_BL, @N_SS_BL

/*recalcul des totaux*/
EXECUTE TOTAUX_BL @N_BL

/*ventilation par rubrique*/
EXECUTE RECAP_RUBRIQUE_BL @N_BL

