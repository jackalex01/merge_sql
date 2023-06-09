ALTER FUNCTION [dbo].[FCTT_STOCK_PRD_REAPPRO]
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
