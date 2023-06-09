ALTER TRIGGER [STOCK_SS_BR_UPDATE] ON dbo.SS_BR 
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
@RefOld varchar(30),
@PU_EuroOld numeric(18,10),
@PU_Euro numeric(18,10),
@PU_FrancOld numeric(18,10),
@PU_Franc numeric(18,10)


SELECT 
@N_Produit  = i.N_Produit,
@N_Fct_Base = i.N_Fct_Base,
@N_Cde = i.N_Cde_Four,
@N_Document = i.N_BR,
@N_Depot = i.N_Depot,
@Qte = i.Qte,
@Ref	     = i.Ref_Produit,
@Designation = i.Designation,
@PU_Euro =i.PU_Euro,
@PU_Franc = i.PU_Franc
From inserted i

SELECT 
@N_ProduitOld  = d.N_Produit,
@N_Fct_BaseOld = d.N_Fct_Base,
@N_CdeOld = d.N_Cde_Four,
@N_DepotOld = d.N_Depot,
@QteOld = d.Qte,
@RefOld	     = d.Ref_Produit,
@DesignationOld = d.Designation,
@PU_EuroOld = d.PU_Euro,
@PU_FrancOld = d.PU_Franc
From deleted d

/*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
produit ou de fonction de base ou de depot ou de cde*/
IF(( @N_ProduitOld = @N_Produit )AND
(@QteOld = @Qte ) AND
(@N_DepotOld = @N_Depot) AND
(@N_CdeOld = @N_Cde ) AND
(@Ref = @RefOld ) AND
(@Designation = @DesignationOld ) AND
(@PU_Euro = @PU_EuroOld )
) RETURN


IF( ( @N_CdeOld > 0 )AND
( ( @N_ProduitOld > 0 )OR(( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' )))
)
BEGIN
/*met à jour le champ cde complètement livrée*/
EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_CdeOld
END


IF( ( @N_Cde > 0 )AND
( ( @N_Produit > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
)
BEGIN
/*met à jour le champ cde complètement livrée*/
EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Cde
END


SET @QteCde = 0
SET @QteLivre = 0
SET @QteResteALivre = 0

/*la valeur écrasée concerne un produit ou une fct de base*/
IF( @N_ProduitOld > 0 )
BEGIN


IF( @N_CdeOld > 0 )
BEGIN

select
@QteCde=SUM(S.Quantite),
@Qtelivre=(SELECT SUM(Qte) FROM SS_BR WHERE (N_Cde_Four = @N_CdeOld)AND( N_Produit = @N_ProduitOld))
from Scd_Four S
where( S.n_cde_four = @N_CdeOld )AND( S.N_Prod = @N_ProduitOld )


IF @QteCde IS NULL SET @QteCde = 0
IF @QteLivre IS NULL SET @QteLivre = 0
SET @QteResteALivre = @QteCde - @QteLivre
IF( @N_Produit = @N_ProduitOld ) SET @QteResteALivre = @QteResteALivre + @Qte
END

IF @QteResteALivre >= 0 
BEGIN
/* tout le cdé n'a pas été livré on touche au cdé dans la limite de ce qui a été cdé */
IF @QteOld < @QteResteALivre SET @QteCde = @QteOld ELSE SET @QteCde = @QteResteALivre
END
ELSE
BEGIN
/* tout le cdé a déjà été livré donc on ne touche pas au compteur cdé */
IF @QteResteALivre <= 0 SET @QteCde = 0
END

IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_Fournisseur,Qte_Stock,Qte_BR,Origine,Operation, TestIntegrite,GestionStock, PU_Euro, PU_Franc ) 
VALUES (@N_DepotOld, @N_ProduitOld,0,@N_Document,@QteCde,-@QteOld,-@QteOld,'BR','AUT','Non',@GestionStockOld, @PU_EuroOld, @PU_FrancOld )

END


/*la nouvelle valeur concerne un produit ou une fct de base*/
IF( @N_Produit > 0 )
BEGIN

IF( @N_Cde > 0 )
BEGIN

select
@QteCde=SUM(S.Quantite),
@Qtelivre=(SELECT SUM(Qte) FROM SS_BR WHERE (N_Cde_Four = @N_Cde)AND( N_Produit = @N_Produit))
from Scd_Four S
where( S.n_cde_four = @N_Cde )AND( S.N_Prod = @N_Produit )


IF @QteCde IS NULL SET @QteCde = 0
IF @QteLivre IS NULL SET @QteLivre = 0
SET @QteResteALivre = @QteCde - @QteLivre + @Qte

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
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_Fournisseur,Qte_Stock,Qte_BR,Origine,Operation, TestIntegrite, GestionStock, PU_Euro, PU_Franc ) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,-@QteCde,@Qte,@Qte,'BR','AUT','Oui',@GestionStock, @PU_Euro, @PU_Franc )

END




