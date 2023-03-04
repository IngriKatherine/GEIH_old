*---------------------------------------------------------------------
* Function: process GEIH data                                       
*---------------------------------------------------------------------
/*
*-------------------------
*datasets assembly by year
*-------------------------
*2008
forvalues y = 2008/2008 {
	display "`y'"
    forvalues m = 1/12 {
    	local month: word `m' of Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`month'\\stata\\`g'_caracter_sticas_generales_personas_`m'_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden using "$data\original\\geih\\`y'\\data\\`month'\\stata\\`b'_`m'_.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`month'\\stata\\`g'_vivienda_y_hogares_`m'_.dta", nogen force
            *month var
            if `y' == 2008 {
            	gen mes = `m'
            }
            *save dataset
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *year var
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2009-2010
forvalues y = 2009/2010 {
	display "`y'"
    forvalues m = 1/12 {
    	local month: word `m' of Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`month'\\stata\\`g'_caracter_sticas_generales_personas_`m'_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`month'\\stata\\`b'_`m'_.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`month'\\stata\\`g'_vivienda_y_hogares_`m'_.dta", nogen force
            *month var
            if `y' == 2009 {
            	gen mes = `m'
            }
            *save dataset
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *year var
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2011
forvalues y = 2011/2011 {
	display "`y'"
    forvalues m = 1/12 {
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2012
forvalues y = 2012/2012 {
	display "`y'"
    foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\01_`y'.dta", clear
    foreach m in 02 03 04 05 06 07 08 09 10 11 12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2013-2015
forvalues y = 2013/2015 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2016
forvalues y = 2016/2016 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in cabecera resto {
            use "$data\original\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		destring p6980, replace
		destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2017
*Enero to Agosto
forvalues y = 2017/2017 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto {
        foreach g in cabecera resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		*destring p6980, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
}

*to lowercase
forvalues y = 2017/2017 {
	display "`y'"
    foreach m in Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Caracteristicas generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         "`g' - Vivienda y Hogares" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}
            
*Septiembre to Diciembre
forvalues y = 2017/2017 {
	display "`y'"
    foreach m in Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Caracteristicas generales (Personas).dta", clear
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
}

use "$data_temp\\Enero_2017.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_2017.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\2017.dta", replace

*2018
*to lowercase
forvalues y = 2018/2018 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Caracteristicas generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         "`g' - Vivienda y Hogares" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}

*process
forvalues y = 2018/2018 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Caracteristicas generales (Personas).dta", clear
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 if "`m'" == "Enero" & "`b'" == "`g' - Otras actividades y ayudas en la semana" {
                         	     foreach v in regis mes dpto clase {
                         	         destring `v', replace
                         	     }
                         	 }
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
      	     foreach v in regis mes dpto clase {
     	         tostring `v', replace
     	     }
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace            
        }
        foreach g in Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Caracteristicas generales (Personas).dta", clear
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all data bases
        use "$data_temp\\Cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\Resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		*destring p6980, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*process
*-------
*2019
*to lowercase
forvalues y = 2019/2019 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Características generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         "`g' - Vivienda y Hogares" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}
            
forvalues y = 2019/2019 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
      	     foreach v in regis mes dpto clase {
     	         tostring `v', replace
     	     }
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace            
        }
        foreach g in Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all data bases
        use "$data_temp\\Cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\Resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		*destring p6980, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*process
*-------
*2020
*----
*Enero-Febrero
*to lowercase
forvalues y = 2020/2020 {
	display "`y'"
    foreach m in Enero Febrero Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Características generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         "`g' - Vivienda y Hogares" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}
            
forvalues y = 2020/2020 {
	display "`y'"
    foreach m in Enero Febrero Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in Cabecera {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
      	     foreach v in regis mes dpto clase {
     	         tostring `v', replace
     	     }
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace            
        }
        foreach g in Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all data bases
        use "$data_temp\\Cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\Resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		destring regis clase mes dpto, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'_1_2_8.dta", replace
}

*2020
*Marzo-Julio
*to lowercase
forvalues y = 2020/2020 {
	display "`y'"
    foreach m in Marzo Abril Mayo Junio Julio {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Características generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}
            
forvalues y = 2020/2020 {
	display "`y'"
    foreach m in Marzo Abril Mayo Junio Julio {
        foreach g in Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace            
        }
        foreach g in Cabecera {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all data bases
        use "$data_temp\\Cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\Resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		destring regis clase mes dpto, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    use "$data_temp\\Marzo_`y'.dta", clear
    foreach m in Abril Mayo Junio Julio {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'_3_7.dta", replace
}

*process
*-------
*2021
*to lowercase
forvalues y = 2021/2021 {
	display "`y'"
    foreach m in Enero Febrero Marzo {
        foreach g in Cabecera Resto {
            foreach b in "`g' - Características generales (Personas)" /// 
                         "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         "`g' - Vivienda y Hogares" ///
                         {
                         use "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", clear
                         rename *, lower
                         save "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", replace
                         }
             }
      }
}
           
forvalues y = 2021/2021 {
	display "`y'"
    foreach m in Enero Febrero Marzo {
        foreach g in Cabecera {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
      	     foreach v in regis mes dpto clase {
     	         tostring `v', replace
     	     }
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace            
        }
        foreach g in Resto {
            use "$data\original\\geih\\`y'\\data\\`m'\\`g' - Características generales (Personas).dta", clear
            rename *, lower
            foreach b in "`g' - Fuerza de trabajo" ///
                         "`g' - Ocupados" ///
                         "`g' - Desocupados" ///
                         "`g' - Inactivos" ///
                         "`g' - Otros ingresos" ///
                         "`g' - Otras actividades y ayudas en la semana" ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\\geih\\`y'\\data\\`m'\\`b'.dta", nogen
            }
            *add household data
            display "`g' - Vivienda y Hogares"
            merge m:1 directorio secuencia_p using "$data\original\\geih\\`y'\\data\\`m'\\`g' - Vivienda y Hogares.dta", nogen
            foreach v in regis mes dpto clase {
                destring `v', replace
            }
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all data bases
        use "$data_temp\\Cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\Resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		*destring p6980, replace
		*destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}
*/

*para Econometría Avanzada
use "$process\\geih\\2019.dta", clear
order anio mes 
append using "$process\\geih\\2020_3_7.dta"
append using "$process\\geih\\2020_1_2_8.dta"
keep if mes == 8
compress
save "$process\\geih\\geih_19_20_8.dta", replace
exit
*----------------------------------------
* from raw data to workdata by year
*----------------------------------------

