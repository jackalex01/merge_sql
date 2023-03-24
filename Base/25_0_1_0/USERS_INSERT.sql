ALTER TRIGGER [USERS_INSERT] ON [USERS] 
FOR INSERT
AS

DECLARE @N_User integer

SELECT
	@N_User = i.N_User
FROM inserted i

/*crÚe un profil vierge*/
EXECUTE	INSERT_PROFIL -1

/*rattache le profil au user*/
UPDATE PROFIL_DROITS
	SET 	N_Profil = 0,
		N_User = @N_User
WHERE N_Profil = -1




