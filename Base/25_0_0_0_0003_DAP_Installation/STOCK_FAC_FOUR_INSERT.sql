ALTER TRIGGER [STOCK_FAC_FOUR_INSERT] ON [SFACFOUR] 
FOR INSERT
AS

DECLARE @N_Produit  int,
	@N_Document int,
	@Qte	numeric(18,10),
	@N_Depot int,
	@N_BR int,
	@GestionStock varchar(3)

SELECT 
@N_Produit       = i.N_Produit,
@N_BR  = i.N_BR,
@N_Document  = i.N_Fac_Four,
@N_Depot  = i.N_Depot,
@Qte                = i.Quantite
From inserted i

/*Calcul du dernier Prix d'achat*/
IF( @N_Produit > 0 )AND( SELECT ISNULL( MethodeDPA, 0 ) FROM SOFT_INI ) = 1 EXECUTE CALCUL_DERNIER_PRIX_ACHAT @N_Produit


IF( @N_BR > 0 )
BEGIN

IF( @N_Produit > 0 )
BEGIN

IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_BR,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,0,@N_Document,-@Qte,'FF','AUT','Oui',@GestionStock)

END

END

