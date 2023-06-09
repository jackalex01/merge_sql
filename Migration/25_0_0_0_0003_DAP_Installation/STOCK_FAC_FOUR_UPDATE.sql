ALTER TRIGGER [dbo].[STOCK_FAC_FOUR_UPDATE] ON [dbo].[Sfacfour] 
FOR UPDATE
AS
 
DECLARE 
     @N_Produit INT
   , @N_ProduitOld INT
   , @N_BR INT
   , @N_BROld INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @N_Document INT
   , @Qte numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @GestionStock varchar(3)
   , @GestionStockOld varchar(3)
   , @Stock_Liste_Info varchar(max)
   , @Stock_Preparation varchar(3)
   , @Stock_Liste_Info_Old varchar(max)
   , @Stock_Preparation_Old varchar(3)
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
   , @TypeFiche_Precedent_Old INT
   , @N_Fiche_Precedent_Old INT
   , @N_Detail_Precedent_Old INT
   , @App_LigneId_Old varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 
 
DECLARE STOCK_FAC_FOUR_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = i.N_Produit
    , N_BR = i.N_BR
    , N_Document = i.N_Fac_Four
    , N_Depot = i.N_Depot
    , Qte = i.Quantite
    , Stock_Liste_Info = i.Stock_Liste_Info
    , Stock_Preparation = i.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 113
    , N_Fiche_Precedent = i.N_Fac_Four
    , N_Detail_Precedent = i.N_Sfacfour
    , App_LigneId = i.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
 
    , N_ProduitOld = d.N_Produit
    , N_BROld = d.N_BR
    , N_DepotOld = d.N_Depot
    , QteOld = d.Quantite
    , Stock_Liste_Info_Old = d.Stock_Liste_Info
    , Stock_Preparation_Old = d.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent_Old = 113
    , N_Fiche_Precedent_Old = d.N_Fac_Four
    , N_Detail_Precedent_Old = d.N_Sfacfour
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
From inserted i 
left outer join deleted d on i.N_Sfacfour = d.n_Sfacfour
 
OPEN STOCK_FAC_FOUR_UPDATE_Cursor
FETCH FROM STOCK_FAC_FOUR_UPDATE_Cursor INTO 
      @N_Produit
    , @N_BR
    , @N_Document
    , @N_Depot
    , @Qte
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_ProduitOld
    , @N_BROld
    , @N_DepotOld
    , @QteOld
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
WHILE @@FETCH_STATUS = 0
BEGIN
 
    /*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
    produit ou de fonction de base*/
    IF NOT (( @N_ProduitOld = @N_Produit )AND
    (@QteOld = @Qte )AND( @N_Depot = @N_DepotOld)AND( @N_BR = @N_BROld )
    /* s{App_LigneId Code=If /} */
    AND (@App_LigneId_Old = @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */
    ) 
    BEGIN
 
        /*Calcul du dernier Prix d'achat*/
        IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 
        BEGIN
            EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
        END
 
        /*Calcul du dernier Prix d'achat*/
        IF( @N_ProduitOld <> @N_produit )AND( @N_ProduitOld > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 
        BEGIN
            EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_ProduitOld
        END
 
 
        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF( @N_BROld > 0 )
        BEGIN
            IF( @N_ProduitOld > 0 )
            BEGIN
                IF( @N_ProduitOld > 0 ) 
                BEGIN
                    SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
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
                     N_Depot = @N_DepotOld
                   , N_Produit = @N_ProduitOld
                   , N_Fct_Base = 0
                   , N_Document = @N_Document
                   , Qte_BR = @QteOld
                   , Origine = 'FF'
                   , Operation = 'AUT'
                   , TestIntegrite = 'Non'
                   , GestionStock = @GestionStockOld
                   , Stock_Liste_Info = @Stock_Liste_Info_Old
                   , Stock_Preparation = @Stock_Preparation_Old
                     /* s{App_LigneId Code=Insert_Select /} */
                   , TypeFiche_Precedent = @TypeFiche_Precedent_Old
                   , N_Fiche_Precedent = @N_Fiche_Precedent_Old
                   , N_Detail_Precedent = @N_Detail_Precedent_Old
                   , App_LigneId_Origine = @App_LigneId_Old
                     /* s{/App_LigneId Code=Insert_Select /} */
 
            END
        END
 
        IF( @N_BR > 0 )
        BEGIN
            /*la nouvelle valeur concerne un produit ou une fct de base*/
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
                   , Qte_BR = -@Qte
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
    END
    ELSE
    BEGIN
        /*Calcul du dernier Prix d'achat*/
        IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 
        BEGIN
            EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
        END        
    END 
	FETCH NEXT FROM STOCK_FAC_FOUR_UPDATE_Cursor INTO
      @N_Produit
    , @N_BR
    , @N_Document
    , @N_Depot
    , @Qte
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_ProduitOld
    , @N_BROld
    , @N_DepotOld
    , @QteOld
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
END
 
CLOSE STOCK_FAC_FOUR_UPDATE_Cursor
DEALLOCATE STOCK_FAC_FOUR_UPDATE_Cursor
 
 
 
 
GO
