ALTER PROCEDURE [PREPARE_PROPOSITION_DA] 
@N_Demande_Achat int,
@N_Fourniss int,
@N_Affaire int,
@Ref int,
@Stock int,
@Commentaire int,
@Fcts_Base int,
@N_Document int,
@Prix int,
@TypeDocument int,
@SansPV int,
@TypePoste int,
@CodePoste varchar(50),
@Marque varchar(50),
@TypeMarque int,
@Cumul int,
@N_Famille_Produit int

AS

DELETE DA_DETAIL_PROPOSITION
WHERE N_Demande_Achat = @N_Demande_Achat

DECLARE
@N_Four int
SET @N_Four = ( SELECT N_Four FROM DEMANDE_ACHAT WHERE N_Demande_Achat = @N_Demande_Achat )

DECLARE
@N_DEPOT int
SET @N_DEPOT = ( SELECT N_DEPOT FROM DEMANDE_ACHAT WHERE N_Demande_Achat = @N_Demande_Achat )

IF( @Cumul = 0 )
BEGIN

INSERT INTO DA_DETAIL_PROPOSITION
( N_Demande_Achat,
N_Four,
N_Prod,
Designation,
Ref,
Quantite,
Prix_Ht_Franc,
Prix_Ht_Euro,
Remise,
Total_Franc,
Total_Euro,
N_Rubrique,
N_Depot,
QteLivre,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Marque,
Fournisseur )
select
@N_Demande_AChat,
@N_Four,
V.N_Prod,
V.Designation,
Left(V.Reference,20),
Qte = V.Qte,
Prix_HT_Franc = ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Franc ELSE V.EstimatifAchat_Franc END ) END ),
Prix_HT_Euro =  ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Euro ELSE V.EstimatifAchat_Euro END ) END ),
Remise = ( CASE WHEN @Prix = 0 THEN R.Remise ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise ELSE V.EstimatifAchat_Remise END ) END ),
Prix_HT_Remise_Franc = V.Qte*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Franc ELSE V.EstimatifAchat_Remise_Franc END ) END ),
Prix_HT_Remise_Euro =  V.Qte*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Euro ELSE V.EstimatifAchat_Remise_Euro END ) END ),
V.N_Rubrique,
@N_DEPOT,
0,
V.N_Position,
V.Unite,
V.Texte,
V.CodePoste,
V.Libre1,
V.Marque,
V.Fournisseur
FROM VUE_PROPOSITION_DA V
LEFT OUTER JOIN FOURNISS FO ON ( FO.N_Fourniss = @N_Fourniss )
LEFT OUTER JOIN REF R ON ( R.N_Produit = V.N_Prod )AND( R.N_Fourniss = FO.N_Fourniss )
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = V.N_Prod )
WHERE( N_Affaire = @N_Affaire )AND
( ( @TypeDocument = 2 AND V.N_Cde_Cli > 0 )OR( @TypeDocument = 3 AND V.N_Cde_Cli = @N_Document )
OR( @TypeDocument = 0 AND V.N_Devis > 0 )OR( @TypeDocument = 1 AND V.N_Devis = @N_Document ) )AND
( V.N_Fct_Base <= 0 OR( @Fcts_Base = 1 ) )AND
( (@Commentaire = 1 )OR( ISNULL(V.Qte,0) <> 0 ) )AND
(( @Stock = 0 )OR( V.GestionStock <> 'Oui' ))AND
(( @Ref <> 1 )OR( (R.N_Ref IS NOT NULL)OR( V.Fournisseur = FO.Nom_Fournisseur ) ))AND
(( @SansPV = 0 )OR( ISNULL( V.Prix_Total_Vente_Euro, 0 ) <> 0 ))AND
(( @N_Famille_Produit = 0 )OR( ISNULL( V.N_Famille_Produit, 0 ) = @N_Famille_Produit ))AND
(( @TypeMarque = 0 )OR( @TypeMarque = 1 AND V.Marque IN ( SELECT Marque FROM MARQUE_FOURNISSEUR M WHERE M.N_Fourniss = FO.N_Fourniss )  )OR( V.Marque = @Marque ) )AND
( ( @TypePoste = 0 )OR( ( ISNULL( V.CodePoste, '' ) + '.' ) LIKE ( @CodePoste + '.%' ) ) )

END


IF( @Cumul = 2 )
BEGIN

