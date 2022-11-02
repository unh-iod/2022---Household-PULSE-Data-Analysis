********************************************************************/
* NIOSH WSH (PAR-20-312) Project - Household PULSE Data Analysis
* Data: HPS data phase 3.1-3.5 (week 28-48)
* Task#1: Essential work settings - counts 06/20/2022 ~
* Task#2: Shot by EW 8/22/2022 ~
* By: Liu Yang
********************************************************************

********************************************************************
* Table of Contents
* 1. Read data folders;

********************************************************************/

* 1. Read data folders;
libname HPS_temp 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\'; /*my folder for temp datasets*/

* Phase 3.1;

libname PULSE28 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\28\';
libname PULSE29 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\29\';
libname PULSE30 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\30\';
libname PULSE31 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\31\';
libname PULSE32 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\32\';
libname PULSE33 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\33\';  

* Phase 3.2;
libname PULSE34 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\34\';
libname PULSE35 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\35\';
libname PULSE36 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\36\';
libname PULSE37 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\37\';
libname PULSE38 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\38\';
libname PULSE39 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\39\';  

* Phase 3.3;
libname PULSE40 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\40\';
libname PULSE41 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\41\';
libname PULSE42 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\42\';

* Phase 3.4;
libname PULSE43 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\43\';
libname PULSE44 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\44\';
libname PULSE45 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\45\'; 

* Phase 3.5;
libname PULSE46 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\46\';
libname PULSE47 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\47\';
libname PULSE48 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\48\'; 

* Phase 3.6;

*libname PULSE49 'C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\Data\SAS\49\'; 

* Datasets to work folder;
proc datasets library = hps_temp;
	copy out= work in= hps_temp;
run;

* Datasets save to temp folder;
proc datasets library = work;
	copy out= hps_temp in= work;
run;

* 2. Clean and prepare data;
* Use Macro Loop here;

* 2.1 Read data using Macro;
* 2.1.1 Read data %macro pulse_data_read;
* Year 2021 and week 28-40 vs year 2022 and week 41-45;
%macro pulse_data_read (week1, week2); 
%do wk = &week1. %to &week2.;
  %if &wk. <41 %then %let yr=2021;	
  %else %let yr=2022;

/* Read main data; */
data main;
	set pulse&wk..pulse&yr._puf_&wk.;
run;

proc sort data=main;
   	by SCRAM;
run;

/* Read weigths data; */
data wgt;
	set pulse&wk..pulse&yr._repwgt_puf_&wk.;
run;

proc sort data=wgt;
   	by SCRAM;
run;

* 2.1.2 Merge main and weights data;
data week&wk.;
	merge main wgt;
	by SCRAM;

	* 2.1.2.1 Add variables in different phases to make sure all variables included;
	if week in (28:33) then do; *Phase 3.1;
		EGENID_BIRTH= .; 
		PHASE= "Phase 3.1";
	end;

	if week in (34:39) then do; *Phase 3.2;
		EGENDER = .;
		PHASE = "Phase 3.2";
	end;

	if week in (40:42) then do; *Phase 3.3;
		EGENDER = .;
		PHASE = "Phase 3.3";
	end;

	if week in (43:45) then do; *Phase 3.4;
		EGENDER = .;
		PHASE = "Phase 3.4";		
	end;

	if week in (46:48) then do; *Phase 3.5;
		EGENDER = .;		
		PHASE = "Phase 3.5";
	end;

	* 2.1.2.2 Keep only variables needed;
	keep	SCRAM 
		    week
			/*Demographics*/
		    TBIRTH_YEAR 
		    EGENDER /*Used in phase3.1*/
			EGENID_BIRTH /*Used in phase3.2+*/
			RHISPANIC
			RRACE
			EEDUC
			/*Disability*/
			seeing
			hearing
			remembering
			mobility
			/*Employment*/
			anywork			
			wkvol
			setting
			/*Vaccination*/
			RECVDVACC
			
			/*Location related*/
			region
			est_st			
			/*Weights*/
			PWEIGHT
			Hweight 
			PWEIGHT1-PWEIGHT80;
run;

%end;
%mend pulse_data_read;

options mprint;
%pulse_data_read (28,48);


