ALTER PROCEDURE [DUPLIQUE_FCT_BASE] 
@N integer, @N_User integer
AS

BEGIN TRANSACTION

/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_FCT_BASE  @CHRONO OUTPUT

INSERT INTO FCT_BASE
(Nom_Fct_Base,
Date_Relance,
Total_Heure,
Total_Ht_Heure_Franc,
Total_Ht_Heure_Euro,
Total_Ht_Produit_Franc,
Total_Ht_Produit_Euro,
Champ1,
Champ2,
Champ3,
Champ4,
Champ5,
Champ6,
Champ7,
Champ8,
Champ9,
Champ10,
Champ11,
Champ12,
Champ13,
Champ14,
Champ15,
Champ16,
Champ17,
Champ18,
Champ19,
Champ20,
Champ21,
Champ22,
Champ23,
Champ24,
Champ25,
Champ26,
Champ27,
Champ28,
Parent,
Date_Creation,
Num_Fct_Base,
Ref_Constructeur,
Prix_Vente_Franc,
Prix_Vente_Euro,
Photo,
Marque,
Unite,
N_Famille_Produit,
Obsolete,
Poids,
Colisage,
Garantie,
Origine,
Delai,
CG_NUM_Vente_France,
CG_NUM_Vente_Export,
CG_NUM_Vente_CE,
N_Tva_Vente_France,
N_Tva_Vente_Export,
QteMini,
QteMaxi,
QteAppro,
DepotConsulter,
GestionStock,
CodeRubrique,
Nom_Fct_Base1,
Nom_Fct_Base2,
Nom_Fct_Base3,
Descriptif,
Groupe,
User_Create,
User_Modif )
SELECT
Nom_Fct_Base= LEFT(Nom_Fct_Base+' (COPIE)',50),
Date_Relance,
Total_Heure,
Total_Ht_Heure_Franc,
Total_Ht_Heure_Euro,
Total_Ht_Produit_Franc,
Total_Ht_Produit_Euro,
Champ1,
Champ2,
Champ3,
Champ4,
Champ5,
Champ6,
Champ7,
Champ8,
Champ9,
Champ10,
Champ11,
Champ12,
Champ13,
Champ14,
Champ15,
Champ16,
Champ17,
Champ18,
Champ19,
Champ20,
Champ21,
Champ22,
Champ23,
Champ24,
Champ25,
Champ26,
Champ27,
Champ28,
Parent,
Date_Creation = (select(convert(datetime,convert(varchar(15),getdate(),103)))),
Num_Fct_Base=@CHRONO,
Ref_Constructeur,
Prix_Vente_Franc,
Prix_Vente_Euro,
Photo,
Marque,
Unite,
N_Famille_Produit,
Obsolete,
Poids,
Colisage,
Garantie,
Origine,
Delai,
CG_NUM_Vente_France,
CG_NUM_Vente_Export,
CG_NUM_Vente_CE,
N_Tva_Vente_France,
N_Tva_Vente_Export,
QteMini,
QteMaxi,
QteAppro,
DepotConsulter,
GestionStock,
CodeRubrique,
Nom_Fct_Base1,
Nom_Fct_Base2,
Nom_Fct_Base3, 
Descriptif,
Groupe,
@N_User,
@N_User
FROM FCT_BASE
WHERE n_fct_base = @N


DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT SCOPE_IDENTITY() )


INSERT INTO LFCT
(Man,
DESIGNATION,
Quantite,
Unite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fct_Base,
N_Produit,
V1,
V2,
V3,
V4,
V5,
V6,
V7,
V8,
V9,
V10,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Reference,
N_Position,
CodePoste,
Libre1,
StyleFonte ,
ColorFond,
ColorTexte,
Invisible,
numeric1,
numeric2,
check1,
check2,
date1,
date2,
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
,App_LigneId_Origine 
/* s{/App_LigneId Code=Insert /} */   
 )
SELECT
Man,
DESIGNATION,
Quantite,
Unite,
Prix_U_Franc,
Prix_U_Euro,
Remise,
Prix_Total_Franc,
Prix_Total_Euro,
N_Fct_Base=@NCOPIE,
N_Produit,
V1,
V2,
V3,
V4,
V5,
V6,
V7,
V8,
V9,
V10,
N_Rubrique,
Prix_U_Remise_Franc,
Prix_U_Remise_Euro,
Reference,
N_Position,
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
Libre2,
Libre3,
Libre4,
numeric3,
numeric4,
Fournisseur,
Marque
/* s{App_LigneId Code=Insert_Select /} */
,TypeFiche_Precedent = 117 
,N_Fiche_Precedent = @N
,N_Detail_Precedent = lfct.N_Ligne
,App_LigneId_Origine = '' 
/* s{/App_LigneId Code=Insert_Select /} */ 
FROM LFCT 
WHERE N_Fct_Base = @N


INSERT INTO DTarif_Fct_Base
(N_fct_base,
Prix_Vente_Franc,
N_Code_Tarif,
Prix_Vente_Euro )
SELECT
N_fct_base=@NCOPIE,
Prix_Vente_Franc,
N_Code_Tarif,
Prix_Vente_Euro 
FROM DTarif_Fct_Base
WHERE N_Fct_Base = @N

COMMIT












