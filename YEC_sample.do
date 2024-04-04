clear all 
capture log close
set logtype text
log using replication_choi.txt

*** Laptop
cd "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2"

****** Individual level estimation ******

*** Variable descriptive (this is not defined in the original code) 

/*** The dataset the paper provides does not have specific explanation of variables. 
I match the variable descriptive through the appendix and will define the variables for interpretation easy. ***/ 

foreach s in florida georgia missouri montana newyork northcarolina pennsylvania {

use `s'.dta, clear
describe 
su
/* I found out that the data only provides the individual demographic statistics as follows: 
incarceration, release date, the binary variable whether the dna is collected or not, age, 
state, white, type of criminal behavior and whether they are reoffended after 3 or 5 years. 
Still, most of the variables are binary variable and release date is unformatted which 
it needs to be formatted by date. */ 

foreach i in murder sexassault robbery aggassault burglary larceny vtheft arson ucrviol_r ucrprop {
rename sample_`i' `i'
rename sample_`i'_ever `i'_ever
}
label var murder "Murder convicts" 
label var sexassault "Sexual Assualt"
label var robbery "Robbery convicts" 
label var aggassault "Aggravated assault convcits" 
label var burglary "Burglary convicts"
label var larceny "Larceny convicts" 
label var vtheft "Vehicle theft convicts"
label var arson "Arson convcits"
label var ucrviol_r "Any UCR Violent Crime" 
label var ucrprop "Any UCR Property Crime" 
label var incarceration "Incarceration number"
label var release_date "Release date"
label var dna_collected "DNA required"
label var white "White"
label var black "Black"
label var ucrviol_r "Violent crime convict"
label var ucrprop "Property crime convict"
label var murder_ever "Murder history"
label var sexassault_ever "Rape history"
label var robbery_ever "Robbery history"
label var aggassault_ever "Aggravated assault history"
label var burglary_ever "Burglary history"
label var larceny_ever "Larceny history"
label var vtheft_ever "Vehicle theft history"
label var arson_ever "Arson history"
label var ucrviol_r_ever "Violent crime history"
label var ucrprop_ever "Property crime history"
label var age "Age"
label var age_sq "Age squared"
label var reoffend_3yrs "Convicted within 3 years of release"
label var reoffend_5yrs "Convicted within 5 years of release"
label var state "State"

save `s'_1.dta, replace
}

*** 1-1. Fig 1 and 2: DNA requirement for serious violent offense convicts ***

/*** Actually, the impression of the code they provided is too long. 
Even though we could simplify the codes they went through into details, it makes me little bit more 
time to run their codes. Thus to save time and space, I modified the entire code with the abbreviation. 
I would put "/* */" into the original code and I would put the modified version from mine as following way. ***/

/*** The paper represents the probabilities that released offenders convict serious
crimes who required to provide DNA samples consequent to thier release day by state level. 
For the serious violent offense, they provides different level of crimes in the appendix 
so that code conducts all level of crimes to show the scatter plot of probabilities DNA required. 
I will only restrict crime level to murder and sexual assualt where it seems most relevant to 
serious crimes. ***/ 

/* foreach j in murder sexassault {

use florida_1.dta, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("Florida") ytitle("Pr(DNA Required)") xtitle("Date of release") tlabel(11139 "Jul 1990" 12235 "Jul 1993" 12965 "Jul 1995" 14792 "Jul 2000" 15522 "Jul 2002" 15887 "Jul 2003" 16253 "Jul 2004" 16983 "Jul 2006" 17348 "Jul 2007", labsize(vsmall) angle(vertical)) xline(11139 12235 12965 14792 15522 15887 16253 16983 17348, lcolor(red)))
graph export "FL_`j'_week.png", replace


use georgia_1.dta, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("Georgia") ytitle("Pr(DNA Required)") tlabel(11870 "Jul 1992" 14792 "Jul 2000", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(11870 14792, lcolor(red)))
graph export "GA_`j'_week.png", replace

use missouri.dta, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("Missouri") ytitle("Pr(DNA Required)") tlabel(11562 "Aug 1991" 13389 "Aug 1996" 16437 "Jan 2005", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(11562 13389 16437, lcolor(red)))
graph export "MO_`j'_week.png", replace
clear

use montana, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("Montana") ytitle("Pr(DNA Required)") tlabel(12869 "Mar 1995" 15249 "Oct 2001", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(12869 15249, lcolor(red)))
graph export "MT_`j'_week.png", replace
clear

use newyork, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("New York") ytitle("Pr(DNA Required)") tlabel(13149 "Jan 1996" 14579 "Dec 1999" 16258 "Jul 2004" 16975 "Jun 2006", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(13149 14579 16258 16975, lcolor(red)))
graph export "NY_`j'_week.png", replace
clear

use northcarolina
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("North Carolina") ytitle("Pr(DNA Required)") tlabel(12600 "Jul 1994" 16040 "Dec 2003" 16771 "Dec 2005", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(12600 16040 16771, lcolor(red)))
graph export "NC_`j'_week.png", replace
clear

use pennsylvania
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if sample_`j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("Pennsylvania") ytitle("Pr(DNA Required)") tlabel(13481 "Nov 1996" 15510 "Oct 2001" 15690 "Dec 2002" 16465 "Jan 2005", labsize(vsmall) angle(vertical)) xtitle("Date of release") xline(13481 15510 15690 16465, lcolor(red)))
graph export "PA_`j'_week.png", replace
clear
} */

foreach s in florida georgia missouri montana newyork northcarolina pennsylvania {

foreach j in murder {

use `s'_1.dta, clear
gen woy = week(release_date)
gen year = year(release_date)
collapse (mean) dna_collected (min) release_date if `j', by(year woy)
twoway (scatter dna_collected release_date if release_date>=10227 & release_date<18992, sort title("`s'") ytitle("Pr(DNA Required)") xtitle("Date of release") tlabel(11139 "Jul 1990" 12235 "Jul 1993" 12965 "Jul 1995" 14792 "Jul 2000" 15522 "Jul 2002" 15887 "Jul 2003" 16253 "Jul 2004" 16983 "Jul 2006" 17348 "Jul 2007", labsize(vsmall) angle(vertical)) xline(11139 12235 12965 14792 15522 15887 16253 16983 17348, lcolor(red)))
gr save `s'_`j'_week, replace
}
}

gr combine florida_murder_week.gph georgia_murder_week.gph missouri_murder_week.gph montana_murder_week.gph newyork_murder_week.gph northcarolina_murder_week.gph pennsylvania_murder_week.gph, ycommon col(4)
gr export state_murder.png, replace

*** 1-2. UCR Violent Offenders ***

