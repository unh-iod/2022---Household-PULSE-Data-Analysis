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
	end;

	if 28 le week le 40 then do;
		if 2001 le TBIRTH_YEAR le 2003 then lbl_agegroup1 = "ages 18 to 20";   *ages 18 to 20;
		if 1972 le TBIRTH_YEAR le 2000 then lbl_agegroup1 = "ages 21 to 49";   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1971 then lbl_agegroup1 = "ages 50+";   *ages 50+;
	end;

	* For 2022 (Wk41+) data;
	if week >= 41 then do;
		if 2002 le TBIRTH_YEAR le 2004 then agegroup1 = 1;   *ages 18 to 20;
		if 1973 le TBIRTH_YEAR le 2001 then agegroup1 = 2;   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1972 then agegroup1 = 3;   *ages 50+;
	else agegroup1 = agegroup1;
	end;

	if week >= 41 then do;
		if 2002 le TBIRTH_YEAR le 2004 then lbl_agegroup1 = "ages 18 to 20";   *ages 18 to 20;
		if 1973 le TBIRTH_YEAR le 2001 then lbl_agegroup1 = "ages 21 to 49";   *ages 21 to 49;		
		if         TBIRTH_YEAR le 1972 then lbl_agegroup1 = "ages 50+";   *ages 50+;
	else lbl_agegroup1 = lbl_agegroup1;
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
	if seeing in (1, 2) AND  hearing in (1,2) AND remembering in (1,2) AND mobility in (1,2)  then disability = 0;

	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then lbl_disability = "With Disability";
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then lbl_disability = "Missing Data";
	if seeing in (1, 2) AND  hearing in (1,2) AND remembering in (1,2) AND mobility in (1,2)  then lbl_disability = "Without Disability";

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
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,7)          then lbl_ewrk = "Health care                     "; * Health care;
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
		else ewrk=ewrk;
	end;

	if 34 <= week <= 48 then do; 
		if wkvol = 1 AND wrkstatus = 1 AND setting in (1,2,3,4,5,10)   then lbl_ewrk = "Health care                     "; * Health care;
		if wkvol = 1 AND wrkstatus = 1 and setting in (6,7,8)          then lbl_ewrk = "Education"; * Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (9,11:18)        then lbl_ewrk = "Non-Education"; * Non-Education;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (19)             then lbl_ewrk = "Not in essential work setting"; * Not in essential work setting;
		if wkvol = 1 AND wrkstatus = 1 AND setting in (-99, .m)        then lbl_ewrk = "Missing work setting information"; * Missing work setting information;
		else lbl_ewrk=lbl_ewrk;
	end;
	
	**For Population Calculations
	* Make an all-in-one variable: allewgrp_layer2;
	if wrkstatus = 1 AND wrklctn = 1              then allewgrp_layer2 = 1;  *working, inside home;
	if wrkstatus = 1 AND wrklctn = 2 			  then allewgrp_layer2 = 2;  *working, outside home;
	if wrkstatus = 1 AND wrklctn = 3              then allewgrp_layer2 = 7;  *working, missing location info;
	if wrkstatus = 2 							  then allewgrp_layer2 = 8;  *volunteering;
	if wrkstatus = 3                              then allewgrp_layer2 = 13; *not working;
	if wrkstatus = 4                              then allewgrp_layer2 = 14; *missing working info;

	* Make an all-in-one variable: allewgrp_layer3;
	if wrkstatus = 1 AND wrklctn = 1              then allewgrp_layer3 = 1;  *working, inside home;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 1 then allewgrp_layer3 = 2;  *working, outside home, healthcare;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 2 then allewgrp_layer3 = 3;  *working, outside home, education;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 3 then allewgrp_layer3 = 4;  *working, outside home, not education(other);
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4 then allewgrp_layer3 = 5;  *working, outside home, non EW;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 5 then allewgrp_layer3 = 6;  *working, outside home, missing setting information;
	if wrkstatus = 1 AND wrklctn = 3              then allewgrp_layer3 = 7;  *working, missing location info;
	if wrkstatus = 2                              then allewgrp_layer3 = 8;  *volunteering;
	if wrkstatus = 3                              then allewgrp_layer3 = 13; *not working;
	if wrkstatus = 4                              then allewgrp_layer3 = 14; *missing working info;

	* Make an all-in-one variable: allewgrp_layer3_EW;
	if wrkstatus = 1 AND wrklctn = 1                   then allewgrp_layer3_EW = 1;  *working, inside home;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk in (1:3) then allewgrp_layer3_EW = 2;  *working, outside home, EW;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4      then allewgrp_layer3_EW = 5;  *working, outside home, non EW;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 5      then allewgrp_layer3_EW = 6;  *working, outside home, missing setting information;
	if wrkstatus = 1 AND wrklctn = 3                   then allewgrp_layer3_EW = 7;  *working, missing location info;
	if wrkstatus = 2                                   then allewgrp_layer3_EW = 8;  *volunteering;
	if wrkstatus = 3                                   then allewgrp_layer3_EW = 13; *not working;
	if wrkstatus = 4                                   then allewgrp_layer3_EW = 14; *missing working info;
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
data week_all;
	set week28;

