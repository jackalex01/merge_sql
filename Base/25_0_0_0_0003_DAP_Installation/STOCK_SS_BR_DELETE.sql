ALTER TRIGGER [STOCK_SS_BR_DELETE] ON dbo.SS_BR 
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
	@Ref varchar(30),
	@PU_Euro numeric(18,10),
	@PU_Franc numeric(18,10)


SELECT 
@N_Produit   = d.N_Produit,
@N_Fct_Base  = d.N_Fct_Base,
@N_Document  = d.N_BR,
@N_Cde       = d.N_Cde_Four,
@N_Depot     = d.N_Depot,
@Qte         = d.Qte,
@Ref	     = d.Ref_Produit,
@Designation = d.Designation,
@PU_Euro = d.PU_Euro,
@PU_Franc = d.PU_Franc
From deleted d

IF( ( @N_Cde > 0 )AND
( ( @N_Produit > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
)
BEGIN
/*met à jour le champ cde complètement livrée*/
EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Cde
END

IF( @N_Produit > 0 )
BEGIN

SET @QteCde = 0
SET @QteLivre = 0
SET @QteResteALivre = 0


IF( @N_Cde > 0 )
BEGIN

select
@QteCde=SUM(S.Quantite),
@Qtelivre=(SELECT SUM(Qte) FROM SS_BR WHERE (N_Cde_Four = @N_Cde)AND( N_Produit = @N_Produit))
from Scd_Four S
where( S.n_cde_four = @N_Cde )AND( S.N_Prod = @N_Produit )

IF @QteCde IS NULL SET @QteCde = 0
IF @QteLivre IS NULL SET @QteLivre = 0
SET @QteResteALivre = @QteCde - @QteLivre

IF @QteResteALivre >= 0 
BEGIN
/* tout le cdé n'a pas été livré on touche au cdé dans la limite de ce qui a été cdé */
IF @Qte < @QteResteALivre SET @QteCde = @Qte ELSE SET @QteCde = @QteResteALivre
END
ELSE
BEGIN
/* tout le cdé a déjà été livré donc on ne touche pas au compteur cdé */
IF @QteResteALivre <= 0 SET @QteCde = 0
END
END

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_Cde_Fournisseur,Qte_Stock,Qte_BR,Origine,Operation, TestIntegrite,GestionStock, PU_Euro, PU_Franc) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,@QteCde,-@Qte,-@Qte,'BR','SUP', 'Oui',@GestionStock, @PU_Euro, @PU_Franc )
END



