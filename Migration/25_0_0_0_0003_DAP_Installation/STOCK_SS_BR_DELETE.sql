ALTER TRIGGER [dbo].[STOCK_SS_BR_DELETE] ON [dbo].[SS_BR] 
FOR DELETE
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
   , @PU_Euro numeric(18 ,10)
   , @PU_Franc numeric(18 ,10)
   , @Recap_Livraison BIT = 0 
   , @Stock_Liste_Info varchar(max)
   , @Stock_Preparation varchar(3)
     /* s{App_LigneId Code=Declare /} */
   , @TypeFiche_Precedent INT
   , @N_Fiche_Precedent INT
   , @N_Detail_Precedent INT
   , @App_LigneId varchar(50)
     /* s{/App_LigneId Code=Declare /} */ 
 
 
DECLARE STOCK_SS_BR_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
      N_Produit = d.N_Produit
    , N_Fct_Base = d.N_Fct_Base
    , N_Document = d.N_BR
    , N_Cde = d.N_Cde_Four
    , N_Depot = d.N_Depot
    , Qte = d.Qte
    , Ref = d.Ref_Produit
    , Designation = d.Designation
    , PU_Euro = d.PU_Euro
    , PU_Franc = d.PU_Franc
    , Stock_Liste_Info = d.Stock_Liste_Info
    , Stock_Preparation = d.Stock_Preparation
      /* s{App_LigneId Code=Inserted_Variable /} */
    , TypeFiche_Precedent = 111
    , N_Fiche_Precedent = d.N_Br
    , N_Detail_Precedent = d.N_Ss_Br
    , App_LigneId = d.App_LigneId
      /* s{/App_LigneId Code=Inserted_Variable /} */ 
From deleted d
 
OPEN STOCK_SS_BR_Cursor
FETCH FROM STOCK_SS_BR_Cursor INTO 
      @N_Produit
    , @N_Fct_Base
    , @N_Document
    , @N_Cde
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
WHILE @@FETCH_STATUS = 0
BEGIN
 
    IF( @N_Produit > 0 )
    BEGIN
 
    SET @QteCde = 0
    SET @QteLivre = 0
    SET @QteResteALivre = 0
 
 
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
        SET @QteResteALivre = @QteCde - @QteLivre
 
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
        , Qte_Cde_Fournisseur
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
        , Qte_Cde_Fournisseur = @QteCde
        , Qte_Stock = -@Qte
        , Qte_BR = -@Qte
        , Origine = 'BR'
        , Operation = 'SUP'
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
  
	FETCH NEXT FROM STOCK_SS_BR_Cursor INTO
      @N_Produit
    , @N_Fct_Base
    , @N_Document
    , @N_Cde
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
END
 
CLOSE STOCK_SS_BR_Cursor
DEALLOCATE STOCK_SS_BR_Cursor
 
/*                                                                  
================================================
 -> Recap Livraison
================================================
*/
DECLARE STOCK_SS_BR_Cursor CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR
SELECT
    N_Document = N_Cde_Four
From deleted d
WHERE ( ( N_Cde_Four > 0 )AND
    ( ( N_Produit > 0 )OR(( Designation IS NOT NULL AND Designation <> '' )AND(Ref_Produit IS NOT NULL AND Ref_Produit <> '' )))
    )
GROUP BY d.N_Cde_Four

OPEN STOCK_SS_BR_Cursor
FETCH FROM STOCK_SS_BR_Cursor INTO @N_Cde
WHILE @@FETCH_STATUS = 0
BEGIN 
    
    EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Cde
 
	FETCH NEXT FROM STOCK_SS_BR_Cursor INTO @N_Cde
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
From deleted d
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
