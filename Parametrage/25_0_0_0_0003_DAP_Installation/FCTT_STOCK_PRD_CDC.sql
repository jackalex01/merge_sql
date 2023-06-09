ALTER FUNCTION [FCTT_STOCK_PRD_CDC]
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
CDE.N_Cde_Cli, CDE.Num_Cde_Cli, CDE.Nom_Cde, CDE.Date_Cde,
CL.Nom_Client, D.Nom_Depot, I.Nom_Commercial,
cde=SUM( LI.Quantite ),
livre = ( SELECT SUM( SS.Qte ) FROM SS_BL SS
   LEFT OUTER JOIN dbo.BL BL ON BL.N_BL = SS.N_BL
WHERE( ( BL.Parent > 0 )
AND( SS.N_Cde_Client = CDE.N_Cde_Cli )
AND( SS.N_Produit = LI.N_Prod ) ) ),
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
FROM DEPOT D, CLIENT CL, LIGNECLI LI, CDE_CLI CDE
   LEFT OUTER JOIN dbo.ITC I ON CDE.N_ITC1 = I.N_ITC
WHERE ( CDE.N_Depot = D.N_Depot )AND
( ( CDE.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( LI.N_Cde_Cli = CDE.N_Cde_Cli )AND( LI.N_Prod = @N_Produit )AND
( CL.N_Client = CDE.N_Client )AND
( CDE.Parent > 0 )
GROUP BY CDE.N_Cde_Cli, CDE.Num_Cde_Cli, CDE.Nom_Cde, CDE.Date_Cde,
CL.Nom_Client, D.Nom_Depot, I.Nom_Commercial, LI.N_Prod
)

