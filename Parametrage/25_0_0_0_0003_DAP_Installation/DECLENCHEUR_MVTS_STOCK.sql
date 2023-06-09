ALTER TRIGGER [DECLENCHEUR_MVTS_STOCK] ON [dbo].[MVTS_STOCK] 
FOR INSERT
AS

DECLARE 
	@N_Produit  int,
	@N_Fct_Base  int,
	@N_Depot int,
	@Qte_Stock numeric(18,10),
	@Qte_BL numeric(18,10),
	@Qte_BR numeric(18,10),
	@Qte_Cde_client numeric(18,10),
	@Qte_Cde_fournisseur numeric(18,10),
	@Qte_OF numeric(18,10),
	@TestIntegrite varchar(3),
	@GestionStock varchar(3),
	@LIGNE_STOCK_EXISTE int,
	@Origine varchar(3),
	@N_Document int,
	@PU_Euro numeric(18,10),
	@PU_Franc numeric(18,10),
    @Reservation varchar (3),
    @Qte_BL_Reservation numeric (18,5)


DECLARE @Q numeric(18,10)

SELECT 
@N_Produit           = ISNULL(  i.N_Produit, 0 ),
@N_Fct_Base          = ISNULL( i.N_Fct_Base, 0 ),
@N_Depot	     = i.N_Depot,
@Qte_Stock           = i.Qte_Stock,
@Qte_BL              = i.Qte_BL,
@Qte_BR              = i.Qte_BR,
@Qte_Cde_Client      = i.Qte_Cde_Client,
@Qte_Cde_Fournisseur = i.Qte_Cde_Fournisseur,
@Qte_OF = i.Qte_OF,
@GestionStock = i.GestionStock,
@TestIntegrite = i.TestIntegrite,
@Origine = i.Origine,
@N_Document = i.N_Document,
@PU_Euro = i.PU_Euro,
@PU_Franc = i.PU_Franc,
@Qte_BL_Reservation = i.Qte_BL_Reservation
From inserted i

/*pas de gestion de stock pour le produit*/
IF( ISNULL( @GestionStock, 'Non' ) <> 'Oui' ) RETURN

IF( @Qte_Stock IS NULL ) SET @Qte_Stock = 0
IF( @Qte_BL IS NULL ) SET @Qte_BL = 0
IF( @Qte_BR IS NULL ) SET @Qte_BR = 0
IF( @Qte_Cde_Client IS NULL ) SET @Qte_Cde_Client = 0
IF( @Qte_Cde_Fournisseur IS NULL ) SET @Qte_Cde_Fournisseur = 0
IF( @Qte_OF IS NULL ) SET @Qte_OF = 0

SET @Qte_BL_Reservation = ISNULL(@Qte_BL_Reservation,0)

SET @LIGNE_STOCK_EXISTE =( SELECT Count(*) FROM STOCK_PRODUIT 
			WHERE (((( N_Produit = @N_Produit )OR( @N_Produit = 0 ))AND(( N_Fct_Base = @N_Fct_Base )OR( @N_Fct_Base = 0 )))
			AND( N_Depot = @N_Depot )) )

/* la ligne d'état du stock existe pour le produit*/
IF( ( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )AND( @LIGNE_STOCK_EXISTE > 0 ) )
BEGIN

IF( @Origine = 'BR' )
	BEGIN
		SET @Q = ISNULL( ( SELECT SUM( ST.Qte_Stock ) FROM STOCK_PRODUIT ST, DEPOT DEP, PRODUIT P WHERE P.N_Produit = @N_Produit AND P.N_Produit = ST.N_Produit AND DEP.N_Depot = ST.N_Depot ), 0.0 )
		UPDATE PRODUIT
			Set CMUP_Euro = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_BR * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_BR ),
			CMUP_Franc = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_BR * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_BR )*( SELECT TauxEuro FROM Devise, SOFT_INI WHERE DEVISE.N_Devise = SOFT_INI.N_Devise )
		WHERE N_Produit =  @N_Produit AND ( @Q + @Qte_BR ) <> 0.0
	END

