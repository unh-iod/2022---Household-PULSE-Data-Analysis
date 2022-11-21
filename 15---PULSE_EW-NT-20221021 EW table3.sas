********************************************************************
* NIOSH WSH (PAR-20-312) Project - Household PULSE Data Analysis
* Data: HPS data phase 3.1-3.5 (week 28-48)
* By: Nate Thomas
********************************************************************

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

********************************************************************;
* Clean and prepare data;
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

* Merge main and weights data;
data week&wk.;
	merge main wgt;
	by SCRAM;

	* Add variables in different phases to first week to carry nulls for subsequent weeks;
	if week in (28:33) then do; *Phase 3.1;
		EGENID_BIRTH= .; 
		PHASE= "Phase 3.1";
		WHYNOTV1 = .;
		WHYNOTV2 = .;
		WHYNOTV3 = .;
		WHYNOTV4 = .;
		WHYNOTV5 = .;
		WHYNOTV6 = .;
		WHYNOTV7 = .;
		WHYNOTV8 = .;
		WHYNOTV9 = .;
		WHYNOTV10 = .;
		WHYNOTV11 = .;
		WHYNOTV13 = .;
		DOSESRV = .;
		NUMDOSES = .;
		BRAND = .;
		WHYNORV1 = .;
		WHYNORV2 = .;
		WHYNORV3 = .;
		WHYNORV4 = .;
		WHYNORV5 = .;
		WHYNORV6 = .;
		WHYNORV7 = .;
		WHYNORV8 = .;
		WHYNORV9 = .;
		WHYNORV10 = .;
		WHYNORV11 = .;
		WHYNORV12 = .;
		WHYNORV13 = .;
		BOOSTERRV = .;
		WHYNOBSTR1 = .;
		WHYNOBSTR2 = .;
		WHYNOBSTR3 = .;
		WHYNOBSTR4 = .;
		WHYNOBSTR5 = .;
		WHYNOBSTR6 = .;
		WHYNOBSTR7 = .;
		WHYNOBSTR8 = .;
		WHYNOBSTR9 = .;
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

	* Keep only variables needed;
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

********************************************************************;
* Clean data and create new variables - independent variables - Macro pulse_var_ind;
%macro pulse_var_ind (week1, week2);
%do wk = &week1. %to &week2.;
data week&wk.;
	set week&wk.;

	* General demographics: age, gender, hisp_race, educ;
	* Age group;

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

	* Gender;
	if 28 le week le 33 and EGENDER      = 2 then female = 1; * For phase 3.1 (week 28-33) data; 
	if 28 le week le 33 and EGENDER      = 1 then female = 0;
	if       week >= 34 and EGENID_BIRTH = 2 then female = 1; * For phase 3.2-3.4 (week >=34) data;
	if       week >= 34 and EGENID_BIRTH = 1 then female = 0; 	
	if 28 le week le 33 and EGENDER      = 2 then lbl_female = "Female";  * For phase 3.1 (week 28-33) data; 
	if 28 le week le 33 and EGENDER      = 1 then lbl_female = "Male";
	if       week >= 34 and EGENID_BIRTH = 2 then lbl_female = "Female";  * For phase 3.2-3.4 (week >=34) data;
	if       week >= 34 and EGENID_BIRTH = 1 then lbl_female = "Male";

	* Hisp and Race;
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

	* Education;
	if EEDUC in (1,2) then educ = 1; /*Less than high school*/
	if EEDUC in (3)   then educ = 2; /*High school*/
   	if EEDUC in (4,5) then educ = 3; /*Some college*/
   	if EEDUC in (6,7) then educ = 4; /*College*/

	if EEDUC in (1,2) then lbl_educ = "Less than high school"; 
	if EEDUC in (3)   then lbl_educ = "High school"; 
   	if EEDUC in (4,5) then lbl_educ = "Some college"; 
   	if EEDUC in (6,7) then lbl_educ = "College";

	* Disability status;
	* Make disability grouping - based on original data;
	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then disability = 1;
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then disability = .;
	if seeing in (1, 2) AND  hearing in (1,2) AND remembering in (1,2) AND mobility in (1,2)  then disability = 0;

	if seeing in (3,4) OR hearing in (3,4) OR remembering in (3,4) OR mobility in (3,4) then lbl_disability =               "With Disability   ";
	if seeing in (., -99) AND  hearing in (.,-99) AND remembering in (.,-99) AND mobility in (.,-99)  then lbl_disability = "Missing Data";
	if seeing in (1, 2) AND  hearing in (1,2) AND remembering in (1,2) AND mobility in (1,2)  then lbl_disability =         "Without Disability";

