********************************************************************/
* NIOSH WSH (PAR-20-312) Project - Household PULSE Data Analysis
* Data: HPS data phase 3.1-3.5 (week 28-48)
* By: Nate Thomas
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
			BRAND
			DOSES
			DOSESRV
			NUMDOSES
			BOOSTERRV
			/*Vaccine Reasons (Drill Through)*/
			GETVACRV
			WHYNOT1-WHYNOT11
			WHYNOTV1-WHYNOTV13
			RBOOSTER
			WHYNORV1-WHYNORV13
			WHYNOBSTR1-WHYNOBSTR9
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
	if 28 le week le 33 and EGENDER      = 2 then female = 1; * For phase 3.1 (week 28-33) data; 
	else if       week >= 34 and EGENID_BIRTH = 2 then female = 1; * For phase 3.2-3.4 (week >=34) data;
	else female = 0;
	if 28 le week le 33 and EGENDER      = 2 then lbl_female = "Female"; * For phase 3.1 (week 28-33) data; 
	else if       week >= 34 and EGENID_BIRTH = 2 then lbl_female = "Female"; * For phase 3.2-3.4 (week >=34) data;
	else female = "Male"; 

	* 2.2.1.3 Hisp and Race;
	if RHISPANIC = 2               then hisprace = 1; /*Hispanic*/
	if RHISPANIC = 1 and RRACE = 1 then hisprace = 2; /*White,alone*/
	if RHISPANIC = 1 and RRACE = 2 then hisprace = 3; /*Black alone*/
	if RHISPANIC = 1 and RRACE = 3 then hisprace = 4; /*Asian alone*/
	if RHISPANIC = 1 and RRACE = 4 then hisprace = 5; /*Any other race alone, or race in combination*/

	if RHISPANIC = 2               then lbl_hisprace = "Hispanic                                    "; 
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

	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then lbl_disability =               "With Disability   ";
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then lbl_disability = "Missing Data";
	if seeing in (1, 2) AND  hearing in (1,2) AND remembering in (1,2) AND mobility in (1,2)  then lbl_disability =         "Without Disability";

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

	if anywork = 1                                   then lbl_wrkstatus = "working for pay     "; * working for pay;
	if anywork = 2 AND wkvol = 1                     then lbl_wrkstatus = "volunteering outside"; * volunteering outside;
	if anywork = 2 AND wkvol ne 1                    then lbl_wrkstatus = "Not working"; * Not working;
	if anywork in (-99, .m) AND wkvol = 1            then lbl_wrkstatus = "volunteering outside"; * volunteering outside;
	if anywork in (-99, .m) AND wkvol = 2            then lbl_wrkstatus = "Not working"; * ;
	if anywork in (-99, .m) AND wkvol in (-99, .m)   then lbl_wrkstatus = "Missing working info"; * Missing working info;

	* Create work location variable: wrklctn;
	if wrkstatus = 1 AND wkvol = 2                   then wrklctn = 1; * working at home;
	if wrkstatus = 1 AND wkvol = 1                   then wrklctn = 2; * working outside;
	if wrkstatus = 1 AND wkvol in (-99, .m)          then wrklctn = 3; * missing working loction info;


	if wrkstatus = 1 AND wkvol = 2                   then lbl_wrklctn = "working at home             "; * working at home;
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

	* Make an all-in-one variable: allewgrp_layer3_EW;
	if wrkstatus = 1 AND wrklctn = 1                   then lbl_allewgrp_layer3_EW = "Working From Home   ";  *working, inside home;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk in (1:3) then lbl_allewgrp_layer3_EW = "Essential Worker";  *working, outside home, EW;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 4      then lbl_allewgrp_layer3_EW = "Non-Essential Worker";  *working, outside home, non EW;
	if wrkstatus = 1 AND wrklctn = 2 AND ewrk = 5      then lbl_allewgrp_layer3_EW = "Missing Setting Info";  *working, outside home, missing setting information;
	if wrkstatus = 1 AND wrklctn = 3                   then lbl_allewgrp_layer3_EW = "Missing Work Location";  *working, missing location info;
	if wrkstatus = 2                                   then lbl_allewgrp_layer3_EW = "Volunteering";  *volunteering;
	if wrkstatus = 3                                   then lbl_allewgrp_layer3_EW = "Not Working"; *not working;
	if wrkstatus = 4                                   then lbl_allewgrp_layer3_EW = "Missing Working Info"; *missing working info;

	*Ganular Vaccination Status;
	if (28 <= week <= 33) AND RECVDVACC in (-99,.m)                            then vacstatus = 0; *Missing Vaccination Status/Information;                             
	if (28 <= week <= 33) AND RECVDVACC = 1         AND DOSES in (2,-99,.m)    then vacstatus = 1; *Partially Vaccinated;
	if (28 <= week <= 33) AND RECVDVACC = 1         AND DOSES = 1              then vacstatus = 4; *Vaccinated (or intend to be);
	if (28 <= week <= 33) AND RECVDVACC = 2                                    then vacstatus = 3; *Not Vaccinated;

	if 34 <= week <= 39 AND RECVDVACC in (-99,.m)                            then vacstatus = 0; *Missing Vaccination Status/Information;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV in (3,-99,.m)  then vacstatus = 1; *Partially Vaccinated;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV in (1,2)       then vacstatus = 2; *Vaccinated;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV = 2            then vacstatus = 4; *Vaccinated (or intend to be);
	if 34 <= week <= 39 AND RECVDVACC = 2                                    then vacstatus = 3; *Not Vaccinated;

	if 40 <= week <= 45 AND RECVDVACC in (-99,.m)                                                       then vacstatus = 0; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (5,6,-99,.m)                             then vacstatus = 0; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 1           then vacstatus = 1; *Partially Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 2           then vacstatus = 2; *Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 3           then vacstatus = 5; *Booster Received;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 4           then vacstatus = 6; *2+ Booster Received; 
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES in (5,-99,.m) then vacstatus = 0; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES = 1           then vacstatus = 2; *Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES = 2           then vacstatus = 5; *Booster Received;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES in (3,4)      then vacstatus = 6; *2+ Booster Received; 
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES in (5,-99,.m) then vacstatus = 2; *Vaccinated; /*this is a special case - we know they are at minimum vaccinated*/
	if 40 <= week <= 45 AND RECVDVACC = 2                                                               then vacstatus = 3; *Not Vaccinated;

	if 46 <= week <= 48 AND RECVDVACC in (-99,.m)                                                       then vacstatus = 0; *Missing Vaccination Status/Information;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES in (-99,.m)                              then vacstatus = 0; *Missing Vaccination Status/Information;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 1                                      then vacstatus = 1; *Partially Vaccinated;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2           AND RBOOSERV in (2,-99,.m) then vacstatus = 2; *Vaccinated;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2           AND RBOOSERV = 1           then vacstatus = 5; *Booster Received;
	if 46 <= week <= 48 AND RECVDVACC = 2                                                               then vacstatus = 3; *Not Vaccinated;






	if (28 <= week <= 33) AND RECVDVACC in (-99,.m)                            then lbl_vacstatus = "Missing Data                "; *Missing Vaccination Status/Information;                             
	if (28 <= week <= 33) AND RECVDVACC = 1         AND DOSES in (2,-99,.m)    then lbl_vacstatus = "Partially Vaccinated"; *Partially Vaccinated;
	if (28 <= week <= 33) AND RECVDVACC = 1         AND DOSES = 1              then lbl_vacstatus = "Vaccinated (or intend to be)"; *Vaccinated (or intend to be);
	if (28 <= week <= 33) AND RECVDVACC = 2                                    then lbl_vacstatus = "Not Vaccinated"; *Not Vaccinated;

	if 34 <= week <= 39 AND RECVDVACC in (-99,.m)                            then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV in (3,-99,.m)  then lbl_vacstatus = "Partially Vaccinated"; *Partially Vaccinated;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV in (1,2)       then lbl_vacstatus = "Vaccinated"; *Vaccinated;
	if 34 <= week <= 39 AND RECVDVACC = 1         AND DOSESRV = 2            then lbl_vacstatus = "Vaccinated (or intend to be)"; *Vaccinated (or intend to be);
	if 34 <= week <= 39 AND RECVDVACC = 2                                    then lbl_vacstatus = "Not Vaccinated"; *Not Vaccinated;

	if 40 <= week <= 45 AND RECVDVACC in (-99,.m)                                                       then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (5,6,-99,.m)                             then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 1           then lbl_vacstatus = "Partially Vaccinated"; *Partially Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 2           then lbl_vacstatus = "Vaccinated"; *Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 3           then lbl_vacstatus = "Booster Received"; *Booster Received;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES = 4           then lbl_vacstatus = "2+ Booster Received"; *2+ Booster Received; 
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND in (1,2,4)       AND NUMDOSES in (5,-99,.m) then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES = 1           then lbl_vacstatus = "Vaccinated"; *Vaccinated;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES = 2           then lbl_vacstatus = "Booster Received"; *Booster Received;
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES in (3,4)      then lbl_vacstatus = "2+ Booster Received"; *2+ Booster Received; 
	if 40 <= week <= 45 AND RECVDVACC = 1         AND BRAND = 3              AND NUMDOSES in (5,-99,.m) then lbl_vacstatus = "Vaccinated"; *Vaccinated; /*this is a special case - we know they are at minimum vaccinated*/
	if 40 <= week <= 45 AND RECVDVACC = 2                                                               then lbl_vacstatus = "Not Vaccinated"; *Not Vaccinated;

	if 46 <= week <= 48 AND RECVDVACC in (-99,.m)                                                       then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES in (-99,.m)                              then lbl_vacstatus = "Missing Data"; *Missing Vaccination Status/Information;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 1                                      then lbl_vacstatus = "Partially Vaccinated"; *Partially Vaccinated;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2          AND BOOSTERRV in (2,-99,.m) then lbl_vacstatus = "Vaccinated"; *Vaccinated;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2          AND BOOSTERRV = 1           then lbl_vacstatus = "Booster Received"; *Booster Received;
	if 46 <= week <= 48 AND RECVDVACC = 2                                                               then lbl_vacstatus = "Not Vaccinated"; *Not Vaccinated;

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

	if RECVDVACC = 1   then lbl_shot = "Vaccinated    ";
    if RECVDVACC = 2   then lbl_shot = "Not Vaccinated";
	if RECVDVACC = -99 then lbl_shot = "Missing Data"; *question seen but not answered;
	if RECVDVACC = .m  then lbl_shot = "Missing Data"; *missing value;
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
		shot
		lbl_shot
		vacstatus
		lbl_vacstatus;
run;
Proc export data=ew_subset 
	outfile='C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\PULSE_vis.csv' 
	dbms=csv 
	replace;
run;

* 3 Calculate metrics by vacstatus;
proc surveyfreq data=week_all varmethod=BRR(FAY);
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table lbl_vacstatus;
	ods output oneway=populations_vacstatus_summary;
	by week;
run;

proc export 
	data = populations_vacstatus_summary 
	outfile="C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\populations_vacstatus_summary"
	dbms = xlsx
	replace; 
run;
