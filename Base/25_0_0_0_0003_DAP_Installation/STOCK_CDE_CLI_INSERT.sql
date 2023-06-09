ALTER TRIGGER [STOCK_CDE_CLI_INSERT] ON dbo.LIGNECLI 
FOR INSERT
AS

DECLARE @N_Produit  int,
	@N_Fct_Base  int,
	@N_Ligne_Maitre  int,
	@N_Document int,
	@Qte	numeric(18,10),
	@N_Depot int,
	@GestionStock varchar(3),
	@Designation varchar(50),
	@Ref varchar(30)

SELECT 
@N_Produit      = i.N_Prod,
@N_Fct_Base     = i.N_Fct_Base,
@N_Ligne_Maitre = i.N_Ligne_Maitre,
@N_Document     = i.N_Cde_Cli,
@N_Depot        = i.N_Depot,
@Qte            = i.Quantite,
@Designation    = i.Designation,
@Ref            = i.Reference
From inserted i

IF(((( @N_Produit > 0 )OR( @N_Fct_Base > 0 ))AND((@N_Ligne_Maitre = 0 )OR(@N_Ligne_Maitre IS NULL ))) OR
((( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' ))))
BEGIN
/*met Ó jour le champ cde complÞtement livrÚe*/
EXECUTE RECAP_LIVRAISON_CDE_CLI @N_Document
END

IF((( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )AND((@N_Ligne_Maitre = 0 )OR(@N_Ligne_Maitre IS NULL )))
BEGIN

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_client,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,@Qte,'CC','AUT','Oui',@GestionStock)

END
