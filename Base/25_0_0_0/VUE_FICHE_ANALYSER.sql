ALTER VIEW [VUE_FICHE_ANALYSER]
AS
SELECT     Description AS Nom_fiche, Tabl_
FROM         dbo.RUBRIQUE
WHERE     (ISNULL(Tabl_, '') <> '') AND (Parent = 1)
UNION ALL
SELECT     Description AS Nom_fiche, Tabl_
FROM         dbo.RUBRIQUE
WHERE     N_Rubrique = 1
UNION ALL
SELECT     Libelle AS Nom_fiche, dbo.TYPE_FICHE_CONFIG.Tabl_ --.*
FROM         dbo.TYPE_FICHE_CONFIG
WHERE     Type_Fiche in ( 126, 128, 130 ) --Tâche, Campagne, Rubrique