%macro Append(week1,week2);
%do wk = &week1. %to &week2.;
proc append base=week_all data=week&wk. force;
run;
%end;
%mend Append;

* Run macro codes;
%Append(29,48);

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
		Region
		lbl_ewrk 
		lbl_wrklctn 
		lbl_wrkstatus 
		lbl_disability 
		lbl_educ 
		lbl_hisprace 
		lbl_agegroup1
		shot;
run;
Proc export data=ew_subset 
	outfile='C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\PULSE_week_all.csv' 
	dbms=csv 
	replace;
run;

* 3 Calculate counts by essential work and settings;
* 3.1 Get sample size in each week;
* Get #sample (total);
proc freq data = week_all; table week/ noprint out=sample_ttl; 
run;
* Get #sample (age21-49);
proc freq data = week_all(where=(agegroup1=2)); table week*agegroup1/ noprint out=table1_adults totpct outpct list ; 
run;
* Initialize table 1 - total sample;
data table1;
	set sample_ttl(drop=percent);
	rename count=total_sample;
run;
* Prepare table1 adults for merge;
data table1_adults;
	set table1_adults(drop= pct_row pct_col percent);
	rename count=count_total_adult_2149;
run;
* Merge adults to table 1;
data table1;
	merge table1 table1_adults;
	by week;
run;
* Add percent working adults;
data table1;
	set table1;
	perc_total_adult_2149 = count_total_adult_2149 / total_sample;
run;
* Working status;
proc freq data = week_all (where=(agegroup1=2)); table week*agegroup1*wrkstatus /missing noprint out=wrkstatus; 
run;
* Shift count wider by wrkstatus;
proc transpose data=wrkstatus out=wrkstatus_count_wide prefix=wrkstatus;
	by week agegroup1;
	id wrkstatus;
	var count;
run;
* Prepare table1 Working status for merge;
data table1_wrkstatus_count_wide;
	set wrkstatus_count_wide(drop= _name_ _label_);
	rename wrkstatus1=count_working_for_pay 
		   wrkstatus2=count_volunteering_outside 
		   wrkstatus3=count_not_working
		   wrkstatus4=count_missing_workstatus;
run;
* Merge working status to table 1;
data table1;
	merge table1 table1_wrkstatus_count_wide;
	by week agegroup1;
run;
* Add percent working adults;
data table1;
	set table1;
	perc_working_for_pay = count_working_for_pay / count_total_adult_2149;
	perc_volunteering_outside = count_volunteering_outside/count_total_adult_2149;
	perc_not_working =  count_not_working/count_total_adult_2149;
	perc_missing_workstatus = count_missing_workstatus/count_total_adult_2149;
