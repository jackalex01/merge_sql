ALTER TRIGGER [STOCK_SS_BL_UPDATE] ON dbo.SS_BL 
FOR UPDATE
AS

DECLARE 
@N_Produit  int,
@N_ProduitOld  int,
@N_Fct_Base  int,
@N_Fct_BaseOld  int,
@N_Depot int,
@N_DepotOld int,
@N_Document int,
@N_Cde int,
@N_CdeOld int,
@Qte	numeric(18,10),
@QteCde numeric(18,10),
@QteLivre numeric(18,10),
@QteResteALivre numeric(18,10),
@QteOld numeric(18,10),
@GestionStock varchar(3),
@GestionStockOld varchar(3),
@Designation varchar(50),
@Ref varchar(30),
@DesignationOld varchar(50),
@RefOld varchar(30)

SELECT 
@N_Produit   = i.N_Produit,
@N_Fct_Base  = i.N_Fct_Base,
@N_Cde       = i.N_Cde_Client,
@N_Document  = i.N_BL,
@N_Depot     = i.N_Depot,
@Qte         = i.Qte,
@Ref	     = i.Ref_Produit,
@Designation = i.Designation
From inserted i

SELECT 
@N_ProduitOld   = d.N_Produit,
@N_Fct_BaseOld  = d.N_Fct_Base,
@N_CdeOld       = d.N_Cde_Client,
@N_DepotOld     = d.N_Depot,
@QteOld         = d.Qte,
@RefOld	        = d.Ref_Produit,
@DesignationOld = d.Designation
From deleted d

/*si la mise Ó jour ne concerne pas la qtÚ et si il n'a pas de changement de
produit ou de fonction de base*/
IF(( @N_ProduitOld = @N_Produit )AND
( @N_Fct_BaseOld = @N_Fct_Base )AND
(@QteOld = @Qte )AND
(@N_DepotOld = @N_Depot )AND
(@N_CdeOld = @N_Cde )AND
(@Ref = @RefOld ) AND
(@Designation = @DesignationOld )
 ) RETURN


IF( ( @N_CdeOld > 0 )AND
( ( @N_ProduitOld > 0 )OR( @N_Fct_baseOld > 0 )OR(( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' )))
)
BEGIN
/*met Ó jour le champ cde complÞtement livrÚe*/
EXECUTE RECAP_LIVRAISON_CDE_CLI @N_CdeOld
END


IF( ( @N_Cde > 0 )AND
( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
)
BEGIN
/*met Ó jour le champ cde complÞtement livrÚe*/
EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Cde
END


SET @QteCde = 0
SET @QteLivre = 0
SET @QteResteALivre = 0

/*la valeur ÚcrasÚe concerne un produit ou une fct de base*/
IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
BEGIN

IF( @N_CdeOld > 0 )
BEGIN

select
@QteCde=SUM(L.Quantite),
@Qtelivre=(SELECT SUM(Qte) FROM SS_BL WHERE (N_Cde_Client = @N_CdeOld)AND
((( N_Produit = @N_ProduitOld)AND( @N_Produit > 0 ) )OR(( N_Fct_Base = @N_Fct_BaseOld )AND( @N_Fct_BaseOld > 0 ))))
from Lignecli L
/*where( L.n_cde_cli = @N_Cde )AND( L.N_Prod = @N_ProduitOld )*/
where( L.n_cde_cli = @N_CdeOld )AND
((( L.N_Prod = @N_ProduitOld )AND( @N_ProduitOld > 0 ) )OR(( L.N_Fct_Base = @N_Fct_BaseOld )AND( @N_Fct_BaseOld > 0 ) ) )


IF @QteCde IS NULL SET @QteCde = 0
IF @QteLivre IS NULL SET @QteLivre = 0
SET @QteResteALivre = @QteCde - @QteLivre
IF( @N_Produit = @N_ProduitOld ) SET @QteResteALivre = @QteResteALivre + @Qte
END

IF @QteResteALivre > 0 
BEGIN
/* tout le cdÚ n'a pas ÚtÚ livrÚ on touche au cdÚ dans la limite de ce qui a ÚtÚ cdÚ */
IF @QteOld < @QteResteALivre SET @QteCde = @QteOld ELSE SET @QteCde = @QteResteALivre
END
ELSE
BEGIN
/* tout le cdÚ a dÚjÓ ÚtÚ livrÚ donc on ne touche pas au compteur cdÚ */
IF @QteResteALivre <= 0 SET @QteCde = 0
END

IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_BaseOld )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_client,Qte_Stock,Qte_BL,Origine,Operation, TestIntegrite, GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,@N_Fct_BaseOld,@N_Document,@QteCde,@QteOld,-@QteOld,'BL','AUT','Non',@GestionStockOld)

END


/*la nouvelle valeur concerne un produit ou une fct de base*/
IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
BEGIN

IF( @N_Cde > 0 )
BEGIN

select
@QteCde=SUM(L.Quantite),
@Qtelivre=(SELECT SUM(Qte) FROM SS_BL WHERE (N_Cde_Client = @N_Cde)AND
((( N_Produit = @N_Produit)AND( @N_Produit > 0 ) )OR(( N_Fct_Base = @N_Fct_Base )AND( @N_Fct_Base > 0 ))))
from Lignecli L
/*where( L.n_cde_cli = @N_Cde )AND( L.N_Prod = @N_Produit )*/
where( L.n_cde_cli = @N_Cde )AND
((( L.N_Prod = @N_Produit )AND( @N_Produit > 0 ) )OR(( L.N_Fct_Base = @N_Fct_Base )AND( @N_Fct_Base > 0 ) ) )


IF @QteCde IS NULL SET @QteCde = 0
IF @QteLivre IS NULL SET @QteLivre = 0
SET @QteResteALivre = @QteCde - @QteLivre + @Qte

IF @QteResteALivre > 0 
BEGIN
/* tout le cdÚ n'a pas ÚtÚ livrÚ on touche au cdÚ dans la limite de ce qui a ÚtÚ cdÚ */
IF @Qte < @QteResteALivre SET @QteCde = @Qte ELSE SET @QteCde = @QteResteALivre
END
ELSE
BEGIN
/* tout le cdÚ a dÚjÓ ÚtÚ livrÚ donc on ne touche pas au compteur cdÚ */
IF @QteResteALivre <= 0 SET @QteCde = 0
END

END

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_client,Qte_Stock,Qte_BL,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,-@QteCde,-@Qte,@Qte,'BL','AUT','Oui',@GestionStock)

END