use montana_1.dta, clear
append using missouri_1
append using florida_1
append using newyork_1
append using georgia_1
append using pennsylvania_1
append using northcarolina_1

/*** The paper creates offender samples for the analysis. 
Individual's released date is discriminated based on their criminal behavior to construct the discontinuity based on Figure 1 and 2. 
As the graph shows, there would be two discontinuities because several crimes are conducted by each individuals. 
The paper confines the released date before January 1 2007 for everyone to be observed for a full five years after release. 
They finally recentered the release dates where zero states the expansion date and final samples span 1994 to 2005. 
I've learned how to construct the threshold to discriminate the before and after the expansion date and baseline for the RD estimation. 
I think this data management is the most important part before RD design. ***/

global window = 365 /* The bandwidth of this paper is 365 days. */ 
gen keep_obs_$window = 0

gen release_recentered = .

* Florida -- 3 jumps in DNA collection, in 1995, 2002 and 2004.
gen fl_win_1 =  state=="FL" & (release_date>=(12965-$window) & release_date<(12965+$window)) 
replace release_recentered = release_date - 12965 if fl_win_1==1
gen fl_win_2 =  state=="FL" & (release_date>=(15522-$window) & release_date<(15522+$window)) 
replace release_recentered = release_date - 15522 if fl_win_2==1
gen fl_win_3 =  state=="FL" & (release_date>=(16253-$window) & release_date<(16253+$window))
replace release_recentered = release_date - 16253 if fl_win_3==1
replace keep_obs_$window=1 if (fl_win_1 | fl_win_2 | fl_win_3)

* Georgia -- 1 jump in DNA collection, in 2000
gen ga_win_1 = state=="GA" & (release_date>=(14792-$window) & release_date<(14792+$window)) 
replace release_recentered = release_date - 14792 if ga_win_1==1
replace keep_obs_$window=1 if ga_win_1

* Missouri -- 2 jumps in DNA collection, in 1996 and 2005.
gen mo_win_1 = state=="MO" & release_date>=(13389-$window) & release_date<(13389+$window)
replace release_recentered = release_date - 13389 if mo_win_1==1
gen mo_win_2 = state=="MO" & release_date>=(16437-$window) & release_date<(16437+$window)
replace release_recentered = release_date - 16437 if mo_win_2==1
replace keep_obs_$window=1 if (mo_win_1 | mo_win_2)

* Montana -- 1 jump in DNA collection, in 1995
gen mt_win_1 = state=="MT" & (release_date>=(12869-$window) & release_date<(12869+$window)) 
replace release_recentered = release_date - 12869 if mt_win_1==1
replace keep_obs_$window=1 if mt_win_1

* New York -- 1 jump in DNA collection, in 1999
gen ny_win_1 = state=="NY" & (release_date>=(14579-$window) & release_date<(14579+$window))
replace release_recentered = release_date - 14579 if ny_win_1==1
replace keep_obs_$window=1 if ny_win_1

* North Carolina -- 1 jump in DNA collection, in 1994
gen nc_win_1 = state=="NC" & (release_date>=(12600-$window) & release_date<(12600+$window)) 
replace release_recentered = release_date - 12600 if nc_win_1==1
replace keep_obs_$window=1 if nc_win_1

* Pennsylvania -- 3 jumps in DNA collection, in 1996, 2002, and 2005
gen pa_win_1 = state=="PA" & (release_date>=(13481-$window) & release_date<(13481+$window)) 
replace release_recentered = release_date - 13481 if pa_win_1==1
gen pa_win_2 = state=="PA" & (release_date>=(15690-$window) & release_date<(15690+$window)) 
replace release_recentered = release_date - 15690 if pa_win_2==1
gen pa_win_3 = state=="PA" & (release_date>=(16465-$window) & release_date<(16465+$window)) 
replace release_recentered = release_date - 16465 if pa_win_3==1
replace keep_obs_$window=1 if (pa_win_1 | pa_win_2 | pa_win_3)

keep if keep_obs_$window==1

gen post = release_recentered>=0 /* creates the post variable after the threshold */

gen state_fl = state=="FL"
gen state_ga = state=="GA"
gen state_mo = state=="MO"
gen state_mt = state=="MT"
gen state_ny = state=="NY"
gen state_nc = state=="NC"
gen state_pa = state=="PA"

gen year = year(release_date)
gen month = month(release_date)
gen dow = dow(release_date)
gen incarc1 = incarceration==1
	
gen age_missing = (age==.)
replace age = 0 if age==.
gen race_missing = (black==.)
replace black = 0 if black==.

foreach c in murder sexassault aggassault robbery {
gen postX`c' = post*`c'
gen dnaX`c' = dna_collected*`c'

}
gen dnaXage = dna_collected*age
gen postXage = post*age

/* gen postXmurder = post*sample_murder
gen postXsexassault = post*sample_sexassault
gen postXaggassault = post*sample_aggassault
gen postXrobbery = post*sample_robbery

gen dnaXmurder = dna_collected*sample_murder
gen dnaXsexassault = dna_collected*sample_sexassault
gen dnaXaggassault = dna_collected*sample_aggassault
gen dnaXrobbery = dna_collected*sample_robbery*/


* Year fixed effects
gen year_1993 = year==1993
gen year_1994 = year==1994
gen year_1995 = year==1995
gen year_1996 = year==1996
gen year_1997 = year==1997
gen year_1998 = year==1998
gen year_1999 = year==1999
gen year_2000 = year==2000
gen year_2001 = year==2001
gen year_2002 = year==2002
gen year_2003 = year==2003
gen year_2004 = year==2004
gen year_2005 = year==2005
gen year_2006 = year==2006


* Month fixed effects
gen mon_1 = month==1
gen mon_2 = month==2
gen mon_3 = month==3
gen mon_4 = month==4
gen mon_5 = month==5
gen mon_6 = month==6
gen mon_7 = month==7
gen mon_8 = month==8
gen mon_9 = month==9
gen mon_10 = month==10
gen mon_11 = month==11
gen mon_12 = month==12

* State*Year fixed effects
gen fl_1994 = state_fl*year_1994
gen fl_1995 = state_fl*year_1995
gen fl_1996 = state_fl*year_1996
gen fl_2001 = state_fl*year_2001
gen fl_2002 = state_fl*year_2002
gen fl_2003 = state_fl*year_2003
gen fl_2004 = state_fl*year_2004
gen fl_2005 = state_fl*year_2005

gen ga_1999 = state_ga*year_1999
gen ga_2000 = state_ga*year_2000
gen ga_2001 = state_ga*year_2001

gen mo_1995 = state_mo*year_1995
gen mo_1996 = state_mo*year_1996
gen mo_1997 = state_mo*year_1997
gen mo_2004 = state_mo*year_2004
gen mo_2005 = state_mo*year_2005