run;
* Work location;
proc freq data = week_all (where=(agegroup1=2 and wrkstatus = 1)); table week*agegroup1*wrkstatus*wrklctn /missing noprint out=wrklctn; 
run;
* Shift count wider by wrkstatus;
proc transpose data=wrklctn out=wrklctn_count_wide prefix=wrklctn;
	by week agegroup1;
	id wrklctn;
	var count;
run;
* Prepare table1 Working status for merge;
data table1_wrklctn_count_wide;
	set wrklctn_count_wide(drop= _name_ _label_);
	rename wrklctn1=count_inside_home 
		   wrklctn2=count_outside_home 
		   wrklctn3=count_missing_location;
run;
* Merge working status to table 1;
data table1;
	merge table1 table1_wrklctn_count_wide;
	by week agegroup1;
run;
* Add percent working adults;
data table1;
	set table1;
	perc_inside_home = count_inside_home / count_total_adult_2149;
	perc_outside_home = count_outside_home/count_total_adult_2149;
	perc_missing_location =  count_missing_location/count_total_adult_2149;
run;
* Essential Work status;
proc freq data = week_all (where=(agegroup1=2 and wrkstatus = 1 and wrklctn = 2)); table week*agegroup1*wrkstatus*wrklctn*ewrk /missing noprint out=ewrk; 
run;
* Shift count wider by wrkstatus;
proc transpose data=ewrk out=ewrk_count_wide prefix=ewrk;
	by week agegroup1;
	id ewrk;
	var count;
run;
* Prepare table1 Working status for merge;
data table1_ewrk_count_wide;
	set ewrk_count_wide(drop= _name_ _label_);
	rename ewrk1=count_healthcare
		   ewrk2=count_education
		   ewrk3=count_not_education
		   ewrk4=count_non_EW
		   ewrk5=count_missing_EW;
run;
* Merge working status to table 1;
data table1;
	merge table1 table1_ewrk_count_wide;
	by week agegroup1;
run;
* Add percent working adults;
data table1;
	set table1;
	perc_healthcare = count_healthcare / count_total_adult_2149;
	perc_education = count_education / count_total_adult_2149;
	perc_not_education = count_not_education / count_total_adult_2149;
	perc_non_EW = count_non_EW / count_total_adult_2149;
	perc_missing_EW = count_missing_EW / count_total_adult_2149;
	count_total_EW = count_healthcare + count_education + count_not_education;
	perc_total_EW = count_total_EW / count_total_adult_2149;
run;
* Reorder columns;
data table1;
	retain 	week 
			agegroup1 
			total_sample 
			count_total_adult_2149
			perc_total_adult_2149
			count_working_for_pay
			perc_working_for_pay
			count_inside_home
			perc_inside_home
			count_outside_home
			perc_outside_home
			count_total_EW
			perc_total_EW
			count_healthcare
			perc_healthcare
			count_education
			perc_education
			count_not_education
			perc_not_education
			count_non_EW
			perc_non_EW
			count_missing_EW
			perc_missing_EW
			count_missing_location
			perc_missing_location
			count_volunteering_outside
			perc_volunteering_outside
			count_not_working
			perc_not_working
			count_missing_workstatus
			perc_missing_workstatus;
	set table1;
run;
proc export 
	data = table1 
	outfile="C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\table1"
	dbms = xlsx
	replace; 
run;

* 3.2 Get population size in each week;
proc surveyfreq data=week_all varmethod=BRR(FAY); 
	weight PWEIGHT; 
	repweights PWEIGHT1-PWEIGHT80; 
	table agegroup1;
	ods output oneway=table2_agegroup1; 	
	by week;
run;
* Initialize table 2 - population counts;
data table2;
	set table2_agegroup1(where=(agegroup1=2));
	drop Table F_agegroup1 frequency _skipline;
	rename WgtFreq=count_total_pop
		   StdDev=count_se_total_pop
		   percent=perc_total_pop
		   StdErr=perc_se_total_pop;
