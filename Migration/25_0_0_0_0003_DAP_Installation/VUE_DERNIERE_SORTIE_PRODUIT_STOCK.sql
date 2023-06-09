ALTER VIEW [dbo].[VUE_DERNIERE_SORTIE_PRODUIT_STOCK]
AS
SELECT Sortie = MAX(CASE WHEN MVT.Origine = 'BL' THEN ISNULL( BL.Date_BL,'' ) ELSE ISNULL( O.Date_OF,'' ) END ), 
    MVT.N_Produit, MVT.N_Depot
FROM MVTS_STOCK MVT
LEFT OUTER JOIN BL BL ON MVT.Origine = 'BL' AND MVT.N_Document = BL.N_BL 
LEFT OUTER JOIN ORDREF O ON MVT.Origine = 'OF' AND MVT.N_Document = O.N_OF 
WHERE( (MVT.Origine = 'BL' AND (BL.Stock_Reservation = 'Non' OR BL.Stock_Reservation IS NULL) ) OR MVT.Origine = 'OF' )AND( MVT.N_Produit > 0 )
GROUP BY MVT.N_Produit, MVT.N_Depot
 
 

GO
