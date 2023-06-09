ALTER FUNCTION [FCTT_STOCK_VALORISATION]
(     
@N_User int,
@MethodeCalcul int,
@N_Depot int,
@TypeDepot int,
@N_Famille_Produit int,
@TypeFamille int,
@TypeArticle int
)
RETURNS TABLE 
AS
RETURN 
(
select
FA.Code_Famille,
D.Nom_Depot,
P.Ref_Constructeur,
P.Nom_Produit,
DernierPrixAchat_Franc = ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Franc ELSE P.DernierPrixAchat_Franc END ),
DernierPrixAchat_Euro = ( CASE WHEN SOFT.MethodeValStock = 1 THEN P.CMUP_Euro ELSE P.DernierPrixAchat_Euro END ),
dateEntree=( SELECT Entree FROM VUE_DERNIERE_ENTREE_PRODUIT_STOCK VUE WHERE VUE.N_Produit = P.N_Produit AND VUE.N_Depot = ST.N_Depot ),
dateSortie=( SELECT Sortie FROM VUE_DERNIERE_SORTIE_PRODUIT_STOCK VUE WHERE VUE.N_Produit = P.N_Produit AND VUE.N_Depot = ST.N_Depot ),
ST.*,
ValeurStock_Franc= ( CASE WHEN SOFT.MethodeValStock = 1 THEN ROUND(P.CMUP_Franc,2) ELSE ROUND(P.DernierPrixAchat_Franc,2) END )*
( ST.Qte_Stock + ( CASE WHEN @MethodeCalcul = 0 THEN ST.Qte_BL + ST.Qte_OF ELSE ISNULL(st.Qte_BL_Reservation,0) END  ) ),
ValeurStock_Euro=( CASE WHEN SOFT.MethodeValStock = 1 THEN ROUND(P.CMUP_Euro,2) ELSE ROUND(P.DernierPrixAchat_Euro,2) END )*
( ST.Qte_Stock + ( CASE WHEN @MethodeCalcul = 0 THEN ST.Qte_BL + ST.Qte_OF ELSE ISNULL(st.Qte_BL_Reservation,0) END  ) ),
Libre1=CAST( NULL as varchar(100) ),
Libre2=CAST( NULL as varchar(100) ),
Libre3=CAST( NULL as varchar(100) ),
Libre4=CAST( NULL as varchar(100) ),
Numeric1=CAST( NULL as numeric(18,10) ),
Numeric2=CAST( NULL as numeric(18,10) ),
Numeric3=CAST( NULL as numeric(18,10) ),
Numeric4=CAST( NULL as numeric(18,10) ),
Date1=CAST( NULL as datetime),
Date2=CAST( NULL as datetime),
P.ColorFond,
P.ColorTexte,
P.StyleFonte,
check1 = CAST(NULL AS varchar (3)),
check2 = CAST(NULL AS varchar (3))
from SOFT_INI SOFT, stock_produit ST, DEPOT D, PRODUIT P
   LEFT OUTER JOIN dbo.FAMILLE_PRODUIT FA ON FA.N_Famille_Produit = P.N_Famille_Produit
where( P.Parent > 0 )AND
( P.N_Produit = ST.N_Produit )AND
( P.GestionStock = 'Oui' )AND
( D.N_Depot = ST.N_Depot )AND
( ( D.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( ( P.N_Famille_Produit = @N_Famille_Produit )OR( @TypeFamille = 0 ) )AND
( @TypeArticle = 0 OR @TypeArticle = 2 )

UNION

select
FA.Code_Famille,
D.Nom_Depot,
F.Ref_Constructeur,
F.Nom_Fct_Base,
F.Total_HT_Produit_Franc+F.Total_HT_Heure_Franc,
F.Total_HT_Produit_Euro+F.Total_HT_Heure_Euro,
dateEntree=( SELECT Entree FROM VUE_DERNIERE_ENTREE_FCT_BASE_STOCK VUE WHERE VUE.N_Fct_Base = F.N_Fct_Base AND VUE.N_Depot = ST.N_Depot ),
dateSortie=( SELECT Sortie FROM VUE_DERNIERE_SORTIE_FCT_BASE_STOCK VUE WHERE VUE.N_Fct_Base = F.N_Fct_Base AND VUE.N_Depot = ST.N_Depot ),
ST.*,
ValeurStock_Franc=ROUND(F.Total_HT_Produit_Franc+F.Total_HT_Heure_Franc,2)*
( ST.Qte_Stock + ( CASE WHEN @MethodeCalcul = 0 THEN ST.Qte_BL ELSE ISNULL(st.Qte_BL_Reservation,0) END  ) ),
ValeurStock_Euro=ROUND(F.Total_HT_Produit_Euro+F.Total_HT_Heure_Euro,2)*
( ST.Qte_Stock + ( CASE WHEN @MethodeCalcul = 0 THEN ST.Qte_BL ELSE ISNULL(st.Qte_BL_Reservation,0) END  ) ),
Libre1=CAST( NULL as varchar(100) ),
Libre2=CAST( NULL as varchar(100) ),
Libre3=CAST( NULL as varchar(100) ),
Libre4=CAST( NULL as varchar(100) ),
Numeric1=CAST(  ISNULL(st.Qte_BL_Reservation,0)  as numeric(18,10) ),
Numeric2=CAST( NULL as numeric(18,10) ),
Numeric3=CAST( NULL as numeric(18,10) ),
Numeric4=CAST( NULL as numeric(18,10) ),
Date1=CAST( NULL as datetime),
Date2=CAST( NULL as datetime),
F.ColorFond,
F.ColorTexte,
F.StyleFonte,
check1 = CAST(NULL AS varchar (3)),
check2 = CAST(NULL AS varchar (3))
from stock_produit ST, DEPOT D, FCT_BASE F
   LEFT OUTER JOIN dbo.FAMILLE_PRODUIT FA ON FA.N_Famille_Produit = F.N_Famille_Produit
where( F.Parent > 0 )AND
( F.N_Fct_Base = ST.N_Fct_Base )AND
( F.GestionStock = 'Oui' )AND
( D.N_Depot = ST.N_Depot )AND
( ( D.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( ( F.N_Famille_Produit = @N_Famille_Produit )OR( @TypeFamille = 0 ) )AND
( @TypeArticle = 0 OR @TypeArticle = 1 )
)