IF( @Origine = 'ES' )
	BEGIN
		IF( ( SELECT Mode FROM ENTREE_SORTIE WHERE N_Entree_Sortie = @N_Document ) = 1 ) --retour d'affaire sur stock
			BEGIN
				SET @Q = ISNULL( ( SELECT SUM( ST.Qte_Stock ) FROM STOCK_PRODUIT ST, DEPOT DEP, PRODUIT P WHERE P.N_Produit = @N_Produit AND P.N_Produit = ST.N_Produit AND DEP.N_Depot = ST.N_Depot ), 0.0 )
				UPDATE PRODUIT
					Set CMUP_Euro = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_Stock * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_Stock ),
					     CMUP_Franc = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_Stock * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_Stock )*( SELECT TauxEuro FROM Devise, SOFT_INI WHERE DEVISE.N_Devise = SOFT_INI.N_Devise )
				WHERE N_Produit =  @N_Produit AND ( @Q + @Qte_Stock ) <> 0.0
			END
	END

UPDATE STOCK_PRODUIT
	SET Qte_Stock 		= Qte_Stock + @Qte_Stock,
	    Qte_BL    		= Qte_BL    + @Qte_BL,
	    Qte_BR    		= Qte_BR    + @Qte_BR,
	    Qte_Cde_Client      = Qte_Cde_Client + @Qte_Cde_Client,
	    Qte_Cde_Fournisseur = Qte_Cde_Fournisseur + @Qte_Cde_Fournisseur,
	    Qte_OF    		= Qte_OF    + @Qte_OF,
        Qte_BL_Reservation = ISNULL(Qte_BL_Reservation,0) + @Qte_BL_Reservation,
	    TestIntegrite = @TestIntegrite
WHERE (((( N_Produit = @N_Produit )OR( @N_Produit = 0 ))AND(( N_Fct_Base = @N_Fct_Base )OR( @N_Fct_Base = 0 )))
AND( N_Depot = @N_Depot ))

RETURN

END

/* la ligne détat du stock n'existe pas pour le produit*/
IF( ( ( @N_Produit > 0 )OR( @N_Fct_Base > 0 ) )AND( @LIGNE_STOCK_EXISTE = 0 ) )
BEGIN

IF( @Origine = 'BR' )
	BEGIN
		SET @Q = ISNULL( ( SELECT SUM( ST.Qte_Stock ) FROM STOCK_PRODUIT ST, DEPOT DEP, PRODUIT P WHERE P.N_Produit = @N_Produit AND P.N_Produit = ST.N_Produit AND DEP.N_Depot = ST.N_Depot ), 0.0 )
		UPDATE PRODUIT
			Set CMUP_Euro = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_BR * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_BR ),
			CMUP_Franc = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_BR * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_BR )*( SELECT TauxEuro FROM Devise, SOFT_INI WHERE DEVISE.N_Devise = SOFT_INI.N_Devise )
		WHERE N_Produit =  @N_Produit AND ( @Q + @Qte_BR ) <> 0.0
	END

IF( @Origine = 'ES' )
	BEGIN
		IF( ( SELECT Mode FROM ENTREE_SORTIE WHERE N_Entree_Sortie = @N_Document ) = 1 ) --retour d'affaire sur stock
			BEGIN
				SET @Q = ISNULL( ( SELECT SUM( ST.Qte_Stock ) FROM STOCK_PRODUIT ST, DEPOT DEP, PRODUIT P WHERE P.N_Produit = @N_Produit AND P.N_Produit = ST.N_Produit AND DEP.N_Depot = ST.N_Depot ), 0.0 )
				UPDATE PRODUIT
					Set CMUP_Euro = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_Stock * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_Stock ),
					      CMUP_Franc = ( ( @Q * ISNULL( CMUP_Euro, 0 ) ) + ( @Qte_Stock * ISNULL( @PU_Euro, 0 ) ) )/( @Q + @Qte_Stock )*( SELECT TauxEuro FROM Devise, SOFT_INI WHERE DEVISE.N_Devise = SOFT_INI.N_Devise )
				WHERE N_Produit =  @N_Produit AND ( @Q + @Qte_Stock ) <> 0.0
			END
	END

INSERT INTO 
STOCK_PRODUIT( N_Depot, N_Produit, N_Fct_Base, Qte_Stock, Qte_BL, Qte_BR, Qte_Cde_Client, Qte_Cde_Fournisseur, Qte_OF,Qte_BL_Reservation, TestIntegrite )
VALUES( @N_Depot, @N_Produit, @N_Fct_Base, @Qte_Stock, @Qte_BL, @Qte_BR, @Qte_Cde_Client, @Qte_Cde_Fournisseur, @Qte_OF,@Qte_BL_Reservation, @TestIntegrite )

RETURN

END
