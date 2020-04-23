./scripts/start-services.sh
cd /mnt/host/host_mnt/c/6250/data_sample
hive

-- patient 
sudo su - hdfs
hdfs dfs -mkdir -p /input/patient
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2010_Beneficiary_Summary_File_Sample_5.csv /input/patient

-- pde 

sudo su - hdfs
hdfs dfs -mkdir -p /input/pde
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_5.csv /input/pde
hdfs dfs -rmdir  --ignore-fail-on-non-empty /input/pde

--inpatient
sudo su - hdfs
hdfs dfs -mkdir -p /input/inpatient
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2008_to_2010_Inpatient_Claims_Sample_5.csv /input/inpatient

--outpatient
-- hdfs dfs -mkdir -p /input/outpatient
sudo su - hdfs
hdfs dfs -mkdir -p /input/outpatient
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2008_to_2010_Outpatient_Claims_Sample_5.csv /input/outpatient

--DE1_0_2008_to_2010_Carrier_Claims_Sample_5A
sudo su - hdfs
hdfs dfs -mkdir -p /input/carriera
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2008_to_2010_Carrier_Claims_Sample_5A.csv /input/carriera


--DE1_0_2008_to_2010_Carrier_Claims_Sample_5B
sudo su - hdfs
hdfs dfs -mkdir -p /input/carrierb
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put DE1_0_2008_to_2010_Carrier_Claims_Sample_5B.csv /input/carrierb



--Procedure code mapping
sudo su - hdfs

hdfs dfs -rm -r /input/ccs_proc_mapping
hdfs dfs -mkdir -p /input/ccs_proc_mapping
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put ccs_proc_mapping.csv /input/ccs_proc_mapping


--Diagnosis code mapping
sudo su - hdfs
hdfs dfs -rm -r /input/ccs_diag_mapping
hdfs dfs -mkdir -p /input/ccs_diag_mapping
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put ccs_diag_mapping.csv /input/ccs_diag_mapping

--Case Control Mapping
sudo su - hdfs
hdfs dfs -rm -r /input/ccs_diag_mapping
hdfs dfs -mkdir -p /input/ccs_diag_mapping
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put ccs_diag_mapping.csv /input/ccs_diag_mapping




