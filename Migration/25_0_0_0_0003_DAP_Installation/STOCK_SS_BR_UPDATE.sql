ALTER TRIGGER [dbo].[STOCK_SS_BR_UPDATE] ON [dbo].[SS_BR] 
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
   , @PU_EuroOld numeric(18 ,10)
   , @PU_Euro numeric(18 ,10)
   , @PU_FrancOld numeric(18 ,10)
   , @PU_Franc numeric(18 ,10)
   , @Recap_Livraison BIT = 0 
   , @Recap_Livraison_Old BIT = 0 
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
 
DECLARE STOCK_SS_BR_UPDATE_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = i.N_Produit
    , N_Fct_Base = i.N_Fct_Base
    , N_Cde = i.N_Cde_Four
    , N_Document = i.N_BR
    , N_Depot = i.N_Depot
    , Qte = i.Qte
    , Ref = i.Ref_Produit
    , Designation = i.Designation
    , PU_Euro = i.PU_Euro
    , PU_Franc = i.PU_Franc
    , Stock_Liste_Info = i.Stock_Liste_Info
    , Stock_Preparation = i.Stock_Preparation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent = 111
    , N_Fiche_Precedent = d.N_Br
    , N_Detail_Precedent = d.N_Ss_Br
    , App_LigneId = d.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
 
    , N_ProduitOld = d.N_Produit
    , N_Fct_BaseOld = d.N_Fct_Base
    , N_CdeOld = d.N_Cde_Four
    , N_DepotOld = d.N_Depot
    , QteOld = d.Qte
    , RefOld = d.Ref_Produit
    , DesignationOld = d.Designation
    , PU_EuroOld = d.PU_Euro
    , PU_FrancOld = d.PU_Franc
    , Stock_Liste_Info_Old = d.Stock_Liste_Info
    , Stock_Preparation_Old = d.Stock_Preparation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent_Old = 111
    , N_Fiche_Precedent_Old = d.N_Br
    , N_Detail_Precedent_Old = d.N_Ss_Br
    , App_LigneId_Old = d.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
From inserted i
LEFT OUTER JOIN DELETED d on i.N_ss_br = d.N_Ss_Br
 
OPEN STOCK_SS_BR_UPDATE_Cursor
FETCH FROM STOCK_SS_BR_UPDATE_Cursor INTO 
      @N_Produit
    , @N_Fct_Base
    , @N_Cde
    , @N_Document
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    , @PU_Euro
    , @PU_Franc
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
 
    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_CdeOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
    , @PU_EuroOld
    , @PU_FrancOld
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
      /* s{App_LigneId Code=Deleted_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
      /* s{/App_LigneId Code=Deleted_Variable /} */ 
 
