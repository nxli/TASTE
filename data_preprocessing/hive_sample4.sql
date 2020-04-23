./scripts/start-services.sh
cd /mnt/host/host_mnt/c/6250/data_sample
hive

-- patient 
sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/patient
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2010_Beneficiary_Summary_File_Sample_4.csv /input_s4/patient

-- pde 

sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/pde
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_4.csv /input_s4/pde
hdfs dfs -rmdir  --ignore-fail-on-non-empty /input_s4/pde

--inpatient
sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/inpatient
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2008_to_2010_Inpatient_Claims_Sample_4.csv /input_s4/inpatient

--outpatient
-- hdfs dfs -mkdir -p /input_s4/outpatient
sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/outpatient
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2008_to_2010_Outpatient_Claims_Sample_4.csv /input_s4/outpatient

--DE1_0_2008_to_2010_Carrier_Claims_Sample_4A
sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/carriera
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2008_to_2010_Carrier_Claims_Sample_4A.csv /input_s4/carriera


--DE1_0_2008_to_2010_Carrier_Claims_Sample_4B
sudo su - hdfs
hdfs dfs -mkdir -p /input_s4/carrierb
hdfs dfs -chown -R root /input_s4
exit 
hdfs dfs -put DE1_0_2008_to_2010_Carrier_Claims_Sample_4B.csv /input_s4/carrierb



--Procedure code mapping
-- sudo su - hdfs

-- hdfs dfs -rm -r /input_s4/ccs_proc_mapping
-- hdfs dfs -mkdir -p /input_s4/ccs_proc_mapping
-- hdfs dfs -chown -R root /input_s4
-- exit 
-- hdfs dfs -put ccs_proc_mapping.csv /input_s4/ccs_proc_mapping


-- --Diagnosis code mapping
-- sudo su - hdfs
-- hdfs dfs -rm -r /input_s4/ccs_diag_mapping
-- hdfs dfs -mkdir -p /input_s4/ccs_diag_mapping
-- hdfs dfs -chown -R root /input_s4
-- exit 
-- hdfs dfs -put ccs_diag_mapping.csv /input_s4/ccs_diag_mapping

-- --Case Control Mapping
-- sudo su - hdfs
-- hdfs dfs -rm -r /input_s4/ccs_diag_mapping
-- hdfs dfs -mkdir -p /input_s4/ccs_diag_mapping
-- hdfs dfs -chown -R root /input_s4
-- exit 
-- hdfs dfs -put ccs_diag_mapping.csv /input_s4/ccs_diag_mapping




