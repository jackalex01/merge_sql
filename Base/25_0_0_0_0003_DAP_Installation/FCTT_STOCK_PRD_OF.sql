ALTER FUNCTION [FCTT_STOCK_PRD_OF]
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
ORDREF.N_OF, ORDREF.Num_OF, ORDREF.Nom_OF, ORDREF.Date_OF,
ORDREF.Delai, D.Nom_Depot, I.Nom_Commercial,
Qte=LF.Quantite*SUM(ORDREF.Qte),
Receptionne = LF.Quantite*( SELECT SUM( RF.Qte ) FROM dbo.RF RF
WHERE( ( RF.Parent > 0 )
AND( RF.N_OF = ORDREF.N_OF )
AND( RF.N_Fct_Base = ORDREF.N_Fct_Base ) ) ),
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
FROM DEPOT D, LFCT LF, dbo.ORDREF ORDREF
   LEFT OUTER JOIN dbo.ITC I ON ORDREF.N_ITC = I.N_ITC
WHERE ( ORDREF.N_Depot = D.N_Depot )AND
( LF.N_Fct_Base = ORDREF.N_Fct_Base )AND
( ( ORDREF.N_Depot = @N_Depot )OR( @N_Depot = -1 ) )AND
( LF.N_Produit = @N_Produit )AND
( ORDREF.Simuler = 'Non' )AND
( ORDREF.Parent > 0 )
GROUP BY ORDREF.N_OF, ORDREF.Num_OF, ORDREF.Nom_OF, ORDREF.Date_OF,
ORDREF.Delai, D.Nom_Depot, I.Nom_Commercial, ORDREF.N_Fct_Base, LF.Quantite
)

