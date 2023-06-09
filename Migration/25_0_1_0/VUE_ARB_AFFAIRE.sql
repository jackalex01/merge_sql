CREATE VIEW [dbo].[VUE_ARB_AFFAIRE]
AS
SELECT A.N_Affaire, A.Designation, A.N_Client, A.Parent, 
    A.Num_Affaire, A.Total_Revient_Franc, A.Total_Vente_Franc, 
    C.Nom_Client, A.StyleFonte, A.ColorFond, A.ColorTexte, 
    A.Total_Revient_Euro,
    Champ1 = ISNULL(A.Champ1, ''),
    Champ2 = ISNULL(A.Champ2, ''),
    Champ3 = ISNULL(A.Champ3, ''),
    Champ4 = ISNULL(A.Champ4, ''),
    Champ5 = ISNULL(A.Champ5, ''),
    Champ6 = ISNULL(A.Champ6, ''),
    Champ7 = ISNULL(A.Champ7, ''),
    Champ8 = ISNULL(A.Champ8, ''),
    Champ9 = ISNULL(A.Champ9, ''),
    Champ10 = ISNULL(A.Champ10, ''),
    Champ11 = ISNULL(A.Champ11, ''),
    Champ12 = ISNULL(A.Champ12, ''),
    Champ13 = ISNULL(A.Champ13, ''),
    Champ14 = ISNULL(A.Champ14, ''),
    Champ15 = ISNULL(A.Champ15, ''),
    Champ16 = ISNULL(A.Champ16, ''),  
    A.Total_Vente_Euro, A.Solder, 
    A.Date_Ouverture, A.Date_Fermeture, DEP.N_Depot,
    DEP.Nom_Depot, A.User_Create, A.Date_Create, A.User_Modif, 
    A.Date_Modif, FAM.Code_Famille, I.Nom_Commercial,
    Nom_User_Create = LEFT(U1.Nom + ' ' + U1.Prenom, 25), 
    Nom_User_Modif = LEFT(U2.Nom + ' ' + U2.Prenom, 25), 
    Arborescence = ''
FROM dbo.Affaire A 
	LEFT OUTER JOIN dbo.CLIENT C ON A.N_Client = C.N_Client 
	LEFT OUTER JOIN dbo.DEPOT DEP ON A.N_Depot = DEP.N_Depot 
	LEFT OUTER JOIN dbo.FAMILLE_AFFAIRE FAM ON FAM.N_Famille_Affaire = A.N_Famille_Affaire 
	LEFT OUTER JOIN dbo.USERS U1 ON A.User_Create = U1.N_User 
	LEFT OUTER JOIN dbo.USERS U2 ON A.User_Modif = U2.N_User
	LEFT OUTER JOIN dbo.ITC I ON A.N_ITC = I.N_ITC 
WHERE A.Parent > 0 AND A.Variante = 0

GO
