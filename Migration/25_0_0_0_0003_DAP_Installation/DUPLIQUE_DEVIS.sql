ALTER PROCEDURE [dbo].[DUPLIQUE_DEVIS] 
@N integer, @N_User integer
AS
SET NOCOUNT ON;

DECLARE 
	@N_Dev_Arborescence INT 
	,@N_Dev_Arborescence_Copie INT 

	
/*détermine le dépot adéquat en fonction des droits
si droits restreint à une agence on force la copie sur cette agence*/
DECLARE 
@Creation int,
@N_DepotFiche int

SET @N_DepotFiche = ( SELECT N_Depot FROM DEVIS WHERE N_Devis = @N)
IF ISNULL( @N_DepotFiche, 0 ) = 0 SET @N_DepotFiche = (SELECT N_Depot FROM Depot WHERE Depot_Principal = 'Oui')
IF((SELECT Admin FROM USERS WHERE N_User = @N_User)<>'Oui')
BEGIN
	EXECUTE DROIT_CREATION_FICHE 123, @N_User, @N_DepotFiche, @Creation OUTPUT
	DECLARE @N_DepotUser int
	IF( @Creation IS NULL OR @Creation <> 1 ) 
		BEGIN
		/* par défaut, le dépôt d'appartenance de l'utilisateur */
		SET @N_DepotUser = ( SELECT I.N_Depot
		From USERS U, ITC I
		WHERE( U.N_User = @N_User )AND( U.N_ITC = I.N_ITC )AND( I.Parent > 0 )AND( I.Actif = 'Oui' ))
		/* on prend le dépôt du user */
		IF ISNULL( @N_DepotUser, 0 ) <> 0 SET @N_DepotFiche = @N_DepotUser
		END
END


/*récupère le chrono suivant*/
DECLARE @CHRONO int
EXECUTE CHRONO_DEVIS  @CHRONO OUTPUT