* Make work and setting new variables;
* Use 3 existing variables: anywork & wkvol & setting;
data week&wk.;
	set week&wk.;

	* New variables for original data;
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
	if wrkstatus = 1 AND wrklctn = 1                   then lbl_allewgrp_layer3_EW = "Working From Home    ";  *working, inside home;
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
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2           AND BOOSTERRV in (2,-99,.m) then vacstatus = 2; *Vaccinated;
	if 46 <= week <= 48 AND RECVDVACC = 1         AND NUMDOSES = 2           AND BOOSTERRV = 1           then vacstatus = 5; *Booster Received;
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
run;
%end;
%mend pulse_var_ind;

%pulse_var_ind(28,48);

********************************************************************;
* Dependent variables - use macro pulse_var_dep;
* Shot-Received at least one shot;
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

%pulse_var_dep(28,48);

* Combine datasets;
* Append data;
data week_all;
	set week28;
%macro Append(week1,week2);
%do wk = &week1. %to &week2.;
proc append base=week_all data=week&wk. force;
run;
%end;
%mend Append;

%Append(29,48);

*Collect and define the whynot reason - collapse into a single word for visualization post processing in R;
data week_all;
	set week_all;
	if 28 <= week <= 33 then do;
		if WHYNOT1 in (-99,.m)   then WHYNOT1=0;  else WHYNOT1=1;
		if WHYNOT2 in (-99,.m)   then WHYNOT2=0;  else WHYNOT2=1;
		if WHYNOT3 in (-99,.m)   then WHYNOT3=0;  else WHYNOT3=1;
		if WHYNOT4 in (-99,.m)   then WHYNOT4=0;  else WHYNOT4=1;
		if WHYNOT5 in (-99,.m)   then WHYNOT5=0;  else WHYNOT5=1;
		if WHYNOT6 in (-99,.m)   then WHYNOT6=0;  else WHYNOT6=1;
		if WHYNOT7 in (-99,.m)   then WHYNOT7=0;  else WHYNOT7=1;
		if WHYNOT8 in (-99,.m)   then WHYNOT8=0;  else WHYNOT8=1;
		if WHYNOT9 in (-99,.m)   then WHYNOT9=0;  else WHYNOT9=1;
		if WHYNOT10 in (-99,.m)  then WHYNOT10=0; else WHYNOT10=1;
		if WHYNOT11 in (-99,.m)  then WHYNOT11=0; else WHYNOT11=1;
		WHYNOT12=0;
		WHYNOT13=0;
		REASON1=WHYNOT1; *I am concerned about possible side effects of a COVID-19 vaccine;
		REASON2=WHYNOT2; *I don't know if a COVID-19 vaccine will  - protect me  -work;
		REASON3=WHYNOT3; *I don't beleive I need a COVID-19 vaccine;
		REASON4=WHYNOT5; *My doctor has not recommended it;
		REASON5=WHYNOT6; *I plan to wait and see if it is safe and may get it later;
		REASON6=WHYNOT9; *I don't trust COVID-19 vaccines;
		REASON7=WHYNOT10; *I don't trust the government;
		if WHYNOT4=1 or WHYNOT7=1 or WHYNOT8=1 or WHYNOT11=1 then REASON8=1; else REASON8=0; *Other;
	end;
	if 34 <= week <= 45 then do;
		if WHYNORV1 in (-99,.m)  then WHYNOT1=0;  else WHYNOT1=1;
		if WHYNORV2 in (-99,.m)  then WHYNOT2=0;  else WHYNOT2=1;
		if WHYNORV3 in (-99,.m)  then WHYNOT3=0;  else WHYNOT3=1;
		if WHYNORV4 in (-99,.m)  then WHYNOT4=0;  else WHYNOT4=1;
		if WHYNORV5 in (-99,.m)  then WHYNOT5=0;  else WHYNOT5=1;
		if WHYNORV6 in (-99,.m)  then WHYNOT6=0;  else WHYNOT6=1;
		if WHYNORV7 in (-99,.m)  then WHYNOT7=0;  else WHYNOT7=1;
		if WHYNORV8 in (-99,.m)  then WHYNOT8=0;  else WHYNOT8=1;
		if WHYNORV9 in (-99,.m)  then WHYNOT9=0;  else WHYNOT9=1;
		if WHYNORV10 in (-99,.m) then WHYNOT10=0; else WHYNOT10=1;
		if WHYNORV11 in (-99,.m) then WHYNOT11=0; else WHYNOT11=1;
		if WHYNORV12 in (-99,.m) then WHYNOT12=0; else WHYNOT12=1;
		if WHYNORV13 in (-99,.m) then WHYNOT13=0; else WHYNOT13=1;
		REASON1=WHYNOT1; *I am concerned about possible side effects of a COVID-19 vaccine;
		REASON2=WHYNOT2; *I don't know if a COVID-19 vaccine will  - protect me  -work;
		REASON3=WHYNOT3; *I don't beleive I need a COVID-19 vaccine;
		REASON4=WHYNOT4; *My doctor has not recommended it;
		REASON5=WHYNOT5; *I plan to wait and see if it is safe and may get it later;
		REASON6=WHYNOT7; *I don't trust COVID-19 vaccines;
		REASON7=WHYNOT8; *I don't trust the government;
		if WHYNOT6=1 or WHYNOT9=1 or WHYNOT10=1 or WHYNOT11=1 or WHYNOT12=1 or WHYNOT13=1 then REASON8=1; else REASON8=0; *Other;
	end;
	if 46 <= week then do;
		WHYNOT1=0;
		WHYNOT2=0;
		WHYNOT3=0;
		WHYNOT4=0;
		WHYNOT5=0;
		WHYNOT6=0;
		WHYNOT7=0;
		WHYNOT8=0;
		WHYNOT9=0;
		WHYNOT10=0;
		WHYNOT11=0;
		WHYNOT12=0;
		WHYNOT13=0;
	end;
	WHYNOT = catx(',',WHYNOT1,
					  WHYNOT2,
					  WHYNOT3,
					  WHYNOT4,
					  WHYNOT5,
					  WHYNOT6,
					  WHYNOT7,
					  WHYNOT8,
					  WHYNOT9,
					  WHYNOT10,
					  WHYNOT11,
					  WHYNOT12,
					  WHYNOT13);