*2020-Marzo-Julio
forvalues y = 2020/2020 {
	display `y'
    use "$process\\geih\\`y'_3_7.dta", clear
                 
    *TIME
    *year
    rename anio year
    *month
    destring mes, force replace
    rename mes month
    *quarter
    gen     quarter = .
    replace quarter = 1 if month >= 1  & month <= 3
    replace quarter = 2 if month >= 4  & month <= 6
    replace quarter = 3 if month >= 7  & month <= 9
    replace quarter = 4 if month >= 10 & month <= 12
    label var quarter "Quarter"
    *semester
    gen     semester = .
    replace semester=1 if quarter == 1 | quarter == 2
    replace semester=2 if quarter == 3 | quarter == 4
    label var semester "Semester"
    *year-quarter
    gen    year_q = yq(year,quarter)
    format year_q %tq
    label var year_q "Year-Quarter"
    *after 2012 dummy
    gen     after_2012 = .
    replace after_2012 = 0 if year <= 2012
    replace after_2012 = 1 if year >= 2013
    
    *HOUSEHOLD
    gen aux = 1
    egen hh_size = total(aux), by(month directorio secuencia_p)
    label var hh_size "Household size"
    drop aux                                    
     
    *LOCATION
	*city
	capture replace area = "5" if area == "05"
	capture replace area = "8" if area == "08"
	destring area, force replace
	destring dpto, force replace
	gen     city = "Rest" 
	replace city = "Medellín MA"       if area == 5  & month == 3     
	replace city = "Barranquilla MA"   if area == 8  & month == 3
	replace city = "Bogotá DC"         if area == 11 & month == 3 
	replace city = "Cartagena"         if area == 13 & month == 3
	replace city = "Tunja"             if area == 15 & month == 3
	replace city = "Manizales MA"      if area == 17 & month == 3
	replace city = "Florencia"         if area == 18 & month == 3
	replace city = "Popayán"           if area == 19 & month == 3
	replace city = "Valledupar"        if area == 20 & month == 3
	replace city = "Montería"          if area == 23 & month == 3
	replace city = "Quibdó"            if area == 27 & month == 3
	replace city = "Neiva"             if area == 41 & month == 3
	replace city = "Riohacha"          if area == 44 & month == 3
	replace city = "Santa Marta"       if area == 47 & month == 3
	replace city = "Villavicencio"     if area == 50 & month == 3 
	replace city = "Pasto"             if area == 52 & month == 3 
	replace city = "Cúcuta MA"         if area == 54 & month == 3
	replace city = "Armenia"           if area == 63 & month == 3
	replace city = "Pereira MA"        if area == 66 & month == 3 
	replace city = "Bucaramanga MA"    if area == 68 & month == 3
	replace city = "Sincelejo"         if area == 70 & month == 3
	replace city = "Ibagué"            if area == 73 & month == 3 
	replace city = "Cali MA"           if area == 76 & month == 3

	replace city = "Medellín MA"       if dpto == 5  & month >= 4     
	replace city = "Barranquilla MA"   if dpto == 8  & month >= 4
	replace city = "Bogotá DC"         if dpto == 11 & month >= 4 
	replace city = "Cartagena"         if dpto == 13 & month >= 4
	replace city = "Tunja"             if dpto == 15 & month >= 4
	replace city = "Manizales MA"      if dpto == 17 & month >= 4
	replace city = "Florencia"         if dpto == 18 & month >= 4
	replace city = "Popayán"           if dpto == 19 & month >= 4
	replace city = "Valledupar"        if dpto == 20 & month >= 4
	replace city = "Montería"          if dpto == 23 & month >= 4
	replace city = "Quibdó"            if dpto == 27 & month >= 4
	replace city = "Neiva"             if dpto == 41 & month >= 4
	replace city = "Riohacha"          if dpto == 44 & month >= 4
	replace city = "Santa Marta"       if dpto == 47 & month >= 4
	replace city = "Villavicencio"     if dpto == 50 & month >= 4 
	replace city = "Pasto"             if dpto == 52 & month >= 4 
	replace city = "Cúcuta MA"         if dpto == 54 & month >= 4
	replace city = "Armenia"           if dpto == 63 & month >= 4
	replace city = "Pereira MA"        if dpto == 66 & month >= 4 
	replace city = "Bucaramanga MA"    if dpto == 68 & month >= 4
	replace city = "Sincelejo"         if dpto == 70 & month >= 4
	replace city = "Ibagué"            if dpto == 73 & month >= 4 
	replace city = "Cali MA"           if dpto == 76 & month >= 4
	
	label define city 11 "Bogotá DC" ///
					  5  "Medellín MA" ///
					  76 "Cali MA" ///
					  8  "Barranquilla MA" ///
					  68 "Bucaramanga MA" ///
					  17 "Manizales MA" ///
					  52 "Pasto" ///
					  66 "Pereira MA" ///
					  54 "Cúcuta MA" ///
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
					  99 "Rest" ///
							  
	encode  city, gen(city_cod) label(city)
	drop area dpto                          
	drop city
	rename city_cod city
          
    *department
    gen     department = ""
    replace department = "Antioquia"           if city == 5
    replace department = "Atlántico"           if city == 8
    replace department = "Bogotá DC"           if city == 11
    replace department = "Bolívar"             if city == 13
    replace department = "Boyacá"              if city == 15
    replace department = "Caldas"              if city == 17
    replace department = "Caquetá"             if city == 18
    replace department = "Cauca"               if city == 19
    replace department = "Cesar"               if city == 20
    replace department = "Córdoba"             if city == 23
    replace department = "Cundinamarca"        if city == 25
    replace department = "Chocó"               if city == 27
    replace department = "Huila"               if city == 41
    replace department = "La guajira"          if city == 44
    replace department = "Magdalena"           if city == 47
    replace department = "Meta"                if city == 50
    replace department = "Nariño"              if city == 52
    replace department = "Norte de santander"  if city == 54
    replace department = "Quindío"             if city == 63
    replace department = "Risaralda"           if city == 66
    replace department = "Santander"           if city == 68
    replace department = "Sucre"               if city == 70
    replace department = "Tolima"              if city == 73
    replace department = "Valle del Cauca"     if city == 76
    encode  department, gen(dep_cod)
    
    *Cities groups
    *13 ï¿½reas:  Bogotï¿½ D.C, ///
              * Medellï¿½n - Valle de Aburrï¿½, ///
              * Cali - Yumbo, ///
              * Barranquilla - Soledad, ///
              * Bucaramanga, Girï¿½n, Piedecuesta y Floridablanca, ///
              * Manizales y Villa Marï¿½a, ///
              * Pasto, ///
              * Pereira, Dos Quebradas y La Virginia, ///
              * Cï¿½cuta, Villa del Rosario, Los Patios y El Zulia, ///
              * Ibaguï¿½, ///
              * Monterï¿½a, ///
              * Cartagena, ///
              * Villavicencio.
    *10 ciudades: Tunja, ///
              * Florencia, ///
              * Popayï¿½n, /// 
              * Valledupar, ///
              * Quibdï¿½, /// 
              * Neiva,  ///
              * Riohacha,  /// 
              * Santa Marta,  /// 
              * Armenia,  /// 
              * Sincelejo. ///
              
    gen          city_group = .
    replace      city_group = 1 if city >= 1  & city <= 13 
    replace      city_group = 2 if city >= 14 & city <= 23
    replace      city_group = 3 if city == 24
    label define city_group 1  "13 areas"   ///
                            2  "10 cities"   ///
                            3  "Rest"   ///
                                   
    label values city_group city_group
    label var city_group "Group of cities"
    
    *urban
    rename clase area
    destring area, replace
    label var    area "Urban/Rural"
    label define area 1  "Urban"   ///
                      2  "Rural"   ///
                             
    label values area area
    
    *AGE
    *age
    gen age=p6040
    *gender
    gen     gender = . 
    replace gender = 1 if p6020==1
    replace gender = 2 if p6020==2
    label var    gender "gender"
    label define gender 1  "Male"   ///
                        2  "Female"   ///
                             
    label values gender gender

    *marital status
    gen          marital = . 
    replace      marital = 1 if p6070==1
    replace      marital = 2 if p6070==2
    replace      marital = 3 if p6070==3
    replace      marital = 4 if p6070==4
    replace      marital = 5 if p6070==5
    replace      marital = 6 if p6070==6
    label var    marital "marital status"
    label define marital 1  "Not married - living together less 2 yrs"   ///
                         2  "Not married - living together more 2 yrs"   ///
                         3  "Married"   ///
                         4  "Separated/divorced"   ///
                         5  "Widow"   ///
                         6  "Single"   ///
    
    label values marital marital
    
    *relation with head hh
    gen          rel_head = p6050 
    label var    rel_head "relation w/head hh"
    label define rel_head 1  "Head hh"   ///
                          2  "Husband/Wife/Partner"   ///
                          3  "Son/Daughter"   ///
                          4  "Grandson"   ///
                          5  "Other relative"   ///
                          6  "Housemaid"   ///
                          7  "Tenant"   ///
                          8  "Worker"   ///
                          8  "Other non-relative"   ///
    
    label values rel_head rel_head 
    replace rel_head = . if p6050 == 9 

    *EDUCATION
    *---------
    *reads & write
    gen       read_write = .
    replace   read_write = 1 if p6160 == 1
    replace   read_write = 0 if p6160 == 2
    label var read_write "=1 if reads & write"
    
    *years of education
    rename esc edu_years
    label var  edu_years "Years of Education"

    *enrolled
    gen       enroll = .
    replace   enroll = 1 if p6170 == 1
    replace   enroll = 0 if p6170 == 2
    label var enroll "=1 if enrolled in any level of education"
    table year quarter, c(mean enroll)

    *highest level of education (detailed)
    gen     edu_level7 = p6210
    replace edu_level7 = . if p6210 == 9

    *highest level of education (year)
    gen     edu_level7_year = p6210s1

    *highest level of education
    gen edu_level = .
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220   == `j' & month >=1 & month <= 7 & year == 2011    
        replace edu_level = `i' if p6210s1 == `j' & month >=8 & month <= 12 & year == 2011
    }
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220 == `j' & year != 2011
    }
    label define edu_level 0  "None"   ///
                           1  "High School"   ///
                           2  "Technical/Technological"   ///
                           3  "University"   ///
                           4  "Post-graduate"   ///
                        
    label values edu_level edu_level
    table edu_level year month
    
    *workage
    gen       workage = 0
    replace   workage = 1 if age >= 12 & age != . & area == 1
    replace   workage = 1 if age >= 10 & age != . & area == 2
    label var workage "=1 if age to work"
    
    *actividad principal semana pasada
    gen apsp = p6240
    label var apsp "actividad principal semana pasada"
    
    *indicator of labor force participation (employed + unemployed + inactive)
    gen     inlf = .
    //DANE
    *inactive: all non-workers 
    replace inlf = 3 if p6240 >=2 & p6240 <=6
    //Quiï¿½nes son los ocupados (OC)?
    //Son las personas que durante el perï¿½odo de referencia se encontraban en una de las siguientes situaciones:
    //1. Trabajï¿½ por lo menos una hora remunerada en dinero o en especie en la semana de referencia.
    replace inlf = 1 if p6240 == 1
    replace inlf = 1 if p6250 == 1
    //2. Los que no trabajaron la semana de referencia, pero tenï¿½an un trabajo.
    replace inlf = 1 if p6260 == 1
    //3. Trabajadores familiares sin remuneraciï¿½n que trabajaron en la semana de referencia por lo menos 1 hora
    replace inlf = 1 if p6270 == 1
    //DANE
    // Desocupados (D): Son las personas que en la semana de referencia se encontraban en una de
    // las siguientes situaciones:
    // 1. Desempleo abierto:
    //   a. Sin empleo en la semana de referencia.
    //   b. Hicieron diligencias en el ï¿½ltimo mes.
    //   c. Disponibilidad.
    replace inlf = 2 if p6240 == 2              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 3              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 4              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 6              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if              p6280 == 1 & p6250 == 2 & p6351 == 1
    // 2. Desempleo oculto:
    //   a. Sin empleo en la semana de referencia.
    //   b. No hicieron diligencias en el ï¿½ltimo mes, pero sï¿½ en los ï¿½ltimos 12 meses y tienen una razï¿½n vï¿½lida de desaliento.
    //   c. Disponibilidad.
    //Razones vï¿½lidas de desempleo:
    //  a. No hay trabajo disponible en la ciudad.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2 
    //  b. Estï¿½ esperando que lo llamen.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  f. Estï¿½ esperando la temporada alta.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  c. No sabe cï¿½mo buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 4
    //  d. Estï¿½ cansado de buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 5
    //  e. No encuentra trabajo apropiado en su oficio o profesiï¿½n.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2
    //  g. Carece de la experiencia necesaria.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 6
    //  h. No tiene recursos para instalar un negocio.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 7
    //  i. Los empleadores lo consideran muy joven o muy viejo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 8
    label define inlf 1  "Employed"   ///
                      2  "Unemployed"   ///
                      3  "Inactive"   ///
                        
    label values inlf inlf
    label var inlf "Labor force participation"
    tab inlf if workage == 1, miss

    *active
    gen       active = .
    replace   active = 0 if inlf != .
    replace   active = 1 if inlf == 1 | inlf == 2
    label var active "=1 if active"
    *employed
    gen       employed = .
    replace   employed = 0 if inlf == 1 | inlf == 2
    replace   employed = 1 if inlf == 1
    label var employed "=1 if employed"
    *unemployed
    gen       unemployed = .
    replace   unemployed = 0 if inlf == 1 | inlf == 2
    replace   unemployed = 1 if inlf == 2
    label var unemployed "=1 if unemployed"
    
    *labor status
    *------------
    gen          labor_state = p6430
    label define labor_state 1 "Private employee"   ///
                             2 "Public employee"   ///
                             3 "Domestic employee"   ///
                             4 "Self-employed"   ///
                             5 "Employer"   ///
                             6 "Unpaid family worker"   ///
                             7 "Unpaid private worker"   ///
                             8 "Laborer or farmhand"   ///
                             9 "Other"   ///
    
    label values labor_state labor_state
    label var    labor_state "labor state in main occupation"

    *formas de trabajo (cuenta propia)
    *---------------------------------
    gen          forma_trabajo = p6765
    label define forma_trabajo	1 "Honorarios o prestación de servicios"   ///
								2 "Por obra"   ///
								3 "Por piezas o a destajo"   /// 
								4 "Por comisión"   ///
								5 "Vendiendo por catálogo"   ///
								6 "En su oficio (plomero, taxista, etc.)"   ///
								7 "Tiene un negocio"   ///
								8 "Otro"   ///
    
    label values forma_trabajo forma_trabajo
    label var    forma_trabajo "forma de trabajo en oc. principal"
    
    *job quality
    *-----------
    *type of contract
    gen          con_type = .
    replace      con_type = 1 if p6440 == 1 & p6450 == 1  
    replace      con_type = 2 if p6440 == 1 & p6450 == 2
    replace      con_type = 3 if p6440 == 1 & p6450 == 3
    replace      con_type = 3 if p6440 == 1 & p6450 == 9 & month <= 2
    replace      con_type = 4 if p6440 == 2
    label define con_type 1  "Yes, verbal"   ///
                          2  "Yes, written"   ///
                          3  "Yes, do not know"   ///
                          4  "None"   ///
    
    label values con_type con_type
    label var con_type "labor contract type"
    
    *contract term
    gen          con_term = .
    replace      con_term = 1 if p6460 == 1
    replace      con_term = 2 if p6460 == 2
    replace      con_term = 3 if p6460 == 3
    label define con_term 1  "Indefinite"   ///
                          2  "Fixed"   ///
                          3  "Do not know"   ///
    
    label values con_term con_term
    label var    con_term "labor contract term"
    
    *contract length
    gen          con_term_m = p6460s1
    replace      con_term_m = . if p6460s1 == 99 | p6460s1 == 98 
    label var    con_term_m "labor contract fixed term in months"
    
    *chrismas bonus
    gen          con_bonus = .
    replace      con_bonus = 1 if p6424s2 == 1
    replace      con_bonus = 0 if p6424s2 == 2
    label var    con_bonus "=1 if labor contract includes chrismas bonus"
    
    *severance
    gen          con_sever = .
    replace      con_sever = 1 if p6424s3 == 1
    replace      con_sever = 0 if p6424s3 == 2
    label var    con_sever "=1 if labor contract includes severance"
    
    *vacations
    gen          con_vacation = .
    replace      con_vacation = 1 if p6424s1 == 1
    replace      con_vacation = 0 if p6424s1 == 2
    label var    con_vacation "=1 if labor contract includes paid vacations"
    
    *tenure
    *-------
    gen       tenure_firm = p6426
    label var tenure_firm "tenure in firm (months)"
    
    *PENSION
    *dummy
    gen       pension = .
    replace   pension = 1 if p6920 == 1
    replace   pension = 0 if p6920 == 2
    label var pension "=1 if contributes to a pension fund"
    *type
    gen          pension_type = p6930
    label define pension_type 1  "Private"   ///
                              2  "Colpensiones"   ///
                              3  "Special (FFMM, Ecopetrol)"   ///
                              4  "Subsidized (Prosperar)"   ///
    
    label values pension_type pension_type
    label var    pension_type "type of pension fund"
    *type
    gen          pension_who = p6940
    label define pension_who 1  "Shared w/employer"   ///
                              2  "Pays all"   ///
                              3  "Employer pays all"   ///
                              4  "Does not pay"   ///
    
    label values pension_who pension_who
    label var    pension_who "who pays pension contrib."
    
    *health care
    *-----------
    *yes/no
    gen       health = .
    replace   health = 1 if p6090 == 1
    replace   health = 0 if p6090 == 2
    label var health "=1 if affiliated for health care"
    *type
    gen          health_type = .
    replace      health_type = 1 if p6100 == 1
    replace      health_type = 2 if p6100 == 2
    replace      health_type = 3 if p6100 == 3
    label define health_type 1  "Contributive"   ///
                             2  "Special"   ///
                             3  "Subsidized"   ///
    
    label values health_type health_type
    label var    health_type "Type of health care"
    
    *who pays
    gen          health_who = .
    replace      health_who = 1 if p6110 == 1
    replace      health_who = 2 if p6110 == 2
    replace      health_who = 3 if p6110 == 3
    replace      health_who = 4 if p6110 == 4
    replace      health_who = 5 if p6110 == 5
    replace      health_who = 6 if p6110 == 6
    label define health_who 1  "Shared with employer"   ///
                            2  "Discounted from pension"   ///
                            3  "Pays all"   ///
                            4  "Employer pays all"   ///
                            5  "Beneficiary"   ///
                            6  "Do not know"   ///
    
    label values health_who health_who
    label var    health_who "Who pays for health care"
                            
    *union membership
    *----------------
    gen       union = .
    replace   union = 1 if p7180 == 1
    replace   union = 0 if p7180 == 2
    label var union "=1 if affiliated to a labor union"
     
    *income
    *------
    *wages
    *-----
    *gross wage
    gen       w_m_gross = p6500
    label var w_m_gross "Gross monthly wage LCU"
            
    *overtime
    gen       w_overtime = p6510s1
    label var w_overtime "Overtime paid LCU"
    
    *overtime included
    gen       w_overtime_inc = .
    replace   w_overtime_inc = 1 if p6510s2 == 1
    replace   w_overtime_inc = 0 if p6510s2 == 2
    label var w_overtime_inc "Overtime paid LCU included in wage"
    
    *food
    gen       w_food =      p6590s1
    replace   w_food = . if p6590s1 == 98
    label var w_food "Food paid LCU"
    
    *rent
    gen       w_rent =      p6600s1
    replace   w_rent = . if p6600s1 == 98
    label var w_rent "Rent paid LCU"
    
    *transport
    gen       w_transport =      p6610s1
    replace   w_transport = . if p6610s1 == 98
    label var w_transport "Transport paid LCU"
    
    *in kind
    gen       w_in_kind =      p6620s1
    replace   w_in_kind = . if p6620s1 == 98
    label var w_in_kind "In kind paid LCU"
    
    *SUBSIDIES
    *food
    gen       sub_food =      p6585s1a1
    replace   sub_food = . if p6585s1a1 == 98
    label var sub_food "Subsidy food"
    gen       sub_food_inc = .
    replace   sub_food_inc = 1 if p6585s1a2 == 1
    replace   sub_food_inc = 0 if p6585s1a2 == 2
    label var sub_food_inc "=1 if Subsidy food included in income"
    
    *transport
    gen       sub_trans =      p6585s2a1
    replace   sub_trans = . if p6585s2a1 == 98
    label var sub_trans "Subsidy transport"
    gen       sub_trans_inc = .
    replace   sub_trans_inc = 1 if p6585s2a2 == 1
    replace   sub_trans_inc = 0 if p6585s2a2 == 2
    label var sub_trans_inc "=1 if Subsidy transport included in income"
    
    *family
    gen       sub_fam =      p6585s3a1
    replace   sub_fam = . if p6585s3a1 == 98
    label var sub_fam "Subsidy family"
    gen       sub_fam_inc = .
    replace   sub_fam_inc = 1 if p6585s3a2 == 1
    replace   sub_fam_inc = 0 if p6585s3a2 == 2
    label var sub_fam_inc "=1 if Subsidy family included in income"
     
    *education
    gen       sub_edu =      p6585s4a1
    replace   sub_edu = . if p6585s4a1 == 98
    label var sub_edu "Subsidy education"
    gen       sub_edu_inc = .
    replace   sub_edu_inc = 1 if p6585s4a2 == 1
    replace   sub_edu_inc = 0 if p6585s4a2 == 2
    label var sub_edu_inc "=1 if Subsidy education included in income"
    
    *MAIN OCCUPATION
    *primes last month
    *prime 
    gen       prime_m =      p6545s1
    replace   prime_m = . if p6545s1 == 98
    label var prime_m "last month prime"
    
    *bonus 
    gen       bonus_m =      p6545s1
    replace   bonus_m = . if p6545s1 == 98
    label var bonus_m "last month monthly bonus"
    
    *last 12 month plus
    *prime services 
    gen       prime_serv_12m =      p6630s1a1
    replace   prime_serv_12m = . if p6630s1a1 == 98
    label var prime_serv_12m "12m income prime services"
    
    *prime chrismas 
    gen       prime_xmas_12m =      p6630s2a1
    replace   prime_xmas_12m = . if p6630s2a1 == 98
    label var prime_xmas_12m "12m income prime chrismas"
    
    *prime vacations
    gen       prime_vac_12m =      p6630s3a1
    replace   prime_vac_12m = . if p6630s3a1 == 98
    label var prime_vac_12m "12m income prime vacations"
    
    *prime travel
    gen       prime_travel_12m =      p6630s4a1
    replace   prime_travel_12m = . if p6630s4a1 == 98
    label var prime_travel_12m "12m income prime travel"
    
    *prime accident 
    gen       prime_acc_12m =      p6630s6a1
    replace   prime_acc_12m = . if p6630s6a1 == 98
    label var prime_acc_12m "12m income prime work accident"
    
    *INDEPENDENT WORKERS
    *type of independent work
    gen          indep_type = p6765
    label var    indep_type "type of independent work"
    label define indep_type 1  "Location of services"   ///
                            2  "By project"   ///
                            3  "By piece"   ///
                            4  "On comission"   ///
                            5  "Catalog sales"   ///
                            6  "Profession (plumber, carpenter, taxi driver)"   ///
                            7  "Owner of business or land"   ///
                            8  "Other"   ///
    
    label values indep_type indep_type
    
    *employer
    gen          employer = .
    replace      employer = 0 if employed == 1
    replace      employer = 1 if employed == 1 & indep_type == 7
    label var    employer "=1 if employer"
    
    *registered bussiness
    gen       firm_regis = .
    replace   firm_regis = 1 if p6772 == 1
    replace   firm_regis = 0 if p6772 == 2
    label var firm_regis "=1 if firm is registered"
    
    *profit
    gen       profit =      p6750
    replace   profit = . if p6750 == 98 | p6750 == 99
    label var profit "profit from activity last month"
         
    *12 month crop profit
    gen       profit_crop =      p550
    replace   profit_crop = . if p550 == 98 | p550 == 99
    label var profit_crop "12m profit from crop RURAL"
    
    *WORK HOURS
    *regular
    gen       job_hrs_reg =      p6800
    label var job_hrs_reg "main jobs regular weekly hours"
    
    *last week
    gen       job_hrs_lastw =      p6850
    label var job_hrs_lastw "main jobs last week hours"
    
    *FIRM SIZE
    gen          firm_size = p6870
    label var    firm_size "number of employees in firm"
    label define firm_size 1  "Alone"   ///
                           2  "[2-3]"   ///
                           3  "[4-5]"   ///
                           4  "[6-10]"   ///
                           5  "[11-19]"   ///
                           6  "[20-30]"   ///
                           7  "[31-50]"   ///
                           8  "[51-100]"   ///
                           9  "101 or more"   ///
    
    label values firm_size firm_size
    
    *ECONOMIC SECTOR
    *ISIC Rev4 4 digits
    if year >= 2008 & year <= 2019 {
		gen          sector4d_rev3 = rama4d
		destring     sector4d_rev3, force replace		
		replace      sector4d_rev3 = . if sector4d_rev3 == 0		
		label var    sector4d_rev3 "sector ISIC Rev3 A.C. 4 digits"
	}
    if year == 2020 {
		gen          sector4d_rev4 = rama4d_r4
		destring     sector4d_rev4, force replace		
		replace      sector4d_rev4 = . if sector4d_rev4 == 0		
		label var    sector4d_rev4 "sector ISIC Rev4 A.C. 4 digits"
	}
    
    *ISIC Rev3 2 digits
    if year >= 2008 & year <= 2019 {
		gen          sector2d_rev3 = rama2d
		destring     sector2d_rev3, force replace
		replace      sector2d_rev3 = . if sector2d_rev3 == 0
		label var    sector2d_rev3 "sector ISIC Rev3 A.C. 2 digits"
	}
    if year == 2020 {
		gen          sector2d_rev4 = rama2d_r4
		destring     sector2d_rev4, force replace
		replace      sector2d_rev4 = . if sector2d_rev4 == 0
		label var    sector2d_rev4 "sector ISIC Rev3 A.C. 2 digits"
	}
     

    *OCCUPATION  
    *----------   
    destring oficio, replace
    gen		ocupac8=.
	replace ocupac8=0 if oficio==0   
	replace ocupac8=1 if oficio==1|oficio==2|oficio==3|oficio==4|oficio==5|oficio==6|oficio==7| ///
								   oficio==8|oficio==9|oficio==11|oficio==12 
	replace ocupac8=2 if oficio==13|oficio==14|oficio==15|oficio==16|oficio==17|oficio==18|oficio==19
	replace ocupac8=3 if oficio==20|oficio==21 
	replace ocupac8=4 if oficio==30|oficio==31|oficio==32|oficio==33|oficio==34|oficio==39|oficio==35| ///
								   oficio==36|oficio==37|oficio==38 
	replace ocupac8=5 if oficio==40|oficio==41|oficio==42|oficio==43|oficio==44|oficio==45|oficio==49 
	replace ocupac8=6 if oficio==50|oficio==51|oficio==52|oficio==53|oficio==54|oficio==55|oficio==56| ///
								   oficio==57|oficio==58|oficio==59
	replace ocupac8=7 if oficio==60|oficio==61|oficio==62|oficio==63|oficio==64
	replace ocupac8=8 if oficio==70|oficio==71|oficio==72|oficio==73|oficio==74|oficio==76|oficio==75| ///
								   oficio==77|oficio==78|oficio==79|oficio==80|oficio==81|oficio==82|oficio==83| ///
								   oficio==84|oficio==85|oficio==86|oficio==87|oficio==88|oficio==89|oficio==90| ///
								   oficio==91|oficio==92|oficio==93|oficio==94|oficio==95|oficio==96|oficio==97| ///
								   oficio==98|oficio==99           
                               
	label define ocupaclbl  ///
					0 "No code"  ///
					1 "Professionals and Technicians 1" /// 
					2 "Professionals and Technicians 2"  ///
					3 "Managers and Public Officials"  ///
					4 "Administrative Staff"  ///
					5 "Merchant and Vendor" /// 
					6 "Service Worker"  ///
					7 "Agriculture and forest" /// 
					8 "Operator (non-agr.)"
				   
	label values ocupac8 ocupaclbl                   
    
    *ADDITIONAL VARIABLES
    *--------------------
    *weights
    gen wgt        = fex_c_2011
    gen wgt_year   = wgt/12
    gen wgt_sem    = wgt/6
    gen wgt_quarter= wgt/3
    
    *save 
    keep directorio secuencia_p /// 
              year month        quarter    semester year_q after_2012 /// time 
              area         department dep_cod  city   city_group  /// location
              age          gender     marital  rel_head /// personal
              hh_size      /// household
              read_write   enroll       edu_years      edu_level edu_level7 edu_level7_year /// education
              workage      apsp         inlf         active         employed  unemployed labor_state forma_trabajo /// labor state
              con_type     con_term     con_term_m     con_bonus con_sever  con_vacation tenure_firm union /// job quality
              pension      pension_type pension_who    health    health_type health_who /// formality
              w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
              sub_food     sub_food_inc sub_trans      sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
              prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
              profit       profit_crop   /// profits
              job_hrs_reg  job_hrs_lastw /// work hours 
              firm_size    sector* /// firm
              ocupac8 oficio /// occupation              
              wgt* /// weights
              
    order year month      quarter    semester year_q    after_2012 /// time 
               area       department dep_cod  city   city_group  /// location
               age        gender     marital  rel_head /// personal
               hh_size    /// household
               read_write   enroll       edu_years      edu_level edu_level7 edu_level7_year /// education
               workage      apsp         inlf         active         employed    unemployed labor_state forma_trabajo /// labor state
               con_type     con_term     con_term_m     con_bonus   con_sever  con_vacation tenure_firm union /// job quality
               pension      pension_type pension_who    health      health_type health_who /// formality
               w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
               sub_food     sub_food_inc sub_trans sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
               prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
               profit       profit_crop   /// profits
               job_hrs_reg  job_hrs_lastw /// work hours 
               firm_size    sector* /// firm
               ocupac8 oficio /// occupation               
               wgt* /// weights
   
    compress           
    save "$data_temp\\`y'_3_geih_temp.dta", replace           
}

