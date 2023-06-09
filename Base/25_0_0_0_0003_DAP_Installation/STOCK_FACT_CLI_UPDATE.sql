ALTER TRIGGER [STOCK_FACT_CLI_UPDATE] ON [SFCT_CLI] 
FOR UPDATE
AS
DECLARE 
@N_Produit  int,
@N_ProduitOld  int,
@N_Fct_Base  int,
@N_Fct_BaseOld  int,
@N_BL int,
@N_BLOld  int,
@N_Depot int,
@N_DepotOld int,
@N_Document int,
@Qte	numeric(18,10),
@QteOld numeric(18,10),
@GestionStock varchar(3),
@GestionStockOld varchar(3),
@CoefAvoir Numeric(18,10),
@N_fact_Cli int
SELECT 
@N_Produit  = i.N_Produit,
@N_Fct_Base = i.N_Fct_Base,
@N_BL = i.N_BL,
@N_Document = i.N_Fact_Cli,
@N_Depot = i.N_Depot,
@Qte = i.Quantite,
@N_fact_Cli = i.N_fact_Cli
From inserted i
SELECT 
@N_ProduitOld  = d.N_Produit,
@N_Fct_BaseOld = d.N_Fct_Base,
@N_BLOld = d.N_BL,
@N_DepotOld = d.N_Depot,
@QteOld = d.Quantite
From deleted d

--gestion des avoirs
SET @CoefAvoir = (CASE WHEN IsNull((SELECT UPPER(IsNull(Avoir,'Non')) FROM FACT_CLI FAC WHERE FAC.N_fact_Cli=@N_fact_Cli),'NON')='OUI'
	          THEN -1 ELSE 1 END)

SET @Qte=@Qte * @CoefAvoir
SET @QteOld=@QteOld * @CoefAvoir

/*si la mise à jour ne concerne pas la qté et si il n'a pas de changement de
produit ou de fonction de base*/
IF(( @N_ProduitOld = @N_Produit )AND
( @N_Fct_BaseOld = @N_Fct_Base )AND
(@QteOld = @Qte )AND( @N_Depot = @N_DepotOld)AND( @N_BL = @N_BLOld )) RETURN

/*la valeur écrasée concerne un produit ou une fct de base*/
IF( @N_BLOld > 0 )
BEGIN
IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
BEGIN
IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_BaseOld )
INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_BL,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,@N_Fct_BaseOld,@N_Document,@QteOld,'FC','AUT','Non',@GestionStockOld)
END
END

ELSE
--ajout pour mvts stock sur facture sans BL pour produits ---
--IF( @N_BLOld = 0 )
BEGIN
IF(( @N_ProduitOld > 0 )OR( @N_Fct_BaseOld > 0 ) )
BEGIN
IF( @N_ProduitOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_ProduitOld )
IF( @N_Fct_BaseOld > 0 ) SET @GestionStockOld = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_BaseOld )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_Stock,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_DepotOld, @N_ProduitOld,@N_Fct_BaseOld,@N_Document,@QteOld,'FC','AUT','Non',@GestionStockOld)
END
END


IF( @N_BL > 0 )
BEGIN
/*la nouvelle valeur concerne un produit ou une fct de base*/
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
/*la nouvelle valeur concerne un produit ou une fct de base*/
IF(( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )
BEGIN
IF( @N_Produit > 0 ) SET @GestionStock = ( SELECT GestionStock FROM PRODUIT WHERE N_Produit = @N_Produit )
IF( @N_Fct_Base > 0 ) SET @GestionStock = ( SELECT GestionStock FROM Fct_Base WHERE N_Fct_Base = @N_Fct_Base )

INSERT INTO 
MVTS_STOCK (N_Depot, N_Produit,N_Fct_Base,N_Document,Qte_Stock,Origine,Operation,TestIntegrite,GestionStock) 
VALUES (@N_Depot, @N_Produit,@N_Fct_Base,@N_Document,-@Qte,'FC','AUT','Oui',@GestionStock)
END
END




