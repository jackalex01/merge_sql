ALTER VIEW [VUE_PROPOSITION_CDE_FOUR]

AS

select
N_Position = LI.N_Position,
N_Ligne = LI.N_LigneCli,
N_Cde_Cli = CDE.N_Cde_Cli,
N_Devis = 0,
CDE.N_Affaire,
LI.N_Prod,
N_Fct_Base = 0,
LI.Activite,
LI.Reference,
LI.Designation,
LI.Texte,
LI.CodePoste,
LI.Libre1,
DernierPrixAchat_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Euro =  P.DernierPrixAchat_Euro,
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro,
EstimatifAchat_Franc = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Euro =  CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Franc = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Euro = CAST( NULL AS numeric(18,10) ),
Qte = LI.Quantite,
Cde = LI.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
WHERE ( Cde_Four.N_Affaire = CDE.N_Affaire )AND( Scd_Four.N_Prod = LI.N_Prod )),
LI.Unite,
Marque = ISNULL( P.Marque, '' ),
Fournisseur = '',
GestionStock = ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro
FROM CDE_CLI CDE, LIGNECLI LI
LEFT OUTER JOIN PRODUIT P ON P.N_Produit = LI.N_Prod
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )AND( LI.N_Prod > 0 )

UNION ALL

select
N_Position = LI.N_Position,
N_Ligne = LI.N_LigneCli,
N_Cde_Cli = CDE.N_Cde_Cli,
N_Devis = 0,
CDE.N_Affaire,
N_Prod = 0,
N_Fct_Base = 0,
LI.Activite,
LI.Reference,
LI.Designation,
LI.Texte,
LI.CodePoste,
LI.Libre1,
DernierPrixAchat_Franc = NULL,
DernierPrixAchat_Euro = NULL,
DernierPrixAchat_Remise = NULL,
DernierPrixAchat_Remise_Franc = NULL,
DernierPrixAchat_Remise_Euro = NULL,
EstimatifAchat_Franc = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Euro =  CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Franc = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Euro = CAST( NULL AS numeric(18,10) ),
Qte=LI.Quantite,
Cde=LI.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = CDE.N_Affaire )AND
   (ISNULL(LI.Reference,'') = ISNULL(Scd_Four.Ref,''))AND(ISNULL(LI.Designation,'') = ISNULL(Scd_Four.Designation,''))),
LI.Unite,
Marque = '',
Fournisseur = '',
GestionStock = 'Non',
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro
FROM CDE_CLI CDE, LIGNECLI LI
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.Code_Secteur = LI.Activite )
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )
AND(ISNULL(LI.N_Prod, 0) <= 0)AND( ISNULL( LI.N_Fct_Base, 0 ) <= 0 )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
/*AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')*/


UNION ALL

select
N_Position = LI.N_Position,
N_Ligne = FCT.N_Ligne,
N_Document = CDE.N_Cde_Cli,
N_Devis = 0,
CDE.N_Affaire,
FCT.N_Produit,
LI.N_Fct_Base,
RUB.Code_Secteur,
FCT.Reference,
FCT.Designation,
NULL,
NULL,
NULL,
DernierPrixAchat_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Euro =  P.DernierPrixAchat_Euro,
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro,
EstimatifAchat_Franc = FCT.Prix_U_Franc,
EstimatifAchat_Euro =  FCT.Prix_U_Euro,
EstimatifAchat_Remise = FCT.Remise,
EstimatifAchat_Remise_Franc = FCT.Prix_U_Remise_Franc,
EstimatifAchat_Remise_Euro = FCT.Prix_U_Remise_Euro,
Qte = LI.Quantite*FCT.Quantite,
Cde = LI.Quantite*FCT.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = CDE.N_Affaire )AND( Scd_Four.N_Prod = FCT.N_Produit )),
FCT.Unite,
Marque = ISNULL( P.Marque, '' ),
Fournisseur = '',
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro
FROM CDE_CLI CDE, LIGNECLI LI, FCT_CDE_CLI FCT
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = FCT.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = FCT.N_Rubrique )
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )
AND( LI.N_Fct_Base > 0 )AND( LI.N_LigneCli = FCT.N_LigneCli )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
AND( ISNULL( P.Type, 1 ) = 1 )

UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_Ligne,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
N_Affaire=S.N_Affaire,
N_Prod=L.N_Produit,
N_Fct_Base = 0,
Activite=RUB.Code_Secteur,
reference=L.Ref,
L.Designation,
L.Texte,
L.CodePoste,
L.Libre1,
DernierPrixAchat_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Euro =  P.DernierPrixAchat_Euro,
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro,
EstimatifAchat_Franc =  L.Prix_U_Franc,
EstimatifAchat_Euro =  L.Prix_U_Euro,
EstimatifAchat_Remise = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Franc =  L.Prix_U_Franc,
EstimatifAchat_Remise_Euro = L.Prix_U_Euro,
Qte = L.Quantite,
Cde = L.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = S.N_Affaire )AND( Scd_Four.N_Prod = L.N_Produit )),
L.Unite,
Marque = ISNULL( P.Marque, '' ),
Fournisseur = '',
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
FROM DEVIS D, SDEVIS S, LPRODUIT L
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = L.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
WHERE
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )
AND( L.N_Produit > 0 )
AND( P.Type = 1 )


UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_Ligne,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
S.N_Affaire,
0,
0,
Activite=RUB.Code_Secteur,
reference=L.Ref,
L.Designation,
L.Texte,
L.CodePoste,
L.Libre1,
DernierPrixAchat_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Euro =  CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Euro = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Franc =  L.Prix_U_Franc,
EstimatifAchat_Euro =  L.Prix_U_Euro,
EstimatifAchat_Remise = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Remise_Franc =  L.Prix_U_Franc,
EstimatifAchat_Remise_Euro = L.Prix_U_Euro,
Qte = L.Quantite,
Cde = L.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = S.N_Affaire )AND
   (ISNULL(L.Ref,'') = ISNULL(Scd_Four.Ref,''))AND(ISNULL(L.Designation,'') = ISNULL(Scd_Four.Designation,''))),
L.Unite,
Marque = '',
Fournisseur = '',
GestionStock = 'Non',
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
FROM SDEVIS S, DEVIS D, LPRODUIT L
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
WHERE 
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )
AND(ISNULL(L.N_Produit, 0) <= 0)
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
/*AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')*/


UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_DevisDetail,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
N_Affaire=S.N_Affaire,
N_Prod=L.N_Produit,
N_Fct_Base = L.N_Fct_Base,
Activite=RUB.Code_Secteur,
reference=L.Ref,
Designation=L.Description,
L.Texte,
L.CodePoste,
L.Libre1,
DernierPrixAchat_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Euro =  P.DernierPrixAchat_Euro,
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc,
DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro,
EstimatifAchat_Franc = ISNULL( L.Prix_U_Base_Franc, L.Prix_U_Franc ),
EstimatifAchat_Euro =  ISNULL( L.Prix_U_Base_Euro, L.Prix_U_Euro ),
EstimatifAchat_Remise = L.RemiseFourn,
EstimatifAchat_Remise_Franc = L.Prix_U_Franc,
EstimatifAchat_Remise_Euro = L.Prix_U_Euro,
Qte = L.Quantite,
Cde = L.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = S.N_Affaire )AND( Scd_Four.N_Prod = L.N_Produit )),
	L.Unite,
Marque = ISNULL( L.Marque, ISNULL( P.Marque, '' ) ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
FROM SDEVIS S, DEVIS D, DEVISDETAIL L
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = L.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
WHERE
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )
AND( L.N_Produit > 0 )
AND( P.Type = 1 )AND( ISNULL( L.Options, 0 ) = 0 )

UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_DevisDetail,
N_Cde_Cli = 0,
N_Document = D.N_Devis,
S.N_Affaire,
0,
0,
Activite=RUB.Code_Secteur,
reference=L.Ref,
Designation=L.Description,
L.Texte,
L.CodePoste,
L.Libre1,
DernierPrixAchat_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Euro =  CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Euro = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Franc = ISNULL( L.Prix_U_Base_Franc, L.Prix_U_Franc ),
EstimatifAchat_Euro =  ISNULL( L.Prix_U_Base_Euro, L.Prix_U_Euro ),
EstimatifAchat_Remise = L.RemiseFourn,
EstimatifAchat_Remise_Franc = L.Prix_U_Franc,
EstimatifAchat_Remise_Euro = L.Prix_U_Euro,
Qte = L.Quantite,
Cde = L.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = S.N_Affaire )AND
   (ISNULL(L.Ref,'') = ISNULL(Scd_Four.Ref,''))AND(ISNULL(L.Description,'') = ISNULL(Scd_Four.Designation,''))),
L.Unite,
Marque = ISNULL( L.Marque, '' ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
GestionStock = 'Non',
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
FROM SDEVIS S, DEVIS D, DEVISDETAIL L
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
WHERE 
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )AND( ISNULL( L.Options, 0 ) = 0 )
AND(ISNULL(L.N_Produit, 0) <= 0)AND(ISNULL(L.N_Fct_Base, 0) <= 0)
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
/*AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')*/


UNION ALL

select
N_Position = L.N_Position,
N_Ligne = LF.N_Ligne_Fct,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
S.N_Affaire,
LF.N_Produit,
LF.N_Fct_Base,
Activite=RUB.Code_Secteur,
reference=LF.Reference,
Designation=LF.Designation,
CAST( NULL AS Text ),
L.CodePoste,
NULL,
DernierPrixAchat_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Euro =  CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Franc = CAST( NULL AS numeric(18,10) ),
DernierPrixAchat_Remise_Euro = CAST( NULL AS numeric(18,10) ),
EstimatifAchat_Franc = LF.Prix_U_Franc,
EstimatifAchat_Euro =  LF.Prix_U_Euro,
EstimatifAchat_Remise = LF.Remise,
EstimatifAchat_Remise_Franc = LF.Prix_U_Remise_Franc,
EstimatifAchat_Remise_Euro = LF.Prix_U_Remise_Euro,
Qte = L.Quantite*LF.Quantite,
Cde = L.Quantite*LF.Quantite,
cdefour = (SELECT SUM(Quantite) FROM Scd_Four, Cde_Four
   WHERE ( Cde_Four.N_Affaire = S.N_Affaire )AND
   (ISNULL(LF.Reference,'') = ISNULL(Scd_Four.Ref,''))AND(ISNULL(LF.Designation,'') = ISNULL(Scd_Four.Designation,''))),
LF.Unite,
Marque = ISNULL( L.Marque, ISNULL( P.Marque, '' ) ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
FROM SDEVIS S, DEVIS D, DEVISDETAIL L, LFCT_DEVISDETAIL LF
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = LF.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = LF.N_Rubrique )
WHERE 
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )AND( ISNULL( L.Options, 0 ) = 0 )
AND( L.N_Fct_Base > 0 )AND( L.N_DevisDetail = LF.N_Ligne )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
/*AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')*/










