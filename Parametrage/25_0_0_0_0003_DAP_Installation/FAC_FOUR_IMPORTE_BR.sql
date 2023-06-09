ALTER PROCEDURE [FAC_FOUR_IMPORTE_BR] 
@N_BR int
AS


select 
Type = 1,
N_Position = SS.N_Position,
Qte = SS.Qte,
N_Produit = SS.N_Produit,
N_SS_BR= SS.N_SS_BR,
N_BR = @N_BR,
Remise = SS.Remise,
Tva = SS.Tva,
Designation = SS.Designation,
Texte = SS.Texte,
Unite = SS.Unite,
Ref_Produit = SS.Ref_Produit,
CodePoste = SS.CodePoste,
Libre1 = SS.Libre1,
N_Depot = SS.N_Depot,
PU_Euro = SS.PU_Euro,
HT_Euro = SS.Montant_Euro,
PU_Franc = SS.PU_Franc,
HT_Franc = SS.Montant_Franc,
N_Activites = A.N_Activites,
Activite = A.Code_Secteur,
SS.N_Affaire,
Affaire = AF.Designation
/* s{Col_Detail_Supp Code=Select Comment=Oui /} *//*  
,StyleFonte
,ColorFond
,ColorTexte
,numeric1
,numeric2
,date1
,date2
,check1
,check2
,Libre2
,Libre3
,Libre4
,numeric3
,numeric4
,Fournisseur
,Marque
*//* s{/Col_Detail_Supp Code=Select /} */ 
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 111 
,N_Fiche_Precedent = ss.N_Br
,N_Detail_Precedent = ss.N_Ss_Br
,App_LigneId_Origine = SS.App_LigneId
/* s{/App_LigneId Code=Select /} */   
from SS_BR SS
LEFT OUTER JOIN dbo.Activite A ON ( ( SS.Activite = A.Code_Secteur )AND( A.Parent = 0 ) )
LEFT OUTER JOIN AFFAIRE AF ON SS.N_Affaire = AF.N_Affaire
WHERE SS.N_BR = @N_BR

UNION ALL

select 
TOP 1
Type = 0,
N_Position = NULL,
Qte = NULL,
N_Produit =  NULL,
N_SS_BL= NULL,
N_BL = NULL,
Remise = NULL,
Tva = NULL,
Designation = '*** BR n° ' + CAST( BR.Num_BR as varchar(10) )+ ' ***',
Texte = NULL,
Unite = NULL,
Ref_Produit = NULL,
CodePoste = NULL,
Libre1 = NULL,
N_Depot = BR.N_DEPOT,
PU_Euro = NULL,
HT_Euro = NULL,
PU_Franc = NULL,
HT_Franc = NULL,
N_Activites = NULL,
Activite = NULL,
SS.N_Affaire,
Affaire = ''
/* s{Col_Detail_Supp Code=Select Comment=Oui /} *//*  
,StyleFonte
,ColorFond
,ColorTexte
,numeric1
,numeric2
,date1
,date2
,check1
,check2
,Libre2
,Libre3
,Libre4
,numeric3
,numeric4
,Fournisseur
,Marque
*//* s{/Col_Detail_Supp Code=Select /} */ 
/* s{App_LigneId Code=Select /} */
,TypeFiche_Precedent = 111 
,N_Fiche_Precedent = ss.N_Br
,N_Detail_Precedent = 0
,App_LigneId_Origine = ''
/* s{/App_LigneId Code=Select /} */
from BR BR, SS_BR SS
WHERE SS.N_BR = @N_BR AND BR.N_BR = SS.N_BR


ORDER BY Type, N_Position, N_SS_BR
