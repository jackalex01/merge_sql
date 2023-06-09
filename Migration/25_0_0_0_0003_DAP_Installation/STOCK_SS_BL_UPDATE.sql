ALTER TRIGGER [dbo].[STOCK_SS_BL_UPDATE] ON [dbo].[SS_BL] 
FOR UPDATE
AS
 
DECLARE 
     @N_Produit INT
   , @N_ProduitOld INT
   , @N_Fct_Base INT
   , @N_Fct_BaseOld INT
   , @N_Depot INT
   , @N_DepotOld INT
   , @N_Document INT
   , @N_Cde INT
   , @N_CdeOld INT
   , @Qte numeric(18 ,10)
   , @QteCde numeric(18 ,10)
   , @QteLivre numeric(18 ,10)
   , @QteResteALivre numeric(18 ,10)
   , @QteOld numeric(18 ,10)
   , @GestionStock varchar(3)
   , @GestionStockOld varchar(3)
   , @Designation varchar(50)
   , @Ref varchar(30)
   , @DesignationOld varchar(50)
   , @RefOld varchar(30)
   , @Reservation varchar (3)
   , @Reservation_Old varchar (3)
   , @Recap_Livraison BIT = 0 
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
 
 
DECLARE STOCK_SS_BL_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT 
      N_Produit = i.N_Produit
    , N_Fct_Base = i.N_Fct_Base
    , N_Document = i.N_BL
    , N_Cde = i.N_Cde_Client
    , N_Depot = i.N_Depot
    , Qte = i.Qte
    , Ref = i.Ref_Produit
    , Designation = i.Designation
    , Reservation = i.Stock_Reservation
    , Stock_Liste_Info = i.Stock_Liste_Info
    , Stock_Preparation = i.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent = 103
    , N_Fiche_Precedent = i.N_Bl
    , N_Detail_Precedent = i.N_Ss_Bl
    , App_LigneId = i.App_LigneId
 
      /* s{/App_LigneId Code=Cursor_Select /} */ 
    , N_ProduitOld = d.N_Produit
    , N_Fct_BaseOld = d.N_Fct_Base
    , N_CdeOld = d.N_Cde_Client
    , N_DepotOld = d.N_Depot
    , QteOld = d.Qte
    , RefOld = d.Ref_Produit
    , DesignationOld = d.Designation
    , Reservation_Old = d.Stock_Reservation
    , Stock_Liste_Info_Old = d.Stock_Liste_Info
    , Stock_Preparation_Old = d.Stock_Preparation
      /* s{App_LigneId Code=Cursor_Select /} */
    , TypeFiche_Precedent_Old = 103
    , N_Fiche_Precedent_Old = d.N_Bl
    , N_Detail_Precedent_Old = d.N_Ss_Bl
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Cursor_Select /} */ 
FROM INSERTED i
LEFT OUTER JOIN DELETED d on i.N_Ss_Bl= d.N_Ss_Bl 
 
