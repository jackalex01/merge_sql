ALTER PROCEDURE [SP_GENEMAIL_PROPRIETES_DETAIL]
@N_GENEMail integer,
@N_User integer,
@N_Lang integer
AS

DECLARE @Type_Fiche integer
SET @Type_Fiche = ISNULL( ( SELECT TypeFiche FROM GENEMAIL WHERE N_GENEMail = @N_GeneMail ), 0 )

DECLARE @N_Fiche integer
IF( @Type_Fiche <> 0 ) 
	SET @N_Fiche = ISNULL( ( SELECT N_Fiche FROM GENEMAIL WHERE N_GENEMail = @N_GeneMail ), 0 )
ELSE
	SET @N_Fiche = 0


IF( @Type_Fiche not IN ( 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 113, 115, 117, 118, 120, 122, 123, 127, 128, 130, 132 ) OR @N_Fiche = 0 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( '<HR>' as varchar(200) ),
Msg3 = CAST( 'pas de fiche associée' as varchar(200) ),
Msg4 = CAST( '' as varchar(200) ),
Msg5 = CAST( '' as varchar(200) ),
Msg6 = CAST( '' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )


IF( @Type_Fiche = 100 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_CLIENT">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:3"><B>' + ISNULL( CL.Nom_Client, '' ) + '<IND x="250">' + ( CASE WHEN CL.Prospect = 'Oui' Then 'Prospect' ELSE '' END )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( ISNULL( CL.Adresse1, '' ) + ' ' + ISNULL( CL.Adresse2, '' ) + ' ' + ISNULL( CL.Adresse3, '' ) + ' ' + ISNULL( CL.Code_Postal, '' ) + ' ' + ISNULL( CL.Nom_Ville, '' ) + '<IND x="250">' + ISNULL( CL.Nom_Pays, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Standard : ' + ISNULL( CL.Standard, '' ) + '<IND x="250">' + '- Fax : ' + ISNULL( CL.Fax, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CLIENT CL
WHERE CL.N_Client = @N_Fiche


IF( @Type_Fiche = 101 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( '<IND x="150"> <IMG src="idx:52"> <A href="' + 'mailto:' + ISNULL( CO.Internet, '' ) +'">envoyer un email</A>'  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_CONTACT">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:4"><B>' + ISNULL( CO.Titre, '' ) + ' ' +  ISNULL( CO.Prenom_Contact, '' ) + ' ' + ISNULL( CO.Nom_Contact, '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( CO.Fonction, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Ligne directe : ' + ISNULL( CO.Ligne_Directe, '' ) + '<IND x="225">' + '- Fax : ' + ISNULL( CO.Fax, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CONTACT CO
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = CO.N_Client
WHERE CO.N_Contact = @N_Fiche


IF( @Type_Fiche = 102 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_PROJET">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:5"><B>' + ISNULL( PR.Nom_Projet, '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( PR.Action_En_Cours, '' ) + '<IND x="225">' + ISNULL( CO.Prenom_Contact, '' ) + ' ' +  ISNULL( CO.Nom_Contact, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- ' + ISNULL( PR.Resultat, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
PROJET PR
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = PR.N_Client
LEFT OUTER JOIN CONTACT CO ON CO.N_Contact = PR.N_Contact
WHERE PR.N_Projet = @N_Fiche


IF( @Type_Fiche = 103 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_BL">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:19"><B>' + 'N° ' + ISNULL( CAST( BL.Num_BL as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), BL.Date_BL, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
BL BL
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = BL.N_Client
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = BL.N_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = BL.N_ITC
WHERE BL.N_BL = @N_Fiche


IF( @Type_Fiche = 104 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_CDE_CLI">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:12"><B>' + 'N° ' + ISNULL( CAST( CDE.Num_Cde_Cli as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), CDE.Date_Cde, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CDE_CLI CDE
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = CDE.N_Client
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = CDE.N_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = CDE.N_ITC1
WHERE CDE.N_Cde_Cli = @N_Fiche


IF( @Type_Fiche = 105 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_FACT_CLI">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:13"><B>' + ( CASE When FACT.Avoir = 'Oui' THEN 'Avoir ' ELSE 'Facture ' END ) + 'N° ' + ISNULL( CAST( FACT.Num_Fact_Cli as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), FACT.Date_Facture, 103 ), '' ) + '<IND x="225">' + '- Echéance : ' + ISNULL( CONVERT( varchar(15), FACT.Date_Echeance, 103 ), '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
FACT_CLI FACT
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = FACT.N_Client
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = FACT.N_Affaire
LEFT OUTER JOIN CDE_CLI CDE ON CDE.N_Cde_Cli = FACT.N_Cde_Cli
WHERE FACT.N_Fact_Cli = @N_Fiche


IF( @Type_Fiche = 106 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_FOURNISS">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:9"><B>' + ISNULL( FO.Nom_Fournisseur, '' ) + '<IND x="250">' + ( CASE WHEN FO.Eviter = 'Oui' Then 'A éviter' ELSE '' END )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( ISNULL( FO.Code_Postal, '' ) + ' ' + ISNULL( FO.Nom_Ville, '' ) + '<IND x="250">' + ISNULL( FO.Nom_Pays, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Standard : ' + ISNULL( FO.Tel_Standard, '' ) + '<IND x="250">' + '- Fax : ' + ISNULL( FO.Fax, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
FOURNISS FO
WHERE FO.N_Fourniss = @N_Fiche


IF( @Type_Fiche = 107 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( '<IND x="150"> <IMG src="idx:52"> <A href="' + 'mailto:' + ISNULL( CO.Internet, '' ) +'">envoyer un email</A>'  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_CONTFN">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:6"><B>' + ISNULL( CO.Titre, '' ) + ' ' +  ISNULL( CO.Prenom_Contact, '' ) + ' ' + ISNULL( CO.Nom_Contact, '' ) + '<IND x="225">' + ISNULL( FO.Nom_Fournisseur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( CO.Fonction, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Ligne directe : ' + ISNULL( CO.Ligne_Directe, '' ) + '<IND x="225">' + '- Fax : ' + ISNULL( CO.Fax, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CONTFN CO
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = CO.N_Fournisseur
WHERE CO.N_Contact = @N_Fiche


IF( @Type_Fiche = 108 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_ORDREF">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:21"><B>' + 'N° ' + ISNULL( CAST( O.Num_OF as varchar(15 ) ), '' ) + '<IND x="225">' + ( CASE WHEN O.Realiser = 'Oui' Then 'Fabrication complète' ELSE '' END ) + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( FCT.Ref_Constructeur, '' ) + '<IND x="225">' + ISNULL( CONVERT( varchar(15), O.Date_OF, 103 ), '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- ' + ISNULL( FCT.Nom_Fct_Base, '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
ORDREF O
LEFT OUTER JOIN FCT_BASE FCT ON FCT.N_Fct_Base = O.N_Fct_Base
LEFT OUTER JOIN ITC I ON I.N_ITC = O.N_ITC
WHERE O.N_OF = @N_Fiche


IF( @Type_Fiche = 109 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_RF">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:22"><B>' + 'N° ' + ISNULL( CAST( RF.Num_RF as varchar(15 ) ), '' ) + '<IND x="225">' + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( FCT.Ref_Constructeur, '' ) + '<IND x="225">' + ISNULL( CONVERT( varchar(15), RF.Date_RF, 103 ), '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- ' + ISNULL( FCT.Nom_Fct_Base, '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
RF RF
LEFT OUTER JOIN FCT_BASE FCT ON FCT.N_Fct_Base = RF.N_Fct_Base
LEFT OUTER JOIN ITC I ON I.N_ITC = RF.N_ITC
WHERE RF.N_RF = @N_Fiche


IF( @Type_Fiche = 111 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_BR">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:20"><B>' + 'N° ' + ISNULL( CAST( BR.Num_BR as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( FO.Nom_Fournisseur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), BR.Date_BR, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
BR BR
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = BR.N_Fournisseur
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = BR.N_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = BR.N_ITC
WHERE BR.N_BR = @N_Fiche


IF( @Type_Fiche = 112 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_CDE_FOUR">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:15"><B>' + 'N° ' + ISNULL( CAST( CDE.Num_Cde_Four as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( FO.Nom_Fournisseur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), CDE.Date_Com, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CDE_FOUR CDE
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = CDE.N_Four
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = CDE.N_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = CDE.N_ITC
WHERE CDE.N_Cde_Four = @N_Fiche


IF( @Type_Fiche = 113 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_FAC_FOUR">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:16"><B>' + ( CASE When FACT.Avoir = 'Oui' THEN 'Avoir ' ELSE 'Facture ' END ) + 'N° ' + ISNULL( CAST( FACT.Num_Fac_Four as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( FO.Nom_Fournisseur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), FACT.Date_Facture, 103 ), '' ) + '<IND x="225">' + '- Echéance : ' + ISNULL( CONVERT( varchar(15), FACT.Echeance, 103 ), '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
FAC_FOUR FACT
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = FACT.N_Fournisseur
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = FACT.N_Affaire
LEFT OUTER JOIN CDE_FOUR CDE ON CDE.N_Cde_Four = FACT.N_Cde_Four
WHERE FACT.N_Fac_Four = @N_Fiche


IF( @Type_Fiche = 115 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( '<IND x="150"> <IMG src="idx:52"> <A href="' + 'mailto:' + ISNULL( I.Internet, '' ) +'">envoyer un email</A>'  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_ITC">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:14"><B>' + ISNULL( I.Titre, '' ) + ' ' +  ISNULL( I.Prenom, '' ) + ' ' + ISNULL( I.Nom_Commercial, '' ) + '<IND x="225">' + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( FO.Fonction, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Ligne directe : ' + ISNULL( I.Tel_Direct, '' ) + '<IND x="225">' + '- Fax : ' + ISNULL( I.Fax_Direct, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
ITC I
LEFT OUTER JOIN FONCTION FO ON FO.N_Fonction = I.N_Fonction
WHERE I.N_ITC = @N_Fiche


IF( @Type_Fiche = 117 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_FCT_BASE">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:8"><B>' + ISNULL( FCT.Nom_Fct_Base, '' ) + '<IND x="225">' + ISNULL( FCT.Ref_Constructeur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- Dernier prix d''achat : ' + ISNULL( CAST( CAST( FCT.Total_HT_General_Euro as numeric( 18, 2 ) ) as varchar(15) ), '' ) + '<IND x="225">' + '- Prix de vente : ' + ISNULL( CAST( CAST( FCT.Prix_Vente_Euro as numeric( 18, 2 ) ) as varchar(15) ), '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Famille : ' + ISNULL( FAM.Designation, '' ) + '<IND x="225">' + '- Marque  : ' + ISNULL( FCT.Marque, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
FCT_BASE FCT
LEFT OUTER JOIN FAMILLE_PRODUIT FAM ON FAM.N_Famille_Produit = FCT.N_Famille_Produit
WHERE FCT.N_Fct_Base = @N_Fiche


IF( @Type_Fiche = 118 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_PRODUIT">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:10"><B>' + ISNULL( P.Nom_Produit, '' ) + '<IND x="225">' + ISNULL( P.Ref_Constructeur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- Dernier prix d''achat : ' + ISNULL( CAST( CAST( P.DernierPrixAchat_Euro as numeric( 18, 2 ) ) as varchar(15) ), '' ) + '<IND x="225">' + '- Prix de vente : ' + ISNULL( CAST( CAST( P.Prix_Vente_Euro as numeric( 18, 2 ) ) as varchar(15) ), '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- Famille : ' + ISNULL( FAM.Designation, '' ) + '<IND x="225">' + '- Marque  : ' + ISNULL( P.Marque, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
PRODUIT P
LEFT OUTER JOIN FAMILLE_PRODUIT FAM ON FAM.N_Famille_Produit = P.N_Famille_Produit
WHERE P.N_Produit = @N_Fiche



IF( @Type_Fiche = 120 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_AFFAIRE">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:11"><B>' + ISNULL( A.Designation, '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ouverte le : ' + ISNULL( convert(varchar(15), A.Date_Ouverture, 103), '' ) + '<IND x="225">' + '- Resp. : ' +  ISNULL( I.Prenom, '' ) + ' ' + ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- fermée le  : ' + ISNULL( convert(varchar(15), A.Date_Fermeture, 103), '' ) + '<IND x="225">' + '- Famille : ' + ISNULL( FAM.Designation, '' ) as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
AFFAIRE A
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = A.N_Client
LEFT OUTER JOIN FAMILLE_AFFAIRE FAM ON FAM.N_Famille_Affaire = A.N_Famille_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = A.N_ITC
WHERE A.N_Affaire = @N_Fiche


IF( @Type_Fiche = 122 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_INVENTAIRE">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:23"><B>' + ISNULL( INV.Nom_Inventaire, '' ) + '<IND x="225">' + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( I.Prenom, '' ) + ' ' + ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), INV.Date_Inventaire, 103 ), '' ) + '<IND x="200">' + '- date de clôture : ' + CONVERT( varchar(15), INV.Date_Cloture, 103 ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
INVENTAIRE INV
LEFT OUTER JOIN ITC I ON I.N_ITC = INV.N_ITC
WHERE INV.N_Inventaire = @N_Fiche



IF( @Type_Fiche = 123 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_DEVIS">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:7"><B>' + ISNULL( D.Nom_Devis, '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + 'créé le : ' + ISNULL( CONVERT( varchar(15), D.Date_Creation, 103 ), '' ) + '<IND x="225">' + '- ' + ISNULL( RES.Resultat, '' ) + ' au ' + ISNULL( CONVERT( varchar(15), D.DateResultat, 103 ), '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- ' + ISNULL( I.Prenom, '' ) + ' ' + ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
DEVIS D
LEFT OUTER JOIN CLIENT CL ON CL.N_Client = D.N_Client
LEFT OUTER JOIN VUE_DEVIS_RESULTATS RES ON RES.N_Resultat = D.Resultat
LEFT OUTER JOIN ITC I ON I.N_ITC = D.N_ITC
WHERE D.N_Devis = @N_Fiche



IF( @Type_Fiche = 127 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_DEMANDE_ACHAT">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:56"><B>' + 'N° ' + ISNULL( CAST( DA.Num_Demande_Achat as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( FO.Nom_Fournisseur, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), DA.Date_Dem, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
DEMANDE_ACHAT DA
LEFT OUTER JOIN FOURNISS FO ON FO.N_Fourniss = DA.N_Four
LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = DA.N_Affaire
LEFT OUTER JOIN ITC I ON I.N_ITC = DA.N_ITC
WHERE DA.N_Demande_Achat = @N_Fiche


IF( @Type_Fiche = 128 )
SELECT 
Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
Msg2 = CAST( ''  as varchar(200) ),
Msg3 = CAST( '<IND x="275"> <IMG src="idx:64"> <A href="detail_fiche_voir_CAMPAGNE">voir la fiche</A> <HR><BR>'  as varchar(200) ),
Msg4 = CAST( '<IMG src="idx:64"><B>' + 'N° ' + ISNULL( CAST( CA.Num_Campagne as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( DEP.Nom_Depot, '' )  + '</B><BR>' as varchar(200) ),
Msg5 = CAST( '- ' + ISNULL( CA.Nom_Campagne, '' ) + '<BR>' as varchar(200) ),
Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), CA.Date_Creation, 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
Msg7 = CAST( '' as varchar(200) ),
Msg8 = CAST( '' as varchar(200) ),
Msg9 = CAST( '' as varchar(200) ),
Msg10 = CAST( '' as varchar(200) ),
Msg11 = CAST( '' as varchar(200) ),
Msg12 = CAST( '' as varchar(200) ),
Msg13 = CAST( '' as varchar(200) ),
Msg14 = CAST( '' as varchar(200) ),
Msg15 = CAST( '' as varchar(200) ),
Msg16 = CAST( '' as varchar(200) ),
Msg17 = CAST( '' as varchar(200) ),
Msg18 = CAST( '' as varchar(200) ),
Msg19 = CAST( '' as varchar(200) ),
Msg20 = CAST( '' as varchar(200) )
FROM
CAMPAGNE CA
LEFT OUTER JOIN DEPOT DEP ON DEP.N_Depot = CA.N_Depot
LEFT OUTER JOIN ITC I ON I.N_ITC = CA.N_ITC
WHERE CA.N_Campagne = @N_Fiche


IF( @Type_Fiche = 130 )
BEGIN
	DECLARE @MoisPivot int

	SET @MoisPivot = ( SELECT CT.Mois_Pivot FROM Categorie_Todo CT LEFT OUTER JOIN DEMANDE_CONGE DC ON DC.TypeConge = CT.N_Categorie_Todo WHERE DC.N_Demande_Conge = @N_Fiche )

	IF ISNULL(@MoisPivot,0) <> 0
	BEGIN
		SELECT 
		Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
		Msg2 = CAST( '<IND x="275"> <IMG src="idx:67"> <A href="detail_fiche_voir_DEMANDE_CONGE">voir la demande</A> <HR>'  as varchar(200) ),
		Msg3 = CAST( '<B>' + ISNULL( dbo.EGX_NumToStr(DC.Quantite,2), '' ) + ' ' + CA.Categorie + '<IND x="160">' + ' Période du : ' + ISNULL( CONVERT( varchar(15), DC.Date_Debut, 103 ), '' )  +  ' au ' + ISNULL( CONVERT( varchar(15), DC.Date_Fin, 103 ), '' ) +  '</B><BR>' as varchar(200) ),
		Msg4 = CASE WHEN DC.Resultat = 2 THEN CAST( '<IND x="150">' + '<FONT color="#1cb44f"><B>ACCEPTEE</B></FONT>'as varchar(200) ) WHEN DC.Resultat = 3 THEN CAST( '<IND x="150">' + '<FONT color="#FF0000"><B>REFUSEE</B></FONT>'as varchar(200) ) ELSE CAST( 'Solde actuel : ' + ISNULL( CAST( C.Solde as varchar(15)), '' ) + '<IND x="160">' as varchar(200) ) END,
		Msg5 = CASE WHEN DC.Resultat = 2 OR DC.Resultat = 3 THEN '' ELSE CASE WHEN C.SoldeSimule >= 0 THEN CAST( '<FONT color="#1cb44f"> Solde simulé : </FONT>' + '<FONT color="#1cb44f">'+ ISNULL( CAST( C.SoldeSimule as varchar(15)), '' ) + '</FONT>' + ' ' + '<IMG src="idx:46">' + '<BR>'   as varchar(200) ) ELSE CAST( '<FONT color="#FF0000"><B> Solde simulé : </B></FONT>' + '<FONT color="#FF0000"><B>'+ISNULL( CAST( C.SoldeSimule as varchar(15)), '' )+ '</B></FONT>' + ' ' + '<IMG src="idx:72">' + '<BR>'   as varchar(200) ) END END,
		Msg6 = CASE WHEN DC.Resultat = 2 OR DC.Resultat = 3 THEN '' ELSE CAST( 'Dernier congé pris : ' + ISNULL(CAST ((SELECT TOP 1 dbo.EGX_NumToStr(D.Quantite,2) FROM DEMANDE_CONGE D LEFT OUTER JOIN ITC I ON I.N_ITC = D.N_ITC WHERE D.N_Demande_Conge <> @N_Fiche AND D.N_ITC = (SELECT N_ITC FROM DEMANDE_CONGE WHERE N_Demande_Conge = @N_Fiche) AND D.Resultat = 2 ORDER BY D.N_Demande_Conge DESC)as varchar(15)),'') as varchar(200) )END,
		Msg7 = CASE WHEN DC.Resultat = 2 OR DC.Resultat = 3 THEN '' ELSE CAST( ' ' + (SELECT CT.Categorie FROM Categorie_Todo CT WHERE N_Categorie_Todo = (SELECT TOP 1 TypeConge FROM DEMANDE_CONGE D WHERE D.N_Demande_Conge <> @N_Fiche AND D.N_ITC = (SELECT N_ITC FROM DEMANDE_CONGE WHERE N_Demande_Conge = @N_Fiche) AND D.Resultat = 2 ORDER BY D.N_Demande_Conge DESC)) as varchar(200) )END,
		Msg8 = CASE WHEN DC.Resultat = 2 OR DC.Resultat = 3 THEN '' ELSE CAST( '<IND x="160">' + ' Période du : ' + (SELECT TOP 1 ISNULL( CONVERT( varchar(15), D.Date_Debut, 103 ), '' ) FROM DEMANDE_CONGE D  WHERE D.N_Demande_Conge <> @N_Fiche AND D.N_ITC = (SELECT N_ITC FROM DEMANDE_CONGE WHERE N_Demande_Conge = @N_Fiche) AND D.Resultat = 2 ORDER BY D.N_Demande_Conge DESC) as varchar(200) )END,
		Msg9 = CASE WHEN DC.Resultat = 2 OR DC.Resultat = 3 THEN '' ELSE CAST( ' au ' + (SELECT TOP 1 ISNULL( CONVERT( varchar(15), D.Date_Fin, 103 ), '' ) FROM DEMANDE_CONGE D  WHERE D.N_Demande_Conge <> @N_Fiche AND D.N_ITC = (SELECT N_ITC FROM DEMANDE_CONGE WHERE N_Demande_Conge = @N_Fiche) AND D.Resultat = 2 ORDER BY D.N_Demande_Conge DESC) as varchar(200) )END,
		Msg10 = CAST( '' as varchar(200) ),
		Msg11 = CAST( '' as varchar(200) ),
		Msg12 = CAST( '' as varchar(200) ),
		Msg13 = CAST( '' as varchar(200) ),
		Msg14 = CAST( '' as varchar(200) ),
		Msg15 = CAST( '' as varchar(200) ),
		Msg16 = CAST( '' as varchar(200) ),
		Msg17 = CAST( '' as varchar(200) ),
		Msg18 = CAST( '' as varchar(200) ),
		Msg19 = CAST( '' as varchar(200) ),
		Msg20 = CAST( '' as varchar(200) )
		FROM
		DEMANDE_CONGE DC
		LEFT OUTER JOIN Categorie_Todo CA ON CA.N_Categorie_Todo = DC.TypeConge
		LEFT OUTER JOIN ITC I ON I.N_ITC = DC.N_ITC
		LEFT OUTER JOIN TB_ITC_COMPTEUR C ON C.N_ITC = I.N_ITC
		WHERE DC.N_Demande_Conge = @N_Fiche AND DC.TypeConge = C.N_Categorie AND DC.Date_Fin BETWEEN C.DateDebut AND C.DateFin
	END
	ELSE
	BEGIN
		SELECT 
		Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
		Msg2 = CAST( '<IND x="275"> <IMG src="idx:67"> <A href="detail_fiche_voir_DEMANDE_CONGE">voir la demande</A> <HR>'  as varchar(200) ),
		Msg3 = CAST( '<B>' + ISNULL( dbo.EGX_NumToStr(DC.Quantite,2), '' ) + ' ' + CA.Categorie + '<IND x="160">' + ' Période du : ' + ISNULL( CONVERT( varchar(15), DC.Date_Debut, 103 ), '' )  +  ' au ' + ISNULL( CONVERT( varchar(15), DC.Date_Fin, 103 ), '' ) +  '</B><BR>' as varchar(200) ),
		Msg4 = CASE WHEN DC.Resultat = 2 THEN CAST( '<IND x="150">' + '<FONT color="#1cb44f"><B>ACCEPTEE</B></FONT>'as varchar(200) ) WHEN DC.Resultat = 3 THEN CAST( '<IND x="150">' + '<FONT color="#FF0000"><B>REFUSEE</B></FONT>' as varchar(200) ) END,
		Msg5 = CAST( '' as varchar(200) ),
		Msg6 = CAST( '' as varchar(200) ),
		Msg7 = CAST( '' as varchar(200) ),
		Msg8 = CAST( '' as varchar(200) ),
		Msg9 = CAST( '' as varchar(200) ),
		Msg10 = CAST( '' as varchar(200) ),
		Msg11 = CAST( '' as varchar(200) ),
		Msg12 = CAST( '' as varchar(200) ),
		Msg13 = CAST( '' as varchar(200) ),
		Msg14 = CAST( '' as varchar(200) ),
		Msg15 = CAST( '' as varchar(200) ),
		Msg16 = CAST( '' as varchar(200) ),
		Msg17 = CAST( '' as varchar(200) ),
		Msg18 = CAST( '' as varchar(200) ),
		Msg19 = CAST( '' as varchar(200) ),
		Msg20 = CAST( '' as varchar(200) )
		FROM
		DEMANDE_CONGE DC
		LEFT OUTER JOIN Categorie_Todo CA ON CA.N_Categorie_Todo = DC.TypeConge
		LEFT OUTER JOIN ITC I ON I.N_ITC = DC.N_ITC
		WHERE DC.N_Demande_Conge = @N_Fiche 
	END
END

IF @Type_Fiche = 132 
BEGIN
    SELECT 
        Msg1 = CAST( '<IMG src="idx:54"><FONT color="#FF0000"><B> Informations :</B></FONT>' as varchar(200) ),
        Msg2 = CAST( ''  as varchar(200) ),
        Msg3 = CAST( '<IND x="275"> <IMG src="idx:53"> <A href="detail_fiche_voir_TB_DAP_DEMANDE_APPRO">voir la fiche</A> <HR><BR>'  as varchar(200) ),
        Msg4 = CAST( '<IMG src="idx:1138"><B>' + 'N° ' + ISNULL( CAST( t.[Num_Demande_Appro] as varchar(15 ) ), '' ) + '<IND x="225">' + ISNULL( CL.Nom_Client, '' )  + '</B><BR>' as varchar(200) ),
        Msg5 = CAST( '- ' + ISNULL( AF.Designation, '' ) + '<BR>' as varchar(200) ),
        Msg6 = CAST( '- en date du : ' + ISNULL( CONVERT( varchar(15), ISNULL(t.[Date_Creation],''), 103 ), '' ) + '<IND x="225">' + ISNULL( I.Prenom, '' ) + ' ' +  ISNULL( I.Nom_Commercial, '' ) + '<BR>' as varchar(200) ),
        Msg7 = CAST( '' as varchar(200) ),
        Msg8 = CAST( '' as varchar(200) ),
        Msg9 = CAST( '' as varchar(200) ),
        Msg10 = CAST( '' as varchar(200) ),
        Msg11 = CAST( '' as varchar(200) ),
        Msg12 = CAST( '' as varchar(200) ),
        Msg13 = CAST( '' as varchar(200) ),
        Msg14 = CAST( '' as varchar(200) ),
        Msg15 = CAST( '' as varchar(200) ),
        Msg16 = CAST( '' as varchar(200) ),
        Msg17 = CAST( '' as varchar(200) ),
        Msg18 = CAST( '' as varchar(200) ),
        Msg19 = CAST( '' as varchar(200) ),
        Msg20 = CAST( '' as varchar(200) )
    FROM [dbo].[TB_DAP_DEMANDE_APPRO] T
    LEFT OUTER JOIN CLIENT CL ON CL.N_Client = t.N_Client
    LEFT OUTER JOIN AFFAIRE AF ON AF.N_Affaire = t.N_Affaire
    LEFT OUTER JOIN ITC I ON I.N_ITC = t.[N_Itc_Demandeur]
    WHERE t.[N_Demande_Appro] = @N_Fiche

END