gen mt_1994 = state_mt*year_1994
gen mt_1995 = state_mt*year_1995
gen mt_1996 = state_mt*year_1996

gen nc_1993 = state_nc*year_1993
gen nc_1994 = state_nc*year_1994
gen nc_1995 = state_nc*year_1995

gen ny_1998 = state_ny*year_1998
gen ny_1999 = state_ny*year_1999
gen ny_2000 = state_ny*year_2000

gen pa_1995 = state_pa*year_1995
gen pa_1996 = state_pa*year_1996
gen pa_1997 = state_pa*year_1997
gen pa_2001 = state_pa*year_2001
gen pa_2002 = state_pa*year_2002
gen pa_2003 = state_pa*year_2003
gen pa_2004 = state_pa*year_2004
gen pa_2005 = state_pa*year_2005
gen pa_2006 = state_pa*year_2006

gen postXrelease = post*release_recentered
gen dnaXrelease = dna_collected*release_recentered

*** ANALYSIS

global stateyear  "fl_1994 fl_1995 fl_1996 fl_2001 fl_2002 fl_2003 fl_2004 fl_2005 ga_1999 ga_2000 ga_2001 mo_1995 mo_1996 mo_1997 mo_2004 mo_2005 mt_1994 mt_1995 mt_1996 nc_1993 nc_1994 nc_1995 ny_1998 ny_1999 ny_2000 pa_1995 pa_1996 pa_1997 pa_2001 pa_2002 pa_2003 pa_2004 pa_2005 pa_2006"

** TABLE 3: First stage: The effect of Post-Expansion on DNA Requirement
	
	ivregress 2sls reoffend_5yrs release_recentered year_*  state_* $stateyear black race_missing age age_missing incarc1 ucrprop_ever murder_ever aggassault_ever sexassault_ever robbery_ever (dna_collected  = post ) if ucrviol_r & year<2007
	estat firststage
	reg dna_collected post  release_recentered year_*  state_* $stateyear black race_missing age age_missing incarc1 ucrprop_ever murder_ever aggassault_ever sexassault_ever robbery_ever  if ucrviol_r & year<2007

