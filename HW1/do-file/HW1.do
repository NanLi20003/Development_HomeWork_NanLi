*********************************
* Development Homework 1 ********

/*
1. Consumption:
use consumption.do to calculate data, the result is similar to the aggeragate data
in the dataset, so I decide to use the given variable.
2. Income

*/

* household size
use "D:\CEMFI\Development\HW1\Data\GSEC3.dta", clear
gen number = 1
collapse (sum) number, by(HHID)
label variable number "Number of people in the household"
save "D:\CEMFI\Development\HW1\Data\hhn.dta",replace

* compare household size
use "D:\CEMFI\Development\HW1\Data\UNPS 2013-14 Consumption Aggregate.dta", clear
duplicates drop HHID,force
merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\hhn.dta"
summarize number hsize

keep HHID number hsize
save "D:\CEMFI\Development\HW1\Data\hhn.dta",replace


* head of household information
use "D:\CEMFI\Development\HW1\Data\GSEC2.dta", clear
duplicates report HHID
keep if h2q4==1
keep h2q3 h2q8 HHID PID
rename h2q8 age
rename h2q3 sex

duplicates drop HHID, force
save "D:\CEMFI\Development\HW1\Data\Head_infor.dta",replace	 



***problem 1 ****

use "D:\CEMFI\Development\HW1\Data\GSEC1.dta", clear

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\wealth.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\consumption.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\income.dta"
drop _merge
drop hh

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\hhn.dta"

save "D:\CEMFI\Development\HW1\Data\CIWtotal.dta",replace


keep if wealth !=. & nexp_d !=.
summarize nexp_d cpexp_d consumption consumption1 nondurable_consum


* report the average CIW in household level for rural level
summarize consumption1 income wealth
summarize consumption1 income wealth if urban == 1
summarize consumption1 income wealth if urban == 0


* report inequality CIW 
/*
gen consumption1_capita = consumption1/hsize
gen nondurable_capita = nondurable_consum/hsize
gen cpexp_capita = cpexp_d/hsize
gen consumption_capita = consumption/hsize
gen nexp_capita = nexp_d/hsize
gen income_capita = income/hsize
gen wealth_capita = wealth/hsize
*/

gen lnexp_d = log(nexp_d)  
gen lcpexp_d = log(cpexp_d)
gen lconsumption = log(consumption)
gen lconsumption1 = log(consumption1)
gen lnondurable_consum = log(nondurable_consum)

/*
gen lnexp_c = log(nexp_capita)  
gen lcpexp_c = log(cpexp_capita)
gen lconsumption_c = log(consumption1_capita)
gen lconsumption1_c = log(consumption1)
gen lnondurable_c = log(nondurable_capita)
*/
centile income, centile(1 99)
drop if income >= 6.22e+07 | income <= -1480405

summarize income
egen income_min = min(income)
gen income_a = income - income_min

gen lincome = log(income_a)
gen lwealth = log(wealth)

egen lconsumption_sd = std(lconsumption1)
egen lincome_sd = std(lincome)
egen lwealth_sd = std(lwealth)

drop if lincome_sd ==.  // drop 62

