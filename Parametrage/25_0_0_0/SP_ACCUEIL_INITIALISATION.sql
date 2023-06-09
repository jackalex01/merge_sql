ALTER PROCEDURE [SP_ACCUEIL_INITIALISATION]
@N_User int
AS

DECLARE @N_Accueil integer

---------------------------------------------------------------------------------------------------
-- PS d'initialisation des tuiles.
-- Si l'enregistrement du N_User n'existe pas dans la table TB_ACCUEIL, le crée.
-- Puis crée les groupes de tuiles dans la table TB_ACCUEIL_GROUPE et les tuiles dans la table TB_ACCUEIL_TUILE.

-- Les noms des tuiles doivent être uniques.
-- Les noms des tuiles Système ne doivent pas être modifiés.
----------------------------------------------------------------------------------------------------

IF NOT EXISTS ( SELECT N_Accueil FROM TB_ACCUEIL WHERE N_USER = @N_User )
BEGIN
  -- Enregistrement dans la table TB_ACCUEIL
  INSERT INTO TB_ACCUEIL
	  ( 
	  N_User, 
	  Logo, 
	  Titre, 
	  NomFonte_Titre, 
	  StyleFonte_Titre, 
	  TailleFonte_Titre, 
	  ColorFonte_Titre
	  ) 
  SELECT
	  @N_User,
	  NULL,-- Si NULL, logo Everwin par défaut (valeur binaire)
	  'Everwin GX',
	  'Segoe UI',
	  0,
	  35,
	  16777215  
  
  -- Récupère le N_Accueil généré
  SET @N_Accueil = ( SELECT MAX( N_Accueil ) FROM TB_ACCUEIL )
  
    -- Enregistrements dans la table TB_ACCUEIL_GROUPE
  INSERT INTO TB_ACCUEIL_GROUPE
	  (
	  N_Accueil, 
	  NumGroupe,
	  Texte, 
	  Texte1, 
	  Texte2, 
	  Texte3, 
	  Texte4, 
	  Texte5,
	  NomFonte,
	  StyleFonte, 
	  TailleFonte, 
	  ColorFonte
	  )
  SELECT 
      @N_Accueil,
	  NumGroupe, 
	  CAST (Texte as varchar(50)), 
	  CAST (Texte1 as varchar(50)), 
	  CAST (Texte2 as varchar(50)), 
	  CAST (Texte3 as varchar(50)), 
	  CAST (Texte4 as varchar(50)), 
	  CAST (Texte5 as varchar(50)), 
	  CAST (NomFonte as varchar(20)), 
	  StyleFonte, 
	  TailleFonte, 
	  ColorFonte 
    FROM VUE_ACCUEIL_GROUPES_INITIALISATION
    ORDER BY NumGroupe

-- Enregistrements dans la table TB_ACCUEIL_TUILE
  INSERT INTO TB_ACCUEIL_TUILE
	  (
	  N_Accueil,
	  N_Accueil_Groupe,
	  Nom, 
	  Image, 
	  Taille,
	  AlignementImage, 
	  IndentX, 
	  IndentY, 
	  Texte, 
	  Texte1, 
	  Texte2, 
	  Texte3, 
	  Texte4, 
	  Texte5,
	  BeginColor,
	  EndColor,
	  BorderColor,
	  Raccourci,
	  Parametres,
	  NomFonte,
	  StyleFonte, 
	  TailleFonte, 
	  ColorFonte,
	  Visible,
	  IndexAction,
	  TuileSysteme  
	  )
  SELECT 
      @N_Accueil,
      (SELECT N_Accueil_Groupe FROM TB_ACCUEIL_GROUPE WHERE (NumGroupe = T.NumGroupe) AND (N_Accueil = @N_Accueil) ),
	  CAST (Nom as varchar(50)), 
	  Image, 
	  Taille, 
	  AlignementImage, 
	  IndentX, 
	  IndentY, 
	  CAST (Texte as varchar(50)), 
	  CAST (Texte1 as varchar(50)), 
	  CAST (Texte2 as varchar(50)), 
	  CAST (Texte3 as varchar(50)), 
	  CAST (Texte4 as varchar(50)), 
	  CAST (Texte5 as varchar(50)), 
	  BeginColor, 
	  EndColor, 
	  BorderColor, 
	  CAST (Raccourcis as varchar(255)), 
	  CAST (Parametres as varchar(255)), 
	  CAST (NomFonte as varchar(20)), 
	  StyleFonte, 
	  TailleFonte, 
	  ColorFonte, 
	  CAST (Visible as varchar(3)), 
	  IndexAction, 
	  CAST (TuileSysteme as varchar(3)) 

    FROM VUE_ACCUEIL_TUILES_INITIALISATION T
    ORDER BY NumGroupe, IndexInGroupe



END  

    /*                                                                  
    ================================================
     -> Tuiles pour la signature
    ================================================
    */
    IF EXISTS(SELECT 1 FROM sys.[procedures] p WHERE p.name ='SP_SIGN_ACCUEIL_INITIALISATION' ) 
    BEGIN
        EXEC SP_SIGN_ACCUEIL_INITIALISATION @N_user = @N_user 
    END


