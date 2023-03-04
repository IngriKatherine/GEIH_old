*----------------------------------------------------------
* Function: generate graphs                                     
*----------------------------------------------------------
graph set window fontface "Courier New"


*-------------------------------------------
*R&R
*-------------------------------------------
use "$tables\informal_ss_se_sal", clear

*share of informal workers for different income range
twoway (line          informal_ss_se  informal_ss_se_0_1 informal_ss_se_1_10 year_m,  /// 
             lwidth(  med             med                med  ) ///
             lcolor(  gs2             gs4                gs8 ) ///
             lpattern(solid           solid              solid) ///
             cmissing(n) yaxis(1) ///
             ) ///
       (line          informal_ss_salaried year_m,  /// 
             lwidth(  med                  ) ///
             lcolor(  black                ) ///
             lpattern(dash                 ) ///
             cmissing(n) yaxis(2) ///
             ) ///             
        , ylabel(20(2)50, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(2)) ///
          ylabel(70(2)100, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///        
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(4800 633 "reform" "passed",  color(gray) size(small) ) ///
          text(4800 643.5 "1st" "tax" "waiver", color(gray) size(small) ) ///
          text(4800 650.5 "final" "tax" "waiver", color(gray) size(small) ) ///
          xtitle("")             ///
          ytitle("", axis(1))    ///
          ytitle("", axis(2))    ///
          legend(label(4 "Salaried [1-10] #MW" "(right axis)") ///
                 label(1 "Self-employer all #MW") ///
                 label(2 "Self-employer [0-1) #MW") ///
                 label(3 "Self-employer [1-10] #MW") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(2) ) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\informal_ss_se_sal.png", replace
graph export "$graphs\\informal_ss_se_sal.eps", replace

*--------------------------------
*DISTRIBUTION OF # HOURLY MWS
*--------------------------------
*HISTOGRAM
*unweighted
use "$process\geih\workdata_wcity_gaps", clear
keep if city != 99
drop around*

*around 1 MW
foreach v in hr month {
    gen          around_mw_`v' = .
    replace      around_mw_`v' = 1  if nr_mw_`v' >  0    & nr_mw_`v' < 1
    replace      around_mw_`v' = 2  if nr_mw_`v' >= 1    & nr_mw_`v' <= 2
}

*kdensity
foreach v in hr month {
	*formal
    graph twoway (kdensity nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2012 & informal_ss == 0, bwidth(0.03) lcolor(gs10) ) ///
                 (kdensity nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2014 & informal_ss == 0, bwidth(0.03) lcolor(gs0) ) ///
                 , ///
              ylabel(, glcolor(white) ) ///
              xline(1, lwidth(med) lcolor(gray) lpattern(dash)) ///
              title("Formal workers", color(black) size(medsmall) ) ///
              ytitle("")             ///
              xtitle("# MWs", size(small))             ///
              graphregion(color(white)) bgcolor(white) ///
              legend(order(1 2) label(1 "2012") label(2 "2014") ) ///
              saving("$graphs\\stata\\kden_mw_`v'_formal", replace)
              
	*informal
    graph twoway (kdensity nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2012 & informal_ss == 1, bwidth(0.03) lcolor(gs10) ) ///
                 (kdensity nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2014 & informal_ss == 1, bwidth(0.03) lcolor(gs0) ) ///
                 , ///
              ylabel(, glcolor(white) ) ///
              xline(1, lwidth(med) lcolor(gray) lpattern(dash)) ///
              title("Informal workers", color(black) size(medsmall)) ///
              ytitle("")             ///
              xtitle("# MWs", size(small))             ///
              graphregion(color(white)) bgcolor(white) ///
              legend(order(1 2) label(1 "2012") label(2 "2014") ) ///
              saving("$graphs\\stata\\kden_mw_`v'_informal", replace)

     *combine
     graph combine "$graphs\\stata\\kden_mw_`v'_formal.gph" ///
              "$graphs\\stata\\kden_mw_`v'_informal.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5)  ///

     graph export "$graphs\\kden_mw_`v'_for_inf.png", as(png) replace
     
}

*histogram
foreach v in hr {
	*formal
    graph twoway (histogram nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2012 & informal_ss == 0, bin(19) color(gs11%50)  ) ///
                 (histogram nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2014 & informal_ss == 0, bin(19) color(gs2%45) ) ///
                 , ///
              ylabel(, glcolor(white) ) ///
              xline(1, lwidth(med) lcolor(gray) lpattern(dash)) ///
              title("Formal workers", color(black) size(medsmall) ) ///
              ytitle("")             ///
              xtitle("# MWs", size(small))             ///
              graphregion(color(white)) bgcolor(white) ///
              legend(order(1 2) label(1 "2012") label(2 "2014") ) ///
              saving("$graphs\\stata\\hist_mw_`v'_formal", replace)
              
    graph export "$graphs\\hist_mw_`v'_formal.png", as(png) replace
    graph export "$graphs\\hist_mw_`v'_formal.eps", as(eps) replace

	*informal
    graph twoway (histogram nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2012 & informal_ss == 1, bin(19) color(gs11%50)  ) ///
                 (histogram nr_mw_`v' if nr_mw_`v' >= 0 & nr_mw_`v' < 2 & tr_treated != . & year == 2014 & informal_ss == 1, bin(19) color(gs2%45) ) ///
                 , ///
              ylabel(, glcolor(white) ) ///
              xline(1, lwidth(med) lcolor(gray) lpattern(dash)) ///
              title("Informal workers", color(black) size(medsmall)) ///
              ytitle("")             ///
              xtitle("# MWs", size(small))             ///
              graphregion(color(white)) bgcolor(white) ///
              legend(order(1 2) label(1 "2012") label(2 "2014") ) ///
              saving("$graphs\\stata\\hist_mw_`v'_informal", replace)

      graph export "$graphs\\hist_mw_`v'_informal.png", as(png) replace
      graph export "$graphs\\hist_mw_`v'_informal.eps", as(eps) replace
              
     *combine
     graph combine "$graphs\\stata\\hist_mw_`v'_formal.gph" ///
              "$graphs\\stata\\hist_mw_`v'_informal.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5)  ///

     graph export "$graphs\\histogram_mw_`v'_for_inf.png", width(4796) height(3488) replace
     graph export "$graphs\\histogram_mw_`v'_for_inf.eps", cmyk(off) replace
     
}

*Wage gaps and informality rates
*-------------------------------
*2012 vs 2014
use "$tables\\wgaps_inf", clear

twoway (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       (lowess wgap_c informal_ss  if wgap_c != 1 & year == 2012, lcolor(gs14)) ///
       (lowess wgap_c informal_ss  if wgap_c != 1 & year == 2014, lcolor(black)) ///
       , ylabel(0.5(0.05)1, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(55(5)95, labsize(small) glwidth(small) ) ///
         xtitle("Informality rate (%)", size(small))             ///
         ytitle("Hourly wage gap (Bogotá as baseline)", size(small))    ///
         xline(0, lcolor(gs11) lpattern(dash)) ///
         yline(0, lcolor(gs11) lpattern(dash)) ///
         legend(order(1 2) label(1 "2012") label(2 "2014") ///
                position(1) ring(0) cols(1) size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\wgaps_inf_12_14.png", replace
graph export "$graphs\\wgaps_inf_12_14.eps", replace

*all years
use "$tables\\wgaps_inf", clear
twoway (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2009, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2010, ///
                                                       msize(med) /// 
                                                       mfcolor(gs12) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2011, ///
                                                       msize(med) /// 
                                                       mfcolor(gs10) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///                                                       
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs8) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///                                                       
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2013, ///
                                                       msize(med) /// 
                                                       mfcolor(gs6) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///                                                       
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2014, ///
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///                                                       
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2015, ///
                                                       msize(med) /// 
                                                       mfcolor(gs2) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(O) ///    
                                                       ) ///                                                       
       (scatter wgap_c informal_ss  if wgap_c != 1 & year == 2016, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs0) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2009, lcolor(gs14)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2010, lcolor(gs12)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2011, lcolor(gs10)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2012, lcolor(gs8)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2013, lcolor(gs6)) ///              
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2014, lcolor(gs4)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2015, lcolor(gs2)) ///
       (lfit wgap_c informal_ss  if wgap_c != 1 & year == 2016, lcolor(gs0)) ///       
       , ylabel(0.5(0.05)1, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(55(5)95, labsize(small) glwidth(small) ) ///
         xtitle("Informality rate (%)", size(small))             ///
         ytitle("Hourly wage gap (Bogotá as baseline)", size(small))    ///
         xline(0, lcolor(gs11) lpattern(dash)) ///
         yline(0, lcolor(gs11) lpattern(dash)) ///
         legend(order(1 2 3 4 5 6 7 8) /// 
                label(1 "2009") label(2 "2010") label(3 "2011") label(4 "2012") label(5 "2013") label(6 "2014") label(7 "2015") label(8 "2016") ///
                position(1) ring(0) cols(1) size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\wgaps_inf_yall.png", replace
graph export "$graphs\\wgaps_inf_yall.eps", replace

*2012 vs 2014 - TREATED
*----------------------
use "$tables\\wgaps_inf_all_groups", clear

gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*treated
reg wgap_c_treated1 informal_ss_treated1 if wgap_c != 1 & year == 2012
local r2_1 = e(r2) 
local dr2_1 : di %4.3f `r2_1'
reg wgap_c_treated1 informal_ss_treated1 if wgap_c != 1 & year == 2014
local r2_2 = e(r2)
local dr2_2 : di %4.3f `r2_2'
twoway (scatter wgap_c_treated1 informal_ss_treated1  if wgap_c != 1 & year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs12) ///
                                                       mlcolor(gs5) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter wgap_c_treated1 informal_ss_treated1  if wgap_c != 1 & year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       , ylabel(0.6(0.05)1, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(10(10)70, labsize(small) glwidth(small) ) ///
         title("All", color(black) size(medsmall))             ///
         xtitle("Workers informality rate (%)", size(small))             ///
         ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
         yline(1, lcolor(gs11) lpattern(solid)) ///
         text(0.65 28 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
         text(0.60 28 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
         legend(order(1 2) label(1 "2012") label(2 "2014") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///
         saving("$graphs\\stata\\wgaps_inf_12_14_treated1", replace)

graph export "$graphs\\wgaps_inf_12_14_treated1.png", replace
graph export "$graphs\\wgaps_inf_12_14_treated1.eps", replace

*control            
reg wgap_c_treated0 informal_ss_treated0 if wgap_c != 1 & year == 2012
local r2_1 = e(r2) 
local dr2_1 : di %4.3f `r2_1'
reg wgap_c_treated0 informal_ss_treated0 if wgap_c != 1 & year == 2014
local r2_2 = e(r2)
local dr2_2 : di %4.3f `r2_2'
twoway (scatter wgap_c_treated0 informal_ss_treated0  if wgap_c != 1 & year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs12) ///
                                                       mlcolor(gs5) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter wgap_c_treated0 informal_ss_treated0  if wgap_c != 1 & year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       mlabsize(2) ///
                                                       mlabposition(12) ///
                                                       mlabcolor(black) ///
                                                       mlabt(tick_label) ///                                                                                  
                                                       msymbol(O) ///    
                                                       ) ///
       , ylabel(0.5(0.05)1, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(82(2)98, labsize(small) glwidth(small) ) ///
         title("All", color(black) size(medsmall))             ///
         xtitle("Workers informality rate (%)", size(small))             ///
         ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
         yline(1, lcolor(gs11) lpattern(solid)) ///
         text(0.55 87 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
         text(0.50 87 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
         legend(order(1 2) label(1 "2012") label(2 "2014") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///
         saving("$graphs\\stata\\wgaps_inf_12_14_treated0", replace)         

graph export "$graphs\\wgaps_inf_12_14_treated0.png", replace
graph export "$graphs\\wgaps_inf_12_14_treated0.eps", replace

*by quintiles
*control
forvalues q = 1/5 { 
        reg wgap_c_treated0_q`q' informal_ss_treated0 if wgap_c != 1 & year == 2012
        local r2_1 = e(r2) 
        local dr2_1 : di %4.3f `r2_1'
        reg wgap_c_treated0_q`q' informal_ss_treated0 if wgap_c != 1 & year == 2014
        local r2_2 = e(r2)
        local dr2_2 : di %4.3f `r2_2'
        twoway (scatter wgap_c_treated0_q`q' informal_ss_treated0  if year == 2012, ///
                                                               msize(med) /// 
                                                               mfcolor(gs12) ///          
                                                               mlcolor(gs5) ///           
                                                               mlabsize(2) ///
                                                               mlabposition(12) ///   
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///          
                                                               ) ///
               (scatter wgap_c_treated0_q`q' informal_ss_treated0  if year == 2014, /// 
                                                               msize(med) /// 
                                                               mfcolor(gs4) ///
                                                               mlcolor(gs0) ///
                                                               mlabsize(2) ///               
                                                               mlabposition(6) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               , ylabel(0.3(0.1)1.3, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
                 xlabel(80(2)100, labsize(small) glwidth(small) ) ///
                 title("Quintile `q'", color(black))             ///
                 xtitle("Workers informality rate (%)", size(small))             ///
                 ytitle("Hourly wage gap (Bogota=1)", size(small))    ///                        
                 yline(1, lcolor(gs11) lpattern(solid)) ///
                 text(0.5 86 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
                 text(0.4 86 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
                 legend(order(1 2) label(1 "2012") label(2 "2014") ///
                        size(small) ///
                       ) ///
                 graphregion(color(white)) bgcolor(white) ///
                 saving("$graphs\\stata\\wgaps_inf_12_14_treated0_q`q'", replace)
        
        graph export "$graphs\\wgaps_inf_12_14_treated0_q`q'.png", replace
        graph export "$graphs\\wgaps_inf_12_14_treated0_q`q'.eps", replace
    }

*treated    
forvalues q = 1/5 { 
        reg wgap_c_treated1_q`q' informal_ss_treated1 if wgap_c != 1 & year == 2012
        local r2_1 = e(r2) 
        local dr2_1 : di %4.3f `r2_1'
        reg wgap_c_treated1_q`q' informal_ss_treated1 if wgap_c != 1 & year == 2014
        local r2_2 = e(r2)
        local dr2_2 : di %4.3f `r2_2'
        twoway (scatter wgap_c_treated1_q`q' informal_ss_treated1  if year == 2012, ///
                                                               msize(med) /// 
                                                               mfcolor(gs12) ///
                                                               mlcolor(gs5) ///
                                                               mlabsize(2) ///
                                                               mlabposition(12) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               (scatter wgap_c_treated1_q`q' informal_ss_treated1  if year == 2014, /// 
                                                               msize(med) /// 
                                                               mfcolor(gs4) ///
                                                               mlcolor(gs0) ///
                                                               mlabsize(2) ///
                                                               mlabposition(6) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               , ylabel(0.3(0.1)1.3, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
                 xlabel(10(5)65, labsize(small) glwidth(small) ) ///
                 title("Quintile `q'", color(black))             ///
                 xtitle("Workers informality rate (%)", size(small))             ///
                 ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
                 yline(1, lcolor(gs11) lpattern(solid)) ///
                 text(0.5 30 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
                 text(0.4 30 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
                 legend(order(1 2) label(1 "2012") label(2 "2014") ///
                        size(small) ///
                       ) ///
                 graphregion(color(white)) bgcolor(white) ///
                 saving("$graphs\\stata\\wgaps_inf_12_14_treated1_q`q'", replace)
        
        graph export "$graphs\\wgaps_inf_12_14_treated1_q`q'.png", replace
        graph export "$graphs\\wgaps_inf_12_14_treated1_q`q'.eps", replace
 }

graph combine "$graphs\\stata\\wgaps_inf_12_14_treated1_q1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_q2.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_q3.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_q4.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_q5.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5) title("Salaried (treated)", color(black)) ///
                saving("$graphs\\stata\\wgaps_inf_12_14_treated1", replace)

graph combine "$graphs\\stata\\wgaps_inf_12_14_treated0_q1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_q2.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_q3.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_q4.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_q5.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5) title("Self-employed (control)", color(black)) ///
                saving("$graphs\\stata\\wgaps_inf_12_14_treated0", replace)
                
graph combine "$graphs\\stata\\wgaps_inf_12_14_treated1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(2) altshrink iscale(1.1) ///

graph export "$graphs\\wgaps_inf_12_14.png", replace

*control/treated around 1 MW
*treated    
forvalues i = 1/9 {
   		local j = 10 - `i'
        reg wgap_c_treated1_nmw_`j'_`i' informal_ss_treated1 if wgap_c != 1 & year == 2012
        local r2_1 = e(r2) 
        local dr2_1 : di %4.3f `r2_1'
        reg wgap_c_treated1_nmw_`j'_`i' informal_ss_treated1 if wgap_c != 1 & year == 2014
        local r2_2 = e(r2)
        local dr2_2 : di %4.3f `r2_2'
        twoway (scatter wgap_c_treated1_nmw_`j'_`i' informal_ss_treated1  if year == 2012, ///
                                                               msize(med) /// 
                                                               mfcolor(gs12) ///
                                                               mlcolor(gs5) ///
                                                               mlabsize(2) ///
                                                               mlabposition(12) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               (scatter wgap_c_treated1_nmw_`j'_`i' informal_ss_treated1  if year == 2014, /// 
                                                               msize(med) /// 
                                                               mfcolor(gs4) ///
                                                               mlcolor(gs0) ///
                                                               mlabsize(2) ///
                                                               mlabposition(6) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               , ylabel(0.9(0.01)1.05, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
                 xlabel(10(10)60, labsize(small) glwidth(small) ) ///
                 title("# MWs [0.`j',1.`i']", color(black) size(medsmall))             ///
                 xtitle("Workers informality rate (%)", size(small))             ///
                 ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
                 yline(1, lcolor(gs11) lpattern(solid)) ///
                 text(0.92 26 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
                 text(0.90 26 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
                 legend(order(1 2) label(1 "2012") label(2 "2014") ///
                        size(small) ///
                       ) ///
                 graphregion(color(white)) bgcolor(white) ///
                 saving("$graphs\\stata\\wgaps_inf_12_14_treated1_nmw_`j'_`i'", replace)
        
        graph export "$graphs\\wgaps_inf_12_14_treated1_nmw_`j'_`i'.png", replace
        graph export "$graphs\\wgaps_inf_12_14_treated1_nmw_`j'_`i'.eps", replace
 }

*control    
forvalues i = 1/9 {
   		local j = 10 - `i'
        reg wgap_c_treated0_nmw_`j'_`i' informal_ss_treated0 if wgap_c != 1 & year == 2012
        local r2_1 = e(r2) 
        local dr2_1 : di %4.3f `r2_1'
        reg wgap_c_treated0_nmw_`j'_`i' informal_ss_treated0 if wgap_c != 1 & year == 2014
        local r2_2 = e(r2)
        local dr2_2 : di %4.3f `r2_2'
        twoway (scatter wgap_c_treated0_nmw_`j'_`i' informal_ss_treated0  if year == 2012, ///
                                                               msize(med) /// 
                                                               mfcolor(gs12) ///
                                                               mlcolor(gs5) ///
                                                               mlabsize(2) ///
                                                               mlabposition(12) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               (scatter wgap_c_treated0_nmw_`j'_`i' informal_ss_treated0  if year == 2014, /// 
                                                               msize(med) /// 
                                                               mfcolor(gs4) ///
                                                               mlcolor(gs0) ///
                                                               mlabsize(2) ///
                                                               mlabposition(6) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               , ylabel(0.9(0.01)1.05, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
                 xlabel(82(2)98, labsize(small) glwidth(small) ) ///
                 title("# MWs [0.`j',1.`i']", color(black) size(medsmall))             ///
                 xtitle("Workers informality rate (%)", size(small))             ///
                 ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
                 yline(1, lcolor(gs11) lpattern(solid)) ///
                 text(0.92 87 "{bf:R{sup:2}{sub:2012}=`dr2_1'}", color(gray) size(medium)) ///
                 text(0.90 87 "{bf:R{sup:2}{sub:2014}=`dr2_2'}", color(gs4) size(medium)) ///
                 legend(order(1 2) label(1 "2012") label(2 "2014") ///
                        size(small) ///
                       ) ///
                 graphregion(color(white)) bgcolor(white) ///
                 saving("$graphs\\stata\\wgaps_inf_12_14_treated0_nmw_`j'_`i'", replace)
        
        graph export "$graphs\\wgaps_inf_12_14_treated0_nmw_`j'_`i'.png", replace
        graph export "$graphs\\wgaps_inf_12_14_treated0_nmw_`j'_`i'.eps", replace
 }
 
graph combine "$graphs\\stata\\wgaps_inf_12_14_treated1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_nmw_9_1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_nmw_8_2.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated1_nmw_7_3.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5) title("Salaried (treated)", color(black)) ///
                saving("$graphs\\stata\\wgaps_inf_12_14_nmw_treated1", replace)

graph combine "$graphs\\stata\\wgaps_inf_12_14_treated0.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_nmw_9_1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_nmw_8_2.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_treated0_nmw_7_3.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(1) altshrink iscale(1.5) title("Self-employed (control)", color(black)) ///
                saving("$graphs\\stata\\wgaps_inf_12_14_nmw_treated0", replace)
                
graph combine "$graphs\\stata\\wgaps_inf_12_14_nmw_treated1.gph" ///
              "$graphs\\stata\\wgaps_inf_12_14_nmw_treated0.gph" ///
              , graphregion(color(white) lwidth(vvvthick)) rows(2) altshrink iscale(1.1) ///

graph export "$graphs\\wgaps_inf_12_14_nmw.png", replace


exit
*by deciles
forvalues t = 0/1 {
    forvalues d = 1/10 { 
        twoway (scatter wgap_c_treated`t'_d`d' informal_ss  if year == 2012, ///
                                                               msize(med) /// 
                                                               mfcolor(gs12) ///
                                                               mlcolor(gs5) ///
                                                               mlabel(city_graph) ///
                                                               mlabsize(2) ///
                                                               mlabposition(12) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               (scatter wgap_c_treated`t'_d`d' informal_ss  if year == 2014, /// 
                                                               msize(med) /// 
                                                               mfcolor(gs4) ///
                                                               mlcolor(gs0) ///
                                                               mlabel(city_graph) ///                                                           
                                                               mlabsize(2) ///
                                                               mlabposition(6) ///
                                                               mlabcolor(black) ///
                                                               mlabt(tick_label) ///                                                                                  
                                                               msymbol(O) ///    
                                                               ) ///
               (lfit wgap_c_treated`t'_d`d' informal_ss if wgap_c != 1 & year == 2012, lcolor(gs12)) ///
               (lfit wgap_c_treated`t'_d`d' informal_ss if wgap_c != 1 & year == 2014, lcolor(black)) ///
               , ylabel(0.3(0.05)1.3, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
                 xlabel(40(2)80, labsize(small) glwidth(small) ) ///
                 xtitle("City informality rate (%)", size(small))             ///
                 ytitle("Hourly wage gap (Bogota=1)", size(small))    ///
                 xline(0, lcolor(gs11) lpattern(dash)) ///
                 yline(1, lcolor(gs11) lpattern(solid)) ///
                 legend(order(1 2) label(1 "2012") label(2 "2014") ///
                        size(small) ///
                       ) ///
                 graphregion(color(white)) bgcolor(white) ///
        
        graph export "$graphs\\wgaps_inf_12_14_treated`t'_d`d'.png", replace
        graph export "$graphs\\wgaps_inf_12_14_treated`t'_d`d'.eps", replace
    }
}

*correlations
*------------
use "$tables\\wgaps_inf_corrs", clear
forvalues t = 0/1 {
    twoway line corrs_tr`t'_q* year if year >=2009 & year <=2016, lwidth(thick thick thick thick thick) /// 
                                                          lcolor(gs0 gs4 gs8 gs12 gs14) ///
             ylabel(-.9(0.05)0.2, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) ) ///
             xlabel(2009(1)2016, labsize(small) glwidth(small) angle(0)) ///
             xtitle("")             ///
             ytitle("Informality-wage gap correlation", axis(1) size(small))    ///
             yline(0, lcolor(gs11) lpattern(solid)) ///
             xline(2012, lcolor(gs11) lpattern(dash)) ///
             text(-0.1 2012.5 "Tax reform", color(gray) size(small)) ///
             legend(label(1 "Q1") label(2 "Q2") label(3 "Q3") label(4 "Q4") label(5 "Q5")) ///         
             legend(size(small) region(lcolor(white)) rows(1)) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\wgaps_inf_corrs_tr`t'.png", replace
}

*-------------------------
*Population and mean wages
*-------------------------
use "$tables\\pop_w_mean_for_inf", clear

gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*treated+control+logs                         
twoway (scatter lpop_city lw_hr_real_i0 if year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter lpop_city lw_hr_real_i0 if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter lpop_city lw_hr_real_i1 if year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(T) ///    
                                                       ) ///
       (scatter lpop_city lw_hr_real_i1 if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(T) ///    
                                                       ) ///
       (lfit lpop_city lw_hr_real_i0 if year == 2012, lcolor(gs5) lpattern(dash) ) ///
       (lfit lpop_city lw_hr_real_i0 if year == 2014, lcolor(gs0) lpattern(dash) ) ///
       (lfit lpop_city lw_hr_real_i1 if year == 2012, lcolor(gs5) lpattern(solid) ) ///
       (lfit lpop_city lw_hr_real_i1 if year == 2014, lcolor(gs0) lpattern(solid) ) ///
       , ylabel(10(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(7.7(0.1)8.5, labsize(small) glwidth(small) ) ///
         xtitle("log(real hourly wage)", size(small))             ///
         ytitle("log(population)", size(small))    ///
         xline(0, lcolor(gs11) lpattern(dash)) ///
         yline(1, lcolor(gs11) lpattern(solid)) ///         
         legend(rows(2) /// 
                label(1 "Informal" "2012") label(2 "Informal" "2014") label(3 "Formal" "2012") label(4 "Formal" "2014") ///
                label(5 "Informal" "2012") label(6 "Informal" "2014") label(7 "Formal" "2012") label(8 "Formal" "2014") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\pop_wage_for_inf_12_14_log.png", replace
graph export "$graphs\\pop_wage_for_inf_12_14_log.eps", replace

*population vs wages:all+formal+informal
forvalues y = 2008/2018 {
	reg lw_hr_real    lpop_city if year == `y'
	mat define betas = e(b)
	scalar b = betas[1,1]
	local db_all : di %4.3f scalar(b)
	mat define rtable = r(table)
	scalar pvalue = rtable[4,1]
	local s   = "*"
	local ss  = "**"
	local sss = "***"
	if scalar(pvalue) < .01 {
	    local str_b_all : di %1s "`db_all'""`sss'"""
	}
	if scalar(pvalue) > .01 & scalar(pvalue) < .05 {
	    local str_b_all : di %1s "`db_all'""`ss'"""
	}
	if scalar(pvalue) > .05 & scalar(pvalue) < .1 {
	    local str_b_all : di %1s "`db_all'""`s'"""
	}
	if scalar(pvalue) > 0.1 {
	    local str_b_all : di %1s "`db_all'"
	}
	display "`str_b_all'"
	
	reg lw_hr_real_i0 lpop_city if year == `y'
	mat define betas = e(b)
	scalar b = betas[1,1]
	local db_for : di %4.3f scalar(b)
	mat define rtable = r(table)
	scalar pvalue = rtable[4,1]
	local s   = "*"
	local ss  = "**"
	local sss = "***"
	if scalar(pvalue) < .01 {
	    local str_b_for : di %1s "`db_for'""`sss'"""
	}
	if scalar(pvalue) > .01 & scalar(pvalue) < .05 {
	    local str_b_for : di %1s "`db_for'""`ss'"""
	}
	if scalar(pvalue) > .05 & scalar(pvalue) < .1 {
	    local str_b_for : di %1s "`db_for'""`s'"""
	}
	if scalar(pvalue) > 0.1 {
	    local str_b_for : di %1s "`db_for'"
	}
	display "`str_b_for'"
	
	reg lw_hr_real_i1 lpop_city if year == `y'
	mat define betas = e(b)
	scalar b = betas[1,1]
	local db_inf : di %4.3f scalar(b)
	mat define rtable = r(table)
	scalar pvalue = rtable[4,1]
	local s   = "*"
	local ss  = "**"
	local sss = "***"
	if scalar(pvalue) < .01 {
	    local str_b_inf : di %1s "`db_inf'""`sss'"""
	}
	if scalar(pvalue) > .01 & scalar(pvalue) < .05 {
	    local str_b_inf : di %1s "`db_inf'""`ss'"""
	}
	if scalar(pvalue) > .05 & scalar(pvalue) < .1 {
	    local str_b_inf : di %1s "`db_inf'""`s'"""
	}
	if scalar(pvalue) > 0.1 {
	    local str_b_inf : di %1s "`db_inf'"
	}
	display "`str_b_inf'"
                   
	twoway (scatter lw_hr_real    lpop_city if year == `y', ///
	                                                       msize(med) /// 
	                                                       mfcolor(gs14) ///
	                                                       mlcolor(gs5) ///
	                                                       msymbol(O) ///    
	                                                       ) /// 
	       (scatter lw_hr_real_i0 lpop_city if year == `y', ///
	       													mlabel(city_graph) ///
	       													mlabposition(3) ///
	       													mlabsize(small) ///   
                                                            mlabcolor(black) ///
	                                                       msize(med) /// 
	                                                       mfcolor(green) ///
	                                                       mlcolor(dkgreen) ///
	                                                       msymbol(S) ///    
	                                                       ) ///
	       (scatter lw_hr_real_i1 lpop_city if year == `y', ///
	                                                       msize(med) /// 
	                                                       mfcolor(orange) ///
	                                                       mlcolor(dkorange) ///
	                                                       msymbol(T) ///    
	                                                       ) ///
	       (lfit lw_hr_real    lpop_city if year == `y', lcolor(gs5) lpattern(solid) ) ///
	       (lfit lw_hr_real_i0 lpop_city if year == `y', lcolor(green) lpattern(dash) ) ///
	       (lfit lw_hr_real_i1 lpop_city if year == `y', lcolor(orange) lpattern(dash) ) ///
	       , ylabel(7.6(0.1)9.1, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
	         xlabel(11(0.5)16, labsize(small) glwidth(small) ) ///
	         xtitle("log(population)", size(small))             ///
	         ytitle("log(real hourly wage)", size(small))    ///
	         text(8.3 11.3 "{bf:b=`str_b_all'}", color(gs5)      size(small)) ///
	         text(8.75 15.7   "{bf:b=`str_b_for'}", color(dkgreen)  size(small)) ///
	         text(8.0 15.7   "{bf:b=`str_b_inf'}", color(dkorange) size(small)) ///
	         legend(rows(1) /// 
	                label(1 "All" "workers") label(2 "Formal") label(3 "Informal") ///
	                size(small) ///
	                order(1 2 3) ///
	               ) ///
	         graphregion(color(white)) bgcolor(white) ///
	
	graph export "$graphs\\log_pop_wage_all_for_inf_`y'.png", replace
	graph export "$graphs\\log_pop_wage_all_for_inf_`y'.eps", replace
}

exit
*treated+control
replace pop_city = pop_city / 1000000
twoway (scatter pop_city w_hr_real_i0 if year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter pop_city w_hr_real_i0 if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter pop_city w_hr_real_i1 if year == 2012, ///
                                                       msize(med) /// 
                                                       mfcolor(gs14) ///
                                                       mlcolor(gs5) ///
                                                       msymbol(T) ///    
                                                       ) ///
       (scatter pop_city w_hr_real_i1 if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(gs4) ///
                                                       mlcolor(gs0) ///
                                                       msymbol(T) ///    
                                                       ) ///
       (lfit pop_city w_hr_real_i0 if year == 2012, lcolor(gs5) lpattern(dash) ) ///
       (lfit pop_city w_hr_real_i0 if year == 2014, lcolor(gs0) lpattern(dash) ) ///
       (lfit pop_city w_hr_real_i1 if year == 2012, lcolor(gs5) lpattern(solid) ) ///
       (lfit pop_city w_hr_real_i1 if year == 2014, lcolor(gs0) lpattern(solid) ) ///
       , ylabel(0(0.5)8, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(3000(200)4800, labsize(small) glwidth(small) ) ///
         xtitle("log(real hourly wage)", size(small))             ///
         ytitle("log(population)", size(small))    ///
         xline(0, lcolor(gs11) lpattern(dash)) ///
         yline(1, lcolor(gs11) lpattern(solid)) ///         
         legend(rows(2) /// 
                label(1 "Informal" "2012") label(2 "Informal" "2014") label(3 "Formal" "2012") label(4 "Formal" "2014") ///
                label(5 "Informal" "2012") label(6 "Informal" "2014") label(7 "Formal" "2012") label(8 "Formal" "2014") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\pop_wage_for_inf_12_14.png", replace
graph export "$graphs\\pop_wage_for_inf_12_14.eps", replace

*formal+informal+logs                         
twoway (scatter lpop_city lw_hr_real_i0 if year == 2014, ///
                                                       msize(med) /// 
                                                       mfcolor(yellow) ///
                                                       mlcolor(black) ///
                                                       msymbol(O) ///    
                                                       ) ///
       (scatter lpop_city lw_hr_real_i1 if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(orange) ///
                                                       mlcolor(black) ///
                                                       msymbol(T) ///    
                                                       ) ///
       (lfit lpop_city lw_hr_real_i0 if year == 2014, lcolor(sand)     lpattern(solid) ) ///
       (lfit lpop_city lw_hr_real_i1 if year == 2014, lcolor(dkorange) lpattern(solid) ) ///
       , ylabel(11(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(7.7(0.1)8.9, labsize(small) glwidth(small) ) ///
         xtitle("log(real hourly wage)", size(small))             ///
         ytitle("log(city population)", size(small))    ///
         legend(rows(2) /// 
                label(1 "Formal") label(2 "Informal") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\pop_wage_for_inf_14_log.png", replace
graph export "$graphs\\pop_wage_for_inf_14_log.eps", replace

*self-employed+salaried+logs 
forvalues y = 2009/2018 {
     sum lmin_wage_hr if year == `y'
     local mw = r(mean)
     
     twoway (rcap lw_hr_real_t0 lw_hr_real_t1 lpop_city if year == `y', ///
                                                                         lcolor(black) ///
                                                                         lpattern(dash) ///
                                                                         ) ///
            (scatter lw_hr_real_t0 lpop_city if year == `y', ///
                                                            msize(med) ///
                                                            mfcolor(orange) ///
                                                            mlcolor(black) ///
                                                            msymbol(S) ///    
                                                            ) ///
            (scatter lw_hr_real_t1 lpop_city if year == `y', /// 
                                                            mlabel(city_graph) ///
                                                            mlabposition(12) ///  
                                                            mlabsize(vsmall) ///   
                                                            mlabcolor(black) ///                                                         
                                                            msize(med) /// 
                                                            mfcolor(yellow) ///
                                                            mlcolor(black) ///
                                                            msymbol(D) ///    
                                                            ) ///
            , xlabel(11.0(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
              ylabel(7.6(0.1)8.5, labsize(small) glwidth(small) glcolor(white) ) ///
              yline(`mw') ///
              ytitle("log(real hourly wage)", size(small))             ///
              xtitle("log(city population)", size(small))    ///
              legend(order(3 2) rows(1) /// 
                     label(2 "Self-employed") label(3 "Salaried") ///
                     size(small) ///
                    ) ///
              graphregion(color(white)) bgcolor(white) ///
     
     graph export "$graphs\\pop_w_mean_se_sal_`y'_log.png", replace
     graph export "$graphs\\pop_w_mean_se_sal_`y'_log.eps", replace
}

twoway (rcap lw_hr_real_t0 lw_hr_real_t1 lpop_city if year == 2014, ///
                                                       msize(med) ///
                                                       mfcolor(orange) ///
                                                       mlcolor(black) ///
                                                       msymbol(S) ///    
                                                       ) ///
       (scatter lw_hr_real_t1 lpop_city if year == 2014, /// 
                                                       msize(med) /// 
                                                       mfcolor(yellow) ///
                                                       mlcolor(black) ///
                                                       msymbol(D) ///    
                                                       ) ///
       , xlabel(11(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         ylabel(7.8(0.1)8.5, labsize(small) glwidth(small) ) ///
         ytitle("log(real hourly wage)", size(small))             ///
         xtitle("log(city population)", size(small))    ///
         legend(order(2 1) rows(1) /// 
                label(1 "Self-employed") label(2 "Salaried") ///
                size(small) ///
               ) ///
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\pop_wage_se_sal_14_log_test.png", replace
graph export "$graphs\\pop_wage_se_sal_14_log_test.eps", replace

*population+informality                         
twoway (scatter lpop_city informal_ss if year == 2014, ///
                                                       msize(med) ///
                                                       mfcolor(orange) ///
                                                       mlcolor(black) ///
                                                       msymbol(S) ///    
                                                       ) ///
       (lfit lpop_city informal_ss if year == 2014, lcolor(dkorange)     lpattern(dash) ) ///
       , ylabel(11(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
         xlabel(58(2)92, labsize(small) glwidth(small) ) ///
         ytitle("log(city population)", size(small))             ///
         xtitle("Informality (%)", size(small))    ///
         legend(off)  ///       
         graphregion(color(white)) bgcolor(white) ///

graph export "$graphs\\pop_inf_14_log.png", replace
graph export "$graphs\\pop_inf_14_log.eps", replace

*population+informality+self-employed+salaried+logs
foreach y in 2012 2014 {
    forvalues i = 0/1 {
        reg informal_ss_t`i' lpop_city   if year == `y' 
        mat define aux = e(b)
        local beta`i' = round(aux[1,1], 0.02)
    }
    
    twoway (scatter informal_ss_t1 lpop_city  if year == `y', /// 
                                                           msize(med) /// 
                                                           mfcolor(yellow) ///
                                                           mlcolor(black) ///
                                                           msymbol(D) ///
                                                           yaxis(1) ///
                                                           ) ///
           (scatter informal_ss_t0 lpop_city  if year == `y', ///
                                                           msize(med) ///
                                                           mfcolor(orange) ///
                                                           mlcolor(black) ///
                                                           msymbol(S) ///
                                                           yaxis(2) ///
                                                           ) ///
           (lfit informal_ss_t1 lpop_city  if year == `y', lcolor(sand)     lpattern(solid) yaxis(1) ) ///                                                       
           (lfit informal_ss_t0 lpop_city  if year == `y', lcolor(dkorange) lpattern(dash)  yaxis(2) ) ///
           , ylabel(15(5)60, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) /// 
             ylabel(55(5)100, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(2)) ///
             xlabel(11.5(0.5)16, labsize(small) glwidth(small) ) ///
             ytitle("Informality (%)", size(small) axis(1))    ///
             ytitle("Informality (%)", size(small) axis(2))    ///
             xtitle("log(city population)", size(small))             ///
             text( 22 15   "b=`beta1'**" ) ///
             text( 51 15.5 "b=`beta0'" ) ///
             legend(rows(1) /// 
                    label(3 "Self-employed" "(right axis)") label(1 "Salaried") ///
                    order(1 3) ///                                 
                    size(small) ///
                   ) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\pop_inf_se_sal_`y'.png", replace
    graph export "$graphs\\pop_inf_se_sal_`y'.eps", replace
}

*----------------------------------------
*Population and median wages 2012 vs 2014
*----------------------------------------
use "$tables\\pop_w_median_for_inf", clear
                      
gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*self-employed+salaried+logs 
forvalues y = 2009/2018 {
     sum lmin_wage_hr if year == `y'
     local mw = r(mean)
     twoway (rcap lw_hr_real_t0 lw_hr_real_t1 lpop_city if year == `y', ///
                                                                         lcolor(black) ///
                                                                         lpattern(dash) ///
                                                                         ) ///
            (scatter lw_hr_real_t0 lpop_city if year == `y', ///
                                                            mlabel(city_graph) ///
                                                            mlabposition(6) ///  
                                                            mlabsize(vsmall) ///   
                                                            mlabcolor(black) ///                                                         
                                                            msize(med) ///
                                                            mfcolor(orange) ///
                                                            mlcolor(black) ///
                                                            msymbol(S) ///    
                                                            ) ///
            (scatter lw_hr_real_t1 lpop_city if year == `y', /// 
                                                            msize(med) /// 
                                                            mfcolor(yellow) ///
                                                            mlcolor(black) ///
                                                            msymbol(D) ///    
                                                            ) ///
            (lfit lw_hr_real_t0 lpop_city if year == `y', lcolor(orange)) ///
            (lfit lw_hr_real_t1 lpop_city if year == `y', lcolor(gold)) ///
            , xlabel(11.0(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
              ylabel(7.2(0.1)8.2, labsize(small) glwidth(small) glcolor(white) ) ///
              yline(`mw', lcolor(red) lpattern(dash) ) ///
              ytitle("median log(real hourly wage)", size(small))             ///
              xtitle("log(city population)", size(small))    ///
              legend(order(3 2) rows(1) /// 
                     label(2 "Self-employed") label(3 "Salaried") ///
                     size(small) ///
                    ) ///
              graphregion(color(white)) bgcolor(white) ///
     
     graph export "$graphs\\pop_w_median_se_sal_`y'_log.png", replace
     graph export "$graphs\\pop_w_median_se_sal_`y'_log.eps", replace
}
exit
*---------------------------
*Population and nominal wages
*---------------------------
*mean wages
use "$tables\\pop_w_mean_for_inf_nominal", clear

gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*self-employed+salaried+logs 
forvalues y = 2009/2018 {
     sum lmin_wage_hr if year == `y'
     local mw = r(mean)
     
     twoway (rcap lw_hr_real_t0 lw_hr_real_t1 lpop_city if year == `y', ///
                                                                         lcolor(black) ///
                                                                         lpattern(dash) ///
                                                                         ) ///
            (scatter lw_hr_real_t0 lpop_city if year == `y', ///
                                                            msize(med) ///
                                                            mfcolor(orange) ///
                                                            mlcolor(black) ///
                                                            msymbol(S) ///    
                                                            ) ///
            (scatter lw_hr_real_t1 lpop_city if year == `y', /// 
                                                            mlabel(city_graph) ///
                                                            mlabposition(12) ///  
                                                            mlabsize(vsmall) ///   
                                                            mlabcolor(black) ///                                                         
                                                            msize(med) /// 
                                                            mfcolor(yellow) ///
                                                            mlcolor(black) ///
                                                            msymbol(D) ///    
                                                            ) ///
            , xlabel(11.0(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
              ylabel(7.6(0.1)8.9, labsize(small) glwidth(small) glcolor(white) ) ///
              yline(`mw') ///
              ytitle("log(real hourly wage)", size(small))             ///
              xtitle("log(city population)", size(small))    ///
              legend(order(3 2) rows(1) /// 
                     label(2 "Self-employed") label(3 "Salaried") ///
                     size(small) ///
                    ) ///
              graphregion(color(white)) bgcolor(white) ///
     
     graph export "$graphs\\pop_w_mean_se_sal_`y'_log_nominal.png", replace
     graph export "$graphs\\pop_w_mean_se_sal_`y'_log_nominal.eps", replace
}

*---------------------------
*Population and mean # MWs
*---------------------------
*mean wages
use "$tables\\pop_w_mean_for_inf", clear

gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*self-employed+salaried+logs 
forvalues y = 2009/2018 {
     sum lmin_wage_hr if year == `y'
     local mw = r(mean)
     
     twoway (rcap nr_mw_hr_t0 nr_mw_hr_t1 lpop_city if year == `y', ///
                                                                         lcolor(black) ///
                                                                         lpattern(dash) ///
                                                                         ) ///
            (scatter nr_mw_hr_t0 lpop_city if year == `y', ///
                                                            msize(med) ///
                                                            mfcolor(orange) ///
                                                            mlcolor(black) ///
                                                            msymbol(S) ///    
                                                            ) ///
            (scatter nr_mw_hr_t1 lpop_city if year == `y', /// 
                                                            mlabel(city_graph) ///
                                                            mlabposition(12) ///  
                                                            mlabsize(vsmall) ///   
                                                            mlabcolor(black) ///                                                         
                                                            msize(med) /// 
                                                            mfcolor(yellow) ///
                                                            mlcolor(black) ///
                                                            msymbol(D) ///    
                                                            ) ///
            , xlabel(11.0(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
              ylabel(0.7(0.1)1.8, labsize(small) glwidth(small) glcolor(white) ) ///
              yline(1) ///
              ytitle("mean # MW hourly", size(small))             ///
              xtitle("log(city population)", size(small))    ///
              legend(order(3 2) rows(1) /// 
                     label(2 "Self-employed") label(3 "Salaried") ///
                     size(small) ///
                    ) ///
              graphregion(color(white)) bgcolor(white) ///
     
     graph export "$graphs\\pop_w_mean_se_sal_`y'_nrmws.png", replace
     graph export "$graphs\\pop_w_mean_se_sal_`y'_nrmws.eps", replace
}

*---------------------------
*Population and median # MWs
*---------------------------
*mean wages
use "$tables\\pop_w_median_for_inf", clear

gen city_graph = city
label define city_graph 11 "BOG" ///
                        5  "MED" ///
                        76 "CALI" ///
                        8  "BARR" ///
                        68 "BUC" ///
                        17 "MAN" ///
                        52 "PAS" ///
                        66 "PER" ///
                        54 "CUC" ///
                        73 "IBA" ///
                        23 "MON" ///
                        13 "CAR" ///
                        50 "VIL" ///
                        15 "TUN" ///
                        18 "FLO" ///
                        19 "POP" ///
                        20 "VAL" ///
                        27 "QUI" ///
                        41 "NEI" ///
                        44 "RIO" ///
                        47 "SM" ///
                        63 "ARM" ///
                        70 "SIN" ///
                        99 "REST" ///
                          
label values  city_graph city_graph

*self-employed+salaried+logs 
forvalues y = 2009/2018 {
     sum lmin_wage_hr if year == `y'
     local mw = r(mean)
     twoway (rcap nr_mw_hr_t0 nr_mw_hr_t1 lpop_city if year == `y', ///
                                                                         lcolor(black) ///
                                                                         lpattern(dash) ///
                                                                         ) ///
            (scatter nr_mw_hr_t0 lpop_city if year == `y', ///
                                                            mlabel(city_graph) ///
                                                            mlabposition(6) ///  
                                                            mlabsize(vsmall) ///   
                                                            mlabcolor(black) ///                                                         
                                                            msize(med) ///
                                                            mfcolor(orange) ///
                                                            mlcolor(black) ///
                                                            msymbol(S) ///    
                                                            ) ///
            (scatter nr_mw_hr_t1 lpop_city if year == `y', /// 
                                                            msize(med) /// 
                                                            mfcolor(yellow) ///
                                                            mlcolor(black) ///
                                                            msymbol(D) ///    
                                                            ) ///
            , xlabel(11.0(0.5)16, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
              ylabel(0.5(0.1)1.3, labsize(small) glwidth(small) glcolor(white) ) ///
              yline(1) ///
              ytitle("median # MW hourly", size(small))             ///
              xtitle("log(city population)", size(small))    ///
              legend(order(3 2) rows(1) /// 
                     label(2 "Self-employed") label(3 "Salaried") ///
                     size(small) ///
                    ) ///
              graphregion(color(white)) bgcolor(white) ///
     
     graph export "$graphs\\pop_w_median_se_sal_`y'_nrmws.png", replace
     graph export "$graphs\\pop_w_median_se_sal_`y'_nrmws.eps", replace
}

*---------------------------------
*DDD estimates log(hourly real wage)	Above 1 hourly MW
*---------------------------------
use "$tables\\reg_ddd_post2_cities_tr_treated_graph", clear

gen     inf_class = .
replace inf_class = 1 if city == 11 | city == 17 | city == 5  |city == 66 |city == 76
replace inf_class = 2 if inf_class == .
label define inf_class 1 "Low" ///
                       2 "High" ///
                       
label values inf_class inf_class
label var inf_class "informality class"

foreach g in all 9_1 8_2 7_3 { 
    gen  above1mw_`g'_ul = above1mw_`g' + above1mw_`g'_se
    gen  above1mw_`g'_ll = above1mw_`g' - above1mw_`g'_se
    gen  lw_hr_real_`g'_ul = lw_hr_real_`g' + lw_hr_real_`g'_se
    gen  lw_hr_real_`g'_ll = lw_hr_real_`g' - lw_hr_real_`g'_se
    
}

graph set window fontface "Courier New"

foreach g in all {    
    twoway (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) horizontal ) ///
           (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) horizontal ) ///
           (scatter above1mw_`g' lw_hr_real_`g'  if inf_class == 1 & city != 23, ///
                                                           msize(med) ///
                                                           mfcolor(green) ///
                                                           mlcolor(black) ///
                                                           msymbol(O) ///    
                                                           ) ///
           (scatter above1mw_`g' lw_hr_real_`g' if inf_class == 2 & city != 23, ///
                                                                  msize(med) ///
                                                                  mfcolor(red) ///
                                                                  mlcolor(black) ///
                                                                  msymbol(O) ///    
                                                                  ) ///
           , ylabel(-0.06(0.02)0.12, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
             xlabel(-0.12(0.02)0.14, labsize(small) glwidth(small) ) ///
             yline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             xline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             ytitle("Above 1 hourly MW", size(small))             ///
             xtitle("log(hourly real wage)", size(small))    ///
             legend(rows(1) order(5 6) /// 
                    label(5 "Low") label(6 "High") ///
                    size(small) ///
                   ) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\ddd_post2_cities_`g'.png", replace
    graph export "$graphs\\ddd_post2_cities_`g'.eps", replace
}

foreach g in 9_1 {
    twoway (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) horizontal ) ///
           (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) horizontal ) ///
           (scatter above1mw_`g' lw_hr_real_`g'  if inf_class == 1 & city != 23, ///
                                                           msize(med) ///
                                                           mfcolor(green) ///
                                                           mlcolor(black) ///
                                                           msymbol(O) ///    
                                                           ) ///
           (scatter above1mw_`g' lw_hr_real_`g' if inf_class == 2 & city != 23, ///
                                                                  msize(med) ///
                                                                  mfcolor(red) ///
                                                                  mlcolor(black) ///
                                                                  msymbol(O) ///    
                                                                  ) ///
           , ylabel(-0.100(0.05)0.250, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
             xlabel(-0.002(0.004)0.026, labsize(small) glwidth(small) ) ///
             yline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             xline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             ytitle("Above 1 hourly MW", size(small) margin(zero))             ///
             xtitle("log(hourly real wage)", size(small))    ///
             legend(rows(1) order(5 6) /// 
                    label(5 "Low") label(6 "High") ///
                    size(small) ///
                   ) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\ddd_post2_cities_`g'.png", replace
    graph export "$graphs\\ddd_post2_cities_`g'.eps", replace
}

foreach g in 8_2 {
    twoway (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) horizontal ) ///
           (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) horizontal ) ///
           (scatter above1mw_`g' lw_hr_real_`g'  if inf_class == 1 & city != 23, ///
                                                           msize(med) ///
                                                           mfcolor(green) ///
                                                           mlcolor(black) ///
                                                           msymbol(O) ///    
                                                           ) ///
           (scatter above1mw_`g' lw_hr_real_`g' if inf_class == 2 & city != 23, ///
                                                                  msize(med) ///
                                                                  mfcolor(red) ///
                                                                  mlcolor(black) ///
                                                                  msymbol(O) ///    
                                                                  ) ///
           , ylabel(-0.10(0.02)0.18, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
             xlabel(-0.02(0.01)0.04, labsize(small) glwidth(small) ) ///
             yline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             xline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             ytitle("Above 1 hourly MW", size(small))             ///
             xtitle("log(hourly real wage)", size(small))    ///
             legend(rows(1) order(5 6) /// 
                    label(5 "Low") label(6 "High") ///
                    size(small) ///
                   ) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\ddd_post2_cities_`g'.png", replace
    graph export "$graphs\\ddd_post2_cities_`g'.eps", replace
}
exit
foreach g in 7_3 {
    twoway (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 1 & city != 23, lstyle(ci) lcolor(dkgreen) horizontal ) ///
           (rcap above1mw_`g'_ul   above1mw_`g'_ll   lw_hr_real_`g' if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) ) ///
           (rcap lw_hr_real_`g'_ul lw_hr_real_`g'_ll above1mw_`g'   if inf_class == 2 & city != 23, lstyle(ci) lcolor(cranberry) horizontal ) ///
           (scatter above1mw_`g' lw_hr_real_`g'  if inf_class == 1 & city != 23, ///
                                                           msize(med) ///
                                                           mfcolor(green) ///
                                                           mlcolor(black) ///
                                                           msymbol(O) ///    
                                                           ) ///
           (scatter above1mw_`g' lw_hr_real_`g' if inf_class == 2 & city != 23, ///
                                                                  msize(med) ///
                                                                  mfcolor(red) ///
                                                                  mlcolor(black) ///
                                                                  msymbol(O) ///    
                                                                  ) ///
           , ylabel(-0.08(0.02)0.12, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
             xlabel(-0.04(0.01)0.03, labsize(small) glwidth(small) ) ///
             yline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             xline(0, lwidth(med) lcolor(gray) lpattern(dot)) ///
             ytitle("Above 1 hourly MW", size(small))             ///
             xtitle("log(hourly real wage)", size(small))    ///
             legend(rows(1) order(5 6) /// 
                    label(5 "Low") label(6 "High") ///
                    size(small) ///
                   ) ///
             graphregion(color(white)) bgcolor(white) ///
    
    graph export "$graphs\\ddd_post2_cities_`g'.png", replace
    graph export "$graphs\\ddd_post2_cities_`g'.eps", replace
}
exit
*salaried-all wages
*------------------
*2011-2014
use "$tables\w_prop_11_14_tr1", clear

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_med w_hr_real_low above1mw_hr_high above1mw_hr_med above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages-raw
twoway (line          w_hr_real_high w_hr_real_med w_hr_real_low   year_m,  /// 
             lwidth(  med            med           med   ) ///
             lcolor(  black          gs5           gs10  ) ///
             lpattern(solid          solid         solid ) ///
             cmissing(n) ///
             ) ///
        (lfit w_hr_real_high year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit w_hr_real_high year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit w_hr_real_high year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit w_hr_real_high year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit w_hr_real_med year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs5) lpattern(solid) ) ///              
        (lfit w_hr_real_med year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs5) lpattern(solid) ) ///
        (lfit w_hr_real_med year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs5) lpattern(solid) ) /// 
        (lfit w_hr_real_med year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs5) lpattern(solid) ) ///
        ///     
        (lfit w_hr_real_low year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit w_hr_real_low year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit w_hr_real_low year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit w_hr_real_low year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(3000(200)4800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(612(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(612(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(4800 633 "reform" "passed",  color(gray) size(small) ) ///
          text(4800 643.5 "1st" "tax" "waiver", color(gray) size(small) ) ///
          text(4800 650.5 "final" "tax" "waiver", color(gray) size(small) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Medium") ///
                 label(3 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2 3)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_11_14_tr1.png", replace
graph export "$graphs\\w_11_14_tr1.eps", replace

*wages-quartertly moving average
twoway (line          w_hr_real_high_ma3 w_hr_real_med_ma3 w_hr_real_low_ma3   year_m,  /// 
             lwidth(  med            med           med   ) ///
             lcolor(  black          gs5           gs10  ) ///
             lpattern(solid          solid         solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(3000(200)4800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(612(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(612(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(4800 633 "reform" "passed",  color(gray) size(small) ) ///
          text(4800 643.5 "1st" "tax" "waiver", color(gray) size(small) ) ///
          text(4800 650.5 "final" "tax" "waiver", color(gray) size(small) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Medium") ///
                 label(3 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2 3)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_11_14_tr1_ma3.png", replace
graph export "$graphs\\w_11_14_tr1_ma3.eps", replace
                               
*proportion-raw
twoway (line          above1mw_hr_high above1mw_hr_med above1mw_hr_low   year_m,  /// 
             lwidth(  med            med           med   ) ///
             lcolor(  black          gs5           gs10  ) ///
             lpattern(solid          solid         solid ) ///
             cmissing(n) ///
             ) ///
        (lfit above1mw_hr_high year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit above1mw_hr_high year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit above1mw_hr_high year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit above1mw_hr_high year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit above1mw_hr_med year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs5) lpattern(solid) ) ///              
        (lfit above1mw_hr_med year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs5) lpattern(solid) ) ///
        (lfit above1mw_hr_med year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs5) lpattern(solid) ) /// 
        (lfit above1mw_hr_med year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs5) lpattern(solid) ) ///
        ///     
        (lfit above1mw_hr_low year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit above1mw_hr_low year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit above1mw_hr_low year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit above1mw_hr_low year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(38(2)78, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(612(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(612(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(78 633 "reform" "passed",  color(gray) size(small) ) ///
          text(78 643.5 "1st" "tax" "waiver", color(gray) size(small) ) ///
          text(78 650.5 "final" "tax" "waiver", color(gray) size(small) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Medium") ///
                 label(3 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2 3)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_11_14_tr1.png", replace
graph export "$graphs\\prop_11_14_tr1.eps", replace
          
*proportion-quarterly moving average
twoway (line          above1mw_hr_high_ma3 above1mw_hr_med_ma3 above1mw_hr_low_ma3   year_m,  /// 
             lwidth(  med            med           med   ) ///
             lcolor(  black          gs5           gs10  ) ///
             lpattern(solid          solid         solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(38(2)78, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(612(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(612(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(58 633 "reform" "passed",  color(gray) size(small) ) ///
          text(58 643.5 "1st" "tax" "waiver", color(gray) size(small) ) ///
          text(58 650.5 "final" "tax" "waiver", color(gray) size(small) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Medium") ///
                 label(3 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2 3)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_11_14_tr1_ma3.png", replace
graph export "$graphs\\prop_11_14_tr1_ma3.eps", replace

*2008-2014
*---------
*salaried-monthly
use "$tables\w_prop_08_14_tr1", clear

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages-raw
twoway (line          w_hr_real_high w_hr_real_low   year_m if w_hr_real_high != .,  /// 
             lwidth(  med            med   ) ///
             lcolor(  black          gs10  ) ///
             lpattern(solid          solid ) ///
             cmissing(n) ///
             ) ///
        (lfit w_hr_real_high year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit w_hr_real_high year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit w_hr_real_high year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit w_hr_real_high year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit w_hr_real_low year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit w_hr_real_low year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit w_hr_real_low year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit w_hr_real_low year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(3200(200)4800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(4800 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(4800 643.6 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(4800 650.6 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr1.png", replace
graph export "$graphs\\w_09_14_tr1.pdf", replace

*wages-quartertly moving average
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2800(200)4600, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3900 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(4000 643.8 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(4050 650.8 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr1_ma3.png", replace
graph export "$graphs\\w_09_14_tr1_ma3.eps", replace

*proportion-raw
twoway (line          above1mw_hr_high above1mw_hr_low   year_m if w_hr_real_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        (lfit above1mw_hr_high year_m if year_m >= 576 & year_m <=636 & w_hr_real_high != ., lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit above1mw_hr_high year_m if year_m >= 636 & year_m <=641 & w_hr_real_high != ., lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit above1mw_hr_high year_m if year_m >= 641 & year_m <=648 & w_hr_real_high != ., lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit above1mw_hr_high year_m if year_m >= 648 & year_m <=683 & w_hr_real_high != ., lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit above1mw_hr_low year_m if year_m >= 576 & year_m <=636 & w_hr_real_high != ., lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit above1mw_hr_low year_m if year_m >= 636 & year_m <=641 & w_hr_real_high != ., lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit above1mw_hr_low year_m if year_m >= 641 & year_m <=648 & w_hr_real_high != ., lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit above1mw_hr_low year_m if year_m >= 648 & year_m <=683 & w_hr_real_high != ., lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(35(5)80, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(60 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(60 643.6 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(60 650.6 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr1.png", replace
graph export "$graphs\\prop_09_14_tr1.eps", replace

*proportion-quarterly moving average
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(58(2)78, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(70 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(72 643.6 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(73 650.6 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr1_ma3.png", replace
graph export "$graphs\\prop_09_14_tr1_ma3.eps", replace

*salaried-[0.9-1.1]
*------------------
use "$tables\w_prop_08_14_tr1_w_9_1", replace

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2550 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(2550 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(2550 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\w_09_14_tr1_ma3_w_9_1.png", replace
          graph export "$graphs\\w_09_14_tr1_ma3_w_9_1.eps", replace

*proportion
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3   year_m if w_hr_real_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(66(2)86, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(70 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(70 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(70 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\prop_09_14_tr1_ma3_w_9_1.png", replace
          graph export "$graphs\\prop_09_14_tr1_ma3_w_9_1.eps", replace

          
*salaried-[0.8-1.2]
*------------------
use "$tables\w_prop_08_14_tr1_w_8_2", replace

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2550 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(2550 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(2550 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\w_09_14_tr1_ma3_w_8_2.png", replace
          graph export "$graphs\\w_09_14_tr1_ma3_w_8_2.eps", replace

*proportion
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3   year_m if w_hr_real_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(56(2)76, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(60 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(60 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(60 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\prop_09_14_tr1_ma3_w_8_2.png", replace
          graph export "$graphs\\prop_09_14_tr1_ma3_w_8_2.eps", replace

*-----------------------         
*self-employed-all wages
*-----------------------
*2009-2014
*---------
use "$tables\w_prop_08_14_tr0", clear

keep if w_hr_real_high != .

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages-quarterly moving average
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3   year_m,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2600(200)4400, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3600 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(3600 643.6 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(3600 650.6 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr0_ma3.png", replace
graph export "$graphs\\w_09_14_tr0_ma3.pdf", replace

*proportion-quarterly moving average
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3   year_m,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(32(2)52, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(45 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(46 643.5 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(45 650.5 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr0_ma3.png", replace
graph export "$graphs\\prop_09_14_tr0_ma3.pdf", replace

*self-employed-[0.9-1.1]
*-----------------------
use "$tables\w_prop_08_14_tr0_w_9_1", clear

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2550 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(2550 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(2550 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\w_09_14_tr0_ma3_w_9_1.png", replace
          graph export "$graphs\\w_09_14_tr0_ma3_w_9_1.eps", replace

*proportion
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3   year_m if w_hr_real_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(26(2)66, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(44 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(50 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(56 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\prop_09_14_tr0_ma3_w_9_1.png", replace
          graph export "$graphs\\prop_09_14_tr0_ma3_w_9_1.eps", replace

*self-employed-[0.8-1.2]
*-----------------------
use "$tables\w_prop_08_14_tr0_w_8_2", clear

*quarterly moving average
foreach v in w_hr_real_high w_hr_real_low above1mw_hr_high above1mw_hr_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*wages
twoway (line          w_hr_real_high_ma3 w_hr_real_low_ma3 year_m if w_hr_real_high != .,  /// 
             lwidth(  med                med   ) ///
             lcolor(  black              gs10  ) ///
             lpattern(solid              solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2550 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(2550 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(2550 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\w_09_14_tr0_ma3_w_8_2.png", replace
          graph export "$graphs\\w_09_14_tr0_ma3_w_8_2.eps", replace

*proportion
twoway (line          above1mw_hr_high_ma3 above1mw_hr_low_ma3   year_m if w_hr_real_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(26(2)56, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(35 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(35 643.5 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(35 650.5 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
          graph export "$graphs\\prop_09_14_tr0_ma3_w_8_2.png", replace
          graph export "$graphs\\prop_09_14_tr0_ma3_w_8_2.eps", replace

*---------          
*2008-2014
*---------
*salaried-quarterly
*------------------
use "$tables\w_prop_08_14_tr1_q", clear

*wages-raw
twoway (line          w_hr_real_high w_hr_real_low   year_q if w_hr_real_high != .,  /// 
             lwidth(  med            med   ) ///
             lcolor(  black          gs10  ) ///
             lpattern(solid          solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(3200(100)4600, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3900 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(4000 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(4100 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr1_q.png", replace
graph export "$graphs\\w_09_14_tr1_q.eps", replace
exit
*proportion
twoway (line          above1mw_hr_high     above1mw_hr_low  year_q if w_hr_real_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(58(2)78, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(69 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(71 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(72 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr1_q.png", replace
graph export "$graphs\\prop_09_14_tr1_q.eps", replace
 
*salaried-quarterly-[0.9-1.1]
*----------------------------
use "$tables\w_prop_08_14_tr1_w_9_1_q", clear

*wages-raw
twoway (line          w_hr_real_high w_hr_real_low   year_q if w_hr_real_high != .,  /// 
             lwidth(  med            med   ) ///
             lcolor(  black          gs10  ) ///
             lpattern(solid          solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2800 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(2800 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(2800 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr1_w_9_1_q.png", replace
graph export "$graphs\\w_09_14_tr1_w_9_1_q.eps", replace
                
*proportion
twoway (line          above1mw_hr_high     above1mw_hr_low  year_q if w_hr_real_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(66(2)88, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(88 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(88 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(88 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr1_w_9_1_q.png", replace
graph export "$graphs\\prop_09_14_tr1_w_9_1_q.eps", replace
            
*salaried-quarterly-[0.8-1.2]
*----------------------------
use "$tables\w_prop_08_14_tr1_w_8_2_q", clear

*wages-raw
twoway (line          w_hr_real_high w_hr_real_low   year_q if w_hr_real_high != .,  /// 
             lwidth(  med            med   ) ///
             lcolor(  black          gs10  ) ///
             lpattern(solid          solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2500(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(2750 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(2750 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(2650 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr1_w_8_2_q.png", replace
graph export "$graphs\\w_09_14_tr1_w_8_2_q.eps", replace

*proportion
twoway (line          above1mw_hr_high     above1mw_hr_low  year_q if w_hr_real_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(56(2)78, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(78 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(78 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(78 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr1_w_8_2_q.png", replace
graph export "$graphs\\prop_09_14_tr1_w_8_2_q.eps", replace
 
*-----------------------
*self-employed-quarterly
*-----------------------
use "$tables\w_prop_08_14_tr0_q", clear

*wages-raw
twoway (line          w_hr_real_high w_hr_real_low   year_q if w_hr_real_high != .,  /// 
             lwidth(  med            med   ) ///
             lcolor(  black          gs10  ) ///
             lpattern(solid          solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(2600(200)4400, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3400 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(3450 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(3500 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\w_09_14_tr0_q.eps", replace
graph export "$graphs\\w_09_14_tr0_q.png", replace

exit              
*proportion
twoway (line          above1mw_hr_high     above1mw_hr_low  year_q if w_hr_real_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(32(2)52, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
          xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
          xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(44 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(45 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(46 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\prop_09_14_tr0_q.png", replace
graph export "$graphs\\prop_09_14_tr0_q.eps", replace
exit 
*---------------------------------
*self-employed-quarterly-[0.9-1.1]
*---------------------------------
foreach v in 9_1 8_2 {
	use "$tables\w_prop_08_14_tr0_w_`v'_q", clear
	*wages-raw
	twoway (line          w_hr_real_high w_hr_real_low   year_q if w_hr_real_high != .,  /// 
				 lwidth(  med            med   ) ///
				 lcolor(  black          gs10  ) ///
				 lpattern(solid          solid ) ///
				 cmissing(n) ///
				 ) ///
			, ylabel(2400(50)2800, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
			  xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
			  xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
			  xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
			  xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
			  xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
			  xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
			  text(2750 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
			  text(2750 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
			  text(2650 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
			  xtitle("")             ///
			  ytitle("")    ///
			  legend(label(1 "High") ///
					 label(2 "Low") ///
					 ) ///
			  legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
			  graphregion(color(white)) bgcolor(white) ///
			  
	graph export "$graphs\\w_09_14_tr0_w_`v'_q.png", replace
	graph export "$graphs\\w_09_14_tr0_w_`v'_q.eps", replace
	
	*proportion
	twoway (line          above1mw_hr_high     above1mw_hr_low  year_q if w_hr_real_high != .,  /// 
				 lwidth(  med                  med   ) ///
				 lcolor(  black                gs10  ) ///
				 lpattern(solid                solid ) ///
				 cmissing(n) ///
				 ) ///
			, ylabel(30(2)66, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
			  xlabel(196(4)215 219, labsize(small) glwidth(small)) ///
			  xline(212, lwidth(thick) lcolor(gray) lpattern(solid)) ///
			  xline(213, lwidth(thick) lcolor(gray) lpattern(dash)) ///          
			  xline(216, lwidth(thick) lcolor(gray) lpattern(dash)) ///
			  xline(196(4)208 219, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
			  xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
			  text(66 210.5 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
			  text(66 214.0 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
			  text(66 217 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
			  xtitle("")             ///
			  ytitle("")    ///
			  legend(label(1 "High") ///
					 label(2 "Low") ///
					 ) ///
			  legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
			  graphregion(color(white)) bgcolor(white) ///
			  
	graph export "$graphs\\prop_09_14_tr0_w_`v'_q.png", replace
	graph export "$graphs\\prop_09_14_tr0_w_`v'_q.eps", replace
}

*regressions DDD estimates for all intervals around 1 MW possible 
*----------------------------------------------------------------
*WAGES - Bandwidths around 1MW
foreach reg in reg_all_bw1mw_lw_hr_real ///
               {
               use "$tables\\`reg'", clear
               replace bandwidth = bandwidth / 100
               foreach c in high {
               twoway (line    b_`c'     ll_`c'   ul_`c' bandwidth  /// if bandwidth >= 0.1
                       , ///                                             
                       lwidth(  medthick med      med      ) ///
                       lcolor(  black    black    black    ) ///
                       lpattern(solid    dash     longdash ) ///
                       ) ///
                       , ylabel(-0.025(0.005)0.035, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
                         xlabel(0(0.2)2, labsize(small) glwidth(small) angle(0) format(%9.1f)) ///
                         yline(0, lcolor(black) lpattern(solid)) ///
                         xtitle("Bandwidth around 1 MW", size(small))             ///
                         ytitle("Estimates")    ///
                         legend(label(1 "Point estimate") ///
                                label(2 "Lower limit" "(95% CI)") ///
                                label(3 "Upper limit" "(95% CI)") ///
                                ) ///
                         legend(size(small) region(lcolor(white)) rows(1) ) ///
                         graphregion(color(white)) bgcolor(white) ///
               
               graph export "$graphs\\`reg'_`c'.png", width(4796) height(3488) replace
               graph export "$graphs\\`reg'_`c'.eps", replace
               }
}

*WAGES - 2 to 10 MWs
foreach reg in reg_all_2_10mw ///
               {
               use "$tables\\`reg'", clear
               replace bandwidth = bandwidth / 10
               foreach c in med high {
               twoway (line    b_`c'     ll_`c'   ul_`c' bandwidth ///
                       , ///                                             
                       lwidth(  medthick med      med      ) ///
                       lcolor(  black    black    black    ) ///
                       lpattern(solid    dash     longdash ) ///
                       ) ///
                       , ylabel(-0.04(0.005)0.05, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
                         xlabel(2(0.5)10, labsize(small) glwidth(small) angle(0) format(%9.1f)) ///
                         yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
                         xtitle("Wages <= #MW", size(small))             ///
                         ytitle("Estimates")    ///
                         legend(label(1 "Point estimate") ///
                                label(2 "Lower limit" "(95% CI)") ///
                                label(3 "Upper limit" "(95% CI)") ///
                                ) ///
                         legend(size(small) region(lcolor(white)) rows(1) ) ///
                         graphregion(color(white)) bgcolor(white) ///
               
               graph export "$graphs\\`reg'_`c'.png", replace
               graph export "$graphs\\`reg'_`c'.eps", replace
               }
}

*WAGES - not around 1 MW
foreach reg in reg_not_around_1mw ///
               {
               use "$tables\\`reg'", clear
               replace bandwidth = ( bandwidth * 2 ) / 100
               foreach c in med high {
               twoway (line    b_`c'     ll_`c'   ul_`c' bandwidth ///
                       , ///                                             
                       lwidth(  medthick med      med      ) ///
                       lcolor(  black    black    black    ) ///
                       lpattern(solid    dash     longdash ) ///
                       ) ///
                       , ylabel(-0.04(0.005)0.05, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
                         xlabel(0(0.2)2, labsize(small) glwidth(small) angle(0) format(%9.1f)) ///
                         yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
                         xtitle("Bandwidth around 1 MW", size(small))             ///
                         ytitle("Estimates")    ///
                         legend(label(1 "Point estimate") ///
                                label(2 "Lower limit" "(95% CI)") ///
                                label(3 "Upper limit" "(95% CI)") ///
                                ) ///
                         legend(size(small) region(lcolor(white)) rows(1) ) ///
                         graphregion(color(white)) bgcolor(white) ///
               
               graph export "$graphs\\`reg'_`c'.png", replace
               graph export "$graphs\\`reg'_`c'.eps", replace
               }
}
*/
*ABOVE 1 MW - Bandwidths around 1MW
foreach reg in reg_all_bw1mw_above1mw_hr ///
               {
               use "$tables\\`reg'", clear
               replace bandwidth = bandwidth / 100
               foreach c in high {
               twoway (line    b_`c'     ll_`c'   ul_`c' bandwidth if bandwidth >= 0.1 ///  
                       , ///                                             
                       lwidth(  medthick med      med      ) ///
                       lcolor(  black    black    black    ) ///
                       lpattern(solid    dash     longdash ) ///
                       ) ///
                       , ylabel(-0.040(0.01)0.100, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
                         xlabel(0(0.2)2, labsize(small) glwidth(small) angle(0) format(%9.1f)) ///
                         yline(0, lcolor(black) lpattern(solid)) ///
                         xtitle("Bandwidth around 1 MW", size(small))             ///
                         ytitle("Estimates")    ///
                         legend(label(1 "Point estimate") ///
                                label(2 "Lower limit" "(95% CI)") ///
                                label(3 "Upper limit" "(95% CI)") ///
                                ) ///
                         legend(size(small) region(lcolor(white)) rows(1) ) ///
                         graphregion(color(white)) bgcolor(white) ///
               
               graph export "$graphs\\`reg'_`c'.png", width(4796) height(3488) replace
               graph export "$graphs\\`reg'_`c'.eps", replace
               }
}
exit
*-------------------
*Time placebo
*-------------------
*lw_all
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    lw_all     lw_all_c95_ll   lw_all_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.10(0.02)0.16, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_lw_all.png", replace
   graph export "$graphs\\`reg'_lw_all.eps", replace
   }

*lw_nmw_9_1
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    lw_nmw_9_1     lw_nmw_9_1_c95_ll   lw_nmw_9_1_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.02(0.005)0.04, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_lw_nmw_9_1.png", replace
   graph export "$graphs\\`reg'_lw_nmw_9_1.eps", replace
}

*lw_nmw_8_2
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    lw_nmw_8_2     lw_nmw_8_2_c95_ll   lw_nmw_8_2_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.02(0.005)0.04, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_lw_nmw_8_2.png", replace
   graph export "$graphs\\`reg'_lw_nmw_8_2.eps", replace
}

*a1mw_all
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    a1mw_all     a1mw_all_c95_ll   a1mw_all_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.10(0.02)0.16, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_a1mw_all.png", replace
   graph export "$graphs\\`reg'_a1mw_all.eps", replace
   }

*a1mw_nmw_9_1
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    a1mw_nmw_9_1     a1mw_nmw_9_1_c95_ll   a1mw_nmw_9_1_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.20(0.05)0.30, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_a1mw_nmw_9_1.png", replace
   graph export "$graphs\\`reg'_a1mw_nmw_9_1.eps", replace
   }

*a1mw_nmw_8_2
foreach reg in reg_ffddd_post2_tr_treated_graph ///
   {
   use "$tables\\`reg'", clear
   twoway (line    a1mw_nmw_8_2     a1mw_nmw_8_2_c95_ll   a1mw_nmw_8_2_c95_ul year_q  /// 
		   , ///                                             
		   lwidth(  medthick med      med      ) ///
		   lcolor(  black    black    black    ) ///
		   lpattern(solid    dash     longdash ) ///
		   ) ///
		   , ylabel(-0.20(0.05)0.30, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.3f)) ///
			 xlabel(197(3)219, labsize(small) glwidth(small) angle(0)) ///
			 yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
			 xtitle("Year-Quarter", size(small))             ///
			 ytitle("Estimates")    ///
			 legend(label(1 "Point estimate") ///
					label(2 "Lower limit" "(95% CI)") ///
					label(3 "Upper limit" "(95% CI)") ///
					) ///
			 legend(size(small) region(lcolor(white)) rows(1) ) ///
			 graphregion(color(white)) bgcolor(white) ///
   
   graph export "$graphs\\`reg'_a1mw_nmw_8_2.png", replace
   graph export "$graphs\\`reg'_a1mw_nmw_8_2.eps", replace
   }
   
exit

*-------------------
*Weekly HOURS WORKED
*-------------------
*salaried
*--------
use "$tables\whrs_08_14_tr1", clear

*quarterly moving average
foreach v in job_hrs_reg_high job_hrs_reg_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*hours-raw
twoway (line          job_hrs_reg_high job_hrs_reg_low year_m if job_hrs_reg_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        (lfit job_hrs_reg_high year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit job_hrs_reg_high year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit job_hrs_reg_high year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit job_hrs_reg_high year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit job_hrs_reg_low year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit job_hrs_reg_low year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit job_hrs_reg_low year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit job_hrs_reg_low year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(47(0.5)52, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(52 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(52 643.6 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(52 650.6 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\hours_09_14_tr1.png", replace
graph export "$graphs\\hours_09_14_tr1.eps", replace
     
*wages-quartertly moving average
twoway (line          job_hrs_reg_high_ma3 job_hrs_reg_low_ma3 year_m if job_hrs_reg_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(47(0.5)53, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3900 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(4000 643.8 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(4050 650.8 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\hours_09_14_tr1_ma3.png", replace
graph export "$graphs\\hours_09_14_tr1_ma3.eps", replace

*self-employed
*-------------
use "$tables\whrs_08_14_tr0", clear

*quarterly moving average
foreach v in job_hrs_reg_high job_hrs_reg_low {
	tssmooth ma  `v'_ma3 = `v' , window(1 1 1)
}

*hours-raw
twoway (line          job_hrs_reg_high job_hrs_reg_low year_m if job_hrs_reg_high != .,  /// 
             lwidth(  med              med   ) ///
             lcolor(  black            gs10  ) ///
             lpattern(solid            solid ) ///
             cmissing(n) ///
             ) ///
        (lfit job_hrs_reg_high year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(black) lpattern(solid) ) ///              
        (lfit job_hrs_reg_high year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(black) lpattern(solid) ) ///
        (lfit job_hrs_reg_high year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(black) lpattern(solid) ) /// 
        (lfit job_hrs_reg_high year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(black) lpattern(solid) ) ///
        ///
        (lfit job_hrs_reg_low year_m if year_m >= 576 & year_m <=636, lwidth(med) lcolor(gs10) lpattern(solid) ) ///              
        (lfit job_hrs_reg_low year_m if year_m >= 636 & year_m <=641, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        (lfit job_hrs_reg_low year_m if year_m >= 641 & year_m <=648, lwidth(med) lcolor(gs10) lpattern(solid) ) /// 
        (lfit job_hrs_reg_low year_m if year_m >= 648 & year_m <=683, lwidth(med) lcolor(gs10) lpattern(solid) ) ///
        , ylabel(42(0.5)48, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(52 633 "reform" "passed",  color(gray) size(vsmall) ) ///
          text(52 643.6 "1st" "tax" "waiver", color(gray) size(vsmall) ) ///
          text(52 650.6 "final" "tax" "waiver", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\hours_09_14_tr0.png", replace
graph export "$graphs\\hours_09_14_tr0.eps", replace
     
*wages-quartertly moving average
twoway (line          job_hrs_reg_high_ma3 job_hrs_reg_low_ma3 year_m if job_hrs_reg_high != .,  /// 
             lwidth(  med                  med   ) ///
             lcolor(  black                gs10  ) ///
             lpattern(solid                solid ) ///
             cmissing(n) ///
             ) ///
        , ylabel(42(0.5)48, labsize(small) glwidth(small) glcolor(white) glpattern(gs16) angle(horizontal) axis(1)) ///
          xlabel(588(12)648 659, labsize(small) glwidth(small)) ///
          xline(636, lwidth(thick) lcolor(gray) lpattern(solid)) ///
          xline(641, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(648, lwidth(thick) lcolor(gray) lpattern(dash)) ///
          xline(588(12)624, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          xline(659, lwidth(med)   lcolor(gs15)  lpattern(dash) ) ///
          text(3900 633 "{bf:reform}" "{bf:passed}",  color(gray) size(vsmall) ) ///
          text(4000 643.8 "{bf:1st}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          text(4050 650.8 "{bf:final}" "{bf:tax}" "{bf:waiver}", color(gray) size(vsmall) ) ///
          xtitle("")             ///
          ytitle("")    ///
          legend(label(1 "High") ///
                 label(2 "Low") ///
                 ) ///
          legend(size(small) region(lcolor(white)) rows(1) order(1 2)) ///
          graphregion(color(white)) bgcolor(white) ///
          
graph export "$graphs\\hours_09_14_tr0_ma3.png", replace
graph export "$graphs\\hours_09_14_tr0_ma3.eps", replace
*/
*regressions DDD estimates for all intervals around 1 MW possible 
*----------------------------------------------------------------
*WAGES - Bandwidths around 1MW
foreach reg in reg_dodd_bw1mw_lw_hr_real ///
               {
               use "$tables\\`reg'", clear
               replace bandwidth = ( bandwidth * 2 ) / 100
               foreach c in high {
               twoway (line    b_`c'     ll_`c'   ul_`c' bandwidth if bandwidth >= 0.1 ///
                       , ///                                             
                       lwidth(  medthick med      med      ) ///
                       lcolor(  black    black    black    ) ///
                       lpattern(solid    dash     longdash ) ///
                       ) ///
                       , ylabel(-0.0020(0.0005)0.0020, labsize(small) glwidth(vsmall) glcolor(gs15) glpattern(solid) angle(horizontal) axis(1) format(%9.4f)) ///
                         xlabel(0(0.2)2, labsize(small) glwidth(small) angle(0) format(%9.1f)) ///
                         yline(0, lwidth(med) lcolor(red) lpattern(solid)) ///
                         xtitle("Bandwidth around 1 MW", size(small))             ///
                         ytitle("Estimates")    ///
                         legend(label(1 "Point estimate") ///
                                label(2 "Lower limit" "(95% CI)") ///
                                label(3 "Upper limit" "(95% CI)") ///
                                ) ///
                         legend(size(small) region(lcolor(white)) rows(1) ) ///
                         graphregion(color(white)) bgcolor(white) ///
               
               graph export "$graphs\\`reg'_`c'.png", replace
               graph export "$graphs\\`reg'_`c'.eps", replace
               }
}


exit