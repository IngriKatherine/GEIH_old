*---------------------------------------------------------------------
* Function: import Consumer Price Index series                                       
*---------------------------------------------------------------------

*Línea de pobreza por ciudad
clear all
import excel "$data\original\linea de pobreza.xlsx", sheet("lp_month") cellrange(A1:Z153) firstrow
reshape long c, i(year month) j(city)
drop if city == 0 | city == 999
rename c lp_ciudad
drop if lp_ciudad == .
compress              
save "$process\lp_ciudad", replace

