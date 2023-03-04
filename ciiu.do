*---------------------------------------------------------------------
* Function: import CIIU codes                                       
*---------------------------------------------------------------------

*4 dígitos
import excel "$data\original\geih\TC-CIIU-3ACvsCIIU-4AC-2020.xlsx", sheet("rev3_rev4_4d") firstrow clear
destring ciiu_rev4_4d, ignore("*") replace
drop *des
compress  
rename ciiu_rev3_4d sector4d_rev3
rename ciiu_rev4_4d sector4d_rev4
save "$process\ciiu_rev3_rev4_4d", replace

*2 dígitos
import excel "$data\original\geih\TC-CIIU-3ACvsCIIU-4AC-2020.xlsx", sheet("rev3_rev4_2d") firstrow clear
destring ciiu_rev4_2d, ignore("*") replace
exit
drop *des
compress
rename ciiu_rev3_2d sector2d_rev3
rename ciiu_rev4_2d sector2d_rev4
save "$process\ciiu_rev3_rev4_2d", replace