WHILE @@FETCH_STATUS = 0
BEGIN
    /*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
    produit ou de fonction de base ou de depot ou de cde*/
    IF NOT (( @N_ProduitOld = @N_Produit )AND
    (@QteOld = @Qte ) AND
    (@N_DepotOld = @N_Depot) AND
    (@N_CdeOld = @N_Cde ) AND
    (@Ref = @RefOld ) AND
    (@Designation = @DesignationOld ) AND
    (@PU_Euro = @PU_EuroOld )
    /* s{App_LigneId Code=If /} */
    AND (@App_LigneId_Old = @App_LigneId)
    /* s{/App_LigneId Code=Inserted_Variable /} */
    ) 
    BEGIN
  
 
        SET @QteCde = 0
        SET @QteLivre = 0
        SET @QteResteALivre = 0
 
        /*la valeur écrasée concerne un produit ou une fct de base*/
        IF( @N_ProduitOld > 0 )
        BEGIN
            IF( @N_CdeOld > 0 )
            BEGIN
                SELECT 
                      @QteCde = SUM(S.Quantite)
                    , @Qtelivre = (SELECT 
                                         SUM(Qte)
                                   FROM SS_BR
                                   WHERE (N_Cde_Four = @N_CdeOld) AND (N_Produit = @N_ProduitOld))
                FROM Scd_Four S
                WHERE (S.n_cde_four = @N_CdeOld) AND (S.N_Prod = @N_ProduitOld)
 
                SET @QteCde = ISNULL(@QteCde,0)
                SET @QteLivre = ISNULL(@QteLivre,0)
                SET @QteResteALivre = @QteCde - @QteLivre
                
                IF( @N_Produit = @N_ProduitOld ) 
                BEGIN
                    SET @QteResteALivre = @QteResteALivre + @Qte
                END
            END
 
            IF @QteResteALivre >= 0 
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
 
            INSERT INTO MVTS_STOCK
            (
                 N_Depot
               , N_Produit
               , N_Fct_Base
               , N_Document
               , Qte_cde_Fournisseur
               , Qte_Stock
               , Qte_BR
               , Origine
               , Operation
               , TestIntegrite
               , GestionStock
               , PU_Euro
               , PU_Franc
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
               , Qte_cde_Fournisseur = @QteCde
               , Qte_Stock = -@QteOld
               , Qte_BR = -@QteOld
               , Origine = 'BR'
               , Operation = 'AUT'
               , TestIntegrite = 'Non'
               , GestionStock = @GestionStockOld
               , PU_Euro = @PU_EuroOld
               , PU_Franc = @PU_FrancOld 
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
        IF( @N_Produit > 0 )
        BEGIN
 
            IF( @N_Cde > 0 )
            BEGIN
 
                SELECT 
                      @QteCde = SUM(S.Quantite)
                    , @Qtelivre = (SELECT 
                                         SUM(Qte)
                                   FROM SS_BR
                                   WHERE (N_Cde_Four = @N_Cde) AND (N_Produit = @N_Produit))
                FROM Scd_Four S
                WHERE (S.n_cde_four = @N_Cde) AND (S.N_Prod = @N_Produit)
 
 
                SET @QteCde = ISNULL(@QteCde,0)
                SET @QteLivre = ISNULL(@QteLivre,0)
                SET @QteResteALivre = @QteCde - @QteLivre + @Qte
 
                IF @QteResteALivre >= 0 
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
 
            INSERT INTO MVTS_STOCK
            (
                 N_Depot
               , N_Produit
               , N_Fct_Base
               , N_Document
               , Qte_cde_Fournisseur
               , Qte_Stock
               , Qte_BR
               , Origine
               , Operation
               , TestIntegrite
               , GestionStock
               , PU_Euro
               , PU_Franc
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
               , Qte_cde_Fournisseur = -@QteCde
               , Qte_Stock = @Qte
               , Qte_BR = @Qte
               , Origine = 'BR'
               , Operation = 'AUT'
               , TestIntegrite = 'Oui'
               , GestionStock = @GestionStock
               , PU_Euro = @PU_Euro
               , PU_Franc = @PU_Franc 
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
 
	FETCH NEXT FROM STOCK_SS_BR_UPDATE_Cursor INTO
     @N_Produit
    , @N_Fct_Base
    , @N_Cde
    , @N_Document
    , @N_Depot
    , @Qte
    , @Ref
    , @Designation
    , @PU_Euro
    , @PU_Franc
    , @Stock_Liste_Info
    , @Stock_Preparation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , @TypeFiche_Precedent
    , @N_Fiche_Precedent
    , @N_Detail_Precedent
    , @App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
 
    , @N_ProduitOld
    , @N_Fct_BaseOld
    , @N_CdeOld
    , @N_DepotOld
    , @QteOld
    , @RefOld
    , @DesignationOld
    , @PU_EuroOld
    , @PU_FrancOld
    , @Stock_Liste_Info_Old
    , @Stock_Preparation_Old
      /* s{App_LigneId Code=Deleted_Variable /} */
    , @TypeFiche_Precedent_Old
    , @N_Fiche_Precedent_Old
    , @N_Detail_Precedent_Old
    , @App_LigneId_Old
      /* s{/App_LigneId Code=Deleted_Variable /} */ 
END
 
CLOSE STOCK_SS_BR_UPDATE_Cursor
DEALLOCATE STOCK_SS_BR_UPDATE_Cursor
 
 
/*                                                                  
================================================
 -> Recap Livraison
================================================
*/
DECLARE STOCK_SS_BR_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
    N_Document = i.N_Cde_Four
    ,N_Document_Old = d.N_Cde_Four
From INSERTED i
LEFT OUTER JOIN DELETED d ON i.N_Ss_Br = d.N_Ss_Br
WHERE ( ( i.N_Cde_Four > 0 )AND
    ( ( i.N_Produit > 0 )OR(( i.Designation IS NOT NULL AND i.Designation <> '' )AND(i.Ref_Produit IS NOT NULL AND i.Ref_Produit <> '' )))
) OR 
( ( d.N_Cde_Four > 0 )AND
    ( ( d.N_Produit > 0 )OR(( d.Designation IS NOT NULL AND d.Designation <> '' )AND(d.Ref_Produit IS NOT NULL AND d.Ref_Produit <> '' )))
)
GROUP BY i.N_Cde_Four,d.N_Cde_Four

OPEN STOCK_SS_BR_Cursor
FETCH FROM STOCK_SS_BR_Cursor INTO @N_Cde,@N_CdeOld
WHILE @@FETCH_STATUS = 0
BEGIN 
    
    EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Cde
    
    IF @N_Cde <> @N_CdeOld AND @N_CdeOld IS NOT NULL 
    BEGIN
        EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_CdeOld
    END
 
	FETCH NEXT FROM STOCK_SS_BR_Cursor INTO @N_Cde,@N_CdeOld
END
 
CLOSE STOCK_SS_BR_Cursor
DEALLOCATE STOCK_SS_BR_Cursor 
 
/*                                                                  
================================================
 -> Notification pour les DAP
================================================
*/
DECLARE STOCK_SS_BR_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
    N_Document = d.N_BR
From INSERTED d
GROUP BY d.N_Br

OPEN STOCK_SS_BR_Cursor
FETCH FROM STOCK_SS_BR_Cursor INTO @N_Document
WHILE @@FETCH_STATUS = 0
BEGIN 
    
    EXEC SP_DAP_NOTIFICATION_STOCK_BR @N_br = @N_Document
 
	FETCH NEXT FROM STOCK_SS_BR_Cursor INTO @N_Document
END
 
CLOSE STOCK_SS_BR_Cursor
DEALLOCATE STOCK_SS_BR_Cursor 
  
 
 
 
GO
