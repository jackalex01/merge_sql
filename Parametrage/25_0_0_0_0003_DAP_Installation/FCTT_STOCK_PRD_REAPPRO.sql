ALTER FUNCTION [FCTT_STOCK_PRD_REAPPRO]
(     
@N_User int,
@SimulationOF int,
@N_Depot int,
@TypeDepot int,
@N_Famille_Produit int,
@TypeFamille INT
)
RETURNS TABLE 
AS
RETURN 
(
    SELECT 
          t.N_Produit
        , t.Nom_Produit
        , t.Ref_Constructeur
        , t.Nom_Depot
        , t.Code_Famille
        , t.QteATerme
        , t.QteMini
        , t.QteAppro
        , t.Libre1
        , t.Libre2
        , t.Libre3
        , t.Libre4
        , t.Numeric1
        , t.Numeric2
        , t.Numeric3
        , t.Numeric4
        , t.Date1
        , t.Date2
        , t.ColorFond
        , t.ColorTexte
        , t.StyleFonte
        , t.N_Famille_Produit
        , t.Type_Fiche
        , t.N_Fiche
        , t.ImageIndex_Fiche
        , t.Libelle_Fiche
        , t.Num_Gx_Fiche
        , t.Nom_Fiche
        , t.Descriptif_Fiche
        , t.Date_Fiche
        , t.Date_Appro_Fiche
        , t.Affaire_Fiche
    FROM dbo.[FCTT_DAP_PROPOSITION_DETAIL_FICHE_REAPPRO_PRD] (@N_user ,@SimulationOF ,@N_Depot ,@TypeDepot,@N_Famille_Produit ,@TypeFamille) t
   
)



/*
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create function [dbo].[FCTT_DAP_IMPORT]
Print 'Create function [dbo].[FCTT_DAP_IMPORT]'
GO

CREATE FUNCTION [dbo].[FCTT_DAP_IMPORT]
(
    @N_Demande_Appro INT 
    ,@N_User INT 
)
RETURNS TABLE 
AS
RETURN 
(
    SELECT 
         N_Import = T.N_Import
        ,N_Demande_Appro = T.N_Demande_Appro
        ,ImportID = T.ImportID
        ,Code_Page = T.Code_Page
        ,Type_Selection = T.Type_Selection
        ,Cle_Selection = T.Cle_Selection
        ,Nbre_Selection = T.Nbre_Selection
        ,Fichiers = T.Fichiers
        ,DESCRIPTION = T.Description
        ,Commentaire = T.Commentaire
        ,Date_Import = T.Date_Import
        ,Date_Creation = T.Date_Creation
        ,Version = T.Version
        ,Genesys_Lock = T.Genesys_Lock
        ,Libre1 = T.Libre1
        ,Libre2 = T.Libre2
        ,Libre3 = T.Libre3
        ,Libre4 = T.Libre4
        ,numeric1 = T.numeric1
        ,numeric2 = T.numeric2
        ,numeric3 = T.numeric3
        ,numeric4 = T.numeric4
        ,check1 = T.check1
        ,check2 = T.check2
        ,date1 = T.date1
        ,date2 = T.date2
        ,Imp_Article_Uniquement = T.Imp_Article_Uniquement
        ,Imp_Ignorer_Article_Enfant = T.Imp_Ignorer_Article_Enfant
        ,Imp_Ignorer_Article_Sans_Cle = T.Imp_Ignorer_Article_Sans_Cle
        ,Imp_Ignorer_Article_Sans_Prix_Vente = T.Imp_Ignorer_Article_Sans_Prix_Vente
        ,Imp_Ignorer_Article_Sans_Quantite = T.Imp_Ignorer_Article_Sans_Quantite
        ,Imp_Article_Agrege = T.Imp_Article_Agrege
        ,User_Create = T.User_Create
        ,Date_Create = T.Date_Create
        ,User_Modif = T.User_Modif
        ,Date_Modif = T.Date_Modif
        ,StyleFonte = T.StyleFonte
        ,ColorFond = T.ColorFond
        ,ColorTexte = T.ColorTexte   
        ,Nom_Import = trav.Nom_Travail
        ,Num_Gx = Tfi.Num_Gx
        ,Nom_Fiche = CASE WHEN t.Type_Selection IN (118) THEN tfc.Libelle ELSE CASE WHEN t.Type_Selection = 1221 THEN tfc.Libelle +' - '+ ISNULL(fp.Code_Famille,'')ELSE Tfi.Nom_Fiche END END
        ,Descriptif = Tfi.Descriptif
        ,Date_Piece = Tfi.Date_Piece
        ,Origine_Import = CAST('' AS varchar (100))
        ,Nom_User_Create = ISNULL(uc.Nom,'') + ' ' + ISNULL(uc.Prenom,'')
        ,Nom_User_Modif = ISNULL(um.Nom,'') + ' ' + ISNULL(um.Prenom,'')
    FROM TB_DAP_DEMANDE_APPRO da 
    INNER JOIN TB_DAP_IMPORT t ON t.N_Demande_Appro = da.N_Demande_Appro
    LEFT OUTER JOIN USERS uc ON t.User_Create = uc.N_User
    LEFT OUTER JOIN USERS um ON t.User_Modif = um.N_User
    OUTER APPLY dbo.FCTT_DAP_TYPE_FICHE_INFORMATION(t.Type_Selection,t.Cle_Selection) tfi 
    LEFT OUTER JOIN MGX_TB_STI_CFG_TRAVAIL trav ON t.Code_Page = 'FICHIER' AND t.Cle_Selection = trav.N_STI_Travail
    LEFT OUTER JOIN dbo.TYPE_FICHE_CONFIG tfc ON tfc.Type_Fiche = t.Type_Selection
    LEFT OUTER JOIN dbo.Famille_produit fp ON t.Type_Selection = 1221 AND t.Cle_Selection = fp.N_Famille_produit
    WHERE da.N_Demande_Appro = @N_Demande_Appro AND (t.Type_Selection <> 123 OR (t.Type_Selection = 123 AND (tfi.N_Affaire IS NULL OR Tfi.N_Affaire = 0 OR tfi.N_Affaire = da.N_Affaire)))
)
*/