twoway (histogram lconsumption_sd if urban == 0, color(ebg))(histogram lconsumption_sd if urban == 1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("Consumption (in Ushs)") saving (consumption2.gph)
twoway (histogram lincome_sd if urban == 0, color(ebg))(histogram lincome_sd if urban == 1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("Income (in Ushs)") saving (income2.gph)
twoway (histogram lwealth_sd if urban == 0, color(ebg))(histogram lwealth_sd if urban == 1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("Wealth (in Ushs)") saving (wealth2.gph)
gr combine consumption2.gph income2.gph wealth2.gph
graph export "D:\CEMFI\Development\HW1\results\1_1.png", as(png) replace

summarize lconsumption1 lincome	lwealth   
summarize lconsumption1 lincome	lwealth if urban == 1
summarize lconsumption1 lincome	lwealth if urban == 0

* correlation
correlate consumption1 income wealth
correlate consumption1 income wealth if urban ==0
correlate consumption1 income wealth if urban ==1
save "D:\CEMFI\Development\HW1\Data\CIWtotal.dta",replace

* lifecycle
/*drop _merge
merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\Head_infor.dta"

keep if _merge==3
drop _merge
save "D:\CEMFI\Development\HW1\Data\CIWtotal.dta",replace

* full 
use "D:\CEMFI\Development\HW1\Data\CIWtotal.dta", clear
collapse (mean) consumption1 income wealth, by(age)

summarize consumption1 if age==25
egen c_sd = sd(consumption)
gen c_25 = 4721397
gen c_s = (consumption1-c_25)/c_sd + 1

summarize income if age==25
egen i_sd = sd(income)
gen i_25 = 5039190
gen i_s = (income-i_25)/i_sd + 1

summarize wealth if age==25
gen w_25 = 3886341
egen w_sd = sd(wealth)
gen w_s = (wealth-w_25)/w_sd + 1

keep age c_s i_s w_s
save "D:\CEMFI\Development\HW1\Data\lifecycle1.dta"，replace

* rural 
use "D:\CEMFI\Development\HW1\Data\CIWtotal.dta", clear
keep if urban == 0
collapse (mean) consumption1 income wealth, by(age) 

summarize consumption1 if age==25
egen c_sd = sd(consumption)
gen c_25 = 3671380
gen c_s = (consumption1-c_25)/c_sd + 1
summarize income if age==25
egen i_sd = sd(income)
gen i_25 =  3700221
gen i_s = (income-i_25)/i_sd + 1
summarize wealth if age==25
gen w_25 = 3267719
egen w_sd = sd(wealth)
gen w_s = (wealth-w_25)/w_sd + 1
keep age c_s i_s w_s
rename c_s cr_s
rename i_s ir_s
rename w_s wr_s
save "D:\CEMFI\Development\HW1\Data\lifecycle2.dta"，replace

* urban 
use "D:\CEMFI\Development\HW1\Data\CIWtotal.dta", clear
keep if urban == 1
collapse (mean) consumption1 income wealth, by(age) 
summarize consumption1 if age==25
egen c_sd = sd(consumption)
gen c_25 = 6931959
gen c_s = (consumption1-c_25)/c_sd + 1
summarize income if age==25
egen i_sd = sd(income)
gen i_25 =  7858072
gen i_s = (income-i_25)/i_sd + 1
summarize wealth if age==25
gen w_25 =  5188705
egen w_sd = sd(wealth)
gen w_s = (wealth-w_25)/w_sd + 1
keep age c_s i_s w_s
rename c_s cu_s
rename i_s iu_s
rename w_s wu_s
save "D:\CEMFI\Development\HW1\Data\lifecycle3.dta", replace

* merge
merge 1:1 age using "D:\CEMFI\Development\HW1\Data\lifecycle1.dta"
drop _merge

merge 1:1 age using "D:\CEMFI\Development\HW1\Data\lifecycle2.dta"
drop _merge

*/

** top and bottom ***
use "D:\CEMFI\Development\HW1\Data\CIWtotal.dta", clear

egen rank = rank(income) 

egen i_total = sum(income)
egen c_total = sum(consumption1)
egen w_total = sum(wealth)

egen c_total_l = sum(consumption1) if rank<= 3047*0.05
egen w_total_l = sum(wealth) if rank<= 3047*0.05
egen i_total_l = sum(income) if rank<= 3047*0.05

egen c_total_h = sum(consumption1) if rank>= 3047*0.95
egen w_total_h = sum(wealth) if rank >= 3047*0.95
egen i_total_h = sum(income) if rank >= 3047*0.95



****************************************************************
*** problem 2 ****

use "D:\CEMFI\Development\HW1\Data\labordata.dta",clear
duplicates report PID	
duplicates drop PID, force
save "D:\CEMFI\Development\HW1\Data\labordata.dta",replace

use "D:\CEMFI\Development\HW1\Data\GSEC2.dta",clear
duplicates report PID
duplicates drop PID, force  

merge 1:1 PID using "D:\CEMFI\Development\HW1\Data\labordata.dta"
drop _merge

keep if h2q8 >= 15
gen Work_7_a = 0
replace Work_7_a = 1 if Work_7 == 1
gen Work_12_a = 0
replace Work_12_a = 1 if Work_12 == 1

save "D:\CEMFI\Development\HW1\Data\labor.dta",replace

use "D:\CEMFI\Development\HW1\Data\GSEC4.dta",clear
duplicates report PID
duplicates drop PID, force  
keep PID h4q7
rename h4q7 education_level

merge 1:1 PID using "D:\CEMFI\Development\HW1\Data\labor.dta"
drop if _merge==1
drop _merge

merge m:1 HHID using "D:\CEMFI\Development\HW1\Data\GSEC1.dta"
keep if _merge==3

save "D:\CEMFI\Development\HW1\Data\labor.dta",replace

**1） average
summarize thour Work_7_a Work_12_a
summarize thour Work_7_a Work_12_a if urban ==0
summarize thour Work_7_a Work_12_a if urban ==1

summarize Work_7_a Work_12_a if urban == 0 & sex ==1
summarize Work_7_a Work_12_a if urban == 0 & sex ==2
summarize Work_7_a Work_12_a if urban == 1 & sex ==1
summarize Work_7_a Work_12_a if urban == 1 & sex ==2

gen thour_a= thour if thour >0
twoway (histogram thour if urban == 0, color(ebg))(histogram thour if urban == 1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("average work hours per week") saving (thour.gph)
twoway (histogram thour_a if urban == 0, color(ebg))(histogram thour_a if urban == 1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("average work hours per week") saving (thour_a.gph)


twoway (histogram thour_a if urban == 0 & sex ==1, color(ebg))(histogram thour_a if urban == 1 & sex ==1, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("average work hours per week (Male)") saving (thour_m.gph)
twoway (histogram thour_a if urban == 0 & sex ==2, color(ebg))(histogram thour_a if urban == 1 & sex ==2, color(red) fcolor(none)),legend(order(1 "Rural" 2 "Urban"))xtitle("average work hours per week (Female)") saving (thour_f.gph)
gr combine thour.gph thour_a.gph thour_m.gph thour_f.gph
graph export "D:\CEMFI\Development\HW1\results\thourf.eps", as(eps) preview(off) replace


**** 3. by district ****
collapse (mean) Work_7_a Work_12_a thour , by(ea)
save "D:\CEMFI\Development\HW1\Data\district1.dta",replace


use "D:\CEMFI\Development\HW1\Data\CIWtotal.dta", clear
clearcollapse (mean) consumption1 income wealth, by(ea)
merge 1:1 ea using "D:\CEMFI\Development\HW1\Data\district1.dta"
drop _merge
save "D:\CEMFI\Development\HW1\Data\district.dta",replace

summarize consumption1 income wealth
gen lconsumption = log(consumption)
gen lincome = log(income)
gen lwealth = log(wealth)
egen lconsumption_sd = std(lconsumption)
egen lincome_sd = std(lincome)
egen lwealth_sd = std(lwealth)

twoway scatter lconsumption_sd lincome_sd, legend(order(1 "Rural" 2 "Urban")) xtitle("Consumption inequality by districts") saving(d11.gph )
twoway scatter lwealth_sd lincome_sd ,legend(order(1 "Rural" 2 "Urban")) xtitle("Wealth inequality by districts") saving(d61.gph )

twoway scatter Work_7_a lincome_sd ,legend(order(1 "Rural" 2 "Urban")) xtitle("Employment rate (7 days) inequality by districts") saving(d31.gph )
twoway scatter Work_12_a lincome_sd ,legend(order(1 "Rural" 2 "Urban")) xtitle("Employment rate (12 months)inequality by districts") saving(d41.gph )
twoway scatter thour lincome_sd ,legend(order(1 "Rural" 2 "Urban"))xtitle("Average work time per week inequality by districts") saving(d51.gph )

gr combine d11.gph d61.gph d31.gph d41.gph d51.gph

graph export "D:\CEMFI\Development\HW1\results\inequality.eps", as(eps) preview(off) replace

save "D:\CEMFI\Development\HW1\Data\district.dta",replace