*2008-2020-Enero-Febrero-Agosto+-2021
forvalues y = 2021/2021 {
	display `y'
    *use "$process\\geih\\`y'_1_2_8.dta", clear
    use "$process\\geih\\`y'.dta", clear
                 
    *TIME
    *year
    rename anio year
    *month
    destring mes, force replace
    rename mes month
    *quarter
    gen     quarter = .
    replace quarter = 1 if month >= 1  & month <= 3
    replace quarter = 2 if month >= 4  & month <= 6
    replace quarter = 3 if month >= 7  & month <= 9
    replace quarter = 4 if month >= 10 & month <= 12
    label var quarter "Quarter"
    *semester
    gen     semester = .
    replace semester=1 if quarter == 1 | quarter == 2
    replace semester=2 if quarter == 3 | quarter == 4
    label var semester "Semester"
    *year-quarter
    gen    year_q = yq(year,quarter)
    format year_q %tq
    label var year_q "Year-Quarter"
    *after 2012 dummy
    gen     after_2012 = .
    replace after_2012 = 0 if year <= 2012
    replace after_2012 = 1 if year >= 2013
    
    *HOUSEHOLD
    gen aux = 1
    egen hh_size = total(aux), by(month directorio secuencia_p)
    label var hh_size "Household size"
    drop aux
    
    *LOCATION
    *department
    capture replace dpto = "5" if dpto == "05"
    capture replace dpto = "8" if dpto == "08"
    destring dpto, replace
    gen     department = ""
    replace department = "Antioquia"           if dpto == 5
    replace department = "Atlántico"           if dpto == 8
    replace department = "Bogotá DC"           if dpto == 11
    replace department = "Bolívar"             if dpto == 13
    replace department = "Boyacá"              if dpto == 15
    replace department = "Caldas"              if dpto == 17
    replace department = "Caquetá"             if dpto == 18
    replace department = "Cauca"               if dpto == 19
    replace department = "Cesar"               if dpto == 20
    replace department = "Córdoba"             if dpto == 23
    replace department = "Cundinamarca"        if dpto == 25
    replace department = "Chocó"               if dpto == 27
    replace department = "Huila"               if dpto == 41
    replace department = "La guajira"          if dpto == 44
    replace department = "Magdalena"           if dpto == 47
    replace department = "Meta"                if dpto == 50
    replace department = "Nariño"              if dpto == 52
    replace department = "Norte de santander"  if dpto == 54
    replace department = "Quindío"             if dpto == 63
    replace department = "Risaralda"           if dpto == 66
    replace department = "Santander"           if dpto == 68
    replace department = "Sucre"               if dpto == 70
    replace department = "Tolima"              if dpto == 73
    replace department = "Valle del Cauca"     if dpto == 76
    encode  department, gen(dep_cod)
    drop dpto

    *city
    capture replace area = "5" if area == "05"
    capture replace area = "8" if area == "08"
    destring area, replace
    gen     city = "" 
    replace city = "Medellín MA"       if area == 5 
    replace city = "Barranquilla MA"   if area == 8 
    replace city = "Bogotá DC"         if area == 11 
    replace city = "Cartagena"         if area == 13
    replace city = "Tunja"             if area == 15
    replace city = "Manizales MA"      if area == 17
    replace city = "Florencia"         if area == 18
    replace city = "Popayán"           if area == 19
    replace city = "Valledupar"        if area == 20
    replace city = "Montería"          if area == 23
    replace city = "Quibdó"            if area == 27
    replace city = "Neiva"             if area == 41
    replace city = "Riohacha"          if area == 44
    replace city = "Santa Marta"       if area == 47
    replace city = "Villavicencio"     if area == 50 
    replace city = "Pasto"             if area == 52 
    replace city = "Cúcuta MA"         if area == 54
    replace city = "Armenia"           if area == 63
    replace city = "Pereira MA"        if area == 66 
    replace city = "Bucaramanga MA"    if area == 68
    replace city = "Sincelejo"         if area == 70
    replace city = "Ibagué"            if area == 73 
    replace city = "Cali MA"           if area == 76
    replace city = "Rest"              if area == .
    label define city 11 "Bogotá DC" ///
                      5  "Medellín MA" ///
                      76 "Cali MA" ///
                      8  "Barranquilla MA" ///
                      68 "Bucaramanga MA" ///
                      17 "Manizales MA" ///
                      52 "Pasto" ///
                      66 "Pereira MA" ///
                      54 "Cúcuta MA" ///
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
                      99 "Rest" ///
                              
    encode  city, gen(city_cod) label(city) 
    drop area                          
    drop city
    rename city_cod city
    
    *Cities groups
    *13 ï¿½reas:  Bogotï¿½ D.C, ///
              * Medellï¿½n - Valle de Aburrï¿½, ///
              * Cali - Yumbo, ///
              * Barranquilla - Soledad, ///
              * Bucaramanga, Girï¿½n, Piedecuesta y Floridablanca, ///
              * Manizales y Villa Marï¿½a, ///                              
              * Pasto, ///
              * Pereira, Dos Quebradas y La Virginia, ///
              * Cï¿½cuta, Villa del Rosario, Los Patios y El Zulia, ///
              * Ibaguï¿½, ///
              * Monterï¿½a, ///
              * Cartagena, ///
              * Villavicencio.
    *10 ciudades: Tunja, ///
              * Florencia, ///
              * Popayï¿½n, /// 
              * Valledupar, ///
              * Quibdï¿½, /// 
              * Neiva,  ///
              * Riohacha,  /// 
              * Santa Marta,  /// 
              * Armenia,  /// 
              * Sincelejo. ///
              
    gen          city_group = .
    replace      city_group = 1 if city >= 1  & city <= 13 
    replace      city_group = 2 if city >= 14 & city <= 23
    replace      city_group = 3 if city == 24
    label define city_group 1  "13 areas"   ///
                            2  "10 cities"   ///
                            3  "Rest"   ///
                                   
    label values city_group city_group
    label var city_group "Group of cities"
    
    *urban
    rename clase area
    destring area, replace
    label var    area "Urban/Rural"
    label define area 1  "Urban"   ///
                      2  "Rural"   ///
                             
    label values area area
    
    *AGE
    *age
    gen age=p6040
    *gender
    gen     gender = . 
    replace gender = 1 if p6020==1
    replace gender = 2 if p6020==2
    label var    gender "gender"
    label define gender 1  "Male"   ///
                        2  "Female"   ///
                             
    label values gender gender
    
    *marital status
    gen          marital = . 
    replace      marital = 1 if p6070==1
    replace      marital = 2 if p6070==2
    replace      marital = 3 if p6070==3
    replace      marital = 4 if p6070==4
    replace      marital = 5 if p6070==5
    replace      marital = 6 if p6070==6
    label var    marital "marital status"
    label define marital 1  "Not married - living together less 2 yrs"   ///
                         2  "Not married - living together more 2 yrs"   ///
                         3  "Married"   ///
                         4  "Separated/divorced"   ///
                         5  "Widow"   ///
                         6  "Single"   ///
    
    label values marital marital
    
    *relation with head hh
    gen          rel_head = p6050 
    label var    rel_head "relation w/head hh"
    label define rel_head 1  "Head hh"   ///
                          2  "Husband/Wife/Partner"   ///
                          3  "Son/Daughter"   ///
                          4  "Grandson"   ///
                          5  "Other relative"   ///
                          6  "Housemaid"   ///
                          7  "Tenant"   ///
                          8  "Worker"   ///
                          8  "Other non-relative"   ///
    
    label values rel_head rel_head 
    replace rel_head = . if p6050 == 9 

    *strata
    gen strata = .
    forvalues i = 1/6 {
    	replace strata = `i' if p4030s1a1 == `i'
    }
    label var strata "Colombian Strata"    
    
    *EDUCATION
    *---------
    *reads & write
    gen       read_write = .
    replace   read_write = 1 if p6160 == 1
    replace   read_write = 0 if p6160 == 2
    label var read_write "=1 if reads & write"
    
    *years of education
    rename esc edu_years
    label var  edu_years "Years of Education"
    table year quarter, c(mean edu_years)
    if year == 2008 {
         forvalues m = 1/6 {
             if month == `m' {
             	 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==2 & p6175==. & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==2 & p6175==. & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==2 & p6175==. & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==2 & p6175==. & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==0 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==0 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 10 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==5
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==9
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==12 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==4
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==5
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==9
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==13 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==5
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==5
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==1
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==1
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==5
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==5
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==1
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==5
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==1
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==1
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==2
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==2
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==2
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==3
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==2
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==3
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==2
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==3
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==5
                 replace edu_years = 22 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==11 & p6220==5
                 replace edu_years = 22 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==11 & p6220==4
                 replace edu_years = 22 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==11 & p6220==5
                 replace edu_years = 23 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==12 & p6220==4
                 replace edu_years = 23 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==12 & p6220==5
                 replace edu_years = 23 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==12 & p6220==4
                 replace edu_years = 23 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==12 & p6220==5
                 replace edu_years = 24 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==13 & p6220==4
                 replace edu_years = 24 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==13 & p6220==5
                 replace edu_years = 25 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==14 & p6220==4
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==3
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==4
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==15 & p6220==4
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==15 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==15 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==15 & p6220==4
                 replace edu_years = 26 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==15 & p6220==5
             }
         }
    }
             
    *enrolled
    gen       enroll = .
    replace   enroll = 1 if p6170 == 1
    replace   enroll = 0 if p6170 == 2
    label var enroll "=1 if enrolled in any level of education"
    table year quarter, c(mean enroll)

    *highest level of education (detailed)
    gen     edu_level7 = p6210
    replace edu_level7 = . if p6210 == 9

    *highest level of education (year)
    gen     edu_level7_year = p6210s1

    *highest level of education
    gen edu_level = .
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220   == `j' & month >=1 & month <= 7 & year == 2011    
        replace edu_level = `i' if p6210s1 == `j' & month >=8 & month <= 12 & year == 2011
    }
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220 == `j' & year != 2011
    }
    label define edu_level 0  "None"   ///
                           1  "High School"   ///
                           2  "Technical/Technological"   ///
                           3  "University"   ///
                           4  "Post-graduate"   ///
                        
    label values edu_level edu_level
    table edu_level year month
    
    *labor market
    *------------
    *vars from survey
    foreach v in fuerza_de_trabajo ///
                 ocupados ///
                 desocupados ///
                 inactivos ///
                 otros_ingresos ///
                 {
                     capture gen     `v' = .
                     capture replace `v' = 0 if cabecera_`v' == 0 | resto_`v' == 0
                     capture replace `v' = 1 if cabecera_`v' == 1 | resto_`v' == 1
    }
    *workage
    gen       workage = 0
    replace   workage = 1 if age >= 12 & age != . & area == 1
    replace   workage = 1 if age >= 10 & age != . & area == 2
    label var workage "=1 if age to work"
    
    *searching for job
    rename p6290   search_job
    rename p6290s1 search_job_other
    
    *how got the job
    rename p6480   mean_got_job
    rename p6480s1 mean_got_job_other
    
    *got job w/internet
    rename p9440 got_job_internet

    *actividad principal semana pasada
    gen apsp = p6240
    label var apsp "actividad principal semana pasada"
    
    *indicator of labor force participation (employed + unemployed + inactive)
    gen     inlf = .
    //DANE
    *inactive: all non-workers 
    replace inlf = 3 if p6240 >=2 & p6240 <=6
    //Quiï¿½nes son los ocupados (OC)?
    //Son las personas que durante el perï¿½odo de referencia se encontraban en una de las siguientes situaciones:
    //1. Trabajï¿½ por lo menos una hora remunerada en dinero o en especie en la semana de referencia.
    replace inlf = 1 if p6240 == 1
    replace inlf = 1 if p6250 == 1
    //2. Los que no trabajaron la semana de referencia, pero tenï¿½an un trabajo.
    replace inlf = 1 if p6260 == 1
    //3. Trabajadores familiares sin remuneraciï¿½n que trabajaron en la semana de referencia por lo menos 1 hora
    replace inlf = 1 if p6270 == 1
    //DANE
    // Desocupados (D): Son las personas que en la semana de referencia se encontraban en una de
    // las siguientes situaciones:
    // 1. Desempleo abierto:
    //   a. Sin empleo en la semana de referencia.
    //   b. Hicieron diligencias en el ï¿½ltimo mes.
    //   c. Disponibilidad.
    replace inlf = 2 if p6240 == 2              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 3              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 4              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 6              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if              p6280 == 1 & p6250 == 2 & p6351 == 1
    // 2. Desempleo oculto:
    //   a. Sin empleo en la semana de referencia.
    //   b. No hicieron diligencias en el ï¿½ltimo mes, pero sï¿½ en los ï¿½ltimos 12 meses y tienen una razï¿½n vï¿½lida de desaliento.
    //   c. Disponibilidad.
    //Razones vï¿½lidas de desempleo:
    //  a. No hay trabajo disponible en la ciudad.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2 
    //  b. Estï¿½ esperando que lo llamen.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  f. Estï¿½ esperando la temporada alta.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  c. No sabe cï¿½mo buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 4
    //  d. Estï¿½ cansado de buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 5
    //  e. No encuentra trabajo apropiado en su oficio o profesiï¿½n.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2
    //  g. Carece de la experiencia necesaria.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 6
    //  h. No tiene recursos para instalar un negocio.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 7
    //  i. Los empleadores lo consideran muy joven o muy viejo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 8
    label define inlf 1  "Employed"   ///
                      2  "Unemployed"   ///
                      3  "Inactive"   ///
                        
    label values inlf inlf
    label var inlf "Labor force participation"
    tab inlf if workage == 1, miss
    *active
    gen       active = .
    replace   active = 0 if inlf != .
    replace   active = 1 if inlf == 1 | inlf == 2
    label var active "=1 if active"
    *employed
    gen       employed = .
    replace   employed = 0 if inlf == 1 | inlf == 2
    replace   employed = 1 if inlf == 1
    label var employed "=1 if employed"
    *unemployed
    gen       unemployed = .
    replace   unemployed = 0 if inlf == 1 | inlf == 2
    replace   unemployed = 1 if inlf == 2
    label var unemployed "=1 if unemployed"
    
    *labor status
    *------------
    gen          labor_state = p6430
    label define labor_state 1 "Private employee"   ///
                             2 "Public employee"   ///
                             3 "Domestic employee"   ///
                             4 "Self-employed"   ///
                             5 "Employer"   ///
                             6 "Unpaid family worker"   ///
                             7 "Unpaid private worker"   ///
                             8 "Laborer or farmhand"   ///
                             9 "Other"   ///
    
    label values labor_state labor_state
    label var    labor_state "labor state in main occupation"

    *formas de trabajo (cuenta propia)
    *---------------------------------
    gen          forma_trabajo = p6765
    label define forma_trabajo	1 "Honorarios o prestación de servicios"   ///
								2 "Por obra"   ///
								3 "Por piezas o a destajo"   /// 
								4 "Por comisión"   ///
								5 "Vendiendo por catálogo"   ///
								6 "En su oficio (plomero, taxista, etc.)"   ///
								7 "Tiene un negocio"   ///
								8 "Otro"   ///
    
    label values forma_trabajo forma_trabajo
    label var    forma_trabajo "forma de trabajo en oc. principal"
    
    *job quality
    *-----------
    *type of contract
    gen          con_type = .
    replace      con_type = 1 if p6440 == 1 & p6450 == 1  
    replace      con_type = 2 if p6440 == 1 & p6450 == 2
    replace      con_type = 3 if p6440 == 1 & p6450 == 3
    replace      con_type = 3 if p6440 == 1 & p6450 == 9 & month <= 2
    replace      con_type = 4 if p6440 == 2
    label define con_type 1  "Yes, verbal"   ///
                          2  "Yes, written"   ///
                          3  "Yes, do not know"   ///
                          4  "None"   ///
    
    label values con_type con_type
    label var con_type "labor contract type"
    
    *contract term
    gen          con_term = .
    replace      con_term = 1 if p6460 == 1
    replace      con_term = 2 if p6460 == 2
    replace      con_term = 3 if p6460 == 3
    label define con_term 1  "Indefinite"   ///
                          2  "Fixed"   ///
                          3  "Do not know"   ///
    
    label values con_term con_term
    label var    con_term "labor contract term"
    
    *contract length
    gen          con_term_m = p6460s1
    replace      con_term_m = . if p6460s1 == 99 | p6460s1 == 98 
    label var    con_term_m "labor contract fixed term in months"
    
    *chrismas bonus
    gen          con_bonus = .
    replace      con_bonus = 1 if p6424s2 == 1
    replace      con_bonus = 0 if p6424s2 == 2
    label var    con_bonus "=1 if labor contract includes chrismas bonus"
    
    *severance
    gen          con_sever = .
    replace      con_sever = 1 if p6424s3 == 1
    replace      con_sever = 0 if p6424s3 == 2
    label var    con_sever "=1 if labor contract includes severance"
    
    *vacations
    gen          con_vacation = .
    replace      con_vacation = 1 if p6424s1 == 1
    replace      con_vacation = 0 if p6424s1 == 2
    label var    con_vacation "=1 if labor contract includes paid vacations"
    
    *tenure
    *-------
    gen       tenure_firm = p6426
    label var tenure_firm "tenure in firm (months)"
    
    *PENSION
    *dummy
    gen       pension = .
    replace   pension = 1 if p6920 == 1
    replace   pension = 0 if p6920 == 2
    label var pension "=1 if contributes to a pension fund"
    *type
    gen          pension_type = p6930
    label define pension_type 1  "Private"   ///
                              2  "Colpensiones"   ///
                              3  "Special (FFMM, Ecopetrol)"   ///
                              4  "Subsidized (Prosperar)"   ///
    
    label values pension_type pension_type
    label var    pension_type "type of pension fund"
    *type
    gen          pension_who = p6940
    label define pension_who 1  "Shared w/employer"   ///
                              2  "Pays all"   ///
                              3  "Employer pays all"   ///
                              4  "Does not pay"   ///
    
    label values pension_who pension_who
    label var    pension_who "who pays pension contrib."
    
    *health care
    *-----------
    *yes/no
    gen       health = .
    replace   health = 1 if p6090 == 1
    replace   health = 0 if p6090 == 2
    label var health "=1 if affiliated for health care"
    *type
    gen          health_type = .
    replace      health_type = 1 if p6100 == 1
    replace      health_type = 2 if p6100 == 2
    replace      health_type = 3 if p6100 == 3
    label define health_type 1  "Contributive"   ///
                             2  "Special"   ///
                             3  "Subsidized"   ///
    
    label values health_type health_type
    label var    health_type "Type of health care"
    
    *who pays
    gen          health_who = .
    replace      health_who = 1 if p6110 == 1
    replace      health_who = 2 if p6110 == 2
    replace      health_who = 3 if p6110 == 3
    replace      health_who = 4 if p6110 == 4
    replace      health_who = 5 if p6110 == 5
    replace      health_who = 6 if p6110 == 6
    label define health_who 1  "Shared with employer"   ///
                            2  "Discounted from pension"   ///
                            3  "Pays all"   ///
                            4  "Employer pays all"   ///
                            5  "Beneficiary"   ///
                            6  "Do not know"   ///
    
    label values health_who health_who
    label var    health_who "Who pays for health care"
                            
    *union membership
    *----------------
    gen       union = .
    replace   union = 1 if p7180 == 1
    replace   union = 0 if p7180 == 2
    label var union "=1 if affiliated to a labor union"
     
    *income
    *------
    *wages
    *-----
    *gross wage
    gen       w_m_gross = p6500
    label var w_m_gross "Gross monthly wage LCU"
            
    *overtime
    gen       w_overtime = p6510s1
    label var w_overtime "Overtime paid LCU"
    
    *overtime included
    gen       w_overtime_inc = .
    replace   w_overtime_inc = 1 if p6510s2 == 1
    replace   w_overtime_inc = 0 if p6510s2 == 2
    label var w_overtime_inc "Overtime paid LCU included in wage"
    
    *food
    gen       w_food =      p6590s1
    replace   w_food = . if p6590s1 == 98
    label var w_food "Food paid LCU"
    
    *rent
    gen       w_rent =      p6600s1
    replace   w_rent = . if p6600s1 == 98
    label var w_rent "Rent paid LCU"
    
    *transport
    gen       w_transport =      p6610s1
    replace   w_transport = . if p6610s1 == 98
    label var w_transport "Transport paid LCU"
    
    *in kind
    gen       w_in_kind =      p6620s1
    replace   w_in_kind = . if p6620s1 == 98
    label var w_in_kind "In kind paid LCU"
    
    *SUBSIDIES
    *food
    gen       sub_food =      p6585s1a1
    replace   sub_food = . if p6585s1a1 == 98
    label var sub_food "Subsidy food"
    gen       sub_food_inc = .
    replace   sub_food_inc = 1 if p6585s1a2 == 1
    replace   sub_food_inc = 0 if p6585s1a2 == 2
    label var sub_food_inc "=1 if Subsidy food included in income"
    
    *transport
    gen       sub_trans =      p6585s2a1
    replace   sub_trans = . if p6585s2a1 == 98
    label var sub_trans "Subsidy transport"
    gen       sub_trans_inc = .
    replace   sub_trans_inc = 1 if p6585s2a2 == 1
    replace   sub_trans_inc = 0 if p6585s2a2 == 2
    label var sub_trans_inc "=1 if Subsidy transport included in income"
    
    *family
    gen       sub_fam =      p6585s3a1
    replace   sub_fam = . if p6585s3a1 == 98
    label var sub_fam "Subsidy family"
    gen       sub_fam_inc = .
    replace   sub_fam_inc = 1 if p6585s3a2 == 1
    replace   sub_fam_inc = 0 if p6585s3a2 == 2
    label var sub_fam_inc "=1 if Subsidy family included in income"
     
    *education
    gen       sub_edu =      p6585s4a1
    replace   sub_edu = . if p6585s4a1 == 98
    label var sub_edu "Subsidy education"
    gen       sub_edu_inc = .
    replace   sub_edu_inc = 1 if p6585s4a2 == 1
    replace   sub_edu_inc = 0 if p6585s4a2 == 2
    label var sub_edu_inc "=1 if Subsidy education included in income"
    
    *MAIN OCCUPATION
    *primes last month
    *prime 
    gen       prime_m =      p6545s1
    replace   prime_m = . if p6545s1 == 98
    label var prime_m "last month prime"
    
    *bonus 
    gen       bonus_m =      p6545s1
    replace   bonus_m = . if p6545s1 == 98
    label var bonus_m "last month monthly bonus"
    
    *last 12 month plus
    *prime services 
    gen       prime_serv_12m =      p6630s1a1
    replace   prime_serv_12m = . if p6630s1a1 == 98
    label var prime_serv_12m "12m income prime services"
    
    *prime chrismas 
    gen       prime_xmas_12m =      p6630s2a1
    replace   prime_xmas_12m = . if p6630s2a1 == 98
    label var prime_xmas_12m "12m income prime chrismas"
    
    *prime vacations
    gen       prime_vac_12m =      p6630s3a1
    replace   prime_vac_12m = . if p6630s3a1 == 98
    label var prime_vac_12m "12m income prime vacations"
    
    *prime travel
    gen       prime_travel_12m =      p6630s4a1
    replace   prime_travel_12m = . if p6630s4a1 == 98
    label var prime_travel_12m "12m income prime travel"
    
    *prime accident 
    gen       prime_acc_12m =      p6630s6a1
    replace   prime_acc_12m = . if p6630s6a1 == 98
    label var prime_acc_12m "12m income prime work accident"
    
    *INDEPENDENT WORKERS
    *type of independent work
    gen          indep_type = p6765
    label var    indep_type "type of independent work"
    label define indep_type 1  "Location of services"   ///
                            2  "By project"   ///
                            3  "By piece"   ///
                            4  "On comission"   ///
                            5  "Catalog sales"   ///
                            6  "Profession (plumber, carpenter, taxi driver)"   ///
                            7  "Owner of business or land"   ///
                            8  "Other"   ///
    
    label values indep_type indep_type
    
    *employer
    gen          employer = .
    replace      employer = 0 if employed == 1
    replace      employer = 1 if employed == 1 & indep_type == 7
    label var    employer "=1 if employer"
    
    *registered bussiness
    gen       firm_regis = .
    replace   firm_regis = 1 if p6772 == 1
    replace   firm_regis = 0 if p6772 == 2
    label var firm_regis "=1 if firm is registered"
    
    *profit
    gen       profit =      p6750
    replace   profit = . if p6750 == 98 | p6750 == 99
    label var profit "profit from activity last month"
         
    *12 month crop profit
    gen       profit_crop =      p550
    replace   profit_crop = . if p550 == 98 | p550 == 99
    label var profit_crop "12m profit from crop RURAL"
    
    *WORK HOURS
    *regular
    gen       job_hrs_reg =      p6800
    label var job_hrs_reg "main jobs regular weekly hours"
    
    *last week
    gen       job_hrs_lastw =      p6850
    label var job_hrs_lastw "main jobs last week hours"
    
    *FIRM SIZE
    gen          firm_size = p6870
    label var    firm_size "number of employees in firm"
    label define firm_size 1  "Alone"   ///
                           2  "[2-3]"   ///
                           3  "[4-5]"   ///
                           4  "[6-10]"   ///
                           5  "[11-19]"   ///
                           6  "[20-30]"   ///
                           7  "[31-50]"   ///
                           8  "[51-100]"   ///
                           9  "101 or more"   ///
    
    label values firm_size firm_size
    
    *ECONOMIC SECTOR
    *ISIC Rev4 4 digits
    if year >= 2008 & year <= 2019 {
		gen          sector4d_rev3 = rama4d
		destring     sector4d_rev3, force replace		
		replace      sector4d_rev3 = . if sector4d_rev3 == 0		
		label var    sector4d_rev3 "sector ISIC Rev3 A.C. 4 digits"
	}
    if year >= 2020 {
		gen          sector4d_rev4 = rama4d_r4
		destring     sector4d_rev4, force replace		
		replace      sector4d_rev4 = . if sector4d_rev4 == 0		
		label var    sector4d_rev4 "sector ISIC Rev4 A.C. 4 digits"
	}
    
    *ISIC Rev3 2 digits
    if year >= 2008 & year <= 2019 {
		gen          sector2d_rev3 = rama2d
		destring     sector2d_rev3, force replace
		replace      sector2d_rev3 = . if sector2d_rev3 == 0
		label var    sector2d_rev3 "sector ISIC Rev3 A.C. 2 digits"
	}
    if year >= 2020 {
		gen          sector2d_rev4 = rama2d_r4
		destring     sector2d_rev4, force replace
		replace      sector2d_rev4 = . if sector2d_rev4 == 0
		label var    sector2d_rev4 "sector ISIC Rev3 A.C. 2 digits"
	}
     

    *OCCUPATION  
    *----------   
    destring oficio, replace
    gen		ocupac8=.
	replace ocupac8=0 if oficio==0   
	replace ocupac8=1 if oficio==1|oficio==2|oficio==3|oficio==4|oficio==5|oficio==6|oficio==7| ///
								   oficio==8|oficio==9|oficio==11|oficio==12 
	replace ocupac8=2 if oficio==13|oficio==14|oficio==15|oficio==16|oficio==17|oficio==18|oficio==19
	replace ocupac8=3 if oficio==20|oficio==21 
	replace ocupac8=4 if oficio==30|oficio==31|oficio==32|oficio==33|oficio==34|oficio==39|oficio==35| ///
								   oficio==36|oficio==37|oficio==38 
	replace ocupac8=5 if oficio==40|oficio==41|oficio==42|oficio==43|oficio==44|oficio==45|oficio==49 
	replace ocupac8=6 if oficio==50|oficio==51|oficio==52|oficio==53|oficio==54|oficio==55|oficio==56| ///
								   oficio==57|oficio==58|oficio==59
	replace ocupac8=7 if oficio==60|oficio==61|oficio==62|oficio==63|oficio==64
	replace ocupac8=8 if oficio==70|oficio==71|oficio==72|oficio==73|oficio==74|oficio==76|oficio==75| ///
								   oficio==77|oficio==78|oficio==79|oficio==80|oficio==81|oficio==82|oficio==83| ///
								   oficio==84|oficio==85|oficio==86|oficio==87|oficio==88|oficio==89|oficio==90| ///
								   oficio==91|oficio==92|oficio==93|oficio==94|oficio==95|oficio==96|oficio==97| ///
								   oficio==98|oficio==99           
                               
	label define ocupaclbl  ///
					0 "No code"  ///
					1 "Professionals and Technicians 1" /// 
					2 "Professionals and Technicians 2"  ///
					3 "Managers and Public Officials"  ///
					4 "Administrative Staff"  ///
					5 "Merchant and Vendor" /// 
					6 "Service Worker"  ///
					7 "Agriculture and forest" /// 
					8 "Operator (non-agr.)"
				   
	label values ocupac8 ocupaclbl                   
    
    *ADDITIONAL VARIABLES
    *--------------------
    *weights
    gen wgt        = fex_c_2011
    gen wgt_year   = wgt/12
    gen wgt_sem    = wgt/6
    gen wgt_quarter= wgt/3
    
    *save 
    keep directorio secuencia_p /// 
              year month        quarter    semester year_q after_2012 /// time 
              area         department dep_cod  city   city_group  /// location
              age          gender     marital  rel_head /// personal
              hh_size      strata /// household
              read_write   enroll       edu_years      edu_level edu_level7 edu_level7_year /// education
              workage      apsp         inlf         active         employed  unemployed labor_state forma_trabajo /// labor state
              search_job   search_job_other            mean_got_job         mean_got_job_other       got_job_internet /// job search
              con_type     con_term     con_term_m     con_bonus con_sever  con_vacation tenure_firm union /// job quality
              pension      pension_type pension_who    health    health_type health_who /// formality
              w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
              sub_food     sub_food_inc sub_trans      sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
              prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
              profit       profit_crop   /// profits
              job_hrs_reg  job_hrs_lastw /// work hours 
              firm_size    sector* /// firm
              ocupac8 oficio /// occupation              
              wgt* /// weights
              
    order year month      quarter    semester year_q    after_2012 /// time 
               area       department dep_cod  city   city_group  /// location
               age        gender     marital  rel_head /// personal
               hh_size    strata /// household
               read_write   enroll       edu_years      edu_level edu_level7 edu_level7_year /// education
               workage      apsp         inlf         active         employed    unemployed labor_state forma_trabajo /// labor state
               search_job   search_job_other            mean_got_job         mean_got_job_other       got_job_internet /// job search               
               con_type     con_term     con_term_m     con_bonus   con_sever  con_vacation tenure_firm union /// job quality
               pension      pension_type pension_who    health      health_type health_who /// formality
               w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
               sub_food     sub_food_inc sub_trans sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
               prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
               profit       profit_crop   /// profits
               job_hrs_reg  job_hrs_lastw /// work hours 
               firm_size    sector* /// firm
               ocupac8 oficio /// occupation               
               wgt* /// weights
    
    compress           
    *save "$data_temp\\`y'_1_2_geih_temp.dta", replace
    save "$data_temp\\`y'.dta", replace
}

