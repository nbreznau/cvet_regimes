*some of the code is likely to error if not in this version
version 14
*ssc install piaactools
*ssc install estout




*############################################################################################################################
*1. Data, and last few recodes

use "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE_2.dta", clear

*Use a consistent sample. The descriptives are run on the same analytical sample, no missings

drop if male == . | agenew == . | children == . | EDLEVEL3 == . | isco_cat5 == . 

gen VEMETHO0 = vemethodn

* create a variable to identify lower SES
gen low_ses = 1 if EDLEVEL3 < 3 & isco_nomis < 3

*Recodes
*There are only 14 cases missing from ISCO, this is small enough to let go
tab CNTRYID, gen(country)
gen SPFWT0 = spfwt0
gen hied = education3
recode isco_nomis (1 2=1 "blue-collar") (5 = .), gen(occ3)

* Need a variable to capture all those who did not report a barrier of money, support or care. This means "other" will now refer to all those who trained with no barrier reported and all those with other barriers besides the three of interest here.

gen other = 0
replace other = 1 if barnoyes==1 & time!=1 & money!=1 & support!=1 & childresp!=1


*############################################################################################################################
*2. Descriptives

* To account for complex survey structure, descriptives are done with piaactools, especially piaactab
* Variable for variance estimation for piaactools: vemethodn is changed to VEMETHO0 because of legacy coding

*CVET RELATED DESCRIPTIVES
* Figure 1 and Table A1

piaactab NFE12JR, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab NFE12JR, over(EDLEVEL3) save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET.e") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab NFE12JR, over(isco_nomis) save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET.i") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab NFE12JR, over(barnoyes) save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET.b") vemethodn(VEMETHO0) countryid(CNTRYID)

*ANY
piaactab barnoyes, save("C:\GitHub\CVET_barriers_DEGBSE\Results\any") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab barnoyes, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\any.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*TIME
piaactab time, save("C:\GitHub\CVET_barriers_DEGBSE\Results\time") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab time, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\time.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*MONEY
piaactab money, save("C:\GitHub\CVET_barriers_DEGBSE\Results\money") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab money, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\money.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*SUPPORT
piaactab support, save("C:\GitHub\CVET_barriers_DEGBSE\Results\support") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab support, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\support.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*CARE
piaactab childresp, save("C:\GitHub\CVET_barriers_DEGBSE\Results\care") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab childresp, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\care.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*NO INTEREST
piaactab noFETdesire_2, save("C:\GitHub\CVET_barriers_DEGBSE\Results\nointerest") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab noFETdesire_2, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\nointerest.low") vemethodn(VEMETHO0) countryid(CNTRYID)

*INTERESTED SUBSAMPLE
piaactab NFE12JR if noFETdesire_2 == 0, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab NFE12JR if noFETdesire_2 == 0, over(low_ses) save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested.low") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab time if noFETdesire_2 == 0, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested.time") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab money if noFETdesire_2 == 0, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested.money") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab support if noFETdesire_2 == 0, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested.support") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab childresp if noFETdesire_2 == 0, save("C:\GitHub\CVET_barriers_DEGBSE\Results\FET_interested.childresp") vemethodn(VEMETHO0) countryid(CNTRYID)

* SAMPLE DESCRIPTIVES

piaactab male, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_male") vemethodn(VEMETHO0) countryid(CNTRYID)
piaacdes agenew, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_agenew") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab children, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_children") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab education3, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_education3") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab education1, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_education1") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab isco_cat4, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_isco_cat4") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab isco_cat3, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_isco_cat3") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab isco_cat2, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_isco_cat2") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab full, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_full") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab part, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_part") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab perm, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_perm") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab temp, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_temp") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab public, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_public") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab barnoyes, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_barnoyes") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab time, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_time") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab money, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_money") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab support, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_support") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab childresp, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_childresp") vemethodn(VEMETHO0) countryid(CNTRYID)
piaactab noFETdesire_2, save("C:\GitHub\CVET_barriers_DEGBSE\Results\Table_A1_noFETdesire") vemethodn(VEMETHO0) countryid(CNTRYID)


                 
*############################################################################################################################
*3. Correlations
*http://www.stata.com/support/faqs/statistics/estimate-correlations-with-survey-data/

*Overall 
pwcorr NFE12JR male agenew children education3 isco_cat2 isco_cat4 full part perm temp public barnoyes time money support childresp noFETdesire_2 country* [aweight= SPFWT0]

*Germany 
pwcorr NFE12JR male agenew children education3 isco_cat2 isco_cat4 full part perm temp public barnoyes time money support childresp noFETdesire_2 [aweight= SPFWT0] if CNTRYID == 276

