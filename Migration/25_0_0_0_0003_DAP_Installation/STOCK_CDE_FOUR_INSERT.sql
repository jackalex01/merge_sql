ALTER TRIGGER [dbo].[STOCK_CDE_FOUR_INSERT] ON [dbo].[SCD_FOUR] 
FOR INSERT
AS

DECLARE 
     @N_Produit INT
   , @N_Document INT
   , @N_Depot INT
   , @Qte numeric(18 ,10)
   , @GestionStock varchar(3)
   , @Designation varchar(50)
   , @Ref varchar(30)
   , @Recap_Livraison BIT = 0 
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 

DECLARE STOCK_CDE_FOUR_INSERT_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR 
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
FROM INSERTED i


OPEN STOCK_CDE_FOUR_INSERT_Cursor
FETCH FROM STOCK_CDE_FOUR_INSERT_Cursor INTO 
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
WHILE @@FETCH_STATUS = 0
BEGIN

    IF( ( @N_Produit > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
    BEGIN
        SET @Recap_Livraison = 1 
    END

    IF( @N_Produit > 0 )
    BEGIN

        /*Calcul du dernier Prix d'achat*/
        IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0
        BEGIN
            EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
        END
        
        IF( @N_Produit > 0 ) 
        BEGIN
            SET @GestionStock = ISNULL( ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit ),'Non')
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

	FETCH NEXT FROM STOCK_CDE_FOUR_INSERT_Cursor INTO
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
END

CLOSE STOCK_CDE_FOUR_INSERT_Cursor
DEALLOCATE STOCK_CDE_FOUR_INSERT_Cursor


/*                                                                  
================================================
 -> Récap Livraison
================================================
*/
IF @Recap_Livraison = 1 
BEGIN
    EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Document
END



GO
