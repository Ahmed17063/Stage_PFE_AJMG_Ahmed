drop table if exists BUPA;
create table `BUPA` (
`compte` bigint,
`COPRO` int,
`COMAX` int,
`Nb URSSAF Avril` int,
`Montant total URSSAF Avril` Float(12,2),
`Nb URSSAF Mai` int,
`Montant total URSSAF Mai` Float(12,2),
`Nb URSSAF Juin` int,
`Montant total URSSAF Juin` Float(12,2),
`Nb mouvement TPE Avril` int,
`Nb mouvement TPE Mai` int,
`Nb mouvement TPE Juin` int,
`Nb LCR Avril` int,
`Nb LCR Mai` int,
`Nb LCR Juin` int,
`Nb Chèques Avril` int,
`Nb Chèques Mai` int,
`Nb Chèques Juin` int,
`nb VSOT Avril` INT, 
`nb VSOT Mai` INT, 
`nb VSOT Juin` INT, 
`NbMvtC Avril` int,
`MntC Avril` int,
`NbMvtC Mai` int,
`MntC Mai` int,
`NbMvtC Juin` int,
`MntC Juin` int,
`NbMvtD Avril` int,
`MntD Avril` int,
`NbMvtD Mai` int,
`MntD Mai` int,
`NbMvtD Juin` int,
`MntD Juin` int,
`SSGMAR` varchar(50) 
) engine=myisam default charset=utf8;
create index compte on BUPA (compte);

INSERT INTO BUPA (Compte, COPRO, COMAX)
SELECT COCO, COPRO, COMAX
From stock_contrat
WHERE COPRO IN (160,159,196,162);

-- URSSAF

ALTER TABLE BUPA
ADD COLUMN `Nb URSSAF Avril` int;

ALTER TABLE BUPA
ADD COLUMN `Nb URSSAF Mai` int;

ALTER TABLE BUPA
ADD COLUMN `Nb URSSAF Juin` int;

ALTER TABLE BUPA
ADD COLUMN `Montant total URSSAF Avril` Float(12,2);

ALTER TABLE BUPA
ADD COLUMN `Montant total URSSAF Mai` Float(12,2);

ALTER TABLE BUPA
ADD COLUMN `Montant total URSSAF Juin` Float(12,2);

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(montant) as montant FROM tj81 where LZOA11 like'%URSSAF%' and LAODC not like '%CESU%' and LAODC not like '%PAJ EMPLOI%' and LAODC not like '%PAJEMPLOI%' and LAODC not like 'SALAIRE%' and LAODC not like 'UR%' and LAODC not like 'REMBT%' 
And MONTH(Date_Operation)=4 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb URSSAF Avril` = b.nb;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Montant total URSSAF Avril` = b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(montant) as montant FROM tj81 where LZOA11 like'%URSSAF%' and LAODC not like '%CESU%' and LAODC not like '%PAJ EMPLOI%' and LAODC not like '%PAJEMPLOI%' and LAODC not like 'SALAIRE%' and LAODC not like 'UR%' and LAODC not like 'REMBT%' 
And MONTH(Date_Operation)=5 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb URSSAF Mai` = b.nb;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Montant total URSSAF Mai` = b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(montant) as montant FROM tj81 where LZOA11 like'%URSSAF%' and LAODC not like '%CESU%' and LAODC not like '%PAJ EMPLOI%' and LAODC not like '%PAJEMPLOI%' and LAODC not like 'SALAIRE%' and LAODC not like 'UR%' and LAODC not like 'REMBT%' 
And MONTH(Date_Operation)=6 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb URSSAF Juin` = b.nb;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Montant total URSSAF Juin` = b.montant;


-- TPE 

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 in ('FRAIS LOCATION TPE', 'VIREMENT SAS TPE 78', 'VIREMENT WEB TPE')
AND MONTH(Date_Operation)=4 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`NB mouvement TPE Avril` = b.nb;

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 in ('FRAIS LOCATION TPE', 'VIREMENT SAS TPE 78', 'VIREMENT WEB TPE')
AND MONTH(Date_Operation)=5 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`NB mouvement TPE Mai` = b.nb;

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 in ('FRAIS LOCATION TPE', 'VIREMENT SAS TPE 78', 'VIREMENT WEB TPE')
AND MONTH(Date_Operation)=6 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`NB mouvement TPE Juin` = b.nb;





