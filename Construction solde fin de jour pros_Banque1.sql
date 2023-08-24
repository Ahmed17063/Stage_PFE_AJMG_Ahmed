drop table if exists inter_1;
create table `inter_1` (
`compte` bigint,
`COPRO` int,
`date_val` date, 
`summontant` float(12,2)
) engine=myisam default charset=utf8;
create index ref_cpte on inter_1 (compte);

INSERT INTO inter_1 (compte, COPRO, date_val, summontant)
SELECT COCO, COPRO, date_valeur, sum(Montant)
FROM tj81 
where date_valeur>'2021-03-31' and date_valeur < '2021-07-01' and COPRO= 162
GROUP BY COCO, date_valeur;

-- table intermédiaire pour s'assurer que les dates des 1ers de chaque mois sont présentes dans la table
drop table if exists inter_2;
create table `inter_2` (
`compte` bigint,
`COPRO` int,
`montant` float(12,2)
) engine=myisam default charset=utf8;
create index idx_cpte on inter_2 (compte);

drop table if exists `3dates`;
create table `3dates`(`date_valeur` date)
engine=myisam default charset=utf8;

insert into `3dates` (`date_valeur`)
Values 
('2021-04-01'), 
('2021-05-01'), 
('2021-06-01');

insert into inter_2 (compte ,COPRO)
select distinct compte, COPRO
from inter_1;

drop table if exists inter_3;
Create table inter_3 as 
Select * 
from inter_2
CROSS JOIN `3dates`;

create index idx_cpte on inter_3 (compte);

UPDATE inter_3 a
inner join inter_1 b
on a.compte = b.compte and a.date_valeur = b.date_val
SET a.montant = b.summontant;

UPDATE inter_3 a
inner join inter_1 b
on a.compte = b.compte and a.date_valeur = b.date_val
SET a.COPRO = b.COPRO;

delete from inter_3 where montant is not null;

update inter_3 
set montant = 0;

insert into inter_1 (compte, COPRO, date_val, summontant)
select compte, COPRO, date_valeur, montant
from inter_3;

-- table de solde fin de jour
drop table if exists mvts_jours_pros;
CREATE TABLE `mvts_jours_pros` (
`id` bigint auto_increment primary key,
`compte` bigint,
`COPRO` int,
`date_val` date,
`summontant` float(12,2),
`Auto_decouv` float(12,2),
`SFM` float(12,2),
`SFJ` float(12,2),
`NBJ` int,
`Decouvert` int(1),
`Decouvert_id` int,
`depassement` int(1),
`Depassement_id` int
)  ENGINE=myisam DEFAULT CHARSET=utf8;
create index idx_cpte on mvts_jours_pros (compte, date_val);
create index idx_cpte2 on mvts_jours_pros (compte, id);
create index idx_cpte3 on mvts_jours_pros (compte);

INSERT INTO mvts_jours_pros (compte, COPRO, date_val, summontant)
SELECT compte, COPRO, date_val, summontant
FROM inter_1 
order by compte, date_val desc;

-- update solde fin de trimestre
update mvts_jours_pros
set SFM = (select max(MSVAFP)
		   from tq2i a
		   where nucoi=compte);

-- update NBJ
UPDATE mvts_jours_pros as A   
INNER JOIN mvts_jours_pros as B 
on(A.compte=B.compte and A.id-1=B.id)
SET A.NBJ=datediff(B.date_val,A.date_val);

UPDATE mvts_jours_pros
SET NBJ=datediff('2021-07-01',date_val)
WHERE NBJ is null;

-- update autorisation avec d'abord autorisation_complexe (table retraité pour les comptes avec des chgts d'autorisation au cours du mois. 
update mvts_jours_pros a
inner join autorisation_complexe b
on (a.compte = b.nucoi and a.date_val = b.dat)
set Auto_decouv =  b.mnt_auto
where auto_decouv is null;

-- même chose pour les compte ou c'est moins complexe
update mvts_jours_pros a
inner join autorisation b
on (a.compte = b.nucoi and a.date_val between b.DDVALE and b.DFVALE)
set Auto_decouv =  b.MTAUCA
where auto_decouv is null;

update mvts_jours_pros
set auto_decouv=0
where auto_decouv is null;

-- script qui changer la table pour mettre la solde fin de mois

drop table if exists mvts_jours_pros2;
Create table mvts_jours_pros2 like mvts_jours_pros;
-- 5400 sec
call calcul_sfj_pros(); -- la procédure qui remplit la table comme il se doit.

-- table de synthèse 

drop table if exists synthese_decouvert_pros;
CREATE TABLE `synthese_decouvert_pros` (
`compte` bigint,
`COPRO` int,
`NBJ dec avril` int,
`NBJ dec mai` int,
`NBJ dec juin` int,
`NBJ dec trim` int,
`NBJCdec max` int,
`NBJ dep avril` int,
`NBJ dep mai` int,
`NBJ dep juin` int,
`NBJ dep trim` int,
`NBJCdep max` int
)  ENGINE=myisam DEFAULT CHARSET=utf8;
create index idx_cpte on synthese_decouvert_pros (compte);

INSERT INTO synthese_decouvert_pros (compte, COPRO,`NBJ dec avril`, `NBJ dec mai`, `NBJ dec juin`, `NBJ dec trim`, `NBJ dep avril`, `NBJ dep mai`, `NBJ dep juin`, `NBJ dep trim`)
SELECT distinct compte, COPRO,
sum(CASE
		When decouvert=1 and date_val between '2021-04-01' and '2021-04-31' then NBJ
        Else 0
	END),
sum(CASE 
		When decouvert=1 and date_val between '2021-05-01' and '2021-05-31' then NBJ
        Else 0
	END),
    sum(CASE 
		When decouvert=1 and date_val between '2021-06-01' and '2021-06-31' then NBJ
        Else 0
	END),