use "$data_temp\\2008_geih_temp.dta", clear
forvalues y = 2009/2019 {
    append using "$data_temp\\`y'_geih_temp.dta"
}
append using "$data_temp\\2020_1_2_geih_temp.dta"
append using "$data_temp\\2020_3_geih_temp.dta"
append using "$data_temp\\2021.dta"
compress
save "$process\\geih\\workdata_temp.dta", replace
*/
*--------------------------------------------
*NEW VARIABLES
*--------------------------------------------
use "$process\\geih\\workdata_temp.dta", clear

*keep only employed
*keep if employed == 1

*household IDs
*-------------
rename directorio  hh_id1
rename secuencia_p hh_id2

*label para actividad principal semana pasada
*--------------------------------------------
label define apsp 1  "Trabajando"   ///
                  2  "Buscando trabajo"  /// 
                  3  "Estudiando"  ///
                  4  "Oficios del hogar"  ///
                  5  "Incapacitado permanente"  ///
                  6  "Otra actividad"  ///

label values apsp apsp

*para Econometría Avanzada

exit
*minimum wages
*-------------
*daily
gen       min_wage_day = .
replace   min_wage_day = 14456.67 if year == 2007
replace   min_wage_day = 15383.33 if year == 2008
replace   min_wage_day = 16563.33 if year == 2009
replace   min_wage_day = 17166.67 if year == 2010
replace   min_wage_day = 17853.33 if year == 2011
replace   min_wage_day = 18890    if year == 2012
replace   min_wage_day = 19650    if year == 2013
replace   min_wage_day = 20533.33 if year == 2014
replace   min_wage_day = 21478.33 if year == 2015
replace   min_wage_day = 22981.83 if year == 2016
replace   min_wage_day = 24590.56 if year == 2017
replace   min_wage_day = 26041.40 if year == 2018
replace   min_wage_day = 27602.87 if year == 2019
replace   min_wage_day = 29260.10 if year == 2020
replace   min_wage_day = 30284.2  if year == 2021
label var min_wage_day   "minimum daily wage LCU"

*monthly
gen       min_wage_month = .
replace   min_wage_month = 433700 if year == 2007
replace   min_wage_month = 461500 if year == 2008
replace   min_wage_month = 496900 if year == 2009
replace   min_wage_month = 515000 if year == 2010
replace   min_wage_month = 535600 if year == 2011
replace   min_wage_month = 566700 if year == 2012
replace   min_wage_month = 589500 if year == 2013
replace   min_wage_month = 616000 if year == 2014
replace   min_wage_month = 644350 if year == 2015
replace   min_wage_month = 689455 if year == 2016
replace   min_wage_month = 737717 if year == 2017
replace   min_wage_month = 781242 if year == 2018
replace   min_wage_month = 828116 if year == 2019
replace   min_wage_month = 877803 if year == 2020
replace   min_wage_month = 908526 if year == 2021
label var min_wage_month "minimum monthly wage LCU"

*monthly
gen       min_wage_month_tr = .
replace   min_wage_month_tr = 433700 if year == 2008 & month == 1
replace   min_wage_month_tr = 461500 if year == 2008 & month >  1
replace   min_wage_month_tr = 461500 if year == 2009 & month == 1
replace   min_wage_month_tr = 496900 if year == 2009 & month >  1
replace   min_wage_month_tr = 496900 if year == 2010 & month == 1
replace   min_wage_month_tr = 515000 if year == 2010 & month >  1
replace   min_wage_month_tr = 515000 if year == 2011 & month == 1
replace   min_wage_month_tr = 535600 if year == 2011 & month >  1
replace   min_wage_month_tr = 535600 if year == 2012 & month == 1
replace   min_wage_month_tr = 566700 if year == 2012 & month >  1
replace   min_wage_month_tr = 566700 if year == 2013 & month == 1
replace   min_wage_month_tr = 589500 if year == 2013 & month >  1
replace   min_wage_month_tr = 589500 if year == 2014 & month == 1
replace   min_wage_month_tr = 616000 if year == 2014 & month >  1
replace   min_wage_month_tr = 616000 if year == 2015 & month == 1
replace   min_wage_month_tr = 644350 if year == 2015 & month >  1
replace   min_wage_month_tr = 644350 if year == 2016 & month == 1
replace   min_wage_month_tr = 689455 if year == 2016 & month >  1
replace   min_wage_month_tr = 689455 if year == 2017 & month == 1
replace   min_wage_month_tr = 737717 if year == 2017 & month >  1
replace   min_wage_month_tr = 737717 if year == 2018 & month == 1
replace   min_wage_month_tr = 781242 if year == 2018 & month >  1
replace   min_wage_month_tr = 781242 if year == 2019 & month == 1
replace   min_wage_month_tr = 828116 if year == 2019 & month >  1
replace   min_wage_month_tr = 828116 if year == 2020 & month == 1
replace   min_wage_month_tr = 877803 if year == 2020 & month >  1
replace   min_wage_month_tr = 877803 if year == 2021 & month == 1
replace   min_wage_month_tr = 908526 if year == 2021 & month >  1

label var min_wage_month_tr "minimum monthly wage LCU-Tax reform"

*year-month 
gen    year_m = ym(year,month)
format year_m %tm
label var year_m "Year-Month"

*year-semester
gen    year_s = yh(year,semester)
format year_s %th
label var year_s "Year-Semester"

*CPI merge
merge m:1 year month      using "$process\cpi" , nogen
merge m:1 year month city using "$process\cpi_city"
drop if _merge == 2
drop _merge
*no CPI city data for 2008 so I discard this year
*drop if cpi_city == .

*Líneas de pobreza merge
merge m:1 year month city using "$process\lp_ciudad"
drop if _merge == 2
drop _merge

*merge informality by december 2012
merge m:1 city      using "$tables\wgaps_inf_merge_geih", nogen

*male
gen       male = .
replace   male = 0 if gender == 2
replace   male = 1 if gender == 1
label var male "=1 if male"

*marital status
gen          marital3 = .
replace      marital3 = 1 if marital == 6 | marital == 1 
replace      marital3 = 2 if marital == 2 | marital == 3 
replace      marital3 = 3 if marital == 4 | marital == 5
label var    marital3 "marital status"
label define marital3 1  "Single"   ///
                      2  "Married"  /// 
                      3  "Other"  ///

label values marital3 marital3

*broad age groups
gen     age_gr4 = .
replace age_gr4 = 1  if age >=15 & age <= 24
replace age_gr4 = 2  if age >=25 & age <= 39
replace age_gr4 = 3  if age >=40 & age <= 59
replace age_gr4 = 4  if age >=60 & age != .
label define age_gr4 1  "[15-24]"   ///
                     2  "[25-39]"  /// 
                     3  "[40-59]"  ///
                     4  "[60+]"  ///
					
label values age_gr4 age_gr4
label var    age_gr4 "4 age groups"

*broad age groups
gen     age_gr3 = .
replace age_gr3 = 1  if age >=14 & age <= 28
replace age_gr3 = 2  if age >=29 & age <= 39
replace age_gr3 = 3  if age >=40 & age <= .
label define age_gr3 1  "[14-28]"   ///
                     2  "[29-39]"  /// 
                     3  "[40+]"  ///
					
label values age_gr3 age_gr3
label var    age_gr3 "3 age groups"

*education 4 levels 
gen     edu_level4 = .
replace edu_level4 = 1  if edu_years == 0
replace edu_level4 = 2  if edu_years >= 1 & edu_years <= 5
replace edu_level4 = 3  if edu_years >= 6 & edu_years <= 11
replace edu_level4 = 4  if edu_years >= 12 & edu_years != .
label define edu_level4 1  "None"   ///
                        2  "Primary"  /// 
                        3  "Secondary"  ///
                        4  "Tertiary or more"  ///
					
label values edu_level4 edu_level4
 
*urban
gen       urban = .
replace   urban = 0 if area == 2
replace   urban = 1 if area == 1
label var urban "=1 if urban"

*regions
*Regiï¿½n Caribe: Atlï¿½ntico, Bolivar, Cesï¿½r,Cï¿½rdoba,Sucre, Magdalena, La Guajira.
*Regiï¿½n Oriental: Norte de Santander, Santander, Boyacï¿½, Cundinamarca, Meta.
*Regiï¿½n Central: Caldas,Risaralda, Quindï¿½o, Tolima, Huila, Caquetï¿½, Antioquia.
*Regiï¿½n Pacï¿½fica: Chocï¿½, Cauca, Nariï¿½o, Valle.
*Bogotï¿½ D.C.
gen          region = .
replace      region = 1 if dep_cod == 2  | dep_cod == 4  | dep_cod == 9  | dep_cod == 12 | dep_cod == 22 | dep_cod == 15 | dep_cod == 14
replace      region = 2 if dep_cod == 18 | dep_cod == 21 | dep_cod == 5  | dep_cod == 11 | dep_cod == 16
replace      region = 3 if dep_cod == 6  | dep_cod == 20 | dep_cod == 19 | dep_cod == 23 | dep_cod == 13 | dep_cod == 7 | dep_cod == 1
replace      region = 4 if dep_cod == 10 | dep_cod == 8  | dep_cod == 17 | dep_cod == 24
replace      region = 5 if dep_cod == 3
label define region 1  "Caribe"   ///
                    2  "Oriental"  ///
                    3  "Central"  ///
                    4  "Pacífica"  ///
                    5  "Bogotá"  ///

label values region region
label var    region "region"

*small firm dummy
gen       firm_small = .
replace   firm_small = 1 if firm_size <= 3
replace   firm_small = 0 if firm_size >= 4 & firm_size != .
label var firm_small "=1 if firm size 5 emp. or less"

*private workers
*labor_state
*1	Private employee
*2	Public employee
*3	Domestic employee
*4	Self-employed
*5	Employer
*6	Unpaid family worker
*7	Unpaid private worker
*8	Laborer or farmhand
*9	Other
gen     private_emp = .
replace private_emp = 0 if labor_state == 2 | labor_state == 4 | labor_state == 6 | labor_state == 9
replace private_emp = 1 if labor_state == 1 | labor_state == 3 | labor_state == 5 | labor_state == 7 | labor_state == 8
*private worker = private employee, domestic employee, employer, unpaid private worker, laborer or farmhand 

*formality
*---------
*social security (pension & health)
gen       informal_ss = .
replace   informal_ss = 1 if pension == 0 | health == 0 | health_type == 3
replace   informal_ss = 0 if pension == 1 & health_type <= 2 & health_who <= 4
label var informal_ss "Informal if not affiliated to Social Security"

*no pension
gen       no_pension = .
replace   no_pension = 1 if pension == 0
replace   no_pension = 0 if pension == 1
label var no_pension "=1 if not contributing to any pension fund"

*no health
gen       no_health = .
replace   no_health = 1 if health      == 0 | health_type == 3
replace   no_health = 0 if health_type <= 2 & health_who  <= 4
label var no_health "=1 if without health care or in sub. health"

*who pays health dummy
gen     health_pay = .
replace health_pay = 1 if health_who == 1 | health_who == 3 | health_who == 4
replace health_pay = 0 if health_type == 3

*who pays pension dummy
gen     pension_pay = .
replace pension_pay = 1 if pension_who >= 1 & health_who <= 3
replace pension_pay = 0 if pension == 0

*social security (kugler version)
gen       formal_ss_kug = .
replace   formal_ss_kug = 1 if health_pay == 1 & pension_pay == 1
replace   formal_ss_kug = 0 if health_pay == 0 | pension_pay == 0
label var formal_ss_kug "Informal Kugler ver."
gen       informal_ss_kug = 1 - formal_ss
label var informal_ss_kug "Informal Kugler ver."

*# of monthly minimum wages
gen       nr_mw_month = w_m_gross / min_wage_month_tr
replace   nr_mw_month = profit    / min_wage_month_tr if nr_mw_month == .
label var nr_mw_month "# of minimum wages from main occupation"

*type of health coverage
gen          health_type_all = .
replace      health_type_all = 1 if health == 0
replace      health_type_all = 2 if health_type == 3
replace      health_type_all = 3 if health_type == 1
replace      health_type_all = 4 if health_type == 2
label define health_type_all 1  "No health coverage"   ///
                             2  "Subsidized"  ///
                             3  "Contributive"  /// 
                             4  "Special"  ///
					
label values health_type_all health_type_all

*hourly gross wage
*-----------------
*La duraciï¿½n mï¿½xima legal de la jornada ordinaria de trabajo es de ocho (8) horas al dï¿½a y cuarenta y ocho (48) a la semana
*48/8 = 6
gen       min_wage_hr  = min_wage_month_tr / 4 / 48
gen       aux1 = w_m_gross / 4
replace   aux1 = profit / 4 if aux1 == .
gen       w_m_gross_hr = aux1 / job_hrs_reg
drop aux*
gen       nr_mw_hr = w_m_gross_hr / min_wage_hr
label var nr_mw_hr "# of minimum hourly wages from main occupation"
gen       min_wage_hr_real = ( min_wage_hr / cpi ) * 100

*under MW
*monthly
gen     under_1mw_month = .
replace under_1mw_month = 1 if nr_mw_month >  0   & nr_mw_month < .99
replace under_1mw_month = 0 if nr_mw_month >= .99 & nr_mw_month != .
*hourly
gen     under_1mw_hr = .
replace under_1mw_hr = 1 if nr_mw_hr >  0   & nr_mw_hr < .99
replace under_1mw_hr = 0 if nr_mw_hr >= .99 & nr_mw_hr != . 

*INFORMALITY - social security & MWs
gen     informal_tr = .
replace informal_tr = 1 if (informal_ss == 1 | nr_mw_hr < .99 ) & ( labor_state <= 3 | labor_state == 8 )
replace informal_tr = 1 if  informal_ss == 1 & labor_state == 4
replace informal_tr = 0 if (informal_ss == 0 & nr_mw_hr >= .99 ) & ( labor_state <= 3 | labor_state == 8 )
replace informal_tr = 0 if  informal_ss == 0 & labor_state == 4

*real wages
*----------
*CPI January 2010 102.7
gen       w_month_real = ( w_m_gross / cpi_city ) * 100
replace   w_month_real = ( profit    / cpi_city ) * 100 if w_month_real == .
label var w_month_real "monthly wage from main occupation Dec2008 LCU"
gen       w_hr_real = ( w_m_gross_hr / cpi_city ) * 100 
label var w_hr_real "hourly wage from main occupation Dec2008 LCU"
 
corr nr_mw_month nr_mw_hr w_month_real w_hr_real
sum nr_mw_month nr_mw_hr w_month_real w_hr_real

*nominal labor income
*--------------------
gen       li_month = w_m_gross
replace   li_month = profit    if li_month == .
label var li_month "monthly labor income from main occupation LCU"
gen       li_hr = w_m_gross_hr 
label var li_hr "hourly labor income from main occupation LCU"

*total labor income in the household
*-----------------------------------
egen      li_month_hh = total(li_month), by(year_m hh_id1 hh_id2)
label var li_month_hh "monthly labor income from main occupation LCU in household"
egen      li_hr_hh = total(li_hr), by(year_m hh_id1 hh_id2)
label var li_hr_hh "hourly labor income from main occupation LCU in household"
 
*wages
*-----
*for employees
gen     w_main_employ = w_m_gross
sum     w_main_employ
replace w_main_employ = w_main_employ + w_overtime if w_overtime_inc == 0 & w_overtime != .
sum w_main_employ
foreach v in w_food w_rent w_transport w_in_kind {
	replace w_main_employ = w_main_employ + `v' if `v' != .
	sum w_main_employ
}
foreach v in sub_food sub_trans sub_fam sub_edu {
	replace w_main_employ = w_main_employ + `v' if `v'_inc == 0 & sub_food != .
	sum w_main_employ
} 

gen     nr_mw = .
replace nr_mw = 1 if nr_mw_month >= 0 & nr_mw_month < 1
replace nr_mw = 2 if nr_mw_month >= 1 & nr_mw_month < 2
replace nr_mw = 3 if nr_mw_month >= 2 & nr_mw_month < 10
replace nr_mw = 4 if nr_mw_month >= 10 & nr_mw_month != .

*one or more minimum wage
gen     one_more_mw_month = .
replace one_more_mw_month = 0 if nr_mw_month < 1
replace one_more_mw_month = 1 if nr_mw_month >= 1 & nr_mw_month != .

gen     one_more_mw_hr = .
replace one_more_mw_hr = 0 if nr_mw_hr < 1
replace one_more_mw_hr = 1 if nr_mw_hr >= 1 & nr_mw_hr != .
       
*---------------------
*POBREZA
*---------------------
gen li_month_pc = li_month_hh / hh_size
label var li_month_pc "monthly labor income from main occupation per capita LCU"

gen     poor_li_month = .
replace poor_li_month = 1 if li_month_pc <  lp_ciudad*0.64
replace poor_li_month = 0 if li_month_pc >= lp_ciudad*0.64 & li_month_pc != .
label var poor_li_month "=1 if poor based on monthly labor income from main occupation"