run;

* Save data for R analysis;
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
		lbl_female
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
		lbl_vacstatus
		GETVACRV
		BOOSTERRV
		WHYNOT;
run;

Proc export data=ew_subset 
	outfile='C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\PULSE_vis.csv' 
	dbms=csv 
	replace;
run;

* Prepare reference set (numerator: ref_set = 0, denomiator ref_set = 1);
data week_all;
	set week_all;
	ref_set = 0;
run;

********************************************************************;
********************************************************************;
* Iterate through bands of information broken out by demographic indicator variables;
* This macro builds 21 rows (by week) when not a pooled row. When the input is pooled the output results in 1 row.;
* Each week row stack pooled row stack is given a stack number -  then stacked up at the end;
* References are defined in the input filtering - BE AWARE that SAS takes as numerator first value of ref_set;
* making it imperative that each input with a grouped reference be sent through a proc sort first - see macro calls below;

%macro bander(
	raw_band=, 
	reference=,
	pooled=,
	file=,
	stack=
	);

*update for programmers ease - storing global raw_band value;
data raw_band;
	set &raw_band.;
run;

proc sort data=raw_band out=raw_band;
	by week descending shot;
run;

* Calculate metrics for population;
proc surveyfreq data=raw_band varmethod=BRR(FAY);
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table shot;
	ods output oneway=populations_summary;
	by week;
run;
* Initialize table 3 population counts;
data vac_table3_init;
	set populations_summary;
	drop Table shot _Skipline;
run;
* F_shot is a generated column from surveyfreq which includes totals;
* Get sample sizes - pivot F_shot to columns;
proc transpose data=vac_table3_init out=vac_table3_w1 prefix=F_shot;
	by week;
	id F_shot;
	var Frequency;
run;
* Prepare for merge;
data vac_table3;
	set vac_table3_w1(drop= _name_ F_shot0 F_shot1);
	rename F_shotTotal = tep_sample_count;
run;
* Get population sizes - pivot F_shot to columns;
proc transpose data=vac_table3_init out=vac_table3_w2 prefix=F_shot;
	by week;
	id F_shot;
	var WgtFreq;
