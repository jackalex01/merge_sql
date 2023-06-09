ALTER VIEW [VUE_PROPOSITION_DA]

AS

select
N_Position = LI.N_Position,
N_Ligne = LI.N_LigneCli,
N_Cde_Cli = CDE.N_Cde_Cli,
N_Devis = 0,
N_Demande_Appro = 0,
CDE.N_Affaire,
LI.N_Prod,
N_Fct_Base = 0,
N_Rubrique = ( SELECT TOP 1 ACTIVITE.N_Activites FROM ACTIVITE WHERE Parent > -1 AND ACTIVITE.Code_Secteur = LI.Activite ),
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
WHERE ( DEMANDE_ACHAT.N_Affaire = CDE.N_Affaire )AND( DA_DETAIL.N_Prod = LI.N_Prod )),
LI.Unite,
Marque = ISNULL( P.Marque, '' ),
Fournisseur = '',
GestionStock = ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro,
P.N_Famille_Produit
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = li.numeric1
,numeric2 = li.numeric2
,check1 = li.check1
,check2 = li.check2
,date1 = li.date1
,date2 = li.date2
,Libre2 = li.Libre2
,Libre3 = li.Libre3
,Libre4 = li.Libre4
,Numeric3 = li.Numeric3
,Numeric4 = li.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 104 
,N_Fiche_Precedent = cde.N_Cde_Cli
,N_Detail_Precedent = li.N_LigneCli
,App_LigneId_Origine = li.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM CDE_CLI CDE, LIGNECLI LI
LEFT OUTER JOIN PRODUIT P ON P.N_Produit = LI.N_Prod
,Soft_ini Si
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )AND( LI.N_Prod > 0 )
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */

UNION ALL

select
N_Position = LI.N_Position,
N_Ligne = LI.N_LigneCli,
N_Cde_Cli = CDE.N_Cde_Cli,
N_Devis = 0,
N_Demande_Appro = 0,
CDE.N_Affaire,
N_Prod = 0,
N_Fct_Base = 0,
N_Rubrique = ( SELECT TOP 1 ACTIVITE.N_Activites FROM ACTIVITE WHERE Parent > -1 AND ACTIVITE.Code_Secteur = LI.Activite ),
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
   WHERE ( DEMANDE_ACHAT.N_Affaire = CDE.N_Affaire )AND
   (ISNULL(LI.Reference,'') = ISNULL(DA_DETAIL.Ref,''))AND(ISNULL(LI.Designation,'') = ISNULL(DA_DETAIL.Designation,''))),
LI.Unite,
Marque = '',
Fournisseur = '',
GestionStock = 'Non',
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro,
0
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = li.numeric1
,numeric2 = li.numeric2
,check1 = li.check1
,check2 = li.check2
,date1 = li.date1
,date2 = li.date2
,Libre2 = li.Libre2
,Libre3 = li.Libre3
,Libre4 = li.Libre4
,Numeric3 = li.Numeric3
,Numeric4 = li.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 104 
,N_Fiche_Precedent = cde.N_Cde_Cli
,N_Detail_Precedent = li.N_LigneCli
,App_LigneId_Origine = li.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM CDE_CLI CDE, LIGNECLI LI
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.Code_Secteur = LI.Activite )
,Soft_ini Si
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )
AND(ISNULL(LI.N_Prod, 0) <= 0)AND( ISNULL( LI.N_Fct_Base, 0 ) <= 0 )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
--AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */


UNION ALL

select
N_Position = LI.N_Position,
N_Ligne = FCT.N_Ligne,
N_Document = CDE.N_Cde_Cli,
N_Devis = 0,
N_Demande_Appro = 0,
CDE.N_Affaire,
FCT.N_Produit,
LI.N_Fct_Base,
N_Rubrique=RUB.N_Activites,
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
   WHERE ( DEMANDE_ACHAT.N_Affaire = CDE.N_Affaire )AND( DA_DETAIL.N_Prod = FCT.N_Produit )),
