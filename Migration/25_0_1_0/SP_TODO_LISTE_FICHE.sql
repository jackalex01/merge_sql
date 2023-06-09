CREATE PROCEDURE [dbo].[SP_TODO_LISTE_FICHE]
@Type_Fiche integer

AS

IF( @Type_Fiche not IN ( 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 113, 115, 117, 118, 120, 122, 123, 127, 128, 130, 132, 133 ) )
SELECT 
N_Fiche = 0,
Nom_Col1 = 'Sélectionner un type de fiche...',
Nom_Col2 = ''


IF( @Type_Fiche = 100 )
SELECT 
N_Fiche = CL.N_Client,
Nom_Col1 = CL.Nom_Client,
Nom_Col2 = CL.Nom_Ville
FROM CLIENT CL
WHERE CL.Parent > 0 AND @Type_Fiche = 100
ORDER BY Nom_Col1


IF( @Type_Fiche = 101 )
SELECT 
N_Fiche = CO.N_Contact,
Nom_Col1 = CO.Nom_Contact + ' ' + ISNULL( CO.Prenom_Contact, '' ),
Nom_Col2 = CL.Nom_Client
FROM CONTACT CO
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = CO.N_Client
WHERE CO.Parent > 0 AND @Type_Fiche = 101
ORDER BY Nom_Col1


IF( @Type_Fiche = 102 )
SELECT 
N_Fiche = P.N_Projet,
Nom_Col1 = P.Nom_Projet,
Nom_Col2 = CL.Nom_Client
FROM PROJET P
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = P.N_Client
WHERE P.Parent > 0 AND @Type_Fiche = 102
ORDER BY Nom_Col1


IF( @Type_Fiche = 103 )
SELECT 
N_Fiche = BL.N_BL,
Nom_Col1 = BL.Nom_BL,
Nom_Col2 = A.Designation
FROM BL BL
LEFT OUTER JOIN AFFAIRE A ON A.N_Affaire = BL.N_Affaire
WHERE BL.Parent > 0 AND @Type_Fiche = 103
ORDER BY Nom_Col1


IF( @Type_Fiche = 104 )
SELECT 
N_Fiche = CDE.N_Cde_Cli,
Nom_Col1 = CDE.Nom_CDE,
Nom_Col2 = A.Designation
FROM CDE_CLI CDE
LEFT OUTER JOIN AFFAIRE A ON A.N_Affaire = CDE.N_Affaire
WHERE CDE.Parent > 0 AND @Type_Fiche = 104
ORDER BY Nom_Col1


IF( @Type_Fiche = 105 )
SELECT 
N_Fiche = FACT.N_Fact_Cli,
Nom_Col1 = FACT.Nom_Fac_Cli,
Nom_Col2 = CL.Nom_Client
FROM FACT_CLI FACT
LEFT OUTER JOIN CLIENT CL ON FACT.N_Client = CL.N_Client
WHERE FACT.Parent > 0 AND @Type_Fiche = 105
ORDER BY Nom_Col1


IF( @Type_Fiche = 106 )
SELECT 
N_Fiche = FO.N_Fourniss,
Nom_Col1 = FO.Nom_Fournisseur,
Nom_Col2 = FO.Nom_Ville
FROM FOURNISS FO
WHERE FO.Parent > 0 AND @Type_Fiche = 106
ORDER BY Nom_Col1


IF( @Type_Fiche = 107 )
SELECT 
N_Fiche = CO.N_Contact,
Nom_Col1 = CO.Nom_Contact + ' ' + ISNULL( CO.Prenom_Contact, '' ),
Nom_Col2 = FO.Nom_Fournisseur
FROM CONTFN CO
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = CO.N_Fournisseur
WHERE CO.Parent > 0 AND @Type_Fiche = 107
ORDER BY Nom_Col1



IF( @Type_Fiche = 108 )
SELECT 
N_Fiche = O.N_OF,
Nom_Col1 = O.Nom_OF,
Nom_Col2 = O.Date_OF
FROM ORDREF O
WHERE O.Parent > 0 AND @Type_Fiche = 108
ORDER BY Nom_Col1


IF( @Type_Fiche = 109 )
SELECT 
N_Fiche = RF.N_RF,
Nom_Col1 = RF.Nom_RF,
Nom_Col2 = RF.Date_RF
FROM RF RF
WHERE RF.Parent > 0 AND @Type_Fiche = 109
ORDER BY Nom_Col1


IF( @Type_Fiche = 111 )
SELECT 
N_Fiche = BR.N_BR,
Nom_Col1 = BR.Nom_BR,
Nom_Col2 = A.Designation
FROM BR BR
LEFT OUTER JOIN AFFAIRE A ON A.N_Affaire = BR.N_Affaire
WHERE BR.Parent > 0 AND @Type_Fiche = 111
ORDER BY Nom_Col1


IF( @Type_Fiche = 112 )
SELECT 
N_Fiche = CDE.N_Cde_Four,
Nom_Col1 = CDE.Nom_Cde_Four,
Nom_Col2 = A.Designation
FROM CDE_FOUR CDE
LEFT OUTER JOIN AFFAIRE A ON A.N_Affaire = CDE.N_Affaire
WHERE CDE.Parent > 0 AND @Type_Fiche = 112
ORDER BY Nom_Col1


