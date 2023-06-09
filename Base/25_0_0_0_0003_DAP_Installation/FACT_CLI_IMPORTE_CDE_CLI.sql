ALTER PROCEDURE [FACT_CLI_IMPORTE_CDE_CLI]
@N_User integer, @N_Fact_Cli integer, @N_Cde_Cli integer, @N_Ligne integer
AS

--externalisation de la récupération du détail de la commande client en facture client
--@N_Ligne concerne la ligne de facturation prévisionnelle pour récupérer le % de facturation induit

IF EXISTS( SELECT N_LigneCli_Prev FROM LIGNECLI_PREV WHERE N_Scde_Cli = @N_Ligne )
BEGIN
select
LI.N_LigneCli,
N_Cde_Cli=@N_Cde_Cli,
LI.Reference,
LI.Designation, 
Li.Quantite,
LI.PU_Franc,
LI.PU_Euro,
LI.Remise,
LI.Tva,
LI.Activite,
N_Activites = A.N_Activites,
LI.Montant_Franc,
LI.Montant_Euro,
LI.N_Prod,
LI.N_Fct_Base,
LI.Unite,
LI.Texte,
LI.CodePoste,
LI.Libre1,
LI.Libre2,
LI.Libre3,
LI.Libre4,
LI.Numeric1,
LI.Numeric2,
LI.Date1,
LI.Date2,
LI.Check1,
LI.Check2,
genesys_lock = 'Non',
LI.StyleFonte,
LI.ColorFond,
LI.ColorTexte,
LI.Pourcentage,
LI.Fournisseur,
LI.Marque,
LI.PourcentageCumul,
LI.HT_Franc_Facturer_Cumul,
LI.HT_Euro_Facturer_Cumul,
LI.HT_Franc_Facturer_Prec,
LI.HT_Euro_Facturer_Prec,
LI.HT_Franc_Facturer,
LI.HT_Euro_Facturer
from LigneCli_Prev Li
LEFT OUTER JOIN dbo.Activite A ON ( ( Li.Activite = A.Code_Secteur )AND( A.Parent = 0 ) )
WHERE Li.N_Scde_Cli = @N_Ligne
ORDER BY Li.N_Position

END

ELSE

BEGIN
select
LI.N_LigneCli,
LI.N_Cde_Cli,
LI.Reference,
LI.Designation, 
Li.Quantite,
LI.PU_Franc,
LI.PU_Euro,
LI.Remise,
LI.Tva,
LI.Activite,
N_Activites = A.N_Activites,
LI.Montant_Franc,
LI.Montant_Euro,
LI.N_Prod,
LI.N_Fct_Base,
LI.Unite,
LI.Texte,
LI.CodePoste,
LI.Libre1,
LI.Libre2,
LI.Libre3,
LI.Libre4,
LI.Numeric1,
LI.Numeric2,
LI.Date1,
LI.Date2,
LI.Check1,
LI.Check2,
genesys_lock = 'Non',
LI.StyleFonte,
LI.ColorFond,
LI.ColorTexte,
pourcentage = ISNULL( SC.Pourcent, 100 )
from LigneCli Li
LEFT OUTER JOIN dbo.Activite A ON ( ( Li.Activite = A.Code_Secteur )AND( A.Parent = 0 ) )
LEFT OUTER JOIN dbo.SCDE_CLI SC ON ( SC.N_Scde_Cli = @N_Ligne )
WHERE Li.N_Cde_Cli = @N_Cde_Cli
ORDER BY Li.N_Position
END
