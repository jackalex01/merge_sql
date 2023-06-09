ALTER FUNCTION [FCTT_STOCK_BR]
(     
@N_User int,
@TauxLocal numeric(18,10),
@N_Depot int,
@TypeDepot int,
@N_Fournisseur int,
@TypeFournisseur int
)
RETURNS TABLE 
AS
RETURN 
(
SELECT
B.N_BR, B.Num_BR, B.Nom_BR, B.Date_BR, 
Montant_Franc = ROUND( B.Montant_Franc*(@TauxLocal / TauxEuro), 2 ),
Montant_Euro = ROUND( B.Montant_Euro, 2 ),
F.Nom_Fournisseur, A.Designation, D.Nom_Depot,
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
B.StyleFonte
FROM DEPOT D, FOURNISS F, BR B
   LEFT OUTER JOIN dbo.AFFAIRE A ON B.N_Affaire = A.N_Affaire
WHERE ( B.N_Depot = D.N_Depot )AND
( ( B.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( F.N_Fourniss = B.N_Fournisseur )AND
( ( B.N_Fournisseur = @N_Fournisseur )OR(@TypeFournisseur = 0 ) )AND
( ( B.N_Fac_Four IS NULL )OR( B.N_Fac_Four = 0 ) )AND
( B.Parent > 0 )
)