-- LCR 
Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 LIKE 'LCR %' AND MONTH(Date_Operation)=4
group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb LCR Avril` = b.nb;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 LIKE 'LCR %' AND MONTH(Date_Operation)=5
group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb LCR Mai` = b.nb;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb FROM tj81 where LZOA11 LIKE 'LCR %' AND MONTH(Date_Operation)=6
group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb LCR Juin` = b.nb;




-- Chèques

Drop table if exists inter;
Create table inter as SELECT coco, sum(left(right(LZOA11, 11),3)) as nbcheques from tj81 where LZOA11 LIKE 'REM CHQ%' 
and MONTH(Date_Operation)=4 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb Chèques Avril` = b.nbcheques;



Drop table if exists inter;
Create table inter as SELECT coco, sum(left(right(LZOA11, 11),3)) as nbcheques from tj81 where LZOA11 LIKE 'REM CHQ%' 
and MONTH(Date_Operation)=5 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb Chèques Mai` = b.nbcheques;


Drop table if exists inter;
Create table inter as SELECT coco, sum(left(right(LZOA11, 11),3)) as nbcheques from tj81 where LZOA11 LIKE 'REM CHQ%' 
and MONTH(Date_Operation)=6 group by COCO;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`Nb Chèques Juin` = b.nbcheques;

-- VSOT

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbVSOT from tj81 where LAODC in ('VIREMENT DE TRESORERIE', 'VIREMENT TRESORERIE', 'Virt tresorerie', 'vir tresorerie')
 AND MONTH(Date_Operation)=4 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.COCO
SET a.`nb VSOT Avril` = b.nbVSOT;


Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbVSOT from tj81 where LAODC in ('VIREMENT DE TRESORERIE', 'VIREMENT TRESORERIE', 'Virt tresorerie', 'vir tresorerie')
 AND MONTH(Date_Operation)=5 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`nb VSOT Mai` = b.nbVSOT;


Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbVSOT from tj81 where LAODC in ('VIREMENT DE TRESORERIE', 'VIREMENT TRESORERIE', 'Virt tresorerie', 'vir tresorerie')
 AND MONTH(Date_Operation)=6 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`nb VSOT Juin` = b.nbVSOT;



-- Nb Mvts créditeurs  et montant total créditeur

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant>0 
AND MONTH(Date_Operation)=4 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtC Avril`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntC Avril`=b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant>0 
AND MONTH(Date_Operation)=5 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtC Mai`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntC Mai`=b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant>0 
AND MONTH(Date_Operation)=6 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtC Juin`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntC Juin`=b.montant;

-- Nb Mvts débiteurs  et montant total débiteurs pour les mois Avril, Mai, Juin

Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant<0 
AND MONTH(Date_Operation)=4 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtD Avril`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntD Avril`=b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant<0 
AND MONTH(Date_Operation)=5 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtD Mai`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntD Mai`=b.montant;



Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nb, sum(Montant) as montant from tj81 where montant<0 
AND MONTH(Date_Operation)=6 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte=b.COCO
set a.`NbMvtD Juin`=b.nb;


UPDATE BUPA a
inner join inter b
on a.compte=b.coco
set a.`MntD Juin`=b.montant;


-- mettre les nulls à 0

UPDATE BUPA
SET `MntD Avril` = 0
WHERE `MntD Avril` is null;

UPDATE BUPA
SET `NbMvtD Avril` = 0
WHERE `NbMvtD Avril` is null;


UPDATE BUPA
SET `MntD Mai` = 0
WHERE `MntD Mai` is null;

UPDATE BUPA
SET `NbMvtD Mai` = 0
WHERE `NbMvtD Mai` is null;


UPDATE BUPA
SET `MntD Juin` = 0
WHERE `MntD Juin` is null;

UPDATE BUPA
SET `NbMvtD Juin` = 0
WHERE `NbMvtD Juin` is null;



UPDATE BUPA
SET `MntC Avril` = 0
WHERE `MntC Avril` is null;

UPDATE BUPA
SET `NbMvtC Avril` = 0
WHERE `NbMvtC Avril` is null;


UPDATE BUPA
SET `MntC Mai` = 0
WHERE `MntC Mai` is null;

UPDATE BUPA
SET `NbMvtC Mai` = 0
WHERE `NbMvtC Mai` is null;


UPDATE BUPA
SET `MntC Juin` = 0
WHERE `MntC Juin` is null;

UPDATE BUPA
SET `NbMvtC Juin` = 0
WHERE `NbMvtC Juin` is null;


UPDATE BUPA
SET `Nb URSSAF Avril` =0
Where `Nb URSSAF Avril` is NULL;

UPDATE BUPA
SET `Montant total URSSAF Avril` =0
Where `Montant total URSSAF Avril` is NULL;

UPDATE BUPA
SET `Nb URSSAF Mai` =0
Where `Nb URSSAF Mai` is NULL;

UPDATE BUPA
SET `Montant total URSSAF Mai` =0
Where `Montant total URSSAF Mai` is NULL;

UPDATE BUPA
SET `Nb URSSAF Juin` =0
Where `Nb URSSAF Juin` is NULL;

UPDATE BUPA
SET `Montant total URSSAF Juin` =0
Where `Montant total URSSAF Juin` is NULL;



UPDATE BUPA
SET `Nb mouvement TPE Avril` =0
Where `Nb mouvement TPE Avril`is NULL;

UPDATE BUPA
SET `Nb mouvement TPE Mai` =0
Where `Nb mouvement TPE Mai`is NULL;

UPDATE BUPA
SET `Nb mouvement TPE Juin` =0
Where `Nb mouvement TPE Juin`is NULL;


UPDATE BUPA
SET `Nb Chèques Avril` =0
Where `Nb Chèques Avril` is NULL;

UPDATE BUPA
SET `Nb Chèques Mai` =0
Where `Nb Chèques Mai` is NULL;

UPDATE BUPA
SET `Nb Chèques Juin` =0
Where `Nb Chèques Juin` is NULL;

UPDATE BUPA
SET `nb VSOT Avril` = 0
Where `nb VSOT Avril` is NULL;

UPDATE BUPA
SET `nb VSOT Mai` = 0
Where `nb VSOT Mai` is NULL;

UPDATE BUPA
SET `nb VSOT Juin` = 0
Where `nb VSOT Juin` is NULL;

UPDATE BUPA
SET `nb LCR Avril` = 0
Where `nb LCR Avril` is NULL;

UPDATE BUPA
SET `nb LCR Mai` = 0
Where `nb LCR Mai` is NULL;

UPDATE BUPA
SET `nb LCR Juin` = 0
Where `nb LCR Juin` is NULL;


              
-- ajout segmentation SSGMAR 


Update BUPA a
inner join TR35 b
on a.comax = b.COMAX
set a.`SSGMAR` = b.`SSGMAR`;
              

-- Ajout comm de mouvement

ALTER TABLE BUPA
ADD COLUMN MTBACC float(10,2);

Update BUPA a
inner join tq2i b
on a.compte = b.nucoi
set a.MTBACC = b.MTBACC;

Update Bupa 
set MTBACC = 0
where MTBACC is NULL;

-- Ajout comm de mouvement

ALTER TABLE BUPA
ADD COLUMN TXC Float(6,6);

Update BUPA a
inner join tq2i b
on a.compte = b.nucoi
set a.TXC = b.TXC;

Update Bupa 
set TXC = 0
where TXC is NULL;

-- Ajout comm de mouvement

ALTER TABLE BUPA
ADD COLUMN MFCOCC float(10,2);

Update BUPA a
inner join tq2i b
on a.compte = b.nucoi
set a.MFCOCC = b.MFCOCC;

Update Bupa 
set MFCOCC = 0
where MFCOCC is NULL;

-- Ajout de l'age du client

ALTER TABLE BUPA
ADD COLUMN age int;

Update BUPA a
inner join tr35 b
on a.COMAX = b.COMAX
set a.age = b.QTAGCL;

Update Bupa 
set age = 0
where age is NULL;

-- Ajout de nombre de la remise et depot d'especes en avril

ALTER TABLE BUPA
ADD COLUMN `nb depot Avril` int;

ALTER TABLE BUPA
ADD COLUMN `montant depot Avril` int;


Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbDepot, sum(Montant) as montantDepot from tj81 where LZOA11 in ('VRST DEPOT AUTOMATE G860', 'VRST DEPOT AUTOMATE G8FB', 'VRST DEPOT AUTOMATE G8FN', 
'VRST DEPOT AUTOMATE G862', 'VRST DEPOT AUTOMATE G861', 'VRST DEPOT AUTOMATE G846', 'VRST DEPOT AUTOMATE G8EP','VRST DEPOT AUTOMATE G8IH',
'VRST DEPOT AUTOMATE G859','VRST DEPOT AUTOMATE G8WK','VRST DEPOT AUTOMATE G8EF')
 AND MONTH(Date_Operation)=4 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`nb depot Avril`= b.nbDepot;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`montant depot Avril`= b.montantDepot;

Update Bupa 
set `nb depot Avril` = 0
where `nb depot Avril` is NULL;

Update Bupa 
set `montant depot Avril` = 0
where `montant depot Avril` is NULL;



-- Ajout de nombre et montant de depot d'especes en Mai

ALTER TABLE BUPA
ADD COLUMN `nb depot Mai` int;

ALTER TABLE BUPA
ADD COLUMN `montant depot Mai` int;


Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbDepot, sum(Montant) as montantDepot from tj81 where LZOA11 in ('VRST DEPOT AUTOMATE G860', 'VRST DEPOT AUTOMATE G8FB', 'VRST DEPOT AUTOMATE G8FN', 
'VRST DEPOT AUTOMATE G862', 'VRST DEPOT AUTOMATE G861', 'VRST DEPOT AUTOMATE G846', 'VRST DEPOT AUTOMATE G8EP','VRST DEPOT AUTOMATE G8IH',
'VRST DEPOT AUTOMATE G859','VRST DEPOT AUTOMATE G8WK','VRST DEPOT AUTOMATE G8EF')
 AND MONTH(Date_Operation)=5 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`nb depot Mai`= b.nbDepot;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`montant depot Mai`= b.montantDepot;

Update Bupa 
set `nb depot Mai` = 0
where `nb depot Mai` is NULL;

Update Bupa 
set `montant depot Mai` = 0
where `montant depot Mai` is NULL;

-- Ajout de nombre et montant de depot d'especes en Juin

ALTER TABLE BUPA
ADD COLUMN `nb depot Juin` int;

ALTER TABLE BUPA
ADD COLUMN `montant depot Juin` int;


Drop table if exists inter;
Create table inter as SELECT coco, count(*) as nbDepot, sum(Montant) as montantDepot from tj81 where LZOA11 in ('VRST DEPOT AUTOMATE G860', 'VRST DEPOT AUTOMATE G8FB', 'VRST DEPOT AUTOMATE G8FN', 
'VRST DEPOT AUTOMATE G862', 'VRST DEPOT AUTOMATE G861', 'VRST DEPOT AUTOMATE G846', 'VRST DEPOT AUTOMATE G8EP','VRST DEPOT AUTOMATE G8IH',
'VRST DEPOT AUTOMATE G859','VRST DEPOT AUTOMATE G8WK','VRST DEPOT AUTOMATE G8EF')
 AND MONTH(Date_Operation)=6 group by coco;

create index idx_cpte on inter (coco);

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`nb depot Juin`= b.nbDepot;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`montant depot Juin`= b.montantDepot;

Update Bupa 
set `nb depot Juin` = 0
where `nb depot Juin` is NULL;

Update Bupa 
set `montant depot Juin` = 0
where `montant depot Juin` is NULL;

-- Ajout du colonne de commission de suivi global

ALTER TABLE BUPA
DROP COLUMN `comm suivi globale`;

ALTER TABLE BUPA
ADD COLUMN `comm suivi globale` float(10,2);

DROP TABLE if exists inter;
CREATE TABLE Inter AS SELECT coco, sum(Montant) AS SommeMontant FROM tj81 WHERE LZOA11 like 'Comm suivi global%' 
AND Date_Operation between '2021-04-01' AND '2021-06-31' GROUP BY COCO;

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`comm suivi globale`= b.SommeMontant;

Update BUPA 
Set `comm suivi globale` =0
WHERE `comm suivi globale` is NULL;

 -- Ajout du colonne de rétrocession de commission de suivi global

ALTER TABLE BUPA 
ADD COLUMN `retrocession comm suivi globale` float(12,2);

 DROP TABLE if exists inter;
CREATE TABLE Inter AS SELECT coco, sum(montant) AS SommeMontant FROM tj81 WHERE LZOA11 like 'Rbsmt comm suivi global%' 
AND Date_Operation between '2021-04-01' AND '2021-06-31' GROUP BY COCO; 

UPDATE BUPA a
inner join inter b
on a.compte = b.coco
SET a.`retrocession comm suivi globale`= b.SommeMontant;


Update BUPA 
Set `retrocession comm suivi globale` =0
WHERE `retrocession comm suivi globale` is NULL;

-- Ajout des colonnes de nbj de découvert et de dépassement

ALTER TABLE BUPA
ADD COLUMN `NBJ dec avril` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dec mai` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dec juin` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dec trim` int;