** TABLE 4: Effect of DNA Requirement on Recidivism to compare OLS and Fuzzy RD 

	** 3-year, OLS
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label replace
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear mon_* if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label append
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label append
	
	** 5-year, OLS
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label append
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear mon_* if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label append
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear mon_* black race_missing age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever if  ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_1.tex, se label append

	** 3-year, 2SLS
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label replace
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear mon_* (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label append
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label append
	
	** 5-year, 2SLS
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label append
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear mon_* (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label append
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear mon_* black race_missing age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_2.tex, se label append

** FIGURE 3: Raw data for Probability of DNA Requirement

	rdplot dna_collected release_recentered if ucrviol_r & year<2007, p(1) graph_options(title("Serious Violent Offenders") xtitle("Date of release") ytitle("Pr(DNA Required)")) binselect(esmvpr)
	gr save rdplot, replace 
	gr export rdplot.png, replace
	
/*** The paper uses `rdplot' that I've never seen before. 
It is preprogrammed by Calonico et al. to present graph using local polynomials, partitioning and spacing estimators. 
It plots the robust data discontinuity design for driving inference in the regression.
I would not represent this plot in the replication paper but it is helpful graph to interpret the relationship between 
the expansion date and DNA requirement. There is discontinuous in the date of release (threshold) on the probability of DNA required. 
The probability of DNA requirement increases from the right hand side of the threshold. We could catch the hugh gap between the 
treated and untreated based on the threshold. ***/
	
** (Robusteness Check) Table 5: Effect of DNA Requirement on Recidivism: Violent offenders
 	foreach j in murder sexassault aggassault robbery {
	ivregress 2sls reoffend_3yrs  release_recentered  $stateyear (dna_collected dnaXrelease = post postXrelease) if murder_ever & year<2007, vce(robust)
	ivregress 2sls reoffend_3yrs  release_recentered  $stateyear mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if `j'_ever & year<2007  , vce(robust)
	ivregress 2sls reoffend_5yrs  release_recentered  $stateyear (dna_collected dnaXrelease = post postXrelease) if murder_ever & year<2007, vce(robust)
	ivregress 2sls reoffend_5yrs  release_recentered  $stateyear mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if `j'_ever & year<2007, vce(robust)
	}
	
	save individual_analysis.dta, replace

 
clear

****** Aggregate level Estimation ******

use dna_stats.dta, clear
des
su
/*** Compared to the individual level of dataset, the aggregate level data comprises with 
enough explanation of each variables. It contains state, year, and crimes variable.
With the fixed restricted variable, I could learn how the paper extends the research topic
and conduct the estimation through creating new variables to answer the research questions. ***/

** Note: SDIS stats are per 10,000 residents. Change to per 100,000
replace sdis = sdis*10
replace ndis = ndis*10

gen post1999 = year>=1999

/*** The research restricts the expansion types into four categories: 
felony sex offenses, violent offenses, burglary and all others.
Thus, for the data management, they generates each treatment variables by expansion types. ***/

gen sex_f_cX1999 = sex_f_c*post1999
gen violent_f_cX1999 = violent_f_c*post1999
gen burglary_cX1999 = burglary_c*post1999
gen all_f_cX1999 = all_f_c*post1999

gen sex_f_iX1999 = sex_f_i*post1999
gen violent_f_iX1999 = violent_f_i*post1999
gen burglary_iX1999 = burglary_i*post1999
gen all_f_iX1999 = all_f_i*post1999

** Note: start year = 9999 if given category of offenders had not yet been added in that state
gen sex1999_duration = 0
replace sex1999_duration = year - sex_f_c_start if year>=1999
replace sex1999_duration = 0 if sex1999_duration<0
replace sex1999_duration = . if sex_f_cX1999==.

gen violent1999_duration = 0
replace violent1999_duration = year - violent_f_c_start if year>=1999
replace violent1999_duration = 0 if violent1999_duration<0

gen burglary1999_duration = 0
replace burglary1999_duration = year - burglary_c_start if year>=1999
replace burglary1999_duration = 0 if burglary1999_duration<0

gen all1999_duration = 0
replace all1999_duration = year - all_f_c_start if year>=1999
replace all1999_duration = 0 if all1999_duration<0

* Calculate relevant start date for "releasee" instrument below (lagged by expected time served)
	** Data on mean time served comes from the 1999 National Corrections Reporting Program: http://www.bjs.gov/index.cfm?ty=pbdetail&iid=2045
		* Rape: 69 months = 5.75 years
		* Murder: 87 months = 7.25 years
		* Robbery: 44 months = 3.67 years
		* Assault: 30 months = 2.5 years
			* Mean violent offense: (430*87 + 3312*44 + 1602*30)/(430+3312+1602) = 231,198/5344 = 43.3 months
		* Burglary: 29 months = 2.42 years
		* Larceny: 21 months = 1.75 years
		* V theft: 21 months = 1.75 years		
			* Mean other offense = (1572*21 + 514+21)/(1572+514) = 21 months

gen sex1999_duration_released = 0
replace sex1999_duration_released = year - sex_f_c_start + 5.75 if year>=1999
replace sex1999_duration_released = 0 if sex1999_duration_released<0
replace sex1999_duration_released = . if sex_f_cX1999==.

gen violent1999_duration_released = 0
replace violent1999_duration_released = year - violent_f_c_start + 3.6 if year>=1999
replace violent1999_duration_released = 0 if violent1999_duration_released<0

gen burglary1999_duration_released = 0
replace burglary1999_duration_released = year - burglary_c_start + 2.42 if year>=1999
replace burglary1999_duration_released = 0 if burglary1999_duration_released<0

gen all1999_duration_released = 0
replace all1999_duration_released = year - all_f_c_start +1.75 if year>=1999
replace all1999_duration_released = 0 if all1999_duration_released<0

replace ndis = 0 if sex_f_c==0
replace sdis = 0 if sex_f_c==0

reg sdis ndis if year>=2000
gen sdis1 = 168.0779+.9971228*ndis
replace sdis1 = sdis if sdis!=.

gen fips_st = 	.	
replace fips_st = 	1 if state ==	"Alabama"
replace fips_st =  	2 if state ==	"Alaska"
replace fips_st =  	4 if state ==	"Arizona"
replace fips_st = 	5 if state ==	"Arkansas"
replace fips_st = 	6 if state ==	"California"
replace fips_st = 	8 if state ==	"Colorado"
replace fips_st = 	9 if state ==	"Connecticut"
replace fips_st = 	10 if state ==	"Delaware"
replace fips_st = 	11 if state ==	"DC"
replace fips_st = 	12 if state ==	"Florida"
replace fips_st = 	13 if state ==	"Georgia"
replace fips_st = 	15 if state ==	"Hawaii"
replace fips_st = 	16 if state ==	"Idaho"
replace fips_st = 	17 if state ==	"Illinois"
replace fips_st = 	18 if state ==	"Indiana"
replace fips_st = 	19 if state ==	"Iowa"
replace fips_st = 	20 if state ==	"Kansas"
replace fips_st = 	21 if state ==	"Kentucky"
replace fips_st = 	22 if state ==	"Louisiana"
replace fips_st = 	23 if state ==	"Maine"
replace fips_st = 	24 if state ==	"Maryland"
replace fips_st = 	25 if state ==	"Massachusetts"
replace fips_st = 	26 if state ==	"Michigan"
replace fips_st = 	27 if state ==	"Minnesota"
replace fips_st = 	28 if state ==	"Mississippi"
replace fips_st = 	29 if state ==	"Missouri"
replace fips_st = 	30 if state ==	"Montana"
replace fips_st = 	31 if state ==	"Nebraska"
replace fips_st = 	32 if state ==	"Nevada"
replace fips_st = 	33 if state ==	"New Hampshire"
replace fips_st = 	34 if state ==	"New Jersey"
replace fips_st = 	35 if state ==	"New Mexico"
replace fips_st = 	36 if state ==	"New York"
replace fips_st = 	37 if state ==	"North Carolina"
replace fips_st = 	38 if state ==	"North Dakota"
replace fips_st = 	39 if state ==	"Ohio"
replace fips_st = 	40 if state ==	"Oklahoma"
replace fips_st = 	41 if state ==	"Oregon"
replace fips_st = 	42 if state ==	"Pennsylvania"
replace fips_st = 	44 if state ==	"Rhode Island"
replace fips_st = 	45 if state ==	"South Carolina"
replace fips_st = 	46 if state ==	"South Dakota"
replace fips_st = 	47 if state ==	"Tennessee"
replace fips_st = 	48 if state ==	"Texas"
replace fips_st = 	49 if state ==	"Utah"
replace fips_st = 	50 if state ==	"Vermont"
replace fips_st = 	51 if state ==	"Virginia"
replace fips_st = 	53 if state ==	"Washington"
replace fips_st = 	54 if state ==	"West Virginia"
replace fips_st = 	55 if state ==	"Wisconsin"
replace fips_st = 	56 if state ==	"Wyoming"

sort fips_st year
drop ndis sdis

merge fips_st year using crime_stats 
drop _merge
/*** The papers uses 2000 data from the State Court Processing Statistics to include the number of cleared offenses. ***/

sort fips_st
merge fips_st using crime1999
drop _merge
/*** It merges with 1999 National Corrections Reporting Program where convictions are lagged by the expected time served. ***/

sort fips_st
merge fips_st  using prison99
drop _merge

sort fips_st
merge fips_st  using prison99_natl
drop _merge

/*** I find out that the rates are all per 100,000 U.S. residents of all ages. 
This is important on the interpretation of crime rates later. ***/

** Estimate number of qualifying offenders of each type, based on each instrument definition
gen sdis_sim_cXdur_sex = qualsex_rate1999*sex1999_duration
gen sdis_sim_cXdur_viol = qualviolent_rate1999*violent1999_duration
gen sdis_sim_cXdur_burg = qualburg_rate1999*burglary1999_duration
gen sdis_sim_cXdur_all = qualall_rate1999*all1999_duration

gen sdis_sim_c_clearedXdur_sex = qualsex_cleared_rate1999*sex1999_duration
gen sdis_sim_c_clearedXdur_viol = qualviolent_cleared_rate1999*violent1999_duration
gen sdis_sim_c_clearedXdur_burg = qualburg_cleared_rate1999*burglary1999_duration
gen sdis_sim_c_clearedXdur_all = qualall_cleared_rate1999*all1999_duration

gen sdis_sim_c_convictXdur_sex = qualsex_convict_rate1999*sex1999_duration
gen sdis_sim_c_convictXdur_viol = qualviolent_convict_rate1999*violent1999_duration
gen sdis_sim_c_convictXdur_burg = qualburg_convict_rate1999*burglary1999_duration
gen sdis_sim_c_convictXdur_all = qualall_convict_rate1999*all1999_duration

gen sdis_sim_c_releasedXdur_sex = qualsex_convict_rate1999*sex1999_duration_released
gen sdis_sim_c_releasedXdur_viol = qualviolent_convict_rate1999*violent1999_duration_released
gen sdis_sim_c_releasedXdur_burg = qualburg_convict_rate1999*burglary1999_duration_released
gen sdis_sim_c_releasedXdur_all = qualall_convict_rate1999*all1999_duration_released

gen sdis_sim_c_clearedXdur_sex40 = qualsex_cleared40_rate1999*sex1999_duration
gen sdis_sim_c_clearedXdur_viol40 = qualviolent_cleared40_rate1999*violent1999_duration
gen sdis_sim_c_clearedXdur_burg40 = qualburg_cleared40_rate1999*burglary1999_duration
gen sdis_sim_c_clearedXdur_all40 = qualall_cleared40_rate1999*all1999_duration

gen sdis_sim_c_convictXdur_sex40 = qualsex_convict40_rate1999*sex1999_duration
gen sdis_sim_c_convictXdur_viol40 = qualviolent_convict40_rate1999*violent1999_duration
gen sdis_sim_c_convictXdur_burg40 = qualburg_convict40_rate1999*burglary1999_duration
gen sdis_sim_c_convictXdur_all40 = qualall_convict40_rate1999*all1999_duration

gen sdis_sim_c_releasedXdur_sex40 = qualsex_convict40_rate1999*sex1999_duration_released
gen sdis_sim_c_releasedXdur_viol40 = qualviolent_convict40_rate1999*violent1999_duration_released
gen sdis_sim_c_releasedXdur_burg40 = qualburg_convict40_rate1999*burglary1999_duration_released
gen sdis_sim_c_releasedXdur_all40 = qualall_convict40_rate1999*all1999_duration_released
		
gen sdis_sim_i_sex = 0
replace sdis_sim_i_sex = prison_rape_m+prison_rape_f+prison_othsex_m+prison_othsex_f if sex_f_iX1999==1
gen sdis_sim_i_viol = 0
replace sdis_sim_i_viol = prison_murder_m+prison_murder_f+prison_assault_m+prison_assault_f+prison_robbery_m+prison_robbery_f+prison_othviol_m+prison_othviol_f if violent_f_iX1999==1
gen sdis_sim_i_burg = 0
replace sdis_sim_i_burg = prison_burglary_m + prison_burglary_f if burglary_iX1999==1
gen sdis_sim_i_all = 0
replace sdis_sim_i_all = prison_larceny_m + prison_larceny_f + prison_vtheft_m + prison_vtheft_f + prison_fraud_m + prison_fraud_f + prison_othprop_m + prison_othprop_f + prison_drug_m + prison_drug_f + prison_oth_m + prison_oth_f if all_f_iX1999==1

** Take into account age profiles of offenders

	* Based on data from the 2000 State Court Processing Statistics
		* Murder: 86.72% of arrestees and 86.84% of convicts are under age 40
		* Rape: 79.01% of arrestees and 79.10% of convicts are under age 40
		* Assault: 79.30% of arrestees and 79.88% of convicts are under age 40
		* Robbery: 90.32% of arrestees and 94.14% of convicts are under age 40
			* Mean violent offense: 82.50% of arrestees and 84.31% of convicts are under age 40
		* Burglary: 83.69% of arrestees and 83.09% of convicts are under age 40
		* Larceny: 75.91% of arrestees and 73.06% of convicts are under age 40
		* Vtheft: 89.57% of arrestees and 92.02% of convicts are under age 40
			* Mean other offense = 79.55% of arrestees and 78.00% of convicts are under 40

gen sdis_sim_i_sex40 = 0
replace sdis_sim_i_sex40 = prison_rape_m*0.7910 +prison_rape_f*0.7910 +prison_othsex_m*0.7910 +prison_othsex_f*0.7910 if sex_f_iX1999==1
gen sdis_sim_i_viol40 = 0
replace sdis_sim_i_viol40 = prison_murder_m*0.8684 +prison_murder_f*0.8684 +prison_assault_m*0.7988 +prison_assault_f*0.7988+prison_robbery_m*0.9414 +prison_robbery_f*0.9414 +prison_othviol_m*0.8431 +prison_othviol_f*0.8431 if violent_f_iX1999==1
gen sdis_sim_i_burg40 = 0
replace sdis_sim_i_burg40 = prison_burglary_m*0.8309 + prison_burglary_f*0.8309 if burglary_iX1999==1
gen sdis_sim_i_all40 = 0
replace sdis_sim_i_all40 = prison_larceny_m*0.7306 + prison_larceny_f*0.7306 + prison_vtheft_m*0.9202 + prison_vtheft_f*0.9202 + prison_fraud_m*0.7800 + prison_fraud_f*0.7800 + prison_othprop_m*0.7800 + prison_othprop_f*0.7800 + prison_drug_m*0.7800 + prison_drug_f*0.7800 + prison_oth_m*0.7800 + prison_oth_f*0.7800 if all_f_iX1999==1

** Police officers per capita

merge 1:1 fips_st year using police
drop _merge

gen officers_percap = (officers_male + officers_female)*100000/population /* Data not reported from WV in 2008; use 2007 values instead */
sort fips_st year 
replace officers_percap = officers_percap[_n-1] if fips_st==54 & year==2008 & officers_percap==. 

/*** This part is important in this data analysis where the paper creates a simulated instrument
by predicting the number of profiles uploaded in each state and year. ***/ 
gen total_sim_profiles = sdis_sim_cXdur_sex + sdis_sim_cXdur_viol +  sdis_sim_cXdur_burg +  sdis_sim_cXdur_all +  sdis_sim_i_sex + sdis_sim_i_viol + sdis_sim_i_burg  + sdis_sim_i_all
gen total_sim_profiles_cleared = sdis_sim_c_clearedXdur_sex + sdis_sim_c_clearedXdur_viol +  sdis_sim_c_clearedXdur_burg +  sdis_sim_c_clearedXdur_all +  sdis_sim_i_sex + sdis_sim_i_viol + sdis_sim_i_burg  + sdis_sim_i_all
gen total_sim_profiles_convict = sdis_sim_c_convictXdur_sex + sdis_sim_c_convictXdur_viol +  sdis_sim_c_convictXdur_burg +  sdis_sim_c_convictXdur_all +  sdis_sim_i_sex + sdis_sim_i_viol + sdis_sim_i_burg  + sdis_sim_i_all
gen total_sim_profiles_cleared40 = sdis_sim_c_clearedXdur_sex40 + sdis_sim_c_clearedXdur_viol40 +  sdis_sim_c_clearedXdur_burg40 +  sdis_sim_c_clearedXdur_all40 +  sdis_sim_i_sex40 + sdis_sim_i_viol40 + sdis_sim_i_burg40  + sdis_sim_i_all40
gen total_sim_profiles_convict40 = sdis_sim_c_convictXdur_sex40 + sdis_sim_c_convictXdur_viol40 +  sdis_sim_c_convictXdur_burg40 +  sdis_sim_c_convictXdur_all40 +  sdis_sim_i_sex40 + sdis_sim_i_viol40 + sdis_sim_i_burg40  + sdis_sim_i_all40

* Calculate number of qualifying offenders who are released at each date (lagged by expected time served)
	** Data on mean time served comes from the 1999 National Corrections Reporting Program: http://www.bjs.gov/index.cfm?ty=pbdetail&iid=2045
		* Rape: 69 months = 5.75 years
		* Murder: 87 months = 7.25 years
		* Robbery: 44 months = 3.67 years
		* Assault: 30 months = 2.5 years
			* Mean violent offense: (430*87 + 3312*44 + 1602*30)/(430+3312+1602) = 231,198/5344 = 43.3 months = 3.6 years
		* Burglary: 29 months = 2.42 years
		* Larceny: 21 months = 1.75 years
		* V theft: 21 months = 1.75 years		
			* Mean other offense = (1572*21 + 514+21)/(1572+514) = 21 months = 1.75 years
			
* for incarcerated offenders, change start date to 2000 if < 2000
	replace sex_f_i_start = 2000 if sex_f_i_start<2000
	replace violent_f_i_start = 2000 if violent_f_i_start<2000
	replace burglary_i_start = 2000 if burglary_i_start<2000
	replace all_f_i_start = 2000 if all_f_i_start<2000

gen total_sim_profiles_released = sdis_sim_c_releasedXdur_sex + sdis_sim_c_releasedXdur_viol +  sdis_sim_c_releasedXdur_burg +  sdis_sim_c_releasedXdur_all 
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_sex/5.75 if (year - sex_f_i_start)<=5 & sex_f_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_sex*(1-5/5.75) if (year - sex_f_i_start)==6 & sex_f_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_viol/3.6 if (year - violent_f_i_start)<=3 & violent_f_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_viol*(1-3/3.6) if (year - violent_f_i_start)==4 & violent_f_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_burg/2.42 if (year - burglary_i_start)<=2 & burglary_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_burg*(1-2/2.42) if (year - burglary_i_start)==3 & burglary_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_all/1.75 if (year - all_f_i_start)<=1 & all_f_i_start!=9999
replace total_sim_profiles_released = total_sim_profiles_released + sdis_sim_i_all*(1-1/1.75) if (year - all_f_i_start)==2 & all_f_i_start!=9999

gen total_sim_profiles_released40 = sdis_sim_c_releasedXdur_sex40 + sdis_sim_c_releasedXdur_viol40 +  sdis_sim_c_releasedXdur_burg40 +  sdis_sim_c_releasedXdur_all40 
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_sex40/5.75 if (year - sex_f_i_start)<=5 & sex_f_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_sex40*(1-5/5.75) if (year - sex_f_i_start)==6 & sex_f_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_viol40/3.6 if (year - violent_f_i_start)<=3 & violent_f_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_viol40*(1-3/3.6) if (year - violent_f_i_start)==4 & violent_f_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_burg40/2.42 if (year - burglary_i_start)<=2 & burglary_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_burg40*(1-2/2.42) if (year - burglary_i_start)==3 & burglary_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_all40/1.75 if (year - all_f_i_start)<=1 & all_f_i_start!=9999
replace total_sim_profiles_released40 = total_sim_profiles_released40 + sdis_sim_i_all40*(1-1/1.75) if (year - all_f_i_start)==2 & all_f_i_start!=9999

gen totalcrime_rate = murder_rate + rape_rate + assault_rate + robbery_rate + burglary_rate + larceny_rate + vtheft_rate
gen violcrime_rate = murder_rate + rape_rate + assault_rate + robbery_rate 
gen propcrime_rate =  burglary_rate + larceny_rate + vtheft_rate

** Break into Census regions for region-specific year FEs
gen region1 = state=="Maine" | state=="Vermont" | state=="New Hampshire" | state=="Massachusetts" | state=="Rhode Island" | state=="Connecticut" | state=="New Jersey" | state=="Pennsylvania" | state=="New York" 
gen region2 = state=="Ohio" | state=="Michigan" | state=="Indiana" | state=="Wisconsin" | state=="Illinois" | state=="Missouri" | state=="Iowa" | state=="Minnesota" | state=="Kansas" | state=="Nebraska" | state=="South Dakota" | state=="North Dakota"
gen region3 = state=="Texas" | state=="Oklahoma" | state=="Arkansas" | state=="Louisiana" | state=="Mississippi" | state=="Alabama" | state=="Georgia" | state=="Florida" | state=="Tennessee"| state=="Kentucky"| state=="West Virginia"| state=="Delaware" | state=="Maryland" | state=="Virginia"| state=="DC"| state=="North Carolina"| state=="South Carolina" 
gen region4 = state=="Washington" | state=="Montana" | state=="Wyoming" | state=="Idaho" | state=="Oregon" | state=="California" | state=="Nevada" | state=="Utah" | state=="Arizona"  | state=="New Mexico"  | state=="Alaska" | state=="Hawaii"  
gen yearXreg1 = year*region1
gen yearXreg2 = year*region2
gen yearXreg3 = year*region3
gen yearXreg4 = year*region4


** FIGURE 6: Crime rates relative to date of violent convict expansion

gen eventyear_viol_c = 0 if violent_f_c_start==year 
sort state year
forvalues i = 1/30 {
by state: replace eventyear_viol_c = `i' if eventyear_viol_c[_n-1]==`i'-1
}

forvalues i = 1/30 {
by state: replace eventyear_viol_c = -`i' if eventyear_viol_c[_n+1]==-`i'+1
}

foreach i in viol prop {
foreach j in viol   {
egen `i'crime_rate_`j'c_neg5 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==-5
egen `i'crime_rate_`j'c_neg4 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==-4
egen `i'crime_rate_`j'c_neg3 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==-3
egen `i'crime_rate_`j'c_neg2 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==-2
egen `i'crime_rate_`j'c_neg1 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==-1
egen `i'crime_rate_`j'c_zero = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==0
egen `i'crime_rate_`j'c_pos1 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==1
egen `i'crime_rate_`j'c_pos2 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==2
egen `i'crime_rate_`j'c_pos3 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==3
egen `i'crime_rate_`j'c_pos4 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==4
egen `i'crime_rate_`j'c_pos5 = mean(`i'crime_rate) if state!="" & total_sim_profiles_convict!=. & eventyear_`j'_c==5

gen `i'crime_rate_`j'c = `i'crime_rate_`j'c_neg5 if eventyear_`j'_c==-5
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_neg4 if eventyear_`j'_c==-4
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_neg3 if eventyear_`j'_c==-3
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_neg2 if eventyear_`j'_c==-2
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_neg1 if eventyear_`j'_c==-1
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_zero if eventyear_`j'_c==0
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_pos1 if eventyear_`j'_c==1
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_pos2 if eventyear_`j'_c==2
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_pos3 if eventyear_`j'_c==3
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_pos4 if eventyear_`j'_c==4
replace `i'crime_rate_`j'c = `i'crime_rate_`j'c_pos5 if eventyear_`j'_c==5
}
}
*** Still, I could not understand the figure where the range of crime rates is integer. This comes from the problem where the researcher does not convert 
*** the rate of crime on the percentage. I would rather modify the graph in the crime rates instead of integers in the y-axis. 

gen pviolcrime_rate = violcrime_rate/1000
gen pviolcrime_rate_violc = violcrime_rate_violc/1000
gen ppropcrime_rate = propcrime_rate/1000
gen ppropcrime_rate_violc = propcrime_rate_violc/1000

twoway (lpoly pviolcrime_rate eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=-5 & eventyear_viol_c<=0, xtitle("Year relative to expansion") ytitle("Crime Rate") title("Violent Crime")) /// 
(lpoly pviolcrime_rate eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=0 & eventyear_viol_c<=5) ///
(scatter pviolcrime_rate_violc eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=-5 & eventyear_viol_c<=5), legend(off)
gr save violcrime_rate_1, replace
twoway (lpoly ppropcrime_rate eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=-5 & eventyear_viol_c<=0, xtitle("Year relative to expansion") ytitle("Crime Rate") title("Property Crime")) ///
(lpoly ppropcrime_rate eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=0 & eventyear_viol_c<=5) ///
(scatter ppropcrime_rate_violc eventyear_viol_c if state!="" & total_sim_profiles_convict!=. & eventyear_viol_c>=-5 & eventyear_viol_c<=5), legend(off)
gr save violcrime_rate_2, replace
gr combine violcrime_rate_1.gph violcrime_rate_2.gph
gr export crime_com.png, replace

** TABLE 8
ivregress 2sls violcrime_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict) if year>=2000,  cluster(fips_st)
estat firststage, all
reg sdis1 total_sim_profiles_convict  i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap  if year>=2000,  cluster(fips_st)

