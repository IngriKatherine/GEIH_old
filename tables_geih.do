*---------------------------------------------------------------------
* Function: construction of general tables
*---------------------------------------------------------------------
/*
*-------------------------------------------
*R&R
*-------------------------------------------
*share of informal workers for different income range 
use "$process\geih\workdata_wcity_gaps", clear
table year_m tr_treated if city != 99 & year >= 2009 & year <= 2014 [w=wgt], c(mean informal_ss) replace
rename table1 informal_ss
replace informal_ss = informal_ss * 100
reshape wide informal_ss, i(year) j(tr_treated)
rename informal_ss0 informal_ss_se
rename informal_ss1 informal_ss_salaried
save "$output_temp\informal_ss_se_sal", replace
*self-employed 0-1 monthly mw
use "$process\geih\workdata_wcity_gaps", clear
table year_m if city != 99 & year >= 2009 & year <= 2014 & tr_treated == 0 & nr_mw_month > 0 & nr_mw_hr < 1 [w=wgt], c(mean informal_ss) replace
replace table1 = table1 * 100
rename table1 informal_ss_se_0_1
save "$output_temp\informal_ss_se_0_1", replace
*self-employed 1-10 monthly mw
use "$process\geih\workdata_wcity_gaps", clear
table year_m if city != 99 & year >= 2009 & year <= 2014 & tr_treated == 0 & nr_mw_hr >= 1 & nr_mw_month <= 10 [w=wgt], c(mean informal_ss) replace
replace table1 = table1 * 100
rename table1 informal_ss_se_1_10
save "$output_temp\informal_ss_se_1_10", replace
*table
use "$output_temp\informal_ss_se_sal", clear
merge 1:1 year_m using "$output_temp\informal_ss_se_0_1", nogen
merge 1:1 year_m using "$output_temp\informal_ss_se_1_10", nogen
save "$tables\informal_ss_se_sal", replace
*share of workers under/below 10 monthly #mws
*----------------------------------------------------
use "$process\geih\workdata_wcity_gaps", clear
gen     above10mwm = .
replace above10mwm = 0 if nr_mw_month <  10
replace above10mwm = 1 if nr_mw_month >= 10
table year_m if city != 99 & year >= 2009 & year <= 2014 & tr_treated != . [w=wgt], c(mean above10mwm) replace
rename table1 above10mwm
replace above10mwm = above10mwm * 100
save "$output_temp\above10mwm_10mw", replace
*self-employed under/below 10 monthly #mws
use "$process\geih\workdata_wcity_gaps", clear
gen     above10mwm = .
replace above10mwm = 0 if nr_mw_month <  10
replace above10mwm = 1 if nr_mw_month >= 10
table year_m tr_treated if city != 99 & year >= 2009 & year <= 2014 [w=wgt], c(mean above10mwm) replace
replace table1 = table1 * 100
rename table1 above10mwm
reshape wide above10mwm, i(year) j(tr_treated)
rename above10mwm0 above10mwm_se
rename above10mwm1 above10mwm_sal
save "$output_temp\above10mwm_se_emp", replace
*table
use "$output_temp\above10mwm_10mw", clear
merge 1:1 year_m using "$output_temp\above10mwm_se_emp", nogen
save "$tables\above10mw", replace
*/
*DESCRIPTIVE STATISTICS GENERAL
*------------------------------
use "$process\geih\workdata_wcity_gaps", clear
*before after reform
gen     years_before_after = .
replace years_before_after = 1 if year >= 2009 & year <= 2012
replace years_before_after = 2 if year >= 2013 & year <= 2014
*few firm size
gen     firm_s = .
replace firm_s = 1 if firm_size == 1
replace firm_s = 2 if firm_size == 2 | firm_size == 3
replace firm_s = 3 if firm_size == 4
replace firm_s = 4 if firm_size == 5
replace firm_s = 5 if firm_size == 6 | firm_size == 7
replace firm_s = 6 if firm_size >= 8 & firm_size != .
label define firm_s 1 "Alone"   ///
                    2 "[2-5]"   ///
                    3 "[6-10]"   ///
                    4 "[11-19]"   ///
                    5 "[20-49]"   ///
                    6 "[50+)"   ///

label values firm_s firm_s

