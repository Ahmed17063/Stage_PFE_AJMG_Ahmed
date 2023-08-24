Drop procedure if exists calcul_sfj_part;
DELIMITER $
CREATE PROCEDURE calcul_sfj_part()
	BEGIN
		Declare current_sfj float(12,2);
		Declare max_id bigint;
		Declare compteur bigint default 1;
		Declare current_compte bigint;
        Declare current_decouvert int default 0;
        Declare current_depassement int default 0;
        Declare compteur_decouvert int default 0;
        Declare compteur_depassement int default 0;
		
		Declare id_v1 bigint;
		Declare compte_v1 bigint;
		Declare COPRO_v1 int;
		Declare date_val_v1 date;
		Declare summontant_v1 float(12,2);
		Declare Auto_decouv_v1 float(12,2);
		Declare SFM_v1 float(12,2);
		Declare SFJ_v1 float(12,2);
		Declare NBJ_v1 int;
		Declare Decouvert_v1 int(1);
		Declare Decouvert_id_v1 float(12,2);
        Declare Depassement_v1 int(1);
        Declare Depassement_id_v1 float (12,2);
		
		declare curseur1 cursor for select * 
		from mvts_jours_part; -- table de travail
        
        Select SFM INTO current_sfj
		from mvts_jours_part
		where id=1;
		
		Select count(*) INTO max_id
		from mvts_jours_part;
		
		Select compte INTO current_compte
		from mvts_jours_part
		where id=1;
        
        
        
        open curseur1;
		
		While compteur < max_id DO
			
			fetch curseur1 into id_v1, compte_v1, COPRO_v1, date_val_v1, summontant_v1, Auto_decouv_v1, SFM_v1, SFJ_v1, NBJ_v1, Decouvert_v1, Decouvert_id_v1, Depassement_v1, Depassement_id_v1;
			-- on met à jour la valeur du solde fin de jour
				if compte_v1 = current_compte then
					set SFJ_v1 = current_SFJ;
                    set current_sfj = current_sfj-summontant_v1;
				
                else
					set current_compte = compte_v1;
                    set current_sfj = SFM_v1-summontant_v1;
                    set SFJ_v1 = SFM_v1;
                    set compteur_decouvert = 0;
                    set compteur_depassement = 0;
                    set Decouvert_id_v1 = compteur_decouvert;
                    set Depassement_id_v1 = compteur_depassement;
				
                end if;
                
			-- on met à jour l'état du compte (découvert, dépassement)
				set Decouvert_v1 = Case
									When SFJ_v1 < 0 then 1
								    Else 0
								End;
				set Depassement_v1 = Case
									When SFJ_v1 < -Auto_decouv_v1 *1000 then 1
									Else 0
								End;
				
				if compte_v1 = current_compte then
					if Decouvert_v1 <> current_decouvert then set Compteur_decouvert = Compteur_decouvert + 1;
                    end if;
					if depassement_v1 <> current_depassement then set Compteur_depassement = Compteur_depassement + 1;
					End if;
                    set Decouvert_id_v1 = Compteur_decouvert;
                    set Depassement_id_v1 = Compteur_depassement;
                end if;
            
            set current_decouvert = Decouvert_v1;
            set current_depassement = Depassement_v1;
			set compteur = compteur + 1;
            insert into mvts_jours_part2 value (id_v1, compte_v1, COPRO_v1, date_val_v1, summontant_v1, Auto_decouv_v1, SFM_v1, SFJ_v1, NBJ_v1, Decouvert_v1, Decouvert_id_v1, Depassement_v1, Depassement_id_v1);
		
		END WHILE;
        
        close curseur1;

	END $
	