FCT.Unite,
Marque = ISNULL( P.Marque, '' ),
Fournisseur = '',
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = LI.Montant_Franc,
Prix_Total_Vente_Euro = LI.Montant_Euro,
P.N_Famille_Produit
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = fct.numeric1
,numeric2 = fct.numeric2
,check1 = fct.check1
,check2 = fct.check2
,date1 = fct.date1
,date2 = fct.date2
,Libre2 = fct.Libre2
,Libre3 = fct.Libre3
,Libre4 = fct.Libre4
,Numeric3 = fct.Numeric3
,Numeric4 = fct.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 104 
,N_Fiche_Precedent = cde.N_Cde_Cli
,N_Detail_Precedent = li.N_LigneCli
,App_LigneId_Origine = fct.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM CDE_CLI CDE, LIGNECLI LI, FCT_CDE_CLI FCT
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = FCT.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = FCT.N_Rubrique )
,Soft_ini Si
WHERE
( CDE.N_Cde_Cli = LI.N_Cde_Cli )
AND( LI.N_Fct_Base > 0 )AND( LI.N_LigneCli = FCT.N_LigneCli )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
AND( ISNULL( P.Type, 1 ) = 1 )
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */

UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_DevisDetail,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
N_Demande_Appro = 0,
N_Affaire=S.N_Affaire,
N_Prod=L.N_Produit,
N_Fct_Base = L.N_Fct_Base,
N_Rubrique=RUB.N_Activites,
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
   WHERE ( DEMANDE_ACHAT.N_Affaire = S.N_Affaire )AND( DA_DETAIL.N_Prod = L.N_Produit )),
	L.Unite,
Marque = ISNULL( L.Marque, ISNULL( P.Marque, '' ) ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro,
P.N_Famille_Produit
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = l.numeric1
,numeric2 = l.numeric2
,check1 = l.check1
,check2 = l.check2
,date1 = l.date1
,date2 = l.date2
,Libre2 = l.Libre2
,Libre3 = l.Libre3
,Libre4 = l.Libre4
,Numeric3 = l.Numeric3
,Numeric4 = l.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123 
,N_Fiche_Precedent = d.N_Devis
,N_Detail_Precedent = l.N_DevisDetail
,App_LigneId_Origine = l.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM SDEVIS S, DEVIS D, DEVISDETAIL L
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = L.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
,Soft_ini Si
WHERE
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )
AND( L.N_Produit > 0 )
AND( P.Type = 1 )AND( ISNULL( L.Options, 0 ) = 0 )
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */


UNION ALL

select
N_Position = L.N_Position,
N_Ligne = L.N_DevisDetail,
N_Cde_Cli = 0,
N_Document = D.N_Devis,
N_Demande_Appro = 0,
S.N_Affaire,
0,
0,
N_Rubrique=RUB.N_Activites,
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
   WHERE ( DEMANDE_ACHAT.N_Affaire = S.N_Affaire )AND
   (ISNULL(L.Ref,'') = ISNULL(DA_DETAIL.Ref,''))AND(ISNULL(L.Description,'') = ISNULL(DA_DETAIL.Designation,''))),
L.Unite,
Marque = ISNULL( L.Marque, '' ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
GestionStock = 'Non',
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro,
0
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = l.numeric1
,numeric2 = l.numeric2
,check1 = l.check1
,check2 = l.check2
,date1 = l.date1
,date2 = l.date2
,Libre2 = l.Libre2
,Libre3 = l.Libre3
,Libre4 = l.Libre4
,Numeric3 = l.Numeric3
,Numeric4 = l.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123 
,N_Fiche_Precedent = d.N_Devis
,N_Detail_Precedent = l.N_DevisDetail
,App_LigneId_Origine = l.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM SDEVIS S, DEVIS D, DEVISDETAIL L
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = L.N_Rubrique )
,Soft_ini Si
WHERE 
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )AND( ISNULL( L.Options, 0 ) = 0 )
AND(ISNULL(L.N_Produit, 0) <= 0)AND(ISNULL(L.N_Fct_Base, 0) <= 0)
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
--AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */


UNION ALL

