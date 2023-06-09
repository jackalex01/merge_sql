ALTER PROCEDURE [DUPLIQUE_FCT_BASE_DEVISDETAIL]
@N int, @N_COPIE INT
AS

DECLARE @N_Ligne_COPIE INT


DECLARE @N_DevisDetail int, @Description varchar(50), @N_Devis int,
        @CodePoste varchar(50), @N_Rubrique int, @Quantite numeric(18,10),
        @Prix_U_Franc numeric(18,10), @Prix_U_Euro numeric(18,10),
        @Prix_Total_Franc numeric(18,10), @Prix_Total_Euro numeric(18,10),
        @Prix_U_Vente_Franc numeric(18,10), @Prix_U_Vente_Euro numeric(18,10),
        @Prix_U_Vente_net_Franc numeric(18,10),
        @Prix_U_Vente_net_Euro numeric(18,10), @coeff numeric(18,10),
        @Remise numeric(18,10), @Prix_Total_Vente_Franc numeric(18,10),
        @Prix_Total_Vente_Euro numeric(18,10), @Ref varchar(30),
        @N_Position numeric(18,10), @N_Produit int, @N_Fct_Base int,
        @Prix_Produit_Franc numeric(18,10), @Prix_Produit_Euro numeric(18,10),
        @Prix_MO_Franc numeric(18,10), @Prix_MO_Euro numeric(18,10),
        @Unite varchar(5), @Texte varchar(max), @N_LigneOrigine int,
        @Libre1 varchar(100), @Tva numeric(18,10), @StyleFonte int,
        @ColorFond int, @ColorTexte int, @Fournisseur varchar(50),
        @Prix_U_Base_Franc numeric(18,10), @Prix_U_Base_Euro numeric(18,10),
        @RemiseFourn numeric(18,10), @Marque varchar(50), @options int,
        @Invisible varchar(3), @numeric1 numeric(18,10),
        @numeric2 numeric(18,10), @date1 datetime, @date2 datetime,
        @check1 varchar(3), @check2 varchar(3), @genesys_lock varchar(3),
        @Libre2 varchar(100), @Libre3 varchar(100), @Libre4 varchar(100),
        @numeric3 numeric(18,10), @numeric4 numeric(18,10),
        @N_SpgLigneDevis int, @CodePoste_Visible varchar(50),
        @N_Dev_Arborescence int, @Titre int