INSERT INTO DA_DETAIL_PROPOSITION
( N_Demande_Achat,
N_Four,
N_Prod,
Designation,
Ref,
Quantite,
Prix_Ht_Franc,
Prix_Ht_Euro,
Remise,
Total_Franc,
Total_Euro,
N_Rubrique,
N_Depot,
QteLivre,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Marque,
Fournisseur )
select
@N_Demande_Achat,
@N_Four,
V.N_Prod,
V.Designation,
Left(V.Reference,20),
Qte = SUM( V.Qte ),
Prix_HT_Franc = ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Franc ELSE V.EstimatifAchat_Franc END ) END ),
Prix_HT_Euro =  ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Euro ELSE V.EstimatifAchat_Euro END ) END ),
Remise = ( CASE WHEN @Prix = 0 THEN R.Remise ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise ELSE V.EstimatifAchat_Remise END ) END ),
Prix_HT_Remise_Franc = SUM( V.Qte )*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Franc ELSE V.EstimatifAchat_Remise_Franc END ) END ),
Prix_HT_Remise_Euro =  SUM( V.Qte )*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Euro ELSE V.EstimatifAchat_Remise_Euro END ) END ),
V.N_Rubrique,
@N_DEPOT,
0,
0,--V.N_Position,
V.Unite,
CAST( V.Texte AS VARCHAR(8000) ),
V.CodePoste,
V.Libre1,
V.Marque,
V.Fournisseur
FROM VUE_PROPOSITION_DA V
LEFT OUTER JOIN FOURNISS FO ON ( FO.N_Fourniss = @N_Fourniss )
LEFT OUTER JOIN REF R ON ( R.N_Produit = V.N_Prod )AND( R.N_Fourniss = FO.N_Fourniss )
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = V.N_Prod )
WHERE( N_Affaire = @N_Affaire )AND
( ( @TypeDocument = 2 AND V.N_Cde_Cli > 0 )OR( @TypeDocument = 3 AND V.N_Cde_Cli = @N_Document )
OR( @TypeDocument = 0 AND V.N_Devis > 0 )OR( @TypeDocument = 1 AND V.N_Devis = @N_Document ) )AND
( V.N_Fct_Base <= 0 OR( @Fcts_Base = 1 ) )AND
( (@Commentaire = 1 )OR( ISNULL(V.Qte,0) <> 0 ) )AND
(( @Stock = 0 )OR( V.GestionStock <> 'Oui' ))AND
(( @Ref <> 1 )OR( (R.N_Ref IS NOT NULL)OR( V.Fournisseur = FO.Nom_Fournisseur ) ))AND
(( @SansPV = 0 )OR( ISNULL( V.Prix_Total_Vente_Euro, 0 ) <> 0 ))AND
(( @N_Famille_Produit = 0 )OR( ISNULL( V.N_Famille_Produit, 0 ) = @N_Famille_Produit ))AND
(( @TypeMarque = 0 )OR( @TypeMarque = 1 AND V.Marque IN ( SELECT Marque FROM MARQUE_FOURNISSEUR M WHERE M.N_Fourniss = FO.N_Fourniss )  )OR( V.Marque = @Marque ) )AND
( ( @TypePoste = 0 )OR( ( ISNULL( V.CodePoste, '' ) + '.' ) LIKE ( @CodePoste + '.%' ) ) )

GROUP BY V.N_Prod, V.Designation, Left(V.Reference,20), R.Prix_HT_Franc, R.Prix_HT_Euro, V.DernierPrixAchat_Franc, V.DernierPrixAchat_Euro, V.EstimatifAchat_Franc, V.EstimatifAchat_Euro,
R.Remise, R.Prix_HT_Remise_Franc, R.Prix_HT_Remise_Euro, V.DernierPrixAchat_Remise_Franc, V.DernierPrixAchat_Remise_Euro, V.DernierPrixAchat_Remise, V.EstimatifAchat_Remise,
V.EstimatifAchat_Remise_Franc, V.EstimatifAchat_Remise_Euro, V.N_Rubrique, V.Unite, CAST( V.Texte AS VARCHAR(8000) ), V.CodePoste, V.Libre1, V.Marque, V.Fournisseur

END


IF( @Cumul = 1 )
BEGIN

