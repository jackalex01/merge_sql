ALTER TRIGGER [STOCK_CDE_FOUR_UPDATE] ON dbo.SCD_FOUR 
FOR UPDATE
AS

DECLARE 
@N_Produit  int,
@N_ProduitOld  int,
@N_Document int,
@N_Depot int,
@N_DepotOld int,
@Qte	numeric(18,10),
@QteOld numeric(18,10),
@GestionStock varchar(3),
@GestionStockOld varchar(3),
@Designation varchar(50),
@Ref varchar(30),
@DesignationOld varchar(50),
@RefOld varchar(30)

SELECT 
@N_Produit   = i.N_Prod,
@N_Document  = i.N_Cde_Four,
@N_Depot     = i.N_Depot,
@Qte         = i.Quantite,
@Ref	     = i.Ref,
@Designation = i.Designation
From inserted i

SELECT 
@N_ProduitOld   = d.N_Prod,
@N_DepotOld     = d.N_Depot,
@QteOld         = d.Quantite,
@RefOld	        = d.Ref,
@DesignationOld = d.Designation
From deleted d


IF( ( @N_Produit > 0 )OR( @N_ProduitOld > 0 )OR
(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' ))OR
(( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' )))
BEGIN
/*met Ó jour le champ cde complÞtement livrée*/
EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Document
END


/*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
produit: on ne gère que le dernier Prix d'achat*/
IF(( @N_ProduitOld = @N_Produit )AND
(@QteOld = @Qte )AND( @N_DepotOld = @N_Depot)) 
BEGIN
/*Calcul du dernier Prix d'achat*/
IF( @N_Produit > 0 )  EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit
RETURN
END

/*la valeur écrasée concerne un produit ou une fct de base*/
IF( @N_ProduitOld > 0 )
BEGIN

/*Calcul du dernier Prix d'achat*/
IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_ProduitOld

IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ISNULL( ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld ) , 'Non')

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_fournisseur,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,0,@N_Document,-@QteOld,'CF','AUT','Non',@GestionStockOld)

END


/*la nouvelle valeur concerne un produit ou une fct de base*/
IF( @N_Produit > 0 )
BEGIN

/*Calcul du dernier Prix d'achat*/
IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_fournisseur,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,@Qte,'CF','AUT','Oui',@GestionStock)

END
