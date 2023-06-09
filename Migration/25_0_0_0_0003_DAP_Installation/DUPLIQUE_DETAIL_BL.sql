ALTER PROCEDURE [dbo].[DUPLIQUE_DETAIL_BL]
@N int, @N_COPIE int
AS

DECLARE @N_SS_BL int
DECLARE @Designation varchar(50)
DECLARE @Ref_Produit varchar(30)
DECLARE @Qte numeric(18, 10)
DECLARE @Unite varchar(5)
DECLARE @N_Produit int
DECLARE @N_BL int
DECLARE @N_Cde_Client int
DECLARE @N_Fct_Base int
DECLARE @N_Depot int
DECLARE @PU_Franc numeric(18, 10)
DECLARE @PU_Euro numeric(18, 10)
DECLARE @Montant_Franc numeric(18, 10)
DECLARE @Montant_Euro numeric(18, 10)
DECLARE @Remise numeric(18, 10)
DECLARE @Tva numeric(18, 10)
DECLARE @Activite varchar(5)
DECLARE @N_Position int
DECLARE @Revient_Franc numeric(18, 10)
DECLARE @Revient_Euro numeric(18, 10)
DECLARE @N_LigneCli int
DECLARE @Texte varchar(max)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @N_LigneOrigine int
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte INT
DECLARE @numeric1 NUMERIC(18,10)
DECLARE @numeric2 NUMERIC(18,10)
DECLARE @date1 datetime
DECLARE @date2 datetime
DECLARE @check1 VARCHAR(3)
DECLARE @check2 VARCHAR(3)
DECLARE @Libre2 VARCHAR(100)
DECLARE @Libre3 VARCHAR(100)
DECLARE @Libre4 VARCHAR(100)
DECLARE @numeric3 NUMERIC(18,10)
DECLARE @numeric4 NUMERIC(18,10)
DECLARE @Fournisseur VARCHAR(50)
DECLARE @Marque VARCHAR (50)

DECLARE
    /* s{App_LigneId Code=Declare /} */
    @App_LigneId_Origine varchar(50)
    /* s{/App_LigneId Code=Declare /} */ 
    
DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des BL */


FOR
SELECT
Designation, Texte, Ref_Produit, Qte, Unite, N_Produit, N_BL, N_Cde_Client, N_Fct_Base,
N_Depot, PU_Franc, PU_Euro, Montant_Franc, Montant_Euro, Remise, Tva,
Activite, N_Position, Revient_Franc, Revient_Euro, N_LigneCli, CodePoste, Libre1, N_SS_BL, N_LigneOrigine,StyleFonte,ColorFond,ColorTexte,
numeric1, numeric2, date1, date2, check1, check2, Libre2, Libre3, Libre4, numeric3, numeric4, Fournisseur, Marque
/* s{App_LigneId Code=Cursor_Select /} */
, App_LigneId_Origine = App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Select /} */ 
FROM SS_BL 
WHERE N_BL = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Designation, @texte, @Ref_Produit, @Qte, @Unite, @N_Produit, @N_BL, @N_Cde_Client, @N_Fct_Base,
@N_Depot, @PU_Franc, @PU_Euro, @Montant_Franc, @Montant_Euro, @Remise, @Tva,
@Activite, @N_Position, @Revient_Franc, @Revient_Euro, @N_LigneCli, @CodePoste, @Libre1, @N_SS_BL, @N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */ 

WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SS_BL
(
    N_BL
   ,Designation
   ,Texte
   ,Ref_Produit
   ,Qte
   ,Unite
   ,N_Produit
   ,N_Cde_Client
   ,N_Fct_Base
   ,N_Depot
   ,PU_Franc
   ,PU_Euro
   ,Montant_Franc
   ,Montant_Euro
   ,Remise
   ,Tva
   ,Activite
   ,N_Position
   ,Revient_Franc
   ,Revient_Euro
   ,N_LigneCli
   ,CodePoste
   ,Libre1
   ,N_LigneOrigine
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
    /* s{App_LigneId Code=Insert /} */
    ,TypeFiche_Precedent 
    ,N_Fiche_Precedent
    ,N_Detail_Precedent 
    ,App_LigneId_Origine 
	/* s{/App_LigneId Code=Insert /} */   
)
SELECT
    N_BL = @N_COPIE
   ,Designation = @Designation
   ,Texte = @Texte
   ,Ref_Produit = @Ref_Produit
   ,Qte = @Qte
   ,Unite = @Unite
   ,N_Produit = @N_Produit
   ,N_Cde_Client = @N_Cde_Client
   ,N_Fct_Base = @N_Fct_Base
   ,N_Depot = @N_Depot
   ,PU_Franc = @PU_Franc
   ,PU_Euro = @PU_Euro
   ,Montant_Franc = @Montant_Franc
   ,Montant_Euro = @Montant_Euro
   ,Remise = @Remise
   ,Tva = @Tva
   ,Activite = @Activite
   ,N_Position = @N_Position
   ,Revient_Franc = @Revient_Franc
   ,Revient_Euro = @Revient_Euro
   ,N_LigneCli = @N_LigneCli
   ,CodePoste = @CodePoste
   ,Libre1 = @Libre1
   ,N_LigneOrigine = @N_SS_BL
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
   /* s{App_LigneId Code=Insert_Select /} */
   ,TypeFiche_Precedent = 103
   ,N_Fiche_Precedent = @N
   ,N_Detail_Precedent = @N_SS_BL
   ,App_LigneId_Origine = @App_LigneId_Origine
   /* s{/App_LigneId Code=Insert_Select /} */  


FETCH NEXT FROM @CursorVar
INTO  @Designation, @Texte, @Ref_Produit, @Qte, @Unite, @N_Produit, @N_BL, @N_Cde_Client, @N_Fct_Base,
@N_Depot, @PU_Franc, @PU_Euro, @Montant_Franc, @Montant_Euro, @Remise, @Tva,
@Activite, @N_Position, @Revient_Franc, @Revient_Euro, @N_LigneCli, @CodePoste, @Libre1,@N_SS_BL, @N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte,
@numeric1, @numeric2, @date1, @date2, @check1, @check2, @Libre2, @Libre3, @Libre4, @numeric3, @numeric4, @Fournisseur, @Marque
/* s{App_LigneId Code=Cursor_Variable /} */
, @App_LigneId_Origine
 /* s{/App_LigneId Code=Cursor_Variable /} */
END

CLOSE @CursorVar
DEALLOCATE @CursorVar















GO
