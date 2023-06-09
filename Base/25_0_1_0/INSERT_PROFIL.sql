ALTER PROCEDURE [INSERT_PROFIL] 
@N integer
AS

/* si c'est une duplication de profil il ne faut rien faire */
IF( RIGHT(( SELECT Nom FROM PROFIL_USERS WHERE N_Profil_User = @N ),7)='(COPIE)') RETURN

DELETE PROFIL_DROITS
WHERE N_Profil = @N

INSERT INTO PROFIL_DROITS( N_Profil, N_User, Type, Code, Tabl_, Descriptif)
SELECT @N, 0, 1, 100, 'CLIENT', 'Client'
UNION
SELECT @N, 0, 1, 101, 'CONTACT', 'Contact Client'
UNION
SELECT @N, 0, 1, 102, 'PROJET', 'Projet'
UNION
SELECT @N, 0, 1, 103, 'BL', 'Bon de livraison'
UNION
SELECT @N, 0, 1, 104, 'CDE_CLI', 'Commande Client'
UNION
SELECT @N, 0, 1, 105, 'FACT_CLI', 'Facture Client'
UNION
SELECT @N, 0, 1, 106, 'FOURNISS', 'Fournisseur'
UNION
SELECT @N, 0, 1, 107, 'CONTFN', 'Contact Fournisseur'
UNION
SELECT @N, 0, 1, 108, 'ORDREF', 'Ordre de Fabrication'
UNION
SELECT @N, 0, 1, 109, 'RF', 'Réception de Fabrication'
UNION
SELECT @N, 0, 1, 110, 'STOCK', 'Stock'
UNION
SELECT @N, 0, 1, 111, 'BR', 'Bon de réception'
UNION
SELECT @N, 0, 1, 112, 'CDE_FOUR', 'Commande Fournisseur'
UNION
SELECT @N, 0, 1, 113,  'FAC_FOUR', 'Facture Fournisseur'
UNION
SELECT @N, 0, 1, 114, 'TRESO', 'Trésorerie'
UNION
SELECT @N, 0, 1, 115, 'ITC', 'Personnel (propre fiche)'
UNION
SELECT @N, 0, 1, 116, 'ITC', 'Personnel (autres fiches)'
UNION
SELECT @N, 0, 1, 117, 'FCT_BASE', 'Fonction de base'
UNION
SELECT @N, 0, 1, 118, 'PRODUIT', 'Produit/Prestation/Frais'
UNION
SELECT @N, 0, 1, 119, 'STAT', 'Requètes/Statistiques'
UNION
SELECT @N, 0, 1, 120, 'AFFAIRE', 'Affaire'
UNION
SELECT @N, 0, 1, 121, 'COMPTA', 'Comptabilité'
UNION
SELECT @N, 0, 1, 122, 'INVENTAIRE', 'Inventaire'
UNION
SELECT @N, 0, 1, 123, 'DEVIS', 'Devis'
UNION
SELECT @N, 0, 1, 124, 'MABONNEMENT', 'Abonnement'
UNION
SELECT @N, 0, 1, 125, 'PLANNING', 'Planning'
UNION
SELECT @N, 0, 1, 127, 'DEMANDE_ACHAT', 'Demande d''achat'
UNION
SELECT @N, 0, 1, 128, 'CAMPAGNE', 'CAMPAGNE'
UNION
SELECT @N, 0, 0, 1, 'SOFT_INI', 'Société'
UNION
SELECT @N, 0, 0, 2, 'FONCTION', 'Fonction'
UNION
SELECT @N, 0, 0, 3, 'BANQUE', 'Banque'
UNION
SELECT @N, 0, 0, 4, 'TERME', 'Conditions de paiement'
UNION
SELECT @N, 0, 0, 5, 'NAF', 'N.A.F'
UNION
SELECT @N, 0, 0, 6, 'VILLE', 'Ville'
UNION
SELECT @N, 0, 0, 7, 'FAMILLE_CLIENT', 'Famille de client'
UNION
SELECT @N, 0, 0, 8, 'PROFIL_USERS', 'Profil utilisateurs'
UNION
SELECT @N, 0, 0, 9, 'RUBRIQUE', 'Rubrique'
UNION
SELECT @N, 0, 0, 10, 'SERVICE', 'Service'
UNION
SELECT @N, 0, 0, 11, 'TVA', 'Tva'
UNION
SELECT @N, 0, 0, 12, 'MODE', 'Mode de paiement'
UNION
SELECT @N, 0, 0, 13, 'FORMULES', 'Formules et impressions'
UNION
SELECT @N, 0, 0, 14, 'POSTE_DEVIS', 'Poste devis'
UNION
SELECT @N, 0, 0, 15, 'PAYS', 'Pays'
UNION
SELECT @N, 0, 0, 16, 'DEVISE', 'Devise'
UNION
SELECT @N, 0, 0, 17, 'FAMILLE_PRODUIT', 'Famille de produit'
UNION
SELECT @N, 0, 0, 18, 'CODE_TARIF', 'Code Tarif'
UNION
SELECT @N, 0, 0, 19, 'DEPOT', 'Dépots'
UNION
SELECT @N, 0, 0, 20, 'USERS', 'Utilisateurs'
UNION
SELECT @N, 0, 0, 21, 'MODELES_WORD', 'Modèles Word'
UNION
SELECT @N, 0, 0, 22, 'MDE_RELANCE', 'Mode Relance'
UNION
SELECT @N, 0, 0, 23, 'MARQUE', 'Marques'
UNION
SELECT @N, 0, 0, 24, 'FAMILLE_AFFAIRE', 'Famille d''affaire'
UNION
SELECT @N, 0, 0, 25, 'CHRONOS_DOC', 'Chronos'
UNION
SELECT @N, 0, 0, 26, 'FAMILLE_ABONNEMENT', 'Famille d''abonnement'
UNION
SELECT @N, 0, 0, 27, 'CONFIG_TODO', 'Catégories de tâches'
UNION
SELECT @N, 0, 2, 1000, 'ANALYSER', 'Analyser'
UNION
SELECT @N, 0, 2, 1001, 'PLANNING_GENERAL', 'Planning Général'
UNION
SELECT @N, 0, 2, 1002, 'GENEMAIL', 'GENEMail'







