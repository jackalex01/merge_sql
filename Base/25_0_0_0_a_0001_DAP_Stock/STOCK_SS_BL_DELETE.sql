ALTER TRIGGER [STOCK_SS_BL_DELETE] ON dbo.SS_BL 
FOR DELETE
AS

DECLARE @N_Produit  int,
	@N_Fct_Base  int,
	@N_Document int,
	@N_Cde int,
	@Qte	numeric(18,10),
	@QteCde numeric(18,10),
	@QteLivre numeric(18,10),
	@QteResteALivre numeric(18,10),
	@N_Depot int,
	@GestionStock varchar(3),
	@Designation varchar(50),
	@Ref varchar(30)

SELECT 
@N_Produit   = d.N_Produit,
@N_Fct_Base  = d.N_Fct_Base,
@N_Document  = d.N_BL,
@N_Cde       = d.N_Cde_Client,
@N_Depot     = d.N_Depot,
@Qte         = d.Qte,
@Ref	     = d.Ref_Produit,
@Designation = d.Designation
From deleted d

IF( ( @N_Cde > 0 )AND
( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
)
BEGIN
/*met Ó jour le champ cde complÞtement livrÚe*/
EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Cde
END

IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
BEGIN

SET @QteCde = 0
SET @QteLivre = 0
SET @QteResteALivre = 0


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
SET @QteResteALivre = @QteCde - @QteLivre


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
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_Cde_Client,Qte_Stock,Qte_BL,Origine,Operation, TestIntegrite, GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,@QteCde,@Qte,-@Qte,'BL','SUP','Oui', @GestionStock)
END