*workage
preserve
table years_before_after tr_treated if workage == 1, replace  
rename table1 treated
gen var = "workage"
reshape wide treated, i(var years_before_after) j(tr_treated)
rename treated0 treated0_y
rename treated1 treated1_y
reshape wide treated0_y treated1_y, i(var) j(years_before_after)
order var treated0_y1 treated0_y2 treated1_y1 treated1_y2
save "$output_temp\des_workage", replace
restore
*share male/age/education/urban/wages
foreach v in male age edu_years urban nr_mw_hr {
    preserve
    table years_before_after tr_treated if workage == 1 [pw=wgt_year], replace c(mean `v')  
    rename table1 treated
    local aux = "`v'"
    if "`aux'" == "male" | "`aux'" == "urban" {
        replace treated = treated * 100
    }
    gen var = "`v'"
    reshape wide treated, i(var years_before_after) j(tr_treated)
    rename treated0 treated0_y
    rename treated1 treated1_y
    reshape wide treated0_y treated1_y, i(var) j(years_before_after)
    order var treated0_y1 treated0_y2 treated1_y1 treated1_y2
    save "$output_temp\des_`v'", replace
    restore
}
*share by sector and firm size
foreach v in sector3_rev3 firm_s {  
    preserve
    table years_before_after tr_treated `v' if workage == 1 [pw=wgt_year], replace
    egen total = total(table1), by(years_before_after tr_treated)
    gen shr_total = ( table1 / total ) * 100
    drop table1 total 
    rename shr_total table1
    rename table1 treated
    gen var = "`v'"
    reshape wide treated, i(var years_before_after `v') j(tr_treated)
    rename treated0 treated0_y
    rename treated1 treated1_y
    reshape wide treated0_y treated1_y, i(var `v') j(years_before_after)
    order var treated0_y1 treated0_y2 treated1_y1 treated1_y2
    save "$output_temp\des_`v'", replace
    restore
}
*table 
use "$output_temp\des_workage", clear
foreach v in male age edu_years urban  {
	append using "$output_temp\des_`v'"
}
append using "$output_temp\des_nr_mw_hr"
append using "$output_temp\des_sector3_rev3"
append using "$output_temp\des_firm_s"
save "$tables\descrip_geih", replace                           

exit

/*
*-------------------------------------------
*CITY WAGE GAPS
*-------------------------------------------
*all workers
use "$process\geih\workdata_wcity_gaps", clear
table year city if city != 99 & tr_treated != . [w=wgt_year], c(mean w_hr_real mean informal_ss freq) replace
rename table1 w_hr_real
rename table2 informal_ss
rename table3 freq
replace informal_ss = informal_ss * 100 
reshape wide freq w_hr_real informal_ss, i(year) j(city)
foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
    gen wgap_c`c' = w_hr_real`c'/w_hr_real11
}
reshape long freq w_hr_real informal_ss wgap_c, i(year) j(city)
save "$tables\wgaps_inf", replace

*control or treated
use "$process\geih\workdata_wcity_gaps", clear
table year city if city != 99 & tr_treated != . & year == 2012 & quarter == 4 [w=wgt_quarter], c(mean w_hr_real mean informal_ss freq) replace
rename table1 w_hr_real
rename table2 informal_ss
rename table3 freq
replace informal_ss = informal_ss * 100 
reshape wide freq w_hr_real informal_ss, i(year) j(city)
foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
    gen wgap_c`c' = w_hr_real`c'/w_hr_real11
}
reshape long freq w_hr_real informal_ss wgap_c, i(year) j(city)
save "$tables\wgaps_inf_con_treat", replace
*for dosage DID estimates
keep city informal_ss
rename informal_ss city_inf_dec_12
save "$tables\wgaps_inf_merge_geih", replace
exit
*control/treated
use "$process\geih\workdata_wcity_gaps", clear
forvalues t = 0/1 {
	preserve
    table year city if tr_treated == `t' & city != 99 [w=wgt_year], c(mean w_hr_real mean informal_ss) replace
    rename table1 w_hr_real
    rename table2 informal_ss
    replace informal_ss = informal_ss * 100 
    reshape wide w_hr_real informal_ss, i(year) j(city)
    foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
        gen wgap_c`c' = w_hr_real`c'/w_hr_real11
    }
    reshape long w_hr_real informal_ss wgap_c, i(year) j(city)
    rename w_hr_real   w_hr_real_treated`t' 
    rename informal_ss informal_ss_treated`t'
    rename wgap_c      wgap_c_treated`t'                  
    save "$tables\wgaps_inf_treated`t'", replace
    restore
}

*control/treated by quintile
use "$process\geih\workdata_wcity_gaps", clear
forvalues t = 0/1 {
	forvalues q = 1/5 {
	    preserve
        table year city if tr_treated == `t' & w_hr_real_ymc_quin == `q' & w_hr_real != 0 & w_hr_real != . & city != 99 [w=wgt_year], c(mean w_hr_real mean informal_ss) replace
        rename table1 w_hr_real
        rename table2 informal_ss
        replace informal_ss = informal_ss * 100 
        reshape wide w_hr_real informal_ss, i(year) j(city)
        foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
            gen wgap_c`c' = w_hr_real`c'/w_hr_real11
        }
        reshape long w_hr_real informal_ss wgap_c, i(year) j(city)
        rename w_hr_real   w_hr_real_treated`t'_q`q' 
        rename informal_ss informal_ss_treated`t'_q`q'
        rename wgap_c      wgap_c_treated`t'_q`q'                  
        save "$tables\wgaps_inf_treated`t'_q`q'", replace
        restore
    }
}

*control/treated by decile
use "$process\geih\workdata_wcity_gaps", clear
forvalues t = 0/1 {
	forvalues d = 1/10 {
	    preserve
        table year city if tr_treated == `t' & w_hr_real_ymc_dec == `d' & w_hr_real != 0 & w_hr_real != . [w=wgt_year], c(mean w_hr_real mean informal_ss) replace
        rename table1 w_hr_real
        rename table2 informal_ss
        replace informal_ss = informal_ss * 100 
        reshape wide w_hr_real informal_ss, i(year) j(city)
        foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
            gen wgap_c`c' = w_hr_real`c'/w_hr_real11
        }
        reshape long w_hr_real informal_ss wgap_c, i(year) j(city)
        rename w_hr_real   w_hr_real_treated`t'_d`d' 
        rename informal_ss informal_ss_treated`t'_d`d'
        rename wgap_c      wgap_c_treated`t'_d`d'                  
        save "$tables\wgaps_inf_treated`t'_d`d'", replace
        restore
    }
}

*control/treated around 1 MW
use "$process\geih\workdata_wcity_gaps", clear
forvalues t = 0/1 {
    	forvalues i = 1/9 {
    		local j = 10 - `i'
	    preserve
        table year city if tr_treated == `t' & nr_mw_hr >= 0.`j' & nr_mw_hr <= 1.`i' [w=wgt_year], c(mean w_hr_real mean informal_ss) replace
        rename table1 w_hr_real
        rename table2 informal_ss
        replace informal_ss = informal_ss * 100 
        reshape wide w_hr_real informal_ss, i(year) j(city)
        foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
            gen wgap_c`c' = w_hr_real`c'/w_hr_real11
        }
        reshape long w_hr_real informal_ss wgap_c, i(year) j(city)
        rename w_hr_real   w_hr_real_treated`t'_nmw_`j'_`i' 
        rename informal_ss informal_ss_treated`t'_nmw_`j'_`i'
        rename wgap_c      wgap_c_treated`t'_nmw_`j'_`i'                  
        save "$tables\wgaps_inf_treated`t'_nmw_`j'_`i'", replace
        restore
    }
}

*city+treated
use "$tables\wgaps_inf", clear
merge 1:1 city year using "$tables\wgaps_inf_treated0", nogen
merge 1:1 city year using "$tables\wgaps_inf_treated1", nogen
forvalues t = 0/1 {
	forvalues q = 1/5 {
		merge 1:1 city year using "$tables\wgaps_inf_treated`t'_q`q'", nogen
	}
	forvalues d = 1/10 {
		merge 1:1 city year using "$tables\wgaps_inf_treated`t'_d`d'", nogen
	}
	forvalues i = 1/9 {
		local j = 10 - `i'
		merge 1:1 city year using "$tables\wgaps_inf_treated`t'_nmw_`j'_`i'", nogen
	}
}
save "$tables\wgaps_inf_all_groups", replace

exit
*correlations
use "$tables\wgaps_inf_all_groups", clear
forvalues t = 0/1 {
	preserve
    mat define corrs = (0,0,0)
    forvalues q = 1/5 {
        forvalues y = 2009/2018 {
            corr wgap_c_treated`t'_q`q' informal_ss_treated`t'  if year == `y' 
            mat define aux = r(C)
            local aux = aux[2,1]
            mat corrs = (corrs\ `q',`y',`aux') 
        }
    }
    clear
    svmat corrs
    drop in 1
    rename corrs1 quintile
    rename corrs2 year
    rename corrs3 corrs_tr`t'_q
    reshape wide corrs, i(year) j(quintile)
    save "$output_temp\wgaps_inf_corrs_tr`t'", replace
    restore
}
use "$output_temp\wgaps_inf_corrs_tr0", clear
merge 1:1 year using "$output_temp\wgaps_inf_corrs_tr1", nogen
save "$tables\wgaps_inf_corrs", replace

*regressions
use "$tables\wgaps_inf_all_groups", clear
forvalues t = 0/1 {
    mat define corrs = (0,0,0)
    forvalues q = 1/5 {
        forvalues y = 2009/2018 {
        	display "treated`t'_q`q'_y`y'"
            reg wgap_c_treated`t'_q`q' informal_ss_treated`t' if year == `y' 
        }
    }
}

exit
    clear
    svmat corrs
    drop in 1
    rename corrs1 quintile
    rename corrs2 year
    rename corrs3 corrs_tr`t'_q
    reshape wide corrs, i(year) j(quintile)
    save "$output_temp\wgaps_inf_corrs_tr`t'", replace
    restore
}
use "$output_temp\wgaps_inf_corrs_tr0", clear
merge 1:1 year using "$output_temp\wgaps_inf_corrs_tr1", nogen
save "$tables\wgaps_inf_corrs", replace

*-------------------------------------------
*CITY INFORMALITY GAPS
*-------------------------------------------
*BY CITY
*-------
*all workers
use "$process\geih\workdata_wcity_gaps", clear

gen     in_ind = . 
replace in_ind = 0 if employed == 1
replace in_ind = 1 if employed == 1 & sector3 == 2

gen     in_serv = . 
replace in_serv = 0 if employed == 1
replace in_serv = 1 if employed == 1 & sector3 == 3

forvalues t = 0/1 {
    foreach v in informal_ss above1mw_hr in_ind in_serv {
    	preserve
        mat define aux = (0,0,0,0,0)
        *all
        ttest `v' if tr_treated == `t' & city != 99 & year >= 2012 & year <= 2014, by(post2)
        mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        *by cities
        foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
            ttest `v' if tr_treated == `t' & city == `c' & year >= 2012 & year <= 2014, by(post2)
            mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        }
        clear
        svmat aux
        drop in 1
        rename aux1 city
        rename aux2 `v'_treated`t'_before
        format `v'_treated`t'_before %9.3f
        rename aux3 `v'_treated`t'_after
        format `v'_treated`t'_after %9.3f
        rename aux4 `v'_treated`t'_diff
        rename aux5 `v'_pvalue
        label define city 11 "Bogotá" ///
                          5  "Medellín" ///
                          76 "Cali" ///
                          8  "Barranquilla" ///
                          68 "Bucaramanga" ///
                          17 "Manizales" ///
                          52 "Pasto" ///
                          66 "Pereira" ///
                          54 "Cúcuta" ///
                          73 "Ibagué" ///
                          23 "Montería" ///
                          13 "Cartagena" ///
                          50 "Villavicencio" ///
                          15 "Tunja" ///
                          18 "Florencia" ///
                          19 "Popayán" ///
                          20 "Valledupar" ///
                          27 "Quibdó" ///
                          41 "Neiva" ///
                          44 "Riohacha" ///
                          47 "Santa Marta" ///
                          63 "Armenia" ///
                          70 "Sincelejo" ///
                          99 "All" ///
                                  
        label values city city
        tostring `v'_treated`t'_diff, replace format(%9.3f) force  
        gen     star = ""
        replace star = "***" if `v'_pvalue <  0.01
        replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
        replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
        replace `v'_treated`t'_diff = `v'_treated`t'_diff + star
        drop `v'_pvalue star 
        save "$output_temp\\`v'_treated`t'_ttest", replace
        restore
    }                      
}

*informality 
use "$output_temp\informal_ss_treated1_ttest", clear
merge 1:1 city using "$output_temp\informal_ss_treated0_ttest", nogen
merge 1:1 city using "$output_temp\above1mw_hr_treated1_ttest", nogen
merge 1:1 city using "$output_temp\above1mw_hr_treated0_ttest", nogen
save "$tables\inf_ttest", replace


*industry and services shares 
use "$output_temp\in_ind_treated1_ttest", clear
merge 1:1 city using "$output_temp\in_ind_treated0_ttest", nogen
merge 1:1 city using "$output_temp\in_serv_treated1_ttest", nogen
merge 1:1 city using "$output_temp\in_serv_treated0_ttest", nogen
save "$tables\ind_serv_shr_ttest", replace
 
*--------------------
*BY INFORMALITY GROUP
*--------------------
*all workers
use "$process\geih\workdata_wcity_gaps", clear

gen     in_ind = . 
replace in_ind = 0 if employed == 1
replace in_ind = 1 if employed == 1 & sector3 == 2

gen     in_serv = . 
replace in_serv = 0 if employed == 1
replace in_serv = 1 if employed == 1 & sector3 == 3

forvalues t = 0/1 {
    foreach v in informal_ss w_hr_real above1mw_hr in_ind in_serv {
    	preserve
        mat define aux = (0,0,0,0,0)
        *all
        ttest `v' if tr_treated == `t' & city != 99 & year >= 2012 & year <= 2014, by(post2)
        mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        *by informality group
        forvalues c = 0/1 {
            ttest `v' if tr_treated == `t' & inf_class2 == `c' & year >= 2012 & year <= 2014, by(post2)
            mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        }
        clear
        svmat aux
        drop in 1
        rename aux1 inf_class2
        rename aux2 `v'_treated`t'_before
        format `v'_treated`t'_before %9.3f
        rename aux3 `v'_treated`t'_after
        format `v'_treated`t'_after %9.3f
        rename aux4 `v'_treated`t'_diff
        rename aux5 `v'_pvalue
        label define inf_class2 0 "Low" ///
                               1 "High" ///
                               
        label values inf_class2 inf_class2
        tostring `v'_treated`t'_diff, replace format(%9.3f) force  
        gen     star = ""
        replace star = "***" if `v'_pvalue <  0.01
        replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
        replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
        replace `v'_treated`t'_diff = `v'_treated`t'_diff + star
        drop `v'_pvalue star 
        save "$output_temp\\`v'_treated`t'_ttest_ig", replace
        restore
    }                      
}

*informality 
use "$output_temp\informal_ss_treated1_ttest_ig", clear
merge 1:1 inf_class using "$output_temp\informal_ss_treated0_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\above1mw_hr_treated1_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\above1mw_hr_treated0_ttest_ig", nogen
save "$tables\inf_ttest_ig", replace

*wage+above1mw 
use "$output_temp\w_hr_real_treated1_ttest_ig", clear
merge 1:1 inf_class using "$output_temp\w_hr_real_treated0_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\above1mw_hr_treated1_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\above1mw_hr_treated0_ttest_ig", nogen
save "$tables\w_a1mw_ttest_ig", replace

*industry and services shares 
use "$output_temp\in_ind_treated1_ttest_ig", clear
merge 1:1 inf_class using "$output_temp\in_ind_treated0_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\in_serv_treated1_ttest_ig", nogen
merge 1:1 inf_class using "$output_temp\in_serv_treated0_ttest_ig", nogen
save "$tables\ind_serv_shr_ttest_ig", replace
*/
*AROUND 1MW
forvalues i = 1/2 {
	use "$process\geih\workdata_wcity_gaps", clear
	
	gen     in_ind = . 
	replace in_ind = 0 if employed == 1
	replace in_ind = 1 if employed == 1 & sector3 == 2
	
	gen     in_serv = . 
	replace in_serv = 0 if employed == 1
	replace in_serv = 1 if employed == 1 & sector3 == 3
	
	gen aux = abs(1 - nr_mw_hr)
	
	forvalues t = 0/1 {
		foreach v in informal_ss w_hr_real above1mw_hr in_ind in_serv {
			preserve
			mat define aux = (0,0,0,0,0)
			local w = `i' / 10
			local bw = `i'*2
			*all
			ttest `v' if tr_treated == `t' & city != 99 & year >= 2012 & year <= 2014 & aux <= `w', by(post2)
			mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
			*by informality group
			forvalues c = 0/1 {
				ttest `v' if tr_treated == `t' & inf_class2 == `c' & year >= 2012 & year <= 2014 & aux <= `w', by(post2)
				mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
			}
			clear
			svmat aux
			drop in 1
			rename aux1 inf_class2
			rename aux2 `v'_treated`t'_before
			format `v'_treated`t'_before %9.3f
			rename aux3 `v'_treated`t'_after
			format `v'_treated`t'_after %9.3f
			rename aux4 `v'_treated`t'_diff
			rename aux5 `v'_pvalue
			label define inf_class2 0 "Low" ///
								   1 "High" ///
								   
			label values inf_class2 inf_class2
			tostring `v'_treated`t'_diff, replace format(%9.3f) force  
			gen     star = ""
			replace star = "***" if `v'_pvalue <  0.01
			replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
			replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
			replace `v'_treated`t'_diff = `v'_treated`t'_diff + star
			drop `v'_pvalue star 
			save "$output_temp\\`v'_treated`t'_ttest_ig_bw`bw'", replace
			restore
		}
	}

	*informality 
	use "$output_temp\informal_ss_treated1_ttest_ig_bw`bw'", clear
	merge 1:1 inf_class using "$output_temp\informal_ss_treated0_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\above1mw_hr_treated1_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\above1mw_hr_treated0_ttest_ig_bw`bw'", nogen
	save "$tables\inf_ttest_ig_bw`bw'", replace
	
	*wage+above1mw 
	use "$output_temp\w_hr_real_treated1_ttest_ig_bw`bw'", clear
	merge 1:1 inf_class using "$output_temp\w_hr_real_treated0_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\above1mw_hr_treated1_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\above1mw_hr_treated0_ttest_ig_bw`bw'", nogen
	save "$tables\w_a1mw_ttest_ig_bw`bw'", replace
	
	*industry and services shares 
	use "$output_temp\in_ind_treated1_ttest_ig_bw`bw'", clear
	merge 1:1 inf_class using "$output_temp\in_ind_treated0_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\in_serv_treated1_ttest_ig_bw`bw'", nogen
	merge 1:1 inf_class using "$output_temp\in_serv_treated0_ttest_ig_bw`bw'", nogen
	save "$tables\ind_serv_shr_ttest_ig_bw`bw'", replace
}
/*
*-------------------------------------------
*CITY SALARIED SHARE GAPS
*-------------------------------------------
*BY CITY
*-------
*all workers
use "$process\geih\workdata_wcity_gaps", clear

foreach v in tr_treated {
    	preserve
        mat define aux = (0,0,0,0,0)
        *all
        ttest `v' if city != 99 & year >= 2012 & year <= 2014, by(post2)
        mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        *by cities
        foreach c in 5 8 11 13 15 17 18 19 20 23 27 41 44 47 50 52 54 63 66 68 70 73 76 {
            ttest `v' if city == `c' & year >= 2012 & year <= 2014, by(post2)
            mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        }
        clear
        svmat aux
        drop in 1
        rename aux1 city
        rename aux2 `v'_before
        format `v'_before %9.3f
        rename aux3 `v'_after
        format `v'_after %9.3f
        rename aux4 `v'_diff
        rename aux5 `v'_pvalue
        label define city 11 "Bogotá" ///
                          5  "Medellín" ///
                          76 "Cali" ///
                          8  "Barranquilla" ///
                          68 "Bucaramanga" ///
                          17 "Manizales" ///
                          52 "Pasto" ///
                          66 "Pereira" ///
                          54 "Cúcuta" ///
                          73 "Ibagué" ///
                          23 "Montería" ///
                          13 "Cartagena" ///
                          50 "Villavicencio" ///
                          15 "Tunja" ///
                          18 "Florencia" ///
                          19 "Popayán" ///
                          20 "Valledupar" ///
                          27 "Quibdó" ///
                          41 "Neiva" ///
                          44 "Riohacha" ///
                          47 "Santa Marta" ///
                          63 "Armenia" ///
                          70 "Sincelejo" ///
                          99 "All" ///
                                  
        label values city city
        tostring `v'_diff, replace format(%9.3f) force  
        gen     star = ""
        replace star = "***" if `v'_pvalue <  0.01
        replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
        replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
        replace `v'_diff = `v'_diff + star
        drop `v'_pvalue star 
        save "$tables\\`v'_ttest", replace
        restore
} 

*--------------------
*BY INFORMALITY GROUP
*--------------------
*all workers
use "$process\geih\workdata_wcity_gaps", clear

foreach v in tr_treated {
    	preserve
        mat define aux = (0,0,0,0,0)
        *all
        ttest `v' if city != 99 & year >= 2012 & year <= 2014, by(post2)
        mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        *by informality group
        forvalues c = 0/1 {
            ttest `v' if inf_class2 == `c' & year >= 2012 & year <= 2014, by(post2)
            mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
        }
        clear
        svmat aux
        drop in 1
        rename aux1 inf_class
        rename aux2 `v'_before
        format `v'_before %9.3f
        rename aux3 `v'_after
        format `v'_after %9.3f
        rename aux4 `v'_diff
        rename aux5 `v'_pvalue
        label define inf_class 0 "Low" ///
                               1 "High" ///
                              
        label values inf_class inf_class
        tostring `v'_diff, replace format(%9.3f) force  
        gen     star = ""
        replace star = "***" if `v'_pvalue <  0.01
        replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
        replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
        replace `v'_diff = `v'_diff + star
        drop `v'_pvalue star 
        save "$tables\\`v'_ttest_ig", replace
        restore
}         
*/
*AROUND 1MW
forvalues i = 1/2 {
	*all workers
	use "$process\geih\workdata_wcity_gaps", clear
	gen aux = abs(1 - nr_mw_hr)
	foreach v in tr_treated {
			preserve
			mat define aux = (0,0,0,0,0)
			local w = `i' / 10
			local bw = `i'*2
			*all
			ttest `v' if city != 99 & year >= 2012 & year <= 2014 & aux <= `w', by(post2)
			mat define aux = (aux\99,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
			*by informality group
			forvalues c = 0/1 {
				ttest `v' if inf_class2 == `c' & year >= 2012 & year <= 2014 & aux <= `w', by(post2)
				mat define aux = (aux\ `c' ,r(mu_1),r(mu_2),r(mu_2)-r(mu_1),r(p))
			}
			clear
			svmat aux
			drop in 1
			rename aux1 inf_class
			rename aux2 `v'_before
			format `v'_before %9.3f
			rename aux3 `v'_after
			format `v'_after %9.3f
			rename aux4 `v'_diff
			rename aux5 `v'_pvalue
			label define inf_class 0 "Low" ///
								   1 "High" ///
								  
			label values inf_class inf_class
			tostring `v'_diff, replace format(%9.3f) force  
			gen     star = ""
			replace star = "***" if `v'_pvalue <  0.01
			replace star = "**"  if `v'_pvalue >= 0.01 & `v'_pvalue < 0.05
			replace star = "*"   if `v'_pvalue >= 0.05 & `v'_pvalue < 0.10
			replace `v'_diff = `v'_diff + star
			drop `v'_pvalue star 
			save "$tables\\`v'_ttest_ig_bw`bw'", replace
			restore
	}         
}
exit
*-------------------------------------------
*POPULATION WAGES INFORMALITY
*-------------------------------------------
*all workers
use "$process\geih\workdata_wcity_gaps", clear

*population
preserve
table year city if city != 99 [w=wgt_year], replace
rename table1 pop_city
gen lpop_city = log(pop_city)
save "$output_temp\pop_city", replace
restore

*minimum wage
preserve    
gen min_wage_hr_real  = ( min_wage_hr / cpi ) * 100
gen lmin_wage_hr_real = log(min_wage_hr_real)
table year if month > 1, c(mean lmin_wage_hr) replace
rename table1 lmin_wage_hr
save "$output_temp\lmin_wage_hr", replace
restore

*city cpi to national CPI
drop w_hr_real w_month_real
gen       w_month_real = ( w_m_gross / cpi ) * 100
replace   w_month_real = ( profit    / cpi ) * 100 if w_month_real == .
label var w_month_real "monthly wage from main occupation 2008 LCU"
gen       w_hr_real = ( w_m_gross_hr / cpi ) * 100 
label var w_hr_real "hourly wage from main occupation 2008 LCU"
   
*mean/median
foreach s in mean median {
    *wages formal/informal
    forvalues i = 0/1 { 
        preserve
        table year city if city != 99 & month > 1 & informal_ss == `i' [w=wgt_year], c(`s' w_hr_real `s' w_month_real `s' nr_mw_month `s' nr_mw_hr) replace
        rename table1 w_hr_real_i`i'
        rename table2 w_month_real_i`i'
        rename table3 nr_mw_month_i`i'
        rename table4 nr_mw_hr_i`i'
        gen lw_hr_real_i`i'    = log(w_hr_real_i`i')
        gen lw_month_real_i`i' = log(w_month_real_i`i')
        save "$output_temp\w_`s'_i`i'", replace
        restore
    }
    
    *wages salaried/self-employed
    forvalues t = 0/1 { 
        preserve
        table year city if city != 99 & month > 1 & tr_treated == `t' [w=wgt_year], c(`s' w_hr_real `s' w_month_real mean informal_ss `s' nr_mw_month `s' nr_mw_hr) replace
        rename table1 w_hr_real_t`t'
        rename table2 w_month_real_t`t'
        rename table3 informal_ss_t`t'
        rename table4 nr_mw_month_t`t'
        rename table5 nr_mw_hr_t`t'
        replace informal_ss_t`t' = informal_ss_t`t' * 100
        gen lw_hr_real_t`t'    = log(w_hr_real_t`t')
        gen lw_month_real_t`t' = log(w_month_real_t`t')
        save "$output_temp\w_`s'_t`t'", replace
        restore
    }
    
    *informality
    preserve
    table year city if city != 99  & month > 1 [w=wgt_year], c(`s' w_hr_real `s' w_month_real mean informal_ss `s' nr_mw_month `s' nr_mw_hr) replace
    rename table1 w_hr_real
    rename table2 w_month_real
    rename table3 informal_ss
    rename table4 nr_mw_month
    rename table5 nr_mw_hr
    replace informal_ss = informal_ss * 100
    gen lw_hr_real    = log(w_hr_real)
    gen lw_month_real = log(w_month_real)
    save "$output_temp\w_`s'_inf", replace
    restore
    
    *table
    preserve
    use "$output_temp\pop_city", clear
    merge 1:1 city year using "$output_temp\w_`s'_i0", nogen
    merge 1:1 city year using "$output_temp\w_`s'_i1", nogen
    merge 1:1 city year using "$output_temp\w_`s'_t0", nogen
    merge 1:1 city year using "$output_temp\w_`s'_t1", nogen
    merge 1:1 city year using "$output_temp\w_`s'_inf", nogen
    merge m:1 year      using "$output_temp\lmin_wage_hr", nogen
    save "$tables\pop_w_`s'_for_inf", replace
    restore
    
}

*NOMINAL WAGES
*minimum wage
preserve    
gen lmin_wage_hr = log(min_wage_hr)
table year if month > 1, c(mean lmin_wage_hr) replace
rename table1 lmin_wage_hr
save "$output_temp\lmin_wage_hr", replace
restore

*mean/median
foreach s in mean median {
    *wages formal/informal
    forvalues i = 0/1 { 
        preserve
        table year city if city != 99 & month > 1 & informal_ss == `i' [w=wgt_year], c(`s' li_hr `s' li_month) replace
        rename table1 w_hr_real_i`i'
        rename table2 w_month_real_i`i'
        gen lw_hr_real_i`i'    = log(w_hr_real_i`i')
        gen lw_month_real_i`i' = log(w_month_real_i`i')
        save "$output_temp\w_`s'_i`i'", replace
        restore
    }
    
    *wages salaried/self-employed
    forvalues t = 0/1 { 
        preserve
        table year city if city != 99 & month > 1 & tr_treated == `t' [w=wgt_year], c(`s' li_hr `s' li_month mean informal_ss) replace
        rename table1 w_hr_real_t`t'
        rename table2 w_month_real_t`t'
        rename table3 informal_ss_t`t'
        replace informal_ss_t`t' = informal_ss_t`t' * 100
        gen lw_hr_real_t`t'    = log(w_hr_real_t`t')
        gen lw_month_real_t`t' = log(w_month_real_t`t')
        save "$output_temp\w_`s'_t`t'", replace
        restore
    }
    
    *informality
    preserve
    table year city if city != 99 & month > 1 [w=wgt_year], c(`s' li_hr `s' li_month mean informal_ss) replace
    rename table1 w_hr_real
    rename table2 w_month_real
    rename table3 informal_ss
    replace informal_ss = informal_ss * 100
    gen lw_hr_real    = log(w_hr_real)
    gen lw_month_real = log(w_month_real)
    save "$output_temp\w_`s'_inf", replace
    restore
    
    *table
    preserve
    use "$output_temp\pop_city", clear
    merge 1:1 city year using "$output_temp\w_`s'_i0", nogen
    merge 1:1 city year using "$output_temp\w_`s'_i1", nogen
    merge 1:1 city year using "$output_temp\w_`s'_t0", nogen
    merge 1:1 city year using "$output_temp\w_`s'_t1", nogen
    merge 1:1 city year using "$output_temp\w_`s'_inf", nogen
    merge m:1 year      using "$output_temp\lmin_wage_hr", nogen
    save "$tables\pop_w_`s'_for_inf_nominal", replace
    restore
    
}

*-----------------------------------------
*informality, wages and edu level analysis
*-----------------------------------------
use "$process\geih\workdata_wcity_gaps", clear
forvalues t = 0/1 { 
    preserve
    table edu_level4 year inf_class if city != 99 & ( year == 2012 | year == 2014 ) & tr_treated == `t' [w=wgt_year], c(mean lw_hr_real) replace
    rename table1 lw_hr_real_t`t'
    save "$output_temp\lw_hr_real_t_12_14_t`t'", replace
    restore
}    

*table
use "$output_temp\lw_hr_real_t_12_14_t0", clear
merge 1:1 inf_class edu_level4 year using "$output_temp\lw_hr_real_t_12_14_t1", nogen
save "$tables\lw_hr_real_t_12_14", replace

*--------------------------
*Wage and proportion trends
*--------------------------
*2011-2014 - monthly
*-------------------
use "$process\geih\workdata_wcity_gaps.dta" , clear

*all wages
forvalues tr = 0/1 {
	preserve
    table inf_class2 year_m if employed == 1 & workage == 1 & nr_mw_hr > 0 & year >= 2011 & year <= 2014 & tr_treated == `tr' [fw=wgt], c(mean w_hr_real mean above1mw_hr) replace
    rename table1 w_hr_real
    rename table2 above1mw_hr
    replace above1mw_hr = above1mw_hr *100
    reshape wide w_hr_real above1mw_hr, i(year_m) j(inf_class2)
    foreach v in w_hr_real above1mw_hr {
        rename `v'0 `v'_low
        rename `v'1 `v'_high
    }
    tsset year_m
    save "$tables\w_prop_11_14_tr`tr'", replace
    restore
}
  
*by wage groups
forvalues tr = 0/1 {
	local u = 3
	forvalues g = 7/9 {
		local lb = 0.`g'
		local ub = 1.`u'
	    preserve
        table inf_class2 year_m if employed == 1 & workage == 1 & nr_mw_hr > 0 & year >= 2011 & year <= 2014 & tr_treated == `tr' & nr_mw_hr >= `lb' & nr_mw_hr <= `ub' [fw=wgt], /// 
              c(mean w_hr_real mean above1mw_hr) replace
        rename table1 w_hr_real
        rename table2 above1mw_hr
        replace above1mw_hr = above1mw_hr *100
        reshape wide w_hr_real above1mw_hr, i(year_m) j(inf_class2)
        foreach v in w_hr_real above1mw_hr {
            rename `v'0 `v'_low
            rename `v'1 `v'_high
        }
        tsset year_m
        save "$tables\w_prop_11_14_tr`tr'_w_`g'_`u'", replace
        restore
        local u = `u' - 1
    }
}

*2008-2014 - monthly
*-------------------
*w_hr_real above1mw_hr
use "$process\geih\workdata_wcity_gaps.dta" , clear
forvalues tr = 0/1 {
	preserve
    table inf_class2 year_m if employed == 1 & workage == 1 & nr_mw_hr > 0 & year <= 2014 & tr_treated == `tr' [fw=wgt], c(mean w_hr_real mean above1mw_hr) replace
    rename table1 w_hr_real
    rename table2 above1mw_hr
    replace above1mw_hr = above1mw_hr *100
    reshape wide w_hr_real above1mw_hr, i(year_m) j(inf_class2)
    foreach v in w_hr_real above1mw_hr {
        rename `v'0 `v'_low
        rename `v'1 `v'_high
    }
    tsset year_m
    save "$tables\w_prop_08_14_tr`tr'", replace
    restore
}

*around 1 hourly MW
forvalues tr = 0/1 {
	forvalues i = 1/2 {
		local j = 10 - `i'
		use "$process\geih\workdata_wcity_gaps.dta" , clear
		table inf_class2 year_m if employed == 1 & workage == 1 & year <= 2014 & tr_treated == `tr' & nr_mw_hr >= 0.`j' & nr_mw_hr <= 1.`i' [fw=wgt], c(mean w_hr_real mean above1mw_hr) replace
		rename table1 w_hr_real
		rename table2 above1mw_hr
		replace above1mw_hr = above1mw_hr *100
		reshape wide w_hr_real above1mw_hr, i(year_m) j(inf_class2)
		foreach v in w_hr_real above1mw_hr {
			rename `v'0 `v'_low
			rename `v'1 `v'_high
		}
		tsset year_m
		save "$tables\w_prop_08_14_tr`tr'_w_`j'_`i'", replace
	}
}
*/
*2008-2014 - quarterly
*---------------------
*w_hr_real above1mw_hr
use "$process\geih\workdata_wcity_gaps.dta" , clear
forvalues tr = 0/1 {
	preserve
    table inf_class2 year_q if employed == 1 & workage == 1 & nr_mw_hr > 0 & year <= 2014 & tr_treated == `tr' [fw=wgt_quarter], c(mean w_hr_real mean above1mw_hr) replace
    rename table1 w_hr_real
    rename table2 above1mw_hr
    replace above1mw_hr = above1mw_hr *100
    reshape wide w_hr_real above1mw_hr, i(year_q) j(inf_class2)
    foreach v in w_hr_real above1mw_hr {
        rename `v'0 `v'_low
        rename `v'1 `v'_high
    }
    tsset year_q
    save "$tables\w_prop_08_14_tr`tr'_q", replace
    restore
}

*around 1 hourly MW
forvalues tr = 0/1 {
	forvalues i = 1/2 {
		local j = 10 - `i'
		use "$process\geih\workdata_wcity_gaps.dta" , clear
		table inf_class2 year_q if employed == 1 & workage == 1 & year <= 2014 & tr_treated == `tr' & nr_mw_hr >= 0.`j' & nr_mw_hr <= 1.`i' [fw=wgt_quarter], c(mean w_hr_real mean above1mw_hr) replace
		rename table1 w_hr_real
		rename table2 above1mw_hr
		replace above1mw_hr = above1mw_hr *100
		reshape wide w_hr_real above1mw_hr, i(year_q) j(inf_class2)
		foreach v in w_hr_real above1mw_hr {
			rename `v'0 `v'_low
			rename `v'1 `v'_high
		}
		tsset year_q
		save "$tables\w_prop_08_14_tr`tr'_w_`j'_`i'_q", replace
	}
}

exit

