sysuse sp500,clear

sort date
tsset date
gen qdate = qofd(date)
format qdate %tq
local variables open close

include copylabels, adopath
collapse (mean) `variables', by(qdate)
include attachlabels, adopath

describe
