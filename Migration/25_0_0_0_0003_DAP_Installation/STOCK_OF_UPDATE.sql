ALTER TRIGGER [dbo].[STOCK_OF_UPDATE] ON [dbo].[ORDREF] 
FOR UPDATE
AS
 
DECLARE 
     @Simuler varchar(3)
   , @SimulerOld varchar(3)
   , @N_Fct_Base INT
   , @N_Fct_BaseOld INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @Qte numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @N_Document INT
   , @N_DocumentOld INT
   , @Num_OF INT
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
 
DECLARE STOCK_OF_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Fct_Base = i.N_Fct_Base
    , Simuler = i.Simuler
    , N_Depot = i.N_Depot
    , Qte = i.Qte
    , N_Document = i.N_OF
    , Num_OF = i.Num_OF
    , Stock_Liste_Info = i.Stock_Liste_Info
    , Stock_Preparation = i.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 108
    , N_Fiche_Precedent = i.N_OF
    , N_Detail_Precedent = i.N_Fct_Base
    , App_LigneId = ''
      /* s{/App_LigneId Code=Cursor_Select /} */ 
 
    , N_Fct_BaseOld = d.N_Fct_Base
    , SimulerOld = d.Simuler
    , N_DepotOld = d.N_Depot
    , QteOld = d.Qte
    , N_DocumentOld = d.N_OF
    , Stock_Liste_Info = d.Stock_Liste_Info
    , Stock_Preparation = d.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent_Old = 108
    , N_Fiche_Precedent_Old = d.N_OF
    , N_Detail_Precedent_Old = d.N_Fct_Base
    , App_LigneId_Old = ''
      /* s{/App_LigneId Code=Cursor_Select /} */ 
From inserted i 
LEFT OUTER JOIN Deleted d on i.N_OF = d.N_OF
 
OPEN STOCK_OF_UPDATE_Cursor
FETCH FROM STOCK_OF_UPDATE_Cursor INTO 
      @N_Fct_Base
    , @Simuler
    , @N_Depot
    , @Qte
    , @N_Document
    , @Num_OF
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_Fct_BaseOld
    , @SimulerOld
    , @N_DepotOld
    , @QteOld
    , @N_DocumentOld
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
    /* simulation : rien à faire pour le stock! */
    IF NOT ( @Simuler = 'Oui' )
    BEGIN
        /* test si des modification répercutables sur le stock ont été faites */
        IF NOT ( ( @N_Depot = @N_DepotOld )AND
        ( @N_Fct_Base = @N_Fct_BaseOld )AND
        ( @Qte = @QteOld )AND( @Simuler = @SimulerOld ) ) 
        BEGIN
 
            IF ( @SimulerOld = 'Non' )AND
            ( @N_Fct_BaseOld > 0 )AND
            ( @QteOld > 0 )AND
            ( @N_DepotOld > 0 ) 
            BEGIN
                /* il faut annuler le mouvement de stock */
                IF( @N_Fct_BaseOld > 0 )
                BEGIN
                    SET @GestionStockOld  = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_BaseOld )
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
                   , N_Produit = 0
                   , N_Fct_Base = @N_Fct_BaseOld
                   , N_Document = @N_Document
                   , Qte_cde_fournisseur = -@QteOld
                   , Origine = 'OF'
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
               
                EXECUTE SORTIE_STOCK_PRODUITS_POUR_OF @N_Document
                   , @N_DepotOld
                   , @N_Fct_BaseOld
                   , @QteOld
                   , 1.0
                   , 'Non' 
                   , @Stock_Liste_Info_Old
                   , @Stock_Preparation_Old
            END
 
            IF( @Simuler = 'Non' )AND
            (  @N_Fct_Base > 0 )AND
            ( @Qte > 0 )AND
            ( @N_Depot > 0 ) 
            BEGIN
                /* il faut créditer un mouvement de stock */
 
                IF( @N_Fct_Base > 0 ) 
                BEGIN
                    SET @GestionStock = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_Base )
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
                   , N_Produit = 0
                   , N_Fct_Base = @N_Fct_Base
                   , N_Document = @N_Document
                   , Qte_cde_fournisseur = @Qte
                   , Origine = 'OF'
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
                   
                EXECUTE SORTIE_STOCK_PRODUITS_POUR_OF @N_Document, @N_Depot, @N_Fct_Base,  @Qte, -1.0, 'Oui',@Stock_Liste_Info,@Stock_Preparation
 
            END
        END
    END
 
 
	FETCH NEXT FROM STOCK_OF_UPDATE_Cursor INTO
      @N_Fct_Base
    , @Simuler
    , @N_Depot
    , @Qte
    , @N_Document
    , @Num_OF
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Cursor_Variable /} */ 
 
    , @N_Fct_BaseOld
    , @SimulerOld
    , @N_DepotOld
    , @QteOld
    , @N_DocumentOld
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
      /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
END
 
CLOSE STOCK_OF_UPDATE_Cursor
DEALLOCATE STOCK_OF_UPDATE_Cursor
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
GO
