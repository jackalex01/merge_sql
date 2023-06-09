ALTER PROCEDURE [dbo].[SORTIE_STOCK_PRODUITS_POUR_OF]
@N_Document int, 
@N_Depot int, 
@N_Fct_Base int, 
@QteFctBase numeric(18,10), 
@sens numeric(18,10),
@TestIntegrite varchar(3),
@Stock_Liste_Info varchar(max) = '',
@Stock_Preparation varchar(3) = 'Non'
 AS

DECLARE 
     @quantite numeric(18 ,10)
   , @N_Produit INT
   , @GestionStock varchar(3)
   , @CursorVar CURSOR
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 

SET @CursorVar = CURSOR SCROLL DYNAMIC
FOR
select
quantite,
N_Produit
/* s{App_LigneId Code=Cursor_Select /} */
, TypeFiche_Precedent = 108
, N_Fiche_Precedent = @N_Document
, N_Detail_Precedent = l.N_Ligne
, App_LigneId = l.App_LigneId
/* s{/App_LigneId Code=Cursor_Select /} */ 
from lfct L
where ( L.n_fct_base = @N_Fct_Base )AND
( L.N_Produit > 0 )AND
( L.Quantite > 0.00 )

OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @quantite, @N_produit
/* s{App_LigneId Code=Cursor_Variable /} */
, @TypeFiche_Precedent
, @N_Fiche_Precedent
, @N_Detail_Precedent
, @App_LigneId
/* s{/App_LigneId Code=Cursor_Variable /} */ 
WHILE @@FETCH_STATUS = 0
BEGIN

    IF( @N_Produit > 0 ) 
    BEGIN
        SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
    END

    INSERT INTO MVTS_STOCK
    (
         N_Depot
       , N_Produit
       , N_Fct_Base
       , N_Document
       , Qte_Stock
       , Qte_OF
       , Origine
       , Operation
       , TestIntegrite
       , GestionStock
       , Stock_Liste_Info
       , Stock_Preparation
         /* s{App_LigneId Code=Insert /} */
       , TypeFiche_Precedent
       , N_Fiche_Precedent
       , N_Detail_Precedent
       , App_LigneId_Origine 
         /* s{/App_LigneId Code=Insert /} */   
    )
    SELECT
         N_Depot = @N_Depot
       , N_Produit = @N_Produit
       , N_Fct_Base = 0
       , N_Document = @N_Document
       , Qte_Stock = @sens * @quantite * @QteFctBase
       , Qte_OF = -@sens * @quantite * @QteFctBase
       , Origine = 'OF'
       , Operation = 'AUT'
       , TestIntegrite = @TestIntegrite
       , GestionStock = @GestionStock 
       , Stock_Liste_Info = @Stock_Liste_Info
       , Stock_Preparation = @Stock_Preparation
         /* s{App_LigneId Code=Insert_Select /} */
       , TypeFiche_Precedent = @TypeFiche_Precedent
       , N_Fiche_Precedent = @N_Fiche_Precedent
       , N_Detail_Precedent = @N_Detail_Precedent
       , App_LigneId_Origine = @App_LigneId
         /* s{/App_LigneId Code=Insert_Select /} */  

    FETCH NEXT FROM @CursorVar
    INTO @quantite, @N_produit
    /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
    /* s{/App_LigneId Code=Cursor_Variable /} */ 
END
CLOSE @CursorVar
DEALLOCATE @CursorVar












GO