INSERT INTO DA_DETAIL_PROPOSITION
( N_Demande_Achat,
N_Four,
N_Prod,
Designation,
Ref,
Quantite,
Prix_Ht_Franc,
Prix_Ht_Euro,
Remise,
Total_Franc,
Total_Euro,
N_Rubrique,
N_Depot,
QteLivre,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Marque,
Fournisseur )
select
@N_Demande_Achat,
@N_Four,
V.N_Prod,
V.Designation,
Left(V.Reference,20),
Qte = SUM( V.Qte ),
Prix_HT_Franc = ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Franc ELSE V.EstimatifAchat_Franc END ) END ),
Prix_HT_Euro =  ( CASE WHEN @Prix = 0 THEN R.Prix_HT_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Euro ELSE V.EstimatifAchat_Euro END ) END ),
Remise = ( CASE WHEN @Prix = 0 THEN R.Remise ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise ELSE V.EstimatifAchat_Remise END ) END ),
Prix_HT_Remise_Franc = SUM( V.Qte )*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Franc ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Franc ELSE V.EstimatifAchat_Remise_Franc END ) END ),
Prix_HT_Remise_Euro =  SUM( V.Qte )*( CASE WHEN @Prix = 0 THEN R.Prix_HT_Remise_Euro ELSE ( CASE WHEN @Prix = 1 THEN V.DernierPrixAchat_Remise_Euro ELSE V.EstimatifAchat_Remise_Euro END ) END ),
V.N_Rubrique,
@N_DEPOT,
0,
0,--V.N_Position,
V.Unite,
CAST( V.Texte AS VARCHAR(8000) ),
'',--V.CodePoste,
V.Libre1,
V.Marque,
V.Fournisseur
FROM VUE_PROPOSITION_DA V
LEFT OUTER JOIN FOURNISS FO ON ( FO.N_Fourniss = @N_Fourniss )
LEFT OUTER JOIN REF R ON ( R.N_Produit = V.N_Prod )AND( R.N_Fourniss = FO.N_Fourniss )
LEFT OUTER JOIN PRODUIT P ON ( P.N_Produit = V.N_Prod )
WHERE( N_Affaire = @N_Affaire )AND
( ( @TypeDocument = 2 AND V.N_Cde_Cli > 0 )OR( @TypeDocument = 3 AND V.N_Cde_Cli = @N_Document )
OR( @TypeDocument = 0 AND V.N_Devis > 0 )OR( @TypeDocument = 1 AND V.N_Devis = @N_Document ) )AND
( V.N_Fct_Base <= 0 OR( @Fcts_Base = 1 ) )AND
( (@Commentaire = 1 )OR( ISNULL(V.Qte,0) <> 0 ) )AND
(( @Stock = 0 )OR( V.GestionStock <> 'Oui' ))AND
(( @Ref <> 1 )OR( (R.N_Ref IS NOT NULL)OR( V.Fournisseur = FO.Nom_Fournisseur ) ))AND
(( @SansPV = 0 )OR( ISNULL( V.Prix_Total_Vente_Euro, 0 ) <> 0 ))AND
(( @N_Famille_Produit = 0 )OR( ISNULL( V.N_Famille_Produit, 0 ) = @N_Famille_Produit ))AND
(( @TypeMarque = 0 )OR( @TypeMarque = 1 AND V.Marque IN ( SELECT Marque FROM MARQUE_FOURNISSEUR M WHERE M.N_Fourniss = FO.N_Fourniss )  )OR( V.Marque = @Marque ) )AND
( ( @TypePoste = 0 )OR( ( ISNULL( V.CodePoste, '' ) + '.' ) LIKE ( @CodePoste + '.%' ) ) )

GROUP BY V.N_Prod, V.Designation, Left(V.Reference,20), R.Prix_HT_Franc, R.Prix_HT_Euro, V.DernierPrixAchat_Franc, V.DernierPrixAchat_Euro, V.EstimatifAchat_Franc, V.EstimatifAchat_Euro,
R.Remise, R.Prix_HT_Remise_Franc, R.Prix_HT_Remise_Euro, V.DernierPrixAchat_Remise_Franc, V.DernierPrixAchat_Remise_Euro, V.DernierPrixAchat_Remise, V.EstimatifAchat_Remise,
V.EstimatifAchat_Remise_Franc, V.EstimatifAchat_Remise_Euro, V.N_Rubrique, V.Unite, CAST( V.Texte AS VARCHAR(8000) ), 
--V.CodePoste, 
V.Libre1, V.Marque, V.Fournisseur

END
