ALTER FUNCTION [dbo].[FCTT_STOCK_BL]
(     
@N_User int,
@TauxLocal numeric(18,10),
@N_Depot int,
@TypeDepot int,
@N_Client int,
@TypeClient int
)
RETURNS TABLE 
AS
RETURN 
(
SELECT
B.N_BL, B.Num_BL, B.Nom_BL, B.Date_BL, 
Montant_Franc=ROUND( B.Montant_Franc*(@TauxLocal / TauxEuro), 2 ), 
Montant_Euro = ROUND( B.Montant_Euro, 2 ), 
CL.Nom_Client, A.Designation, D.Nom_Depot,
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
B.ColorFond,
B.ColorTexte,
B.StyleFonte,
check1 = CAST(NULL AS varchar (3)),
check2 = CAST(NULL AS varchar (3)),
Pret = ISNULL(b.Pret,'Non'),
Stock_Reservation = ISNULL(b.Stock_Reservation,'Non')
FROM DEPOT D, CLIENT CL, BL B
   LEFT OUTER JOIN dbo.AFFAIRE A ON B.N_Affaire = A.N_Affaire
WHERE ( B.N_Depot = D.N_Depot )AND
( B.Parent > 0 )AND
( ( B.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( CL.N_Client = B.N_Client )AND
( ( B.N_Client = @N_Client )OR( @TypeClient = 0 ) )AND
( ( B.N_Fact_Cli IS NULL )OR( B.N_Fact_Cli = 0 ) )AND
( B.Parent > 0 )
)



GO
