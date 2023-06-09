ALTER PROCEDURE [dbo].[GENERE_ABONNEMENT_FAC_FOUR] 
@N integer, @N_User integer, @Parent integer
AS
--@N est le numéro de la commande fournisseur/abonnement
BEGIN TRANSACTION

/*Calcul la date d'échéance*/
DECLARE @NbrJours int
DECLARE @FDM_Le int
DECLARE @Type int
DECLARE @Date_Facturation datetime
DECLARE @Date_Echeance datetime
DECLARE @Condition_Paiement varchar(25)
DECLARE @Mode_Paiement varchar(25)
DECLARE @Banque varchar(25)
DECLARE @Pourcentage numeric(18,10)
DECLARE @Ligne int

SELECT TOP 1 
	@Date_Facturation = R.Date_Reglement,
 	@Condition_Paiement = R.Condition_Paiement,
 	@Mode_Paiement = R.Mode_Paiement,
	@Banque = R.Banque,
	@Pourcentage = R.Pourcentage,
	@Ligne = R.N_Regl_Four
FROM REGL_FOU R 
WHERE R.N_Cde_Four = @N AND R.Facture = 'Non' 
ORDER BY R.Date_Reglement

IF( @Ligne IS NULL )
BEGIN
    RAISERROR ('{ Erreur: pas d''échéance disponible.... }', 16, 1) 
    ROLLBACK TRANSACTION
    RETURN
END

SELECT 
@NbrJours=Nbr_Jours , 
@FDM_Le=FDM_Le, 
@Type=Type
FROM CON_PAIE CON_PAIE
WHERE ( Condition_Paiement = @Condition_Paiement )
EXECUTE CALCUL_DATE_ECHEANCE @Date_Facturation, @Type, @NbrJours, @FDM_Le, @Date_Echeance OUTPUT

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_FAC_FOUR  @CHRONO OUTPUT

INSERT INTO FAC_FOUR
(
Nom_Fac_Four,
N_Cde_Four,
Nom_Fournisseur,
N_Fournisseur,
Mode_Paiement,
Condition_Paiement,
Banque,
Parent,
N_Affaire,
Echeance,
Descriptif_Cde,
Date_Cde,
Montant_Cde_Franc,
Montant_Cde_Euro,
Date_Facture,
N_Devise,
Num_Fac_Four,
TauxEuro,
N_Depot,
Pourcentage,
Ligne,
User_Create,
User_Modif)
SELECT
Nom_Fac_Four=LEFT(FO.Nom_Fournisseur,10)+CAST(@CHRONO as varchar(15)),
CF.N_Cde_Four,
FO.Nom_Fournisseur,
FO.N_Fourniss,
@Mode_Paiement,
@Condition_Paiement,
@Banque,
Parent=@Parent,
CF.N_Affaire,
Echeance=@Date_Echeance,
CF.Descriptif,
CF.Date_Com,
CF.HT_Franc,
CF.HT_Euro,
Date_Facture=@Date_Facturation,
CF.N_Devise,
Num_Fac_Four=@CHRONO,
CF.TauxEuro,
CF.N_Depot,
@Pourcentage,
@Ligne,
@N_user,
@N_User
FROM CDE_FOUR CF, FOURNISS FO
WHERE n_cde_four = @N AND CF.N_Four = FO.N_Fourniss

DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT SCOPE_IDENTITY() )

