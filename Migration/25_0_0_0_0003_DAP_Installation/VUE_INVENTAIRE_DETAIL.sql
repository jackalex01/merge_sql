ALTER VIEW [dbo].[VUE_INVENTAIRE_DETAIL]
AS
--vue utilisée par GENEsys quand inventaire démarré ou clôturé (etat = 1 et etat = 2)
SELECT
ST.N_Inventaire_Stock,
ST.N_Inventaire,
P.N_Produit,
N_Fct_Base = 0,
P.Nom_Produit, P.Ref_Constructeur,
P.GestionStock, P.Emplacement, P.CodeStock, P.Unite, P.Marque, 
ST.Qte_Stock, FA.Code_Famille, FA.N_Famille_Produit,
ST.Qte_Compte,
ST.ValeurFranc, ST.ValeurEuro,
valeurStock_Franc = ( (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0))*ROUND( ST.ValeurFranc, 2 ) ),
valeurStock_Euro  = ((ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0)) *ROUND( ST.ValeurEuro, 2 ) ),
INV.N_Depot,
libre1 = ST.libre1,
numeric1 = CAST( NULL as numeric(18,10) ),
numeric2 = ST.numeric2,
check1 = ST.check1,
check2 = ST.check2,
date1 = ST.date1,
date2 = ST.date2,
styleFonte = CAST( NULL as integer ),
colorFond = CAST( NULL as integer ),
colorTexte = CAST( NULL as integer ),
st.Qte_BL_Reservation
FROM INVENTAIRE_STOCK ST
   LEFT OUTER JOIN INVENTAIRE INV ON ( INV.N_Inventaire = ST.N_Inventaire )
, PRODUIT P
   LEFT OUTER JOIN FAMILLE_PRODUIT FA ON ( FA.N_Famille_Produit = P.N_Famille_Produit )
WHERE( P.Parent > 0 )AND( ST.N_Produit = P.N_Produit )AND
( P.GestionStock = 'Oui' )
 
UNION ALL
 
SELECT
ST.N_Inventaire_Stock,
ST.N_Inventaire,
0,
FCT.N_Fct_Base,
FCT.Nom_Fct_Base, FCT.Ref_Constructeur,
FCT.GestionStock, FCT.Emplacement, FCT.CodeStock, FCT.Unite, FCT.Marque, 
ST.Qte_Stock, FA.Code_Famille, FA.N_Famille_Produit,
ST.Qte_Compte,
ST.ValeurFranc, ST.ValeurEuro,
valeurStock_Franc = ( (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0))*ROUND( ST.ValeurFranc, 2 ) ),
valeurStock_Euro  = ((ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0))*ROUND( ST.ValeurEuro, 2 ) ),
INV.N_Depot,
libre1 = ST.libre1,
numeric1 = CAST( st.Qte_BL_Reservation as numeric(18,10) ),
numeric2 = ST.numeric2,
check1 = ST.check1,
check2 = ST.check2,
date1 = ST.date1,
date2 = ST.date2,
styleFonte = CAST( NULL as integer ),
colorFond = CAST( NULL as integer ),
colorTexte = CAST( NULL as integer ),
st.Qte_BL_Reservation
FROM INVENTAIRE_STOCK ST
   LEFT OUTER JOIN INVENTAIRE INV ON ( INV.N_Inventaire = ST.N_Inventaire )
, FCT_BASE FCT
   LEFT OUTER JOIN FAMILLE_PRODUIT FA ON ( FA.N_Famille_Produit = FCT.N_Famille_Produit )
WHERE( FCT.Parent > 0 )AND( ST.N_Fct_Base = FCT.N_Fct_Base )AND
( FCT.GestionStock = 'Oui' )
 
 
 
 
 


GO
