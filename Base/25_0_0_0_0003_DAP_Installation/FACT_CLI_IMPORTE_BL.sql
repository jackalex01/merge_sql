ALTER PROCEDURE [FACT_CLI_IMPORTE_BL] 
@N_BL int
AS


select 
Type = 1,
N_Position = SS.N_Position,
Qte = SS.Qte,
N_Fct_Base = SS.N_Fct_Base,
N_Produit = SS.N_Produit,
N_SS_BL= SS.N_SS_BL,
N_BL = @N_BL,
Remise = SS.Remise,
Tva = SS.Tva,
Designation = SS.Designation,
Texte = SS.Texte,
Unite = SS.Unite,
Ref_Produit = SS.Ref_Produit,
CodePoste = SS.CodePoste,
Libre1 = SS.Libre1,
N_Depot = SS.N_Depot,
PU_Euro = SS.PU_Euro,
HT_Euro = SS.Montant_Euro,
PU_Franc = SS.PU_Franc,
HT_Franc = SS.Montant_Franc,
N_Activites = A.N_Activites,
Activite = A.Code_Secteur
from SS_BL SS
LEFT OUTER JOIN dbo.Activite A 
  ON ( ( SS.Activite = A.Code_Secteur )AND( A.Parent = 0 ) )
WHERE SS.N_BL = @N_BL

UNION ALL

select 
TOP 1
Type = 0,
N_Position = NULL,
Qte = NULL,
N_Fct_Base = NULL,
N_Produit =  NULL,
N_SS_BL= NULL,
N_BL = NULL,
Remise = NULL,
Tva = NULL,
Designation = '*** BL n° ' + CAST( BL.Num_BL as varchar(10) )+ ' ***',
Texte = NULL,
Unite = NULL,
Ref_Produit = NULL,
CodePoste = NULL,
Libre1 = NULL,
N_Depot = BL.N_DEPOT,
PU_Euro = NULL,
HT_Euro = NULL,
PU_Franc = NULL,
HT_Franc = NULL,
N_Activites = NULL,
Activite = NULL
from SS_BL SS, BL BL
WHERE SS.N_BL = @N_BL AND BL.N_BL = SS.N_BL


ORDER BY Type, N_Position, N_SS_BL


