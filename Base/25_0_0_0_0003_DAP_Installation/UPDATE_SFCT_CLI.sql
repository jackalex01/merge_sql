ALTER PROCEDURE [UPDATE_SFCT_CLI] 
@N_Fact_Cli int,
@N_SFact_Cli int,
@N_Fct_Base int,
@N_Fct_BaseOld int,
@HT_Franc_Facturer numeric(18,5),
@HT_Franc_FacturerOld numeric(18,5),
@HT_Euro_Facturer numeric(18,5),
@HT_Euro_FacturerOld numeric(18,5),
@Tva numeric(18,5),
@TvaOld numeric(18,5),
@N_LigneCli int,
@N_LigneCliOld int,
@N_SS_BL int,
@N_SS_BLOld int,
@N_LigneOrigine int,
@N_LigneOrigineOld int,
@N_Devis int,
@N_DevisOld int,
@N_Ligne_Devis int,
@N_Ligne_DevisOld int

AS

IF( (@N_Fct_BaseOld <> @N_Fct_Base)OR( @N_LigneCliOld <> @N_LigneCli )OR( @N_SS_BLOld <> @N_SS_BL )OR( @N_LigneOrigineOld <> @N_LigneOrigine )OR( @N_DevisOld <> @N_Devis)OR( @N_Ligne_DevisOld <> @N_Ligne_Devis) )
BEGIN

/*supprime les détails de l'ancienne fonction de base*/
IF( @N_Fct_BaseOld > 0 )
BEGIN
DELETE FCT_FACT_CLI
WHERE( N_SFact_Cli = @N_SFact_Cli )
END

/*insere le detail de la fonction de base*/
IF( @N_Fct_Base > 0 )
BEGIN

DECLARE 
@Coeff numeric(18,5),
@Prix_Revient_Euro numeric(18,5),
@Prix_Vente_Euro numeric(18,5)

IF( @N_LigneOrigine > 0 )

/*Récupération de la définition de la fonction de base dans la facture client*/
BEGIN
SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_FACT_CLI WHERE N_Sfact_Cli = @N_LigneOrigine )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
FROM FCT_FACT_CLI
WHERE( N_SFact_cli = @N_LigneOrigine )


END


ELSE

BEGIN
IF( @N_LigneCli > 0 ) 
/*Récupération de la définition de la fonction de base dans la cde client*/
BEGIN
SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_CDE_CLI WHERE N_LigneCli = @N_LigneCli )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
WHERE( N_LigneCli = @N_LigneCli )

END

ELSE
BEGIN

IF( @N_SS_BL > 0 ) 
/*Récupération de la définition de la fonction de base dans le bl*/
BEGIN

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_BL WHERE N_SS_BL = @N_SS_BL )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
FROM FCT_BL
WHERE( N_SS_BL = @N_SS_BL )

END

ELSE

BEGIN

IF( @N_Devis > 0  )AND( @N_Ligne_Devis > 0 ) 
BEGIN
/*Récupération de la définition de la fonction de base dans le devis*/

DECLARE @GrilleUnique varchar(3)
SET @GrilleUnique =  ( SELECT GrilleUnique FROM DEVIS WHERE N_Devis = @N_Devis )
IF( @GrilleUnique = 'Non' ) 
	SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT_DEVIS WHERE N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )
ELSE
	SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT_DEVISDETAIL WHERE N_Devis = @N_Devis AND N_Ligne = @N_Ligne_Devis )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )

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
INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
/*Récupération de la définition de la fonction de base dans la fonction de base*/
SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM LFCT WHERE N_Fct_Base = @N_Fct_Base )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )

IF( @Prix_Revient_Euro IS NULL ) SET @Prix_Revient_Euro = 0
IF( @Prix_Revient_Euro <> 0 ) 
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
END
ELSE
BEGIN
SET @Coeff = 0
END

INSERT INTO FCT_FACT_CLI
(
Designation,
Quantite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fact_Cli,
N_SFact_Cli,
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
N_Fact_Cli = @N_Fact_Cli,
N_SFact_Cli = @N_SFact_Cli,
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
END

END

ELSE

BEGIN

SET @Coeff = 0
IF @HT_Franc_FacturerOld <> 0
BEGIN
SET @Coeff = @HT_Franc_Facturer/@HT_Franc_FacturerOld
UPDATE FCT_FACT_CLI
SET Coeff = Coeff*@Coeff,
Prix_Total_Vente_Franc=Prix_Total_Vente_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Vente_Euro*@Coeff
WHERE N_SFact_Cli = @N_SFact_Cli
END
ELSE
BEGIN

SET @Prix_Revient_Euro = ( SELECT SUM( Prix_Total_Euro ) FROM FCT_FACT_CLI WHERE N_SFact_Cli = @N_SFact_Cli  )
SET @Prix_Vente_Euro = ( SELECT HT_Euro_Facturer FROM SFCT_CLI WHERE N_SFact_Cli = @N_SFact_Cli )
IF( @Prix_Revient_Euro <> 0 )
BEGIN
SET @Coeff = @Prix_Vente_Euro/@Prix_Revient_Euro
UPDATE FCT_FACT_CLI
SET Coeff = @Coeff,
Prix_Total_Vente_Franc=Prix_Total_Franc*@Coeff,
Prix_Total_Vente_Euro=Prix_Total_Euro*@Coeff
WHERE N_SFact_Cli = @N_SFact_Cli
END
END
END



IF( @N_Fct_Base > 0 ) EXECUTE UPDATE_DEVISE_DETAIL_FCT_BASE_FACT_CLI @N_Fact_Cli, @N_SFact_Cli

/*recalcul des totaux*/
EXECUTE TOTAUX_FACT_CLI @N_Fact_Cli
/*recalcul des tvas*/
EXECUTE RECAP_TVA_FACT_CLI @N_Fact_Cli

/*ventilation par rubrique*/
EXECUTE RECAP_RUBRIQUE_FACT_CLI @N_Fact_Cli, 0
