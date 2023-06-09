ALTER PROCEDURE [UPDATE_LIGNECLI] 
@N_Cde_Cli int,
@N_LigneCli int,
@N_Fct_Base int,
@N_Fct_BaseOld int,
@PrixVente numeric(18,10),
@PrixVenteOld numeric(18,10),
@N_Devis int,
@N_DevisOld int,
@N_Ligne_Devis int,
@N_Ligne_DevisOld int,
@N_LigneOrigine int,
@N_LigneOrigineOld int
AS

IF(( @N_Fct_BaseOld <> @N_Fct_Base )OR( @N_DevisOld <> @N_Devis )OR( @N_Ligne_DevisOld <> @N_Ligne_Devis )OR( @N_LigneOrigineOld <> @N_LigneOrigine ))
BEGIN

/*supprime les détails de l'ancienne fonction de base*/
IF( @N_Fct_BaseOld > 0 )
BEGIN
DELETE FCT_CDE_CLI
WHERE( N_LigneCli = @N_LigneCli )
END


/*insere le detail de la fonction de base*/
IF( @N_Fct_Base > 0 )
BEGIN

DECLARE 
@Coeff numeric(18,10),
@Prix_Revient_Euro numeric(18,10),
@Prix_Vente_Euro numeric(18,10),
@GrilleUnique varchar(3)


IF( @N_LigneOrigine > 0 )
/*récupération de la définition de la fonction de base dans la cde client*/
BEGIN

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_CDE_CLI WHERE N_LigneCli = @N_LigneOrigine )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI WHERE N_LigneCli = @N_LigneCli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_CDE_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli,
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
N_LigneCli = @N_LigneCli,
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
FROM FCT_CDE_CLI
WHERE( N_LigneCli = @N_LigneOrigine )


END

ELSE

BEGIN

IF( @N_Devis > 0  )AND( @N_Ligne_Devis > 0 ) 
BEGIN
/*Récupération de la définition de la fonction de base dans le devis*/

SET @GrilleUnique =  ( SELECT GrilleUnique FROM DEVIS WHERE N_Devis = @N_Devis )
IF( @GrilleUnique = 'Non' ) 
	SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT_DEVIS WHERE N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )
ELSE
	SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT_DEVISDETAIL WHERE N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI WHERE N_LigneCli = @N_LigneCli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

IF( @GrilleUnique = 'Non' ) 
INSERT INTO FCT_CDE_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff,
Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro,
Reference,
Unite
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
N_LigneCli = @N_LigneCli,
N_Fct_Base,
N_Produit,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Coeff = @Coeff,
Prix_Total_Vente_Franc=Prix_Total_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Euro*@Coeff,
Reference,
Unite
FROM LFCT_DEVIS
WHERE( N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )
ELSE
INSERT INTO FCT_CDE_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli,
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
N_LigneCli = @N_LigneCli,
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
FROM LFCT_DEVISDETAIL
WHERE( N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )

END
ELSE
BEGIN
/*Récupération de la définition de la fonction de base dans la fiche Fct de Base*/

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT WHERE N_Fct_Base = @N_Fct_Base )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI WHERE N_LigneCli = @N_LigneCli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_CDE_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Cde_Cli,
N_LigneCli,
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
N_LigneCli = @N_LigneCli,
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
FROM LFCT
WHERE( N_Fct_Base = @N_Fct_Base )
END

END

END


END
ELSE
BEGIN

SET @Coeff = 0
IF @PrixVenteOld <> 0 
BEGIN
SET @Coeff = @PrixVente/@PrixVenteOld
UPDATE FCT_CDE_CLI
SET Coeff = Coeff*@Coeff,
Prix_Total_Vente_Franc=Prix_Total_Vente_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Vente_Euro*@Coeff
WHERE N_LigneCli = @N_LigneCli
END
ELSE
BEGIN

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_CDE_CLI WHERE N_LigneCli = @N_LigneCli  )
SET @Prix_Vente_Euro = ( SELECT Montant_Euro FROM LIGNECLI WHERE N_LigneCli = @N_LigneCli )
IF( @Prix_Revient_Euro <> 0 )
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
UPDATE FCT_CDE_CLI
SET Coeff = @Coeff,
Prix_Total_Vente_Franc=Prix_Total_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Euro*@Coeff
WHERE N_LigneCli = @N_LigneCli
END
END

END


IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_CDE_CLI @N_Cde_Cli, @N_LigneCli

/*recalcul des totaux*/
EXECUTE TOTAUX_CDE_CLI @N_Cde_Cli

/*recalcul des tvas*/
EXECUTE RECAP_TVA_CDE_CLI @N_Cde_Cli

/*ventilation par rubrique*/
EXECUTE RECAP_RUBRIQUE_CDE_CLI @N_Cde_Cli