run;
*Population size subset by adult split by work status;
proc surveyfreq data=week_all(where=(agegroup1=2)) varmethod=BRR(FAY); 
	weight PWEIGHT; 
	repweights PWEIGHT1-PWEIGHT80; 
	table wrkstatus;
	ods output oneway=table2_wrkstatus_raw;
	by week;	
run;
* Initialize table 2 - wrkstatus;
data table2_wrkstatus;
	set table2_wrkstatus_raw;
	drop Table F_wrkstatus frequency _skipline;
run;
*Shift wider by wrkstatus;
proc transpose data=table2_wrkstatus out=table2_wrkstatus_count_wide prefix=wrkstatus;
	by week;
	id wrkstatus;
	var WgtFreq;
run;
proc transpose data=table2_wrkstatus out=table2_wrkstatus_count_se_wide prefix=wrkstatus;
	by week;
	id wrkstatus;
	var StdDev;
run;
proc transpose data=table2_wrkstatus out=table2_wrkstatus_perc_wide prefix=wrkstatus;
	by week;
	id wrkstatus;
	var Percent;
run;
proc transpose data=table2_wrkstatus out=table2_wrkstatus_perc_se_wide prefix=wrkstatus;
	by week;
	id wrkstatus;
	var StdErr;
run;
* Prepare table2 Working status for merge;
data table2_wrkstatus_count_wide;
	set table2_wrkstatus_count_wide(drop= _name_ _label_);
	rename wrkstatus1=count_working_for_pay 
		   wrkstatus2=count_volunteering_outside 
		   wrkstatus3=count_not_working
		   wrkstatus4=count_missing_workstatus;
run;
data table2_wrkstatus_count_se_wide;
	set table2_wrkstatus_count_se_wide(drop= _name_ _label_);
	rename wrkstatus1=count_se_working_for_pay 
		   wrkstatus2=count_se_volunteering_outside 
		   wrkstatus3=count_se_not_working
		   wrkstatus4=count_se_missing_workstatus;
run;
data table2_wrkstatus_perc_wide;
	set table2_wrkstatus_perc_wide(drop= _name_);
	rename wrkstatus1=perc_working_for_pay 
		   wrkstatus2=perc_volunteering_outside 
		   wrkstatus3=perc_not_working
		   wrkstatus4=perc_missing_workstatus;
run;
data table2_wrkstatus_perc_se_wide;
	set table2_wrkstatus_perc_se_wide(drop= _name_ _label_);
	rename wrkstatus1=perc_se_working_for_pay
		   wrkstatus2=perc_se_volunteering_outside 
		   wrkstatus3=perc_se_not_working
		   wrkstatus4=perc_se_missing_workstatus;
run;
* Merge working status to table 2;
data table2;
	merge table2 
		table2_wrkstatus_count_wide 
		table2_wrkstatus_count_se_wide 
		table2_wrkstatus_perc_wide 
		table2_wrkstatus_perc_se_wide;
	by week;
run;
*Population size subset by adult split by wrklctn;
proc surveyfreq data=week_all(where=(agegroup1=2)) varmethod=BRR(FAY); 
	weight PWEIGHT; 
	repweights PWEIGHT1-PWEIGHT80; 
	table allewgrp_layer2;
	ods output oneway=table2_allewgrp_layer2_raw;
	by week;	
run;
* Initialize table 2 - wrklctn;
data table2_allewgrp_layer2;
	set table2_allewgrp_layer2_raw;
	drop Table F_allewgrp_layer2 frequency _skipline;
run;
*Shift wider by wrkstatus;
proc transpose data=table2_allewgrp_layer2 out=table2_allewgrp_count_wide prefix=allewgrp_layer2;
	by week;
	id allewgrp_layer2;
	var WgtFreq;
run;
proc transpose data=table2_allewgrp_layer2 out=table2_allewgrp_count_se_wide prefix=allewgrp_layer2;
	by week;
	id allewgrp_layer2;
	var StdDev;
