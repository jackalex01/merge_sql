ALTER PROCEDURE [DUPLIQUE_DETAIL_BL]
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
DECLARE @Texte varchar(8000)
DECLARE @CodePoste varchar(50)
DECLARE @Libre1 varchar(100)
DECLARE @N_LigneOrigine int
DECLARE @StyleFonte int
DECLARE @ColorFond int
DECLARE @ColorTexte int

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC

/* boucle pour dupliquer le détail des BL */


FOR
SELECT
Designation, Texte, Ref_Produit, Qte, Unite, N_Produit, N_BL, N_Cde_Client, N_Fct_Base,
N_Depot, PU_Franc, PU_Euro, Montant_Franc, Montant_Euro, Remise, Tva,
Activite, N_Position, Revient_Franc, Revient_Euro, N_LigneCli, CodePoste, Libre1, N_SS_BL, N_LigneOrigine,StyleFonte,ColorFond,ColorTexte
FROM SS_BL 
WHERE N_BL = @N
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @Designation, @texte, @Ref_Produit, @Qte, @Unite, @N_Produit, @N_BL, @N_Cde_Client, @N_Fct_Base,
@N_Depot, @PU_Franc, @PU_Euro, @Montant_Franc, @Montant_Euro, @Remise, @Tva,
@Activite, @N_Position, @Revient_Franc, @Revient_Euro, @N_LigneCli, @CodePoste, @Libre1, @N_SS_BL, @N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte


WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO SS_BL
(N_BL, Designation, Texte, Ref_Produit, Qte, Unite, N_Produit, N_Cde_Client, N_Fct_Base,
N_Depot, PU_Franc, PU_Euro, Montant_Franc, Montant_Euro, Remise, Tva,
Activite, N_Position, Revient_Franc, Revient_Euro, N_LigneCli, CodePoste, Libre1, N_LigneOrigine,StyleFonte,ColorFond,ColorTexte
)
VALUES
(@N_COPIE, @Designation, @Texte, @Ref_Produit, @Qte, @Unite, @N_Produit, @N_Cde_Client, @N_Fct_Base,
@N_Depot, @PU_Franc, @PU_Euro, @Montant_Franc, @Montant_Euro, @Remise, @Tva,
@Activite, @N_Position, @Revient_Franc, @Revient_Euro, @N_LigneCli, @CodePoste, @Libre1,@N_SS_BL,@StyleFonte,@ColorFond,@ColorTexte)


FETCH NEXT FROM @CursorVar
INTO  @Designation, @Texte, @Ref_Produit, @Qte, @Unite, @N_Produit, @N_BL, @N_Cde_Client, @N_Fct_Base,
@N_Depot, @PU_Franc, @PU_Euro, @Montant_Franc, @Montant_Euro, @Remise, @Tva,
@Activite, @N_Position, @Revient_Franc, @Revient_Euro, @N_LigneCli, @CodePoste, @Libre1,@N_SS_BL, @N_LigneOrigine,@StyleFonte,@ColorFond,@ColorTexte

END

CLOSE @CursorVar
DEALLOCATE @CursorVar