*Sweden 
pwcorr NFE12JR male agenew children education3 isco_cat2 isco_cat4 full part perm temp public barnoyes time money support childresp noFETdesire_2 [aweight= SPFWT0] if CNTRYID == 752

*UK 
pwcorr NFE12JR male agenew children education3 isco_cat2 isco_cat4 full part perm temp public barnoyes time money support childresp noFETdesire_2 [aweight= SPFWT0] if CNTRYID == 826


*############################################################################################################################
*4. Regression analysis

*Survey set data
*In order to run estimations with replicate weights and jackknife variance estimation methods, svyset is necessary
* Otherwise I do not know how to run the regressions separate by country from the same datafile (piaacreg is proved complicated)

version 14
svyset [pw=spfwt0], jkrw(spfwt1-spfwt80) vce(jackknife)

*Regressions 

* Country codes
* Germany 276
* Sweden 752
* United Kingdom 826


*++++++++++++++++++++++++++++++++++++++
*PREDICTING CVET

*Full Model: Socio-demographics and work-related variables on whole sample

* Full sample
svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.barnoyes i.CNTRYID i.CNTRYID#i.hied i.CNTRYID#i.occ3 i.CNTRYID#i.barnoyes
est store all1

*Without barrier
svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.CNTRYID i.CNTRYID#i.hied i.CNTRYID#i.occ3 
est store all1nob

* Germany

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public barnoyes if CNTRYID == 276
est store ger1

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 276
est store ger1nob

* Sweden

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public barnoyes if CNTRYID == 752
est store swe1

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 752
est store swe1nob


* United Kingdom

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public barnoyes if CNTRYID == 826
est store uk1
svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 826
est store uk1nob

est table all1 ger1 swe1 uk1, b(%9.3f) stats(N)
est table all1 ger1 swe1 uk1, se(%9.3f)

*++++++++++++++++++++++++++++++++++++++
*PREDICTING LACK of INTEREST


* Full sample

svy: logit noFETdesire_2 male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.CNTRYID i.CNTRYID#i.hied i.CNTRYID#i.occ3
est store noFETall


* Germany

svy: logit noFETdesire_2 male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 276
est store noFETde

* Sweden

svy: logit noFETdesire_2 male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 752
est store noFETse

* UK

svy: logit noFETdesire_2 male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public if CNTRYID == 826
est store noFETuk

est table noFETall noFETde noFETse noFETuk, b(%9.3f) stats(N)
est table noFETall noFETde noFETse noFETuk, se(%9.3f)


*++++++++++++++++++++++++++++++++++++++
*SUBSET TO ONLY THOSE INTERESTED

*Restricted model: Model I 

*(formerly Model 3): Socio-demographics and work-related variables but only for those interested in training, adding perceived barriers (money, supervisor support, child/family responsibilities) other is references category

* Subsample, only those interested in training

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.money i.support i.childresp i.CNTRYID i.CNTRYID#i.money i.CNTRYID#i.support i.CNTRYID#i.childresp i.CNTRYID#i.hied i.CNTRYID#i.occ3 if noFETdesire_2 == 0 
est store all3

* Germany

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.money i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store ger3

* Sweden

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.money i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swe3

* United Kingdom

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children i.hied i.occ3 full part perm temp public i.money i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uk3

est table all3 ger3 swe3 uk3, star(.05 .01 .001) b(%9.3f)
est table all3 ger3 swe3 uk3, se(%9.3f) stats(N)



*Restricted model: MODEL II 

*(formerly Model 4o): Main Models (Interested in training only)

* Full sample (for interested in training)

*(barrier other has only 482 cases - does not converge when we include it)

*svy: logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public i.hied##i.other i.occ3##i.other i.hied##i.time i.occ3##i.time i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp i.CNTRYID i.CNTRYID#i.other i.CNTRYID#i.time i.CNTRYID#i.money i.CNTRYID#i.support i.CNTRYID#i.childresp i.CNTRYID#i.hied i.CNTRYID#i.occ3 i.CNTRYID#i.hied#i.other i.CNTRYID#i.hied#i.time i.CNTRYID#i.hied#i.money i.CNTRYID#i.hied#i.support i.CNTRYID#i.hied#i.childresp i.CNTRYID#i.occ3#i.other i.CNTRYID#i.occ3#i.time i.CNTRYID#i.occ3#i.money i.CNTRYID#i.occ3#i.support i.CNTRYID#i.occ3#i.childresp if noFETdesire_2 == 0
*est store all4oX