** TABLE 9

fvset base 13 fips_st
fvset base 2003 year

foreach i in violcrime propcrime murder rape assault robbery burglary larceny vtheft  {

eststo: quietly reg  `i'_rate sdis1 officers_percap i.fips_st i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 if year>=2000 & total_sim_profiles_cleared!=., cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_cleared) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_cleared40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_released) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_released40) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)

esttab using `i'_sim.tex, title(`i' per Capita) label star(* .10 ** .05 *** .01) keep(sdis1) cells(b(fmt(4) star) se(fmt(4) par))  replace r2 se 
eststo clear
}

**** Extension 


** TABLE 8
ivregress 2sls violcrime_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict) if year>=2000,  cluster(fips_st)
estat firststage, all
reg sdis1 total_sim_profiles_convict  i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap  if year>=2000,  cluster(fips_st)

** TABLE 9

fvset base 13 fips_st
fvset base 2003 year

foreach i in violcrime propcrime murder rape assault robbery burglary larceny vtheft  {

eststo: quietly reg  `i'_rate sdis1 officers_percap i.fips_st i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 if year>=2000 & total_sim_profiles_cleared!=., cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_cleared) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_cleared40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_convict40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_released) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap (sdis1 =  total_sim_profiles_released40) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)

esttab using `i'_sim.tex, title(`i' per Capita) label star(* .10 ** .05 *** .01) keep(sdis1) cells(b(fmt(4) star) se(fmt(4) par))  replace r2 se 
eststo clear
}