run;
proc transpose data=table2_allewgrp_layer2 out=table2_allewgrp_perc_wide prefix=allewgrp_layer2;
	by week;
	id allewgrp_layer2;
	var percent;
run;
proc transpose data=table2_allewgrp_layer2 out=table2_allewgrp_perc_se_wide prefix=allewgrp_layer2;
	by week;
	id allewgrp_layer2;
	var StdErr;
run;
* Prepare table2 Working status for merge;
data table2_allewgrp_count_wide;
	set table2_allewgrp_count_wide(drop= _name_ _label_ allewgrp_layer28 allewgrp_layer213 allewgrp_layer214);
	rename allewgrp_layer21=count_inside_home 
		   allewgrp_layer22=count_outside_home 
		   allewgrp_layer27=count_missing_location;
run;
data table2_allewgrp_count_se_wide;
	set table2_allewgrp_count_se_wide(drop= _name_ _label_ allewgrp_layer28 allewgrp_layer213 allewgrp_layer214);
	rename allewgrp_layer21=count_se_inside_home 
		   allewgrp_layer22=count_se_outside_home 
		   allewgrp_layer27=count_se_missing_location;
run;
data table2_allewgrp_perc_wide;
	set table2_allewgrp_perc_wide(drop= _name_ allewgrp_layer28 allewgrp_layer213 allewgrp_layer214);
	rename allewgrp_layer21=perc_inside_home 
		   allewgrp_layer22=perc_outside_home 
		   allewgrp_layer27=perc_missing_location;
run;
data table2_allewgrp_perc_se_wide;
	set table2_allewgrp_perc_se_wide(drop= _name_ _label_ allewgrp_layer28 allewgrp_layer213 allewgrp_layer214);
	rename allewgrp_layer21=perc_se_inside_home 
		   allewgrp_layer22=perc_se_outside_home 
		   allewgrp_layer27=perc_se_missing_location;
run;
* Merge working location to table 2;
data table2;
	merge table2 
		table2_allewgrp_count_wide 
		table2_allewgrp_count_se_wide 
		table2_allewgrp_perc_wide 
		table2_allewgrp_perc_se_wide;
	by week;
run;
*Population size subset by adult split by work status location and essential work type;
proc surveyfreq data=week_all(where=(agegroup1=2)) varmethod=BRR(FAY); 
	weight PWEIGHT; 
	repweights PWEIGHT1-PWEIGHT80; 
	table allewgrp_layer3;
	ods output oneway=table2_layer3_raw;
	by week;
run;
* Initialize table 2 - wrkstatus;
data table2_layer3;
	set table2_layer3_raw;
	drop Table F_allewgrp_layer3 frequency _skipline;
run;
proc print data=table2_layer3;run;
*Shift wider by essential work type;
proc transpose data=table2_layer3 out=table2_layer3_count_wide prefix=allewgrp_layer3;
	by week;
	id allewgrp_layer3;
	var WgtFreq;
run;
proc transpose data=table2_layer3 out=table2_layer3_count_se_wide prefix=allewgrp_layer3;
	by week;
	id allewgrp_layer3;
	var StdDev;
run;
proc transpose data=table2_layer3 out=table2_layer3_perc_wide prefix=allewgrp_layer3;
	by week;
	id allewgrp_layer3;
	var Percent;
run;
proc transpose data=table2_layer3 out=table2_layer3_perc_se_wide prefix=allewgrp_layer3;
	by week;
	id allewgrp_layer3;
	var StdErr;
run;
* Prepare table2 Working status for merge;
data table2_layer3_count_wide;
	set table2_layer3_count_wide(drop= _name_ _label_ allewgrp_layer31 allewgrp_layer37 allewgrp_layer38 allewgrp_layer313 allewgrp_layer314);
	rename allewgrp_layer32=count_healthcare
		   allewgrp_layer33=count_education
		   allewgrp_layer34=count_not_education
		   allewgrp_layer35=count_non_EW
		   allewgrp_layer36=count_missing_EW;