--duplication du détail
/*
INSERT INTO SFACFOUR
(N_Fac_Four,
Description,
Texte,
Montant_HT_Franc,
Montant_HT_Euro,
TVA,
N_SCd_Four,
Quantite,
Unite,
Remise,
N_Activites,
PU_Franc,
PU_Euro,
N_Depot,
N_Produit,
N_BR,
Ref_Produit,
Pourcentage,
HT_Franc_Facturer,
HT_Euro_Facturer,
N_Cde_Four,
PU_Franc_Net,
PU_Euro_Net,
N_Position)
SELECT
@NCOPIE,
SCD.Designation,
SCD.Texte,
SCD.Total_Franc,
SCD.Total_Euro,
SCD.Tva,
NULL,
SCD.Quantite,
SCD.Unite,
SCD.Remise,
( SELECT TOP 1 A.N_Activites FROM Activite A WHERE ( SCD.Rubrique = A.Code_Secteur )AND( A.Parent = 0 ) ),
SCD.Prix_HT_Franc,
SCD.Prix_HT_Euro,
SCD.N_Depot,
SCD.N_Prod,
0,
SCD.Ref,
@Pourcentage,
@Pourcentage*SCD.Total_Franc/100,
@Pourcentage*SCD.Total_Euro/100,
SCD.N_Cde_Four,
SCD.Prix_HT_Franc*(100-ISNULL(SCD.Remise,0)/100),
SCD.Prix_HT_Euro*(100-ISNULL(SCD.Remise,0)/100),
SCD.N_Position
FROM SCD_FOUR SCD
WHERE n_cde_four = @N
ORDER BY N_Position, N_Scd_Four
*/

DECLARE @Description varchar(50),
@Texte varchar(max),
@Montant_HT_Franc numeric(18,10),
@HT_Franc numeric(18,10),
@Montant_HT_Euro numeric(18,10),
@HT_Euro numeric(18,10),
@TVA numeric(18,10),
@Quantite numeric(18,10),
@Unite varchar(10),
@remise numeric(18,10),
@N_Activites int,
@PU_Franc numeric(18,10),
@PU_Euro numeric(18,10),
@N_Depot int,
@N_Produit int,
@Ref_Produit varchar(30),
@HT_Franc_Facturer numeric(18,10),
@HT_Euro_Facturer numeric(18,10),
@N_Cde_Four int,
@PU_Franc_Net numeric(18,10),
@PU_Euro_Net numeric(18,10),
@N_Position INT

, @N_Scd_Four INT 
/* s{Col_Detail_Supp Code=Declare /} */
, @StyleFonte int
, @ColorFond int
, @ColorTexte INT
, @numeric1 NUMERIC(18,10)
, @numeric2 NUMERIC(18,10)
, @date1 datetime
, @date2 datetime
, @check1 VARCHAR(3)
, @check2 VARCHAR(3)
, @Libre2 VARCHAR(100)
, @Libre3 VARCHAR(100)
, @Libre4 VARCHAR(100)
, @numeric3 NUMERIC(18,10)
, @numeric4 NUMERIC(18,10)
, @Fournisseur VARCHAR(50)
, @Marque VARCHAR (50)
/* s{/Col_Detail_Supp Code=Declare /} */
/* s{App_LigneId Code=Declare /} */
, @App_LigneId VARCHAR(50)
/* s{/App_LigneId Code=Declare /} */  



DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des factures Fournisseur */

FOR
SELECT
SCD.Designation,
SCD.Texte,
SCD.Total_Franc,
SCD.Total_Euro,

SCD.Tva,
SCD.Quantite,
SCD.Unite,
SCD.Remise,
( SELECT TOP 1 A.N_Activites FROM Activite A WHERE ( SCD.Rubrique = A.Code_Secteur )AND( A.Parent = 0 ) ),
SCD.Prix_HT_Franc,
SCD.Prix_HT_Euro,
SCD.N_Depot,
SCD.N_Prod,
SCD.Ref,
@Pourcentage,
@Pourcentage*SCD.Total_Franc/100,
@Pourcentage*SCD.Total_Euro/100,
SCD.N_Cde_Four,
SCD.Prix_HT_Franc*((100-ISNULL(SCD.Remise,0))/100),
SCD.Prix_HT_Euro*((100-ISNULL(SCD.Remise,0))/100),
SCD.N_Position
,SCD.N_Scd_Four
/* s{Col_Detail_Supp Code=Cursor_Select /} */
, StyleFonte
, ColorFond
, ColorTexte
, numeric1
, numeric2
, date1
, date2
, check1
, check2
, Libre2
, Libre3
, Libre4
, numeric3
, numeric4
, Fournisseur
, Marque
/* s{Col_Detail_Supp Code=Cursor_Select /} */
/* s{App_LigneId Code=Cursor_Select /} */
, App_LigneId 
/* s{/App_LigneId Code=Cursor_Select /} */  
FROM SCD_FOUR SCD
WHERE n_cde_four = @N
ORDER BY N_Position, N_Scd_Four
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position
, @N_Scd_Four
/* s{Col_Detail_Supp Code=Cursor_Variable /} */
, @StyleFonte
, @ColorFond
, @ColorTexte
, @numeric1
, @numeric2
, @date1
, @date2
, @check1
, @check2
, @Libre2
, @Libre3
, @Libre4
, @numeric3
, @numeric4
, @Fournisseur
, @Marque
/* s{Col_Detail_Supp Code=Cursor_Variable /} */
/* s{App_LigneId Code=Cursor_Variable /} */
, @app_LigneId 
/* s{/App_LigneId Code=Cursor_Variable /} */  

WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SFACFOUR
(N_Fac_Four,Description,Texte,Montant_HT_Franc,Montant_HT_Euro,TVA,Quantite,Unite,
Remise,N_Activites,PU_Franc,PU_Euro,N_Depot,N_Produit,
N_BR,Ref_Produit,Pourcentage,HT_Franc_Facturer,
HT_Euro_Facturer,N_Cde_Four,PU_Franc_Net,PU_Euro_Net,
N_Position
/* s{Col_Detail_Supp Code=Insert Comment=Oui /} *//*  
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
*//* s{/Col_Detail_Supp Code=Insert /} */ 
/* s{App_LigneId Code=Insert /} */
,TypeFiche_Precedent 
,N_Fiche_Precedent
,N_Detail_Precedent 
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
)
SELECT
@NCOPIE,@Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
0,@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position
/* s{Col_Detail_Supp Code=Insert_Select Comment=Oui /} *//*   
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
*//* s{Col_Detail_Supp Code=Insert_Select /} */   
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 112
,N_Fiche_Precedent = @N
,N_Detail_Precedent = @N_Scd_Four
,App_LigneId_Origine = @App_LigneId
/* s{/App_LigneId Code=Insert_Select /} */  


FETCH NEXT FROM @CursorVar
INTO  @Description,@Texte,@Montant_HT_Franc,@Montant_HT_Euro,@TVA,@Quantite,@Unite,
@Remise,@N_Activites,@PU_Franc,@PU_Euro,@N_Depot,@N_Produit,
@Ref_Produit,@Pourcentage,@HT_Franc_Facturer,
@HT_Euro_Facturer,@N_Cde_Four,@PU_Franc_Net,@PU_Euro_Net,
@N_Position
, @N_Scd_Four
/* s{Col_Detail_Supp Code=Cursor_Variable /} */
, @StyleFonte
, @ColorFond
, @ColorTexte
, @numeric1
, @numeric2
, @date1
, @date2
, @check1
, @check2
, @Libre2
, @Libre3
, @Libre4
, @numeric3
, @numeric4
, @Fournisseur
, @Marque
/* s{Col_Detail_Supp Code=Cursor_Variable /} */
/* s{App_LigneId Code=Cursor_Variable /} */
, @app_LigneId 
/* s{/App_LigneId Code=Cursor_Variable /} */  
END

CLOSE @CursorVar
DEALLOCATE @CursorVar


--insertion du terme de paiement

INSERT INTO RFAC_FOU
(N_Fac_Four,
Date_Reglement,
Pourcentage,
Mode_Paiement,
Condition_Paiement,
Montant_Franc,
Montant_Euro,
Banque,
MontantTTC_Franc,
MontantTTC_Euro,
ReportTreso)
SELECT
F.N_Fac_Four,
F.Date_Facture,
100,
F.Mode_Paiement,
F.Condition_Paiement,
F.Montant_HT_Franc,
F.Montant_HT_Euro,
F.Banque,
F.Total_TTc_Franc,
F.Total_TTc_Euro,
'Oui'
FROM FAC_FOUR F
WHERE F.N_Fac_Four = @NCOPIE

COMMIT












GO