ALTER TABLE BUPA
ADD COLUMN `NBJCdec max` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dep avril` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dep mai` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dep juin` int;

ALTER TABLE BUPA
ADD COLUMN `NBJ dep trim` int;

ALTER TABLE BUPA
ADD COLUMN `NBJCdep max` int;

ALTER TABLE BUPA
ADD COLUMN QCNJDB int;

ALTER TABLE BUPA
ADD COLUMN Auto float(10,2);

ALTER TABLE BUPA
ADD COLUMN CTARC varchar(1);

ALTER TABLE BUPA
ADD COLUMN MINDB float(12,2);

drop table if exists synthese_decouvert_part;
CREATE TABLE `synthese_decouvert_part` (
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
`NBJCdep max` int,
QCNJDB int,
Auto float(10,2),
CTARC varchar(1),
MINDB float(12,2)
)  ENGINE=myisam DEFAULT CHARSET=utf8;
create index idx_cpte on synthese_decouvert_part (compte);

INSERT INTO synthese_decouvert_part(compte, COPRO,`NBJ dec avril`, `NBJ dec mai`, `NBJ dec juin`, `NBJ dec trim`, `NBJ dep avril`, `NBJ dep mai`, `NBJ dep juin`, `NBJ dep trim`)
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
FROM mvts_jours_part2
Group by compte, copro;

-- Remplir les colonnes NBJCdec max et NBJCdep max (pour ça on utilise les decouvert et depassement_id a travers des tables intermédiaires
-- decouvert
drop table if exists inter1;
Create table inter1 as Select compte, sum(NBJ) as periode from mvts_jours_part2 where decouvert = 1 group by compte, Decouvert_id; 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax from inter1 group by compte; 
create index idx_cpte on inter2 (compte);

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec max` = b.dureeMax;


