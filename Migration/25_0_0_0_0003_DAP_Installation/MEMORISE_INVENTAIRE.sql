ALTER PROCEDURE [dbo].[MEMORISE_INVENTAIRE] 
@N_Inventaire integer,
@N_Depot integer
AS
 
BEGIN TRANSACTION
 
/*efface éventuellement mémoire précédente de l'inventaire*/
DELETE INVENTAIRE_STOCK
WHERE N_Inventaire = @N_Inventaire
 
 
/*mémorise l'intégralité du stock*/
INSERT INTO INVENTAIRE_STOCK
(N_Inventaire,
N_Depot,
N_Produit,
Qte_Stock,
Qte_BL,
Qte_BR,
Qte_Cde_Client,
Qte_Cde_Fournisseur,
N_Fct_Base,
Qte_OF,
Qte_Compte,
ValeurFranc,
ValeurEuro,
Qte_BL_Reservation)
SELECT
@N_Inventaire,
ST.N_Depot,
ST.N_Produit,
ST.Qte_Stock,
ST.Qte_BL,
ST.Qte_BR,
ST.Qte_Cde_Client,
ST.Qte_Cde_Fournisseur,
ST.N_Fct_Base,
ST.Qte_OF,
NULL,
CASE WHEN ST.N_Produit > 0 THEN ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Franc ELSE P.DernierPrixAchat_Franc END ) ELSE FCT.Total_HT_General_Franc END,
CASE WHEN ST.N_Produit > 0 THEN ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Euro ELSE P.DernierPrixAchat_Euro END )  ELSE FCT.Total_HT_General_Euro END,
ST.Qte_BL_Reservation
FROM SOFT_INI SOFT, STOCK_PRODUIT ST
	LEFT OUTER JOIN PRODUIT P ON P.N_Produit = ST.N_Produit
	LEFT OUTER JOIN FCT_BASE FCT ON FCT.N_Fct_Base = ST.N_Fct_Base
WHERE ST.N_Depot = @N_Depot
 
UNION
 
SELECT
@N_Inventaire,
@N_Depot,
P.N_Produit,
0,
0,
0,
0,
0,
0,
0,
NULL,
( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Franc ELSE P.DernierPrixAchat_Franc END ),
( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Euro ELSE P.DernierPrixAchat_Euro END ),
Qte_BL_Reservation = 0
FROM SOFT_INI SOFT, PRODUIT P
WHERE P.GestionStock = 'Oui' AND
P.N_Produit NOT IN 
( SELECT ST.N_Produit FROM STOCK_PRODUIT ST 
WHERE ST.N_Produit = P.N_Produit AND ST.N_Depot = @N_Depot )
 
UNION
 
SELECT
@N_Inventaire,
@N_Depot,
0,
0,
0,
0,
0,
0,
N_Fct_Base,
0,
NULL,
FCT.Total_HT_General_Franc,
FCT.Total_HT_General_Euro,
Qte_BL_Reservation = 0
FROM FCT_BASE FCT
WHERE Fct.GestionStock = 'Oui' AND
FCT.N_Fct_Base NOT IN 
( SELECT ST.N_Fct_Base FROM STOCK_PRODUIT ST 
WHERE ST.N_Fct_Base = FCT.N_Fct_Base AND ST.N_Depot = @N_Depot )
 
COMMIT
 
 
 
 

GO
