ALTER VIEW [VUE_RECUPERATION_DEVIS_CDE_CLI_RUBRIQUE]
AS

SELECT
DEV.N_Devis,
A.Code_Secteur,
Designation=A.Secteur,
A.Manuel,
PU_Franc=SUM( L.Prix_Total_Vente_Franc ),
PU_Euro=SUM( L.Prix_Total_Vente_Euro ),
Unite='',
Quantite=1.0,
Ref = '',
CodePoste = '',
Libre1 = ''
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM DEVIS DEV, Lproduit L
   LEFT OUTER JOIN Activite A ON L.N_Rubrique = A.N_Activites
WHERE (L.N_Devis = DEV.N_Devis)AND( DEV.GrilleUnique = 'Non' )
GROUP BY DEV.N_Devis, Code_Secteur, Secteur, Manuel

UNION

SELECT
DEV.N_Devis,
A.Code_Secteur,
Designation=A.Secteur,
A.Manuel,
SUM( E.Prix_Total_Vente_Franc ),
SUM( E.Prix_Total_Vente_Euro ),
Unite='',
Quantite=1.0,
Ref = '',
CodePoste = '',
Libre1 = ''
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM DEVIS DEV, Etudes E
   LEFT OUTER JOIN Activite A ON E.N_Rubrique = A.N_Activites
WHERE (E.N_Devis = DEV.N_Devis)AND( DEV.GrilleUnique = 'Non' )
GROUP BY DEV.N_Devis, Code_Secteur, Secteur, Manuel

UNION

SELECT
DEV.N_Devis,
A.Code_Secteur,
Designation=A.Secteur,
A.Manuel,
SUM( F.Prix_Total_Vente_Franc ),
SUM( F.Prix_Total_Vente_Euro ),
Unite='',
Quantite=1.0,
Ref = '',
CodePoste = '',
Libre1 = ''
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM DEVIS DEV, Frais_d F
   LEFT OUTER JOIN Activite A ON F.N_Rubrique = A.N_Activites
WHERE (F.N_Devis = DEV.N_Devis)AND( DEV.GrilleUnique = 'Non' )
GROUP BY DEV.N_Devis, Code_Secteur, Secteur, Manuel

UNION

SELECT
DEV.N_Devis,
A.Code_Secteur,
Designation=A.Secteur,
A.Manuel,
SUM(LF.Prix_Total_Franc*DET.Quantite*DET.Coeff*(1.0-( CASE WHEN DET.Remise IS NULL THEN 0 ELSE DET.Remise END )/100.0)),
SUM(LF.Prix_Total_Euro*DET.Quantite*DET.Coeff*(1.0-( CASE WHEN DET.Remise IS NULL THEN 0 ELSE DET.Remise END )/100.0)),
Unite='',
Quantite=1.0,
Ref = '',
CodePoste = '',
Libre1 = ''
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM DEVIS DEV, DEVISDETAIL DET, LFCT_DEVISDETAIL LF
   LEFT OUTER JOIN Activite A ON LF.N_Rubrique =
A.N_Activites
WHERE (DET.N_Devis = DEV.N_Devis)AND( LF.N_Ligne = DET.N_DevisDetail )AND( DEV.GrilleUnique = 'Oui' )
AND( ISNULL( DET.Options, 0 ) = 0 )
GROUP BY DEV.N_Devis,Code_Secteur, Secteur, Manuel

UNION

SELECT
DEV.N_Devis,
A.Code_Secteur,
Designation=A.Secteur,
A.Manuel,
SUM( DET.Prix_Total_Vente_Franc ),
SUM( DET.Prix_Total_Vente_Euro ),
Unite='',
Quantite=1.0,
Ref = '',
CodePoste = '',
Libre1 = ''
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 123
,N_Fiche_Precedent = dev.N_Devis
,N_Detail_Precedent =0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
FROM DEVIS DEV, DEVISDETAIL DET
   LEFT OUTER JOIN Activite A ON DET.N_Rubrique = A.N_Activites
WHERE (DET.N_Devis = DEV.N_Devis)AND( ISNULL( DET.N_Fct_Base, 0 ) = 0 )AND( DEV.GrilleUnique = 'Oui' )
AND( ISNULL( DET.Options, 0 ) = 0 )
GROUP BY DEV.N_Devis,Code_Secteur, Secteur, Manuel



