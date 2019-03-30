sysuse auto, clear

** Formatted table in Stata - version 1
eststo clear
eststo domestic: quietly estpost summarize ///
    price mpg weight headroom trunk if foreign == 0
eststo foreign: quietly estpost summarize ///
    price mpg weight headroom trunk if foreign == 1
eststo diff: quietly estpost ttest ///
    price mpg weight headroom trunk, by(foreign) unequal

esttab domestic foreign diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
mtitles("Domestic" "Foreign" "Diff") ///
label

eststo bygroup: estpost tabstat price in 1/15, by(make)
esttab bygroup, cells(mean) noobs nomtitle nonumber ///
	varlabels(`e(labels)') varwidth(20)

** Formatted table in Stata - version 2
eststo clear
estpost ttest price mpg weight headroom trunk, by(foreign) unequal
esttab, cells("mu_1 mu_2 b(star)")

** Formatted table in LaTeX
eststo clear
eststo domestic: estpost tabstat price mpg weight headroom trunk if foreign == 0, columns(statistics) statistics(count mean sd p25 p50 p75)
eststo foreign: estpost tabstat price mpg weight headroom trunk if foreign == 1, columns(statistics) statistics(count mean sd p25 p50 p75)
eststo diff: estpost ttest price mpg weight headroom trunk, by(foreign) unequal
esttab domestic foreign diff using two_sample_ttest.tex, ///
	cells("mean(pattern(1 1 0) f(1 3))  b(star pattern(0 0 1) f(1 3))" "sd(par([ ]) f(1 3) pattern(1 1 0)) se(pattern(0 0 1) par f(1 3))") ///
	label mlabels("Domestic" "Foreign" "Diff of Means") substitute(% \%) collabels(,none) ///
	prehead(`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"'  \begin{tabular}{@{\extracolsep{\fill}}l*{@E}{c}} \toprule ) ///
	postfoot(`"\bottomrule"' \end{tabular}) nonotes replace booktabs noisily compress nonum

	
