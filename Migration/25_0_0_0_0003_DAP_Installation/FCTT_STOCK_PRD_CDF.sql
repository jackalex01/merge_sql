ALTER FUNCTION [dbo].[FCTT_STOCK_PRD_CDF]
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
CDE.N_Cde_Four, CDE.Num_Cde_Four, CDE.Nom_Cde_Four, CDE.Date_Com,
FO.Nom_Fournisseur, D.Nom_Depot, I.Nom_Commercial,
cde=SUM( SCD.Quantite ),
livre = ( SELECT SUM( SS.Qte ) FROM SS_BR SS
   LEFT OUTER JOIN dbo.BR BR ON BR.N_BR = SS.N_BR
WHERE( ( BR.Parent > 0 )
AND( SS.N_Cde_Four = CDE.N_Cde_Four )
AND( SS.N_Produit = SCD.N_Prod ) ) ),
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
FROM DEPOT D, FOURNISS FO, SCD_FOUR SCD, CDE_FOUR CDE
   LEFT OUTER JOIN dbo.ITC I ON CDE.N_ITC = I.N_ITC
WHERE ( CDE.N_Depot = D.N_Depot )AND
( ( CDE.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( SCD.N_Cde_Four = CDE.N_Cde_Four )AND( SCD.N_Prod = @N_Produit )AND
( FO.N_Fourniss = CDE.N_Four )AND
( CDE.Parent > 0 )
GROUP BY CDE.N_Cde_Four, CDE.Num_Cde_Four, CDE.Nom_Cde_Four, CDE.Date_Com,
FO.Nom_Fournisseur, D.Nom_Depot, I.Nom_Commercial, SCD.N_Prod
)

GO