--Creation du curseur
DECLARE DEVISDETAIL_Cursor CURSOR FOR
SELECT 
	N_DevisDetail = t.N_DevisDetail
   ,DESCRIPTION = T.Description
   ,N_Devis = @N_COPIE
   ,CodePoste = T.CodePoste
   ,N_Rubrique = T.N_Rubrique
   ,Quantite = T.Quantite
   ,Prix_U_Franc = T.Prix_U_Franc
   ,Prix_U_Euro = T.Prix_U_Euro
   ,Prix_Total_Franc = T.Prix_Total_Franc
   ,Prix_Total_Euro = T.Prix_Total_Euro
   ,Prix_U_Vente_Franc = T.Prix_U_Vente_Franc
   ,Prix_U_Vente_Euro = T.Prix_U_Vente_Euro
   ,Prix_U_Vente_net_Franc = T.Prix_U_Vente_net_Franc
   ,Prix_U_Vente_net_Euro = T.Prix_U_Vente_net_Euro
   ,coeff = T.coeff
   ,Remise = T.Remise
   ,Prix_Total_Vente_Franc = T.Prix_Total_Vente_Franc
   ,Prix_Total_Vente_Euro = T.Prix_Total_Vente_Euro
   ,Ref = T.Ref
   ,N_Position =  T.N_Position
   ,N_Produit = T.N_Produit
   ,N_Fct_Base = T.N_Fct_Base
   ,Prix_Produit_Franc = T.Prix_Produit_Franc
   ,Prix_Produit_Euro = T.Prix_Produit_Euro
   ,Prix_MO_Franc = T.Prix_MO_Franc
   ,Prix_MO_Euro = T.Prix_MO_Euro
   ,Unite = T.Unite
   ,Texte = T.Texte
   ,N_LigneOrigine = NULL
   ,Libre1 = T.Libre1
   ,Tva = CASE WHEN ISNULL(t.Tva,0) = 19.60 THEN CASE WHEN d.Tva_active IS NOT NULL  THEN d.Tva_active ELSE CASE WHEN c.Tva IS NOT NULL THEN c.Tva ELSE si.Tva_Active END END ELSE t.Tva END
   ,StyleFonte = T.StyleFonte
   ,ColorFond = T.ColorFond
   ,ColorTexte = T.ColorTexte
   ,Fournisseur = T.Fournisseur
   ,Prix_U_Base_Franc = T.Prix_U_Base_Franc
   ,Prix_U_Base_Euro = T.Prix_U_Base_Euro
   ,RemiseFourn = T.RemiseFourn
   ,Marque = T.Marque
   ,options = T.options
   ,Invisible = T.Invisible
   ,numeric1 = T.numeric1
   ,numeric2 = T.numeric2
   ,date1 = T.date1
   ,date2 = T.date2
   ,check1 = T.check1
   ,check2 = T.check2
   ,genesys_lock = 'Non'
   ,Libre2 = T.Libre2
   ,Libre3 = T.Libre3
   ,Libre4 = T.Libre4
   ,numeric3 = T.numeric3
   ,numeric4 = T.numeric4
   ,N_SpgLigneDevis = NULL
   ,CodePoste_Visible = T.CodePoste_Visible
   ,N_Dev_Arborescence = o.N_Dev_Arborescence
   ,Titre = T.Titre
FROM DEVISDETAIL T 
LEFT OUTER JOIN DEVIS d ON d.N_Devis = T.N_Devis
LEFT OUTER JOIN CLIENT c ON c.N_Client = d.N_Client
LEFT OUTER JOIN TB_DEV_ARBORESCENCE o ON o.N_Dev_Arborescence_Origine=t.N_Dev_Arborescence AND o.N_Devis=@N_COPIE
,Soft_ini si
WHERE t.N_Devis=@N AND ISNULL(t.N_Fct_Base,0) <> 0

--Ouverture du curseur
OPEN DEVISDETAIL_Cursor
--Pointe le premier enregistrement
FETCH FROM DEVISDETAIL_Cursor into @N_DevisDetail, @Description, @N_Devis,
                                   @CodePoste, @N_Rubrique, @Quantite,
                                   @Prix_U_Franc, @Prix_U_Euro,
                                   @Prix_Total_Franc, @Prix_Total_Euro,
                                   @Prix_U_Vente_Franc, @Prix_U_Vente_Euro,
                                   @Prix_U_Vente_net_Franc,
                                   @Prix_U_Vente_net_Euro, @coeff, @Remise,
                                   @Prix_Total_Vente_Franc,
                                   @Prix_Total_Vente_Euro, @Ref, @N_Position,
                                   @N_Produit, @N_Fct_Base, @Prix_Produit_Franc,
                                   @Prix_Produit_Euro, @Prix_MO_Franc,
                                   @Prix_MO_Euro, @Unite, @Texte,
                                   @N_LigneOrigine, @Libre1, @Tva, @StyleFonte,
                                   @ColorFond, @ColorTexte, @Fournisseur,
                                   @Prix_U_Base_Franc, @Prix_U_Base_Euro,
                                   @RemiseFourn, @Marque, @options, @Invisible,
                                   @numeric1, @numeric2, @date1, @date2,
                                   @check1, @check2, @genesys_lock, @Libre2,
                                   @Libre3, @Libre4, @numeric3, @numeric4,
                                   @N_SpgLigneDevis, @CodePoste_Visible,
                                   @N_Dev_Arborescence, @Titre