run;
* Prepare for merge;
data vac_table3_w2;
	set vac_table3_w2(drop= _name_ _label_ F_shot1);
	rename F_shotTotal = tep_pop_count
		   F_shot0 = tep_pop_not_count;
run;
* Get StdDev - pivot F_shot to columns;
proc transpose data=vac_table3_init out=vac_table3_w3 prefix=F_shot;
	by week;
	id F_shot;
	var StdDev;
run;
* Prepare for merge;
data vac_table3_w3;
	set vac_table3_w3(drop= _name_ _label_ F_shot1);
	rename F_shotTotal = tep_pop_size_count_se
		   F_shot0 = tep_pop_not_count_se;
run;
* Get Percent - pivot F_shot to columns;
proc transpose data=vac_table3_init out=vac_table3_w4 prefix=F_shot;
	by week;
	id F_shot;
	var Percent;
run;
* Prepare for merge;
data vac_table3_w4;
	set vac_table3_w4(drop= _name_ F_shot1 F_shotTotal);
	rename F_shot0 = tep_pop_not_perc;
run;
* Get StdErr of Percent - pivot F_shot to columns;
proc transpose data=vac_table3_init out=vac_table3_w5 prefix=F_shot;
	by week;
	id F_shot;
	var StdErr;
run;
* Prepare for merge;
data vac_table3_w5;
	set vac_table3_w5(drop= _name_ _label_ F_shot1 F_shotTotal);
	rename F_shot0 = tep_pop_not_perc_se;
run;
*Merge wide (pivoted on F_shot) tables to table1;
data vac_table3;
	merge vac_table3
		  vac_table3_w2
		  vac_table3_w3
		  vac_table3_w4
		  vac_table3_w5;
	by week;
run;
* Calculate metrics for population;
proc sort data=raw_band; 
	by week lbl_allewgrp_layer3_EW reason1; 
proc surveyfreq data=raw_band(where=(shot=0)) varmethod=BRR(FAY);
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table reason1;
	ods output oneway=populations_reason1_summary;
	by week;
run;
data vac_table3_r1;
	set populations_reason1_summary(where=(reason1=1));
run;
data vac_table3_r1;
	set vac_table3_r1(drop=Table F_REASON1 REASON1 _SkipLine);
	rename 
		Frequency=r1_Frequency
		WgtFreq=r1_WgtFreq
		StdDev=r1_StdDev
		Percent=r1_Percent
		StdErr=r1_StdErr;
data vac_table3;
	merge 
		vac_table3
		vac_table3_r1;
	by week;
run;

* Calculate metrics for population;
proc surveyfreq data=raw_band varmethod=BRR(FAY);
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table shot;
	ods output oneway=populations_ew_summary;
	by week lbl_allewgrp_layer3_EW;
run;
* Initialize table 1 population counts by EW status;
data vac_table3_ew_init;
	set populations_ew_summary;
	drop Table shot _Skipline;