-- découvert durée max avrillet, mai, juinembre
drop table if exists inter1;
Create table inter1 as Select compte,  MONTH(date_val) as mois, sum(NBJ) as periode from mvts_jours_part2 where decouvert = 1 group by compte, Decouvert_id, MONTH(date_val); 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax, mois from inter1 group by compte, mois; 
create index idx_cpte on inter2 (compte);
 
ALTER table synthese_decouvert_part
ADD column `NBJCdec_max_04` int after `NBJ dec avril`;

ALTER table synthese_decouvert_part
ADD column `NBJCdec_max_05` int after `NBJ dec mai`;

ALTER table synthese_decouvert_part
ADD column `NBJCdec_max_06` int after `NBJ dec juin`;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_04` = b.dureeMax
where b.mois = 4;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_05` = b.dureeMax
where b.mois = 5;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdec_max_06` = b.dureeMax
where b.mois = 6;



-- depassement
drop table if exists inter1;
Create table inter1 as Select compte, sum(NBJ) as periode from mvts_jours_part2 where depassement = 1 group by compte, depassement_id; 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax from inter1 group by compte; 
create index idx_cpte on inter2 (compte);

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep max` = b.dureeMax;



-- dépassement durée max avril, mai, et juin
drop table if exists inter1;
Create table inter1 as Select compte,  MONTH(date_val) as mois, sum(NBJ) as periode from mvts_jours_part2 where depassement = 1 group by compte, depassement_id, MONTH(date_val); 