INSERT INTO DEVIS
  (
    Nom_Devis
   ,Date_Relance
   ,Total_Heure
   ,Total_Ht_Heure_Franc
   ,Total_Ht_Heure_Euro
   ,Total_Ht_Produit_Franc
   ,Total_Ht_Produit_Euro
   ,Total_Ht_Frais_Franc
   ,Total_Ht_Frais_Euro
   ,Total_Frais_Vente_Franc
   ,Total_Frais_Vente_Euro
   ,Total_Heure_Vente_Franc
   ,Total_Heure_Vente_Euro
   ,Total_Produit_Vente_Franc
   ,Total_Produit_Vente_Euro
   ,Total_Revient_Franc
   ,Total_Revient_Euro
   ,Total_Vente_Franc
   ,Total_Vente_Euro
   ,Coef_Frais
   ,Coef_Main
   ,Coef_Achat
   ,Coef_Total
   ,Explication_Frais
   ,Commentaire
   ,DESCRIPTION
   ,N_Client
   ,N_Projet
   ,Libelle1
   ,Champ1
   ,Libelle2
   ,Champ2
   ,Libelle3
   ,Champ3
   ,Libelle4
   ,Champ4
   ,Libelle5
   ,Champ5
   ,Libelle6
   ,Champ6
   ,Libelle7
   ,Champ7
   ,Libelle8
   ,Champ8
   ,Parent
   ,Date_Creation
   ,Num_Devis
   ,Nom_Adresse
   ,Adresse1
   ,Adresse2
   ,Adresse3
   ,Intention
   ,N_Ville_Adresse
   ,N_Pays_Adresse
   ,coef_Achat_Defaut
   ,coef_Frais_Defaut
   ,Coef_Main_Defaut
   ,Ent_Devis_L1
   ,Ent_Devis_L2
   ,Pied_Devis_L1
   ,Pied_Devis_L2
   ,Pied_Devis_L3
   ,Tva_active
   ,Nom_Ville_Adresse
   ,Nom_Pays_Adresse
   ,Code_Postal_Adresse
   ,N_Itc
   ,PrixMoyMO_Franc
   ,PrixMoyMO_Euro
   ,PourcentProduit
   ,StyleFonte
   ,ColorFond
   ,ColorTexte
   ,User_Create
   ,Date_Create
   ,User_Modif
   ,Date_Modif
   ,Reussite
   ,DateCdePrev
   ,TempsRealisation
   ,DelaiRealisation
   ,Resultat
   ,DateResultat
   ,N_Depot
   ,GrilleUnique
   ,Champ9
   ,Champ10
   ,Champ11
   ,Champ12
   ,Champ13
   ,Champ14
   ,Champ15
   ,Champ16
   ,Champ17
   ,Champ18
   ,Champ19
   ,Champ20
   ,Champ21
   ,Champ22
   ,Champ23
   ,Champ24
   ,Champ25
   ,Champ26
   ,Champ27
   ,Champ28
   ,N_Devise
   ,TauxEuro
   ,Total_Tva_Franc
   ,Total_Tva_Euro
   ,Total_Ttc_Franc
   ,Total_Ttc_Euro
   ,Champ29
   ,Champ30
   ,Champ31
   ,Champ32
   ,Champ33
   ,Champ34
   ,Champ35
   ,Champ36
   ,Champ37
   ,Champ38
   ,Champ39
   ,Champ40
   ,Champ41
   ,Champ42
   ,Champ43
   ,Champ44
   ,Champ45
   ,Champ46
   ,Champ47
   ,Champ48
   ,Champ49
   ,Champ50
   ,Champ51
   ,Champ52
   ,AlertePlanning
   ,ModeImpression
   ,N_Modele_Impression
   ,User_Print
   ,date_Print
   ,N_QrCode
   ,N_SpgDealId
   ,N_SpgEnteteDevis
)
SELECT 
	Nom_Devis =LEFT(t.Nom_Devis+' (COPIE)',50)
   ,Date_Relance = T.Date_Relance
   ,Total_Heure = T.Total_Heure
   ,Total_Ht_Heure_Franc = T.Total_Ht_Heure_Franc
   ,Total_Ht_Heure_Euro = T.Total_Ht_Heure_Euro
   ,Total_Ht_Produit_Franc = T.Total_Ht_Produit_Franc
   ,Total_Ht_Produit_Euro = T.Total_Ht_Produit_Euro
   ,Total_Ht_Frais_Franc = T.Total_Ht_Frais_Franc
   ,Total_Ht_Frais_Euro = T.Total_Ht_Frais_Euro
   ,Total_Frais_Vente_Franc = T.Total_Frais_Vente_Franc
   ,Total_Frais_Vente_Euro = T.Total_Frais_Vente_Euro
   ,Total_Heure_Vente_Franc = T.Total_Heure_Vente_Franc
   ,Total_Heure_Vente_Euro = T.Total_Heure_Vente_Euro
   ,Total_Produit_Vente_Franc = T.Total_Produit_Vente_Franc
   ,Total_Produit_Vente_Euro = T.Total_Produit_Vente_Euro
   ,Total_Revient_Franc = T.Total_Revient_Franc
   ,Total_Revient_Euro = T.Total_Revient_Euro
   ,Total_Vente_Franc = T.Total_Vente_Franc
   ,Total_Vente_Euro = T.Total_Vente_Euro
   ,Coef_Frais = T.Coef_Frais
   ,Coef_Main = T.Coef_Main
   ,Coef_Achat = T.Coef_Achat
   ,Coef_Total = T.Coef_Total
   ,Explication_Frais = T.Explication_Frais
   ,Commentaire = T.Commentaire
   ,DESCRIPTION = T.Description
   ,N_Client = T.N_Client
   ,N_Projet = T.N_Projet
   ,Libelle1 = T.Libelle1
   ,Champ1 = T.Champ1
   ,Libelle2 = T.Libelle2
   ,Champ2 = T.Champ2
   ,Libelle3 = T.Libelle3
   ,Champ3 = T.Champ3
   ,Libelle4 = T.Libelle4
   ,Champ4 = T.Champ4
   ,Libelle5 = T.Libelle5
   ,Champ5 = T.Champ5
   ,Libelle6 = T.Libelle6
   ,Champ6 = T.Champ6
   ,Libelle7 = T.Libelle7
   ,Champ7 = T.Champ7
   ,Libelle8 = T.Libelle8
   ,Champ8 = T.Champ8
   ,Parent = -1
   ,Date_Creation =CAST( CONVERT(varchar, GETDATE(), 103) AS DATETIME )
   ,Num_Devis = @CHRONO
   ,Nom_Adresse = T.Nom_Adresse
   ,Adresse1 = T.Adresse1
   ,Adresse2 = T.Adresse2
   ,Adresse3 = T.Adresse3
   ,Intention = T.Intention
   ,N_Ville_Adresse = T.N_Ville_Adresse
   ,N_Pays_Adresse = T.N_Pays_Adresse
   ,coef_Achat_Defaut = T.coef_Achat_Defaut
   ,coef_Frais_Defaut = T.coef_Frais_Defaut
   ,Coef_Main_Defaut = T.Coef_Main_Defaut
   ,Ent_Devis_L1 = T.Ent_Devis_L1
   ,Ent_Devis_L2 = T.Ent_Devis_L2
   ,Pied_Devis_L1 = T.Pied_Devis_L1
   ,Pied_Devis_L2 = T.Pied_Devis_L2
   ,Pied_Devis_L3 = T.Pied_Devis_L3
   ,Tva_active = CASE WHEN ISNULL(T.Tva_active,0) = 19.60 THEN CASE WHEN c.Tva IS NOT NULL THEN c.Tva ELSE si.Tva_Active END ELSE t.Tva_active END
   ,Nom_Ville_Adresse = T.Nom_Ville_Adresse
   ,Nom_Pays_Adresse = T.Nom_Pays_Adresse
   ,Code_Postal_Adresse = T.Code_Postal_Adresse
   ,N_Itc = T.N_Itc
   ,PrixMoyMO_Franc = T.PrixMoyMO_Franc
   ,PrixMoyMO_Euro = T.PrixMoyMO_Euro
   ,PourcentProduit = T.PourcentProduit
   ,StyleFonte = T.StyleFonte
   ,ColorFond = T.ColorFond
   ,ColorTexte = T.ColorTexte
   ,User_Create = @n_user
   ,Date_Create = GETDATE()
   ,User_Modif = @n_user
   ,Date_Modif = GETDATE()
   ,Reussite = T.Reussite
   ,DateCdePrev = null
   ,TempsRealisation = T.TempsRealisation
   ,DelaiRealisation = T.DelaiRealisation
   ,Resultat = 0
   ,DateResultat = NULL
   ,N_Depot = @N_DepotFiche
   ,GrilleUnique = T.GrilleUnique
   ,Champ9 = T.Champ9
   ,Champ10 = T.Champ10
   ,Champ11 = T.Champ11
   ,Champ12 = T.Champ12
   ,Champ13 = T.Champ13
   ,Champ14 = T.Champ14
   ,Champ15 = T.Champ15
   ,Champ16 = T.Champ16
   ,Champ17 = T.Champ17
   ,Champ18 = T.Champ18
   ,Champ19 = T.Champ19
   ,Champ20 = T.Champ20
   ,Champ21 = T.Champ21
   ,Champ22 = T.Champ22
   ,Champ23 = T.Champ23
   ,Champ24 = T.Champ24
   ,Champ25 = T.Champ25
   ,Champ26 = T.Champ26
   ,Champ27 = T.Champ27
   ,Champ28 = T.Champ28
   ,N_Devise = T.N_Devise
   ,TauxEuro = T.TauxEuro
   ,Total_Tva_Franc = T.Total_Tva_Franc
   ,Total_Tva_Euro = T.Total_Tva_Euro
   ,Total_Ttc_Franc = T.Total_Ttc_Franc
   ,Total_Ttc_Euro = T.Total_Ttc_Euro
   ,Champ29 = T.Champ29
   ,Champ30 = T.Champ30
   ,Champ31 = T.Champ31
   ,Champ32 = T.Champ32
   ,Champ33 = T.Champ33
   ,Champ34 = T.Champ34
   ,Champ35 = T.Champ35
   ,Champ36 = T.Champ36
   ,Champ37 = T.Champ37
   ,Champ38 = T.Champ38
   ,Champ39 = T.Champ39
   ,Champ40 = T.Champ40
   ,Champ41 = T.Champ41
   ,Champ42 = T.Champ42
   ,Champ43 = T.Champ43
   ,Champ44 = T.Champ44
   ,Champ45 = T.Champ45
   ,Champ46 = T.Champ46
   ,Champ47 = T.Champ47
   ,Champ48 = T.Champ48
   ,Champ49 = T.Champ49
   ,Champ50 = T.Champ50
   ,Champ51 = T.Champ51
   ,Champ52 = T.Champ52
   ,AlertePlanning = T.AlertePlanning
   ,ModeImpression = T.ModeImpression
   ,N_Modele_Impression = T.N_Modele_Impression
   ,User_Print = NULL
   ,date_Print = NULL
   ,N_QrCode = NULL
   ,N_SpgDealId = NULL
   ,N_SpgEnteteDevis = NULL
