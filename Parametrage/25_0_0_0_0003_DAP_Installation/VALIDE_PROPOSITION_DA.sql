ALTER PROCEDURE [VALIDE_PROPOSITION_DA] 
@N_Demande_Achat int

AS


DECLARE
@N_Four integer,
@N_Prod integer,
@Designation varchar(50),
@Ref varchar(50),
@Quantite numeric(18,10),
@Prix_Ht_Franc numeric(18,10),
@Prix_Ht_Euro numeric(18,10),
@Remise numeric(18,10),
@Total_Franc numeric(18,10),
@Total_Euro numeric(18,10),
@N_Rubrique integer,
@N_Depot integer,
--@QteLivre numeric(18,10),
@N_Position numeric(18,10),
@Unite varchar(50),
@Texte varchar(max),
@CodePoste varchar(50),
@Libre1 varchar(50),
@Marque varchar(50),
@Fournisseur varchar(50),
@Tva numeric(18,10),
@N_PositionMax numeric(18,10),
@Date1 datetime,
@Date2 datetime,
@Numeric1 numeric(18,10),
@Numeric2 numeric(18,10),
@check1 varchar(3),
@check2 varchar(3),
@genesys_lock varchar(3),
@N_Affaire integer
/* s{App_LigneId Code=Declare /} */
, @TypeFiche_Precedent INT 
, @N_Fiche_Precedent INT 
, @N_Detail_Precedent INT 
, @App_LigneId varchar (50)
/* s{/App_LigneId Code=Declare /} */

SET @N_PositionMax = ISNULL( ( SELECT MAX( N_Position ) FROM DA_DETAIL WHERE N_Demande_Achat = @N_Demande_AChat ), 0.0 )

DECLARE @CursorVar CURSOR
SET @CursorVar = CURSOR SCROLL DYNAMIC


FOR
SELECT
N_Demande_Achat,
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
--QteLivre,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Marque,
Fournisseur,
Tva,
Date1,
Date2,
Numeric1,
Numeric2,
check1,
check2,
genesys_lock,
N_Affaire
/* s{App_LigneId Code=Cursor_Select /} */
, TypeFiche_Precedent
, N_Fiche_Precedent
, N_Detail_Precedent
, App_LigneId
/* s{/App_LigneId Code=Cursor_Select /} */
FROM DA_DETAIL_PROPOSITION
WHERE N_Demande_Achat = @N_Demande_Achat
ORDER BY N_Position, N_Da_Detail_Proposition
OPEN @CursorVar 
FETCH NEXT FROM @CursorVar
INTO @N_Demande_Achat, @N_Four, @N_Prod, @Designation, @Ref, @Quantite, @Prix_Ht_Franc, @Prix_Ht_Euro, @Remise,
@Total_Franc, @Total_Euro, @N_Rubrique, @N_Depot, /*@QteLivre,*/ @N_Position, @Unite,
@Texte, @CodePoste, @Libre1, @Marque, @Fournisseur, @Tva, @Date1, @Date2, @Numeric1, @Numeric2, @check1, @check2, @genesys_lock, @N_Affaire
/* s{App_LigneId Code=Cursor_Variable /} */
, @TypeFiche_Precedent
, @N_Fiche_Precedent
, @N_Detail_Precedent
, @App_LigneId
/* s{/App_LigneId Code=Cursor_Variable /} */
WHILE @@FETCH_STATUS = 0
BEGIN

SET @N_PositionMax = @N_PositionMax + 100.0

INSERT INTO DA_DETAIL
(N_Demande_Achat,
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
--QteLivre,
N_Position,
Unite,
Texte,
CodePoste,
Libre1,
Tva,
Date1,
Date2,
Numeric1,
Numeric2,
check1,
check2,
genesys_lock,
N_Affaire 
/* s{App_LigneId Code=Insert /} */
, TypeFiche_Precedent
, N_Fiche_Precedent
, N_Detail_Precedent
, App_LigneId_Origine
/* s{/App_LigneId Code=Insert /} */
)
SELECT
@N_Demande_Achat, @N_Four, @N_Prod, @Designation, @Ref, @Quantite, @Prix_Ht_Franc, @Prix_Ht_Euro, @Remise,
@Total_Franc, @Total_Euro, @N_Rubrique, @N_Depot, /*@QteLivre,*/ @N_PositionMax, @Unite,
@Texte, @CodePoste, @Libre1, @Tva, @Date1, @Date2, @Numeric1, @Numeric2, @check1, @check2, @genesys_lock, @N_Affaire 
/* s{App_LigneId Code=Insert_Select /} */
, @TypeFiche_Precedent
, @N_Fiche_Precedent
, @N_Detail_Precedent
, @App_LigneId 
/* s{/App_LigneId Code=Insert_Select /} */


FETCH NEXT FROM @CursorVar
INTO @N_Demande_Achat, @N_Four, @N_Prod, @Designation, @Ref, @Quantite, @Prix_Ht_Franc, @Prix_Ht_Euro, @Remise,
@Total_Franc, @Total_Euro, @N_Rubrique, @N_Depot, /*@QteLivre,*/ @N_Position, @Unite,
@Texte, @CodePoste, @Libre1, @Marque, @Fournisseur, @Tva, @Date1, @Date2, @Numeric1, @Numeric2, @check1, @check2, @genesys_lock, @N_Affaire
/* s{App_LigneId Code=Cursor_Variable /} */
, @TypeFiche_Precedent
, @N_Fiche_Precedent
, @N_Detail_Precedent
, @App_LigneId
/* s{/App_LigneId Code=Cursor_Variable /} */
END

CLOSE @CursorVar
DEALLOCATE @CursorVar



