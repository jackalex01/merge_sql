ALTER TRIGGER [STOCK_FACT_CLI_INSERT] ON dbo.Sfct_cli 
FOR INSERT
AS
DECLARE 
     @N_Produit INT
   , @N_Fct_Base INT
   , @N_Document INT
   , @Qte numeric(18 ,10)
   , @N_Depot INT
   , @N_BL INT
   , @GestionStock varchar(3)
   , @CoefAvoir numeric(18 ,10)
   , @N_fact_Cli INT
   , @Stock_Liste_Info varchar(max)
   , @Stock_Preparation varchar(3)
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 
   
 
DECLARE STOCK_FACT_CLI_INSERT_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
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
From inserted i
 
OPEN STOCK_FACT_CLI_INSERT_Cursor
FETCH FROM STOCK_FACT_CLI_INSERT_Cursor INTO 
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
WHILE @@FETCH_STATUS = 0
BEGIN
    --gestion des avoirs
    SET @CoefAvoir = (CASE WHEN IsNull((SELECT UPPER(IsNull(Avoir,'Non')) FROM FACT_CLI FAC WHERE FAC.N_fact_Cli=@N_fact_Cli),'NON')='OUI'
	              THEN -1 ELSE 1 END)
 
    SET @Qte=@Qte * @CoefAvoir
 
    IF( @N_BL > 0 )
    BEGIN
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
 
	FETCH NEXT FROM STOCK_FACT_CLI_INSERT_Cursor INTO
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
END
 
CLOSE STOCK_FACT_CLI_INSERT_Cursor
DEALLOCATE STOCK_FACT_CLI_INSERT_Cursor
