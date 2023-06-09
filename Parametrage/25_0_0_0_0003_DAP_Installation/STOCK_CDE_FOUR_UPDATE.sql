ALTER TRIGGER [STOCK_CDE_FOUR_UPDATE] ON [dbo].[SCD_FOUR] 
FOR UPDATE
AS

DECLARE 
     @N_Produit INT
   , @N_ProduitOld INT
   , @N_Document INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @Qte numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @GestionStock varchar(3)
   , @GestionStockOld varchar(3)
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


DECLARE STOCK_CDE_FOUR_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT 
      N_Produit = i.N_Prod
    , N_Document = i.N_Cde_Four
    , N_Depot = i.N_Depot
    , Qte = i.Quantite
    , Ref = i.Ref
    , Designation = i.Designation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent = 112
    , N_Fiche_Precedent = i.N_Cde_Four
    , N_Detail_Precedent = i.N_Scd_Four
    , App_LigneId = i.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
    
    , N_ProduitOld = d.N_Prod
    , N_DepotOld = d.N_Depot
    , QteOld = d.Quantite
    , RefOld = d.Ref
    , DesignationOld = d.Designation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent_Old = 112
    , N_Fiche_Precedent_Old = d.N_Cde_Four
    , N_Detail_Precedent_Old = d.N_Scd_Four
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */

FROM INSERTED i
LEFT OUTER JOIN DELETED d ON  i.N_Scd_Four = d.N_Scd_Four


OPEN STOCK_CDE_FOUR_UPDATE_Cursor
FETCH FROM STOCK_CDE_FOUR_UPDATE_Cursor INTO 
     @N_Produit
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

    IF( ( @N_Produit > 0 )OR( @N_ProduitOld > 0 )OR
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
    produit: on ne gère que le dernier Prix d'achat*/
    IF NOT (( @N_ProduitOld = @N_Produit )AND
    (@QteOld = @Qte )AND( @N_DepotOld = @N_Depot)
    /* s{App_LigneId Code=If /} */
    AND (@App_LigneId_Old = @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */    
    ) 
    BEGIN


        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF( @N_ProduitOld > 0 )
        BEGIN

            /*Calcul du dernier Prix d'achat*/
            IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 
            BEGIN
                EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_ProduitOld
            END

            IF( @N_ProduitOld > 0 ) 
            BEGIN
                SET @GestionStockOld = ISNULL( ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld ) , 'Non')
            END

            INSERT INTO MVTS_STOCK
            (
                 N_Depot
               , N_Produit
               , N_Fct_Base
               , N_Document
               , Qte_cde_fournisseur
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
               , N_Fct_Base = 0
               , N_Document = @N_Document
               , Qte_cde_fournisseur = -@QteOld
               , Origine = 'CF'
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
        IF( @N_Produit > 0 )
        BEGIN

            /*Calcul du dernier Prix d'achat*/
            IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0
            BEGIN
                EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit    
            END

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
               , Qte_cde_fournisseur
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
               , N_Fct_Base = 0
               , N_Document = @N_Document
               , Qte_cde_fournisseur = @Qte
               , Origine = 'CF'
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
    ELSE
    BEGIN
       /*Calcul du dernier Prix d'achat*/
        IF( @N_Produit > 0 )  
        BEGIN
            EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
        END
    END

	FETCH NEXT FROM STOCK_CDE_FOUR_UPDATE_Cursor INTO
      @N_Produit
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

CLOSE STOCK_CDE_FOUR_UPDATE_Cursor
DEALLOCATE STOCK_CDE_FOUR_UPDATE_Cursor


/*                                                                  
================================================
 -> Récap Livraison
================================================
*/
IF @Recap_Livraison = 1 
BEGIN
    EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Document
END