select
N_Position = L.N_Position,
N_Ligne = LF.N_Ligne_Fct,
N_Cde_Cli = 0,
N_Devis = D.N_Devis,
N_Demande_Appro = 0,
S.N_Affaire,
LF.N_Produit,
LF.N_Fct_Base,
N_Rubrique=RUB.N_Activites,
reference=LF.Reference,
Designation=LF.Designation,
CAST( NULL AS VARCHAR(MAX) ),
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
demandeAchat = (SELECT SUM(Quantite) FROM DA_DETAIL, DEMANDE_ACHAT
   WHERE ( DEMANDE_ACHAT.N_Affaire = S.N_Affaire )AND
   (ISNULL(LF.Reference,'') = ISNULL(DA_DETAIL.Ref,''))AND(ISNULL(LF.Designation,'') = ISNULL(DA_DETAIL.Designation,''))),
LF.Unite,
Marque = ISNULL( L.Marque, ISNULL( P.Marque, '' ) ),
Fournisseur = ISNULL( L.Fournisseur, '' ),
ISNULL( P.GestionStock, 'Non' ),
Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc,
Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro,
0
/* s{Col_Detail_Supp Code=Select /} */
,numeric1 = lf.numeric1
,numeric2 = lf.numeric2
,check1 = lf.check1
,check2 = lf.check2
,date1 = lf.date1
,date2 = lf.date2
,Libre2 = lf.Libre2
,Libre3 = lf.Libre3
,Libre4 = lf.Libre4
,Numeric3 = lf.Numeric3
,Numeric4 = lf.Numeric4
/* s{/Col_Detail_Supp Code=Select /} */
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123 
,N_Fiche_Precedent = d.N_Devis
,N_Detail_Precedent = l.N_DevisDetail
,App_LigneId_Origine = l.App_LigneId
/* s{/App_LigneId Code=Select /} */
FROM SDEVIS S, DEVIS D, DEVISDETAIL L, LFCT_DEVISDETAIL LF
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = LF.N_Produit )
LEFT OUTER JOIN ACTIVITE RUB ON ( RUB.N_Activites = LF.N_Rubrique )
,Soft_ini Si
WHERE 
( S.N_Devis = D.N_Devis )
AND( D.N_Devis = L.N_Devis )AND( ISNULL( L.Options, 0 ) = 0 )
AND( L.N_Fct_Base > 0 )AND( L.N_DevisDetail = LF.N_Ligne )
AND( ISNULL( RUB.Produit,'Oui' ) = 'Oui' )
--AND(ISNULL(LI.Reference,'') <> '') AND (ISNULL(LI.Designation, 0 )<> '')
/* s{App_LigneId Code=Where /} */
AND (si.Achat_Suivi_Avec_LigneId = 'Non')
/* s{/App_LigneId Code=Where /} */

UNION ALL

/*                                                                  
================================================
 ->  Les commandes clients
================================================
*/
/*                                                                 
------------------------------------------------
 * Les lignes non fonction de bases
------------------------------------------------
*/
SELECT 
      N_Position = LI.N_Position
    , N_Ligne = LI.N_LigneCli
    , N_Cde_Cli = CDE.N_Cde_Cli
    , N_Devis = 0
    , N_Demande_Appro = 0
    , CDE.N_Affaire
    , LI.N_Prod
    , N_Fct_Base = 0
    , N_Rubrique = (SELECT 
                          TOP 1 ACTIVITE.N_Activites
                    FROM ACTIVITE
                    WHERE Parent > -1 AND ACTIVITE.Code_Secteur = LI.Activite)
    , LI.Reference
    , LI.Designation
    , LI.Texte
    , LI.CodePoste
    , LI.Libre1
    , DernierPrixAchat_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Euro = P.DernierPrixAchat_Euro
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro
    , EstimatifAchat_Franc = CAST(NULL AS numeric(18 ,10))
    , EstimatifAchat_Euro = CAST(NULL AS numeric(18 ,10))
    , EstimatifAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , EstimatifAchat_Remise_Franc = CAST(NULL AS numeric(18 ,10))
    , EstimatifAchat_Remise_Euro = CAST(NULL AS numeric(18 ,10))
    , Qte = LI.Quantite
    , Cde = LI.Quantite
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = LI.App_LigneId))
    , LI.Unite
    , Marque = ISNULL(P.Marque ,'')
    , Fournisseur = ''
    , GestionStock = ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = LI.Montant_Franc
    , Prix_Total_Vente_Euro = LI.Montant_Euro
    , P.N_Famille_Produit
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = li.numeric1
    , numeric2 = li.numeric2
    , check1 = li.check1
    , check2 = li.check2
    , date1 = li.date1
    , date2 = li.date2
    , Libre2 = li.Libre2
    , Libre3 = li.Libre3
    , Libre4 = li.Libre4
    , Numeric3 = li.Numeric3
    , Numeric4 = li.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 104
    , N_Fiche_Precedent = cde.N_Cde_Cli
    , N_Detail_Precedent = li.N_LigneCli
    , App_LigneId_Origine = li.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM CDE_CLI CDE
