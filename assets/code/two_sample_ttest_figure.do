sysuse auto, clear
// Create standardized versions for more informative graph
// In general, the graph works better for variables of similar scale
foreach var in price mpg weight headroom trunk {
	egen `var'_z = std(`var')
	_crcslbl `var'_z `var'
}

estpost ttest price_z mpg_z weight_z headroom_z trunk_z, by(foreign) unequal

gen byte domestic = 1 - foreign
foreach var in price mpg weight headroom trunk {
	gen `var'_2 = domestic
	_crcslbl `var'_2 `var'
	quietly regress `var'_z `var'_2, robust
    estimates store `var'
}

coefplot price mpg weight headroom trunk ///
	, drop(_cons) nooffsets xline(0) xlabel(, labsize(small)) msymbol(D) mfcolor(white) ciopts(lwidth(*3) lcolor(*.6)) ///
	ylabel(,labsize(small) glcolor(gs7) glwidth(vvthin)) graphregion(color(white)) legend(off)
graph export "ttest_figure.png", as(png) width(1024) replace
