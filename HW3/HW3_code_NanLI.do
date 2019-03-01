********************************************************************************
** Program: Development HW 3
** Auther: Nan Li
** Feb 27th, 2019

**** set invironment ***********************************************************

** working directory 
pwd
dir
cd "D:\CEMFI\Development\HW3" 
*change directory type

** log file
. log using DHW3_NL.log,append

** set memory allocation


**** Input data and preparation ************************************************
*** input 
use "dataUGA.dta",clear

*** balance panel
** test the participate condition
tab wave 
gen t = 1 
replace t = 2 if wave == "2010-2011"  
replace t = 3 if wave == "2011-2012"  
replace t = 4 if wave == "2013-2014"

bysort hh: gen part = _N  /* number of waves this household participate*/
tab part

/* four waves: 1490; three waves: 1084; two waves 377; 0ne wave 309 

       part |      Freq.     Percent        Cum.The 
------------+-----------------------------------
          1 |        309        3.01        3.01
          2 |        754        7.34       10.35
          3 |      3,252       31.65       42.00
          4 |      5,960       58.00      100.00
------------+-----------------------------------
      Total |     10,275      100.00

*/

** change overlap time data
* household in "2009 -2010" & "2010-2011" may have year ="2010" in both wave
sort hh t
bysort hh: gen year_d = year[_n+1] - year[_n] 
*test overlap =0 is true
gen time = year
replace time = year -1 if year_d==0
tab time

/*
       time |      Freq.     Percent        Cum.
------------+-----------------------------------
       2009 |      1,078       10.49       10.49
       2010 |      2,615       25.45       35.94
       2011 |      2,343       22.80       58.74
       2012 |      2,416       23.51       82.26
       2013 |        558        5.43       87.69
       2014 |      1,265       12.31      100.00
------------+-----------------------------------
      Total |     10,275      100.00
*/


*** calculate some variables
** Calculate the aggragate consumption
bysort time: egen c_a = sum(exp(lnc))
gen lnc_a= ln(c_a)

** Calculate average household income across all the wave
gen y = exp(lny)
bysort hh: egen y_m = mean(y)

** time period
sort hh time
bysort hh: gen time_d = time[_n+1]-time[_n]

*** save data 
save dataClean.dta,replace


****The whole sampel************************************************************
use dataClean.dta,replace

** get residual
summarize age age_sq familysize time ethnic female urban lnc lny
reg lny age age_sq familysize i.time i.ethnic i.female i.urban 
predict res_y, r

reg lnc age age_sq familysize i.time i.ethnic i.female i.urban 
predict res_c, r

** Calcualte the growth 
* define the change
sort hh time
bysort hh: gen resc_d = res_c[_n+1]-res_c[_n]
bysort hh: gen resy_d = res_y[_n+1]-res_y[_n]
summarize time_d resc_d resy_d
* annualize the growth
gen resc_y = resc_d/time_d
gen resy_y = resy_d/time_d

** pooling regression
reg resc_y resy_y lnc_a,noc

/*
. reg resc_y resy_y lnc_a,noc

      Source |       SS           df       MS      Number of obs   =     6,380
-------------+----------------------------------   F(2, 6378)      =     36.20
       Model |  18.1106274         2  9.05531372   Prob > F        =    0.0000
    Residual |  1595.38469     6,378  .250138709   R-squared       =    0.0112
-------------+----------------------------------   Adj R-squared   =    0.0109
       Total |  1613.49531     6,380  .252898952   Root MSE        =    .50014

------------------------------------------------------------------------------
      resc_y |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      resy_y |   .0487934    .005754     8.48   0.000     .0375136    .0600731
       lnc_a |   .0002712   .0004113     0.66   0.510    -.0005351    .0010775
------------------------------------------------------------------------------


*/
save dataAll.dta,replace

** regression for each household
statsby _b, by (hh): reg resc_y resy_y lnc_a,noc
rename _b_resy_y beta
rename _b_lnc_a phi
gen beta_ab = abs(beta)
xtile beta5q=beta_ab, nquantile(5)

** save
save all.dta,replace


****Urban sampel************************************************************
use dataClean.dta,replace
keep if urban ==1

** get residual
summarize age age_sq familysize time ethnic female lnc lny
reg lny age age_sq familysize i.time i.ethnic i.female 
predict res_y, r

reg lnc age age_sq familysize i.time i.ethnic i.female 
predict res_c, r

** Calcualte the growth 
* define the change
sort hh time
bysort hh: gen resc_d = res_c[_n+1]-res_c[_n]
bysort hh: gen resy_d = res_y[_n+1]-res_y[_n]
summarize time_d resc_d resy_d
* annualize the growth
gen resc_y = resc_d/time_d
gen resy_y = resy_d/time_d

** pooling regression
reg resc_y resy_y lnc_a,noc

