ALTER TRIGGER [STOCK_CDE_CLI_UPDATE] ON dbo.LIGNECLI 
FOR UPDATE
AS

DECLARE 
@N_Produit  int,
@N_ProduitOld  int,
@N_Fct_Base  int,
@N_Fct_BaseOld  int,
@N_Ligne_Maitre int,
@N_Ligne_MaitreOld  int,
@N_Depot int,
@N_DepotOld int,
@N_Document int,
@Qte	numeric(18,10),
@QteOld numeric(18,10),
@GestionStockOld varchar(3),
@GestionStock varchar(3),
@Designation varchar(50),
@Ref varchar(30),
@DesignationOld varchar(50),
@RefOld varchar(30)

SELECT 
@N_Produit      = i.N_Prod,
@N_Fct_Base     = i.N_Fct_Base,
@N_Ligne_Maitre = i.N_Ligne_Maitre,
@N_Document     = i.N_Cde_Cli,
@N_Depot        = i.N_Depot,
@Qte            = i.Quantite,
@Ref	        = i.Reference,
@Designation    = i.Designation
From inserted i

SELECT 
@N_ProduitOld      = d.N_Prod,
@N_Fct_BaseOld     = d.N_Fct_Base,
@N_Ligne_MaitreOld = d.N_Ligne_Maitre,
@N_DepotOld        = d.N_Depot,
@QteOld            = d.Quantite,
@RefOld	           = d.Reference,
@DesignationOld    = d.Designation
From deleted d


IF( ( @N_Produit > 0 )OR( @N_ProduitOld > 0 )OR( @N_Fct_Base > 0 )OR( @N_Fct_BaseOld > 0 )OR
(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' ))OR
(( @DesignationOld IS NOT NULL AND @DesignationOld <> '' )AND(@RefOld IS NOT NULL AND @RefOld <> '' )))
BEGIN
/*met Ó jour le champ cde complÞtement livrÚe*/
EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Document
END


/*si la mise Ó jour ne concerne pas la qtÚ et si il n'a pas de changement de
produit ou de fonction de base*/
IF(( @N_ProduitOld = @N_Produit )AND
( @N_Fct_BaseOld = @N_Fct_Base )AND
( @N_Ligne_MaitreOld = @N_Ligne_Maitre )AND
(@QteOld = @Qte )AND( @N_Depot = @N_DepotOld) ) RETURN

/*la valeur ÚcrasÚe concerne un produit ou une fct de base*/
IF((( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )AND((@N_Ligne_MaitreOld = 0 )OR(@N_Ligne_MaitreOld IS NULL )) )
BEGIN

IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_BaseOld )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_client,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,@N_Fct_BaseOld,@N_Document,-@QteOld,'CC','AUT','Non',@GestionStockOld)

END


/*la nouvelle valeur concerne un produit ou une fct de base*/
IF((( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )AND((@N_Ligne_Maitre = 0 )OR(@N_Ligne_Maitre IS NULL )) )
BEGIN

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_client,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,@Qte,'CC','AUT','Oui',@GestionStock)

END
