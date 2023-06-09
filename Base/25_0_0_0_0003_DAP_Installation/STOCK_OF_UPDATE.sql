ALTER TRIGGER [STOCK_OF_UPDATE] ON [ORDREF] 
FOR UPDATE
AS

DECLARE 
@Simuler varchar(3),
@SimulerOld varchar(3),
@N_Fct_Base int,
@N_Fct_BaseOld int,
@N_Depot int,
@N_DepotOld int,
@Qte numeric(18,10),
@QteOld numeric(18,10),
@N_Document int,
@N_DocumentOld int,
@Num_OF int,
@GestionStock varchar(3),
@GestionStockOld varchar(3)


SELECT
@N_Fct_Base = i.N_Fct_Base,
@Simuler = i.Simuler,
@N_Depot = i.N_Depot,
@Qte = i.Qte,
@N_Document = i.N_OF,
@Num_OF = i.Num_OF
FROM inserted i

SELECT
@N_Fct_BaseOld = d.N_Fct_Base,
@SimulerOld = d.Simuler,
@N_DepotOld = d.N_Depot,
@QteOld = d.Qte,
@N_DocumentOld = d.N_OF
FROM deleted d

/* simulation : rien Ó faire pour le stock! */
IF( @Simuler = 'Oui' )
BEGIN

/* 1Þre sauvegarde du document par l'utilisateur -> validation du N░ */
/*
IF( @Num_OF is NULL )AND( @N_DocumentOld IS NOT NULL )AND( @N_Document IS NOT NULL )
BEGIN
DECLARE @CHRONO int
EXECUTE CHRONO_OF @CHRONO OUTPUT

UPDATE ORDREF
	SET Num_OF = @CHRONO,
	        Nom_OF = LEFT(Nom_OF+CONVERT(varchar,@CHRONO),20)
WHERE N_OF = @N_Document
END
*/
RETURN
END

/* test si des modification rÚpercutables sur le stock ont ÚtÚ faites */
IF( ( @N_Depot = @N_DepotOld )AND
( @N_Fct_Base = @N_Fct_BaseOld )AND
( @Qte = @QteOld )AND( @Simuler = @SimulerOld ) ) RETURN

IF( @SimulerOld = 'Non' )AND
( @N_Fct_BaseOld > 0 )AND
( @QteOld > 0 )AND
( @N_DepotOld > 0 ) 
BEGIN
/* il faut annuler le mouvement de stock */

IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_BaseOld )

INSERT INTO 
MVTS_STOCK( N_Depot, N_Produit, N_Fct_Base, N_Document, Qte_cde_fournisseur, Origine, Operation, TestIntegrite,GestionStock )
VALUES(@N_DepotOld, 0, @N_Fct_BaseOld, @N_Document, -@QteOld, 'OF', 'AUT', 'Non', @GestionStockOld )

EXECUTE SORTIE_STOCK_PRODUITS_POUR_OF @N_Document, @N_DepotOld, @N_Fct_BaseOld,  @QteOld, 1.0, 'Non' 

END

IF( @Simuler = 'Non' )AND
(  @N_Fct_Base > 0 )AND
( @Qte > 0 )AND
( @N_Depot > 0 ) 
BEGIN
/* il faut crÚditer un mouvement de stock */

IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM FCT_BASE WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK( N_Depot, N_Produit, N_Fct_Base, N_Document, Qte_cde_fournisseur, Origine, Operation, TestIntegrite, GestionStock )
VALUES(@N_Depot, 0, @N_Fct_Base, @N_Document, @Qte, 'OF', 'AUT', 'Oui', @GestionStock )

EXECUTE SORTIE_STOCK_PRODUITS_POUR_OF @N_Document, @N_Depot, @N_Fct_Base,  @Qte, -1.0, 'Oui' 

END



