drop table if exists inter2;
Create table inter2 as Select compte, max(periode) as dureeMax, mois from inter1 group by compte, mois; 
create index idx_cpte on inter2 (compte);
 
ALTER table synthese_decouvert_part
ADD column `NBJCdep_max_04` int after `NBJ dep avril`;

ALTER table synthese_decouvert_part
ADD column `NBJCdep_max_05` int after `NBJ dep mai`;

ALTER table synthese_decouvert_part
ADD column `NBJCdep_max_06` int after `NBJ dep juin`;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_04` = b.dureeMax
where b.mois = 4;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_05` = b.dureeMax
where b.mois = 5;

Update `synthese_decouvert_part` a
inner join inter2 b
on a.compte = b.compte
set a.`NBJCdep_max_06` = b.dureeMax
where b.mois = 6;



-- la colonne QCNJDB de la TQ2I pour vérifier qu'on est sur les bons ordres de grandeurs en nombres de jours débiteurs.
UPDATE synthese_decouvert_part a
inner join TQ2I b
on a.compte=b.nucoi
set a.QCNJDB=b.QCNJDB;

-- Autorisation
UPDATE synthese_decouvert_part a
inner join mvts_jours_part2 b
on a.compte=b.compte
set a.auto=b.Auto_decouv;

-- CTARC

