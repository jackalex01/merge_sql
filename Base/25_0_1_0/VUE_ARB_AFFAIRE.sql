ALTER VIEW [VUE_ARB_AFFAIRE]
AS
SELECT A.N_Affaire, A.Designation, A.N_Client, A.Parent, 
    A.Num_Affaire, A.Total_Revient_Franc, A.Total_Vente_Franc, 
    C.Nom_Client, A.StyleFonte, A.ColorFond, A.ColorTexte, 
    A.Total_Revient_Euro,
    A.Champ1, 
    A.Champ2, 
    A.Champ3, 
    A.Champ4, 
    A.Champ5, 
    A.Champ6, 
    A.Champ7, 
    A.Champ8, 
    A.Champ9, 
    A.Champ10, 
    A.Champ11, 
    A.Champ12, 
    A.Champ13, 
    A.Champ14, 
    A.Champ15, 
    A.Champ16, 
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
WHERE A.Parent > 0







