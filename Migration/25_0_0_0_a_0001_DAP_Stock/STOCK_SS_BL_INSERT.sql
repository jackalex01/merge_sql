ALTER TRIGGER [dbo].[STOCK_SS_BL_INSERT] ON [dbo].[SS_BL] 
FOR INSERT
AS
 
DECLARE 
     @N_Produit INT
   , @N_Fct_Base INT
   , @N_Document INT
   , @N_Cde INT
   , @Qte numeric(18 ,10)
   , @QteCde numeric(18 ,10)
   , @QteLivre numeric(18 ,10)
   , @QteResteALivre numeric(18 ,10)
   , @N_Depot INT
   , @GestionStock varchar(3)
   , @Designation varchar(50)
   , @Ref varchar(30)
   , @Reservation varchar (3)
   , @Recap_Livraison BIT = 0 
   , @Stock_Liste_Info varchar(max)
   , @Stock_Preparation varchar(3)
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 
 
DECLARE STOCK_SS_BL_INSERT_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
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
FROM INSERTED i
 
OPEN STOCK_SS_BL_INSERT_Cursor
FETCH FROM STOCK_SS_BL_INSERT_Cursor INTO 
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
WHILE @@FETCH_STATUS = 0
BEGIN
 
 
    IF( ( @N_Cde > 0 )AND
    ( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
    )
    BEGIN
        SET @Recap_Livraison = 1 
    END
 
    IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
    BEGIN
 
        SET @QteCde = 0
        SET @QteLivre = 0
        SET @QteResteALivre = 0
 
        IF( @N_Cde > 0 )
        BEGIN
 
            SELECT 
                  @QteCde = SUM(L.Quantite)
                , @Qtelivre = (SELECT 
                                     SUM(Qte)
                               FROM SS_BL
                               WHERE (N_Cde_Client = @N_Cde) AND (((N_Produit = @N_Produit) AND (@N_Produit > 0)) OR ((N_Fct_Base = @N_Fct_Base) AND (@N_Fct_Base > 0))))
            FROM Lignecli L
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
           , Qte_Cde_Client
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
           , Qte_Cde_Client = -@QteCde
           , Qte_Stock = -@Qte
           , Qte_BL = @Qte
           , Qte_BL_Reservation = CASE WHEN ISNULL(@Reservation,'Non')= 'Oui' THEN @Qte ELSE 0 END
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
 
    FETCH NEXT FROM STOCK_SS_BL_INSERT_Cursor INTO
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
END
 
CLOSE STOCK_SS_BL_INSERT_Cursor
DEALLOCATE STOCK_SS_BL_INSERT_Cursor
 

/*                                                                  
================================================
 -> Récap Livraison
================================================
*/
IF @Recap_Livraison = 1 
BEGIN
    EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Cde
END
 
 
 
 
GO
