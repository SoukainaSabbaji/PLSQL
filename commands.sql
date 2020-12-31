DECLARE 
v_total NUMBER(6):= 0;
v_year NUMBER(4);
v_count NUMBER(2) ;
BEGIN 
SELECT to_char(DATE_DIFF_COURS,'YYYY') into v_year FROM COURS
GROUP BY to_char(DATE_DIFF_COURS,'YYYY')
HAVING COUNT(*)= (SELECT max(COUNT(*)) from COURS GROUP BY to_char(DATE_DIFF_COURS,'YYYY'));
dbms_output.put_line(v_year);
FOR i IN 1 .. 12 
LOOP
SELECT COUNT(*) INTO v_count 
from COURS where to_char(DATE_DIFF_COURS,'mm') = i 
AND to_char(DATE_DIFF_COURS,'YYYY') = v_year ;
v_total := v_total + v_count;
dbms_output.put_line('In month : '|| i ||' the number of courses uploaded is :'|| v_count);
END LOOP;
dbms_output.put_line('In year :'|| v_year || ' we uploaded :'|| v_total||' courses .');
END;
/


set serveroutput on;
DECLARE
	v_Log_In Utilisateur.Log_In%type;
	v_Password_ Utilisateur.Password_%type;
	v_Type_Utlisateur Utilisateur.Type_Utlisateur%type;
	already_exist EXCEPTION;
	pragma exception_init(already_exist, -1);
BEGIN
	v_Log_In:='&Log_In';
	v_Password_:='&Password_';
	v_Type_Utlisateur:='&Type_Utlisateur';
	INSERT into Utilisateur values(v_Log_In, v_Password_ ,v_Type_Utlisateur);
	dbms_output.put_line(' Utilisateur ajoute ! ');
	EXCEPTION
		WHEN already_exist THEN
			dbms_output.put_line('Cet utilisateur existe deja');
END;
/

DECLARE
CURSOR c_cours_detail IS
   SELECT Num_Cours,Module_Format,Fil_etd
   FROM COURS;
   rec_cours_detail c_cours_detail%ROWTYPE;   
BEGIN
OPEN c_cours_detail;
   LOOP
    FETCH c_cours_detail INTO rec_cours_detail;
    EXIT WHEN c_cours_detail%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(' cours numero: '||' '||rec_cours_detail.Num_Cours ||' est cours de : '||rec_cours_detail.Module_Format||'de la filiere '||rec_cours_detail.Fil_etd);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nombre total des lignes: '||c_cours_detail%ROWCOUNT);    
CLOSE c_cours_detail;
END;
/
DECLARE
v_found NUMBER := 0
CURSOR check_cursor
IS
SELECT Fil_etd
FROM ETUDIANT
BEGIN

set serveroutput on;
DECLARE
	CURSOR etudcursor
	IS
	SELECT Fil_etd
	FROM ETUDIANT;
	v_prenom etudiant.Prenom_etd%type;
	v_nom etudiant.nom_etd%type;
	v_annee etudiant.An_etd%type;
	v_fil etudiant.Fil_etd%type;
	v_Num_insc etudiant.Num_insc%TYPE;
	v_CNE etudiant.CNE%TYPE;
	invalid_entry EXCEPTION;
BEGIN
	v_annee := &An_etd;
	v_prenom := '&Prenom_etd';
	v_nom := '&nom_etd';
	v_fil := '&Fil_etd';
	v_Num_insc := &Num_insc;
	v_CNE := '&CNE';
	FOR etudrec in etudcursor
	LOOP
	IF etudrec.Fil_etd IN ('GI','TM','IDSD','GODT','GE') THEN
		RAISE invalid_entry;
	END IF;
	END LOOP;
	INSERT into etudiant(Prenom_etd, nom_etd, An_etd,Fil_etd,Num_insc,CNE) values(v_prenom,v_nom,v_annee,v_fil,v_Num_insc,v_CNE);
	EXCEPTION
		WHEN invalid_entry THEN
			dbms_output.put_line('--Cette filiere est indisponible--');
END;
/



CREATE TABLE format_temp AS
  SELECT Num_Format, Nom_Format,Module_Format
  FROM FORMAT;
DELETE FROM format_temp;
COMMIT; 

CREATE TABLE format_details_temp(
Numero_formateur NUMBER,
Nom_Formateur varchar2(50)); 

 

DECLARE
    v_Num_Format FORMAT.Num_Format%TYPE;
    v_firstname format.Prenom_Format%TYPE;
    v_lastname  format.Nom_Format%TYPE;
	v_Module Format.Module_Format%TYPE;
	v_fil COURS.Fil_etd%TYPE;	
	
    CURSOR cur_GI IS
     SELECT F.Num_Format, F.Nom_Format ,F.Module_Format, C.Fil_etd FROM FORMAT F INNER JOIN COURS C
ON C.Module_Format=F.Module_Format WHERE C.Fil_etd='GI';
BEGIN
    OPEN cur_GI; 
    LOOP
        FETCH cur_GI INTO v_Num_Format,v_firstname,v_lastname, v_Module;
        EXIT WHEN cur_GI%NOTFOUND;
        INSERT INTO Format_temp
                    (Num_Format,
                     Nom_Format,Module_Format)
        VALUES      (v_Num_Format,
                     v_lastname,
                     'GI');

        INSERT INTO format_details_temp
                   (Numero_formateur,
                     Nom_Formateur)
        VALUES      (v_Num_Format,
                     v_firstname
                     || ' '
                     || v_lastname);
    END LOOP;
    CLOSE cur_GI;
    COMMIT; 
END; 
/
