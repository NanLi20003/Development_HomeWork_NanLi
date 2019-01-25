*****************************************

*****************************************

* Agriculture income (net):
* agriculture production + livestock production - costs

*****************************************
* 1. agriculture production: 2 seasons
*
*		prices: GSEC15B - itmcd (id) h15bq12 (market price)
*
*		using the sold price:
*			AGSEC5A - a5aq8 (total value)
*			AGSEC5A - a5aq7a (quantity sold)
*			priceA = a5aq8 / a5aq7a 
*			*Note that the unit is the same as measurement for harvest
*
*			AGSEC5B - a5bq8 (total value)
*			AGSEC5B - a5bq7a (quantity sold)
*			priceB = a5bq8 / a5bq7a
*
*		SEASON 1: AGSE5A - a5aq6a * priceA
*		SEASON 2: AGSE5B - a5bq6a * priceB
*

use "D:\CEMFI\Development\HW1\Data\AGSEC5A.dta",clear
keep hh cropID a5aq8 a5aq7a a5aq6a
preserve
collapse (sum)a5aq8 a5aq7a, by (cropID)
gen priceA = a5aq8/a5aq7a
* This is the selling price of crop avereaged over all sales
save "D:\CEMFI\Development\HW1\Data\priceA.dta", replace
restore
merge m:1 cropID using "D:\CEMFI\Development\HW1\Data\priceA.dta"
gen agr_prodA = priceA * a5aq6a
collapse (sum) agr_prodA, by (hh)
save "D:\CEMFI\Development\HW1\Data\agr_prodA.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC5B.dta"
keep hh cropID a5bq8 a5bq7a a5bq6a
preserve
collapse (sum)a5bq8 a5bq7a, by (cropID)
gen priceB = a5bq8/a5bq7a
* This is the selling price of crop avereaged over all sales
save "D:\CEMFI\Development\HW1\Data\priceB.dta", replace
restore
merge m:1 cropID using "D:\CEMFI\Development\HW1\Data\priceB.dta"
drop _merge
gen agr_prodB = priceB * a5bq6a
collapse (sum) agr_prodB, by (hh)
save "D:\CEMFI\Development\HW1\Data\agr_prodB.dta", replace

merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\agr_prodA.dta"
egen agr_prod = rowtotal(agr_prodA agr_prodB)
save "D:\CEMFI\Development\HW1\Data\agr_prod.dta", replace

*****************************************
* 2. Agriculture costs:
*		SEASON1: AGSE3A/4A/5A
*			organic fertilizer - a3aq8
*			chemical - a3aq18
*			pesticides - a3aq27
*			hired labor - a3aq36
*			seed - a4aq15
*			transport - a5aq10
*			
*		SEASON2: AGSE3B/4B/5B
*			organic fertilizer - a3bq8
*			chemical - a3bq18
*			pesticides - a3bq27
*			hired labor - a3bq36
*			seed - a4bq15
*			transport - a5bq10
*		
*		rent - a2bq9 (2 seasons)

use "D:\CEMFI\Development\HW1\Data\AGSEC3A.dta" , clear
collapse (sum)a3aq8 a3aq18 a3aq27 a3aq36, by (hh)
save "D:\CEMFI\Development\HW1\Data\inputs.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC4A.dta" , clear
collapse (sum)a4aq15, by (hh)
save "D:\CEMFI\Development\HW1\Data\seed.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC5A.dta" , clear
collapse (sum)a5aq10, by (hh)
save "D:\CEMFI\Development\HW1\Data\transport.dta",replace

use "D:\CEMFI\Development\HW1\Data\inputs.dta" , clear
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\seed.dta"
drop _merge 
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\transport.dta"
drop _merge
save "D:\CEMFI\Development\HW1\Data\agrcost_1.dta",replace


use "D:\CEMFI\Development\HW1\Data\AGSEC3B.dta" , clear
collapse (sum)a3bq8 a3bq18 a3bq27 a3bq36, by (hh)
save "D:\CEMFI\Development\HW1\Data\inputsB.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC4B.dta" , clear
collapse (sum)a4bq15, by (hh)
save "D:\CEMFI\Development\HW1\Data\seedB.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC5B.dta" , clear
collapse (sum)a5bq10, by (hh)
save "D:\CEMFI\Development\HW1\Data\transportB.dta",replace

use "D:\CEMFI\Development\HW1\Data\inputsB.dta" , clear
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\seedB.dta"
drop _merge 
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\transportB.dta"
drop _merge
save "D:\CEMFI\Development\HW1\Data\agrcost_2.dta",replace


use "D:\CEMFI\Development\HW1\Data\AGSEC2B.dta" , clear
collapse (sum)a2bq9, by (hh)
save "D:\CEMFI\Development\HW1\Data\rent.dta",replace

merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\agrcost_1.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\agrcost_2.dta"
drop _merge

egen agrcost_total = rowtotal(a3aq8 a3aq18 a3aq27 a3aq36 a4aq15 a5aq10 a3bq8 a3bq18 a3bq27 a3bq36 a4bq15 a5bq10 a2bq9)
save "D:\CEMFI\Development\HW1\Data\agr_cost.dta", replace

**************************************************
******************************************
* 3. Livestock production: 
* 		sales alive - AGSEC6A - a6aq14a*a6aq14b (cattle and pack)
*					  AGSEC6B - a6bq14a*a6bq14b (small animals)
*					  AGSEC6C - a6cq14a*a6cq14b (poultry, 3 months)
*		sales meat - AGSEC8A - a8aq5
*		sales milk - AGSEC8B - a8bq9
*		sales eggs - AGSEC8C - a8cq5 (3 months)
*

use "D:\CEMFI\Development\HW1\Data\AGSEC6A.dta" , clear
gen cattle = a6aq14a*a6aq14b
collapse (sum)cattle, by (hh)
save "D:\CEMFI\Development\HW1\Data\cattle.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC6B.dta" , clear
gen smallani = a6bq14a*a6bq14b
collapse (sum)smallani, by (hh)
save "D:\CEMFI\Development\HW1\Data\smallani.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC6C.dta" , clear
gen poultry = a6cq14a*a6cq14b
collapse (sum)poultry, by (hh)
gen poultry_y = poultry*4
drop poultry
save "D:\CEMFI\Development\HW1\Data\poultry.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC8A.dta" , clear
collapse (sum)a8aq5, by(hh) 
save "D:\CEMFI\Development\HW1\Data\meat.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC8B.dta" , clear
collapse (sum)a8bq9, by (hh) 
save "D:\CEMFI\Development\HW1\Data\milk.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC8C.dta" , clear
gen eggs = a8cq5*4
collapse (sum)eggs, by (hh) 
save "D:\CEMFI\Development\HW1\Data\eggs.dta",replace

use "D:\CEMFI\Development\HW1\Data\smallani.dta" , clear
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\cattle.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\poultry.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\meat.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\milk.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\eggs.dta"
drop _merge

egen live_prod_total = rowtotal(cattle smallani poultry_y a8aq5 a8bq9 eggs) 
save "D:\CEMFI\Development\HW1\Data\livestock_prod.dta",replace
****************************************************
* 4. Livestock costs:
*		hired labor - AGSEC6A - a6aq5c (cattle and pack)
*					  AGSEC6B - a6bq5c (small animals)
*					  AGSEC6C - a6cq5c (poultry, 3 months)
*
*		feeding - AGSEC7 - a7bq2e
*		watering - AGSEC7 - a7bq3f
*		vaccaination - AGSEC7 - a7bq5d
*		deworming - a7bq6c
*		treatment - a7bq7c	

use "D:\CEMFI\Development\HW1\Data\AGSEC6A.dta" , clear
collapse (sum)a6aq5c, by (hh) 
save "D:\CEMFI\Development\HW1\Data\l_cattle.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC6B.dta" , clear
collapse (sum)a6bq5c, by (hh) 
save "D:\CEMFI\Development\HW1\Data\l_small.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC6C.dta" , clear
collapse (sum)a6cq5c, by (hh) 
gen l_poultry = a6cq5c*4
save "D:\CEMFI\Development\HW1\Data\l_poultry.dta",replace

use "D:\CEMFI\Development\HW1\Data\AGSEC7.dta" , clear
collapse (sum)a7bq2e a7bq3f a7bq5d a7bq6c a7bq7c, by (hh) 
save "D:\CEMFI\Development\HW1\Data\live_inputs.dta",replace

use "D:\CEMFI\Development\HW1\Data\live_inputs.dta"
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\l_cattle.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\l_small.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\l_poultry.dta"
drop _merge
egen live_cost = rowtotal(a6aq5c a6bq5c l_poultry a7bq2e a7bq3f a7bq5d a7bq6c a7bq7c)
save "D:\CEMFI\Development\HW1\Data\live_cost.dta",replace

******************************
use "D:\CEMFI\Development\HW1\Data\agr_prod.dta",clear
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\agr_cost.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\livestock_prod.dta"
drop _merge
merge 1:1 hh using "D:\CEMFI\Development\HW1\Data\live_cost.dta"
drop _merge

replace live_cost = 0 - live_cost
replace agrcost_total = 0 - agrcost_total
egen agri_inc = rowtotal(agr_prod agrcost_total live_prod_total live_cost)
keep hh agr_prod agrcost_total live_prod_total live_cost agri_inc
rename hh HHID
save "D:\CEMFI\Development\HW1\Data\agri_inc.dta",replace
