ALTER FUNCTION [FCTT_STOCK_PRD_BR]
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
BR.N_BR, BR.Num_BR, BR.Nom_BR, BR.Date_BR,
FO.Nom_Fournisseur, D.Nom_Depot, I.Nom_Commercial,
livre   = SUM( SS.Qte ),
facture = ( SELECT SUM( SF.Quantite ) FROM SFACFOUR SF
   LEFT OUTER JOIN dbo.FAC_FOUR FF ON SF.N_Fac_Four = FF.N_Fac_Four
WHERE( ( FF.Parent > 0 )
AND( SF.N_BR = BR.N_BR )
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
StyleFonte=CAST( NULL as integer)
FROM DEPOT D, FOURNISS FO, SS_BR SS, dbo.BR BR
   LEFT OUTER JOIN dbo.ITC I ON BR.N_ITC = I.N_ITC
WHERE ( BR.N_Depot = D.N_Depot )AND
( ( BR.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( SS.N_BR = BR.N_BR )AND( SS.N_Produit = @N_Produit )AND
( FO.N_Fourniss = BR.N_Fournisseur )AND
( BR.Parent > 0 )
GROUP BY BR.N_BR, BR.Num_BR, BR.Nom_BR, BR.Date_BR,
FO.Nom_Fournisseur, D.Nom_Depot, I.Nom_Commercial, SS.N_Produit
)

