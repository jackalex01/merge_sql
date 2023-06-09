CREATE PROCEDURE [dbo].[NOM_FICHE] 
@Type_Fiche integer, @N_Fiche integer, @Nom varchar(100) OUTPUT
AS
BEGIN
    SET @Nom = '??'
    IF @N_Fiche = 0 RETURN

    IF @Type_Fiche = 100
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Client FROM CLIENT WHERE N_Client = @N_Fiche ), '?' )
            RETURN
        END
	
    IF @Type_Fiche = 101
	BEGIN
	    SET @Nom = ISNULL( ( SELECT ISNULL( ISNULL( Prenom_Contact, '' ) + ' ' + Nom_Contact, '' ) FROM CONTACT WHERE N_Contact = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 102
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Projet FROM PROJET WHERE N_Projet = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 103
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_BL FROM BL WHERE N_BL = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 104
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Cde FROM CDE_CLI WHERE N_Cde_Cli = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 105
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Fac_Cli FROM FACT_CLI WHERE N_Fact_Cli = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 106
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Fournisseur FROM FOURNISS WHERE N_Fourniss = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 107
	BEGIN
	    SET @Nom = ISNULL( ( SELECT ISNULL( ISNULL( Prenom_Contact, '' ) + ' ' + Nom_Contact, '' ) FROM CONTFN WHERE N_Contact = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 108
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_OF FROM ORDREF WHERE N_OF = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 109
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_RF FROM RF WHERE N_RF = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 111
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_BR FROM BR WHERE N_BR = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 112
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Cde_Four FROM CDE_FOUR WHERE N_Cde_Four = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 113
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Fac_Four FROM FAC_FOUR WHERE N_Fac_Four = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 115
	BEGIN
	    SET @Nom = ISNULL( ( SELECT ISNULL( ISNULL( Prenom, '' ) + ' ' + Nom_Commercial, '' ) FROM ITC WHERE N_ITC = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 117
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Fct_Base FROM FCT_BASE WHERE N_Fct_Base = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 118
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Produit FROM PRODUIT WHERE N_Produit = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 120
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Designation FROM AFFAIRE WHERE N_Affaire = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 122
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Inventaire FROM INVENTAIRE WHERE N_Inventaire = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 123
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Devis FROM DEVIS WHERE N_Devis = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 126
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_ToDo FROM TODO WHERE N_ToDo = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 127
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Demande_Achat FROM DEMANDE_ACHAT WHERE N_Demande_Achat = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 128
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Campagne FROM CAMPAGNE WHERE N_Campagne = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 129
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Objet FROM GENEMAIL WHERE N_GeneMail = @N_Fiche ), '?' )
            RETURN
        END

    IF @Type_Fiche = 130
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Demande_Conge FROM DEMANDE_CONGE WHERE N_Demande_Conge = @N_Fiche ), '?' )
            RETURN
        END

		IF @Type_Fiche = 131
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Ouvrage FROM TB_OUV_OUVRAGE WHERE N_Ouvrage = @N_Fiche ), '?' )
            RETURN
        END

	IF @Type_Fiche = 132
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Demande_Appro FROM TB_DAP_DEMANDE_APPRO WHERE N_Demande_Appro = @N_Fiche ), '?' )
            RETURN
        END

		IF @Type_Fiche = 133
	BEGIN
	    SET @Nom = ISNULL( ( SELECT Nom_Equipement FROM TB_EQP_EQUIPEMENT WHERE N_Equipement = @N_Fiche ), '?' )
            RETURN
        END

END

GO