IF( @Type_Fiche = 113 )
SELECT 
N_Fiche = FAC.N_Fac_Four,
Nom_Col1 = FAC.Nom_Fac_Four,
Nom_Col2 = A.Designation
FROM FAC_FOUR FAC
LEFT OUTER JOIN AFFAIRE A ON A.N_Affaire = FAC.N_Affaire
WHERE FAC.Parent > 0 AND @Type_Fiche = 113
ORDER BY Nom_Col1


IF( @Type_Fiche = 115 )
SELECT 
N_Fiche = I.N_ITC,
Nom_Col1 = I.Nom_Commercial,
Nom_Col2 = I.Prenom
FROM ITC I
WHERE I.Parent > 0 AND @Type_Fiche = 115
ORDER BY Nom_Col1


IF( @Type_Fiche = 117 )
SELECT 
N_Fiche = FCT.N_Fct_Base,
Nom_Col1 = FCT.Nom_Fct_Base,
Nom_Col2 = FCT.Ref_Constructeur
FROM FCT_BASE FCT
WHERE FCT.Parent > 0 AND @Type_Fiche = 117
ORDER BY Nom_Col1


IF( @Type_Fiche = 118 )
SELECT 
N_Fiche = P.N_Produit,
Nom_Col1 = P.Nom_Produit,
Nom_Col2 = P.Ref_Constructeur
FROM PRODUIT P
WHERE P.Parent > 0 AND @Type_Fiche = 118
ORDER BY Nom_Col1


IF( @Type_Fiche = 120 )

SELECT 
N_Fiche = A.N_Affaire,
Nom_Col1 = A.Designation,
Nom_Col2 = CL.Nom_Client
FROM AFFAIRE A
LEFT OUTER JOIN CLIENT CL ON A.N_Client = CL.N_Client
WHERE A.Parent > 0 AND @Type_Fiche = 120
ORDER BY Nom_Col1


IF( @Type_Fiche = 122 )
SELECT 
N_Fiche = INV.N_Inventaire,
Nom_Col1 = INV.Nom_Inventaire,
Nom_Col2 = INV.Date_Inventaire
FROM INVENTAIRE INV
WHERE INV.Parent > 0 AND @Type_Fiche = 122
ORDER BY Nom_Col1


IF( @Type_Fiche = 123 )
SELECT 
N_Fiche = D.N_Devis,
Nom_Col1 = D.Nom_Devis,
Nom_Col2 = CL.Nom_Client
FROM DEVIS D
LEFT OUTER JOIN CLIENT CL ON D.N_Client = CL.N_Client
WHERE D.Parent > 0 AND @Type_Fiche = 123
ORDER BY Nom_Col1


IF( @Type_Fiche = 127 )
SELECT 
N_Fiche = DA.N_Demande_Achat,
Nom_Col1 = DA.Nom_Demande_Achat,
Nom_Col2 = FO.Nom_Fournisseur
FROM DEMANDE_ACHAT DA
LEFT OUTER JOIN FOURNISS FO ON DA.N_Four = FO.N_Fourniss
WHERE DA.Parent > 0 AND @Type_Fiche = 127
ORDER BY Nom_Col1


IF( @Type_Fiche = 128 )
SELECT 
N_Fiche = CA.N_Campagne,
Nom_Col1 = CA.Nom_Campagne,
Nom_Col2 = I.Nom_Commercial
FROM CAMPAGNE CA
LEFT OUTER JOIN ITC I ON I.N_ITC = CA.N_ITC
WHERE CA.Parent > 0 AND @Type_Fiche = 128
ORDER BY Nom_Col1


IF( @Type_Fiche = 130 )
SELECT 
N_Fiche = DC.N_Demande_Conge,
Nom_Col1 = DC.Nom_Demande_Conge,
Nom_Col2 = I.Nom_Commercial
FROM DEMANDE_CONGE DC
LEFT OUTER JOIN ITC I ON I.N_ITC = DC.N_ITC
WHERE DC.Parent > 0 AND @Type_Fiche = 130
ORDER BY Nom_Col1


IF( @Type_Fiche = 132 )
SELECT 
N_Fiche = t.N_Demande_Appro,
Nom_Col1 = t.Nom_Demande_Appro,
Nom_Col2 = a.Designation
FROM TB_DAP_DEMANDE_APPRO t
LEFT OUTER JOIN Affaire a ON a.N_Affaire = t.N_Affaire
WHERE t.Parent > 0 AND @Type_Fiche = 132
ORDER BY Nom_Col1

IF( @Type_Fiche = 133 )
SELECT 
N_Fiche = t.N_Equipement,
Nom_Col1 = t.Nom_Equipement,
Nom_Col2 = t.Code
FROM TB_EQP_EQUIPEMENT t
WHERE t.Parent > 0 AND @Type_Fiche = 133
ORDER BY Nom_Col1

GO
