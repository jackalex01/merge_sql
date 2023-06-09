ALTER PROCEDURE [FAC_FOUR_IMPORTE_CDE] 
@N_Cde_Four int, @Ligne integer
AS

DECLARE @Pourcent numeric(18,10)
SET @Pourcent = ( SELECT TOP 1 Pourcentage FROM REGL_FOU WHERE N_Cde_Four = @N_Cde_Four AND N_Regl_Four = @Ligne )

select 
Sc.Quantite,
Sc.N_Prod,
Sc.Remise,
Sc.Tva,
Sc.Designation,
Sc.Texte,
Sc.Unite,
Sc.Ref,
Sc.CodePoste,
Sc.Libre1,
Sc.Prix_HT_Franc,
Sc.Total_Franc,
Sc.Prix_HT_Euro,
Sc.Total_Euro,
Sc.Rubrique,
N_Activites = A.N_Activites,
Sc.N_Affaire,
Affaire = AF.Designation,
Pourcentage = ISNULL( @Pourcent, 100.0 )
from Scd_Four Sc
LEFT OUTER JOIN Activite A ON ( ( Sc.Rubrique = A.Code_Secteur )AND( A.Parent = 0 ) )
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = Sc.N_Affaire
WHERE Sc.N_Cde_Four = @N_Cde_Four
ORDER BY Sc.N_Position, Sc.N_Scd_Four