save state_analysis.dta, replace

**** Additional Part I've included with the air quality index

cd "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/aqi"

forvalue i = 1999/2010 {
import delimited /Users/stellachoi/Downloads/annual_aqi_by_county_`i'.csv, clear 

gen fips_st = 	.	
replace fips_st = 	1 if state ==	"Alabama"
replace fips_st =  	2 if state ==	"Alaska"
replace fips_st =  	4 if state ==	"Arizona"
replace fips_st = 	5 if state ==	"Arkansas"
replace fips_st = 	6 if state ==	"California"
replace fips_st = 	8 if state ==	"Colorado"
replace fips_st = 	9 if state ==	"Connecticut"
replace fips_st = 	10 if state ==	"Delaware"
replace fips_st = 	11 if state ==	"DC"
replace fips_st = 	12 if state ==	"Florida"
replace fips_st = 	13 if state ==	"Georgia"
replace fips_st = 	15 if state ==	"Hawaii"
replace fips_st = 	16 if state ==	"Idaho"
replace fips_st = 	17 if state ==	"Illinois"
replace fips_st = 	18 if state ==	"Indiana"
replace fips_st = 	19 if state ==	"Iowa"
replace fips_st = 	20 if state ==	"Kansas"
replace fips_st = 	21 if state ==	"Kentucky"
replace fips_st = 	22 if state ==	"Louisiana"
replace fips_st = 	23 if state ==	"Maine"
replace fips_st = 	24 if state ==	"Maryland"
replace fips_st = 	25 if state ==	"Massachusetts"
replace fips_st = 	26 if state ==	"Michigan"
replace fips_st = 	27 if state ==	"Minnesota"
replace fips_st = 	28 if state ==	"Mississippi"
replace fips_st = 	29 if state ==	"Missouri"
replace fips_st = 	30 if state ==	"Montana"
replace fips_st = 	31 if state ==	"Nebraska"
replace fips_st = 	32 if state ==	"Nevada"
replace fips_st = 	33 if state ==	"New Hampshire"
replace fips_st = 	34 if state ==	"New Jersey"
replace fips_st = 	35 if state ==	"New Mexico"
replace fips_st = 	36 if state ==	"New York"
replace fips_st = 	37 if state ==	"North Carolina"
replace fips_st = 	38 if state ==	"North Dakota"
replace fips_st = 	39 if state ==	"Ohio"
replace fips_st = 	40 if state ==	"Oklahoma"
replace fips_st = 	41 if state ==	"Oregon"
replace fips_st = 	42 if state ==	"Pennsylvania"
replace fips_st = 	44 if state ==	"Rhode Island"
replace fips_st = 	45 if state ==	"South Carolina"
replace fips_st = 	46 if state ==	"South Dakota"
replace fips_st = 	47 if state ==	"Tennessee"
replace fips_st = 	48 if state ==	"Texas"
replace fips_st = 	49 if state ==	"Utah"
replace fips_st = 	50 if state ==	"Vermont"
replace fips_st = 	51 if state ==	"Virginia"
replace fips_st = 	53 if state ==	"Washington"
replace fips_st = 	54 if state ==	"West Virginia"
replace fips_st = 	55 if state ==	"Wisconsin"
replace fips_st = 	56 if state ==	"Wyoming"

collapse (mean) medianaqi daysco daysno2 daysozone daysso2 dayspm25 dayspm10, by(fips_st)

gen year = `i'
save aqi`i'.dta, replace
}

forvalue i = 1999/2009 {
append using aqi`i'.dta
}
tab year

