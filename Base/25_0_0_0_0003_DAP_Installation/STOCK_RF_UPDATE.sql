ALTER TRIGGER [STOCK_RF_UPDATE] ON [RF] 
FOR UPDATE
AS

DECLARE 
@N_OF int,
@N_OFOld int,
@N_Fct_Base int,
@N_Fct_BaseOld int,
@N_Depot int,
@N_DepotOld int,
@Qte numeric(18,10),
@QteOld numeric(18,10),
@N_Document int,
@N_DocumentOld int,
@Num_RF int,
@GestionStock varchar(3),
@GestionStockOld varchar(3)

SELECT
@N_Fct_Base = i.N_Fct_Base,
@N_OF = i.N_OF,
@N_Depot = i.N_Depot,
@Qte = i.Qte,
@N_Document = i.N_RF,
@Num_RF = i.Num_RF
FROM inserted i

SELECT
@N_Fct_BaseOld = d.N_Fct_Base,
@N_OFOld = d.N_OF,
@N_DepotOld = d.N_Depot,
@QteOld = d.Qte,
@N_DocumentOld = d.N_RF
FROM deleted d

/* test si des modification rÚpercutables sur le stock ont ÚtÚ faites */
IF( ( @N_Depot = @N_DepotOld )AND
( @N_Fct_Base = @N_Fct_BaseOld )AND
( @Qte = @QteOld )AND( @N_OF = @N_OFOld ) ) RETURN

IF( @N_Fct_BaseOld > 0 )AND
( @QteOld > 0 )AND
( @N_DepotOld > 0 )
BEGIN
/* il faut annuler le mouvement de stock */
IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_BaseOld )

INSERT INTO 
MVTS_STOCK( N_Depot, N_Produit, N_Fct_Base, N_Document, Qte_Stock, Qte_cde_fournisseur, Origine, Operation, TestIntegrite, GestionStock )
VALUES(@N_DepotOld, 0, @N_Fct_BaseOld, @N_Document, -@QteOld, @QteOld, 'RF', 'AUT', 'Non', @GestionStockOld )

EXECUTE SORTIE_STOCK_PRODUITS_POUR_RF @N_Document, @N_DepotOld, @N_Fct_BaseOld,  @QteOld, 1.0, 'Non'

IF( @N_OFOld  > 0 ) EXECUTE RECAP_FABRICATION @N_OFOld

END


IF(  @N_Fct_Base > 0 )AND
( @Qte > 0 )AND
( @N_Depot > 0 ) 
BEGIN
/* il faut crÚditer un mouvement de stock */
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK( N_Depot, N_Produit, N_Fct_Base, N_Document, Qte_Stock, Qte_cde_fournisseur, Origine, Operation, TestIntegrite, GestionStock )
VALUES(@N_Depot, 0, @N_Fct_Base, @N_Document, @Qte, -@Qte, 'RF', 'AUT', 'Oui', @GestionStock )

EXECUTE SORTIE_STOCK_PRODUITS_POUR_RF @N_Document, @N_Depot, @N_Fct_Base,  @Qte, -1.0, 'Oui'

IF( @N_OF  > 0 ) EXECUTE RECAP_FABRICATION @N_OF

END













