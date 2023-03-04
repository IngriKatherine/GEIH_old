*---------------------------------------------------------------------
* Function: import Consumer Price Index series                                       
*---------------------------------------------------------------------

*Consumer Price Index per city
clear all
import excel "$data\original\1.2.4.IPC_Por ciudad_IQY.xlsx", sheet("stata") firstrow
reshape long c, i(year month) j(city)
drop if city == 0 | city == 999
rename c cpi_city
drop A*
compress              
save "$process\cpi_city", replace

exit
*Consumer Price Index
clear all
import excel "$data\original\1.2.5.IPC_Serie_variaciones_IQY.xlsx", sheet("stata") firstrow
tostring anio_mes, gen(aux)
gen year = substr(aux,1,4)
destring year, replace
gen month = substr(aux,5,2)
destring month, replace
drop anio_mes aux
compress              
save "$process\cpi", replace