INNER JOIN LIGNECLI LI ON CDE.N_Cde_Cli = LI.N_Cde_Cli
LEFT OUTER JOIN ACTIVITE RUB ON  RUB.Code_Secteur = LI.Activite AND rub.Parent >= 0
LEFT OUTER JOIN PRODUIT P ON  P.N_Produit = LI.N_Prod
,Soft_ini Si
WHERE (si.Achat_Suivi_Avec_LigneId = 'Oui')
AND (LI.N_Fct_Base = 0 OR li.N_Fct_Base IS NULL)
AND (ISNULL(RUB.Produit ,'Oui') = 'Oui' OR (ISNULL(P.Type,1) = 1))

UNION ALL

/*                                                                 
------------------------------------------------
 * Les fonctions de bases
------------------------------------------------
*/
SELECT 
      N_Position = LI.N_Position
    , N_Ligne = FCT.N_Ligne
    , N_Document = CDE.N_Cde_Cli
    , N_Devis = 0
    , N_Demande_Appro = 0
    , CDE.N_Affaire
    , FCT.N_Produit
    , LI.N_Fct_Base
    , N_Rubrique = RUB.N_Activites
    , FCT.Reference
    , FCT.Designation
    , NULL
    , NULL
    , NULL
    , DernierPrixAchat_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Euro = P.DernierPrixAchat_Euro
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro
    , EstimatifAchat_Franc = FCT.Prix_U_Franc
    , EstimatifAchat_Euro = FCT.Prix_U_Euro
    , EstimatifAchat_Remise = FCT.Remise
    , EstimatifAchat_Remise_Franc = FCT.Prix_U_Remise_Franc
    , EstimatifAchat_Remise_Euro = FCT.Prix_U_Remise_Euro
    , Qte = LI.Quantite * FCT.Quantite
    , Cde = LI.Quantite * FCT.Quantite
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = FCT.App_LigneId))
    , FCT.Unite
    , Marque = ISNULL(P.Marque ,'')
    , Fournisseur = ''
    , ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = LI.Montant_Franc
    , Prix_Total_Vente_Euro = LI.Montant_Euro
    , P.N_Famille_Produit
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = fct.numeric1
    , numeric2 = fct.numeric2
    , check1 = fct.check1
    , check2 = fct.check2
    , date1 = fct.date1
    , date2 = fct.date2
    , Libre2 = fct.Libre2
    , Libre3 = fct.Libre3
    , Libre4 = fct.Libre4
    , Numeric3 = fct.Numeric3
    , Numeric4 = fct.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 104
    , N_Fiche_Precedent = cde.N_Cde_Cli
    , N_Detail_Precedent = li.N_LigneCli
    , App_LigneId_Origine = fct.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM CDE_CLI CDE
INNER JOIN LIGNECLI LI ON CDE.N_Cde_Cli = LI.N_Cde_Cli
INNER JOIN FCT_CDE_CLI FCT ON LI.N_LigneCli = FCT.N_LigneCli
LEFT OUTER JOIN PRODUIT P ON  P.N_Produit = FCT.N_Produit
LEFT OUTER JOIN ACTIVITE RUB ON  RUB.N_Activites = FCT.N_Rubrique
,Soft_ini Si
WHERE (si.Achat_Suivi_Avec_LigneId = 'Oui')
AND (LI.N_Fct_Base > 0 AND li.N_Fct_Base IS NOT NULL)
AND ((ISNULL(RUB.Produit ,'Oui') = 'Oui') OR (ISNULL(P.Type ,1) = 1))

