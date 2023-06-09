ALTER PROCEDURE [PROPOSITION_CDE_FOUR_LISTE] 
@N_Affaire integer AS
BEGIN
 
SELECT
Type = 0,
N_Document = 0,
Nom_Document = '<Tous les devis liés à l''affaire>',
N_Affaire = @N_Affaire
 
UNION
 
SELECT
Type = 1,
N_Document = D.N_Devis,
Nom_Document = 'DEVIS N°' +LTRIM(STR(D.Num_Devis)),
N_Affaire = @N_Affaire
FROM DEVIS D, SDEVIS S
WHERE( S.N_Affaire = @N_Affaire )AND( S.N_Devis = D.N_Devis )AND( D.Parent > 0 )
 
UNION
 
SELECT
Type = 2,
N_Document = 0,
Nom_Document = '<Toutes les commandes liées à l''affaire>',
N_Affaire = @N_Affaire
 
UNION
 
SELECT
Type = 3,
N_Document = CDE.N_Cde_Cli,
Nom_Document = 'CDE CLIENT N°' + LTRIM(STR(CDE.Num_CDE_CLI)),
N_Affaire = @N_Affaire
FROM CDE_CLI CDE
WHERE( CDE.N_Affaire = @N_Affaire )AND( CDE.Parent > 0 )
 
UNION
 
SELECT 
      TYPE = 4
    , N_Document = 0
    , Nom_Document = '<Toutes les demandes d''approvisionnement liées à l''affaire>'
    , N_Affaire = @N_Affaire

UNION

SELECT 
      TYPE = 5
    , N_Document = t.N_Demande_Appro
    , Nom_Document = 'DDE APPRO N°' + LTRIM(STR(t.Num_Demande_Appro))
    , N_Affaire = @N_Affaire
FROM dbo.TB_DAP_DEMANDE_APPRO t
WHERE (t.N_Affaire = @N_Affaire) AND (t.Parent > 0)
 
ORDER BY Type, Nom_Document
 
 
END
 
 
 
 
 
 
 