run;
* Get sample sizes;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w1 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var Frequency;
run;
proc transpose data=vac_table3_ew_w1 out=vac_table3_ew_w1 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shotTotal;
run;
* Prepare for merge;
data vac_table3_ew_w1;
	set vac_table3_ew_w1(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_sample_count
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_sample_count
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_sample_count;
run;
* Get population sizes;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w2 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var WgtFreq;
run;
proc transpose data=vac_table3_ew_w2 out=vac_table3_ew_w2 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shotTotal;
run;
	* Prepare for merge;
data vac_table3_ew_w2;
	set vac_table3_ew_w2(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_pop_count
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_pop_count
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_pop_count;
run;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w3 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var StdDev;
run;
proc transpose data=vac_table3_ew_w3 out=vac_table3_ew_w3 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shotTotal;
run;
data vac_table3_ew_w3;
	set vac_table3_ew_w3(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_pop_count_se
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_pop_count_se
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_pop_count_se;
run;
* Get vaccinated pop by group;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w4 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var WgtFreq;
run;
proc transpose data=vac_table3_ew_w4 out=vac_table3_ew_w4 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shot0;
run;
data vac_table3_ew_w4;
	set vac_table3_ew_w4(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_s_pop_count
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_s_pop_count
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_s_pop_count;
run;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w5 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var StdDev;
run;
proc transpose data=vac_table3_ew_w5 out=vac_table3_ew_w5 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shot0;
run;
data vac_table3_ew_w5;
	set vac_table3_ew_w5(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_s_pop_count_se
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_s_pop_count_se
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_s_pop_count_se;
run;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w6 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var Percent;
run;
proc transpose data=vac_table3_ew_w6 out=vac_table3_ew_w6 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shot0;
run;
data vac_table3_ew_w6;
	set vac_table3_ew_w6(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_s_pop_perc
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_s_pop_perc
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_s_pop_perc;
run;
proc transpose data=vac_table3_ew_init out=vac_table3_ew_w7 prefix=F_shot;
	by week lbl_allewgrp_layer3_EW;
	id F_shot;
	var StdErr;
run;
proc transpose data=vac_table3_ew_w7 out=vac_table3_ew_w7 prefix=lbl_allewgrp_layer3_EW;
	by week;
	id lbl_allewgrp_layer3_EW;
	var F_shot0;
run;
data vac_table3_ew_w7;
	set vac_table3_ew_w7(drop= _name_);
	rename lbl_allewgrp_layer3_EWEssential = ew_s_pop_perc_se
		   lbl_allewgrp_layer3_EWNon_Essent = no_ew_s_pop_perc_se
		   lbl_allewgrp_layer3_EWWorking_Fr = wfh_s_pop_perc_se;
run;
*Merge wide tables to table1;
data vac_table3_ew;
	merge vac_table3_ew_w1 
		  vac_table3_ew_w2
		  vac_table3_ew_w3
		  vac_table3_ew_w4
		  vac_table3_ew_w5
		  vac_table3_ew_w6
		  vac_table3_ew_w7;
	by week;
run;
data vac_table3;
	merge 
		vac_table3
		vac_table3_ew;
	by week;
run;
* Calculate metrics for Reason1;
proc surveyfreq data=raw_band(where=(shot=0)) varmethod=BRR(FAY);
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table reason1;
	ods output oneway=populations_reason1_ew;
	by week lbl_allewgrp_layer3_EW;
run;
data vac_table3_r1_ew1;
	set populations_reason1_ew(where=(reason1=1 and lbl_allewgrp_layer3_EW="Working From Home"));
run;
data vac_table3_r1_ew1;
	set vac_table3_r1_ew1(drop = lbl_allewgrp_layer3_EW Table F_REASON1 REASON1 _SkipLine);
	rename
		Frequency=wfh_r1_Frequency
		WgtFreq=wfh_r1_WgtFreq
		StdDev=wfh_r1_StdDev
		Percent=wfh_r1_Percent
		StdErr=wfh_r1_StdErr;
run;
data vac_table3_r1_ew2;
	set populations_reason1_ew(where=(reason1=1 and lbl_allewgrp_layer3_EW="Essential Worker"));
run;
data vac_table3_r1_ew2;
	set vac_table3_r1_ew2(drop = lbl_allewgrp_layer3_EW Table F_REASON1 REASON1 _SkipLine);
	rename
		Frequency=ew_r1_Frequency
		WgtFreq=ew_r1_WgtFreq
		StdDev=ew_r1_StdDev
		Percent=ew_r1_Percent
		StdErr=ew_r1_StdErr;
run;
data vac_table3_r1_ew5;
	set populations_reason1_ew(where=(reason1=1 and lbl_allewgrp_layer3_EW="Non-Essential Worker"));
run;
data vac_table3_r1_ew5;
	set vac_table3_r1_ew5(drop = lbl_allewgrp_layer3_EW Table F_REASON1 REASON1 _SkipLine);
	rename
		Frequency=no_ew_r1_Frequency
		WgtFreq=no_ew_r1_WgtFreq
		StdDev=no_ew_r1_StdDev
		Percent=no_ew_r1_Percent
		StdErr=no_ew_r1_StdErr;
run;
data vac_table3;
	merge 
		vac_table3
		vac_table3_r1_ew1
		vac_table3_r1_ew2
		vac_table3_r1_ew5;
	by week;
run;
data vac_table3;
	retain
		week
		tep_sample_count
		tep_pop_count
		tep_pop_size_count_se
		tep_pop_not_count
		tep_pop_not_count_se
		tep_pop_not_perc
		tep_pop_not_perc_se
		r1_Frequency
		r1_WgtFreq
		r1_StdDev
		r1_Percent
		r1_StdErr
		ew_sample_count
		ew_pop_count
		ew_pop_count_se
		ew_s_pop_count
		ew_s_pop_count_se
		ew_s_pop_perc
		ew_s_pop_perc_se
		ew_r1_Frequency
		ew_r1_WgtFreq
		ew_r1_StdDev
		ew_r1_Percent
		ew_r1_StdErr
		no_ew_sample_count
		no_ew_pop_count
		no_ew_pop_count_se
		no_ew_s_pop_count
		no_ew_s_pop_count_se
		no_ew_s_pop_perc
		no_ew_s_pop_perc_se
		no_ew_r1_Frequency
		no_ew_r1_WgtFreq
		no_ew_r1_StdDev
		no_ew_r1_Percent
		no_ew_r1_StdErr
		wfh_sample_count
		wfh_pop_count
		wfh_pop_count_se
		wfh_s_pop_count
		wfh_s_pop_count_se
		wfh_s_pop_perc
		wfh_s_pop_perc_se
		wfh_r1_Frequency
		wfh_r1_WgtFreq
		wfh_r1_StdDev
		wfh_r1_Percent
		wfh_r1_StdErr;
	set vac_table3;
	rr_ewnew_s_pop_perc1 = ew_r1_Percent/no_ew_r1_Percent; *Compare EWs to Non-Ews;
	rr_ewwfh_s_pop_perc1 = ew_r1_Percent/wfh_r1_Percent; *Compare EWs to workers working at home;
	rr_ewtime_s_pop_perc1 = tep_pop_not_perc/ref; *Compare within category;
	drop ref;
run;

* Get RR & ConfInt;	
proc sort data=raw_band out=raw_band;
	by week descending reason1 descending allewgrp_layer3_EW;
run;
proc surveyfreq data=raw_band(where=(allewgrp_layer3_EW in (1,2) and shot=0)) varmethod=BRR(FAY) order=data;
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table allewgrp_layer3_EW*reason1 /or;
	ods output OddsRatio=rr1;
	by week;
run;
data vac_table3_ci1;
	set rr1(where = (Statistic = "Column 1 Relative Risk"));
	drop Table Statistic;
	rename 
		Estimate=rr_ewwfh_s_pop_perc2
		LowerCL = rr_ewwfh_s_pop_perc2_lci
		UpperCL = rr_ewwfh_s_pop_perc2_uci;
run;
* Get RR & ConfInt;
proc sort data=raw_band out=raw_band;
	by week descending reason1 allewgrp_layer3_EW;
run;
proc surveyfreq data=raw_band(where=(allewgrp_layer3_EW in (2,5) and shot=0)) varmethod=BRR(FAY) order=data;
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table allewgrp_layer3_EW*reason1 /or;
	ods output OddsRatio=rr2;
	by week;
run;
data vac_table3_ci2;
	set rr2(where = (Statistic = "Column 1 Relative Risk"));
	drop Table Statistic;
	rename 
		Estimate=rr_ewnew_s_pop_perc2
		LowerCL = rr_ewnew_s_pop_perc2_lci
		UpperCL = rr_ewnew_s_pop_perc2_uci;
run;
*Merge to table3;
data vac_table3;
	merge 
		vac_table3
		vac_table3_ci2
		vac_table3_ci1;
	by week;
run;
* Get RR and CI for reference;
%if &pooled. = 0 %then %do;
data reference_set_rolling;
	set raw_band;
	ref_set = 1; 
run;
data reference_set_rolling;
	set reference_set_rolling;
	week = week+1;
run;
proc append base = reference_set_rolling data = raw_band force;
run;
proc sort data=reference_set_rolling out=reference_set_rolling;
	by week descending reason1 ref_set;
run;
* Get RR and CI for reference;
proc surveyfreq data=reference_set_rolling(where=(shot=0)) varmethod=BRR(FAY) order=data;
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table ref_set*reason1 /or;
	ods output OddsRatio=rr4;
	by week;
run;
data vac_table3_ci4;
	set rr4(where = (Statistic = "Column 1 Relative Risk"));
	drop Table Statistic;
	rename 
		Estimate=rr_ewtimeroll_s_pop_perc2
		LowerCL = rr_ewtimeroll_s_pop_perc2_lci
		UpperCL = rr_ewtimeroll_s_pop_perc2_uci;
run;
data vac_table3;
	merge 
		vac_table3
		vac_table3_ci4;
	by week;
run;
%end;
proc surveyfreq data=&reference.(where=(shot=0)) varmethod=BRR(FAY) order=data;
	weight PWEIGHT;
	repweights PWEIGHT1-PWEIGHT80;
	table ref_set*reason1 /or;
	ods output OddsRatio=rr3;
	by week;
run;
data vac_table3_ci3;
	set rr3(where = (Statistic = "Column 1 Relative Risk"));
	drop Table Statistic;
	rename 
		Estimate=rr_ewtime_s_pop_perc2
		LowerCL = rr_ewtime_s_pop_perc2_lci
		UpperCL = rr_ewtime_s_pop_perc2_uci;
run;
data vac_table3;
	merge 
		vac_table3
		vac_table3_ci3;
	by week;
run;
data vac_table3;
	set vac_table3;
	rr_ewnew_s_pop_perc2_se = log(rr_ewnew_s_pop_perc2_lci/rr_ewnew_s_pop_perc2)*(-1/quantile("t", 0.925, 80));
	rr_ewwfh_s_pop_perc2_se = log(rr_ewwfh_s_pop_perc2_lci/rr_ewwfh_s_pop_perc2)*(-1/quantile("t", 0.925, 80));
	rr_ewtime_s_pop_perc2_se = log(rr_ewtime_s_pop_perc2_lci/rr_ewtime_s_pop_perc2)*(-1/quantile("t", 0.925, 80));
	rr_ewtimeroll_s_pop_perc2_se = log(rr_ewtimeroll_s_pop_perc2_lci/rr_ewtimeroll_s_pop_perc2)*(-1/quantile("t", 0.925, 80));
	rr_ewnew_s_pop_perc2_t = log(1/rr_ewnew_s_pop_perc2)*(1/rr_ewnew_s_pop_perc2_se);
	rr_ewwfh_s_pop_perc2_t = log(1/rr_ewwfh_s_pop_perc2)*(1/rr_ewwfh_s_pop_perc2_se);
	rr_ewtime_s_pop_perc2_t = log(1/rr_ewtime_s_pop_perc2)*(1/rr_ewtime_s_pop_perc2_se);
	rr_ewtimeroll_s_pop_perc2_t = log(1/rr_ewtimeroll_s_pop_perc2)*(1/rr_ewtimeroll_s_pop_perc2_se);
	rr_ewnew_s_pop_perc2_p = cdf("t", rr_ewnew_s_pop_perc2_t, 80);
	rr_ewwfh_s_pop_perc2_p = cdf("t", rr_ewwfh_s_pop_perc2_t, 80);
	rr_ewtime_s_pop_perc2_p = cdf("t", rr_ewtime_s_pop_perc2_t, 80);
	rr_ewtimeroll_s_pop_perc2_p = cdf("t", rr_ewtimeroll_s_pop_perc2_t, 80);
	rr_ewtime_s_pop_perc2_uci = rr_ewtime_s_pop_perc2_uci;
	rr_ewtimeroll_s_pop_perc2_uci = rr_ewtimeroll_s_pop_perc2_uci;
run;
data vac_table3;
		retain
		week
		week
		tep_sample_count
		tep_pop_count
		tep_pop_size_count_se
		tep_pop_not_count
		tep_pop_not_count_se
		tep_pop_not_perc
		tep_pop_not_perc_se
		r1_Frequency
		r1_WgtFreq
		r1_StdDev
		r1_Percent
		r1_StdErr
		ew_sample_count
		ew_pop_count
		ew_pop_count_se
		ew_s_pop_count
		ew_s_pop_count_se
		ew_s_pop_perc
		ew_s_pop_perc_se
		ew_r1_Frequency
		ew_r1_WgtFreq
		ew_r1_StdDev
		ew_r1_Percent
		ew_r1_StdErr
		no_ew_sample_count
		no_ew_pop_count
		no_ew_pop_count_se
		no_ew_s_pop_count
		no_ew_s_pop_count_se
		no_ew_s_pop_perc
		no_ew_s_pop_perc_se
		no_ew_r1_Frequency
		no_ew_r1_WgtFreq
		no_ew_r1_StdDev
		no_ew_r1_Percent
		no_ew_r1_StdErr
		wfh_sample_count
		wfh_pop_count
		wfh_pop_count_se
		wfh_s_pop_count
		wfh_s_pop_count_se
		wfh_s_pop_perc
		wfh_s_pop_perc_se
		wfh_r1_Frequency
		wfh_r1_WgtFreq
		wfh_r1_StdDev
		wfh_r1_Percent
		wfh_r1_StdErr
		rr_ewnew_s_pop_perc1
		rr_ewnew_s_pop_perc2
		rr_ewnew_s_pop_perc2_lci
		rr_ewnew_s_pop_perc2_uci
		rr_ewnew_s_pop_perc2_se
		rr_ewnew_s_pop_perc2_t
		rr_ewnew_s_pop_perc2_p
		rr_ewwfh_s_pop_perc1
		rr_ewwfh_s_pop_perc2
		rr_ewwfh_s_pop_perc2_lci
		rr_ewwfh_s_pop_perc2_uci
		rr_ewwfh_s_pop_perc2_se
		rr_ewwfh_s_pop_perc2_t
		rr_ewwfh_s_pop_perc2_p
		rr_ewtime_s_pop_perc1
		rr_ewtime_s_pop_perc2
		rr_ewtime_s_pop_perc2_lci
		rr_ewtime_s_pop_perc2_uci
		rr_ewtime_s_pop_perc2_se
		rr_ewtime_s_pop_perc2_t
		rr_ewtime_s_pop_perc2_p
		rr_ewtimeroll_s_pop_perc2
		rr_ewtimeroll_s_pop_perc2
		rr_ewtimeroll_s_pop_perc2_lci
		rr_ewtimeroll_s_pop_perc2_uci
		rr_ewtimeroll_s_pop_perc2_se
		rr_ewtimeroll_s_pop_perc2_t
		rr_ewtimeroll_s_pop_perc2_p;
	set vac_table3;
run;

proc export 
	data = vac_table3 
	outfile= &file.
	dbms = xlsx
	replace; 
run;

data stack&stack.;
	set vac_table3;
run;

proc delete data=vac_table3_init;
run;
proc delete data=vac_table3_w2;
run;
proc delete data=vac_table3_w3;
run;
proc delete data=vac_table3_w4;
run;
proc delete data=vac_table3_w5;
run;

proc delete data=vac_table3_ew_init;
run;
proc delete data=vac_table3_ew;
run;
proc delete data=vac_table3_ew_w1;
run;
proc delete data=vac_table3_ew_w2;
run;
proc delete data=vac_table3_ew_w3;
run;
proc delete data=vac_table3_ew_w4;
run;
proc delete data=vac_table3_ew_w5;
run;
proc delete data=vac_table3_ew_w6;
run;
proc delete data=vac_table3_ew_w7;
run;

proc delete data=ref;
run;
proc delete data=vac_table3;
run;
proc delete data=vac_table3_ci1;
run;
proc delete data=vac_table3_ci2;
run;
proc delete data=vac_table3_ci3;
run;
proc delete data=vac_table3_ci4;
run;
proc delete data=reference_set_rolling
run;
proc delete data=rr1;
run;
proc delete data=rr2;
run;
proc delete data=rr3;
run;
proc delete data=rr4;
run;

%mend bander;

********************************************************************
********************************************************************;
* Population Overview band 1;
data reference_set;
	set week_all(where=(allewgrp_layer3_EW in (1,2,5) and shot in (0,1) and week=28));
	ref_set = 1; 
run;
data full_reference_set;
	set reference_set;
run;
%macro reference_stack(week1,week2);
%do wk = &week1. %to &week2.;
data reference_set&wk.;
	set reference_set;
	week = &wk.;
run;
proc append base = full_reference_set data = reference_set&wk. force;
run;
%end;
%mend reference_stack;
%reference_stack(29,45);
proc append base = full_reference_set data = week_all(where=(week in (28:45) and allewgrp_layer3_EW in (1,2,5) and shot in (0,1))) force;
run;
proc sort data=full_reference_set out=full_reference_set;
	by week descending shot ref_set;
run;
%bander(raw_band = week_all(where=(week in (28:45) and allewgrp_layer3_EW in (1,2,5) and shot in (0,1))),
		pooled = 0,
		reference=full_reference_set,
		file = "C:\Users\npr8\OneDrive - USNH\2022---Household-PULSE-Data-Analysis\SAS\populations_vac_table3",
		stack = 1);

