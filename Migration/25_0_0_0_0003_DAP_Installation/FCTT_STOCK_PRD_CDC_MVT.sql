ALTER FUNCTION [dbo].[FCTT_STOCK_PRD_CDC_MVT]
(     
@N_User int,
@N_Produit int,
@N_Depot int
)
RETURNS TABLE 
AS
RETURN 
(
SELECT
MVTS.N_Mvts_Stock,
MVTS.DateMvts,
D.Nom_Depot,
Nom_User = U.Nom + ' ' + U.Prenom,
MVTS.Qte_Cde_Client,
Libre1=CAST( NULL as varchar(100) ),
Libre2=CAST( NULL as varchar(100) ),
Libre3=CAST( NULL as varchar(100) ),
Libre4=CAST( NULL as varchar(100) ),
Numeric1=CAST( NULL as numeric(18,10) ),
Numeric2=CAST( NULL as numeric(18,10) ),
Numeric3=CAST( NULL as numeric(18,10) ),
Numeric4=CAST( NULL as numeric(18,10) ),
Date1=CAST( NULL as datetime),
Date2=CAST( NULL as datetime),
ColorFond=CAST( NULL as integer),
ColorTexte=CAST( NULL as integer),
StyleFonte=CAST( NULL as integer),
check1 = CAST(NULL AS varchar (3)),
check2 = CAST(NULL AS varchar (3))
FROM DEPOT D, MVTS_STOCK MVTS
   LEFT OUTER JOIN dbo.USERS U ON MVTS.User_Create = U.N_User
WHERE ( MVTS.N_Depot = D.N_Depot )AND
( MVTS.Qte_Cde_Client <> 0 )AND
( MVTS.N_Produit = @N_Produit )AND
( ( MVTS.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( MVTS.Origine = 'MA' )AND
( MVTS.GestionStock = 'Oui' )
)

GO