sum(CASE 
		When decouvert=1 then NBJ
        Else 0
	END),
sum(CASE 
		When depassement = 1 and date_val between '2021-04-01' and '2021-04-31' then NBJ
        Else 0
	END),
sum(CASE 
		When depassement = 1 and date_val between '2021-05-01' and '2021-05-31' then NBJ
        Else 0
	END),
sum(CASE 
		When depassement = 1 and date_val between '2021-06-01' and '2021-06-31' then NBJ
        Else 0
	END),
sum(CASE 
		When depassement = 1 then NBJ
        Else 0
	END)
FROM mvts_jours_pros2
Group by compte, copro;

-- Remplir les colonnes NBJCdec max et NBJCdep max (pour çça on utilise les decouvert et depassement_id a travers des tables intermédiaires
-- decouvert
drop table if exists inter1;
Create table inter1 as Select compte, sum(NBJ) as periode from mvts_jours_pros2 where decouvert = 1 group by compte, Decouvert_id; 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax from inter1 group by compte; 
create index idx_cpte on inter2 (compte);

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec max` = b.dureeMax;

update `synthese_decouvert_pros`
set `NBJCdec max` = 0
where `NBJCdec max` is null;

-- découvert durée max avrillet, mai, juinembre
drop table if exists inter1;
Create table inter1 as Select compte,  MONTH(date_val) as mois, sum(NBJ) as periode from mvts_jours_pros2 where decouvert = 1 group by compte, Decouvert_id, MONTH(date_val); 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax, mois from inter1 group by compte, mois; 
create index idx_cpte on inter2 (compte);
 
ALTER table synthese_decouvert_pros
ADD column `NBJCdec_max_04` int after `NBJ dec avril`;

ALTER table synthese_decouvert_pros
ADD column `NBJCdec_max_05` int after `NBJ dec mai`;

ALTER table synthese_decouvert_pros
ADD column `NBJCdec_max_06` int after `NBJ dec juin`;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_04` = b.dureeMax
where b.mois = 4;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_05` = b.dureeMax
where b.mois = 5;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_06` = b.dureeMax
where b.mois = 6;

update `synthese_decouvert_pros`
set `NBJCdec_max_04` = 0
where `NBJCdec_max_04` is null;
update `synthese_decouvert_pros`
set `NBJCdec_max_05` = 0
where `NBJCdec_max_05` is null;
update `synthese_decouvert_pros`
set `NBJCdec_max_06` = 0
where `NBJCdec_max_06` is null;

-- depassement
drop table if exists inter1;
Create table inter1 as Select compte, sum(NBJ) as periode from mvts_jours_pros2 where depassement = 1 group by compte, depassement_id; 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax from inter1 group by compte; 
create index idx_cpte on inter2 (compte);

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep max` = b.dureeMax;

update synthese_decouvert_pros
set `NBJCdep max` = 0
where `NBJCdep max` is null;

-- dépassement durée max avrillet, mai, juinembre
drop table if exists inter1;
Create table inter1 as Select compte,  MONTH(date_val) as mois, sum(NBJ) as periode from mvts_jours_pros2 where depassement = 1 group by compte, depassement_id, MONTH(date_val); 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax, mois from inter1 group by compte, mois; 
create index idx_cpte on inter2 (compte);
 
ALTER table synthese_decouvert_pros
ADD column `NBJCdep_max_04` int after `NBJ dep avril`;

ALTER table synthese_decouvert_pros
ADD column `NBJCdep_max_05` int after `NBJ dep mai`;

ALTER table synthese_decouvert_pros
ADD column `NBJCdep_max_06` int after `NBJ dep juin`;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_04` = b.dureeMax
where b.mois = 4;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_05` = b.dureeMax
where b.mois = 5;

Update `synthese_decouvert_pros` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_06` = b.dureeMax
where b.mois = 6;

update `synthese_decouvert_pros`
set `NBJCdep_max_04` = 0
where `NBJCdep_max_04` is null;
update `synthese_decouvert_pros`
set `NBJCdep_max_05` = 0
where `NBJCdep_max_05` is null;
update `synthese_decouvert_pros`
set `NBJCdep_max_06` = 0
where `NBJCdep_max_06` is null;

-- ajout de colonne QCNJDB de la TQ2I pour vérifier qu'on est sur les bons ordres de grandeurs en nombres de jours débiteurs.

ALTER table synthese_decouvert_pros
ADD column QCNJDB int;

UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.QCNJDB=b.QCNJDB;

-- Ajout Autorisation
ALTER table synthese_decouvert_pros
ADD column Auto float(10,2);

UPDATE synthese_decouvert_pros a
inner join mvts_jours_pros2 b
on a.compte=b.compte
set a.auto=b.Auto_decouv;

-- Ajouter CTARC
ALTER table synthese_decouvert_pros
ADD column CTARC varchar(1);

UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.CTARC=b.CTARC;

-- Ajout Intérêt débiteur
ALTER table synthese_decouvert_pros
ADD column MINDB float(12,2);

UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.MINDB=b.MINDB;


-- verif

Select count(*) from synthese_decouvert_pros where `NBJ dec trim` between  QCNJDB-3 and QCNJDB+3 and  `NBJ dec trim`>0;
Select count(*) from synthese_decouvert_pros where `NBJ dec trim` not between  QCNJDB-3 and QCNJDB+3 and  `NBJ dec trim`>0;
Select count(*) from synthese_decouvert_pros where `NBJ dec trim` = 0; 

Select * from synthese_decouvert_pros where `NBJ dec trim` <> QCNJDB and  `NBJ dec trim`>0;

