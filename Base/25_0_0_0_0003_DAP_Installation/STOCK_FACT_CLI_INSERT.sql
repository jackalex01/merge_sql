ALTER TRIGGER [STOCK_FACT_CLI_INSERT] ON [SFCT_CLI] 
FOR INSERT
AS
DECLARE @N_Produit  int,
	@N_Fct_Base  int,
	@N_Document int,
	@Qte	numeric(18,10),
	@N_Depot int,
	@N_BL int,
	@GestionStock varchar(3),
	@CoefAvoir numeric(18,10),
	@N_fact_Cli int
SELECT 
@N_Produit       = i.N_Produit,
@N_Fct_Base   = i.N_Fct_Base,
@N_BL  = i.N_BL,
@N_Document  = i.N_Fact_Cli,
@N_Depot  = i.N_Depot,
@Qte                = i.Quantite,
@N_fact_Cli = i.N_fact_Cli
From inserted i

--gestion des avoirs
SET @CoefAvoir = (CASE WHEN IsNull((SELECT UPPER(IsNull(Avoir,'Non')) FROM FACT_CLI FAC WHERE FAC.N_fact_Cli=@N_fact_Cli),'NON')='OUI'
	          THEN -1 ELSE 1 END)

SET @Qte=@Qte * @CoefAvoir



IF( @N_BL > 0 )
BEGIN
IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
BEGIN
IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )
INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_BL,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,-@Qte,'FC','AUT','Oui',@GestionStock)
END
END

ELSE

--ajout pour mvts stock sur facture sans BL pour produits ---
--IF( @N_BL = 0 )
BEGIN
IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
BEGIN
IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_Stock,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,-@Qte,'FC','AUT','Oui',@GestionStock)
END
END


