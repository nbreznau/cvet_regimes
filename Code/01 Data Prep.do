* Institional Adult Education Regimes: Continuing Vocational Education and Training Participation and Barriers in Germany, Sweden and The United Kingdom

*PIAAC Data for Germany, England/Northern Ireland, Sweden
*Merged from International PUFs (https://github.com/nbreznau/ALE_degrees_institutions for R import routine )

*import delimited "C:\GitHub\CVET_barriers_DEGBSE\Data\piaac_combined.csv", clear 
*keep if cntryid == 276 | cntryid == 752 | cntryid == 826
*save "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE.dta"

* For replicability
version 14


*#########################################################################################
* Age variable missing in German PUF, merging it from German SUF

*use "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE.dta"\ZA5845_v2-0-0.dta", clear
*keep CNTRYID SEQID AGE_R
*drop if CNTRYID != 276

*rename AGE_R age_suf
*sort CNTRYID SEQID
*save "C:\GitHub\CVET_barriers_DEGBSE\Data\GERage.dta", replace

*use "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE.dta", clear
*gen CNTRYID = cntryid
*drop cntryid
*gen SEQID = seqid
*drop seqid
*sort CNTRYID SEQID
*merge 1:1 CNTRYID SEQID using "C:\GitHub\CVET_barriers_DEGBSE\Data\GERage.dta"

*gen age = real(age_r)
*gen agenew = age
*replace agenew = age_suf if CNTRYID == 276
*tab1 agenew

*save "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE_1.dta", replace

* German SUF has 86 cases more than German PUF. What to do with those cases?
* As I am using the weights in the PUF data, I am deleting these cases for now. 
*#########################################################################################

use "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE_1.dta", clear

drop if _merge == 2

drop _merge

sort CNTRYID SEQID

merge 1:1 CNTRYID SEQID using "C:\GitHub\CVET_barriers_DEGBSE\Data\insamp_seqids.dta"


*Age
* Determine appropriate age range for analysis
* Drop cases which are under 25 years of age (predominantly those still in formal schooling or about to return to formal schooling)
* Drop cases older than 55, CVET unlikely

drop if agenew < 25
drop if agenew > 55

*Sex

gen GEN_R = real(gender_r)
gen male = GEN_R
recode male (2=0)

*Education

gen EDLEVEL3 = real(edlevel3)
drop edlevel3
tab EDLEVEL3, gen(education)

*ISIC industry classification

* Generating a variable which indicates the current (or previous) industry of employment requires matching the industries with 25 subcategories. When done later, the value labels no longer align; this would involve far longer recodes to match the respective industries of current and last job.

encode isic1c, gen(isic)
recode isic (1 2 3 4 5 6 = .)


encode isic1l, gen(I1L)
recode I1L (1 2 3 4 5 6 = .)
drop isic1l
gen isic1l = I1L

replace isic = isic1l if isic == .
replace isic = isic - 1

tab isic, gen(isic_k)
* 6 = A and 26 = U

*Occupational status

* Occupational status variable provided in PIAAC rather broad with 4 categories. 

encode iscoskil4, gen(isco_nomis)
replace isco_nomis = . if isco_nomis > 6
*tab1 isco_nomis
recode isco_nomis (1=4) (2=3) (3=2) (4=1)(5 6 = 5)
label define isco 5 "missing" 4 "skilled" 3 "semi white" 2 "semi blue" 1 "elementary"
label val isco_nomis isco

tab isco_nomis, gen(isco_cat)

*Employment status

* This is the major sample selection criteria
* Paid work in the past 12 months (not just employment as it is lumped together in PIAAC with unpaid work for the family business) 
* Delete cases which are currently students or in some form of education, in military service, permanently disabled, or missing

keep if paidwork12 == "1"

gen C_Q07 = real(c_q07)
drop if C_Q07 == 4
drop if C_Q07 == 5
drop if C_Q07 == 7
drop if C_Q07 == 8
drop if C_Q07 == .



*Full-time versus part-time employment

* Subjective judgement of current work status ("what would describe your current situation best"
* Other variables for previous and current job on working hours may be vague. Also, it may differ in the three countries what is perceived as part-time. 

gen full = 0
replace full = 1 if c_q07 == "1"

gen part = 0
replace part = 1 if c_q07 == "2"


*Public versus private sector

* Variable indicating if someone works in the public sector opposed to everything else (assuming that state/government jobs are different in terms of training than private sector jobs)
* Variable includes information on current job or past job if there was no information on current job but they reported the last working experience within the past 12 months

gen publicc = 1 if d_q03 == "2"
replace publicc = 0 if d_q03 == "1" | d_q03 == "3" | d_q03 == "6" | d_q03 == "7" | d_q03 == "8" | d_q03 == "9"

gen publicl = 1 if e_q03 == "2"
replace publicl = 0 if e_q03 == "1" | e_q03 == "3" | e_q03 == "6" | e_q03 == "7" | e_q03 == "8" | e_q03 == "9"

gen public = 0
replace public = 1 if publicc == 1
replace public = 1 if publicl == 1 & publicc == 0


*Type of contract
* Reference category becomes atypical and self-employed

gen D_Q09 = real(d_q09)
drop d_q09
gen E_Q08 = real(e_q08)
drop e_q08
recode D_Q09 (1 = 1) (2/99 = 0), gen(permc)
recode E_Q08 (1 = 1) (2/99 = 0), gen(perml)

gen perm = 0
replace perm = 1 if permc == 1
replace perm = 1 if perml == 1 & permc == 0


recode D_Q09 (2 = 1) (1 3/99 = 0), gen(tempc)
recode E_Q08 (2 = 1) (1 3/99 = 0), gen(templ)

gen temp = 0
replace temp = 1 if tempc == 1
replace temp = 1 if templ == 1 &tempc == 0


*Children under 10

gen children = 1 if j_q03a == "1"
replace children = 0 if j_q03a == "2"


*Sample restriction: NFE12JR (non-formal job-related training in past 12 months)

gen NFE12JR = real(nfe12jr)
drop nfe12jr
drop if NFE12JR== .


*Obstacles to (additional) participation

* Not all of the barriers to participation make sense in the context of different welfare state regimes: prerequisits may refer to lack of skills or credentials transferred (or not transferred) through the education system; money refers to potential ressourced offered to take courses or the provision of free or rather inexpensive courses; employer support reflects a certain training atmosphere in the firm and potential firm involvement, which should also be directly linked to human capital formation regimes; child and family care responsibilities are also directly linked to welfare state provision of respective outsourced care options and general state support in taking care of these matters
* Less relevant here: busy at work as everyone is normally 'busy at work' and 'something unexpected', this do not seem policy or welfare regime relevant

gen barriers = real(b_q26b)
drop if b_q26b == "D"


tab barriers, gen(barriers_kat)

* 1 I did not have the prerequisites, 2 Education or training was too expensive/I could not afford it, 3 Lack of employer's support, 4 I was too busy at work, 5 The course or programme was offered at an inconvenient time or place, 6 I did not have time because of child care or family responsibilities, 7 Something unexpected came up that prevented me from taking education or training, 8 Other

gen prereq = 0
replace prereq = 1 if b_q26b == "1"

gen money = 0
replace money = 1 if b_q26b == "2"

gen support = 0
replace support = 1 if b_q26b == "3"

gen busy = 0
replace busy = 1 if b_q26b == "4"

gen timeplace = 0
replace timeplace = 1 if b_q26b == "5"

gen childresp = 0
replace childresp = 1 if b_q26b == "6"

gen unexpect = 0
replace unexpect = 1 if b_q26b == "7"

* variables 4, 5 and 7 all refer to not having enough time personally
gen time = 0
replace time = 1 if busy == 1 | unexpect == 1 | timeplace == 1



drop if b_q26a == "D"
* Generating variable which indicates whether any barrier was reported

recode barriers (1 2 3 4 5 6 7 8 = 1) (else = .), gen(barnoyes)
replace barnoyes = 0 if b_q26b == "V"



* Generating variable which indicates satisfaction with current training level (B_Q26a) -> no need for any (further) training
* In the last 12 months, were there More / Any learning activities you wanted to participate in but did not? Include both learning activities that lead to formal qualifications and other organised learning activities. 

gen FETsatisfact = real(b_q26a)
replace FETsatisfact = FETsatisfact - 1

* Generating variable which indicates lack of interest in training (no participation reported and no desire for any/further training

gen noFETdesire = 0
gen B_Q26a = real(b_q26a)
replace noFETdesire = 1 if NFE12JR == 0 & B_Q26a == 2
label define noFETdesire 0 "want more" 1 "no FET desire"
label val noFETdesire noFETdesire

* Testing this variable
*+++++++++++++++++++++++++++++++++++++++++++++++
*FIGURE A1


* The problem is that some might report not interested in 'more' training, because they had their training interests fulfilled

* b_q12d - on the job training 12mo count (CVET)
gen NFE12JR_onjob_count = real(b_q12d)
recode NFE12JR_onjob_count (. = 0)

* b_q12f - seminars or workshops 12mo count (not exactly CVET, but likely CVET)
gen NFE12_seminars_count = real(b_q12f)
recode NFE12_seminars_count (. = 0)

* create a filter here. those who had 1 to 4 CVET courses in the last 12 months, could easily take more. Therefore when they say they do not want more, they can also be safely coded as not interested. Our assumptions break down as the number of courses gets higher as there is a point of saturation where people who are interested in CVET actually could have their insterest fulfillend and then do not want 'more'. This is based on the correlations below

gen NFE12JR_count6 = NFE12JR_onjob_count + NFE12_seminars_count
recode NFE12JR_count6 (6/300 = 6)

gen NFE12JR_count = NFE12JR_onjob_count + NFE12_seminars_count
recode NFE12JR_count (1 2 3 4 = 1)(5/300 = 2)

tab NFE12JR_count b_q26a
tab NFE12JR_count6 b_q26a

* Learning strategies - like learning new things
gen I_Q04d = real(i_q04d)

* somewhat strong associations

table I_Q04d, c(mean noFETdesire)
pwcorr noFETdesire I_Q04d NFE12JR NFE12JR_count6

* create final noFETdesire_2 variable

gen noFETdesire_2 = noFETdesire
replace noFETdesire_2 = 1 if NFE12JR_count == 1 & B_Q26a == 2

*CVET / Barriers MULTINOMIAL OUTCOME

recode barriers (2=1)(3=2)(6=3)(1=5)( 4 5 7 =5)(*=4), gen(bart)
label define bart 1 "Money" 2 "Emp support" 3 "Care resp" 4 "No barrier" 5 "Other barrier"
label val bart bart
tab bart
tab NFE12JR
gen cp = NFE12JR
replace cp=cp*10
gen cvetmn = bart+cp
label var cvetmn "CVET: Multinomial outcome"
tab cvetmn
label define cvetmn 1 "Money / No CVET" 2 "EmpSup / No CVET" 3 "CareResp / No CVET" 4 "No Barrier / No CVET" 5 "OtherBar / No CVET" 11 "Money / CVET" 12 "EmpSup / CVET" 13 "CareResp / CVET" 14 "No Barrier / CVET" 15 "OtherBar / CVET"
label val cvetmn cvetmn
tab cvetmn

 

save "C:\GitHub\CVET_barriers_DEGBSE\Data\DEGBSE_2.dta", replace