* As there are so few cases just leave it in for now

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public i.hied##i.time i.occ3##i.time i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp i.CNTRYID i.CNTRYID#i.time i.CNTRYID#i.money i.CNTRYID#i.support i.CNTRYID#i.childresp i.CNTRYID#i.hied i.CNTRYID#i.occ3 i.CNTRYID#i.hied#i.time i.CNTRYID#i.hied#i.money i.CNTRYID#i.hied#i.support i.CNTRYID#i.hied#i.childresp i.CNTRYID#i.occ3#i.time i.CNTRYID#i.occ3#i.money i.CNTRYID#i.occ3#i.support i.CNTRYID#i.occ3#i.childresp if noFETdesire_2 == 0
est store all4oe

* Germany

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public i.hied##i.time i.occ3##i.time i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store ger4o

* Sweden

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public i.hied##i.time i.occ3##i.time i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swe4o


* United Kingdom 

svy: logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public i.hied##i.time i.occ3##i.time i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uk4o

est table all4o ger4o swe4o uk4o, b(%9.3f) noempty
est table all4o ger4o swe4o uk4o, se(%9.3f) stat(N)


*Appendix Table 1. Descriptives (alternate to piaactools, same results)
svy: mean NFE12JR male agenew children education2 education3 isco_cat2 isco_cat3 isco_cat4 full part perm temp public barnoyes  money support childresp noFETdesire_2 
estat sd
svy: mean NFE12JR male agenew children education2 education3 isco_cat2 isco_cat3 isco_cat4 full part perm temp public barnoyes  money support childresp noFETdesire_2 if CNTRYID==276
estat sd
svy: mean NFE12JR male agenew children education2 education3  isco_cat2 isco_cat3 isco_cat4  full part perm temp public barnoyes  money support childresp noFETdesire_2 if CNTRYID==752
estat sd
svy: mean NFE12JR male agenew children education2 education3 isco_cat2 isco_cat3 isco_cat4  full part perm temp public barnoyes  money support childresp noFETdesire_2 if CNTRYID==826
estat sd

*#######################################################
*TABLE 1. CVET full sample
est restore all1nob
margins, dydx(i.hied i.occ3)
margins, dydx(i.hied i.occ3) by(CNTRYID)

est restore all1 
margins, dydx(i.hied i.occ3 barnoyes)
margins, dydx(i.hied i.occ3 barnoyes) by(CNTRYID)

*TABLE A3. Odds-ratios
esttab all1, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab ger1, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab swe1, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab uk1, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant

*fix barriers to 1 for second column, so effect of educ and occ net of barrier effect
margins, dydx(i.hied i.occ3) at(barnoyes=1)
margins, dydx(i.hied i.occ3) at(barnoyes=1) by(CNTRYID)

est restore ger1nob
margins, dydx(i.hied i.occ3)

est restore ger1
margins, dydx(i.hied i.occ3 barnoyes)

margins, dydx(i.hied i.occ3) at(barnoyes=1)

est restore swe1nob
margins, dydx(i.hied i.occ3)

est restore swe1
margins, dydx(i.hied i.occ3 barnoyes)
margins, dydx(i.hied i.occ3) at(barnoyes=1)

est restore uk1nob
margins, dydx(i.hied i.occ3)

est restore uk1

margins, dydx(i.hied i.occ3 barnoyes)
margins, dydx(i.hied i.occ3) at(barnoyes=1)

*#######################################################
*TABLE 2. Not Interested
est restore noFETall 
margins, dydx(i.hied i.occ3)
margins, dydx(i.hied i.occ3) by(CNTRYID)

* By country, not used
est restore noFETde 
margins, dydx(i.hied)
margins, dydx(i.occ3) 

est restore noFETse
margins, dydx(i.hied)
margins, dydx(i.occ3)

est restore noFETuk
margins, dydx(i.hied)
margins, dydx(i.occ3)

*TABLE A4. Odds-ratios
esttab noFETall, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab noFETde, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab noFETse, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant
esttab noFETuk, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant

*#######################################################
*TABLE 3. Barriers and CVET
*for those interested in training


* Results by country
est restore all4oe

*No barrier AME (this is slightly contaminated by 'other' barriers, but the N is so low that we do not worry about it as it is 18%)
*tab other barnoyes
*display 487/2651
*.18370426

margins, dydx(time money support childresp) by(CNTRYID)
margins, dydx(time money support childresp) at(hied=(0 1)) by(CNTRYID)
margins, dydx(time money support childresp) at(occ3=(1 3 4)) by(CNTRYID)
margins, dydx(time money support childresp) at(hied=0 occ3=1) by(CNTRYID)
margins, dydx(time money support childresp) at(hied=1 occ3=4) by(CNTRYID)

*no barrier
margins, at(time=0 money=0 support=0 childresp=0) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=0 hied=(0 1)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=0 occ3=(1 3 4)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=0 hied=0 occ3=1) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=0 hied=1 occ3=4) by(CNTRYID) level(90)