/*
*--------------------------
*SECTOR VULNERABLE COVID-19
*--------------------------
gen vulnerable = .
replace vulnerable =0 if sector4d_rev3 ==  111
replace vulnerable =0 if sector4d_rev3 ==  112
replace vulnerable =0 if sector4d_rev3 ==  113
replace vulnerable =0 if sector4d_rev3 ==  114
replace vulnerable =0 if sector4d_rev3 ==  115
replace vulnerable =0 if sector4d_rev3 ==  116
replace vulnerable =0 if sector4d_rev3 ==  117
replace vulnerable =0 if sector4d_rev3 ==  118
replace vulnerable =0 if sector4d_rev3 ==  119
replace vulnerable =0 if sector4d_rev3 ==  121
replace vulnerable =0 if sector4d_rev3 ==  122
replace vulnerable =0 if sector4d_rev3 ==  123
replace vulnerable =0 if sector4d_rev3 ==  124
replace vulnerable =0 if sector4d_rev3 ==  125
replace vulnerable =0 if sector4d_rev3 ==  129
replace vulnerable =0 if sector4d_rev3 ==  130
replace vulnerable =0 if sector4d_rev3 ==  140
replace vulnerable =0 if sector4d_rev3 ==  150
replace vulnerable =0 if sector4d_rev3 ==  201
replace vulnerable =0 if sector4d_rev3 ==  202
replace vulnerable =0 if sector4d_rev3 ==  501
replace vulnerable =0 if sector4d_rev3 ==  502
replace vulnerable =0 if sector4d_rev3 == 1010
replace vulnerable =0 if sector4d_rev3 == 1110
replace vulnerable =0 if sector4d_rev3 == 1120
replace vulnerable =0 if sector4d_rev3 == 1310
replace vulnerable =0 if sector4d_rev3 == 1320
replace vulnerable =0 if sector4d_rev3 == 1331
replace vulnerable =0 if sector4d_rev3 == 1339
replace vulnerable =0 if sector4d_rev3 == 1411
replace vulnerable =0 if sector4d_rev3 == 1413
replace vulnerable =0 if sector4d_rev3 == 1414
replace vulnerable =0 if sector4d_rev3 == 1415
replace vulnerable =0 if sector4d_rev3 == 1422
replace vulnerable =0 if sector4d_rev3 == 1431
replace vulnerable =0 if sector4d_rev3 == 1432
replace vulnerable =0 if sector4d_rev3 == 1511
replace vulnerable =0 if sector4d_rev3 == 1512
replace vulnerable =0 if sector4d_rev3 == 1521
replace vulnerable =0 if sector4d_rev3 == 1522
replace vulnerable =0 if sector4d_rev3 == 1530
replace vulnerable =0 if sector4d_rev3 == 1541
replace vulnerable =0 if sector4d_rev3 == 1542
replace vulnerable =0 if sector4d_rev3 == 1543
replace vulnerable =0 if sector4d_rev3 == 1551
replace vulnerable =0 if sector4d_rev3 == 1552
replace vulnerable =0 if sector4d_rev3 == 1561
replace vulnerable =0 if sector4d_rev3 == 1562
replace vulnerable =0 if sector4d_rev3 == 1563
replace vulnerable =0 if sector4d_rev3 == 1564
replace vulnerable =0 if sector4d_rev3 == 1571
replace vulnerable =0 if sector4d_rev3 == 1572
replace vulnerable =0 if sector4d_rev3 == 1581
replace vulnerable =0 if sector4d_rev3 == 1589
replace vulnerable =0 if sector4d_rev3 == 1591
replace vulnerable =0 if sector4d_rev3 == 1592
replace vulnerable =0 if sector4d_rev3 == 1593
replace vulnerable =0 if sector4d_rev3 == 1594
replace vulnerable =1 if sector4d_rev3 == 1600
replace vulnerable =1 if sector4d_rev3 == 1710
replace vulnerable =1 if sector4d_rev3 == 1720
replace vulnerable =1 if sector4d_rev3 == 1730
replace vulnerable =1 if sector4d_rev3 == 1741
replace vulnerable =1 if sector4d_rev3 == 1742
replace vulnerable =1 if sector4d_rev3 == 1743
replace vulnerable =1 if sector4d_rev3 == 1749
replace vulnerable =1 if sector4d_rev3 == 1750
replace vulnerable =1 if sector4d_rev3 == 1810
replace vulnerable =1 if sector4d_rev3 == 1820
replace vulnerable =1 if sector4d_rev3 == 1910
replace vulnerable =1 if sector4d_rev3 == 1921
replace vulnerable =1 if sector4d_rev3 == 1922
replace vulnerable =1 if sector4d_rev3 == 1923
replace vulnerable =1 if sector4d_rev3 == 1924
replace vulnerable =1 if sector4d_rev3 == 1925
replace vulnerable =1 if sector4d_rev3 == 1926
replace vulnerable =1 if sector4d_rev3 == 1929
replace vulnerable =1 if sector4d_rev3 == 1931
replace vulnerable =1 if sector4d_rev3 == 1932
replace vulnerable =1 if sector4d_rev3 == 1939
replace vulnerable =1 if sector4d_rev3 == 2010
replace vulnerable =1 if sector4d_rev3 == 2020
replace vulnerable =1 if sector4d_rev3 == 2030
replace vulnerable =1 if sector4d_rev3 == 2040
replace vulnerable =1 if sector4d_rev3 == 2090
replace vulnerable =1 if sector4d_rev3 == 2101
replace vulnerable =1 if sector4d_rev3 == 2102
replace vulnerable =1 if sector4d_rev3 == 2109
replace vulnerable =1 if sector4d_rev3 == 2211
replace vulnerable =1 if sector4d_rev3 == 2212
replace vulnerable =1 if sector4d_rev3 == 2213
replace vulnerable =1 if sector4d_rev3 == 2219
replace vulnerable =1 if sector4d_rev3 == 2220
replace vulnerable =1 if sector4d_rev3 == 2231
replace vulnerable =1 if sector4d_rev3 == 2233
replace vulnerable =1 if sector4d_rev3 == 2234
replace vulnerable =1 if sector4d_rev3 == 2240
replace vulnerable =1 if sector4d_rev3 == 2310
replace vulnerable =1 if sector4d_rev3 == 2321
replace vulnerable =1 if sector4d_rev3 == 2322
replace vulnerable =1 if sector4d_rev3 == 2411
replace vulnerable =1 if sector4d_rev3 == 2412
replace vulnerable =1 if sector4d_rev3 == 2413
replace vulnerable =1 if sector4d_rev3 == 2414
replace vulnerable =1 if sector4d_rev3 == 2421
replace vulnerable =1 if sector4d_rev3 == 2422
replace vulnerable =1 if sector4d_rev3 == 2423
replace vulnerable =1 if sector4d_rev3 == 2424
replace vulnerable =1 if sector4d_rev3 == 2429
replace vulnerable =1 if sector4d_rev3 == 2430
replace vulnerable =1 if sector4d_rev3 == 2511
replace vulnerable =1 if sector4d_rev3 == 2512
replace vulnerable =1 if sector4d_rev3 == 2513
replace vulnerable =1 if sector4d_rev3 == 2519
replace vulnerable =1 if sector4d_rev3 == 2521
replace vulnerable =1 if sector4d_rev3 == 2529
replace vulnerable =1 if sector4d_rev3 == 2610
replace vulnerable =1 if sector4d_rev3 == 2691
replace vulnerable =1 if sector4d_rev3 == 2692
replace vulnerable =1 if sector4d_rev3 == 2693
replace vulnerable =1 if sector4d_rev3 == 2694
replace vulnerable =1 if sector4d_rev3 == 2695
replace vulnerable =1 if sector4d_rev3 == 2696
replace vulnerable =1 if sector4d_rev3 == 2699
replace vulnerable =1 if sector4d_rev3 == 2710
replace vulnerable =1 if sector4d_rev3 == 2721
replace vulnerable =1 if sector4d_rev3 == 2729
replace vulnerable =1 if sector4d_rev3 == 2731
replace vulnerable =1 if sector4d_rev3 == 2732
replace vulnerable =1 if sector4d_rev3 == 2811
replace vulnerable =1 if sector4d_rev3 == 2812
replace vulnerable =1 if sector4d_rev3 == 2813
replace vulnerable =1 if sector4d_rev3 == 2891
replace vulnerable =1 if sector4d_rev3 == 2892
replace vulnerable =1 if sector4d_rev3 == 2893
replace vulnerable =1 if sector4d_rev3 == 2899
replace vulnerable =1 if sector4d_rev3 == 2911
replace vulnerable =1 if sector4d_rev3 == 2912
replace vulnerable =1 if sector4d_rev3 == 2913
replace vulnerable =1 if sector4d_rev3 == 2914
replace vulnerable =1 if sector4d_rev3 == 2915
replace vulnerable =1 if sector4d_rev3 == 2919
replace vulnerable =1 if sector4d_rev3 == 2921
replace vulnerable =1 if sector4d_rev3 == 2922
replace vulnerable =1 if sector4d_rev3 == 2923
replace vulnerable =1 if sector4d_rev3 == 2924
replace vulnerable =1 if sector4d_rev3 == 2925
replace vulnerable =1 if sector4d_rev3 == 2926
replace vulnerable =1 if sector4d_rev3 == 2927
replace vulnerable =1 if sector4d_rev3 == 2929
replace vulnerable =1 if sector4d_rev3 == 2930
replace vulnerable =1 if sector4d_rev3 == 3000
replace vulnerable =1 if sector4d_rev3 == 3110
replace vulnerable =1 if sector4d_rev3 == 3120
replace vulnerable =1 if sector4d_rev3 == 3130
replace vulnerable =1 if sector4d_rev3 == 3140
replace vulnerable =1 if sector4d_rev3 == 3150
replace vulnerable =1 if sector4d_rev3 == 3190
replace vulnerable =1 if sector4d_rev3 == 3210
replace vulnerable =1 if sector4d_rev3 == 3220
replace vulnerable =1 if sector4d_rev3 == 3230
replace vulnerable =1 if sector4d_rev3 == 3311
replace vulnerable =1 if sector4d_rev3 == 3312
replace vulnerable =1 if sector4d_rev3 == 3313
replace vulnerable =1 if sector4d_rev3 == 3320
replace vulnerable =1 if sector4d_rev3 == 3330
replace vulnerable =1 if sector4d_rev3 == 3410
replace vulnerable =1 if sector4d_rev3 == 3420
replace vulnerable =1 if sector4d_rev3 == 3430
replace vulnerable =1 if sector4d_rev3 == 3511
replace vulnerable =1 if sector4d_rev3 == 3512
replace vulnerable =1 if sector4d_rev3 == 3530
replace vulnerable =1 if sector4d_rev3 == 3591
replace vulnerable =1 if sector4d_rev3 == 3592
replace vulnerable =1 if sector4d_rev3 == 3599
replace vulnerable =1 if sector4d_rev3 == 3611
replace vulnerable =1 if sector4d_rev3 == 3612
replace vulnerable =1 if sector4d_rev3 == 3613
replace vulnerable =1 if sector4d_rev3 == 3614
replace vulnerable =1 if sector4d_rev3 == 3619
replace vulnerable =1 if sector4d_rev3 == 3691
replace vulnerable =1 if sector4d_rev3 == 3692
replace vulnerable =1 if sector4d_rev3 == 3693
replace vulnerable =1 if sector4d_rev3 == 3694
replace vulnerable =1 if sector4d_rev3 == 3699
replace vulnerable =1 if sector4d_rev3 == 3710
replace vulnerable =1 if sector4d_rev3 == 3720
replace vulnerable =0 if sector4d_rev3 == 4010
replace vulnerable =0 if sector4d_rev3 == 4020
replace vulnerable =0 if sector4d_rev3 == 4030
replace vulnerable =0 if sector4d_rev3 == 4100
replace vulnerable =1 if sector4d_rev3 == 4511
replace vulnerable =1 if sector4d_rev3 == 4512
replace vulnerable =1 if sector4d_rev3 == 4521
replace vulnerable =1 if sector4d_rev3 == 4522
replace vulnerable =1 if sector4d_rev3 == 4530
replace vulnerable =1 if sector4d_rev3 == 4541
replace vulnerable =1 if sector4d_rev3 == 4542
replace vulnerable =1 if sector4d_rev3 == 4543
replace vulnerable =1 if sector4d_rev3 == 4549
replace vulnerable =1 if sector4d_rev3 == 4551
replace vulnerable =1 if sector4d_rev3 == 4552
replace vulnerable =1 if sector4d_rev3 == 4559
replace vulnerable =1 if sector4d_rev3 == 4560
replace vulnerable =1 if sector4d_rev3 == 5011
replace vulnerable =1 if sector4d_rev3 == 5012
replace vulnerable =1 if sector4d_rev3 == 5020
replace vulnerable =1 if sector4d_rev3 == 5030
replace vulnerable =1 if sector4d_rev3 == 5040
replace vulnerable =1 if sector4d_rev3 == 5051
replace vulnerable =1 if sector4d_rev3 == 5052
replace vulnerable =0 if sector4d_rev3 == 5111
replace vulnerable =0 if sector4d_rev3 == 5112
replace vulnerable =1 if sector4d_rev3 == 5113
replace vulnerable =1 if sector4d_rev3 == 5119
replace vulnerable =0 if sector4d_rev3 == 5121
replace vulnerable =0 if sector4d_rev3 == 5122
replace vulnerable =1 if sector4d_rev3 == 5123
replace vulnerable =0 if sector4d_rev3 == 5124
replace vulnerable =0 if sector4d_rev3 == 5125
replace vulnerable =0 if sector4d_rev3 == 5126
replace vulnerable =0 if sector4d_rev3 == 5127
replace vulnerable =1 if sector4d_rev3 == 5131
replace vulnerable =1 if sector4d_rev3 == 5132
replace vulnerable =1 if sector4d_rev3 == 5133
replace vulnerable =1 if sector4d_rev3 == 5134
replace vulnerable =0 if sector4d_rev3 == 5135
replace vulnerable =0 if sector4d_rev3 == 5136
replace vulnerable =1 if sector4d_rev3 == 5137
replace vulnerable =1 if sector4d_rev3 == 5139
replace vulnerable =1 if sector4d_rev3 == 5141
replace vulnerable =1 if sector4d_rev3 == 5142
replace vulnerable =1 if sector4d_rev3 == 5151
replace vulnerable =1 if sector4d_rev3 == 5152
replace vulnerable =1 if sector4d_rev3 == 5153
replace vulnerable =1 if sector4d_rev3 == 5154
replace vulnerable =1 if sector4d_rev3 == 5155
replace vulnerable =1 if sector4d_rev3 == 5159
replace vulnerable =1 if sector4d_rev3 == 5161
replace vulnerable =1 if sector4d_rev3 == 5162
replace vulnerable =1 if sector4d_rev3 == 5163
replace vulnerable =1 if sector4d_rev3 == 5169
replace vulnerable =1 if sector4d_rev3 == 5170
replace vulnerable =1 if sector4d_rev3 == 5190
replace vulnerable =0 if sector4d_rev3 == 5211
replace vulnerable =0 if sector4d_rev3 == 5219
replace vulnerable =0 if sector4d_rev3 == 5221
replace vulnerable =0 if sector4d_rev3 == 5222
replace vulnerable =0 if sector4d_rev3 == 5223
replace vulnerable =1 if sector4d_rev3 == 5224
replace vulnerable =1 if sector4d_rev3 == 5225
replace vulnerable =1 if sector4d_rev3 == 5229
replace vulnerable =1 if sector4d_rev3 == 5231
replace vulnerable =1 if sector4d_rev3 == 5232
replace vulnerable =1 if sector4d_rev3 == 5233
replace vulnerable =1 if sector4d_rev3 == 5234
replace vulnerable =1 if sector4d_rev3 == 5235
replace vulnerable =1 if sector4d_rev3 == 5236
replace vulnerable =1 if sector4d_rev3 == 5237
replace vulnerable =1 if sector4d_rev3 == 5239
replace vulnerable =1 if sector4d_rev3 == 5241
replace vulnerable =1 if sector4d_rev3 == 5242
replace vulnerable =1 if sector4d_rev3 == 5243
replace vulnerable =1 if sector4d_rev3 == 5244
replace vulnerable =1 if sector4d_rev3 == 5245
replace vulnerable =1 if sector4d_rev3 == 5246
replace vulnerable =1 if sector4d_rev3 == 5249
replace vulnerable =1 if sector4d_rev3 == 5251
replace vulnerable =1 if sector4d_rev3 == 5252
replace vulnerable =1 if sector4d_rev3 == 5261
replace vulnerable =1 if sector4d_rev3 == 5262
replace vulnerable =1 if sector4d_rev3 == 5269
replace vulnerable =1 if sector4d_rev3 == 5271
replace vulnerable =1 if sector4d_rev3 == 5272
replace vulnerable =1 if sector4d_rev3 == 5511
replace vulnerable =1 if sector4d_rev3 == 5512
replace vulnerable =1 if sector4d_rev3 == 5513
replace vulnerable =1 if sector4d_rev3 == 5519
replace vulnerable =1 if sector4d_rev3 == 5521
replace vulnerable =1 if sector4d_rev3 == 5522
replace vulnerable =1 if sector4d_rev3 == 5523
replace vulnerable =1 if sector4d_rev3 == 5524
replace vulnerable =1 if sector4d_rev3 == 5529
replace vulnerable =1 if sector4d_rev3 == 5530
replace vulnerable =0 if sector4d_rev3 == 6010
replace vulnerable =0 if sector4d_rev3 == 6021
replace vulnerable =0 if sector4d_rev3 == 6022
replace vulnerable =0 if sector4d_rev3 == 6023
replace vulnerable =0 if sector4d_rev3 == 6031
replace vulnerable =0 if sector4d_rev3 == 6032
replace vulnerable =0 if sector4d_rev3 == 6039
replace vulnerable =0 if sector4d_rev3 == 6041
replace vulnerable =0 if sector4d_rev3 == 6042
replace vulnerable =0 if sector4d_rev3 == 6043
replace vulnerable =0 if sector4d_rev3 == 6044
replace vulnerable =0 if sector4d_rev3 == 6050
replace vulnerable =0 if sector4d_rev3 == 6111
replace vulnerable =0 if sector4d_rev3 == 6112
replace vulnerable =0 if sector4d_rev3 == 6120
replace vulnerable =1 if sector4d_rev3 == 6211
replace vulnerable =1 if sector4d_rev3 == 6212
replace vulnerable =1 if sector4d_rev3 == 6213
replace vulnerable =1 if sector4d_rev3 == 6214
replace vulnerable =1 if sector4d_rev3 == 6220
replace vulnerable =1 if sector4d_rev3 == 6310
replace vulnerable =1 if sector4d_rev3 == 6320
replace vulnerable =1 if sector4d_rev3 == 6331
replace vulnerable =1 if sector4d_rev3 == 6332
replace vulnerable =1 if sector4d_rev3 == 6333
replace vulnerable =1 if sector4d_rev3 == 6339
replace vulnerable =1 if sector4d_rev3 == 6340
replace vulnerable =1 if sector4d_rev3 == 6390
replace vulnerable =0 if sector4d_rev3 == 6411
replace vulnerable =0 if sector4d_rev3 == 6412
replace vulnerable =0 if sector4d_rev3 == 6421
replace vulnerable =0 if sector4d_rev3 == 6422
replace vulnerable =0 if sector4d_rev3 == 6423
replace vulnerable =0 if sector4d_rev3 == 6424
replace vulnerable =0 if sector4d_rev3 == 6425
replace vulnerable =0 if sector4d_rev3 == 6426
replace vulnerable =0 if sector4d_rev3 == 6511
replace vulnerable =0 if sector4d_rev3 == 6512
replace vulnerable =0 if sector4d_rev3 == 6513
replace vulnerable =0 if sector4d_rev3 == 6514
replace vulnerable =0 if sector4d_rev3 == 6515
replace vulnerable =0 if sector4d_rev3 == 6516
replace vulnerable =0 if sector4d_rev3 == 6519
replace vulnerable =0 if sector4d_rev3 == 6592
replace vulnerable =0 if sector4d_rev3 == 6593
replace vulnerable =0 if sector4d_rev3 == 6595
replace vulnerable =0 if sector4d_rev3 == 6596
replace vulnerable =0 if sector4d_rev3 == 6599
replace vulnerable =0 if sector4d_rev3 == 6601
replace vulnerable =0 if sector4d_rev3 == 6602
replace vulnerable =0 if sector4d_rev3 == 6603
replace vulnerable =0 if sector4d_rev3 == 6604
replace vulnerable =0 if sector4d_rev3 == 6711
replace vulnerable =0 if sector4d_rev3 == 6712
replace vulnerable =0 if sector4d_rev3 == 6713
replace vulnerable =0 if sector4d_rev3 == 6714
replace vulnerable =1 if sector4d_rev3 == 6715
replace vulnerable =0 if sector4d_rev3 == 6719
replace vulnerable =1 if sector4d_rev3 == 6721
replace vulnerable =1 if sector4d_rev3 == 6722
replace vulnerable =1 if sector4d_rev3 == 7010
replace vulnerable =1 if sector4d_rev3 == 7020
replace vulnerable =1 if sector4d_rev3 == 7111
replace vulnerable =1 if sector4d_rev3 == 7112
replace vulnerable =1 if sector4d_rev3 == 7121
replace vulnerable =1 if sector4d_rev3 == 7122
replace vulnerable =1 if sector4d_rev3 == 7123
replace vulnerable =1 if sector4d_rev3 == 7129
replace vulnerable =1 if sector4d_rev3 == 7130
replace vulnerable =0 if sector4d_rev3 == 7210
replace vulnerable =0 if sector4d_rev3 == 7220
replace vulnerable =0 if sector4d_rev3 == 7230
replace vulnerable =1 if sector4d_rev3 == 7240
replace vulnerable =1 if sector4d_rev3 == 7250
replace vulnerable =1 if sector4d_rev3 == 7290
replace vulnerable =0 if sector4d_rev3 == 7310
replace vulnerable =0 if sector4d_rev3 == 7320
replace vulnerable =0 if sector4d_rev3 == 7411
replace vulnerable =0 if sector4d_rev3 == 7412
replace vulnerable =1 if sector4d_rev3 == 7413
replace vulnerable =0 if sector4d_rev3 == 7414
replace vulnerable =0 if sector4d_rev3 == 7421
replace vulnerable =0 if sector4d_rev3 == 7422
replace vulnerable =1 if sector4d_rev3 == 7430
replace vulnerable =0 if sector4d_rev3 == 7491
replace vulnerable =0 if sector4d_rev3 == 7492
replace vulnerable =1 if sector4d_rev3 == 7493
replace vulnerable =1 if sector4d_rev3 == 7494
replace vulnerable =1 if sector4d_rev3 == 7495
replace vulnerable =0 if sector4d_rev3 == 7499
replace vulnerable =0 if sector4d_rev3 == 7511
replace vulnerable =0 if sector4d_rev3 == 7512
replace vulnerable =0 if sector4d_rev3 == 7513
replace vulnerable =0 if sector4d_rev3 == 7514
replace vulnerable =0 if sector4d_rev3 == 7515
replace vulnerable =0 if sector4d_rev3 == 7521
replace vulnerable =0 if sector4d_rev3 == 7522
replace vulnerable =0 if sector4d_rev3 == 7523
replace vulnerable =0 if sector4d_rev3 == 7524
replace vulnerable =0 if sector4d_rev3 == 7530
replace vulnerable =0 if sector4d_rev3 == 8011
replace vulnerable =0 if sector4d_rev3 == 8012
replace vulnerable =0 if sector4d_rev3 == 8021
replace vulnerable =0 if sector4d_rev3 == 8022
replace vulnerable =0 if sector4d_rev3 == 8030
replace vulnerable =0 if sector4d_rev3 == 8041
replace vulnerable =0 if sector4d_rev3 == 8042
replace vulnerable =0 if sector4d_rev3 == 8043
replace vulnerable =0 if sector4d_rev3 == 8044
replace vulnerable =0 if sector4d_rev3 == 8045
replace vulnerable =0 if sector4d_rev3 == 8046
replace vulnerable =0 if sector4d_rev3 == 8050
replace vulnerable =0 if sector4d_rev3 == 8060
replace vulnerable =0 if sector4d_rev3 == 8511
replace vulnerable =0 if sector4d_rev3 == 8512
replace vulnerable =1 if sector4d_rev3 == 8513
replace vulnerable =0 if sector4d_rev3 == 8514
replace vulnerable =0 if sector4d_rev3 == 8515
replace vulnerable =0 if sector4d_rev3 == 8519
replace vulnerable =0 if sector4d_rev3 == 8520
replace vulnerable =0 if sector4d_rev3 == 8531
replace vulnerable =0 if sector4d_rev3 == 8532
replace vulnerable =0 if sector4d_rev3 == 9000
replace vulnerable =1 if sector4d_rev3 == 9111
replace vulnerable =1 if sector4d_rev3 == 9112
replace vulnerable =1 if sector4d_rev3 == 9120
replace vulnerable =1 if sector4d_rev3 == 9191
replace vulnerable =1 if sector4d_rev3 == 9192
replace vulnerable =1 if sector4d_rev3 == 9199
replace vulnerable =1 if sector4d_rev3 == 9211
replace vulnerable =1 if sector4d_rev3 == 9212
replace vulnerable =1 if sector4d_rev3 == 9213
replace vulnerable =1 if sector4d_rev3 == 9214
replace vulnerable =1 if sector4d_rev3 == 9219
replace vulnerable =1 if sector4d_rev3 == 9220
replace vulnerable =1 if sector4d_rev3 == 9231
replace vulnerable =1 if sector4d_rev3 == 9232
replace vulnerable =1 if sector4d_rev3 == 9233
replace vulnerable =1 if sector4d_rev3 == 9241
replace vulnerable =1 if sector4d_rev3 == 9242
replace vulnerable =1 if sector4d_rev3 == 9249
replace vulnerable =1 if sector4d_rev3 == 9301
replace vulnerable =1 if sector4d_rev3 == 9302
replace vulnerable =1 if sector4d_rev3 == 9303
replace vulnerable =1 if sector4d_rev3 == 9309
replace vulnerable =1 if sector4d_rev3 == 9500
replace vulnerable =0 if sector4d_rev3 == 9900

*merge isic codes 
merge m:1 sector4d_rev3 using "$process\ciiu_rev3_rev4_4d", update
drop if year == .
drop _merge

*merge m:1 sector2d_rev3 using "$process\ciiu_rev3_rev4_2d", update
*drop if year == .
*drop _merge  
               
replace vulnerable = 0 if sector4d_rev4 == 111
replace vulnerable = 0 if sector4d_rev4 == 113
replace vulnerable = 0 if sector4d_rev4 == 119
replace vulnerable = 0 if sector4d_rev4 == 122
replace vulnerable = 0 if sector4d_rev4 == 123
replace vulnerable = 0 if sector4d_rev4 == 124
replace vulnerable = 0 if sector4d_rev4 == 130
replace vulnerable = 0 if sector4d_rev4 == 141
replace vulnerable = 0 if sector4d_rev4 == 142
replace vulnerable = 0 if sector4d_rev4 == 144
replace vulnerable = 0 if sector4d_rev4 == 145
replace vulnerable = 0 if sector4d_rev4 == 149
replace vulnerable = 0 if sector4d_rev4 == 150
replace vulnerable = 0 if sector4d_rev4 == 161
replace vulnerable = 0 if sector4d_rev4 == 170
replace vulnerable = 0 if sector4d_rev4 == 240
replace vulnerable = 0 if sector4d_rev4 == 311
replace vulnerable = 0 if sector4d_rev4 == 510
replace vulnerable = 0 if sector4d_rev4 == 610
replace vulnerable = 0 if sector4d_rev4 == 710
replace vulnerable = 0 if sector4d_rev4 == 722
replace vulnerable = 0 if sector4d_rev4 == 723
replace vulnerable = 0 if sector4d_rev4 == 729
replace vulnerable = 0 if sector4d_rev4 == 811
replace vulnerable = 0 if sector4d_rev4 == 812
replace vulnerable = 0 if sector4d_rev4 == 820
replace vulnerable = 0 if sector4d_rev4 == 892
replace vulnerable = 0 if sector4d_rev4 == 910
replace vulnerable = 0 if sector4d_rev4 == 990
replace vulnerable = 1 if sector4d_rev4 == 990
replace vulnerable = 0 if sector4d_rev4 == 1011
replace vulnerable = 0 if sector4d_rev4 == 1012
replace vulnerable = 0 if sector4d_rev4 == 1020
replace vulnerable = 0 if sector4d_rev4 == 1030
replace vulnerable = 0 if sector4d_rev4 == 1040
replace vulnerable = 0 if sector4d_rev4 == 1051
replace vulnerable = 0 if sector4d_rev4 == 1052
replace vulnerable = 0 if sector4d_rev4 == 1061
replace vulnerable = 0 if sector4d_rev4 == 1062
replace vulnerable = 0 if sector4d_rev4 == 1063
replace vulnerable = 0 if sector4d_rev4 == 1071
replace vulnerable = 0 if sector4d_rev4 == 1072
replace vulnerable = 0 if sector4d_rev4 == 1081
replace vulnerable = 0 if sector4d_rev4 == 1082
replace vulnerable = 0 if sector4d_rev4 == 1083
replace vulnerable = 1 if sector4d_rev4 == 1089
replace vulnerable = 0 if sector4d_rev4 == 1090
replace vulnerable = 0 if sector4d_rev4 == 1101
replace vulnerable = 0 if sector4d_rev4 == 1102
replace vulnerable = 0 if sector4d_rev4 == 1103
replace vulnerable = 0 if sector4d_rev4 == 1104
replace vulnerable = 1 if sector4d_rev4 == 1200
replace vulnerable = 1 if sector4d_rev4 == 1311
replace vulnerable = 1 if sector4d_rev4 == 1312
replace vulnerable = 1 if sector4d_rev4 == 1313
replace vulnerable = 1 if sector4d_rev4 == 1391
replace vulnerable = 1 if sector4d_rev4 == 1392
replace vulnerable = 1 if sector4d_rev4 == 1393
replace vulnerable = 1 if sector4d_rev4 == 1394
replace vulnerable = 1 if sector4d_rev4 == 1420
replace vulnerable = 1 if sector4d_rev4 == 1511
replace vulnerable = 1 if sector4d_rev4 == 1512
replace vulnerable = 1 if sector4d_rev4 == 1513
replace vulnerable = 1 if sector4d_rev4 == 1521
replace vulnerable = 1 if sector4d_rev4 == 1522
replace vulnerable = 1 if sector4d_rev4 == 1523
replace vulnerable = 1 if sector4d_rev4 == 1610
replace vulnerable = 1 if sector4d_rev4 == 1620
replace vulnerable = 1 if sector4d_rev4 == 1630
replace vulnerable = 1 if sector4d_rev4 == 1640
replace vulnerable = 1 if sector4d_rev4 == 1690
replace vulnerable = 1 if sector4d_rev4 == 1701
replace vulnerable = 1 if sector4d_rev4 == 1702
replace vulnerable = 1 if sector4d_rev4 == 1709
replace vulnerable = 1 if sector4d_rev4 == 1811
replace vulnerable = 1 if sector4d_rev4 == 1812
replace vulnerable = 1 if sector4d_rev4 == 1820
replace vulnerable = 1 if sector4d_rev4 == 1910
replace vulnerable = 1 if sector4d_rev4 == 1921
replace vulnerable = 1 if sector4d_rev4 == 2012
replace vulnerable = 1 if sector4d_rev4 == 2013
replace vulnerable = 1 if sector4d_rev4 == 2014
replace vulnerable = 1 if sector4d_rev4 == 2021
replace vulnerable = 1 if sector4d_rev4 == 2022
replace vulnerable = 1 if sector4d_rev4 == 2023
replace vulnerable = 1 if sector4d_rev4 == 2100
replace vulnerable = 1 if sector4d_rev4 == 2211
replace vulnerable = 1 if sector4d_rev4 == 2212
replace vulnerable = 1 if sector4d_rev4 == 2219
replace vulnerable = 1 if sector4d_rev4 == 2221
replace vulnerable = 1 if sector4d_rev4 == 2229
replace vulnerable = 1 if sector4d_rev4 == 2310
replace vulnerable = 1 if sector4d_rev4 == 2391
replace vulnerable = 1 if sector4d_rev4 == 2392
replace vulnerable = 1 if sector4d_rev4 == 2394
replace vulnerable = 1 if sector4d_rev4 == 2395
replace vulnerable = 1 if sector4d_rev4 == 2396
replace vulnerable = 1 if sector4d_rev4 == 2410
replace vulnerable = 1 if sector4d_rev4 == 2421
replace vulnerable = 1 if sector4d_rev4 == 2429
replace vulnerable = 1 if sector4d_rev4 == 2431
replace vulnerable = 1 if sector4d_rev4 == 2432
replace vulnerable = 1 if sector4d_rev4 == 2511
replace vulnerable = 1 if sector4d_rev4 == 2512
replace vulnerable = 1 if sector4d_rev4 == 2513
replace vulnerable = 1 if sector4d_rev4 == 2520
replace vulnerable = 1 if sector4d_rev4 == 2591
replace vulnerable = 1 if sector4d_rev4 == 2593
replace vulnerable = 1 if sector4d_rev4 == 2599
replace vulnerable = 1 if sector4d_rev4 == 2610
replace vulnerable = 1 if sector4d_rev4 == 2630
replace vulnerable = 1 if sector4d_rev4 == 2640
replace vulnerable = 1 if sector4d_rev4 == 2651
replace vulnerable = 1 if sector4d_rev4 == 2652
replace vulnerable = 1 if sector4d_rev4 == 2660
replace vulnerable = 1 if sector4d_rev4 == 2670
replace vulnerable = 1 if sector4d_rev4 == 2720
replace vulnerable = 1 if sector4d_rev4 == 2740
replace vulnerable = 1 if sector4d_rev4 == 2750
replace vulnerable = 1 if sector4d_rev4 == 2790
replace vulnerable = 1 if sector4d_rev4 == 2811
replace vulnerable = 1 if sector4d_rev4 == 2812
replace vulnerable = 1 if sector4d_rev4 == 2815
replace vulnerable = 1 if sector4d_rev4 == 2816
replace vulnerable = 1 if sector4d_rev4 == 2819
replace vulnerable = 1 if sector4d_rev4 == 2821
replace vulnerable = 1 if sector4d_rev4 == 2823
replace vulnerable = 1 if sector4d_rev4 == 2824
replace vulnerable = 1 if sector4d_rev4 == 2825
replace vulnerable = 1 if sector4d_rev4 == 2826
replace vulnerable = 1 if sector4d_rev4 == 2910
replace vulnerable = 1 if sector4d_rev4 == 2920
replace vulnerable = 1 if sector4d_rev4 == 3011
replace vulnerable = 1 if sector4d_rev4 == 3012
replace vulnerable = 1 if sector4d_rev4 == 3092
replace vulnerable = 1 if sector4d_rev4 == 3110
replace vulnerable = 1 if sector4d_rev4 == 3120
replace vulnerable = 1 if sector4d_rev4 == 3210
replace vulnerable = 1 if sector4d_rev4 == 3220
replace vulnerable = 1 if sector4d_rev4 == 3230
replace vulnerable = 1 if sector4d_rev4 == 3290
replace vulnerable = 1 if sector4d_rev4 == 3312
replace vulnerable = 0 if sector4d_rev4 == 3511
replace vulnerable = 0 if sector4d_rev4 == 3520
replace vulnerable = 0 if sector4d_rev4 == 3530
replace vulnerable = 0 if sector4d_rev4 == 3600
replace vulnerable = 0 if sector4d_rev4 == 3700
replace vulnerable = 1 if sector4d_rev4 == 3830
replace vulnerable = 1 if sector4d_rev4 == 4111
replace vulnerable = 1 if sector4d_rev4 == 4112
replace vulnerable = 1 if sector4d_rev4 == 4210
replace vulnerable = 1 if sector4d_rev4 == 4290
replace vulnerable = 1 if sector4d_rev4 == 4311
replace vulnerable = 1 if sector4d_rev4 == 4321
replace vulnerable = 1 if sector4d_rev4 == 4322
replace vulnerable = 1 if sector4d_rev4 == 4330
replace vulnerable = 1 if sector4d_rev4 == 4390
replace vulnerable = 1 if sector4d_rev4 == 4511
replace vulnerable = 1 if sector4d_rev4 == 4512
replace vulnerable = 1 if sector4d_rev4 == 4520
replace vulnerable = 1 if sector4d_rev4 == 4530
replace vulnerable = 1 if sector4d_rev4 == 4541
replace vulnerable = 0 if sector4d_rev4 == 4610
replace vulnerable = 1 if sector4d_rev4 == 4610
replace vulnerable = 0 if sector4d_rev4 == 4620
replace vulnerable = 1 if sector4d_rev4 == 4620
replace vulnerable = 0 if sector4d_rev4 == 4631
replace vulnerable = 0 if sector4d_rev4 == 4632
replace vulnerable = 1 if sector4d_rev4 == 4641
replace vulnerable = 1 if sector4d_rev4 == 4642
replace vulnerable = 1 if sector4d_rev4 == 4643
replace vulnerable = 1 if sector4d_rev4 == 4644
replace vulnerable = 0 if sector4d_rev4 == 4645
replace vulnerable = 1 if sector4d_rev4 == 4649
replace vulnerable = 0 if sector4d_rev4 == 4652
replace vulnerable = 1 if sector4d_rev4 == 4652
replace vulnerable = 1 if sector4d_rev4 == 4653
replace vulnerable = 1 if sector4d_rev4 == 4659
replace vulnerable = 1 if sector4d_rev4 == 4661
replace vulnerable = 1 if sector4d_rev4 == 4662
replace vulnerable = 1 if sector4d_rev4 == 4663
replace vulnerable = 1 if sector4d_rev4 == 4664
replace vulnerable = 1 if sector4d_rev4 == 4665
replace vulnerable = 1 if sector4d_rev4 == 4669
replace vulnerable = 1 if sector4d_rev4 == 4690
replace vulnerable = 0 if sector4d_rev4 == 4711
replace vulnerable = 0 if sector4d_rev4 == 4719
replace vulnerable = 0 if sector4d_rev4 == 4721
replace vulnerable = 0 if sector4d_rev4 == 4722
replace vulnerable = 0 if sector4d_rev4 == 4723
replace vulnerable = 1 if sector4d_rev4 == 4724
replace vulnerable = 1 if sector4d_rev4 == 4729
replace vulnerable = 1 if sector4d_rev4 == 4731
replace vulnerable = 1 if sector4d_rev4 == 4732
replace vulnerable = 1 if sector4d_rev4 == 4741
replace vulnerable = 1 if sector4d_rev4 == 4751
replace vulnerable = 1 if sector4d_rev4 == 4752
replace vulnerable = 1 if sector4d_rev4 == 4753
replace vulnerable = 1 if sector4d_rev4 == 4754
replace vulnerable = 1 if sector4d_rev4 == 4761
replace vulnerable = 1 if sector4d_rev4 == 4771
replace vulnerable = 1 if sector4d_rev4 == 4772
replace vulnerable = 1 if sector4d_rev4 == 4773
replace vulnerable = 1 if sector4d_rev4 == 4774
replace vulnerable = 1 if sector4d_rev4 == 4775
replace vulnerable = 1 if sector4d_rev4 == 4781
replace vulnerable = 1 if sector4d_rev4 == 4791
replace vulnerable = 1 if sector4d_rev4 == 4792
replace vulnerable = 0 if sector4d_rev4 == 4911
replace vulnerable = 0 if sector4d_rev4 == 4921
replace vulnerable = 0 if sector4d_rev4 == 4923
replace vulnerable = 0 if sector4d_rev4 == 4930
replace vulnerable = 0 if sector4d_rev4 == 5011
replace vulnerable = 0 if sector4d_rev4 == 5021
replace vulnerable = 1 if sector4d_rev4 == 5111
replace vulnerable = 1 if sector4d_rev4 == 5112
replace vulnerable = 1 if sector4d_rev4 == 5121
replace vulnerable = 1 if sector4d_rev4 == 5122
replace vulnerable = 1 if sector4d_rev4 == 5210
replace vulnerable = 1 if sector4d_rev4 == 5221
replace vulnerable = 1 if sector4d_rev4 == 5222
replace vulnerable = 1 if sector4d_rev4 == 5223
replace vulnerable = 1 if sector4d_rev4 == 5224
replace vulnerable = 1 if sector4d_rev4 == 5229
replace vulnerable = 0 if sector4d_rev4 == 5310
replace vulnerable = 0 if sector4d_rev4 == 5320
replace vulnerable = 1 if sector4d_rev4 == 5511
replace vulnerable = 1 if sector4d_rev4 == 5513
replace vulnerable = 1 if sector4d_rev4 == 5514
replace vulnerable = 1 if sector4d_rev4 == 5530
replace vulnerable = 1 if sector4d_rev4 == 5611
replace vulnerable = 1 if sector4d_rev4 == 5612
replace vulnerable = 1 if sector4d_rev4 == 5613
replace vulnerable = 1 if sector4d_rev4 == 5619
replace vulnerable = 1 if sector4d_rev4 == 5630
replace vulnerable = 1 if sector4d_rev4 == 5811
replace vulnerable = 1 if sector4d_rev4 == 5813
replace vulnerable = 0 if sector4d_rev4 == 5820
replace vulnerable = 1 if sector4d_rev4 == 5911
replace vulnerable = 1 if sector4d_rev4 == 5912
replace vulnerable = 1 if sector4d_rev4 == 5914
replace vulnerable = 1 if sector4d_rev4 == 5920
replace vulnerable = 0 if sector4d_rev4 == 6110
replace vulnerable = 0 if sector4d_rev4 == 6190
replace vulnerable = 0 if sector4d_rev4 == 6202
replace vulnerable = 1 if sector4d_rev4 == 6209
replace vulnerable = 1 if sector4d_rev4 == 6391
replace vulnerable = 0 if sector4d_rev4 == 6399
replace vulnerable = 0 if sector4d_rev4 == 6411
replace vulnerable = 0 if sector4d_rev4 == 6412
replace vulnerable = 0 if sector4d_rev4 == 6421
replace vulnerable = 0 if sector4d_rev4 == 6422
replace vulnerable = 0 if sector4d_rev4 == 6423
replace vulnerable = 0 if sector4d_rev4 == 6424
replace vulnerable = 0 if sector4d_rev4 == 6431
replace vulnerable = 0 if sector4d_rev4 == 6432
replace vulnerable = 0 if sector4d_rev4 == 6492
replace vulnerable = 0 if sector4d_rev4 == 6493
replace vulnerable = 0 if sector4d_rev4 == 6494
replace vulnerable = 0 if sector4d_rev4 == 6499
replace vulnerable = 0 if sector4d_rev4 == 6511
replace vulnerable = 0 if sector4d_rev4 == 6512
replace vulnerable = 0 if sector4d_rev4 == 6513
replace vulnerable = 0 if sector4d_rev4 == 6611
replace vulnerable = 0 if sector4d_rev4 == 6612
replace vulnerable = 0 if sector4d_rev4 == 6613
replace vulnerable = 1 if sector4d_rev4 == 6614
replace vulnerable = 0 if sector4d_rev4 == 6619
replace vulnerable = 1 if sector4d_rev4 == 6621
replace vulnerable = 1 if sector4d_rev4 == 6629
replace vulnerable = 1 if sector4d_rev4 == 6820
replace vulnerable = 0 if sector4d_rev4 == 6910
replace vulnerable = 0 if sector4d_rev4 == 6920
replace vulnerable = 0 if sector4d_rev4 == 7010
replace vulnerable = 0 if sector4d_rev4 == 7120
replace vulnerable = 0 if sector4d_rev4 == 7210
replace vulnerable = 0 if sector4d_rev4 == 7220
replace vulnerable = 1 if sector4d_rev4 == 7310
replace vulnerable = 1 if sector4d_rev4 == 7320
replace vulnerable = 1 if sector4d_rev4 == 7420
replace vulnerable = 0 if sector4d_rev4 == 7490
replace vulnerable = 0 if sector4d_rev4 == 7500
replace vulnerable = 1 if sector4d_rev4 == 7710
replace vulnerable = 1 if sector4d_rev4 == 7721
replace vulnerable = 1 if sector4d_rev4 == 7730
replace vulnerable = 0 if sector4d_rev4 == 7810
replace vulnerable = 1 if sector4d_rev4 == 7810
replace vulnerable = 1 if sector4d_rev4 == 7911
replace vulnerable = 1 if sector4d_rev4 == 7990
replace vulnerable = 1 if sector4d_rev4 == 8121
replace vulnerable = 1 if sector4d_rev4 == 8292
replace vulnerable = 0 if sector4d_rev4 == 8411
replace vulnerable = 0 if sector4d_rev4 == 8412
replace vulnerable = 0 if sector4d_rev4 == 8413
replace vulnerable = 0 if sector4d_rev4 == 8414
replace vulnerable = 0 if sector4d_rev4 == 8421
replace vulnerable = 0 if sector4d_rev4 == 8422
replace vulnerable = 0 if sector4d_rev4 == 8424
replace vulnerable = 0 if sector4d_rev4 == 8430
replace vulnerable = 0 if sector4d_rev4 == 8511
replace vulnerable = 0 if sector4d_rev4 == 8513
replace vulnerable = 0 if sector4d_rev4 == 8521
replace vulnerable = 0 if sector4d_rev4 == 8522
replace vulnerable = 0 if sector4d_rev4 == 8523
replace vulnerable = 0 if sector4d_rev4 == 8530
replace vulnerable = 0 if sector4d_rev4 == 8541
replace vulnerable = 0 if sector4d_rev4 == 8551
replace vulnerable = 1 if sector4d_rev4 == 8552
replace vulnerable = 0 if sector4d_rev4 == 8610
replace vulnerable = 0 if sector4d_rev4 == 8621
replace vulnerable = 1 if sector4d_rev4 == 8622
replace vulnerable = 0 if sector4d_rev4 == 8691
replace vulnerable = 0 if sector4d_rev4 == 8692
replace vulnerable = 0 if sector4d_rev4 == 8699
replace vulnerable = 0 if sector4d_rev4 == 8720
replace vulnerable = 0 if sector4d_rev4 == 8810
replace vulnerable = 1 if sector4d_rev4 == 9102
replace vulnerable = 1 if sector4d_rev4 == 9103
replace vulnerable = 1 if sector4d_rev4 == 9200
replace vulnerable = 1 if sector4d_rev4 == 9411
replace vulnerable = 1 if sector4d_rev4 == 9412
replace vulnerable = 1 if sector4d_rev4 == 9420
replace vulnerable = 1 if sector4d_rev4 == 9491
replace vulnerable = 1 if sector4d_rev4 == 9492
replace vulnerable = 1 if sector4d_rev4 == 9499
replace vulnerable = 1 if sector4d_rev4 == 9512
replace vulnerable = 1 if sector4d_rev4 == 9523
replace vulnerable = 1 if sector4d_rev4 == 9601
replace vulnerable = 1 if sector4d_rev4 == 9602
replace vulnerable = 1 if sector4d_rev4 == 9603
replace vulnerable = 1 if sector4d_rev4 == 9700
replace vulnerable = 0 if sector4d_rev4 == 9900
*/                
*ISIC Rev3 
*---------
label var    sector2d_rev3 "sector ISIC Rev3 2 digits"
label define sector2d_rev3 1  "Agriculture, hunting and related service activities"   ///
					  2  "Forestry, logging and related service activities"   ///
					  5  "Fishing, operation of fish hatcheries and fish farms"   ///
					  10 "Mining of coal and lignite"   ///
					  11 "Extraction of crude petroleum and natural gas"   ///
					  12 "Mining of uranium and thorium ores"   ///
					  13 "Mining of metal ores"   ///
					  14 "Other mining and quarrying"   ///
					  15 "Manufacture of food products and beverages"   ///
					  16 "Manufacture of tobacco products"   ///
					  17 "Manufacture of textiles"   ///
					  18 "Manufacture of wearing apparel"   ///
					  19 "Tanning and dressing of leather"   ///
					  20 "Manufacture of wood and of products of wood and cork"   ///
					  21 "Manufacture of paper and paper products"   ///
					  22 "Publishing, printing and reproduction of recorded media"   ///
					  23 "Manufacture of coke, refined petroleum products and nuclear fuel"   ///
					  24 "Manufacture of chemicals and chemical products"   ///
					  25 "Manufacture of rubber and plastics products"   ///
					  26 "Manufacture of other non-metallic mineral products"   ///
					  27 "Manufacture of basic metals"   ///
					  28 "Manufacture of fabricated metal products"   ///
					  29 "Manufacture of machinery and equipment"   ///
					  30 "Manufacture of office, accounting and computing machinery"   ///
					  31 "Manufacture of electrical machinery and apparatus"   ///
					  32 "Manufacture of radio, television and communication equipment and apparatus"   ///
					  33 "Manufacture of medical, precision and optical instruments, watches and clocks"   ///
					  34 "Manufacture of motor vehicles, trailers and semi-trailers"   ///
					  35 "Manufacture of other transport equipment"   ///
					  36 "Manufacture of furniture"   ///
					  37 "Recycling"   ///
					  40 "Electricity, gas, steam and hot water supply"   ///
					  41 "Collection, purification and distribution of water"   ///
					  45 "Construction"   ///
					  50 "Sale, maintenance and repair of motor vehicles and motorcycles"   ///
					  51 "Wholesale trade and commission trade"   ///
					  52 "Retail trade, except of motor vehicles and motorcycles"   ///
					  55 "Hotels and restaurants"   ///
					  60 "Land transport"   ///
					  61 "Water transport"   ///
					  62 "Air transport"   ///
					  63 "Supporting and auxiliary transport activities"   ///
					  64 "Post and telecommunications"   ///
					  65 "Financial intermediation"   ///
					  66 "Insurance and pension funding"   ///
					  67 "Activities auxiliary to financial intermediation"   ///
					  70 "Real estate activities"   ///
					  71 "Renting of machinery and equipment without operator and of personal and household goods"   ///
					  72 "Computer and related activities"   ///
					  73 "Research and development"   ///
					  74 "Other business activities"   ///
					  75 "Public administration and defence"   ///
					  80 "Education"   ///
					  85 "Health and social work"   ///
					  90 "Sewage and refuse disposal, sanitation and similar activities"   ///
					  91 "Activities of membership organizations"   ///
					  92 "Recreational, cultural and sporting activities"   ///
					  93 "Other service activities"   ///
					  95 "Private households with employed persons"   ///
					  99 "Extra-territorial organizations and bodies"   ///

