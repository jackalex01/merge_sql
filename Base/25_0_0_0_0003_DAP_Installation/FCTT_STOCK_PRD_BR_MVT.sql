ALTER FUNCTION [FCTT_STOCK_PRD_BR_MVT]
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
MVTS.Qte_BR,
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
StyleFonte=CAST( NULL as integer)
FROM DEPOT D, MVTS_STOCK MVTS
   LEFT OUTER JOIN dbo.USERS U ON MVTS.User_Create = U.N_User
WHERE ( MVTS.N_Depot = D.N_Depot )AND
( MVTS.Qte_BR <> 0 )AND
( MVTS.N_Produit = @N_Produit )AND
( ( MVTS.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( MVTS.Origine = 'MA' )AND
( MVTS.GestionStock = 'Oui' )
)