data table2_layer3_count_se_wide;
	set table2_layer3_count_se_wide(drop= _name_ _label_ allewgrp_layer31 allewgrp_layer37 allewgrp_layer38 allewgrp_layer313 allewgrp_layer314);
	rename allewgrp_layer32=count_se_healthcare
		   allewgrp_layer33=count_se_education
		   allewgrp_layer34=count_se_not_education
		   allewgrp_layer35=count_se_non_EW
		   allewgrp_layer36=count_se_missing_EW;
data table2_layer3_perc_wide;
	set table2_layer3_perc_wide(drop= _name_ allewgrp_layer31 allewgrp_layer37 allewgrp_layer38 allewgrp_layer313 allewgrp_layer314);
	rename allewgrp_layer32=perc_healthcare
		   allewgrp_layer33=perc_education
		   allewgrp_layer34=perc_not_education
		   allewgrp_layer35=perc_non_EW
		   allewgrp_layer36=perc_missing_EW;
data table2_layer3_perc_se_wide;
	set table2_layer3_perc_se_wide(drop= _name_ _label_ allewgrp_layer31 allewgrp_layer37 allewgrp_layer38 allewgrp_layer313 allewgrp_layer314);
	rename allewgrp_layer32=perc_se_healthcare
		   allewgrp_layer33=perc_se_education
		   allewgrp_layer34=perc_se_not_education
		   allewgrp_layer35=perc_se_non_EW
		   allewgrp_layer36=perc_se_missing_EW;
* Merge working status to table 2;
data table2;
	merge table2 
		table2_layer3_count_wide 
		table2_layer3_count_se_wide 
		table2_layer3_perc_wide 
		table2_layer3_perc_se_wide;
	by week;
run;
*Population size subset by adult split by work status location and essential work (no EW type included);
proc surveyfreq data=week_all(where=(agegroup1=2)) varmethod=BRR(FAY); 
	weight PWEIGHT; 
	repweights PWEIGHT1-PWEIGHT80; 
	table allewgrp_layer3_EW;
	ods output oneway=table2_layer3_EW_raw; 
	by week;	
run;
* Initialize table 2 - wrkstatus;
data table2_layer3_EW;
	set table2_layer3_EW_raw;
	drop Table F_allewgrp_layer3_EW frequency _skipline;
run;
*Shift wider by essential work type;
proc transpose data=table2_layer3_EW out=table2_layer3_EW_count_wide prefix=allewgrp_layer3_EW;
	by week;
	id allewgrp_layer3_EW;
	var WgtFreq;
run;
proc transpose data=table2_layer3_EW out=table2_layer3_EW_count_se_wide prefix=allewgrp_layer3_EW;
	by week;
	id allewgrp_layer3_EW;
	var StdDev;
run;
proc transpose data=table2_layer3_EW out=table2_layer3_EW_perc_wide prefix=allewgrp_layer3_EW;
	by week;
	id allewgrp_layer3_EW;
	var Percent;
run;
proc transpose data=table2_layer3_EW out=table2_layer3_EW_perc_se_wide prefix=allewgrp_layer3_EW;
	by week;
	id allewgrp_layer3_EW;
	var StdErr;
run;
* Prepare table2 Working status for merge;
data table2_layer3_EW_count_wide;
	set table2_layer3_EW_count_wide(keep=week allewgrp_layer3_EW2);
	rename allewgrp_layer3_EW2=count_total_EW;
data table2_layer3_EW_count_se_wide;
	set table2_layer3_EW_count_se_wide(keep=week allewgrp_layer3_EW2);
	rename allewgrp_layer3_EW2=count_se_total_EW;
data table2_layer3_EW_perc_wide;
	set table2_layer3_EW_perc_wide(keep=week allewgrp_layer3_EW2);
	rename allewgrp_layer3_EW2=perc_total_EW;