save "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2/aqi.dta", replace

/*** analysis with including air quality index state and year level on the aggregate crime rate ***/ 
cd "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2"
use state_analysis.dta, clear 
merge m:1 fips_st year using aqi.dta 
drop _merge

global aqi daysco daysno2 daysozone daysso2 dayspm25 dayspm10

fvset base 13 fips_st
fvset base 2003 year

foreach i in violcrime propcrime murder {

eststo: quietly reg `i'_rate sdis1 officers_percap $aqi  i.fips_st i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 if year>=2000 & total_sim_profiles_cleared!=., cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_cleared) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_cleared40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_convict) if year>=2000,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_convict40) if year>=2000,  cluster(fips_st)

eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_released) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)
eststo: quietly ivregress 2sls `i'_rate i.yearXreg1 i.yearXreg2 i.yearXreg3 i.yearXreg4 i.fips_st officers_percap $aqi (sdis1 =  total_sim_profiles_released40) if year>=2000 & total_sim_profiles_convict!=.,  cluster(fips_st)

esttab using `i'_sim_aqi.tex, title(`i' per Capita) label star(* .10 ** .05 *** .01) keep(sdis1) cells(b(fmt(4) star) se(fmt(4) par))  replace r2 se 
eststo clear
}

save analysis_aqi.dta, replace