* 2.2 Clean data and create new variables - independent variables - Macro pulse_var_ind;
%macro pulse_var_ind (week1, week2);
%do wk = &week1. %to &week2.;
data week&wk.;
	set week&wk.;

	* 2.2.1 General demographics: age, gender, hisp_race, educ;
	* 2.2.1.1 Age group;

	* For 2021 (Wk28-40) data;
	if 28 le week le 40 then do;
		if 2001 le TBIRTH_YEAR le 2003 then agegroup1 = 1;   *ages 18 to 20;
		if 1972 le TBIRTH_YEAR le 2000 then agegroup1 = 2;   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1971 then agegroup1 = 3;   *ages 50+;
		if 2001 le TBIRTH_YEAR le 2003 then lbl_agegroup1 = "ages 18 to 20";   *ages 18 to 20;
		if 1972 le TBIRTH_YEAR le 2000 then lbl_agegroup1 = "ages 21 to 49";   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1971 then lbl_agegroup1 = "ages 50+";   *ages 50+;
	end;

	* For 2022 (Wk41+) data;
	if week >= 41 then do;
		if 2002 le TBIRTH_YEAR le 2004 then agegroup1 = 1;   *ages 18 to 20;
		if 1973 le TBIRTH_YEAR le 2001 then agegroup1 = 2;   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1972 then agegroup1 = 3;   *ages 50+;
		if 2002 le TBIRTH_YEAR le 2004 then lbl_agegroup1 = "ages 18 to 20";   *ages 18 to 20;
		if 1973 le TBIRTH_YEAR le 2001 then lbl_agegroup1 = "ages 21 to 49";   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1972 then lbl_agegroup1 = "ages 50+";   *ages 50+;
		else agegroup1=agegroup1;
	end;

	* 2.2.1.2 Gender;
	* For phase 3.1 (week 28-33) data; 
	if 28 le week le 33 then do;
		if EGENDER = 2 then female = 1; else female = 0;
	end;
	
	* For phase 3.2-3.4 (week >=34) data;
	if week >= 34 then do;
		if EGENID_BIRTH = 2 then female = 1; else female = 0;
	end;

	* 2.2.1.3 Hisp and Race;
	if RHISPANIC = 2               then hisprace = 1; /*Hispanic*/
	if RHISPANIC = 1 and RRACE = 1 then hisprace = 2; /*White,alone*/
	if RHISPANIC = 1 and RRACE = 2 then hisprace = 3; /*Black alone*/
	if RHISPANIC = 1 and RRACE = 3 then hisprace = 4; /*Asian alone*/
	if RHISPANIC = 1 and RRACE = 4 then hisprace = 5; /*Any other race alone, or race in combination*/

	if RHISPANIC = 2               then lbl_hisprace = "Hispanic"; 
	if RHISPANIC = 1 and RRACE = 1 then lbl_hisprace = "White,alone"; 
	if RHISPANIC = 1 and RRACE = 2 then lbl_hisprace = "Black alone"; 
	if RHISPANIC = 1 and RRACE = 3 then lbl_hisprace = "Asian alone"; 
	if RHISPANIC = 1 and RRACE = 4 then lbl_hisprace = "Any other race alone, or race in combination";

	* 2.2.1.4 Education;
	if EEDUC in (1,2) then educ = 1; /*Less than high school*/
	if EEDUC in (3)   then educ = 2; /*High school*/
   	if EEDUC in (4,5) then educ = 3; /*Some college*/
   	if EEDUC in (6,7) then educ = 4; /*College*/

	if EEDUC in (1,2) then lbl_educ = "Less than high school"; 
	if EEDUC in (3)   then lbl_educ = "High school"; 
   	if EEDUC in (4,5) then lbl_educ = "Some college"; 
   	if EEDUC in (6,7) then lbl_educ = "College";

	* 2.2.2 Disability status;
	* 2.2.2.2 Make disability grouping - based on original data;
	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then disability = 1;
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then disability = .;
	else disability = 0;

	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then lbl_disability = "With Disability";
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then lbl_disability = "Missing Data";
	else lbl_disability = "Without Disability";