data table2_layer3_EW_perc_se_wide;
	set table2_layer3_EW_perc_se_wide(keep=week allewgrp_layer3_EW2);
	rename allewgrp_layer3_EW2=perc_se_total_EW;
* Merge working status to table 2;
data table2;
	merge table2 
		table2_layer3_EW_count_wide 
		table2_layer3_EW_count_se_wide 
		table2_layer3_EW_perc_wide 
		table2_layer3_EW_perc_se_wide;
	by week;
run;
* Reorder columns;
data table2a;
	retain 	week 
			agegroup1 
			count_total_pop
			perc_total_pop
			count_working_for_pay
			perc_working_for_pay
			count_inside_home
			perc_inside_home
			count_outside_home
			perc_outside_home
			count_total_EW
			perc_total_EW
			count_healthcare
			perc_healthcare
			count_education
			perc_education
			count_not_education
			perc_not_education
			count_non_EW
			perc_non_EW
			count_missing_EW
			perc_missing_EW
			count_missing_location
			perc_missing_location
			count_volunteering_outside
			perc_volunteering_outside
			count_not_working
			perc_not_working
			count_missing_workstatus
			perc_missing_workstatus;
	set table2;
run;
data table2a;
	set table2a;
			perc_total_pop=perc_total_pop/100;
			perc_working_for_pay=perc_working_for_pay/100;
			perc_inside_home=perc_inside_home/100;
			perc_outside_home=perc_outside_home/100;
			perc_total_EW=perc_total_EW/100;
			perc_healthcare=perc_healthcare/100;
			perc_education=perc_education/100;
			perc_not_education=perc_not_education/100;
			perc_non_EW=perc_non_EW/100;
			perc_missing_EW=perc_missing_EW/100;
			perc_missing_location=perc_missing_location/100;
			perc_volunteering_outside=perc_volunteering_outside/100;
			perc_not_working=perc_not_working/100;
			perc_missing_workstatus=perc_missing_workstatus/100;
run;
data table2b;
	retain 	week 
			agegroup1 
			count_se_total_pop
			perc_se_total_pop
			count_se_working_for_pay
			perc_se_working_for_pay
			count_se_inside_home
			perc_se_inside_home
			count_se_outside_home
			perc_se_outside_home
			count_se_total_EW
			perc_se_total_EW
			count_se_healthcare
			perc_se_healthcare
			count_se_education
			perc_se_education
			count_se_not_education
			perc_se_not_education
			count_se_non_EW
			perc_se_non_EW
			count_se_missing_EW
			perc_se_missing_EW
			count_se_missing_location
			perc_se_missing_location
			count_se_volunteering_outside
			perc_se_volunteering_outside
			count_se_not_working
			perc_se_not_working
			count_se_missing_workstatus
			perc_se_missing_workstatus;
	set table2;
run;
data table2b;
	set table2b;
			perc_se_total_pop=perc_se_total_pop/100;
			perc_se_working_for_pay=perc_se_working_for_pay/100;
			perc_se_inside_home=perc_se_inside_home/100;
			perc_se_outside_home=perc_se_outside_home/100;
			perc_se_total_EW=perc_se_total_EW/100;
			perc_se_healthcare=perc_se_healthcare/100;
			perc_se_education=perc_se_education/100;
			perc_se_not_education=perc_se_not_education/100;
			perc_se_non_EW=perc_se_non_EW/100;
			perc_se_missing_EW=perc_se_missing_EW/100;
			perc_se_missing_location=perc_se_missing_location/100;
			perc_se_volunteering_outside=perc_se_volunteering_outside/100;
			perc_se_not_working=perc_se_not_working/100;
			perc_se_missing_workstatus=perc_se_missing_workstatus/100;
run;
proc export 
	data = table2a
	outfile="C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\table2a"
	dbms = xlsx 
	replace;
run;
proc export 
	data = table2b
	outfile="C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\table2b"
	dbms = xlsx 
	replace;
run;