FROM DEVIS T 
LEFT OUTER JOIN CLIENT c ON c.N_Client = T.N_Client
,soft_ini si 
WHERE t.n_devis = @N

DECLARE @NCOPIE integer
SET @NCOPIE = ( SELECT SCOPE_IDENTITY() )

-- C'est le passage du Parent -1 à une valeur > 0 qui va tracer la création du devis dans le fil
UPDATE DEVIS
SET Parent = ( SELECT Parent FROM DEVIS WHERE N_Devis = @N )
WHERE N_Devis = @NCOPIE


/*                                                                 
------------------------------------------------
 * Duplication de L'arborescence
------------------------------------------------
*/
--Creation du curseur
DECLARE TB_DEV_ARBORESCENCE_Cursor CURSOR DYNAMIC FOR
SELECT N_Dev_Arborescence  
FROM TB_DEV_ARBORESCENCE T
WHERE t.N_Devis = @N
ORDER BY t.Niveau,T.NumOrdre

--Ouverture du curseur
OPEN TB_DEV_ARBORESCENCE_Cursor
--Pointe le premier enregistrement
FETCH FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
--Parcours le table
WHILE @@FETCH_STATUS = 0
BEGIN
	/* Duplique la ligne */
	INSERT INTO TB_DEV_ARBORESCENCE
	  (
	    N_Devis
	   ,Code
	   ,Chapitre
	   ,Parent
	   ,NumOrdre
	   ,Niveau
	   ,N_Dev_Arborescence_Origine
	  )
	  SELECT 
	  	 N_Devis = @NCOPIE
	     ,Code = T.Code
	     ,Chapitre = CASE WHEN t.Parent = 0 THEN (SELECT nom_devis FROM DEVIS WHERE n_devis =@NCOPIE ) ELSE T.Chapitre END
	     ,Parent = CASE WHEN t.Parent = 0 THEN 0 ELSE o.N_Dev_Arborescence END
	     ,NumOrdre = T.NumOrdre
	     ,Niveau = T.Niveau
	     ,N_Dev_Arborescence_Origine= t.N_Dev_Arborescence
	  FROM TB_DEV_ARBORESCENCE T 
	  LEFT OUTER JOIN TB_DEV_ARBORESCENCE o ON t.Parent=o.N_Dev_Arborescence_Origine AND o.N_Devis=@NCOPIE
	  WHERE t.N_Dev_Arborescence=@N_Dev_Arborescence


	--Pointe l'enregistrement suivant
	FETCH NEXT FROM TB_DEV_ARBORESCENCE_Cursor into @N_Dev_Arborescence
