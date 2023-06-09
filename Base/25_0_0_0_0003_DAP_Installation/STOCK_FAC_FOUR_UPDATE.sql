ALTER TRIGGER [STOCK_FAC_FOUR_UPDATE] ON [SFACFOUR] 
FOR UPDATE
AS

DECLARE 
@N_Produit  int,
@N_ProduitOld  int,
@N_BR int,
@N_BROld  int,
@N_Depot int,
@N_DepotOld int,
@N_Document int,
@Qte	numeric(18,10),
@QteOld numeric(18,10),
@GestionStock varchar(3),
@GestionStockOld varchar(3)

SELECT 
@N_Produit  = i.N_Produit,
@N_BR = i.N_BR,
@N_Document = i.N_Fac_Four,
@N_Depot = i.N_Depot,
@Qte = i.Quantite
From inserted i

SELECT 
@N_ProduitOld  = d.N_Produit,
@N_BROld = d.N_BR,
@N_DepotOld = d.N_Depot,
@QteOld = d.Quantite
From deleted d

/*si la mise Ó jour ne concerne pas la qtÚ et si il n'a pas de changement de
produit ou de fonction de base*/
IF(( @N_ProduitOld = @N_Produit )AND
(@QteOld = @Qte )AND( @N_Depot = @N_DepotOld)AND( @N_BR = @N_BROld )) 
BEGIN
/*Calcul du dernier Prix d'achat*/
IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
RETURN
END

/*Calcul du dernier Prix d'achat*/
IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit

/*Calcul du dernier Prix d'achat*/
IF( @N_ProduitOld <> @N_produit )AND( @N_ProduitOld > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_ProduitOld


/*la valeur ÚcrasÚe concerne un produit ou une fct de base*/
IF( @N_BROld > 0 )
BEGIN

IF( @N_ProduitOld > 0 )
BEGIN

IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_BR,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,0,@N_Document,@QteOld,'FF','AUT','Non',@GestionStockOld)

END
END

IF( @N_BR > 0 )
BEGIN
/*la nouvelle valeur concerne un produit ou une fct de base*/
IF( @N_Produit > 0 )
BEGIN

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_BR,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,-@Qte,'FF','AUT','Oui',@GestionStock)

END
END


