ALTER VIEW [dbo].[VUE_PREINVENTAIRE]
AS
--vue utilisée par GENEsys quand inventaire non démarré (etat = 0)
SELECT
P.N_Produit,
N_Fct_Base = 0,
P.Nom_Produit, P.Ref_Constructeur,
P.GestionStock, P.Emplacement, P.CodeStock, P.Unite, P.Marque, 
ValeurFranc = ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Franc ELSE P.DernierPrixAchat_Franc END ),
ValeurEuro = ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Euro ELSE P.DernierPrixAchat_Euro END ),
ValeurStock_Franc = ( CASE WHEN SOFT.MethodeValStock = 1 THEN ROUND(P.CMUP_Franc,2) ELSE ROUND(P.DernierPrixAchat_Franc,2) END ) * (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0)),
ValeurStock_Euro = ( CASE WHEN SOFT.MethodeValStock = 1 THEN ROUND(P.CMUP_Euro,2) ELSE ROUND(P.DernierPrixAchat_Euro,2) END ) * (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0)),
ST.Qte_Stock, FA.Code_Famille, FA.N_Famille_Produit,
DEP.N_Depot,
libre1 = CAST( NULL as varchar(50) ),
numeric1 = CAST(NULL as numeric(18,10) ),
numeric2 = CAST( NULL as numeric(18,10) ),
check1 = CAST( 'Non' as varchar(3) ),
check2 = CAST( 'Non' as varchar(3) ),
date1 = CAST( NULL as datetime ),
date2 = CAST( NULL as datetime ),
styleFonte = CAST( NULL as integer ),
colorFond = CAST( NULL as integer ),
colorTexte = CAST( NULL as integer ),
st.Qte_BL_Reservation
FROM SOFT_INI SOFT, PRODUIT P
   LEFT OUTER JOIN DEPOT DEP ON ( DEP.N_Depot > 0 )
   LEFT OUTER JOIN STOCK_PRODUIT ST ON ( ST.N_Produit = P.N_Produit )AND( ST.N_Depot = DEP.N_Depot )
   LEFT OUTER JOIN FAMILLE_PRODUIT FA ON ( FA.N_Famille_Produit = P.N_Famille_Produit )
WHERE( P.Parent > 0 )AND
( P.GestionStock = 'Oui' )
 
UNION ALL
 
SELECT
0,
FCT.N_Fct_Base,
FCT.Nom_Fct_Base, FCT.Ref_Constructeur,
FCT.GestionStock, FCT.CodeStock, FCT.Unite, FCT.Emplacement, FCT.Marque,
DernierPrixAchat_Franc = FCT.Total_HT_General_Franc,
DernierPrixAchat_Euro = FCT.Total_HT_General_Euro,
ValeurStock_Franc = ROUND( FCT.Total_HT_General_Franc, 2 ) * (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0)),
ValeurStock_Euro = ROUND( FCT.Total_HT_General_Euro, 2 ) * (ST.Qte_Stock + ISNULL(st.Qte_BL_Reservation,0)),
ST.Qte_Stock, FA.Code_Famille, FA.N_Famille_Produit,
DEP.N_Depot,
libre1 = CAST( NULL as varchar(50) ),
numeric1 = CAST( st.Qte_BL_Reservation as integer ),
numeric2 = CAST( NULL as integer ),
check1 = CAST( 'Non' as varchar(3) ),
check2 = CAST( 'Non' as varchar(3) ),
date1 = CAST( NULL as datetime ),
date2 = CAST( NULL as datetime ),
styleFonte = CAST( NULL as integer ),
colorFond = CAST( NULL as integer ),
colorTexte = CAST( NULL as integer ),
st.Qte_BL_Reservation
FROM FCT_BASE FCT
   LEFT OUTER JOIN DEPOT DEP ON ( DEP.N_Depot > 0 )
   LEFT OUTER JOIN STOCK_PRODUIT ST ON ( ST.N_Fct_Base = FCT.N_Fct_Base )AND( ST.N_Depot = DEP.N_Depot )
   LEFT OUTER JOIN FAMILLE_PRODUIT FA ON ( FA.N_Famille_Produit = FCT.N_Famille_Produit )
WHERE( FCT.Parent > 0 )AND
( FCT.GestionStock = 'Oui' )
 
 
 
 
 
 
 


GO