END

--Fermeture du curseur
CLOSE TB_DEV_ARBORESCENCE_Cursor
DEALLOCATE TB_DEV_ARBORESCENCE_Cursor


/*                                                                 
------------------------------------------------
 * Duplication du corps du devis
------------------------------------------------
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
   ,N_Devis = @NCOPIE
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
   /* s{App_LigneId Code=Insert_Select /} */
   ,TypeFiche_Precedent = 123
   ,N_Fiche_Precedent = @N
   ,N_Detail_Precedent = t.N_DevisDetail
   ,App_LigneId_Origine = '' 
   /* s{/App_LigneId Code=Insert_Select /} */  
FROM DEVISDETAIL T 
LEFT OUTER JOIN DEVIS d ON d.N_Devis = T.N_Devis
LEFT OUTER JOIN CLIENT c ON c.N_Client = d.N_Client
LEFT OUTER JOIN TB_DEV_ARBORESCENCE o ON o.N_Dev_Arborescence_Origine=t.N_Dev_Arborescence AND o.N_Devis=@NCOPIE
,Soft_ini si
WHERE t.N_Devis=@N AND ISNULL(t.N_Fct_Base,0) = 0


/*                                                                 
------------------------------------------------
 * Les lignes de réglements
------------------------------------------------
*/
DECLARE @N_Regl_Devis int, @N_Devis int, @Libelle varchar(50),
        @Pourcent numeric(18,10), @Montant_Franc numeric(18,10),
        @Montant_Euro numeric(18,10), @Date_Regl datetime, @Mode varchar(25),
        @Terme varchar(25), @Banque varchar(25),
        @MontantTTC_Franc numeric(18,10), @MontantTTC_Euro numeric(18,10),
        @Libre1 varchar(100), @Libre2 varchar(100), @Libre3 varchar(100),
        @Libre4 varchar(100), @numeric1 numeric(18,10),
        @numeric2 numeric(18,10), @check1 varchar(3), @check2 varchar(3),
        @date1 datetime, @date2 datetime, @genesys_lock varchar(3),
        @StyleFonte int, @ColorFond int, @ColorTexte int

