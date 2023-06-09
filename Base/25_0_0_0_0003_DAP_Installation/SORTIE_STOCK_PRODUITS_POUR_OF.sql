ALTER PROCEDURE [SORTIE_STOCK_PRODUITS_POUR_OF]
@N_Document int, 
@N_Depot int, 
@N_Fct_Base int, 
@QteFctBase numeric(18,10), 
@sens numeric(18,10),
@TestIntegrite varchar(3)
 AS

DECLARE 
@CursorVar CURSOR,
@quantite numeric(18,10),
@N_Produit int,
@GestionStock varchar(3)

SET @CursorVar = CURSOR SCROLL DYNAMIC
FOR
select
quantite,
N_Produit
from lfct L
where ( L.n_fct_base = @N_Fct_Base )AND
( L.N_Produit > 0 )AND
( L.Quantite > 0.00 )

OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @quantite, @N_produit
WHILE @@FETCH_STATUS = 0
BEGIN

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )

INSERT INTO
MVTS_STOCK( N_Depot, N_Produit, N_Fct_Base, N_Document, Qte_Stock, Qte_OF, Origine, Operation, TestIntegrite, GestionStock )
VALUES(@N_Depot, @N_Produit, 0, @N_Document, @sens*@quantite*@QteFctBase, -@sens*@quantite*@QteFctBase, 'OF', 'AUT', @TestIntegrite, @GestionStock )

    FETCH NEXT FROM @CursorVar
    INTO @quantite, @N_produit
END
CLOSE @CursorVar
DEALLOCATE @CursorVar