* 2.2.3.3 Make work and setting new variables;
* Use 3 existing variables: anywork & wkvol & setting;
data week&wk.;
	set week&wk.;

	* 2.2.3.3.1 New variables for original data;
	* Create work status variable: wrkstatus;
	if anywork = 1                                   then wrkstatus = 1; * working for pay;
	if anywork = 2 AND wkvol = 1                     then wrkstatus = 2; * volunteering outside;
	if anywork = 2 AND wkvol ne 1                    then wrkstatus = 3; * Not working;
	if anywork in (-99, .m) AND wkvol = 1            then wrkstatus = 2; * volunteering outside;
	if anywork in (-99, .m) AND wkvol = 2            then wrkstatus = 3; * Not working;
	if anywork in (-99, .m) AND wkvol in (-99, .m)   then wrkstatus = 4; * Missing working info;

	if anywork = 1                                   then lbl_wrkstatus = "working for pay"; * working for pay;
	If anywork = 2 AND wkvol = 1                     then lbl_wrkstatus = "volunteering outside"; * volunteering outside;
	If anywork = 2 AND wkvol ne 1                    then lbl_wrkstatus = "Not working"; * Not working;
	If anywork in (-99, .m) AND wkvol = 1            then lbl_wrkstatus = "volunteering outside"; * volunteering outside;
	If anywork in (-99, .m) AND wkvol = 2            then lbl_wrkstatus = "Not working"; * ;
	If anywork in (-99, .m) AND wkvol in (-99, .m)   then lbl_wrkstatus = "Missing working info"; * Missing working info;

	* Create work location variable: wrklctn;
	if wrkstatus = 1 AND wkvol = 2                   then wrklctn = 1; * working at home;
	if wrkstatus = 1 AND wkvol = 1                   then wrklctn = 2; * working outside;
	if wrkstatus = 1 AND wkvol in (-99, .m)          then wrklctn = 3; * missing working loction info;


	if wrkstatus = 1 AND wkvol = 2                   then lbl_wrklctn = "working at home"; * working at home;
	if wrkstatus = 1 AND wkvol = 1                   then lbl_wrklctn = "working outside"; * working outside;
	if wrkstatus = 1 AND wkvol in (-99, .m)          then lbl_wrklctn = "missing working loction info"; * missing working loction info;
	
	* create work setting variable: EWrk;
	if 28 <= week <= 33 then do; 
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,7)          then ewrk = 1; * Health care;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (3:5)            then ewrk = 2; * Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (6,8:15)         then ewrk = 3; * Non-Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (16)             then ewrk = 4; * Not in essential work setting;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (-99, .m)        then ewrk = 5; * Missing work setting information;
	end;

	if 28 <= week <= 33 then do; 
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,7)          then lbl_ewrk = "Health care"; * Health care;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (3:5)            then lbl_ewrk = "Education"; * Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (6,8:15)         then lbl_ewrk = "Non-Education"; * Non-Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (16)             then lbl_ewrk = "Not in essential work setting"; * Not in essential work setting;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (-99, .m)        then lbl_ewrk = "Missing work setting information"; * Missing work setting information;
	end;

	if 34 <= week <= 48 then do; 
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,3,4,5,10)   then ewrk = 1; * Health care;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (6,7,8)          then ewrk = 2; * Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (9,11:18)        then ewrk = 3; * Non-Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (19)             then ewrk = 4; * Not in essential work setting;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (-99, .m)        then ewrk = 5; * Missing work setting information;
	end;

	if 34 <= week <= 48 then do; 
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,3,4,5,10)   then lbl_ewrk = "Health care"; * Health care;
		if wkvol = 1 AND wrkstatus = 1 and setting in (6,7,8)          then lbl_ewrk = "Education"; * Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (9,11:18)        then lbl_ewrk = "Non-Education"; * Non-Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (19)             then lbl_ewrk = "Not in essential work setting"; * Not in essential work setting;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (-99, .m)        then lbl_ewrk = "Missing work setting information"; * Missing work setting information;
	end;

	* Make an all-in-one variable: allewgrp;
	if wrkstatus = 1 AND wrklctn = 1              then allewgrp = 1;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 1 then allewgrp = 2;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 2 then allewgrp = 3;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 3 then allewgrp = 4;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4 then allewgrp = 5;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 5 then allewgrp = 6;
	if wrkstatus = 1 AND wrklctn = 3              then allewgrp = 7;
	if wrkstatus = 2 AND ewrk = 1                 then allewgrp = 8;
	if wrkstatus = 2 AND ewrk = 2                 then allewgrp = 9;
	if wrkstatus = 2 AND ewrk = 3                 then allewgrp = 10;
	if wrkstatus = 2 AND ewrk = 4                 then allewgrp = 11;
	if wrkstatus = 2 AND ewrk = 5                 then allewgrp = 12;
	if wrkstatus = 3                              then allewgrp = 13;
	if wrkstatus = 4                              then allewgrp = 14;

	* Make an all-in-one variable#2-lump volunteering together: allewgrp2;
	if wrkstatus = 1 AND wrklctn = 1              then allewgrp2 = 1;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 1 then allewgrp2 = 2;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 2 then allewgrp2 = 3;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 3 then allewgrp2 = 4;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4 then allewgrp2 = 5;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 5 then allewgrp2 = 6;
	if wrkstatus = 1 AND wrklctn = 3              then allewgrp2 = 7;	
	if wrkstatus = 2                              then allewgrp2 = 8;
	if wrkstatus = 3                              then allewgrp2 = 9;
	if wrkstatus = 4                              then allewgrp2 = 10;

	* Make new variable: ewgrp1 - focusing on working for payment pop;
	if wrkstatus = 1 AND wrklctn = 1              	   then ewgrp1 = 3; *work inside home for payment;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk in (1:3) then ewgrp1 = 1; *work EW for payment;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4	   then ewgrp1 = 2; *work Non-EW for payment;

	* Make new variable: ewgrp2 - Compare working outside vs. be at home (working/not working);
	if wrkstatus = 1 AND wrklctn = 1              	   then ewgrp2 = 2; *Inside home;
	if wrkstatus = 1 AND wrklctn = 2 				   then ewgrp2 = 1; *Outside home;
	if wrkstatus = 2  								   then ewgrp2 = 1; *Outside home;
	if wrkstatus = 3  								   then ewgrp2 = 2; *Inside home;

