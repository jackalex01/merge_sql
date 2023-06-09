ALTER TRIGGER [dbo].[STOCK_CDE_FOUR_DELETE] ON [dbo].[SCD_FOUR] 
FOR DELETE
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

DECLARE STOCK_CDE_FOUR_DELETE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = d.N_Prod   
    , N_Document = d.N_Cde_Four  
    , Qte = d.Quantite         
    , N_Depot = d.N_Depot     
    , Ref = d.Ref	     
    , Designation = d.Designation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 112
    , N_Fiche_Precedent = d.N_Cde_Four
    , N_Detail_Precedent = d.N_Scd_Four
    , App_LigneId = d.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
From deleted d

OPEN STOCK_CDE_FOUR_DELETE_Cursor
FETCH FROM STOCK_CDE_FOUR_DELETE_Cursor INTO 
      @N_Produit
    , @N_Document
    , @Qte
    , @N_Depot
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
        /*met à jour le champ cde complètement livrée*/
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
            SET @GestionStock = ISNULL((SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit ) , 'Non')
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
            , Qte_cde_fournisseur = -@Qte
            , Origine = 'CF'
            , Operation = 'SUP'
            , TestIntegrite = 'Oui'
            , GestionStock = @GestionStock 
              /* s{App_LigneId Code=Insert_Select /} */
            , TypeFiche_Precedent = @TypeFiche_Precedent
            , N_Fiche_Precedent = @N_Fiche_Precedent
            , N_Detail_Precedent = @N_Detail_Precedent
            , App_LigneId_Origine = @App_LigneId
              /* s{/App_LigneId Code=Insert_Select /} */   

    END
   
	FETCH NEXT FROM STOCK_CDE_FOUR_DELETE_Cursor INTO
      @N_Produit
    , @N_Document
    , @Qte
    , @N_Depot
    , @Ref
    , @Designation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
END

CLOSE STOCK_CDE_FOUR_DELETE_Cursor
DEALLOCATE STOCK_CDE_FOUR_DELETE_Cursor


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