OPEN STOCK_SS_BL_UPDATE_Cursor
FETCH FROM STOCK_SS_BL_UPDATE_Cursor INTO 
      @N_Produit
    , @N_Fct_Base
    , @N_Document
    , @N_Cde
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    , @Reservation
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
    , @N_CdeOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
    , @Reservation_Old
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
    ( @N_Fct_BaseOld = @N_Fct_Base )AND
    (@QteOld = @Qte )AND
    (@N_DepotOld = @N_Depot )AND
    (@N_CdeOld = @N_Cde )AND
    (@Ref = @RefOld ) AND
    (@Designation = @DesignationOld ) AND
    (@Reservation = @Reservation_Old ) 
    /* s{App_LigneId Code=If /} */
    AND (@App_LigneId_Old = @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */ 
    ) 
    BEGIN
 
 
        IF( ( @N_CdeOld > 0 )AND
        ( ( @N_ProduitOld > 0 )OR( @N_Fct_baseOld > 0 )OR(( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' )))
        )
        BEGIN
            /*met à jour le champ cde complètement livrée*/
            EXECUTE RECAP_LIVRAISON_CDE_CLI @N_CdeOld
        END
 
 
        IF( ( @N_Cde > 0 )AND
        ( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
        )
        BEGIN
            /*met à jour le champ cde complètement livrée*/
            EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Cde
        END
 
        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
        BEGIN
            SET @QteCde = 0
            SET @QteLivre = 0
            SET @QteResteALivre = 0
 
            IF( @N_CdeOld > 0 )
            BEGIN
 
                SELECT 
                    @QteCde = SUM(L.Quantite)
                    , @Qtelivre = (SELECT 
                                        SUM(Qte)
                                FROM SS_BL
                                WHERE (N_Cde_Client = @N_CdeOld) AND (((N_Produit = @N_ProduitOld) AND (@N_Produit > 0)) OR ((N_Fct_Base = @N_Fct_BaseOld) AND (@N_Fct_BaseOld > 0))))
                FROM Lignecli L
                WHERE (L.n_cde_cli = @N_CdeOld) AND (((L.N_Prod = @N_ProduitOld) AND (@N_ProduitOld > 0)) OR ((L.N_Fct_Base = @N_Fct_BaseOld) AND (@N_Fct_BaseOld > 0)))
 
 
                SET @QteCde = ISNULL(@QteCde,0)
                SET @QteLivre = ISNULL(@QteLivre,0)
                
                SET @QteResteALivre = @QteCde - @QteLivre
                IF( @N_Produit = @N_ProduitOld ) SET @QteResteALivre = @QteResteALivre + @Qte
            END
 
            IF @QteResteALivre > 0 
            BEGIN
                /* tout le cdé n'a pas été livré on touche au cdé dans la limite de ce qui a été cdé */
                IF @QteOld < @QteResteALivre 
                BEGIN
                    SET @QteCde = @QteOld 
                END
                ELSE 
                BEGIN
                    SET @QteCde = @QteResteALivre
                END
            END
            ELSE
            BEGIN
                /* tout le cdé a déjà été livré donc on ne touche pas au compteur cdé */
                IF @QteResteALivre <= 0 
                BEGIN
                    SET @QteCde = 0
                END
            END
 
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
                , Qte_Stock
                , Qte_BL
                , Qte_BL_Reservation
                , Origine
                , Operation
                , TestIntegrite
                , GestionStock
                , Reservation
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
                , Qte_cde_client = @QteCde
                , Qte_Stock = @QteOld
                , Qte_BL = -@QteOld
                , Qte_BL_Reservation = CASE WHEN ISNULL(@Reservation_Old,'Non')='Oui' THEN -@QteOld ELSE 0 END
                , Origine = 'BL'
                , Operation = 'AUT'
                , TestIntegrite = 'Non'
                , GestionStock = @GestionStockOld
                , Reservation = @Reservation_Old
                , Stock_Liste_Info = @Stock_Liste_Info_Old
                , Stock_Preparation = @Stock_Preparation_Old
                  /* s{App_LigneId Code=Insert_Select /} */
                , TypeFiche_Precedent = @TypeFiche_Precedent_Old
                , N_Fiche_Precedent = @N_Fiche_Precedent_Old
                , N_Detail_Precedent = @N_Detail_Precedent_Old
                , App_LigneId_Origine = @App_LigneId_Old
                  /* s{/App_LigneId Code=Insert_Select /} */   
 
        END
 
 
        /*la nouvelle valeur concerne un produit ou une fct de base*/
        IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
        BEGIN
 
            IF( @N_Cde > 0 )
            BEGIN
                SET @QteCde = 0
                SET @QteLivre = 0
                SET @QteResteALivre = 0
 
                SELECT 
                    @QteCde = SUM(L.Quantite)
                    , @Qtelivre = (SELECT 
                                        SUM(Qte)
                                FROM SS_BL
                                WHERE (N_Cde_Client = @N_Cde) AND (((N_Produit = @N_Produit) AND (@N_Produit > 0)) OR ((N_Fct_Base = @N_Fct_Base) AND (@N_Fct_Base > 0))))
                FROM Lignecli L
                    /*where( L.n_cde_cli = @N_Cde )AND( L.N_Prod = @N_Produit )*/
                WHERE (L.n_cde_cli = @N_Cde) AND (((L.N_Prod = @N_Produit) AND (@N_Produit > 0)) OR ((L.N_Fct_Base = @N_Fct_Base) AND (@N_Fct_Base > 0)))
 
                SET @QteCde = ISNULL(@QteCde,0)
                SET @QteLivre = ISNULL(@QteLivre,0)
 
                SET @QteResteALivre = @QteCde - @QteLivre + @Qte
 
                IF @QteResteALivre > 0 
                BEGIN
                    /* tout le cdé n'a pas été livré on touche au cdé dans la limite de ce qui a été cdé */
                    IF @Qte < @QteResteALivre 
                    BEGIN
                        SET @QteCde = @Qte 
                    END
                    ELSE
                    BEGIN
                        SET @QteCde = @QteResteALivre
                    END 
                END
                ELSE
                BEGIN
                    /* tout le cdé a déjà été livré donc on ne touche pas au compteur cdé */
                    IF @QteResteALivre <= 0 
                    BEGIN
                        SET @QteCde = 0
                    END
                END
 
            END
 
 
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
                , Qte_cde_client
                , Qte_Stock
                , Qte_BL
                , Qte_BL_Reservation
                , Origine
                , Operation
                , TestIntegrite
                , GestionStock
                , Reservation
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
                , Qte_cde_client = -@QteCde
                , Qte_Stock = -@Qte
                , Qte_BL = @Qte
                , Qte_BL_Reservation = CASE WHEN ISNULL(@Reservation,'Non')='Oui' THEN @Qte ELSE 0 END
                , Origine = 'BL'
                , Operation = 'AUT'
                , TestIntegrite = 'Oui'
                , GestionStock = @GestionStock
                , Reservation = @Reservation
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
 
	FETCH NEXT FROM STOCK_SS_BL_UPDATE_Cursor INTO
      @N_Produit
    , @N_Fct_Base
    , @N_Document
    , @N_Cde
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    , @Reservation
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
    , @N_CdeOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
    , @Reservation_Old
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
    /* s{App_LigneId Code=Cursor_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old  
    /* s{/App_LigneId Code=Cursor_Variable /} */
END
 
CLOSE STOCK_SS_BL_UPDATE_Cursor
DEALLOCATE STOCK_SS_BL_UPDATE_Cursor
 
 
 
 
GO
