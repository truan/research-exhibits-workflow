---
layout: single
classes: wide
author_profile: false
sidebar:
  - text: " "
  - text: "View the Project on [GitHub](https://github.com/truan/research-exhibits-workflow), maintained by [Tianyue Ruan](https://truan.github.io/)."
permalink: /index.html
modified: March 2019
comments: false
---

Sample code fragments for creating commonly used exhibits in empirical research projects.

## Two-sample t-test of multiple variables

### Table (`estout/esttab`)

![Table of two-sample t-test of multiple variables]({{ site.url }}/assets/images/ttest_table.png)

<details>
<summary>Stata code</summary>

```
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
```

</details>

[\[Download\]]({{ site.url }}/assets/code/two_sample_ttest_table.do)

### Figure (`estout/esttab`, `coefplot`)

If the scale is similar across variables, the t-test result can be graphically presented. The scale varies a lot in the `auto` dataset. For illustration purposes, I create the figure using standardized versions of these variables.

![Figure of two-sample t-test of multiple variables]({{ site.url }}/assets/images/ttest_figure.png)

<details>
<summary>Stata code</summary>

```
sysuse auto, clear
foreach var in price mpg weight headroom trunk {
    egen `var'_z = std(`var')
    _crcslbl `var'_z `var'
}

estpost ttest price_z mpg_z weight_z headroom_z trunk_z, by(foreign) unequal

recode foreign (0=1) (1=0)
foreach var in price mpg weight headroom trunk {
    gen `var'_2 = foreign
    _crcslbl `var'_2 `var'
    quietly regress `var'_z `var'_2, robust
    estimates store `var'
}

coefplot price mpg weight headroom trunk ///
    , drop(_cons) nooffsets xline(0) xlabel(, labsize(small)) msymbol(D) mfcolor(white) ciopts(lwidth(*3) lcolor(*.6)) ///
    ylabel(,labsize(small) glcolor(gs7) glwidth(vvthin)) graphregion(color(white)) legend(off)
graph export "ttest_figure.png", as(png) width(1024) replace
```

</details>

[\[Download\]]({{ site.url }}/assets/code/two_sample_ttest_table.do)
<!-- [Download]({{ site.url }}/assets/code/two_sample_ttest_figure.do) -->