%end;
%mend pulse_var_ind;

%pulse_var_ind(28,48);

* 2.3 Dependent variables - use macro pulse_var_dep;
* 2.3.1 Shot-Received at least one shot;
%macro pulse_var_dep(week1, week2);
  %do wk = &week1. %to &week2.;

data week&wk.;
	set week&wk.;
	if RECVDVACC = 1   then shot = 1;
    if RECVDVACC = 2   then shot = 0;
	if RECVDVACC = -99 then shot = .; *question seen but not answered;
	if RECVDVACC = .m  then shot = .; *missing value;
run;

%end;
%mend pulse_var_dep;

* Run macro codes;
%pulse_var_dep(28,48);


* 2.4 Combine datasets;
* 2.4.1 Append data;
%macro Append(week1,week2);
%do wk = &week1. %to &week2.;
proc append base=week_all data=week&wk. force;
run;
%end;
%mend Append;

* Run macro codes;
%Append(28,48);

* 2.4.2 Save data for Stata analysis;
data ew_subset;
	set week_all;
	keep 
		SCRAM 
		week 
		female 
		agegroup1 
		hisprace 
		educ 
		wrkstatus 
		wrklctn 
		ewrk
		disability
		shot
		Region
		lbl_ewrk 
		lbl_wrklctn 
		lbl_wrkstatus 
		lbl_disability 
		lbl_educ 
		lbl_hisprace 
		lbl_agegroup1;
run;
 
Proc export data=ew_subset outfile='C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\PULSE_week_all.csv' dbms=csv replace;
run;

* 3 Calculate counts by essential work and settings;
data week_all_2149;
	set week_all (where= (agegroup1 = 2));
	run;

proc SQL;
	create table tbl1 as (
	select 
		week,
		lbl_wrkstatus,
		lbl_wrklctn,
		lbl_ewrk,
		count(distinct(SCRAM)) as count
	from week_all_2149
	where 
		lbl_wrklctn is not null and
		lbl_ewrk is not null
	group by 
		week,
		lbl_wrkstatus,
		lbl_wrklctn,
		lbl_ewrk
	union
	select 
		week,
		lbl_wrkstatus,
		lbl_wrklctn,
		'total' as lbl_ewrk,
		count(distinct(SCRAM)) as count
	from week_all_2149
	where 
		lbl_wrklctn is not null
	group by 
		week,
		lbl_wrkstatus,
		lbl_wrklctn
	union
	select 
		week,
		lbl_wrkstatus,
		'total' as lbl_wrklctn,
		'total' as lbl_ewrk,
		count(distinct(SCRAM))  as count
	from week_all_2149
	group by 
		week,
		lbl_wrkstatus
	union
	select 
		week,
		'total' as lbl_wrkstatus,
		'total' as lbl_wrklctn,
		'total' as lbl_ewrk,
		count(distinct(SCRAM))  as count
	from week_all_2149
	group by 
		week
)
	; quit;

proc print data=tbl1; 
run;

* 4 Calculate population size;
* 4.1 EW count for each week -  - use macro: EW_count;

%macro EW_count(week1, week2);
%do week=&week1. %to &week2.;

* Only age 21-49;
* 3.2.1 For original data (Get sample size & population size); 
* 3.2.1.1 Get sample size;
* Get working for pay in total;
proc freq data = week&week.; where week=&week. & agegroup1=2; table week*wrkstatus /missing noprint out=wrkstatus_week&week.; run;

proc export 
	data = wrkstatus_week&week.
	outfile="C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\wrkstatus_week&week."
	dbms = xlsx 
	replace;
run;

%end;
%mend EW_count;

* Repeat to get results;
%EW_count(28,48);
