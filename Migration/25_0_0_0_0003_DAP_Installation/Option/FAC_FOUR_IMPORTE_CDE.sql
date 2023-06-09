ALTER PROCEDURE [dbo].[FAC_FOUR_IMPORTE_CDE] 
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
, sc.N_Scd_Four
/* s{Col_Detail_Supp Code=Select Comment=Oui /} *//*  
, sc.StyleFonte
, sc.ColorFond
, sc.ColorTexte
, sc.numeric1
, sc.numeric2
, sc.date1
, sc.date2
, sc.check1
, sc.check2
, sc.Libre2
, sc.Libre3
, sc.Libre4
, sc.numeric3
, sc.numeric4
, sc.Fournisseur
, sc.Marque
*//* s{/Col_Detail_Supp Code=Select /} */ 
/* s{App_LigneId Code=Select /} */
, TypeFiche_Precedent = 112 
, N_Fiche_Precedent = sc.N_Cde_Four
, N_Detail_Precedent = sc.N_Scd_Four
, App_LigneId_Origine = sc.App_LigneId
/* s{/App_LigneId Code=Select /} */
    
from Scd_Four Sc
LEFT OUTER JOIN Activite A ON ( ( Sc.Rubrique = A.Code_Secteur )AND( A.Parent = 0 ) )
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = Sc.N_Affaire
WHERE Sc.N_Cde_Four = @N_Cde_Four

/* Ajouter cette ligne si on ne veut pas ramener des lignes s'il existe des BR rattachés à la commande */
-- AND NOT EXISTS (SELECT N_BR FROM BR WHERE N_CDE_Four = SC.N_CDE_four)
ORDER BY Sc.N_Position, Sc.N_Scd_Four



GO