/*

      Source |       SS           df       MS      Number of obs   =     1,145
-------------+----------------------------------   F(2, 1143)      =     16.77
       Model |  8.58402501         2   4.2920125   Prob > F        =    0.0000
    Residual |  292.519619     1,143  .255922677   R-squared       =    0.0285
-------------+----------------------------------   Adj R-squared   =    0.0268
       Total |  301.103644     1,145  .262972615   Root MSE        =    .50589

------------------------------------------------------------------------------
      resc_y |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      resy_y |   .0703968   .0129013     5.46   0.000     .0450839    .0957096
       lnc_a |   .0018367   .0009835     1.87   0.062     -.000093    .0037664
------------------------------------------------------------------------------

*/

** save data
save dataU.dta,replace

** regression for each household
statsby _b, by (hh): reg resc_y resy_y lnc_a,noc
rename _b_resy_y beta_u
rename _b_lnc_a phi_u
gen beta_uab = abs(beta_u)
xtile beta_u5q=beta_uab, nquantile(5)

** save
save urban.dta,replace

****Rural sampel************************************************************
use dataClean.dta,replace
keep if urban ==0

** get residual
summarize age age_sq familysize time ethnic female lnc lny
reg lny age age_sq familysize i.time i.ethnic i.female 
predict res_y, r

reg lnc age age_sq familysize i.time i.ethnic i.female 
predict res_c, r

** Calcualte the growth 
* define the change
sort hh time
bysort hh: gen resc_d = res_c[_n+1]-res_c[_n]
bysort hh: gen resy_d = res_y[_n+1]-res_y[_n]
summarize time_d resc_d resy_d
* annualize the growth
gen resc_y = resc_d/time_d
gen resy_y = resy_d/time_d

** pooling regression
reg resc_y resy_y lnc_a,noc

/*

      Source |       SS           df       MS      Number of obs   =     4,972
-------------+----------------------------------   F(2, 4970)      =     23.38
       Model |  11.6406756         2  5.82033781   Prob > F        =    0.0000
    Residual |  1237.06825     4,970  .248907093   R-squared       =    0.0093
-------------+----------------------------------   Adj R-squared   =    0.0089
       Total |  1248.70893     4,972  .251148215   Root MSE        =    .49891

------------------------------------------------------------------------------
      resc_y |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
      resy_y |   .0448035   .0065679     6.82   0.000     .0319276    .0576794
       lnc_a |  -.0002133   .0004648    -0.46   0.646    -.0011244    .0006979
------------------------------------------------------------------------------

*/

** save data
save dataR.dta,replace

** regression for each household
statsby _b, by (hh): reg resc_y resy_y lnc_a,noc
rename _b_resy_y beta_r
rename _b_lnc_a phi_r
gen beta_rab = abs(beta_r)
xtile beta_r5q=beta_rab, nquantile(5)

** save
save rural.dta,replace

****Final Results *****************************************************
use dataClean.dta,replace
keep hh y_m 
duplicates drop

merge 1:1 hh using all.dta
drop _merge
merge 1:1 hh using urban.dta
drop _merge
merge 1:1 hh using rural.dta
drop _merge


** gen urban
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        beta |      2,289    .7055405      37.411  -164.7343   1771.217
      beta_r |      1,815     1.50653    84.42061  -321.7252   3569.533
      beta_u |        390    .3808818    4.778009    -25.448   70.57632

*/

save result.dta,replace

*** Question 
use result.dta,clear
summarize beta beta_u beta_r phi phi_u phi_r
summarize y_m beta phi beta_u phi_u beta_r phi_r if beta < 20& beta >-20

_pctile beta_u, p(0.5,99.5)
return list
keep if (beta_u >r(r1)& beta_u <r(r2))|beta_u==.

_pctile beta_r, p(0.3,99.7)
return list
keep if  (beta_r > r(r1) & beta_r <r(r2))| beta_r==.
* drop 12

_pctile beta, p(0.2,99.8)
return list
keep if  (beta > r(r1) & beta <r(r2))| beta==.
* drop 10

** mean and median
tabstat beta beta_u beta_r, statistics(mean median)
tabstat phi phi_u phi_r, statistics(mean median)

** histogram
histogram beta,xtitle("Beta")
graph save Graph "D:\CEMFI\Development\HW3\beta.gph",replace

histogram beta,xtitle("Phi")
graph save Graph "D:\CEMFI\Development\HW3\phi.gph",replace

histogram beta_u, addplot (histogram beta_r, lcolor(red),fcolar())

*** Question 2
* use quantile income as group
xtile y5q=y_m, nquantile(5)

gen y_u = y_m
replace y_u =. if beta_u ==.
xtile y_u5q=y_u, nquantile(5)

gen y_r = y_m
replace y_r =. if beta_r ==.
xtile y_r5q=y_r, nquantile(5)

tabstat beta, statistics(mean median) by(y5q)
tabstat beta_u, statistics(mean median) by(y_u5q)
tabstat beta_r, statistics(mean median) by(y_r5q)

* use quantile beta as group
tabstat y_m, statistics(mean median) by(beta5q)
tabstat y_u, statistics(mean median) by(beta_u5q)
tabstat y_r, statistics(mean median) by(beta_r5q)

*********************************************************************
log close