UNION ALL
/*                                                                  
================================================
 -> Les devis
================================================
*/
/*                                                                 
------------------------------------------------
 * Les lignes non fonction de bases
------------------------------------------------
*/
SELECT 
      N_Position = L.N_Position
    , N_Ligne = L.N_DevisDetail
    , N_Cde_Cli = 0
    , N_Devis = D.N_Devis
    , N_Demande_Appro = 0
    , N_Affaire = S.N_Affaire
    , N_Prod = L.N_Produit
    , N_Fct_Base = L.N_Fct_Base
    , N_Rubrique = RUB.N_Activites
    , reference = L.Ref
    , Designation = L.Description
    , L.Texte
    , L.CodePoste
    , L.Libre1
    , DernierPrixAchat_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Euro = P.DernierPrixAchat_Euro
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro
    , EstimatifAchat_Franc = ISNULL(L.Prix_U_Base_Franc ,L.Prix_U_Franc)
    , EstimatifAchat_Euro = ISNULL(L.Prix_U_Base_Euro ,L.Prix_U_Euro)
    , EstimatifAchat_Remise = L.RemiseFourn
    , EstimatifAchat_Remise_Franc = L.Prix_U_Franc
    , EstimatifAchat_Remise_Euro = L.Prix_U_Euro
    , Qte = L.Quantite
    , Cde = L.Quantite
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = L.App_LigneId))
    , L.Unite
    , Marque = ISNULL(L.Marque ,ISNULL(P.Marque ,''))
    , Fournisseur = ISNULL(L.Fournisseur ,'')
    , ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc
    , Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
    , P.N_Famille_Produit
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = l.numeric1
    , numeric2 = l.numeric2
    , check1 = l.check1
    , check2 = l.check2
    , date1 = l.date1
    , date2 = l.date2
    , Libre2 = l.Libre2
    , Libre3 = l.Libre3
    , Libre4 = l.Libre4
    , Numeric3 = l.Numeric3
    , Numeric4 = l.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 123
    , N_Fiche_Precedent = d.N_Devis
    , N_Detail_Precedent = l.N_DevisDetail
    , App_LigneId_Origine = l.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM DEVIS D 
LEFT OUTER JOIN SDEVIS s ON S.N_Devis = D.N_Devis
INNER JOIN DEVISDETAIL L ON D.N_Devis = L.N_Devis
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = L.N_Produit)
LEFT OUTER JOIN ACTIVITE RUB ON  (RUB.N_Activites = L.N_Rubrique)
,Soft_ini Si
WHERE (si.Achat_Suivi_Avec_LigneId = 'Oui')
AND (ISNULL(L.Options ,0) = 0)
AND (L.N_Fct_Base = 0 OR L.N_Fct_Base IS NULL)
AND (ISNULL(RUB.Produit ,'Oui') = 'Oui' OR (ISNULL(P.Type,1) = 1))

UNION ALL

SELECT 
      N_Position = L.N_Position
    , N_Ligne = LF.N_Ligne_Fct
    , N_Cde_Cli = 0
    , N_Devis = D.N_Devis
    , N_Demande_Appro = 0
    , S.N_Affaire
    , LF.N_Produit
    , LF.N_Fct_Base
    , N_Rubrique = RUB.N_Activites
    , reference = LF.Reference
    , Designation = LF.Designation
    , CAST(NULL AS VARCHAR(MAX))
    , L.CodePoste
    , NULL
    , DernierPrixAchat_Franc = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Euro = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Euro = CAST(NULL AS numeric(18 ,10))
    , EstimatifAchat_Franc = LF.Prix_U_Franc
    , EstimatifAchat_Euro = LF.Prix_U_Euro
    , EstimatifAchat_Remise = LF.Remise
    , EstimatifAchat_Remise_Franc = LF.Prix_U_Remise_Franc
    , EstimatifAchat_Remise_Euro = LF.Prix_U_Remise_Euro
    , Qte = L.Quantite * LF.Quantite
    , Cde = L.Quantite * LF.Quantite
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = LF.App_LigneId))
    , LF.Unite
    , Marque = ISNULL(L.Marque ,ISNULL(P.Marque ,''))
    , Fournisseur = ISNULL(L.Fournisseur ,'')
    , ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc
    , Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
    , 0
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = lf.numeric1
    , numeric2 = lf.numeric2
    , check1 = lf.check1
    , check2 = lf.check2
    , date1 = lf.date1
    , date2 = lf.date2
    , Libre2 = lf.Libre2
    , Libre3 = lf.Libre3
    , Libre4 = lf.Libre4
    , Numeric3 = lf.Numeric3
    , Numeric4 = lf.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 123
    , N_Fiche_Precedent = d.N_Devis
    , N_Detail_Precedent = l.N_DevisDetail
    , App_LigneId_Origine = l.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM DEVIS D 
