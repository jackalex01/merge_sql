ALTER PROCEDURE [SP_DEV_ARBORESCENCE_DUPLIQUE] 
@N_Dev_Arborescence_Origine integer, 
@N_Dev_Arborescence_Dest integer, 
@N_User integer,
@Couper integer /* 0 si c'est un copier-Coller; 1 si c'est un Couper-Coller */

AS
SET NOCOUNT ON;

/* PS de duplication d'un noeud de l'arborescence */

DECLARE 
	@N_Devis_Origine int, 
	@Niveau_Origine int,
	@ListeEnfants_Origine varchar(max),
	@N_Devis_Dest int, 
	@N_Code_Dest varchar(50),
	@Niveau_Dest int,
	@Options_Dest int,
	@N int,
	@N_Dev_Arborescence int,
	@N_Dev_Arborescence_Copie int
	
SET @N = 0
SET @N_Dev_Arborescence_Copie = @N_Dev_Arborescence_Dest

-- Récupération des clés primaires des devis d'origine et de destination
SELECT	
  @N_Devis_Origine		= N_devis,
  @Niveau_Origine		= Niveau,
  @ListeEnfants_Origine	= ListeEnfants 
FROM TB_DEV_ARBORESCENCE WHERE ( N_Dev_Arborescence = @N_Dev_Arborescence_Origine )  	

SELECT	
  @N_Devis_Dest			= N_devis,
  @N_Code_Dest			= Code,
  @Niveau_Dest			= Niveau,
  @Options_Dest			= ISNULL( (SELECT Options FROM DEVISDETAIL D WHERE ( ( D.N_Dev_Arborescence = @N_Dev_Arborescence_Dest ) AND ( D.Titre > 0 ) ) ) ,0)
FROM TB_DEV_ARBORESCENCE WHERE ( N_Dev_Arborescence = @N_Dev_Arborescence_Dest )  	


/*  
-----------------------------------------------------------------------
 * Copie du noeud de l'arborescence et de tous les noeuds enfants
-----------------------------------------------------------------------
*/

-- Réinitialisation du N_Dev_Arborescence_Origine sur le devis de destination
UPDATE TB_DEV_ARBORESCENCE
SET N_Dev_Arborescence_Origine = NULL
WHERE N_Devis = @N_Devis_Dest

--Creation du curseur
DECLARE TB_DEV_ARBORESCENCE_Cursor CURSOR DYNAMIC FOR
SELECT N_Dev_Arborescence  
FROM TB_DEV_ARBORESCENCE T
WHERE ( T.N_Devis = @N_Devis_Origine ) AND ( @ListeEnfants_Origine like '%;' + cast(T.N_Dev_Arborescence as varchar(10))+';%' ) 
ORDER BY T.Code, T.Niveau

--Ouverture du curseur
OPEN TB_DEV_ARBORESCENCE_Cursor
--Pointe le premier enregistrement
FETCH FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
--Parcourt le table
WHILE @@FETCH_STATUS = 0
BEGIN

	INSERT INTO TB_DEV_ARBORESCENCE
	  (
		N_Devis
	   ,Code
	   ,Chapitre
	   ,Parent
	   ,Niveau
	   ,NumOrdre
	   ,IdUnique
	   ,N_Dev_Arborescence_Origine
	  )
	  SELECT 
  		 N_Devis	= @N_Devis_Dest
		 ,Code		= CASE WHEN @N = 0 THEN dbo.FCT_DEV_CALCUL_CODE_POSTE_NOUVEAU_NOEUD( @N_Dev_Arborescence_Dest ) ELSE dbo.FCT_DEV_CALCUL_CODE_POSTE_NOUVEAU_NOEUD( O.N_Dev_Arborescence ) END
		 ,Chapitre	= T.Chapitre
		 ,Parent	= CASE WHEN @N = 0 THEN @N_Dev_Arborescence_Dest ELSE O.N_Dev_Arborescence END
		 ,Niveau	= ( T.Niveau - @Niveau_Origine ) + @Niveau_Dest + 1
		 ,NumOrdre  = T.NumOrdre
		 ,IdUnique  = T.IdUnique
		 ,N_Dev_Arborescence_Origine = T.N_Dev_Arborescence
	  FROM TB_DEV_ARBORESCENCE T
	  LEFT OUTER JOIN TB_DEV_ARBORESCENCE O ON ( O.N_Dev_Arborescence_Origine = T.Parent ) AND ( O.N_Devis=@N_Devis_Dest )
	  WHERE T.N_Dev_Arborescence = @N_Dev_Arborescence
	
	  IF @N = 0 SET @N_Dev_Arborescence_Copie = ( SELECT SCOPE_IDENTITY() )

	  SET @N = @N + 1
	  
	  --Pointe l'enregistrement suivant
	  FETCH NEXT FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
