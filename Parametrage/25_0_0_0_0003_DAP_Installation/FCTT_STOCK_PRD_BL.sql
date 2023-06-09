ALTER FUNCTION [FCTT_STOCK_PRD_BL]
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
BL.N_BL, BL.Num_BL, BL.Nom_BL, BL.Date_BL,
CL.Nom_Client, D.Nom_Depot, I.Nom_Commercial,
livre   = SUM( SS.Qte ),
facture = ( SELECT SUM( IIF(FC.Avoir = 'Oui', -1, 1) * SF.Quantite ) FROM SFCT_CLI SF
   LEFT OUTER JOIN dbo.FACT_CLI FC ON SF.N_Fact_Cli = FC.N_Fact_Cli
WHERE( ( FC.Parent > 0 )
AND( SF.N_BL = BL.N_BL )
AND( SF.N_Produit = SS.N_Produit ) ) ),
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
check2 = CAST(NULL AS varchar (3)),
Stock_Reservation = ISNULL(bl.Stock_Reservation,'Non'),
Pret = ISNULL(bl.Pret,'Non')
FROM DEPOT D, CLIENT CL, SS_BL SS, dbo.BL BL
   LEFT OUTER JOIN dbo.ITC I ON BL.N_ITC = I.N_ITC
WHERE ( BL.N_Depot = D.N_Depot )AND
( ( BL.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( SS.N_BL = BL.N_BL )AND( SS.N_Produit = @N_Produit )AND
( CL.N_Client = BL.N_Client )AND
( BL.Parent > 0 )
GROUP BY BL.N_BL, BL.Num_BL, BL.Nom_BL, BL.Date_BL,
CL.Nom_Client, D.Nom_Depot, I.Nom_Commercial, SS.N_Produit,ISNULL(bl.Stock_Reservation,'Non'),ISNULL(bl.Pret,'Non')
)



