ALTER TRIGGER [dbo].[STOCK_FACT_CLI_UPDATE] ON [dbo].[Sfct_cli] 
FOR UPDATE
AS
DECLARE 
     @N_Produit INT
   , @N_ProduitOld INT
   , @N_Fct_Base INT
   , @N_Fct_BaseOld INT
   , @N_BL INT
   , @N_BLOld INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @N_Document INT
   , @Qte numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @GestionStock varchar(3)
   , @GestionStockOld varchar(3)
   , @CoefAvoir Numeric(18 ,10)
   , @N_fact_Cli INT
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
   
 
DECLARE STOCK_FACT_CLI_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = i.N_Produit
    , N_Fct_Base = i.N_Fct_Base
    , N_BL = i.N_BL
    , N_Document = i.N_Fact_Cli
    , N_Depot = i.N_Depot
    , Qte = i.Quantite
    , N_fact_Cli = i.N_fact_Cli
    , Stock_Liste_Info = i.Stock_Liste_Info
    , Stock_Preparation = i.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 105
    , N_Fiche_Precedent = i.N_Fact_cli
    , N_Detail_Precedent = i.N_SFact_Cli
    , App_LigneId = i.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
 
    , N_ProduitOld = d.N_Produit
    , N_Fct_BaseOld = d.N_Fct_Base
    , N_BLOld = d.N_BL
    , N_DepotOld = d.N_Depot
    , QteOld = d.Quantite
    , Stock_Liste_Info_Old = d.Stock_Liste_Info
    , Stock_Preparation_Old = d.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent_Old = 105
    , N_Fiche_Precedent_Old = d.N_Fact_cli
    , N_Detail_Precedent_Old = d.N_SFact_Cli
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
From inserted i 
LEFT OUTER JOIN Deleted d on i.N_SFact_Cli = d.N_SFact_Cli
 
OPEN STOCK_FACT_CLI_UPDATE_Cursor
FETCH FROM STOCK_FACT_CLI_UPDATE_Cursor INTO 
      @N_Produit
    , @N_Fct_Base
    , @N_BL
    , @N_Document
    , @N_Depot
    , @Qte
    , @N_fact_Cli
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_BLOld
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
    --gestion des avoirs
    SET @CoefAvoir = (CASE WHEN IsNull((SELECT UPPER(IsNull(Avoir,'Non')) FROM FACT_CLI FAC WHERE FAC.N_fact_Cli=@N_fact_Cli),'NON')='OUI'
	              THEN -1 ELSE 1 END)
 
    SET @Qte=@Qte * @CoefAvoir
    SET @QteOld=@QteOld * @CoefAvoir
 
    /*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
    produit ou de fonction de base*/
    IF NOT (( @N_ProduitOld = @N_Produit )AND
    ( @N_Fct_BaseOld = @N_Fct_Base )AND
    (@QteOld = @Qte )AND( @N_Depot = @N_DepotOld)AND( @N_BL = @N_BLOld )) 
    BEGIN
 
        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF( @N_BLOld > 0 )
        BEGIN
            IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
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
                   , Qte_BL
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
                   , N_Fct_Base = @N_Fct_BaseOld
                   , N_Document = @N_Document
                   , Qte_BL = @QteOld
                   , Origine = 'FC'
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
        ELSE
        BEGIN
            --ajout pour mvts stock sur facture sans BL pour produits ---
            --IF( @N_BLOld = 0 )
            IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
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
                   , Qte_Stock
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
                   , N_Fct_Base = @N_Fct_BaseOld
                   , N_Document = @N_Document
                   , Qte_Stock = @QteOld
                   , Origine = 'FC'
                   , Operation = 'AUT'
                   , TestIntegrite = 'Non'
                   , GestionStock = @GestionStockOld
                   , Stock_Liste_Info =@Stock_Liste_Info_Old
                   , Stock_Preparation =@Stock_Preparation_Old
                     /* s{App_LigneId Code=Insert_Select /} */
                   , TypeFiche_Precedent = @TypeFiche_Precedent_Old
                   , N_Fiche_Precedent = @N_Fiche_Precedent_Old
                   , N_Detail_Precedent = @N_Detail_Precedent_Old
                   , App_LigneId_Origine = @App_LigneId_Old
                     /* s{/App_LigneId Code=Insert_Select /} */
            END
        END
 
 
        IF( @N_BL > 0 )
        BEGIN
            /*la nouvelle valeur concerne un produit ou une fct de base*/
            IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
            BEGIN
                IF( @N_Produit > 0 ) 
                BEGIN
                    SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
                END
                
                IF( @N_Fct_Base > 0 )
                BEGIN
                    SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )
                END
                
                INSERT INTO MVTS_STOCK
                (
                     N_Depot
                   , N_Produit
                   , N_Fct_Base
                   , N_Document
                   , Qte_BL
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
                   , N_Fct_Base = @N_Fct_Base
                   , N_Document = @N_Document
                   , Qte_BL = -@Qte
                   , Origine = 'FC'
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
        ELSE
        BEGIN
            --ajout pour mvts stock sur facture sans BL pour produits ---
            --IF( @N_BL = 0 )
            /*la nouvelle valeur concerne un produit ou une fct de base*/
            IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
            BEGIN
                IF( @N_Produit > 0 )
                BEGIN
                    SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
                END
                
                IF( @N_Fct_Base > 0 ) 
                BEGIN
                    SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )
                END
 
                INSERT INTO MVTS_STOCK
                (
                     N_Depot
                   , N_Produit
                   , N_Fct_Base
                   , N_Document
                   , Qte_Stock
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
                   , N_Fct_Base = @N_Fct_Base
                   , N_Document = @N_Document
                   , Qte_Stock = -@Qte
                   , Origine = 'FC'
                   , Operation = 'AUT'
                   , TestIntegrite = 'Oui'
                   , GestionStock = @GestionStock
                   , Stock_Liste_Info =@Stock_Liste_Info
                   , Stock_Preparation =@Stock_Preparation
                     /* s{App_LigneId Code=Insert_Select /} */
                   , TypeFiche_Precedent = @TypeFiche_Precedent
                   , N_Fiche_Precedent = @N_Fiche_Precedent
                   , N_Detail_Precedent = @N_Detail_Precedent
                   , App_LigneId_Origine = @App_LigneId
                     /* s{/App_LigneId Code=Insert_Select /} */
            END
        END
    END
 
	FETCH NEXT FROM STOCK_FACT_CLI_UPDATE_Cursor INTO
      @N_Produit
    , @N_Fct_Base
    , @N_BL
    , @N_Document
    , @N_Depot
    , @Qte
    , @N_fact_Cli
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_BLOld
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
 
CLOSE STOCK_FACT_CLI_UPDATE_Cursor
DEALLOCATE STOCK_FACT_CLI_UPDATE_Cursor
 
 
 
 
 
 
GO