--Creation du curseur
DECLARE Regl_devis_Cursor CURSOR  SCROLL DYNAMIC FOR
SELECT N_Regl_Devis, N_Devis, Libelle, Pourcent, Montant_Franc, Montant_Euro,
       Date_Regl, Mode, Terme, Banque, MontantTTC_Franc, MontantTTC_Euro,
       Libre1, Libre2, Libre3, Libre4, numeric1, numeric2, check1, check2,
       date1, date2, genesys_lock, StyleFonte, ColorFond, ColorTexte  
FROM Regl_devis 
WHERE N_Devis = @N

--Ouverture du curseur
OPEN Regl_devis_Cursor
--Pointe le premier enregistrement
FETCH FROM Regl_devis_Cursor into @N_Regl_Devis, @N_Devis, @Libelle, @Pourcent,
                                  @Montant_Franc, @Montant_Euro, @Date_Regl,
                                  @Mode, @Terme, @Banque, @MontantTTC_Franc,
                                  @MontantTTC_Euro, @Libre1, @Libre2, @Libre3,
                                  @Libre4, @numeric1, @numeric2, @check1,
                                  @check2, @date1, @date2, @genesys_lock,
                                  @StyleFonte, @ColorFond, @ColorTexte
--Parcours le table
WHILE @@FETCH_STATUS = 0
BEGIN
		INSERT INTO Regl_devis
		(
			N_Devis, Libelle, Pourcent, Montant_Franc,
			Montant_Euro, Date_Regl, Mode, Terme, Banque, MontantTTC_Franc,
			MontantTTC_Euro, Libre1, Libre2, Libre3, Libre4, numeric1, numeric2,
			check1, check2, date1, date2, genesys_lock, StyleFonte, ColorFond,
			ColorTexte
		)
		SELECT
			N_Devis = @NCOPIE,
			Libelle = @Libelle, Pourcent = @Pourcent,
			Montant_Franc = @Montant_Franc, Montant_Euro = @Montant_Euro,
			Date_Regl = @Date_Regl, Mode = @Mode, Terme = @Terme,
			Banque = @Banque, MontantTTC_Franc = @MontantTTC_Franc,
			MontantTTC_Euro = @MontantTTC_Euro, Libre1 = @Libre1,
			Libre2 = @Libre2, Libre3 = @Libre3, Libre4 = @Libre4,
			numeric1 = @numeric1, numeric2 = @numeric2, check1 = @check1,
			check2 = @check2, date1 = @date1, date2 = @date2,
			genesys_lock = 'Non', StyleFonte = @StyleFonte,
			ColorFond = @ColorFond, ColorTexte = @ColorTexte



	--Pointe l'enregistrement suivant
	FETCH NEXT FROM Regl_devis_Cursor into @N_Regl_Devis, @N_Devis, @Libelle,
	                                       @Pourcent, @Montant_Franc,
	                                       @Montant_Euro, @Date_Regl, @Mode,
	                                       @Terme, @Banque, @MontantTTC_Franc,
	                                       @MontantTTC_Euro, @Libre1, @Libre2,
	                                       @Libre3, @Libre4, @numeric1,
	                                       @numeric2, @check1, @check2, @date1,
	                                       @date2, @genesys_lock, @StyleFonte,
	                                       @ColorFond, @ColorTexte
END

--Fermeture du curseur
CLOSE Regl_devis_Cursor
DEALLOCATE Regl_devis_Cursor

/*                                                                 
------------------------------------------------
 * Duplique la fonction de base
------------------------------------------------
*/
EXECUTE DUPLIQUE_FCT_BASE_DEVISDETAIL @N, @NCOPIE

 /*                                                                 
------------------------------------------------
 * Recalcul du N_Position
------------------------------------------------
*/
UPDATE DEVISDETAIL
SET N_Position = N_Dev_Arborescence + dbo.Recalcul_N_Position(N_DevisDetail)
WHERE N_Devis = @NCOPIE
 

/*                                                                 
------------------------------------------------
 * Recalcul du devis
------------------------------------------------
*/
EXECUTE SP_DEV_RECAP_DEVIS_DETAIL @NCOPIE


SET NOCOUNT OFF;


GO