/*** analysis with including air quality index weekly and year level on the individual crime rate ***/ 

cd "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/aqi"

forvalue i = 1994/2001 {
import delimited /Users/stellachoi/Downloads/daily_42602_`i'.csv, clear
drop if statecode > 56
gen date = date(datelocal, "YMD")
format date %td
gen woy = week(date) 
gen year = year(date)
collapse (mean) aqi, by(statecode year woy)
rename statecode fips_st
save "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2/week_aqi`i'.dta", replace
}


forvalue i = 2002/2005 {
import delimited /Users/stellachoi/Downloads/daily_42602_`i'.csv, clear
destring statecode, gen(fips_st) force
drop if fips_st > 56
gen date = date(datelocal, "YMD")
format date %td
gen woy = week(date) 
gen year = year(date)
collapse (mean) aqi, by(fips_st year woy)
save "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2/week_aqi`i'.dta", replace
}

forvalue i = 1994/2004 {
append using "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2/week_aqi`i'.dta"
}
keep if fips_st == 12 | fips_st == 13 | fips_st == 29 | fips_st == 30| fips_st == 36 | fips_st == 37 | fips_st == 42
save "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2/week_aqi.dta", replace


*** Laptop
cd "/Users/stellachoi/Google Drive/2. Second Year/5.Applied_microeconometrics/replication/Data 2"
use individual_analysis.dta, clear

gen fips_st = 	.	
replace fips_st = 	12 if state ==	"FL"
replace fips_st = 	13 if state ==	"GA"
replace fips_st = 	29 if state ==	"MO"
replace fips_st = 	30 if state ==	"MT"
replace fips_st = 	36 if state ==	"NY"
replace fips_st = 	37 if state ==	"NC"
replace fips_st = 	42 if state ==	"PA"

merge m:m fips_st using week_aqi.dta
drop _merge

** TABLE 4: Effect of DNA Requirement on Recidivism to compare OLS and Fuzzy RD 

	** 3-year, OLS
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear aqi if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label replace
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear aqi mon_* if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label append
	reg reoffend_3yrs  post postXrelease release_recentered $stateyear aqi mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label append
	
	** 5-year, OLS
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear aqi if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label append
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear aqi mon_* if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label append
	reg reoffend_5yrs  post postXrelease release_recentered $stateyear aqi mon_* black race_missing age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever if  ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_3.tex, se label append

	** 3-year, 2SLS
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear aqi (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label replace
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear aqi mon_* (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label append
	ivregress 2sls reoffend_3yrs  release_recentered $stateyear aqi mon_* black race_missing  age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label append
	
	** 5-year, 2SLS
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear aqi (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label append
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear aqi mon_* (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label append
	ivregress 2sls reoffend_5yrs  release_recentered $stateyear aqi mon_* black race_missing age age_missing incarc1 murder_ever sexassault_ever robbery_ever aggassault_ever ucrprop_ever (dna_collected dnaXrelease = post postXrelease) if ucrviol_r & year<2007, vce(robust)
	outreg2 using result4_4.tex, se label append
	
	** Plot the probability of DNA rquirement based on the threshold
	rdplot dna_collected release_recentered if ucrviol_r & year<2007, p(1) graph_options(title("Serious Violent Offenders") xtitle("Date of release") ytitle("Pr(DNA Required)")) binselect(esmvpr)
	gr save rdplot1, replace 
	gr export rdplot1.png, replace
	
	*** Serious violent offenders 
	reg reoffend_5yrs state_* aqi black race_missing age age_missing incarc1 burglary_ever larceny_ever vtheft_ever arson_ever ucrviol_r_ever if ucrprop & year<2007, vce(robust)
	predict reoff_5yrs_hat if ucrprop & year<2007
	ttest reoff_5yrs_hat if ucrprop & year<2007, by(post)

	reg reoffend_3yrs state_* aqi black race_missing age age_missing incarc1 burglary_ever larceny_ever vtheft_ever arson_ever ucrviol_r_ever if ucrprop & year<2007, vce(robust)
	predict reoff_3yrs_hat if ucrprop & year<2007
	ttest reoff_3yrs_hat if ucrprop & year<2007, by(post)

	** graph residuals:
	gen resid_5yrs = reoffend_5yrs - reoff_5yrs_hat if ucrprop & year<2007
	rdplot resid_5yrs release_recentered if ucrprop & year<2007, p(1) graph_options(title("Serious Property Offenders") xtitle("Date of release") ytitle("Recidivism - Pr(Recidivism)")) binselect(esmvpr)
	graph save resid_5yrs_1, replace	
	graph export resid_5yrs_1.png, replace
	
save individual_analysis_1.dta, replace

 
capture log close
