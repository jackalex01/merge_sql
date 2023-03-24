ALTER VIEW [VUE_DERNIERE_SORTIE_FCT_BASE_STOCK]
AS
SELECT Sortie = MAX(BL.Date_BL),MVT.N_Fct_Base, MVT.N_Depot
FROM MVTS_STOCK MVT, BL BL
WHERE( (MVT.Origine = 'BL' AND (BL.Stock_Reservation = 'Non' OR BL.Stock_Reservation IS NULL) ) )AND( MVT.N_Fct_Base > 0 )AND( MVT.N_Document = BL.N_BL )
GROUP BY MVT.N_Fct_Base, MVT.N_Depot
 