label values sector2d_rev3 sector2d_rev3

*ISIC Rev3 1 digit
gen          sector1d_rev3 = .
replace      sector1d_rev3 = 1  if sector2d_rev3 >= 1  & sector2d_rev3 <= 2
replace      sector1d_rev3 = 2  if sector2d_rev3 == 5
replace      sector1d_rev3 = 3  if sector2d_rev3 >= 10 & sector2d_rev3 <= 14
replace      sector1d_rev3 = 4  if sector2d_rev3 >= 15 & sector2d_rev3 <= 37
replace      sector1d_rev3 = 5  if sector2d_rev3 >= 40 & sector2d_rev3 <= 41
replace      sector1d_rev3 = 6  if sector2d_rev3 == 45
replace      sector1d_rev3 = 7  if sector2d_rev3 >= 50 & sector2d_rev3 <= 52
replace      sector1d_rev3 = 8  if sector2d_rev3 == 55
replace      sector1d_rev3 = 9  if sector2d_rev3 >= 60 & sector2d_rev3 <= 64
replace      sector1d_rev3 = 10 if sector2d_rev3 >= 65 & sector2d_rev3 <= 67
replace      sector1d_rev3 = 11 if sector2d_rev3 >= 70 & sector2d_rev3 <= 74
replace      sector1d_rev3 = 12 if sector2d_rev3 == 75
replace      sector1d_rev3 = 13 if sector2d_rev3 == 80
replace      sector1d_rev3 = 14 if sector2d_rev3 == 85
replace      sector1d_rev3 = 15 if sector2d_rev3 >= 90 & sector2d_rev3 <= 93
replace      sector1d_rev3 = 16 if sector2d_rev3 == 95
replace      sector1d_rev3 = 17 if sector2d_rev3 == 99
label define sector1d_rev3 1  "Agriculture, hunting and forestry"   ///
					  2  "Fishing"   ///
					  3  "Mining and quarrying"   ///
					  4  "Manufacturing"   ///
					  5  "Electricity, gas and water supply"   ///
					  6  "Construction"   ///
					  7  "Wholesale and retail trade"   ///
					  8  "Hotels and restaurants"   ///
					  9  "Transport, storage and communications"   ///
					  10 "Financial intermediation"   ///
					  11 "Real estate, renting and business activities"   ///
					  12 "Public administration and defence"   ///
					  13 "Education"   ///
					  14 "Health and social work"   ///
					  15 "Other community, social and personal service activities"   ///
					  16 "Private households with employed persons"   ///
					  17 "Extra-territorial organizations and bodies"   ///