DROP TABLE IF EXISTS patient_s4;
CREATE EXTERNAL TABLE patient_s4 (
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
LOCATION '/input_s4/patient';

DROP TABLE IF EXISTS inpatient_s4;
CREATE EXTERNAL TABLE inpatient_s4 (
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
LOCATION '/input_s4/inpatient';

--outpatient
DROP TABLE IF EXISTS outpatient_s4;
CREATE EXTERNAL TABLE outpatient_s4 (
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
LOCATION '/input_s4/outpatient';


--carriera
DROP TABLE IF EXISTS carriera_s4;
CREATE EXTERNAL TABLE carriera_s4 (
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
LOCATION '/input_s4/carriera';



--carrierb
DROP TABLE IF EXISTS carrierb_s4;
CREATE EXTERNAL TABLE carrierb_s4 (
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
LOCATION '/input_s4/carrierb';


--combine carrier
DROP TABLE IF EXISTS carrier_s4;
create table carrier_s4 as 
select * from carriera_s4
union
select * from carrierb_s4;

drop table if exists carrierb_s4;
drop table if exists carriera_s4;


-- DROP TABLE IF EXISTS ccs_proc_mapping;
-- CREATE EXTERNAL TABLE ccs_proc_mapping (
-- ICD9_P STRING,
-- CCS_P_ORIGIN STRING,
-- CCS_P STRING
  -- )
-- ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
-- STORED AS TEXTFILE
-- LOCATION '/input_s4/ccs_proc_mapping';


-- DROP TABLE IF EXISTS ccs_diag_mapping;
-- CREATE EXTERNAL TABLE ccs_diag_mapping (
-- ICD9_d STRING,
-- CCS_d STRING
  -- )
-- ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
-- STORED AS TEXTFILE
-- LOCATION '/input_s4/ccs_diag_mapping';



--1. Generate diagnostic code 

drop table if exists outpatient_patient_diag_s4;
create table outpatient_patient_diag_s4 as 
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_1 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_2 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_3 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_4 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_5 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_6 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_7 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_8 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_9 as diagcode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT,  ICD9_DGNS_CD_10 as diagcode,1 as cnt from outpatient_s4
;

drop table if exists inpatient_patient_diag_s4;
create table inpatient_patient_diag_s4 as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_1 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_2 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_3 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_4 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_5 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_6 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_7 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_8 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_9 as diagcode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_10 as diagcode,1 as cnt from inpatient_s4
;

drop table if exists carrier_patient_diag_s4;
create table carrier_patient_diag_s4 as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_1 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_2 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_3 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_4 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_5 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_6 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_7 as diagcode,1 as cnt from carrier_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_DGNS_CD_8 as diagcode,1 as cnt from carrier_s4
;

-- Diagnostic record table 
drop table if exists patient_diag0_s4;
create table patient_diag0_s4 as 
select a.DESYNPUF_ID as patient_id, a.CLM_FROM_DT as claim_date_int
,from_unixtime(unix_timestamp(cast(a.CLM_FROM_DT as string),'yyyymmdd'),'yyyy-mm-dd') as claim_date
, a.diagcode as icd9_diag_code, b.ccs_d as ccs_diag_code from ( 
select * from inpatient_patient_diag_s4
union
select * from carrier_patient_diag_s4
union
select * from outpatient_patient_diag_s4
) a join ccs_diag_mapping b on a.diagcode = b.icd9_d
;
drop table if exists patient_diag_s4;
create table patient_diag_s4 as
with base as (
select patient_id, count(distinct claim_date) as usercnt from patient_diag0_s4 group by patient_id
having usercnt>=5
)
select a.* from patient_diag0_s4 a join base b on a.patient_id = b.patient_id;


-- After combination, I deleted three tables to release some memory and make my life easier
drop table if exists outpatient_patient_diag_s4;
drop table if exists inpatient_patient_diag_s4;
drop table if exists carrier_patient_diag_s4;



--2. Generate procedure code 
-- I add 10000 to CCS procedure code to avoid CCS procedure code overlap with CCS diagnosis code
-- I am a genius

drop table if exists inpatient_patient_proc_s4;
create table inpatient_patient_proc_s4 as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_1 as proccode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_2 as proccode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_3 as proccode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_4 as proccode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_5 as proccode,1 as cnt from inpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_6 as proccode,1 as cnt from inpatient_s4
;

drop table if exists outpatient_patient_proc_s4;
create table outpatient_patient_proc_s4 as 
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_1 as proccode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_2 as proccode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_3 as proccode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_4 as proccode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_5 as proccode,1 as cnt from outpatient_s4
union
select DESYNPUF_ID, CLM_FROM_DT, ICD9_PRCDR_CD_6 as proccode,1 as cnt from outpatient_s4
;


-- Procedure record table
-- Unlike diagnosis, we don't remove less than 5 visits
drop table if exists patient_proc_s4;
create table patient_proc_s4 as 
select a.DESYNPUF_ID as patient_id, a.CLM_FROM_DT as claim_date_int
,from_unixtime(unix_timestamp(cast(a.CLM_FROM_DT as string),'yyyymmdd'),'yyyy-mm-dd') as claim_date
, a.proccode as icd9_proc_code, b.ccs_p as ccs_proc_code from ( 
select * from inpatient_patient_proc_s4
union
select * from outpatient_patient_proc_s4
) a join ccs_proc_mapping b on a.proccode = b.icd9_p
;



--3. Combine diagnosis and procedure record
drop table if exists patient_ehr_s4;
create table patient_ehr_s4 as
select patient_id, claim_date, ccs_diag_code as code from patient_diag_s4
union
select patient_id, claim_date, ccs_proc_code as code from patient_proc_s4
;

-- After we got patient_ehr, I delete other tables to make my life easier
drop table if exists inpatient_patient_proc_s4;
drop table if exists outpatient_patient_proc_s4;
drop table if exists patient_diag_s4;
drop table if exists patient_proc_s4;



--4. Patient static features
drop table if exists patient_static_s4;
create table patient_static_s4 as 
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
from patient_s4
)
select *, year("2010-01-01")- year(dob) as age
from tmp
;

-- select percentile(age, 0.75) from patient_static_s4;

--5. Diabete patients pool
drop table if exists case_control_pool_s4;
create table case_control_pool_s4 as 
with diabetes as (
select distinct DESYNPUF_ID as patient_id from patient_s4 where SP_DIABETES == "1"
union
select DISTINCT patient_id from patient_ehr_s4 where code in ("49", "50")
) 
, non_diabetes as (
select distinct a.DESYNPUF_ID as patient_id from patient_s4 a left join diabetes b on a.DESYNPUF_ID = b.patient_id
where a.SP_DIABETES == "2" and b.patient_id is null
)
select distinct patient_id, 1 as is_case from diabetes 
union
select distinct patient_id, 0 as is_case from non_diabetes;

-- select is_case, count(distinct patient_id) from case_control_pool_s4 group by is_case;
;

--6. Find case patients and their index_date
-- We only select patients firstly diagnosed with diabetes after 2010
drop table if exists case_index_s4;
create table case_index_s4 as
select patient_id, min(claim_date) as index_date from (
select patient_id, claim_date from patient_ehr_s4 where code in ('49', '50')
) a group by patient_id
having index_date >= "2010-01-01"
;

select count(distinct patient_id) from case_index_s4;

--7. Mapping case with control
drop table if exists sample_pool_s4;
create table sample_pool_s4 as 
with duration as (
select patient_id, min(claim_date) as fst_date, max(claim_date) as end_date from (
select b.* from case_control_pool_s4 a join patient_ehr_s4 b on a.patient_id = b.patient_id
) a group by patient_id
)
, base as (
select b.*, a.is_case
from case_control_pool_s4 a join patient_static_s4 b on a.patient_id = b.patient_id
where a.is_case = 0
union
select b.*, 1 as is_case
from case_index_s4 a join patient_static_s4 b on a.patient_id = b.patient_id
)
select a.*, b.fst_date, b.end_date
from base a join duration b on a.patient_id=b.patient_id
;

show columns in sample_pool_s4;
select is_case, count(distinct patient_id) from sample_pool_s4 group by is_case;


--------------------------------------------------------------------------------------------------------------------
-- After this step, we got the controls. Combine their static and dynamic feature with the previous steps
-- That is patient_ehr_s4 and patient_static_s4

drop table if exists sample_ehr_s4;
create table sample_ehr_s4 as
select a.* 
from patient_ehr_s4 a join sample_pool_s4 b on a.patient_id = b.patient_id
where b.is_case = 0;



drop table if exists sample_static_s4;
create table sample_static_s4 as
select a.* , b.is_case
from patient_static_s4 a join sample_pool_s4 b on a.patient_id = b.patient_id
where b.is_case = 0;


-- "000D5502EDFE0C5F", "00318FDAD0C97726"