*time
margins, at(time=1 money=0 support=0 childresp=0) by(CNTRYID) level(90)
margins, at(time=1 money=0 support=0 childresp=0 hied=(0 1)) by(CNTRYID) level(90)
margins, at(time=1 money=0 support=0 childresp=0 occ3=(1 3 4)) by(CNTRYID) level(90)
margins, at(time=1 money=0 support=0 childresp=0 hied=0 occ3=1) by(CNTRYID) level(90)
margins, at(time=1 money=0 support=0 childresp=0 hied=1 occ3=4) by(CNTRYID) level(90)

*money
margins, at(time=0 money=1 support=0 childresp=0) by(CNTRYID) level(90)
margins, at(time=0 money=1 support=0 childresp=0 hied=(0 1)) by(CNTRYID) level(90)
margins, at(time=0 money=1 support=0 childresp=0 occ3=(1 3 4)) by(CNTRYID) level(90)
margins, at(time=0 money=1 support=0 childresp=0 hied=0 occ3=1) by(CNTRYID) level(90)
margins, at(time=0 money=1 support=0 childresp=0 hied=1 occ3=4) by(CNTRYID) level(90)

*support
margins, at(time=0 money=0 support=1 childresp=0) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=1 childresp=0 hied=(0 1)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=1 childresp=0 occ3=(1 3 4)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=1 childresp=0 hied=0 occ3=1) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=1 childresp=0 hied=1 occ3=4) by(CNTRYID) level(90)

*care
margins, at(time=0 money=0 support=0 childresp=1) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=1 hied=(0 1)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=1 occ3=(1 3 4)) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=1 hied=0 occ3=1) by(CNTRYID) level(90)
margins, at(time=0 money=0 support=0 childresp=1 hied=1 occ3=4) by(CNTRYID) level(90)

*TABLE A5. Odds-ratios
esttab all4oe, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant varwidth(40)
esttab ger4o, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant varwidth(25)
esttab swe4o, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant varwidth(25)
esttab uk4o, eform star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) constant varwidth(25)
*Likelihood Ratio Test

*Comparison Models
*LR test cannot be run on models with svy estimation, therefore set models as baseline without and make comparisons.

* Germany

logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store gers

* Sweden


logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swes


* United Kingdom

logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uks

*OMITTED INTERACTION BY BARRIER

* Germany Money
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store ger4lrm

* Germany Support
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store ger4lrs

* Germany Resp
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 276 
est store ger4lrr

* Sweden Money
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swe4lrm

* Sweden Support
 logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.support i.hied##i.childresp i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swe4lrs

* Sweden Resp
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 752
est store swe4lrr

* UK Money
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.money i.hied##i.support i.occ3##i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uk4lrm

* UK Support
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.support i.hied##i.childresp i.occ3##i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uk4lrs

* UK Resp
logit NFE12JR male c.agenew c.agenew#c.agenew children full part perm temp public other i.hied##i.money i.occ3##i.money i.hied##i.support i.occ3##i.support i.childresp if noFETdesire_2 == 0 & CNTRYID == 826
est store uk4lrr

*LR TESTS

*these compare models with and without the interaction by barrier to determine if adding the SES interactions leads to models that fit the data significantly better

lrtest ger4lrm gers, stats
lrtest ger4lrs gers , stats

lrtest ger4lrr gers, stats
 
lrtest swe4lrm swes, stats
 
lrtest swe4lrs swes, stats
 
lrtest swe4lrr swes, stats
 
lrtest uk4lrm uks, stats

lrtest uk4lrs uks, stats
 
lrtest uk4lrr uks, stats

*############################################################################################################################
*5. Multinomial analysis

*Survey set data
*In order to run estimations with replicate weights and jackknife variance estimation methods, svyset is necessary
* Otherwise I do not know how to run the regressions separate by country from the same datafile (also, piaacreg is somewhat complicated …)

svyset [pw=SPFWT0], jkrw(SPFWT1-SPFWT80) vce(jackknife)



*Pooled Sample mlogit
mlogit cvetmn male c.agenew c.agenew#c.agenew children full part perm temp public i.hied i.occ3 i.CNTRYID
mlogit cvetmn male c.agenew c.agenew#c.agenew children full part perm temp public i.hied i.occ3 i.CNTRYID [pw=SPFWT0]
est store pml
margins, at(hied=(0 1))


*Learning Graphing with mlogit
est restore pml
marginsplot, horiz unique
marginsplot, horiz unique xline(0) recast(scatter)

















margins occ3, atmeans pwcompare predict(outcome(11))
marginsplot, horiz unique xline(0) recast(scatter)
 
*This shows that skilled occupations (3 and 4 in occ3) are far more likely to be in the category of a money barrier and train than blue-collar and unskilled (occ3 = 1)



Compare like this in Excel:

margins, atmeans predict(outcome(11)) by(occ3)
margins, atmeans predict(outcome(1)) by(occ3)