label values sector1d_rev3 sector1d_rev3
label var    sector1d_rev3 "sector ISIC Rev3 1 digit"

*Main sector
gen          sector3_rev3 = .            
replace      sector3_rev3 = 1 if sector1d_rev3 >= 1 & sector1d_rev3 <= 2
replace      sector3_rev3 = 2 if sector1d_rev3 >= 3 & sector1d_rev3 <= 6
replace      sector3_rev3 = 3 if sector1d_rev3 >= 7 & sector1d_rev3 <= 17
label define sector3_rev3 1 "Agriculture" ///
					 2 "Industry" ///
					 3 "Services" ///
					 
label values sector3_rev3 sector3_rev3

*Jobs Demand - 21 sectors
recode sector2d_rev3 (1/2   			= 1  "Agricultura") ///
                (5     			= 2  "Pesca") ///
                (10/14 			= 3  "Minas y canteras")  ///
                (15/21 23/37	= 4  "Manufacturas") ///
                (40/41 90		= 5  "Electricidad, gas y agua") ///
                (45  			= 6  "Construcción") ///
                (50/52 			= 7  "Comercio") ///
                (60/64 			= 8  "Transp., alm. y com.") ///
                (55  			= 9  "Hoteles y restaurantes")  ///
                (72 22  		= 10 "Información") ///
                (65/67 			= 11 "Finanzas") ///
                (70    			= 12 "Act. inmobiliarias")  ///
                (73/74 			= 13 "Act. profesionales") ///
                (71 			= 14 "Act. administrativas")  ///
                (75 			= 15 "Adm. pública y defensa")  ///
                (80 			= 16 "Educación")  ///
                (85 			= 17 "Salud")  ///
                (92 			= 18 "Entretenimiento") ///
                (91 93			= 19 "Otros servicios")  ///
                (95				= 20 "Hogares")   ///
                (99				= 21 "Extraterritorial") ///
                , g(sector21_rev3) 

*secondary sectors Jobs CCSA
gen          sector_jobs_rev3 = .
replace      sector_jobs_rev3 = 1  if sector1d_rev3 == 1 | sector1d_rev3 == 2
replace      sector_jobs_rev3 = 2  if sector1d_rev3 >= 3 & sector1d_rev3 <= 4
replace      sector_jobs_rev3 = 3  if sector1d_rev3 == 5
replace      sector_jobs_rev3 = 4  if sector1d_rev3 == 6
replace      sector_jobs_rev3 = 5  if sector1d_rev3 >= 7 & sector1d_rev3 <= 8
replace      sector_jobs_rev3 = 6  if sector1d_rev3 == 9
replace      sector_jobs_rev3 = 7  if sector1d_rev3 >= 10 & sector1d_rev3 <= 11
replace      sector_jobs_rev3 = 8  if sector1d_rev3 == 12
replace      sector_jobs_rev3 = 9  if sector1d_rev3 >= 13 & sector1d_rev3 <= 17
label define sector_jobs_rev3 1  "Agriculture, cattle and fishing"   ///
                         2  "Manufacture and mining"  ///
                         3  "Electricity, gas and water"  ///
                         4  "Construction"  ///
                         5  "Retail, restaurant and hotels"  ///
                         6  "Transport and communication"  ///
                         7  "Finance and real state"  ///
                         8  "Govt/public administration"  ///
                         9  "Other services"  ///
                                        
label values sector_jobs_rev3 sector_jobs_rev3
label var    sector_jobs_rev3 "secondary sectors Jobs CCSA"

*ISIC Rev4 
*---------
rename	sector2d_rev4 sector2d_rev4_orig
gen		sector2d_rev4 = int(sector4d_rev4/100)
label var    sector2d_rev4 "sector ISIC Rev4 2 digits"

*Jobs Demand - 21 sectors
recode sector2d_rev4	(1/2	= 1 "AgricHuntForest") /// 
						(3		= 2 "Fishing") ///
						(5/9	= 3 "MiningQuarrying") ///  
						(10/33	= 4 "Manufacturing") /// 
						(35/39	= 5 "Utilities") ///
						(41/43	= 6 "Construction") ///
						(45/47	= 7 "WholesaleRetail") ///
						(49/53	= 8 "TransportStorageComm") /// 
						(55/56	= 9 "HotelsRestaurants")  ///
						(58/63	= 10 "InformationComm") ///
						(64/66	= 11 "FinanceInsurance") /// 
						(68		= 12 "RealEstate")  ///
						(69/75	= 13 "Professional") ///
						(77/82	= 14 "Administrative")  ///
						(84/84	= 15 "PublicAdmin")  ///
						(85/85	= 16 "Education")  ///
						(86/88	= 17 "Health")  ///
						(90/93	= 18 "Entertainment") ///
						(94/96	= 19 "OtherServices") /// 
						(97/98	= 20 "Households")   ///
						(99/99	= 21 "Extraterritorial")   ///
						, g(sector21_rev4)

*15 sectores						
recode sector2d_rev4	(1/3  					= 1 "Agricultura") ///
						(5/9   					= 2 "Minas y canteras")  ///
						(10/33					= 3 "Manufacturas") ///
						(35/39					= 4 "Luz, agua y electricidad")  ///
						(41/43					= 5 "Construcción") ///
						(45/47					= 6 "Comercio") ///
						(18 49/53 				= 7 "Transp. y alm.")  ///
						(55/56					= 8 "Hoteles y restaurantes")  ///
						(58/63					= 9 "Inf. y comunic.")  ///
						(64/66 68           	= 10 "Finanzas y Act. inmob.") ///
						(69/75 77/82        	= 11 "Serv. Prof. y admin.") ///
						(84						= 12 "Gob. y admin. pub.") ///
						(85						= 13 "Educación")  ///
						(86/88					= 14 "Salud")  ///
						(90/99					= 15 "Otros servicios") ///
						, g(sector15_rev4)
				
*Sri Lanka JD - 12 sectors
recode sector2d_rev4	(1/3  				= 1 "Agriculture, cattle and fishing") ///
                       (5/9 35/39			= 2 "Mining and utilities")  ///
                       (10/11				= 3 "Manufacturing - Food and Bev.") ///
                       (13/15				= 4 "Manufacturing - Textile") ///
                       (12 16/17 19/33		= 5 "Manufacturing - Other") ///
                       (41/43				= 6 "Construction") ///
                       (45/47				= 7 "Wholesale & Retail") ///
                       (18 49/53 58/63		= 8 "Transport and communication")  ///
                       (64/66 68 69/75 77/82 = 9 "Finance and real state") ///
                       (84					= 10 "Govt/public administration") ///
                       (85/88				= 11 "Education & Health")  ///
                       (55/56 90/99			= 12 "Other services") ///
                       , g(sector12_rev4)

*Jobs Demand - 10 sectors
recode sector2d_rev4  (1/3           = 1 "Agriculture") ///
                        (5/9 35/39     = 2 "MiningQuarryingUtilities")  ///
						(10/11         = 3 "FoodBeverages") ///
						(13/15         = 4 "TextilesApparelLeather") ///
						(12 16/23 26/33= 6 "OtherManufacturing") ///
						(24/25         = 5 "Metals") /// 
						(41/43         = 7 "Construction") /// 
						(45/47         = 8 "WholesaleRetail") ///
						(49/53  58/63  = 9 "TransportCommStore") ///  
						(55/56 64/.   = 10 "OtherServices") ///
						, g(sector10_rev4)
                                   
*Jobs Demand - 5 sectors
recode sector21_rev4 (1 2  = 1 "Agriculture") /// 
                  (3 5  = 2 "MiningUtilities") ///
                  (4    = 3 "Manufacture") ///                       
                  (6    = 4 "Construction") ///
                  (7/.  = 5 "Services") /// 
                  , g(sector5_rev4)						
                   
*Jobs Demand - 3 sectors
recode sector5_rev4	(1   = 1 "Agriculture") /// 
					(2/4 = 2 "Industry") ///
					(5   = 3 "Services"), g(sector3_rev4)

*before-after tax reform dummy
gen       after = 0
replace   after = 1 if year >= 2013
label var after "=1 if year 2013 or after"

*treated vs untreated
*--------------------
gen       tr_treated = .

*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated = 1 if labor_state == 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated = 1 if labor_state == 9 & nr_mw_month <=  10

*CONTROLS
*self-employed workers earning less than 10 MWs
replace   tr_treated = 0 if labor_state == 4 & nr_mw_month <=  10
replace tr_treated = . if sector_jobs == 8

*gender+marital status
gen          female_marital = .
replace      female_marital = 0 if male == 1
replace      female_marital = 1 if male == 0 & rel_head == 2
replace      female_marital = 2 if male == 0 & rel_head != 2
label define female_marital 0  "Male"   ///
                            1  "Female spouse"  /// 
                            2  "Female other"  ///

label values female_marital female_marital
label var    female_marital "female+marital status"

*weights to string
foreach v in wgt wgt_year wgt_sem wgt_quarter {
	replace `v' = int(`v')
}

*treated vs untreated - # MWs as running var
*-------------------------------------------
*HOURLY MWS
*----------
gen       tr_treated_mw = . if employed == 1 & nr_mw_month <=  10
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_mw = 1 if labor_state == 1 & nr_mw_hr >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_mw = 1 if labor_state == 9 & nr_mw_hr >= 1 & nr_mw_month <=  10

*CONTROL
*private employees firm earning less than 10 MW
replace   tr_treated_mw = 0 if labor_state == 1 & nr_mw_hr < 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw = 0 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr < 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw = 0 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr < 1 & nr_mw_month <=  10
*all other workers firms earning less than 10 MWs
replace   tr_treated_mw = 0 if labor_state == 9 & nr_mw_hr < 1 & nr_mw_month <=  10

*discard government workers
replace tr_treated_mw = . if sector_jobs == 8

*MONTHLY MWS
*----------
gen       tr_treated_mw_month = . if employed == 1 & nr_mw_month <=  10
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_mw_month = 1 if labor_state == 1 & nr_mw_month >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw_month = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw_month = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_mw_month = 1 if labor_state == 9 & nr_mw_month >= 1 & nr_mw_month <=  10