DROP TABLE IF EXISTS patient;
CREATE EXTERNAL TABLE patient (
DESYNPUF_ID STRING,
BENE_BIRTH_DT STRING,
BENE_DEATH_DT STRING,
BENE_SEX_IDENT_CD STRING,
BENE_RACE_CD STRING,
BENE_ESRD_IND STRING,
SP_STATE_CODE STRING,
BENE_COUNTY_CD STRING,
BENE_HI_CVRAGE_TOT_MONS STRING,
BENE_SMI_CVRAGE_TOT_MONS STRING,
BENE_HMO_CVRAGE_TOT_MONS STRING,
PLAN_CVRG_MOS_NUM STRING,
SP_ALZHDMTA STRING,
SP_CHF STRING,
SP_CHRNKIDN STRING,
SP_CNCR STRING,
SP_COPD STRING,
SP_DEPRESSN STRING,
SP_DIABETES STRING,
SP_ISCHMCHT STRING,
SP_OSTEOPRS STRING,
SP_RA_OA STRING,
SP_STRKETIA STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/patient';

DROP TABLE IF EXISTS inpatient;
CREATE EXTERNAL TABLE inpatient (
DESYNPUF_ID STRING,
CLM_ID STRING,
SEGMENT STRING,
CLM_FROM_DT STRING,
CLM_THRU_DT STRING,
PRVDR_NUM STRING,
CLM_PMT_AMT STRING,
NCH_PRMRY_PYR_CLM_PD_AMT STRING,
AT_PHYSN_NPI STRING,
OP_PHYSN_NPI STRING,
OT_PHYSN_NPI STRING,
CLM_ADMSN_DT STRING,
ADMTNG_ICD9_DGNS_CD STRING,
CLM_PASS_THRU_PER_DIEM_AMT STRING,
NCH_BENE_IP_DDCTBL_AMT STRING,
NCH_BENE_PTA_COINSRNC_LBLTY_AM STRING,
NCH_BENE_BLOOD_DDCTBL_LBLTY_AM STRING,
CLM_UTLZTN_DAY_CNT STRING,
NCH_BENE_DSCHRG_DT STRING,
CLM_DRG_CD STRING,
ICD9_DGNS_CD_1 STRING,
ICD9_DGNS_CD_2 STRING,
ICD9_DGNS_CD_3 STRING,
ICD9_DGNS_CD_4 STRING,
ICD9_DGNS_CD_5 STRING,
ICD9_DGNS_CD_6 STRING,
ICD9_DGNS_CD_7 STRING,
ICD9_DGNS_CD_8 STRING,
ICD9_DGNS_CD_9 STRING,
ICD9_DGNS_CD_10 STRING,
ICD9_PRCDR_CD_1 STRING,
ICD9_PRCDR_CD_2 STRING,
ICD9_PRCDR_CD_3 STRING,
ICD9_PRCDR_CD_4 STRING,
ICD9_PRCDR_CD_5 STRING,
ICD9_PRCDR_CD_6 STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/inpatient';

--outpatient
DROP TABLE IF EXISTS outpatient;
CREATE EXTERNAL TABLE outpatient (
DESYNPUF_ID STRING,
CLM_ID STRING,
SEGMENT STRING,
CLM_FROM_DT STRING,
CLM_THRU_DT STRING,
PRVDR_NUM STRING,
CLM_PMT_AMT STRING,
NCH_PRMRY_PYR_CLM_PD_AMT STRING,
AT_PHYSN_NPI STRING,
OP_PHYSN_NPI STRING,
OT_PHYSN_NPI STRING,
NCH_BENE_BLOOD_DDCTBL_LBLTY_AM STRING,
ICD9_DGNS_CD_1 STRING,
ICD9_DGNS_CD_2 STRING,
ICD9_DGNS_CD_3 STRING,
ICD9_DGNS_CD_4 STRING,
ICD9_DGNS_CD_5 STRING,
ICD9_DGNS_CD_6 STRING,
ICD9_DGNS_CD_7 STRING,
ICD9_DGNS_CD_8 STRING,
ICD9_DGNS_CD_9 STRING,
ICD9_DGNS_CD_10 STRING,
ICD9_PRCDR_CD_1 STRING,
ICD9_PRCDR_CD_2 STRING,
ICD9_PRCDR_CD_3 STRING,
ICD9_PRCDR_CD_4 STRING,
ICD9_PRCDR_CD_5 STRING,
ICD9_PRCDR_CD_6 STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/outpatient';


--carriera
DROP TABLE IF EXISTS carriera;
CREATE EXTERNAL TABLE carriera (
DESYNPUF_ID STRING,
CLM_ID STRING,
CLM_FROM_DT STRING,
CLM_THRU_DT STRING,
ICD9_DGNS_CD_1 STRING,
ICD9_DGNS_CD_2 STRING,
ICD9_DGNS_CD_3 STRING,
ICD9_DGNS_CD_4 STRING,
ICD9_DGNS_CD_5 STRING,
ICD9_DGNS_CD_6 STRING,
ICD9_DGNS_CD_7 STRING,
ICD9_DGNS_CD_8 STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/carriera';



--carrierb
DROP TABLE IF EXISTS carrierb;
CREATE EXTERNAL TABLE carrierb (
DESYNPUF_ID STRING,
CLM_ID STRING,
CLM_FROM_DT STRING,
CLM_THRU_DT STRING,
ICD9_DGNS_CD_1 STRING,
ICD9_DGNS_CD_2 STRING,
ICD9_DGNS_CD_3 STRING,
ICD9_DGNS_CD_4 STRING,
ICD9_DGNS_CD_5 STRING,
ICD9_DGNS_CD_6 STRING,
ICD9_DGNS_CD_7 STRING,
ICD9_DGNS_CD_8 STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/carrierb';


--combine carrier
DROP TABLE IF EXISTS carrier;
create table carrier as 
select * from carriera
union
select * from carrierb;



DROP TABLE IF EXISTS ccs_proc_mapping;
CREATE EXTERNAL TABLE ccs_proc_mapping (
ICD9_P STRING,
CCS_P_ORIGIN STRING,
CCS_P STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/ccs_proc_mapping';


DROP TABLE IF EXISTS ccs_diag_mapping;
CREATE EXTERNAL TABLE ccs_diag_mapping (
ICD9_d STRING,
CCS_d STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/ccs_diag_mapping';



--1. Generate diagnostic code 

drop table if exists outpatient_patient_diag;
create table outpatient_patient_diag as 
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_1 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_2 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_3 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_4 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_5 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_6 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_7 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_8 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_9 as diagcode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_10 as diagcode,1 as cnt from outpatient
;

drop table if exists inpatient_patient_diag;
create table inpatient_patient_diag as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_1 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_2 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_3 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_4 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_5 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_6 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_7 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_8 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_9 as diagcode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_10 as diagcode,1 as cnt from inpatient
;

drop table if exists carrier_patient_diag;
create table carrier_patient_diag as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_1 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_2 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_3 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_4 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_5 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_6 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_7 as diagcode,1 as cnt from carrier
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_8 as diagcode,1 as cnt from carrier
;

-- Diagnostic record table 
drop table if exists patient_diag0;
create table patient_diag0 as 
select a.DESYNPUF_ID as patient_id, a.CLM_FROM_DT as claim_date_int
,from_unixtime(unix_timestamp(cast(a.CLM_FROM_DT as string),'yyyymmdd'),'yyyy-mm-dd') as claim_date
, a.diagcode as icd9_diag_code, b.ccs_d as ccs_diag_code from ( 
select * from inpatient_patient_diag
union
select * from carrier_patient_diag
union
select * from outpatient_patient_diag
) a join ccs_diag_mapping b on a.diagcode = b.icd9_d
;
drop table if exists patient_diag;
create table patient_diag as
with base as (
select patient_id, count(distinct claim_date) as usercnt from patient_diag0 group by patient_id
having usercnt>=5
)
select a.* from patient_diag0 a join base b on a.patient_id = b.patient_id;


-- After combination, I deleted three tables to release some memory and make my life easier
-- drop table if exists outpatient_patient_diag;
-- drop table if exists inpatient_patient_diag;
-- drop table if exists carrier_patient_diag;



--2. Generate procedure code 
-- I add 10000 to CCS procedure code to avoid CCS procedure code overlap with CCS diagnosis code
-- I am a genius

drop table if exists inpatient_patient_proc;
create table inpatient_patient_proc as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_1 as proccode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_2 as proccode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_3 as proccode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_4 as proccode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_5 as proccode,1 as cnt from inpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_6 as proccode,1 as cnt from inpatient
;

drop table if exists outpatient_patient_proc;
create table outpatient_patient_proc as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_1 as proccode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_2 as proccode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_3 as proccode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_4 as proccode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_5 as proccode,1 as cnt from outpatient
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_6 as proccode,1 as cnt from outpatient
;


-- Procedure record table
-- Unlike diagnosis, we don't remove less than 5 visits
drop table if exists patient_proc;
create table patient_proc as 
select a.DESYNPUF_ID as patient_id, a.CLM_FROM_DT as claim_date_int
,from_unixtime(unix_timestamp(cast(a.CLM_FROM_DT as string),'yyyymmdd'),'yyyy-mm-dd') as claim_date
, a.proccode as icd9_proc_code, b.ccs_p as ccs_proc_code from ( 
select * from inpatient_patient_proc
union
select * from outpatient_patient_proc
) a join ccs_proc_mapping b on a.proccode = b.icd9_p
;




--3. Combine diagnosis and procedure record
drop table if exists patient_ehr;
create table patient_ehr as
select patient_id, claim_date, ccs_diag_code as code from patient_diag
union
select patient_id, claim_date, ccs_proc_code as code from patient_proc
;

--4. Patient static features
drop table if exists patient_static;
create table patient_static as 
with tmp as (
select distinct DESYNPUF_ID as patient_id, 
from_unixtime(unix_timestamp(cast(BENE_BIRTH_DT as string),'yyyymmdd'),'yyyy-mm-dd') as dob
,case when BENE_SEX_IDENT_CD = 1 then 1 else 0 end as sex
,BENE_RACE_CD as race
,case when BENE_ESRD_IND = "Y" then 1 else 0 end as esrd,
case when SP_ALZHDMTA="2" then 0 else 1 end as SP_ALZHDMTA,
case when SP_CHF="2" then 0 else 1 end as SP_CHF,
case when SP_CHRNKIDN="2" then 0 else 1 end as SP_CHRNKIDN,
case when SP_CNCR="2" then 0 else 1 end as SP_CNCR,
case when SP_COPD="2" then 0 else 1 end as SP_COPD,
case when SP_DEPRESSN="2" then 0 else 1 end as SP_DEPRESSN,
case when SP_ISCHMCHT="2" then 0 else 1 end as SP_ISCHMCHT,
case when SP_OSTEOPRS="2" then 0 else 1 end as SP_OSTEOPRS,
case when SP_RA_OA="2" then 0 else 1 end as SP_RA_OA,
case when SP_STRKETIA="2" then 0 else 1 end as SP_STRKETIA
from patient
)
select *, year("2010-01-01")- year(dob) as age
from tmp
;

-- select percentile(age, 0.75) from patient_static;




--5. Diabete patients pool
drop table if exists case_control_pool;
create table case_control_pool as 
with diabetes as (
select distinct DESYNPUF_ID as patient_id from patient where SP_DIABETES == "1"
union
select DISTINCT patient_id from patient_ehr where code in ("49", "50")
) 
, non_diabetes as (
select distinct a.DESYNPUF_ID as patient_id from patient a left join diabetes b on a.DESYNPUF_ID = b.patient_id
where a.SP_DIABETES == "2" and b.patient_id is null
)
select distinct patient_id, 1 as is_case from diabetes 
union
select distinct patient_id, 0 as is_case from non_diabetes;

-- select is_case, count(distinct patient_id) from case_control_pool group by is_case;
;

--6. Find case patients and their index_date
-- We only select patients firstly diagnosed with diabetes after 2010
drop table if exists case_index;
create table case_index as
select patient_id, min(claim_date) as index_date from (
select patient_id, claim_date from patient_ehr where code in ('49', '50')
) a group by patient_id
having index_date >= "2010-01-01"
;
--4616 cases

--7. Mapping case with control
drop table if exists sample_pool;
create table sample_pool as 
with duration as (
select patient_id, min(claim_date) as fst_date, max(claim_date) as end_date from (
select b.* from case_control_pool a join patient_ehr b on a.patient_id = b.patient_id
) a group by patient_id
)
, base as (
select b.*, a.is_case
from case_control_pool a join patient_static b on a.patient_id = b.patient_id
where a.is_case = 0
union
select b.*, 1 as is_case
from case_index a join patient_static b on a.patient_id = b.patient_id
)
select a.*, b.fst_date, b.end_date
from base a join duration b on a.patient_id=b.patient_id
;

show columns in sample_pool;

--Output
INSERT OVERWRITE LOCAL DIRECTORY 'tmp_samplepool_out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
select * from sample_pool;

-- Use Pymatch package to map each control patients with a case.

-- 8. Map index date

sudo su - hdfs
hdfs dfs -rm -r /input/case_control_mapping
hdfs dfs -mkdir -p /input/case_control_mapping
hdfs dfs -chown -R root /input
exit 
hdfs dfs -put case_control_mapping.csv /input/case_control_mapping

DROP TABLE IF EXISTS case_control_mapping;
CREATE EXTERNAL TABLE case_control_mapping (
control_id STRING,
case_id STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/case_control_mapping';

-- Sample5:For control patients who couldn't find the match, I set the index date as "2010-06-30".
drop table if exists sample_index_date;
create table sample_index_date as
select distinct a.control_id as patient_id, b.index_date, 0 as is_case
from case_control_mapping a join case_index b on a.case_id = b.patient_id
union
select distinct a.patient_id, a.index_date, 1 as is_case from case_index a 
union
select a.patient_id, "2010-06-30" as index_date, 0 as is_case
from sample_static_total a left join case_control_mapping b on a.patient_id = b.control_id
where a.is_case = 0 and b.control_id is null
;

--Check duplicate
select patient_id, index_date,is_case, count(*)
from sample_index_date
group by patient_id, index_date,is_case
having count(*) > 1;

--9. Construct EHR table for our sample patients
-- Here we set the length of observation window!
-- Here sample_index_date only contain patients from sample5
-- Only keep selected sample's ehr
drop table if exists sample_ehr_s5;
create table sample_ehr_s5 as
select a.* 
from patient_ehr a join sample_index_date b on a.patient_id = b.patient_id;

drop table if exists sample_static_s5;
create table sample_static_s5 as
select a.* ,b.is_case
from patient_static a join sample_index_date b on a.patient_id = b.patient_id;

-- Here we found we don't have sufficient number of controls. The desirable ratio is at least 5:1 as of controls to cases, but we got 1.5:1 from one sample
-- So we gotta extract control patients from other sample files. How we process data please see hive_sample4.sql
-- The idea of hive_sample4.sql is equally applicable to sample3 and sample2
 
drop table if exists sample_ehr_total;
create table sample_ehr_total as
select * from sample_ehr_s5
union 
select * from sample_ehr_s4
union 
select * from sample_ehr_s3
union 
select * from sample_ehr_s2
;

drop table if exists sample_static_total;
create table sample_static_total as
select * from sample_static_s5
union 
select * from sample_static_s4
union 
select * from sample_static_s3
union 
select * from sample_static_s2
;


-- Contains index date for patients from all samples: sample 5,4,3,2
drop table if exists sample_index_date_total;
create table sample_index_date_total as
select distinct a.control_id as patient_id, b.index_date, 0 as is_case
from case_control_mapping a join case_index b on a.case_id = b.patient_id
union
select distinct a.patient_id, a.index_date, 1 as is_case from case_index a 
union
select a.patient_id, "2010-06-30" as index_date, 0 as is_case
from sample_static_total a left join case_control_mapping b on a.patient_id = b.control_id
where a.is_case = 0 and b.control_id is null
;

select is_case, count(distinct patient_id) from sample_index_date_total 
group by is_case;


-------------------------------------------------------------------------------------------------
-- Below this line, patients were treated equally regardless of which sample they belong to
--------------------------------------------------------------
drop table if exists ehr_observation;
create table ehr_observation as
select a.patient_id, a.claim_date, a.code, b.is_case
from sample_ehr_total a join sample_index_date_total b on a.patient_id = b.patient_id
where a.claim_date between date_sub(b.index_date, 180) and date_sub(b.index_date, 1)
;

-- Number clinical record
drop table if exists code_order;
create table code_order as 
select a.code, row_number() over(order by a.code) as code_r from (select distinct code from ehr_observation s) a
;

-- 10. Design matrix

drop table if exists dynamic_feature_matrix;
create table  dynamic_feature_matrix as 
with date_order as (
select patient_id, claim_date , row_number() over(partition by a.patient_id order by a.claim_date) as r 
from (select distinct patient_id, claim_date from ehr_observation) a
)
, date2num as (
select a.patient_id,  b.r, a.code,a.is_case
from ehr_observation a join date_order b on a.patient_id = b.patient_id and a.claim_date = b.claim_date
sort by a.patient_id, b.r, a.code
)
select a.patient_id,  a.r, b.code_r
from date2num a join code_order b on a.code =  b.code
sort by a.patient_id,  a.r, b.code_r
;

-- select * from dynamic_feature_matrix where patient_id in ("E8F1BC712849875D", "F441570F52DCBF77");

-- !!! Do not INCLUDE is_case in TASTE!!!
drop table if exists static_feature_matrix;
create table static_feature_matrix as
with tmp as (
select a.patient_id, sex, race,age, esrd
,sp_alzhdmta,sp_chf,sp_chrnkidn,sp_cncr,sp_copd,sp_depressn,sp_ischmcht,sp_osteoprs,sp_ra_oa,sp_strketia
,b.is_case
from sample_static_total a join (select distinct patient_id, is_case from ehr_observation) b on a.patient_id = b.patient_id
)
select distinct a.patient_id, sex
,case when race = 1 then 1 else 0 end as race_white
, case when race = 2 then 1 else 0 end as race_black
, case when race = 3 then 1 else 0 end as race_others
, case when race = 5 then 1 else 0 end as race_hispanic
, age
,esrd
,sp_alzhdmta,sp_chf,sp_chrnkidn,sp_cncr,sp_copd,sp_depressn,sp_ischmcht,sp_osteoprs,sp_ra_oa,sp_strketia
, case when age <= 68 then 1 else 0 end as leq68
, case when age >68 and age<= 74 then 1 else 0 end as leq74
, case when age > 74 and age<= 82 then 1 else 0 end as leq82
, case when age>82 then 1 else 0 end as geq82
,is_case
from tmp a sort by patient_id
;


select is_case, count(distinct patient_id) from static_feature_matrix group by is_case;
select * from dynamic_feature_matrix where patient_id in ("000D5502EDFE0C5F", "00318FDAD0C97726");
-- select leq68, leq74, leq82, geq82,count(distinct patient_id) from static_feature_matrix group by  leq68, leq74, leq82,geq82;

-- 11. Output
set hive.resultset.use.unique.column.names=false;
INSERT OVERWRITE LOCAL DIRECTORY 'static_matrix_out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
select patient_id,sex,race_white,race_black,race_others,race_hispanic,esrd,sp_alzhdmta,sp_chf,sp_chrnkidn,sp_cncr,sp_copd,sp_depressn,sp_ischmcht,sp_osteoprs,sp_ra_oa,sp_strketia,leq68,leq74,leq82,geq82,is_case
from static_feature_matrix
sort by patient_id;

set hive.cli.print.header=true;
INSERT OVERWRITE LOCAL DIRECTORY 'dynamic_matrix_out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
select patient_id, r, code_r from dynamic_feature_matrix sort by patient_id, r, code_r
;

select count(distinct patient_id) from dynamic_feature_matrix;
select count(distinct patient_id) from static_feature_matrix;


--------------------------------------------------------------------------------------------------------
--Change observation window length


-- 12. Change time unit
-- The idea is to change the time unit from date to week. Changes were made from step9 to step10, and in step11 I saved the file to different paths
-- 12.9 Observation
drop table if exists ehr_observation_weekly;
create table ehr_observation_weekly as
select a.patient_id, a.claim_date, a.code, b.is_case, int(datediff(a.claim_date, "2008-01-01")/7) as weeknum
from sample_ehr_total a join sample_index_date_total b on a.patient_id = b.patient_id
where a.claim_date between date_sub(b.index_date, 720) and date_sub(b.index_date, 1)
;

--12.10 Number clinical record
-- drop table if exists code_order_weekly;
-- create table code_order_weekly as 
-- select a.code, row_number() over(order by a.code) as code_r from (select distinct code from ehr_observation_weekly s) a
-- ;

drop table if exists dynamic_feature_matrix_weekly;
create table dynamic_feature_matrix_weekly as 
with week_order as (
select patient_id, weeknum , row_number() over(partition by a.patient_id order by a.weeknum) as r 
from (select distinct patient_id, weeknum from ehr_observation_weekly) a
)
, date2num as (
select a.patient_id,  b.r, a.code,a.is_case
from ehr_observation_weekly a join week_order b on a.patient_id = b.patient_id and a.weeknum = b.weeknum
sort by a.patient_id, b.r, a.code
)
select a.patient_id,  a.r, b.code_r
from date2num a join code_order b on a.code =  b.code
sort by a.patient_id,  a.r, b.code_r
;


-- -- !!! Do not INCLUDE is_case in TASTE!!!
-- drop table if exists static_feature_matrix_weekly;
-- create table static_feature_matrix_weekly as
-- with tmp as (
-- select a.patient_id, sex, race,age, esrd
-- ,sp_alzhdmta,sp_chf,sp_chrnkidn,sp_cncr,sp_copd,sp_depressn,sp_ischmcht,sp_osteoprs,sp_ra_oa,sp_strketia
-- ,b.is_case
-- from sample_static_total a join (select distinct patient_id, is_case from dynamic_feature_matrix_weekly) b on a.patient_id = b.patient_id
-- )
-- select distinct a.patient_id, sex
-- ,case when race = 1 then 1 else 0 end as race_white
-- , case when race = 2 then 1 else 0 end as race_black
-- , case when race = 3 then 1 else 0 end as race_others
-- , case when race = 5 then 1 else 0 end as race_hispanic
-- , age
-- ,esrd
-- ,sp_alzhdmta,sp_chf,sp_chrnkidn,sp_cncr,sp_copd,sp_depressn,sp_ischmcht,sp_osteoprs,sp_ra_oa,sp_strketia
-- , case when age <= 68 then 1 else 0 end as leq68
-- , case when age >68 and age<= 74 then 1 else 0 end as leq74
-- , case when age > 74 and age<= 82 then 1 else 0 end as leq82
-- , case when age>82 then 1 else 0 end as geq82
-- ,is_case
-- from tmp a sort by patient_id
-- ;




select count(distinct patient_id) from dynamic_feature_matrix_weekly;
select count(distinct patient_id) from dynamic_feature_matrix;
select is_case, count(distinct patient_id) from static_feature_matrix group by is_case;


select * from dynamic_feature_matrix_weekly where patient_id = "000A7207FF59E5E5";
select * from dynamic_feature_matrix where patient_id = "000A7207FF59E5E5";
select * from ehr_observation_weekly where  patient_id = "000A7207FF59E5E5" sort by claim_date;


-- 12.11. Output
-- set hive.resultset.use.unique.column.names=false;
-- INSERT OVERWRITE LOCAL DIRECTORY 'static_matrix_out_weekly'
-- ROW FORMAT DELIMITED
-- FIELDS TERMINATED BY ','
-- STORED AS TEXTFILE
-- select * from static_feature_matrix;

set hive.cli.print.header=true;
INSERT OVERWRITE LOCAL DIRECTORY 'dynamic_matrix_out_weekly'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
select * from dynamic_feature_matrix_weekly
sort by patient_id, r, code_r;
