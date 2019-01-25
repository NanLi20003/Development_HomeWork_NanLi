***************************************
*-------------- Income ---------------*

/* 
Income includes
Agricultural net production: crop, livestock sales, and livestock products sales
Labor market income:
Business income:
Capital income:
Transfer: 
*/


**** Agriculture income ****
* use agrincome.do

**** Labor income ****
use "D:\CEMFI\Development\HW1\Data\labordata.dta",clear
collapse (sum) tlaborincome, by (HHID)

save "D:\CEMFI\Development\HW1\Data\labor_inc.dta",replace

**** Business Income ****
use "D:\CEMFI\Development\HW1\Data\gsec12.dta", clear
rename hhid HHID

summarize h12q12 h12q13 h12q15 h12q16 h12q17 h12q13
gen Busi_inc = h12q13 - h12q15 -h12q16 -h12q17
gen busi_inc = Busi_inc * h12q12
collapse (sum) busi_inc, by (HHID)
label variable  busi_inc  "annual business income (in Shs)"
save "D:\CEMFI\Development\HW1\Data\business.dta",replace


**** capital income *****
use "D:\CEMFI\Development\HW1\Data\GSEC11A.dta", clear
summarize h11q1
drop h11q1

append using  "D:\CEMFI\Development\HW1\Data\GSEC11B.dta"
summarize h11q5 h11q6

replace h11q6=0 if h11q6==. & h11q5 !=.
replace h11q5=0 if h11q5==. & h11q6 !=.
gen transfer_p = h11q5 + h11q6 if h11q2 ==42 |h11q2 ==43 |h11q2 ==45
gen capital_inc = h11q5 + h11q6 if h11q2 !=42 &h11q2 !=43 &h11q2 !=45
summarize h11q6 h11q5 transfer_p capital_inc

collapse (sum) transfer_p capital_inc, by (HHID)
label variable transfer_p "Part of transfer from section 11"
label variable capital_inc "capital income annual"

save "D:\CEMFI\Development\HW1\Data\capital_inc.dta",replace

**** Transfer ****

** good gifts **  
use "D:\CEMFI\Development\HW1\Data\GSEC15B.dta", clear
collapse (sum) h15bq11, by (HHID)
rename h15bq11 food_t
replace food_t= food_t*52
save "D:\CEMFI\Development\HW1\Data\food_t.dta",replace

use "D:\CEMFI\Development\HW1\Data\GSEC15C.dta" , clear
collapse (sum) h15cq9, by (HHID)
rename h15cq9 nondurable_t
replace nondurable_t= nondurable_t*12
save "D:\CEMFI\Development\HW1\Data\nondurable_t.dta",replace

use "D:\CEMFI\Development\HW1\Data\GSEC15D.dta" , clear
collapse (sum) h15dq5, by (HHID)
rename h15dq5 durable_t
save "D:\CEMFI\Development\HW1\Data\durable_t.dta",replace


** LiveStock income  Transfer **
use "D:\CEMFI\Development\HW1\Data\livestock1.dta",clear

merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\livestock2.dta"
drop _merge

merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\livestock3.dta"
drop _merge

egen LiveStock_sale = rowtotal(LiveStock_sell1 LiveStock_sell2 LiveStock_sell3)
egen LiveStock_transfer = rowtotal(LiveStock_transfer1 LiveStock_transfer2 LiveStock_transfer3)
egen LiveStock_buy = rowtotal(LiveStock_buy1 LiveStock_buy2 LiveStock_buy3)

label variable LiveStock_sale "Total estimated value from selling LiveStock"
label variable LiveStock_transfer "Total estimated value from  LiveStock transfer"
label variable LiveStock_buy "Total estimated value from buying LiveStock"

save "D:\CEMFI\Development\HW1\Data\livestock_inc.dta",replace


************************************************
use "D:\CEMFI\Development\HW1\Data\agri_inc.dta",clear
keep HHID agri_inc

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\labor_inc.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\business.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\capital_inc.dta"
drop _merge

gen hh = HHID
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\livestock_inc.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\food_t.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\nondurable_t.dta"
drop _merge

merge 1:1 HHID using "D:\CEMFI\Development\HW1\Data\durable_t.dta"
drop _merge

egen income = rowtotal( agri_inc tlaborincome busi_inc transfer_p capital_inc LiveStock_transfer food_t nondurable_t durable_t)
label variable income "Total income last year"
summarize income
keep HHID hh income

save "D:\CEMFI\Development\HW1\Data\income.dta",replace