UPDATE synthese_decouvert_part a
inner join TQ2I b
on a.compte=b.nucoi
set a.CTARC=b.CTARC;

--  insertion Intérêt débiteur
UPDATE synthese_decouvert_part a
inner join TQ2I b
on a.compte=b.nucoi
set a.MINDB=b.MINDB;

-- insertion de données de decouvert part dans la table de synthése globale (BUPA)

UPDATE BUPA a
inner join synthese_decouvert_part b
on a.compte = b.compte
SET  a.`NBJ dec avril`=b.`NBJ dec avril`,
a.`NBJ dec mai`=b.`NBJ dec mai`,
a.`NBJ dec juin`=b.`NBJ dec juin`,
a.`NBJ dec trim`=b.`NBJ dec trim`,
a.`NBJCdec max`=b.`NBJCdec max`,
a.`NBJ dep avril`=b.`NBJ dep avril`,
a.`NBJ dep mai`=b.`NBJ dep mai`,
a.`NBJ dep juin`=b.`NBJ dep juin`,
a.`NBJ dep trim`=b.`NBJ dep trim`,
a.`NBJCdep max`=b.`NBJCdep max`,
a.QCNJDB =b.QCNJDB,
a.Auto=b.Auto, 
a.CTARC=b.CTARC,
a.MINDB=b.MINDB;

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
`NBJCdep max` int,
QCNJDB int,
Auto float(10,2),
CTARC varchar(1),
MINDB float(12,2)
)  ENGINE=myisam DEFAULT CHARSET=utf8;
create index idx_cpte on synthese_decouvert_pros (compte);