LEFT OUTER JOIN SDEVIS s ON S.N_Devis = D.N_Devis
INNER JOIN DEVISDETAIL L ON D.N_Devis = L.N_Devis
INNER JOIN LFCT_DEVISDETAIL LF ON L.N_DevisDetail = LF.N_Ligne
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = LF.N_Produit)
LEFT OUTER JOIN ACTIVITE RUB ON  (RUB.N_Activites = LF.N_Rubrique)
,Soft_ini Si
WHERE (si.Achat_Suivi_Avec_LigneId = 'Oui')
AND (ISNULL(L.Options ,0) = 0)
AND (L.N_Fct_Base > 0 AND L.N_Fct_Base IS NOT NULL)
AND ((ISNULL(RUB.Produit ,'Oui') = 'Oui') OR (ISNULL(P.Type ,1) = 1))

/*                                                                  
================================================
 -> Les demandes d'appros
================================================
*/

UNION ALL

SELECT 
      N_Position = L.N_Position
    , N_Ligne = L.N_Demande_Appro_Detail
    , N_Cde_Cli = 0
    , N_Devis = 0
    , N_Demande_Appro = dap.N_Demande_Appro
    , N_Affaire = CASE WHEN l.N_Affaire IS NULL OR l.N_Affaire = 0 THEN dap.N_Affaire ELSE l.N_Affaire END
    , N_Prod = L.N_Produit
    , N_Fct_Base = L.N_Fct_Base
    , N_Rubrique = l.N_Activites
    , reference = L.Ref
    , Designation = L.[Description]
    , L.Texte
    , L.CodePoste
    , L.Libre1
    , DernierPrixAchat_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Euro = P.DernierPrixAchat_Euro
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro
    , EstimatifAchat_Franc = ISNULL(L.Prix_U_Base_Franc ,L.Prix_U_Franc)
    , EstimatifAchat_Euro = ISNULL(L.Prix_U_Base_Euro ,L.Prix_U_Euro)
    , EstimatifAchat_Remise = L.RemiseFourn
    , EstimatifAchat_Remise_Franc = L.Prix_U_Franc
    , EstimatifAchat_Remise_Euro = L.Prix_U_Euro
    , Qte = L.Quantite_Appro
    , Cde = L.Quantite_Appro
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = L.App_LigneId))
    , L.Unite
    , Marque = ISNULL(L.Marque ,ISNULL(P.Marque ,''))
    , Fournisseur = ISNULL(L.Fournisseur ,'')
    , ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc
    , Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
    , P.N_Famille_Produit
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = l.numeric1
    , numeric2 = l.numeric2
    , check1 = l.check1
    , check2 = l.check2
    , date1 = l.date1
    , date2 = l.date2
    , Libre2 = l.Libre2
    , Libre3 = l.Libre3
    , Libre4 = l.Libre4
    , Numeric3 = l.Numeric3
    , Numeric4 = l.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 132
    , N_Fiche_Precedent = dap.N_Demande_Appro
    , N_Detail_Precedent = l.N_Demande_Appro_Detail
    , App_LigneId_Origine = l.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM TB_DAP_DEMANDE_APPRO_DETAIL l