END

--Fermeture du curseur
CLOSE TB_DEV_ARBORESCENCE_Cursor
DEALLOCATE TB_DEV_ARBORESCENCE_Cursor



/*                                                                 
------------------------------------------------
 * Copie du corps du devis
------------------------------------------------
*/

/*                                                                 
---------------------------------------------------
 * Copie les lignes de détail sans fonction de base
---------------------------------------------------
*/

INSERT INTO DEVISDETAIL
  (
    -- N_DevisDetail -- this column value is auto-generated
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
	DESCRIPTION = T.Description
   ,N_Devis = @N_Devis_Dest
   ,CodePoste = ( SELECT Code FROM TB_DEV_ARBORESCENCE WHERE N_Dev_Arborescence = O.N_Dev_Arborescence)
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
   ,N_Position =  T.N_Position - ROUND(T.N_Position, 0, 1) + O.N_Dev_Arborescence
   ,N_Produit = T.N_Produit
   ,N_Fct_Base = T.N_Fct_Base
   ,Prix_Produit_Franc = T.Prix_Produit_Franc
   ,Prix_Produit_Euro = T.Prix_Produit_Euro
   ,Prix_MO_Franc = T.Prix_MO_Franc
   ,Prix_MO_Euro = T.Prix_MO_Euro
   ,Unite = T.Unite
   ,Texte = T.Texte
   ,N_LigneOrigine = CASE WHEN ISNULL(T.N_Fct_Base,0) = 0 THEN NULL ELSE T.N_devisdetail END
   ,Libre1 = T.Libre1
   ,Tva = T.Tva
   ,StyleFonte = T.StyleFonte
   ,ColorFond = T.ColorFond
   ,ColorTexte = T.ColorTexte
   ,Fournisseur = T.Fournisseur
   ,Prix_U_Base_Franc = T.Prix_U_Base_Franc
   ,Prix_U_Base_Euro = T.Prix_U_Base_Euro
   ,RemiseFourn = T.RemiseFourn
   ,Marque = T.Marque
   ,options = CASE WHEN @Options_Dest = 1 THEN 1 ELSE T.options END-- si le chapitre de destination est en option, le chapitre collé doit être en option.
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
   ,CodePoste_Visible = ( CASE ISNULL(T.Titre,0) WHEN 0 THEN '' ELSE REPLICATE('    ', O.Niveau ) +  O.Code END ) 
   ,N_Dev_Arborescence = O.N_Dev_Arborescence
   ,Titre = ( CASE ISNULL(T.Titre,0) WHEN 0 THEN 0 ELSE O.Niveau END )
   /* s{App_LigneId Code=Insert_Select /} */
   ,TypeFiche_Precedent = 123
   ,N_Fiche_Precedent = @N_Devis_Origine
   ,N_Detail_Precedent = t.N_DevisDetail
   ,App_LigneId_Origine = ''
   /* s{/App_LigneId Code=Insert_Select /} */
FROM DEVISDETAIL T 
LEFT OUTER JOIN DEVIS D ON D.N_Devis = T.N_Devis
LEFT OUTER JOIN CLIENT C ON C.N_Client = D.N_Client
LEFT OUTER JOIN TB_DEV_ARBORESCENCE O ON O.N_Dev_Arborescence_Origine = T.N_Dev_Arborescence 
,Soft_ini si
WHERE	( T.N_Devis=@N_Devis_Origine ) AND 
		( O.N_Devis=@N_Devis_Dest ) AND
		( ISNULL(T.N_Fct_Base,0) = 0 ) AND 
		( @ListeEnfants_Origine like '%;' + cast(T.N_Dev_Arborescence as varchar(10))+';%' ) 



/*                                                                 
-------------------------------------------------------------------------------------------------------------
 * Copie les lignes de détail avec fonction de base (utilisation d'un curseur pour que le déclencheur se joue)
-------------------------------------------------------------------------------------------------------------
*/
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
        @N_SpgLigneDevis int, @CodePoste_Visible varchar(50),@Titre int

--Creation du curseur
DECLARE DEVISDETAIL_Cursor CURSOR FOR
SELECT 
	N_DevisDetail = T.N_DevisDetail,
	DESCRIPTION = T.Description
   ,N_Devis = @N_Devis_Dest
   ,CodePoste = ( SELECT Code FROM TB_DEV_ARBORESCENCE WHERE N_Dev_Arborescence = O.N_Dev_Arborescence)
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
   ,N_Position =  T.N_Position - ROUND(T.N_Position, 0, 1) + O.N_Dev_Arborescence
   ,N_Produit = T.N_Produit
   ,N_Fct_Base = T.N_Fct_Base
   ,Prix_Produit_Franc = T.Prix_Produit_Franc
   ,Prix_Produit_Euro = T.Prix_Produit_Euro
   ,Prix_MO_Franc = T.Prix_MO_Franc
   ,Prix_MO_Euro = T.Prix_MO_Euro
   ,Unite = T.Unite
   ,Texte = T.Texte
   ,N_LigneOrigine = CASE WHEN ISNULL(T.N_Fct_Base,0) = 0 THEN NULL ELSE T.N_devisdetail END
   ,Libre1 = T.Libre1
   ,Tva = T.Tva
   ,StyleFonte = T.StyleFonte
   ,ColorFond = T.ColorFond
   ,ColorTexte = T.ColorTexte
   ,Fournisseur = T.Fournisseur
   ,Prix_U_Base_Franc = T.Prix_U_Base_Franc
   ,Prix_U_Base_Euro = T.Prix_U_Base_Euro
   ,RemiseFourn = T.RemiseFourn
   ,Marque = T.Marque
   ,options = CASE WHEN @Options_Dest = 1 THEN 1 ELSE T.options END-- si le chapitre de destination est en option, le chapitre collé doit être en option.
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
   ,CodePoste_Visible = ( CASE ISNULL(T.Titre,0) WHEN 0 THEN '' ELSE REPLICATE('    ', O.Niveau ) +  O.Code END ) 
   ,N_Dev_Arborescence = O.N_Dev_Arborescence
   ,Titre = ( CASE ISNULL(T.Titre,0) WHEN 0 THEN 0 ELSE O.Niveau END )
FROM DEVISDETAIL T 
LEFT OUTER JOIN DEVIS D ON D.N_Devis = T.N_Devis
LEFT OUTER JOIN CLIENT C ON C.N_Client = D.N_Client
LEFT OUTER JOIN TB_DEV_ARBORESCENCE O ON O.N_Dev_Arborescence_Origine = T.N_Dev_Arborescence 
,Soft_ini si
WHERE	( T.N_Devis=@N_Devis_Origine ) AND 
		( O.N_Devis=@N_Devis_Dest ) AND
		( ISNULL(T.N_Fct_Base,0) <> 0 ) AND 
		( @ListeEnfants_Origine like '%;' + cast(T.N_Dev_Arborescence as varchar(10))+';%' ) 


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
--Parcourt le table
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
        ,N_Fiche_Precedent = @N_Devis_Origine
        ,N_Detail_Precedent = @N_DevisDetail
        ,App_LigneId_Origine = ''
        /* s{/App_LigneId Code=Insert_Select /} */

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


/*                                                                 
-----------------------------------------------------------------------------------------------------------------------------------
Cas du Couper-Coller
------------------------------------------------------------------------------------------------------------------------------------
*/
-- Si c'est un couper, supprime le noeud Origine et tous les enfants
IF ( @Couper = 1 )
    BEGIN
        --Creation du curseur
		DECLARE TB_DEV_ARBORESCENCE_Cursor CURSOR DYNAMIC FOR
		SELECT N_Dev_Arborescence  
		FROM TB_DEV_ARBORESCENCE T
		WHERE ( T.N_Devis = @N_Devis_Origine ) AND ( @ListeEnfants_Origine like '%;' + cast(T.N_Dev_Arborescence as varchar(10))+';%' ) 
		ORDER BY T.Code, T.Niveau

		--Ouverture du curseur
		OPEN TB_DEV_ARBORESCENCE_Cursor
		--Pointe le premier enregistrement
		FETCH FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
		--Parcourt le table
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    -- Suppression du noeud de la table TB_DEV_ARBORESCENCE
		    DELETE TB_DEV_ARBORESCENCE WHERE N_Dev_Arborescence = @N_Dev_Arborescence
		    -- Suppression des lignes de détail
		    DELETE DEVISDETAIL WHERE N_Dev_Arborescence = @N_Dev_Arborescence

			--Pointe l'enregistrement suivant
			FETCH NEXT FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
		END

		--Fermeture du curseur
		CLOSE TB_DEV_ARBORESCENCE_Cursor
		DEALLOCATE TB_DEV_ARBORESCENCE_Cursor
		
		
		/*                                                                 
		-----------------------------------------------------------------------------------------------------------------------------------
		recalcule les codes postes
		------------------------------------------------------------------------------------------------------------------------------------
		*/
		  
		IF (@N_Devis_Origine = @N_Devis_Dest)
			BEGIN
				UPDATE TB_DEV_ARBORESCENCE
				SET Code = dbo.FCT_DEV_CALCUL_CODE_POSTE( N_Dev_Arborescence ) 
				WHERE ( Niveau > 0 ) AND ( N_Devis = @N_Devis_Dest )
			
				UPDATE DEVISDETAIL
				SET CodePoste_Visible = (SELECT REPLICATE('    ', tda.Niveau ) +  tda.code FROM TB_DEV_ARBORESCENCE AS tda where tda.N_Dev_Arborescence = DEVISDETAIL.N_Dev_Arborescence)
				WHERE ( titre > 0 ) AND ( N_Devis = @N_Devis_Dest )

				UPDATE DEVISDETAIL
				SET CodePoste = (SELECT tda.code FROM TB_DEV_ARBORESCENCE AS tda where tda.N_Dev_Arborescence = DEVISDETAIL.N_Dev_Arborescence)
				WHERE ( N_Devis = @N_Devis_Dest )
			END

		IF (@N_Devis_Origine <> @N_Devis_Dest)
			BEGIN
				UPDATE TB_DEV_ARBORESCENCE
				SET Code = dbo.FCT_DEV_CALCUL_CODE_POSTE( N_Dev_Arborescence ) 
				WHERE ( Niveau > 0 ) AND ( N_Devis = @N_Devis_Origine )
			
				UPDATE DEVISDETAIL
				SET CodePoste_Visible = (SELECT REPLICATE('    ', tda.Niveau ) +  tda.code FROM TB_DEV_ARBORESCENCE AS tda where tda.N_Dev_Arborescence = DEVISDETAIL.N_Dev_Arborescence)
				WHERE ( titre > 0 ) AND ( N_Devis = @N_Devis_Origine )

				UPDATE DEVISDETAIL
				SET CodePoste = (SELECT tda.code FROM TB_DEV_ARBORESCENCE AS tda where tda.N_Dev_Arborescence = DEVISDETAIL.N_Dev_Arborescence)
				WHERE ( N_Devis = @N_Devis_Origine )
			END
		
    END



/*                                                                 
------------------------------------------------
 * Recalcul des devis de départ et d'arrivée
------------------------------------------------
*/
EXECUTE SP_DEV_RECAP_DEVIS_DETAIL @N_Devis_Dest
IF (@N_Devis_Origine <> @N_Devis_Dest)
  EXECUTE SP_DEV_RECAP_DEVIS_DETAIL @N_Devis_Origine


SELECT N_Dev_Arborescence = @N_Dev_Arborescence_Copie -- Numéro du noeud dupliqué


SET NOCOUNT OFF