INSERT INTO synthese_decouvert_pros(compte, COPRO,`NBJ dec avril`, `NBJ dec mai`, `NBJ dec juin`, `NBJ dec trim`, `NBJ dep avril`, `NBJ dep mai`, `NBJ dep juin`, `NBJ dep trim`)
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

-- Remplir les colonnes NBJCdec max et NBJCdep max (pour ça on utilise les decouvert et depassement_id a travers des tables intermédiaires
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



-- dépassement durée max avril, mai, et juin
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



-- la colonne QCNJDB de la TQ2I pour vérifier qu'on est sur les bons ordres de grandeurs en nombres de jours débiteurs.
UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.QCNJDB=b.QCNJDB;

-- Autorisation
UPDATE synthese_decouvert_pros a
inner join mvts_jours_pros2 b
on a.compte=b.compte
set a.auto=b.Auto_decouv;

-- CTARC

UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.CTARC=b.CTARC;

--  insertion Intérêt débiteur
UPDATE synthese_decouvert_pros a
inner join TQ2I b
on a.compte=b.nucoi
set a.MINDB=b.MINDB;

-- insertion de données de decouvert pros dans la table de synthése globale (BUPA)

UPDATE BUPA a
inner join synthese_decouvert_pros b
on a.compte = b.compte
SET  a.`NBJ dec avril`=b.`NBJ dec avril`,
a.`NBJ dec mai`=b.`NBJ dec mai`,
a.`NBJ dec juin`=b.`NBJ dec juin`,
a.`NBJ dec trim`=b.`NBJ dec trim`,
a.`NBJCdec max`=b.`NBJCdec max`,
a.`NBJ dep avril`=b.`NBJ dep avril`,
a.`NBJ dep mai`=b.`NBJ dep mai`,
a.`NBJ dep juin`=b.`NBJ dep juin`,
a.`NBJ dep trim`=b.`NBJ dep trim`,
a.`NBJCdep max`=b.`NBJCdep max`,
a.QCNJDB =b.QCNJDB,
a.Auto=b.Auto, 
a.CTARC=b.CTARC,
a.MINDB=b.MINDB;

-- Ajout du QCCP19 et QCCP21
ALTER TABLE BUPA
ADD COLUMN QCCP19 int(11);

ALTER TABLE BUPA 
ADD COLUMN QCCP21 int(11);

DROP TABLE IF EXISTS inter;

CREATE table inter AS SELECT comax, QCCP19, QCCP21 from tr35;
Create index idx_client on inter(comax);

UPDATE BUPA a
INNER JOIN inter b 
ON a.comax=b.comax
SET a.QCCP19=b.QCCP19,
a.QCCP21=b.QCCP21;

-- La colonne NPAI

ALTER TABLE BUPA
ADD Column NPAI int(1);

Update BUPA a
Inner join npai_2 b
on a.comax=b.`matricule client`
set a.npai=1;

Update Bupa 
Set npai=0
Where npai is null;

-- Vérifications
SELECT count(*) FROM BUPA 
WHERE COPRO IN (159, 160, 196);

Select npai, count(*) From Bupa
group by npai;

SELECT Distinct(SSGMAR) FROM BUPA 
WHERE COPRO =162;

-- Création de table excel Bupa_synthése_PRO

SELECT * FROM BUPA
WHERE COPRO=162 AND
SSGMAR IN ('ASSO', 'COM', 'ART', 'PL', 'AGRI', 'NR', 'AUTRES');

-- Création de table excel Bupa_synthése_PART

SELECT * FROM BUPA
WHERE COPRO IN (159, 160, 196);

SELECT sum(if(copro in (159,160,196),1,0)), sum(if (copro=162,1,0)) FROM BUPA;

SELECT COUNT(distinct(comax)) FROM stock_contrat;


SELECT  SSGMAR, sum(`comm suivi globale`), sum(`retrocession comm suivi globale`), count(*)
FROM BUPA 
WHERE COPRO =162
GROUP BY SSGMAR;

DESCRIBE BUPA;

SELECT * FROM BUPA
LIMIT 100;


