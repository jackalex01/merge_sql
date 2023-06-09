ALTER TRIGGER [dbo].[USERS_INSERT] ON [dbo].[USERS] 
FOR INSERT
AS

DECLARE @N_User integer


SELECT
	@N_User = i.N_User
FROM inserted i

/*crÚe un profil vierge*/
EXECUTE	INSERT_PROFIL -1

/*rattache le profil au user*/
UPDATE PROFIL_DROITS
	SET 	N_Profil = 0,
		N_User = @N_User
WHERE N_Profil = -1

/* Gestion de la config des grilles */
INSERT INTO USERS_CONFIG (Numero) VALUES (@N_User)

UPDATE uc
SET    uc.GRID_CONFIG = uc2.GRID_CONFIG
      ,uc.AFFAIRE = uc2.AFFAIRE
      ,uc.BL = uc2.BL
      ,uc.BR = uc2.BR
      ,uc.CLIENT = uc2.CLIENT
      ,uc.CDE_CLI = uc2.CDE_CLI
      ,uc.CDE_FOUR = uc2.CDE_FOUR
      ,uc.CONTACT = uc2.CONTACT
      ,uc.CONTFN = uc2.CONTFN
      ,uc.DEVIS = uc2.DEVIS
      ,uc.FACT_CLI = uc2.FACT_CLI
      ,uc.FAC_FOUR = uc2.FAC_FOUR
      ,uc.FCT_BASE = uc2.FCT_BASE
      ,uc.FOURNISS = uc2.FOURNISS
      ,uc.ITC = uc2.ITC
      ,uc.ORDREF = uc2.ORDREF
      ,uc.PRODUIT = uc2.PRODUIT
      ,uc.PROJET = uc2.PROJET
      ,uc.RF = uc2.RF
      ,uc.AFFAIRE_ORDER = uc2.AFFAIRE_ORDER
      ,uc.BL_ORDER = uc2.BL_ORDER
      ,uc.BR_ORDER = uc2.BR_ORDER
      ,uc.CLIENT_ORDER = uc2.CLIENT_ORDER
      ,uc.CDE_CLI_ORDER = uc2.CDE_CLI_ORDER
      ,uc.CDE_FOUR_ORDER = uc2.CDE_FOUR_ORDER
      ,uc.CONTACT_ORDER = uc2.CONTACT_ORDER
      ,uc.CONTFN_ORDER = uc2.CONTFN_ORDER
      ,uc.DEVIS_ORDER = uc2.DEVIS_ORDER
      ,uc.FACT_CLI_ORDER = uc2.FACT_CLI_ORDER
      ,uc.FAC_FOUR_ORDER = uc2.FAC_FOUR_ORDER
      ,uc.FCT_BASE_ORDER = uc2.FCT_BASE_ORDER
      ,uc.FOURNISS_ORDER = uc2.FOURNISS_ORDER
      ,uc.ITC_ORDER = uc2.ITC_ORDER
      ,uc.ORDREF_ORDER = uc2.ORDREF_ORDER
      ,uc.PRODUIT_ORDER = uc2.PRODUIT_ORDER
      ,uc.PROJET_ORDER = uc2.PROJET_ORDER
      ,uc.RF_ORDER = uc2.RF_ORDER
      ,uc.INVENTAIRE = uc2.INVENTAIRE
      ,uc.INVENTAIRE_ORDER = uc2.INVENTAIRE_ORDER
      ,uc.PLANNING_CONFIG = uc2.PLANNING_CONFIG
      ,uc.RESTE_A_PLANIFIER_GRID = uc2.RESTE_A_PLANIFIER_GRID
      ,uc.DEMANDE_ACHAT = uc2.DEMANDE_ACHAT
      ,uc.DEMANDE_ACHAT_ORDER = uc2.DEMANDE_ACHAT_ORDER
	  ,uc.TB_DAP_DEMANDE_APPRO = uc2.TB_DAP_DEMANDE_APPRO
      ,uc.TB_DAP_DEMANDE_APPRO_ORDER = uc2.TB_DAP_DEMANDE_APPRO_ORDER
FROM   USERS_CONFIG uc
      ,USERS_CONFIG uc2
WHERE  uc.Numero = @n_user
AND    uc2.Numero = 17

GO