*CONTROL
*private employees firm earning less than 10 MW
replace   tr_treated_mw_month = 0 if labor_state == 1 & nr_mw_month < 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw_month = 0 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month < 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw_month = 0 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month < 1 & nr_mw_month <=  10
*all other workers firms earning less than 10 MWs
replace   tr_treated_mw_month = 0 if labor_state == 9 & nr_mw_month < 1 & nr_mw_month <=  10

*discard government workers
replace tr_treated_mw_month = . if sector_jobs == 8

*SELF-EMPLOYED
*-------------
gen       tr_treated_self = . 
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_self = 1 if labor_state == 1 & nr_mw_hr >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_self = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_self = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_self = 1 if labor_state == 9 & nr_mw_hr >= 1 & nr_mw_month <=  10

*CONTROL
*self-employed earning less than 10 MW
replace   tr_treated_self = 0 if labor_state == 4

*discard government workers
replace tr_treated_self = . if sector_jobs == 8

*weights to string
foreach v in wgt wgt_year wgt_sem wgt_quarter {
	replace `v' = int(`v')
}

*different results variables
*---------------------------
gen     log_w_m_real = log(w_month_real)
gen     con_written = .
replace con_written = 0 if con_type == 1 | con_type == 3 | con_type == 4  
replace con_written = 1 if con_type == 2
gen     con_indef = .
replace con_indef = 0 if con_term == 2 | con_term == 3  
replace con_indef = 1 if con_term == 1
gen     health_0_1 = .
replace health_0_1 = 0 if health_type_all == 1 | health_type_all == 2  
replace health_0_1 = 1 if health_type_all == 3 | health_type_all == 4

*INFORMALITY - social security & MWs - residuals for seasonal adjust
*-------------------------------------------------------------------
*single regression
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust
predict inf_tr_resid1 if e(sample), resid
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust
predict no_pension_resid1 if e(sample), resid
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust
predict no_health_resid1 if e(sample), resid
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust
predict hrs_resid1 if e(sample), resid

*separate regressions
*--------------------
*informality - tax reform
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust
predict informal_tr_resid_0 if e(sample), resid
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust
predict informal_tr_resid_1 if e(sample), resid
gen     inf_tr_resid2 = .
replace inf_tr_resid2 = informal_tr_resid_0 if tr_treated == 0
replace inf_tr_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*informality - social security
reg informal_ss i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust
predict informal_tr_resid_0 if e(sample), resid
reg informal_ss i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust
predict informal_tr_resid_1 if e(sample), resid
gen     inf_ss_resid2 = .
replace inf_ss_resid2 = informal_tr_resid_0 if tr_treated == 0
replace inf_ss_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*pensions
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust
predict informal_tr_resid_0 if e(sample), resid
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust 
predict informal_tr_resid_1 if e(sample), resid
gen     no_pension_resid2 = .
replace no_pension_resid2 = informal_tr_resid_0 if tr_treated == 0
replace no_pension_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*health
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust 
predict informal_tr_resid_0 if e(sample), resid
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust 
predict informal_tr_resid_1 if e(sample), resid
gen     no_health_resid2 = .
replace no_health_resid2 = informal_tr_resid_0 if tr_treated == 0
replace no_health_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*hours of work
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust 
predict informal_tr_resid_0 if e(sample), resid
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust 
predict informal_tr_resid_1 if e(sample), resid
gen     hrs_resid2 = .
replace hrs_resid2 = informal_tr_resid_0 if tr_treated == 0
replace hrs_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*hourly real wages
reg w_hr_real i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust 
predict informal_tr_resid_0 if e(sample), resid
reg w_hr_real i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust 
predict informal_tr_resid_1 if e(sample), resid
gen     w_resid2 = .
replace w_resid2 = informal_tr_resid_0 if tr_treated == 0
replace w_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*under 1 hourly MW
reg under_1mw_hr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust 
predict informal_tr_resid_0 if e(sample), resid
reg under_1mw_hr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust 
predict informal_tr_resid_1 if e(sample), resid
gen     under_w_resid2 = .
replace under_w_resid2 = informal_tr_resid_0 if tr_treated == 0
replace under_w_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
 
*number of minimum wages
foreach v in hr month {
    gen          nr_mw_`v'_bins = .
    replace      nr_mw_`v'_bins = 1  if nr_mw_`v' == 0   
    replace      nr_mw_`v'_bins = 2  if nr_mw_`v' >  0    & nr_mw_`v' < 0.2
    replace      nr_mw_`v'_bins = 3  if nr_mw_`v' >= 0.2  & nr_mw_`v' < 0.4
    replace      nr_mw_`v'_bins = 4  if nr_mw_`v' >= 0.4  & nr_mw_`v' < 0.6
    replace      nr_mw_`v'_bins = 5  if nr_mw_`v' >= 0.6  & nr_mw_`v' < 0.8
    replace      nr_mw_`v'_bins = 6  if nr_mw_`v' >= 0.8  & nr_mw_`v' < 1
    replace      nr_mw_`v'_bins = 7  if nr_mw_`v' >= 1    & nr_mw_`v' < 1.03
    replace      nr_mw_`v'_bins = 8  if nr_mw_`v' >= 1.03 & nr_mw_`v' < 1.2
    replace      nr_mw_`v'_bins = 9  if nr_mw_`v' >= 1.2  & nr_mw_`v' < 1.4
    replace      nr_mw_`v'_bins = 10 if nr_mw_`v' >= 1.4  & nr_mw_`v' < 1.6
    replace      nr_mw_`v'_bins = 11 if nr_mw_`v' >= 1.6  & nr_mw_`v' < 1.8
    replace      nr_mw_`v'_bins = 12 if nr_mw_`v' >= 1.8  & nr_mw_`v' < 2
    replace      nr_mw_`v'_bins = 13 if nr_mw_`v' >= 2    & nr_mw_`v' < 3
    replace      nr_mw_`v'_bins = 14 if nr_mw_`v' >= 3    & nr_mw_`v' < 5
    replace      nr_mw_`v'_bins = 15 if nr_mw_`v' >= 5    & nr_mw_`v' != .
    label define nr_mw_`v'_bins 1  "0"   /// 
                                2  "(0-0.2)"   ///
                                3  "[0.2-0.4)"  ///
                                4  "[0.4-0.6)"  ///
                                5  "[0.6-0.8)"  ///
                                6  "[0.8-1)"  ///
                                7  "1"  ///
								8  "(1-1.2)"  ///
                                9  "[1.2-1.4)"  ///
								10 "[1.4-1.6)"  ///
								11 "[1.6-1.8)"  ///
                                12 "[1.8-2)"  ///
								13 "[2-3)"  ///
                                14 "[3-5)"  ///
                                15 "5 or more"  ///
								, modify
    					
    label values nr_mw_`v'_bins nr_mw_`v'_bins
    label var    nr_mw_`v'_bins "# `v' MW"
}

*number of minimum wages for # hourly MWs as running var
foreach v in hr month {
    gen          nr_mw_`v'_10bin = .
    replace      nr_mw_`v'_10bin = 1  if nr_mw_`v' >  0    & nr_mw_`v' < 0.2
    replace      nr_mw_`v'_10bin = 2  if nr_mw_`v' >= 0.2  & nr_mw_`v' < 0.4
    replace      nr_mw_`v'_10bin = 3  if nr_mw_`v' >= 0.4  & nr_mw_`v' < 0.6
    replace      nr_mw_`v'_10bin = 4  if nr_mw_`v' >= 0.6  & nr_mw_`v' < 0.8
    replace      nr_mw_`v'_10bin = 5  if nr_mw_`v' >= 0.8  & nr_mw_`v' < 1
    replace      nr_mw_`v'_10bin = 6  if nr_mw_`v' == 1
    replace      nr_mw_`v'_10bin = 7  if nr_mw_`v' >  1    & nr_mw_`v' < 1.2
    replace      nr_mw_`v'_10bin = 8  if nr_mw_`v' >= 1.2  & nr_mw_`v' < 1.4
    replace      nr_mw_`v'_10bin = 9  if nr_mw_`v' >= 1.4  & nr_mw_`v' < 1.6
    replace      nr_mw_`v'_10bin = 10 if nr_mw_`v' >= 1.6  & nr_mw_`v' < 1.8
    replace      nr_mw_`v'_10bin = 11 if nr_mw_`v' >= 1.8  & nr_mw_`v' < 2
    label define nr_mw_`v'_10bin 1  "(0.0-0.2)"   ///
                                 2  "[0.2-0.4)"  ///
                                 3  "[0.4-0.6)"  ///
                                 4  "[0.6-0.8)"  ///
                                 5  "[0.8-1.0)"  ///
                                 6  "[1]"  ///
                                 7  "(1.0-1.2)"  ///
                                 8  "[1.2-1.4)"  ///
                                 9  "[1.4-1.6)"  ///
                                 10 "[1.6-1.8)"  ///
                                 11 "[1.8-2.0)"  ///
    					
    label values nr_mw_`v'_10bin nr_mw_`v'_10bin
    label var    nr_mw_hr_10bin "# `v' MW"
}

*number of minimum wages for # hourly MWs as running var - SMOOTH
foreach v in hr month {
    gen     nr_mw_`v'_20bin = .
    forvalues b = 0(10)190 {
    	local i =  `b'     / 100
    	local j = (`b'+10) / 100           
    	replace      nr_mw_`v'_20bin = `b'  if nr_mw_`v' >= `i' & nr_mw_`v' < `j'
    	label define nr_mw_`v'_20bin   `b'  "[`i'-`j')", add
    }
    replace      nr_mw_`v'_20bin = .  if nr_mw_`v' == 0 
    label define nr_mw_`v'_20bin   0  "(0-0.10)", modify
    label values nr_mw_`v'_20bin nr_mw_`v'_20bin
}

*number of minimum wages for # hourly MWs as running var - SMOOTH
foreach v in hr month {
    gen     nr_mw_`v'_sbin = .
    forvalues b = 0(5)195 {
    	local i =  `b'    / 100
    	local j = (`b'+5) / 100
    	replace      nr_mw_`v'_sbin = `b'  if nr_mw_`v' >= `i' & nr_mw_`v' < `j'
    	label define nr_mw_`v'_sbin   `b'  "[`i'-`j')", add
    }
    *replace      nr_mw_`v'_sbin = .  if nr_mw_`v' == 0 
    *label define nr_mw_`v'_sbin   0  "(0-0.05)", modify
    label values nr_mw_`v'_sbin nr_mw_`v'_sbin
}

*around 1 MW
foreach v in hr month {
    gen          around_mw_`v' = .
    replace      around_mw_`v' = 1  if nr_mw_`v' >  0    & nr_mw_`v' < 1
    replace      around_mw_`v' = 2  if nr_mw_`v' >= 1    & nr_mw_`v' < 2
    label define around_mw_`v' 1 "(0-1)" ///
                               2 "[1-2)" ///
    					
    label values around_mw_`v' around_mw_`v'
    label var    around_mw_`v' "around `v' MW"
}

*quick calculations var
gen quick = uniform()

*self-employed vs employee
gen          emp_se_o = .
replace      emp_se_o = 1 if labor_state == 1 | labor_state == 2 | labor_state == 3 
replace      emp_se_o = 2 if labor_state == 4
replace      emp_se_o = 3 if labor_state >  4 & labor_state != .
label define emp_se_o 1 "Employee" ///
                      2 "Self-employed" ///
                      3 "Other" ///

label values emp_se_o emp_se_o

*above1mw
gen          above1mw = .
replace      above1mw = 0 if nr_mw_month <  1  
replace      above1mw = 1 if nr_mw_month >= 1 & nr_mw_month != .
label var above1mw "=1 if wage at or above 1 monthly MW"
gen below1mw = 1-above1mw

*above1mw hourly
gen       above1mw_hr = .
replace   above1mw_hr = 0 if nr_mw_hr <  1  
replace   above1mw_hr = 1 if nr_mw_hr >= 1 & nr_mw_hr != .
label var above1mw_hr "=1 if wage at or above 1 hourly MW"
gen below1mw_hr = 1-above1mw_hr

*winsorizing real wage by city year month tr_treated
winsor2 w_hr_real, replace cuts(0 99) by(city year month)

*year-month-city quintile/decile
*egen w_hr_real_yc_quin = xtile(w_hr_real), by(year city tr_treated) nq(5)
*egen w_hr_real_yc_dec  = xtile(w_hr_real), by(year city tr_treated) nq(10)
*egen w_hr_real_ymc_quin = xtile(w_hr_real), by(year month city tr_treated) nq(5)
*egen w_hr_real_ymc_dec  = xtile(w_hr_real), by(year month city tr_treated) nq(10)
*egen w_hr_real_yc_quin0 = xtile(w_hr_real) if w_hr_real >0 & w_hr_real != ., by(year city tr_treated) nq(5)
*egen w_hr_real_yc_dec  = xtile(w_hr_real) if w_hr_real >0 & w_hr_real != ., by(year city tr_treated) nq(10)
*egen w_hr_real_ymc_quin0 = xtile(w_hr_real) if w_hr_real >0 & w_hr_real != ., by(year month city tr_treated) nq(5)
*egen w_hr_real_ymc_dec  = xtile(w_hr_real), by(year month city tr_treated) nq(10)

*city relabel
label define city 11 "Bogotá DC" ///
                  5  "Medellín MA" ///
                  76 "Cali MA" ///
                  8  "Barranquilla MA" ///
                  68 "Bucaramanga MA" ///
                  17 "Manizales MA" ///
                  52 "Pasto" ///
                  66 "Pereira MA" ///
                  54 "Cúcuta MA" ///
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
                  99 "Rest" ///
                  , replace
                  
gen mw_dep = .                  
                  
replace mw_dep =	560831.9813	 if dep_cod ==	1	 & year == 2018 & month == 1
replace mw_dep =	434978.1494	 if dep_cod ==	2	 & year == 2018 & month == 1
replace mw_dep =	737717	 if dep_cod ==	3	 & year == 2018 & month == 1
replace mw_dep =	333115.8938	 if dep_cod ==	4	 & year == 2018 & month == 1
replace mw_dep =	410484.7308	 if dep_cod ==	5	 & year == 2018 & month == 1
replace mw_dep =	454930.9313	 if dep_cod ==	6	 & year == 2018 & month == 1
replace mw_dep =	388270.3638	 if dep_cod ==	7	 & year == 2018 & month == 1
replace mw_dep =	286606.4797	 if dep_cod ==	8	 & year == 2018 & month == 1
replace mw_dep =	376305.1924	 if dep_cod ==	9	 & year == 2018 & month == 1
replace mw_dep =	311089.119	 if dep_cod ==	10	 & year == 2018 & month == 1
replace mw_dep =	421420.5661	 if dep_cod ==	11	 & year == 2018 & month == 1
replace mw_dep =	317012.2182	 if dep_cod ==	12	 & year == 2018 & month == 1
replace mw_dep =	410061.4384	 if dep_cod ==	13	 & year == 2018 & month == 1
replace mw_dep =	331458.9052	 if dep_cod ==	14	 & year == 2018 & month == 1
replace mw_dep =	337506.3671	 if dep_cod ==	15	 & year == 2018 & month == 1
replace mw_dep =	497778.5817	 if dep_cod ==	16	 & year == 2018 & month == 1
replace mw_dep =	317288.5909	 if dep_cod ==	17	 & year == 2018 & month == 1
replace mw_dep =	365602.7617	 if dep_cod ==	18	 & year == 2018 & month == 1
replace mw_dep =	394318.275	 if dep_cod ==	19	 & year == 2018 & month == 1
replace mw_dep =	450233.3439	 if dep_cod ==	20	 & year == 2018 & month == 1
replace mw_dep =	502547.1836	 if dep_cod ==	21	 & year == 2018 & month == 1
replace mw_dep =	318161.3258	 if dep_cod ==	22	 & year == 2018 & month == 1
replace mw_dep =	366124.7657	 if dep_cod ==	23	 & year == 2018 & month == 1
replace mw_dep =	479952.4424	 if dep_cod ==	24	 & year == 2018 & month == 1

replace mw_dep =	593920.8378	 if dep_cod ==	1	 & year == 2018 & month > 1
replace mw_dep =	460641.6816	 if dep_cod ==	2	 & year == 2018 & month > 1
replace mw_dep =	781242	 if dep_cod ==	3	 & year == 2018 & month > 1
replace mw_dep =	352769.5947	 if dep_cod ==	4	 & year == 2018 & month > 1
replace mw_dep =	434703.1613	 if dep_cod ==	5	 & year == 2018 & month > 1
replace mw_dep =	481771.6694	 if dep_cod ==	6	 & year == 2018 & month > 1
replace mw_dep =	411178.1558	 if dep_cod ==	7	 & year == 2018 & month > 1
replace mw_dep =	303516.1443	 if dep_cod ==	8	 & year == 2018 & month > 1
replace mw_dep =	398507.0441	 if dep_cod ==	9	 & year == 2018 & month > 1
replace mw_dep =	329443.2492	 if dep_cod ==	10	 & year == 2018 & month > 1
replace mw_dep =	446284.2065	 if dep_cod ==	11	 & year == 2018 & month > 1
replace mw_dep =	335715.8089	 if dep_cod ==	12	 & year == 2018 & month > 1
replace mw_dep =	434254.8948	 if dep_cod ==	13	 & year == 2018 & month > 1
replace mw_dep =	351014.8444	 if dep_cod ==	14	 & year == 2018 & month > 1
replace mw_dep =	357419.1042	 if dep_cod ==	15	 & year == 2018 & month > 1
replace mw_dep =	527147.3135	 if dep_cod ==	16	 & year == 2018 & month > 1
replace mw_dep =	336008.4875	 if dep_cod ==	17	 & year == 2018 & month > 1
replace mw_dep =	387173.1744	 if dep_cod ==	18	 & year == 2018 & month > 1
replace mw_dep =	417582.8912	 if dep_cod ==	19	 & year == 2018 & month > 1
replace mw_dep =	476796.9262	 if dep_cod ==	20	 & year == 2018 & month > 1
replace mw_dep =	532197.261	 if dep_cod ==	21	 & year == 2018 & month > 1
replace mw_dep =	336932.7134	 if dep_cod ==	22	 & year == 2018 & month > 1
replace mw_dep =	387725.9765	 if dep_cod ==	23	 & year == 2018 & month > 1
replace mw_dep =	508269.4394	 if dep_cod ==	24	 & year == 2018 & month > 1

*# of monthly minimum department wages
gen       nr_mw_dep_month = w_m_gross / mw_dep
replace   nr_mw_dep_month = profit    / mw_dep if nr_mw_dep_month == .
label var nr_mw_dep_month "# of minimum dep wages from main occupation"

*under MW
*monthly
gen     under_1mw_dep_month = .
replace under_1mw_dep_month = 1 if nr_mw_dep_month >  0   & nr_mw_dep_month < .99
replace under_1mw_dep_month = 0 if nr_mw_dep_month >= .99 & nr_mw_dep_month != .

*post reform
gen     post2 = .
replace post2 = 0 if year < 2013
replace post2 = 0 if year == 2013 & month <= 4
replace post2 = 1 if year == 2013 & month >= 5
replace post2 = 1 if year >= 2014

*informality class
gen     inf_class = .
replace inf_class = 1 if city == 11 
replace inf_class = 2 if city == 17 | city == 5  |city == 66 |city == 76
replace inf_class = 3 if city == 15 | city == 68 |city == 63 |city == 41 |city == 13 | city == 73 | city == 50 | city == 8 | city == 47
replace inf_class = 4 if inf_class == .
label define inf_class 1 "Bogota" ///
                       2 "Low" ///
                       3 "Medium" ///
                       4 "High" ///
                       
label values inf_class inf_class
label var inf_class "informality class"

*paula informality class
gen     inf_class_old=.
replace inf_class_old=1 if city==11
replace inf_class_old=2 if city==13 | city==68 | city==73  | city==66 | city==5 | city==17 | city==76
replace inf_class_old=3 if city==23 | city==52 | city==54 | city==8 |city==50

*binomial informality class
gen     inf_class2 = .
replace inf_class2 = 0 if city == 17 | city == 5  | city == 11 |  city == 15 | city == 66 | city == 76
replace inf_class2 = 1 if inf_class2 == .
replace inf_class2 = . if city == 99
label define inf_class2 0 "Low" ///
                        1 "High" ///
                       
label values inf_class2 inf_class2
label var inf_class2 "informality class binary"

*city group
drop city_group
gen     city_group = .
replace city_group = 1 if city==11 | city==5  | city==76 | city==8  | city==68 | city==17 | city==52 | city==66 | city==73 | city==54 | city==50 | city==23 | city==13
replace city_group = 2 if city==15 | city==18 | city==19 | city==20 | city==27 | city==41 | city==44 | city==47 | city==63 | city==70
replace city_group = 3 if city==99
label define city_group 1 "13 big" ///
                        2 "11 intermediate" ///
                        3 "Rest" ///
                        , replace
                       
label values city_group city_group
label var city_group "city group"

*log wage
gen lw_hr_real = log(w_hr_real)

*save dataset
compress
save "$process\\geih\\workdata_wcity_gaps.dta", replace

*Para Econometría Avanzada
keep if year == 2019 | year == 2020
keep if month >= 8 & month <= 10
*save dataset
compress
