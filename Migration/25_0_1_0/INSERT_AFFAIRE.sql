CREATE PROCEDURE [dbo].[INSERT_AFFAIRE]
@N_User integer
AS

DECLARE 
@N_Depot int

/* par défaut, le dépôt d'appartenance de l'utilisateur */
SET @N_Depot = ( SELECT I.N_Depot
From USERS U, ITC I
WHERE( U.N_User = @N_User )AND( U.N_ITC = I.N_ITC )AND( I.Parent > 0 )AND( I.Actif = 'Oui' ))
/* sinon un dépôt par défaut */
IF ISNULL( @N_Depot, 0 ) = 0 SET @N_Depot = (SELECT N_Depot FROM Depot WHERE Depot_Principal = 'Oui')

INSERT INTO AFFAIRE( Parent, User_Create, User_Modif, N_Depot, Variante ) VALUES( -1, @N_User, @N_User, @N_Depot, 0)

--SELECT MAX(N_AFFAIRE) FROM AFFAIRE
DECLARE @n_affaire int
select @n_affaire = SCOPE_IDENTITY()
select @n_affaire

GO
