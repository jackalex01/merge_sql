ALTER TRIGGER [STOCK_CDE_CLI_UPDATE] ON [dbo].[LIGNECLI] 
FOR UPDATE
AS

DECLARE 
     @N_Produit INT
   , @N_ProduitOld INT
   , @N_Fct_Base INT
   , @N_Fct_BaseOld INT
   , @N_Ligne_Maitre INT
   , @N_Ligne_MaitreOld INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @N_Document INT
   , @Qte numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @GestionStockOld varchar(3)
   , @GestionStock varchar(3)
   , @Designation varchar(50)
   , @Ref varchar(30)
   , @DesignationOld varchar(50)
   , @RefOld varchar(30)
   , @Recap_Livraison BIT = 0 
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

DECLARE STOCK_CDE_CLI_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT 
      N_Produit = i.N_Prod
    , N_Fct_Base = i.N_Fct_Base
    , N_Ligne_Maitre = i.N_Ligne_Maitre
    , N_Document = i.N_Cde_Cli
    , N_Depot = i.N_Depot
    , Qte = i.Quantite
    , Ref = i.Reference
    , Designation = i.Designation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent = 104
    , N_Fiche_Precedent = i.N_Cde_Cli
    , N_Detail_Precedent = i.N_Lignecli
    , App_LigneId = i.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
    
    , N_ProduitOld = d.N_Prod
    , N_Fct_BaseOld = d.N_Fct_Base
    , N_Ligne_MaitreOld = d.N_Ligne_Maitre
    , N_DepotOld = d.N_Depot
    , QteOld = d.Quantite
    , RefOld = d.Reference
    , DesignationOld = d.Designation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent_Old = 104
    , N_Fiche_Precedent_Old = d.N_Cde_Cli
    , N_Detail_Precedent_Old = d.N_Lignecli
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */

FROM INSERTED i
LEFT OUTER JOIN DELETED d ON  i.N_Lignecli = d.N_Lignecli


OPEN STOCK_CDE_CLI_UPDATE_Cursor
FETCH FROM STOCK_CDE_CLI_UPDATE_Cursor INTO 
      @N_Produit
    , @N_Fct_Base
    , @N_Ligne_Maitre
    , @N_Document
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId  
    /* s{/App_LigneId Code=Cursor_Variable /} */

    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_Ligne_MaitreOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
     /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
    /* s{/App_LigneId Code=Cursor_Variable /} */
WHILE @@FETCH_STATUS = 0
BEGIN

    IF( ( @N_Produit > 0 )OR( @N_ProduitOld > 0 )OR( @N_Fct_Base > 0 )OR( @N_Fct_BaseOld > 0 )OR
    (( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' ))OR
    (( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' ))
    /* s{App_LigneId Code=If /} */
    OR (@App_LigneId_Old <> @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */ 
    )
    BEGIN
        SET @Recap_Livraison = 1 
    END


    /*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
    produit ou de fonction de base*/
    IF NOT (( @N_ProduitOld = @N_Produit )AND
    ( @N_Fct_BaseOld = @N_Fct_Base )AND
    ( @N_Ligne_MaitreOld = @N_Ligne_Maitre )AND
    (@QteOld = @Qte )AND( @N_Depot = @N_DepotOld) 
    /* s{App_LigneId Code=If /} */
    AND (@App_LigneId_Old = @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */    
    ) 
    BEGIN
        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF((( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )AND((@N_Ligne_MaitreOld = 0 )OR(@N_Ligne_MaitreOld IS NULL )) )
        BEGIN

            IF( @N_ProduitOld > 0 )
            BEGIN
                SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
            END
            
            IF( @N_Fct_BaseOld > 0 ) 
            BEGIN
                SET @GestionStockOld = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_BaseOld )
            END

            INSERT INTO MVTS_STOCK
            (
                 N_Depot
               , N_Produit
               , N_Fct_Base
               , N_Document
               , Qte_cde_client
               , Origine
               , Operation
               , TestIntegrite
               , GestionStock
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
               , N_Fct_Base = @N_Fct_BaseOld
               , N_Document = @N_Document
               , Qte_cde_client = -@QteOld
               , Origine = 'CC'
               , Operation = 'AUT'
               , TestIntegrite = 'Non'
               , GestionStock = @GestionStockOld
                 /* s{App_LigneId Code=Insert_Select /} */
               , TypeFiche_Precedent = @TypeFiche_Precedent_Old
               , N_Fiche_Precedent = @N_Fiche_Precedent_Old
               , N_Detail_Precedent = @N_Detail_Precedent_Old
               , App_LigneId_Origine = @App_LigneId_Old
                 /* s{/App_LigneId Code=Insert_Select /} */   


        END


        /*la nouvelle valeur concerne un produit ou une fct de base*/
        IF((( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )AND((@N_Ligne_Maitre = 0 )OR(@N_Ligne_Maitre IS NULL )) )
        BEGIN

            IF( @N_Produit > 0 )
            BEGIN
                SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
            END
            
            IF( @N_Fct_BaseOld > 0 ) 
            BEGIN
                SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )
            END 
            
            INSERT INTO MVTS_STOCK
            (
                  N_Depot
                , N_Produit
                , N_Fct_Base
                , N_Document
                , Qte_cde_client
                , Origine
                , Operation
                , TestIntegrite
                , GestionStock
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
                , N_Fct_Base = @N_Fct_Base
                , N_Document = @N_Document
                , Qte_cde_client = @Qte
                , Origine = 'CC'
                , Operation = 'AUT'
                , TestIntegrite = 'Oui'
                , GestionStock = @GestionStock
                /* s{App_LigneId Code=Insert_Select /} */
                , TypeFiche_Precedent = @TypeFiche_Precedent
                , N_Fiche_Precedent = @N_Fiche_Precedent
                , N_Detail_Precedent = @N_Detail_Precedent
                , App_LigneId_Origine = @App_LigneId
                /* s{/App_LigneId Code=Insert_Select /} */ 
        END
    END
    
	FETCH NEXT FROM STOCK_CDE_CLI_UPDATE_Cursor INTO
      @N_Produit
    , @N_Fct_Base
    , @N_Ligne_Maitre
    , @N_Document
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId  
    /* s{/App_LigneId Code=Cursor_Variable /} */

    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_Ligne_MaitreOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
     /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
    /* s{/App_LigneId Code=Cursor_Variable /} */
END

CLOSE STOCK_CDE_CLI_UPDATE_Cursor
DEALLOCATE STOCK_CDE_CLI_UPDATE_Cursor


/*                                                                  
================================================
 -> Récap Livraison
================================================
*/
IF @Recap_Livraison = 1 
BEGIN
    EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Document
END