--Parcours le table
WHILE @@FETCH_STATUS = 0
BEGIN

	IF( @N_Fct_Base > 0 )
	BEGIN
		SET @Prix_U_Franc = ( SELECT SUM( ROUND(Prix_Total_Franc,2) ) FROM LFCT_DEVISDETAIL WHERE N_Ligne = @N_DevisDetail )
		SET @Prix_U_Euro = ( SELECT SUM( ROUND(Prix_Total_Euro,2) ) FROM LFCT_DEVISDETAIL WHERE N_Ligne = @N_DevisDetail )
		SET @Prix_Total_Franc = @Prix_U_Franc*@Quantite
		SET @Prix_Total_Euro = @Prix_U_Euro*@Quantite
		IF( @Prix_U_Franc <> 0.0 AND @Prix_U_Franc IS NOT NULL )
			SET @Coeff = (@Prix_U_Vente_Franc/@Prix_U_Franc)
		ELSE
			SET @Coeff = 0
	END

	INSERT INTO DEVISDETAIL
		(
		DESCRIPTION
		,N_Devis
		,CodePoste
		,N_Rubrique
		,Quantite
		,Prix_U_Franc
		,Prix_U_Euro
		,Prix_Total_Franc
		,Prix_Total_Euro
		,Prix_U_Vente_Franc
		,Prix_U_Vente_Euro
		,Prix_U_Vente_net_Franc
		,Prix_U_Vente_net_Euro
		,coeff
		,Remise
		,Prix_Total_Vente_Franc
		,Prix_Total_Vente_Euro
		,Ref
		,N_Position
		,N_Produit
		,N_Fct_Base
		,Prix_Produit_Franc
		,Prix_Produit_Euro
		,Prix_MO_Franc
		,Prix_MO_Euro
		,Unite
		,Texte
		,N_LigneOrigine
		,Libre1
		,Tva
		,StyleFonte
		,ColorFond
		,ColorTexte
		,Fournisseur
		,Prix_U_Base_Franc
		,Prix_U_Base_Euro
		,RemiseFourn
		,Marque
		,options
		,Invisible
		,numeric1
		,numeric2
		,date1
		,date2
		,check1
		,check2
		,genesys_lock
		,Libre2
		,Libre3
		,Libre4
		,numeric3
		,numeric4
		,N_SpgLigneDevis
		,CodePoste_Visible
		,N_Dev_Arborescence
		,Titre
        /* s{App_LigneId Code=Insert /} */
        ,TypeFiche_Precedent 
        ,N_Fiche_Precedent
        ,N_Detail_Precedent 
        ,App_LigneId_Origine
        /* s{/App_LigneId Code=Insert /} */   
		)
	SELECT 
		DESCRIPTION = @Description
		,N_Devis = @N_Devis
		,CodePoste = @CodePoste
		,N_Rubrique = @N_Rubrique
		,Quantite = @Quantite
		,Prix_U_Franc = @Prix_U_Franc
		,Prix_U_Euro = @Prix_U_Euro
		,Prix_Total_Franc = @Prix_Total_Franc
		,Prix_Total_Euro = @Prix_Total_Euro
		,Prix_U_Vente_Franc = @Prix_U_Vente_Franc
		,Prix_U_Vente_Euro = @Prix_U_Vente_Euro
		,Prix_U_Vente_net_Franc = @Prix_U_Vente_net_Franc
		,Prix_U_Vente_net_Euro = @Prix_U_Vente_net_Euro
		,coeff = @coeff
		,Remise = @Remise
		,Prix_Total_Vente_Franc = @Prix_Total_Vente_Franc
		,Prix_Total_Vente_Euro = @Prix_Total_Vente_Euro
		,Ref = @Ref
		,N_Position = @N_Position
		,N_Produit = 0
		,N_Fct_Base = @N_Fct_Base
		,Prix_Produit_Franc = @Prix_Produit_Franc
		,Prix_Produit_Euro = @Prix_Produit_Euro
		,Prix_MO_Franc = @Prix_MO_Franc
		,Prix_MO_Euro = @Prix_MO_Euro
		,Unite = @Unite
		,Texte = @Texte
		--Reprend la ligne de devisdetail d'origine afin de récupérer le détail de la fonction de base
		,N_LigneOrigine = @N_DevisDetail
		,Libre1 = @Libre1
		,Tva = @Tva
		,StyleFonte = @StyleFonte
		,ColorFond = @ColorFond
		,ColorTexte = @ColorTexte
		,Fournisseur = @Fournisseur
		,Prix_U_Base_Franc = @Prix_U_Base_Franc
		,Prix_U_Base_Euro = @Prix_U_Base_Euro
		,RemiseFourn = @RemiseFourn
		,Marque = @Marque
		,options = @options
		,Invisible = @Invisible
		,numeric1 = @numeric1
		,numeric2 = @numeric2
		,date1 = @date1
		,date2 = @date2
		,check1 = @check1
		,check2 = @check2
		,genesys_lock = @genesys_lock
		,Libre2 = @Libre2
		,Libre3 = @Libre3
		,Libre4 = @Libre4
		,numeric3 = @numeric3
		,numeric4 = @numeric4
		,N_SpgLigneDevis = @N_SpgLigneDevis
		,CodePoste_Visible = @CodePoste_Visible
		,N_Dev_Arborescence = @N_Dev_Arborescence
		,Titre = @Titre
        /* s{App_LigneId Code=Insert_Select /} */
        ,TypeFiche_Precedent = 123
        ,N_Fiche_Precedent = @N
        ,N_Detail_Precedent = @N_DevisDetail
        ,App_LigneId_Origine = ''
        /* s{/App_LigneId Code=Insert_Select /} */  

		
		SET @N_Ligne_COPIE = ( SELECT SCOPE_IDENTITY() )

	--Pointe l'enregistrement suivant
	FETCH NEXT FROM DEVISDETAIL_Cursor into @N_DevisDetail, @Description,
	                                        @N_Devis, @CodePoste, @N_Rubrique,
	                                        @Quantite, @Prix_U_Franc,
	                                        @Prix_U_Euro, @Prix_Total_Franc,
	                                        @Prix_Total_Euro,
	                                        @Prix_U_Vente_Franc,
	                                        @Prix_U_Vente_Euro,
	                                        @Prix_U_Vente_net_Franc,
	                                        @Prix_U_Vente_net_Euro, @coeff,
	                                        @Remise, @Prix_Total_Vente_Franc,
	                                        @Prix_Total_Vente_Euro, @Ref,
	                                        @N_Position, @N_Produit,
	                                        @N_Fct_Base, @Prix_Produit_Franc,
	                                        @Prix_Produit_Euro, @Prix_MO_Franc,
	                                        @Prix_MO_Euro, @Unite, @Texte,
	                                        @N_LigneOrigine, @Libre1, @Tva,
	                                        @StyleFonte, @ColorFond,
	                                        @ColorTexte, @Fournisseur,
	                                        @Prix_U_Base_Franc,
	                                        @Prix_U_Base_Euro, @RemiseFourn,
	                                        @Marque, @options, @Invisible,
	                                        @numeric1, @numeric2, @date1,
	                                        @date2, @check1, @check2,
	                                        @genesys_lock, @Libre2, @Libre3,
	                                        @Libre4, @numeric3, @numeric4,
	                                        @N_SpgLigneDevis,
	                                        @CodePoste_Visible,
	                                        @N_Dev_Arborescence, @Titre
END

--Fermeture du curseur
CLOSE DEVISDETAIL_Cursor
DEALLOCATE DEVISDETAIL_Cursor