LEFT OUTER JOIN TB_DAP_DEMANDE_APPRO dap ON dap.N_Demande_Appro = l.N_Demande_Appro
INNER JOIN TB_GEN_TYPE_LIGNE tl ON tl.N_Type_Ligne = l.N_Type_Ligne
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = l.N_Produit)
,Soft_ini Si
WHERE (Quantite_Appro > 0 AND (tl.Categorie = 'ART' AND (p.GestionStock = 'Non' OR p.GestionStock IS NULL )))

UNION ALL

SELECT 
      N_Position = L.N_Position
    , N_Ligne = L.N_Demande_Appro_Detail
    , N_Cde_Cli = 0
    , N_Devis = 0
    , N_Demande_Appro = dap.N_Demande_Appro
    , N_Affaire = 0
    , N_Prod = L.N_Produit
    , N_Fct_Base = L.N_Fct_Base
    , N_Rubrique = l.N_Activites
    , reference = L.Ref
    , Designation = L.[Description]
    , L.Texte
    , L.CodePoste
    , L.Libre1
    , DernierPrixAchat_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Euro = P.DernierPrixAchat_Euro
    , DernierPrixAchat_Remise = CAST(NULL AS numeric(18 ,10))
    , DernierPrixAchat_Remise_Franc = P.DernierPrixAchat_Franc
    , DernierPrixAchat_Remise_Euro = P.DernierPrixAchat_Euro
    , EstimatifAchat_Franc = ISNULL(L.Prix_U_Base_Franc ,L.Prix_U_Franc)
    , EstimatifAchat_Euro = ISNULL(L.Prix_U_Base_Euro ,L.Prix_U_Euro)
    , EstimatifAchat_Remise = L.RemiseFourn
    , EstimatifAchat_Remise_Franc = L.Prix_U_Franc
    , EstimatifAchat_Remise_Euro = L.Prix_U_Euro
    , Qte = L.Quantite_Reappro_Stock
    , Cde = L.Quantite_Reappro_Stock
    , demandeAchat = (SELECT 
                            SUM(Quantite)
                      FROM DA_DETAIL
                          ,DEMANDE_ACHAT
                      WHERE (DA_DETAIL.App_LigneId = L.App_LigneId))
    , L.Unite
    , Marque = ISNULL(L.Marque ,ISNULL(P.Marque ,''))
    , Fournisseur = ISNULL(L.Fournisseur ,'')
    , ISNULL(P.GestionStock ,'Non')
    , Prix_Total_Vente_Franc = L.Prix_Total_Vente_Franc
    , Prix_Total_Vente_Euro = L.Prix_Total_Vente_Euro
    , P.N_Famille_Produit
      /* s{Col_Detail_Supp Code=Select /} */
    , numeric1 = l.numeric1
    , numeric2 = l.numeric2
    , check1 = l.check1
    , check2 = l.check2
    , date1 = l.date1
    , date2 = l.date2
    , Libre2 = l.Libre2
    , Libre3 = l.Libre3
    , Libre4 = l.Libre4
    , Numeric3 = l.Numeric3
    , Numeric4 = l.Numeric4
      /* s{/Col_Detail_Supp Code=Select /} */
      /* s{App_LigneId Code=Select /} */
    , TypeFiche_Precedent = 132
    , N_Fiche_Precedent = dap.N_Demande_Appro
    , N_Detail_Precedent = l.N_Demande_Appro_Detail
    , App_LigneId_Origine = l.App_LigneId
      /* s{/App_LigneId Code=Select /} */
FROM TB_DAP_DEMANDE_APPRO_DETAIL l
LEFT OUTER JOIN TB_DAP_DEMANDE_APPRO dap ON dap.N_Demande_Appro = l.N_Demande_Appro
INNER JOIN TB_GEN_TYPE_LIGNE tl ON tl.N_Type_Ligne = l.N_Type_Ligne
LEFT OUTER JOIN PRODUIT P ON  (P.N_Produit = l.N_Produit)
,Soft_ini Si
WHERE (Quantite_Reappro_Stock > 0 AND (tl.Code = 'STK' AND p.GestionStock = 'Oui'))










