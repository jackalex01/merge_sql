ALTER PROCEDURE [INSERT_DEVISDETAIL] 
@N_Ligne int,
@N_Devis int,
@N_Fct_Base int,
@N_LigneOrigine int
AS

/* insertion de la nouvelle fonction de base */
IF( @N_Fct_Base IS NOT NULL ) AND( @N_Fct_Base > 0 )
BEGIN

IF( @N_LigneOrigine > 0 ) 
BEGIN 

/* récupération d'une fonction de base définie dans le devis */
INSERT INTO LFCT_DEVISDETAIL(
N_Ligne,
N_Devis,
Man,
DESIGNATION,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Reference,
N_Position,
Unite,
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
@N_Ligne, 
@N_Devis, 
LF.Man,
LF.DESIGNATION,
LF.Quantite,
LF.Prix_U_Franc,
LF.Prix_U_Euro,
LF.Remise,
LF.Prix_Total_Franc,
LF.Prix_Total_Euro,
LF.N_Fct_Base,
LF.N_Produit,
LF.N_Rubrique,
LF.Prix_U_Remise_Franc,
LF.Prix_U_Remise_Euro,
LF.Reference,
LF.N_Position,
LF.Unite,
LF.Texte,
LF.CodePoste,
LF.Libre1,
LF.StyleFonte,
LF.ColorFond,
LF.ColorTexte,
LF.Invisible,
LF.numeric1,
LF.numeric2,
LF.check1,
LF.check2,
LF.date1,
LF.date2,
LF.genesys_lock,
LF.Libre2,
LF.Libre3,
LF.Libre4,
LF.numeric3,
LF.numeric4,
LF.Fournisseur,
LF.Marque 
from LFCT_DEVISDETAIL LF
WHERE( LF.N_Ligne = @N_LigneOrigine )
ORDER BY LF.N_Position
END


ELSE

BEGIN

/* récupération d'une fonction de base définie dans la fiche fonction de base */
INSERT INTO LFCT_DEVISDETAIL(
N_Ligne,
N_Devis,
DESIGNATION,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Reference,
N_Position,
Unite,
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
@N_Ligne, 
@N_Devis, 
LF.DESIGNATION,
LF.Quantite,
LF.Prix_U_Franc,
LF.Prix_U_Euro,
LF.Remise,
LF.Prix_Total_Franc,
LF.Prix_Total_Euro,
LF.N_Fct_Base,
LF.N_Produit,
LF.N_Rubrique,
LF.Prix_U_Remise_Franc,
LF.Prix_U_Remise_Euro,
LF.Reference,
LF.N_Position,
LF.Unite,
LF.Texte,
LF.CodePoste,
LF.Libre1,
LF.StyleFonte,
LF.ColorFond,
LF.ColorTexte,
LF.Invisible,
LF.numeric1,
LF.numeric2,
LF.check1,
LF.check2,
LF.date1,
LF.date2,
LF.genesys_lock,
LF.Libre2,
LF.Libre3,
LF.Libre4,
LF.numeric3,
LF.numeric4,
LF.Fournisseur,
LF.Marque 
from lfct LF
WHERE( LF.N_Fct_Base = @N_Fct_Base )
ORDER BY LF.N_Position
END

END


IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_DEVISDETAIL @N_Devis, @N_Ligne

EXECUTE RECAP_RUBRIQUE_DEVIS_DETAIL @N_Devis

EXECUTE RECAP_POSTE_DEVIS_DETAIL @N_Devis

/*recalcul des tvas*/
EXECUTE RECAP_TVA_DEVIS @N_Devis

EXECUTE TOTAUX_DEVIS @N_Devis
