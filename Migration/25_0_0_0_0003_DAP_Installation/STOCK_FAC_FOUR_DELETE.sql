ALTER TRIGGER [dbo].[STOCK_FAC_FOUR_DELETE] ON [dbo].[Sfacfour] 
FOR DELETE
AS
 
DECLARE 
     @N_Produit INT
   , @N_Document INT
   , @Qte numeric(18 ,10)
   , @N_Depot INT
   , @N_BR INT
   , @GestionStock varchar(3)
   , @Stock_Liste_Info varchar(max)
   , @Stock_Preparation varchar(3)
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 
 
 
DECLARE STOCK_FAC_FOUR_DELETE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = d.N_Produit
    , N_Document = d.N_Fac_Four
    , N_Depot = d.N_Depot
    , N_BR = d.N_BR
    , Qte = d.Quantite
    , Stock_Liste_Info = d.Stock_Liste_Info
    , Stock_Preparation = d.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 113
    , N_Fiche_Precedent = d.N_Fac_Four
    , N_Detail_Precedent = d.N_Sfacfour
    , App_LigneId = d.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
From deleted d
 
OPEN STOCK_FAC_FOUR_DELETE_Cursor
FETCH FROM STOCK_FAC_FOUR_DELETE_Cursor INTO 
      @N_Produit
    , @N_Document
    , @N_Depot
    , @N_BR
    , @Qte
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
WHILE @@FETCH_STATUS = 0
BEGIN
 
    /*Calcul du dernier Prix d'achat*/
    IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 
    BEGIN
        EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
    END
 
    IF( @N_BR > 0 )
    BEGIN
        IF( @N_Produit > 0 )
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
                , Qte_BR
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
                , Qte_BR = @Qte
                , Origine = 'FF'
                , Operation = 'AUT'
                , TestIntegrite = 'Oui'
                , GestionStock = @GestionStock
                , Stock_Liste_Info = @Stock_Liste_Info
                , Stock_Preparation = @Stock_Preparation
                  /* s{App_LigneId Code=Insert_Select /} */
                , TypeFiche_Precedent = @TypeFiche_Precedent
                , N_Fiche_Precedent = @N_Fiche_Precedent
                , N_Detail_Precedent = @N_Detail_Precedent
                , App_LigneId_Origine = @App_LigneId
                  /* s{/App_LigneId Code=Insert_Select /} */  
 
        END
    END
 
	FETCH NEXT FROM STOCK_FAC_FOUR_DELETE_Cursor INTO
      @N_Produit
    , @N_Document
    , @N_Depot
    , @N_BR
    , @Qte
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
END
 
CLOSE STOCK_FAC_FOUR_DELETE_Cursor
DEALLOCATE STOCK_FAC_FOUR_DELETE_Cursor
 
 
 
 
 
GO
