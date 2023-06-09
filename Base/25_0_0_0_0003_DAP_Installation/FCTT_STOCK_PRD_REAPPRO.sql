ALTER FUNCTION [FCTT_STOCK_PRD_REAPPRO]
(     
@N_User int,
@SimulationOF int,
@N_Depot int,
@TypeDepot int,
@N_Famille_Produit int,
@TypeFamille int
)
RETURNS TABLE 
AS
RETURN 
(
SELECT
P.N_Produit, P.Nom_Produit, 
P.Ref_Constructeur, D.Nom_Depot,
F.Code_Famille,
QteATerme=S.Qte_Stock + S.Qte_Cde_Fournisseur - S.Qte_Cde_Client
- ( CASE WHEN @SimulationOF = 0 THEN 0 ELSE ( SELECT SUM( LF.Quantite*O.Qte )
FROM LFCT LF, FCT_BASE FCT, ORDREF O
WHERE ( LF.N_Fct_Base = FCT.N_Fct_Base )AND( FCT.N_Fct_Base = O.N_Fct_Base )
AND(O.Simuler = 'Oui')AND( O.Parent > 0 )AND( LF.N_Produit = P.N_Produit)
AND(( O.N_Depot = D.N_Depot )OR( @TypeDepot = 0 ))) END ),
P.QteMini, P.QteAppro,
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
P.StyleFonte
FROM DEPOT D, STOCK_PRODUIT S, PRODUIT P
   LEFT OUTER JOIN dbo.FAMILLE_PRODUIT F ON F.N_Famille_Produit = P.N_Famille_Produit
WHERE ( P.Parent > 0 )AND
( P.GestionStock = 'Oui' )AND
( S.N_Produit = P.N_Produit )AND
( S.N_Depot = D.N_Depot )AND
( ( D.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( ( F.N_Famille_Produit = @N_Famille_Produit )OR( @TypeFamille = 0 ) )AND
EXISTS( SELECT LF.N_Produit FROM LFCT LF, FCT_BASE FCT, ORDREF O
WHERE ( LF.N_Produit = P.N_Produit )AND( LF.N_Fct_Base = FCT.N_Fct_Base )AND( FCT.N_Fct_Base = O.N_Fct_Base )
AND(O.Simuler = 'Oui')AND( O.Parent > 0 ) )AND
( P.QteMini > ( S.Qte_Stock + S.Qte_Cde_Fournisseur - S.Qte_Cde_Client
- ( CASE WHEN @SimulationOF = 0 THEN 0 ELSE ( SELECT SUM( LF.Quantite*O.Qte )
FROM LFCT LF, FCT_BASE FCT, ORDREF O
WHERE ( LF.N_Fct_Base = FCT.N_Fct_Base )AND( FCT.N_Fct_Base = O.N_Fct_Base )
AND(O.Simuler = 'Oui')AND( O.Parent > 0 )AND( LF.N_Produit = P.N_Produit)
AND(( O.N_Depot = D.N_Depot )OR( @TypeDepot = 0 ))) END ) ) )

UNION ALL

SELECT
P.N_Produit, P.Nom_Produit, 
P.Ref_Constructeur, D.Nom_Depot,
F.Code_Famille,
QteATerme=S.Qte_Stock + S.Qte_Cde_Fournisseur - S.Qte_Cde_Client,
P.QteMini, P.QteAppro,
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
P.StyleFonte
FROM DEPOT D, STOCK_PRODUIT S, PRODUIT P
   LEFT OUTER JOIN dbo.FAMILLE_PRODUIT F ON F.N_Famille_Produit = P.N_Famille_Produit
WHERE ( P.Parent > 0 )AND
( P.GestionStock = 'Oui' )AND
( S.N_Produit = P.N_Produit )AND
( S.N_Depot = D.N_Depot )AND
( ( D.N_Depot = @N_Depot )OR( @TypeDepot = 0 ) )AND
( ( F.N_Famille_Produit = @N_Famille_Produit )OR( @TypeFamille = 0 ) )AND
NOT EXISTS( SELECT LF.N_Produit FROM LFCT LF, FCT_BASE FCT, ORDREF O
WHERE ( LF.N_Produit = P.N_Produit )AND( LF.N_Fct_Base = FCT.N_Fct_Base )AND( FCT.N_Fct_Base = O.N_Fct_Base )
AND(O.Simuler = 'Oui')AND( O.Parent > 0 ) ) AND
( P.QteMini > ( S.Qte_Stock + S.Qte_Cde_Fournisseur - S.Qte_Cde_Client ) )
)

