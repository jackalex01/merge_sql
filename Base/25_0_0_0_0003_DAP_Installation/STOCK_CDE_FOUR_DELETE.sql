ALTER TRIGGER [STOCK_CDE_FOUR_DELETE] ON dbo.SCD_FOUR 
FOR DELETE
AS

DECLARE @N_Produit  int,
	@N_Document int,
	@N_Depot int,
	@Qte	numeric(18,10),
	@GestionStock varchar(3),
	@Designation varchar(50),
	@Ref varchar(30)

SELECT 
@N_Produit   = d.N_Prod,
@N_Document  = d.N_Cde_Four,
@Qte         = d.Quantite,
@N_Depot     = d.N_Depot,
@Ref	     = d.Ref,
@Designation = d.Designation
From deleted d

IF( ( @N_Produit > 0 )OR(( @Designation IS NOT NULL AND @Designation <> '' )AND(@Ref IS NOT NULL AND @Ref <> '' )))
BEGIN
/*met Ó jour le champ cde complÞtement livrée*/
EXECUTE RECAP_LIVRAISON_CDE_FOUR @N_Document
END

IF( @N_Produit > 0 )
BEGIN

/*Calcul du dernier Prix d'achat*/
IF( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 0 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit

IF( @N_Produit > 0 ) SET @GestionStock = ISNULL( ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit ) , 'Non')

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_cde_fournisseur,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,-@Qte,'CF','SUP','Oui',@GestionStock)

END
