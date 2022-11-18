*! arcplot v1.1 (18 Nov 2022)
*! Asjad Naqvi 

* v1.1 18Nov2022. Several bug fixes. Improvements to code. Gtools added.
* v1.0 22Jun2022. First beta release


**********************************
* Step-by-step guide on Medium   *
**********************************

* if you want to go for even more customization, you can read the 
* Arc plots (6 Oct, 2021) guide:
* https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6


cap program drop arcplot


program arcplot, // sortpreserve

version 15
 
	syntax varlist(min=1 max=1 numeric) [if] [in], From(varname) To(varname) 			  									///
		[ gap(real 0.03) ARCPoints(real 50) palette(string) LColor(string) LWidth(string) alpha(real 50) format(str)     ]  ///
		[ VALLABGap(str) VALLABSize(string) VALLABAngle(string) VALLABColor(string)  					]  ///
		[    LABGap(str)    LABSize(string)      LABAngle(string)    LABColor(string) LABPos(string)  ]  ///
		[ title(passthru) subtitle(passthru) note(passthru) scheme(passthru) name(passthru) xsize(passthru) ysize(passthru)	]  
		
		
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The {bf:palettes} package is missing. Click to install: {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace}."
		exit
	}
	
	capture findfile gtools.ado
	if _rc != 0 {
		display as error "The {bf:gtools} package is missing. Click to install: {stata ssc install gtools, replace:gtools}."
		exit
	}
	
	capture findfile labmask.ado
	if _rc != 0 {
		qui ssc install labutil, replace
	}		
	
	marksample touse, strok
	
preserve	
qui {
	
	keep if `touse'
	
	gen lab1 = `from'
	gen lab2 = `to'
	
	collapse (sum) `varlist', by(lab1 lab2)
	
	sort lab2 lab1
	
	gen id = _n

	greshape long lab, i(id) j(layer)

	encode lab, gen(lab2)
	
	sort lab layer `varlist'
	bysort lab: gen order = _n
	
	egen tag = tag(lab)

	expand 2 if tag==1, gen(tag2)
	replace `varlist' = 0 if tag2==1 // duplicate entries are labeled as zero
	replace order = 0 if tag2==1
	replace id    = 0 if tag2==1

	sort lab layer order
	drop tag tag2
		
	// generate cumulative values
	sort lab layer order
	bysort lab: gen double valsum = sum(`varlist')

	gen double valsumtot = sum(`varlist')
	sort lab layer order
	
	// add gaps between arcs
	egen gap = group(lab)	
	summ valsumtot, meanonly
	replace gap = gap * r(max) * `gap'
	gen double valsumtotg = valsumtot + gap  

	gen _y = 0

	sum valsumtotg, meanonly
	gen double _x = valsumtotg / r(max)
	
	// get the spikes
	sort id layer _x
						
	gen double _x1 = .
	gen double _y1 = .

	gen double _x2 = .
	gen double _y2 = .								
									
	egen tag = tag(lab)								
									
	levelsof lab2, local(lvls)

	foreach x of local lvls {	
		summ _x if lab2==`x'
		replace _x1 = r(min) if lab2==`x' & tag==1
		replace _x2 = r(max) if lab2==`x' & tag==1

		summ _y if lab2==`x'
		replace _y1 = r(min) if lab2==`x' & tag==1
		replace _y2 = r(max) if lab2==`x' & tag==1		
	}


	gen double xmid = (_x1 + _x2) / 2
	gen double ymid = (_y1 + _y2) / 2		
	
	***************************
	*** generate the arcs   ***
	***************************
	

	sort lab layer order 
	levelsof id if layer==1 & order!=0, local(lvls)

	foreach x of local lvls {
		
		gen boxx`x' = _x if id==`x'
		gen boxy`x' = _y if id==`x'

		// layer 1
		
		gen     seq`x' = 1 if id==`x' & layer==1
		replace seq`x' = 2 if id==`x' & layer==2
		
		summ lab2  if id==`x' & layer==1, meanonly
		local labcat1 = r(mean)
			
		// start future block. these are used much later in the last step after reshape
		gen double from`x' = r(mean)		// from node
		
		summ `varlist' if id==`x' & layer==1, meanonly
		gen double fval`x' = r(mean)		// from value
			
		summ order if id==`x' & layer==1, meanonly
		local prel1 = `r(mean)' - 1
		
		// end future block here

		replace boxx`x' = _x if lab2==`labcat1' & order==`prel1'
		replace boxy`x' = _y if lab2==`labcat1' & order==`prel1'

		
		*** one more item for the future. the mid point for labels on the from values
		
		summ boxx`x' if layer==1, meanonly
		gen double fmid`x' = r(mean)
		
		// layer 2

		summ lab2  if id==`x' & layer==2, meanonly
		local labcat2 = r(mean)
		
		summ order if id==`x' & layer==2, meanonly
		local prel2 = `r(mean)' - 1
		
		replace boxx`x' = _x if lab2==`labcat2' & order==`prel2'
		replace boxy`x' = _y if lab2==`labcat2' & order==`prel2'
		
		
		replace seq`x' = seq`x'[_n+1] if seq`x'[_n+1]!=.
	}

		expand `arcpoints'  // higher the number, smoother the curve, but also slower the process

		levelsof id if layer==1 & order!=0, local(lvls)

		foreach x of local lvls { 
		  
			//  calculate the mid point of each box

			summ boxx`x' if seq`x'==2, meanonly
				local xout1 = r(min)
				local  xin1 = r(max)
				
			summ boxx`x' if seq`x'==1, meanonly
				local xout2 = r(max)
				local  xin2 = r(min)
			
			
			local midx = (`xout1' + `xout2')/2  
			local midy = 0 	

			
			local start = atan2(0 - `midy', `xout2' - `midx')
			local end   = atan2(0 - `midy', `xout1' - `midx') 
			
			
			if `start' < `end' {
				gen double t`x' = runiform(`start', `end')
			}
			else {
				gen double t`x' = runiform(`end', `start')
			}
			
			gen double radius`x'_in  = sqrt((`xin1'  - `midx')^2 + (0 - `midy')^2)   
			gen double radius`x'_out = sqrt((`xout1' - `midx')^2 + (0 - `midy')^2)    

			gen double arcx_in`x'   = `midx' + radius`x'_in * cos(t`x')
			gen double arcy_in`x'   = `midy' + radius`x'_in * sin(t`x')
			
			gen double arcx_out`x'  = `midx' + radius`x'_out * cos(t`x')
			gen double arcy_out`x'  = `midy' + radius`x'_out * sin(t`x')
			
		}

		cap drop tag*
		egen tag = tag(_y _x)
		egen taglab = tag(ymid xmid)

		sort lab layer order		
		
		keep _y1 _x1 _y2 _x2 ymid xmid arc* from* layer `varlist' lab2 fval* fmid*

		gen id = _n  // dummy for reshape
					
				
		greshape long arcx_in arcy_in arcx_out arcy_out from fval fmid, i(id _x1 _y1 _x2 _y2 xmid ymid layer `varlist' lab2) j(num)		

		ren arcx_in arcx1
		ren arcy_in arcy1

		ren arcx_out arcx2
		ren arcy_out arcy2		
		
		greshape long arcx arcy, i(id _x1 _y1 _x2 _y2 num lab2 layer `varlist') j(level)	
		
		// control variables
		egen tag = tag(num)	
		gen _y = 0 if tag==1		

		sort level num arcx	
		
		
		*** order the layers		
				
		sort num level arcx
		gen order = _n if level==1

		gsort level -arcx
		gen temp = _n if level==2

		replace order = temp if level==2
		drop temp

		cap drop tag2
		egen tag2 = tag(num ymid xmid) 


		sort num level order	
		
				
		*******************************			
		*** put everything together	***
		*******************************		
		
		
		if "`palette'"     == "" local palette CET C1
		if "`lcolor'"      == "" local lcolor black
		if "`lwidth'"      == "" local lwidth none
		
		if "`labcolor'"    == "" local labcolor black
		if "`labangle'"    == "" local labangle 0
		if "`labgap'"      == "" local labgap 0.5
		if "`labpos'"      == "" local labpos 6
		if "`labsize'"     == "" local labsize 2
		
		if "`vallabangle'" == "" local vallabangle 90
		if "`vallabcolor'" == "" local vallabcolor black
		if "`vallabgap'"   == "" local vallabgap 2
		if "`vallabsize'"  == "" local vallabsize 1.2
		
		if "`format'" 	   == "" local format %9.0fc
		
		gen fval2 = string(fval, "`format'") 
		
		local spikes

		levelsof lab, local(lvls)
		local items = `r(r)' 

		foreach x of local lvls {

			colorpalette `palette', n(`items') nograph
			
			local spikes `spikes' (pcspike _y1 _x1 _y2 _x2 if num==1 & lab==`x', lc( "`r(p`x')'") lwidth(1.5))	||
			
		}
				
		local arcs		
				
		levelsof num, local(lvls)
		foreach x of local lvls {
			
			summ from if num==`x', meanonly
			local clr `r(mean)'
			
			colorpalette `palette', n(`items') nograph
			
			local arcs `arcs' (area arcy arcx if num==`x', fi(100) fc( "`r(p`clr')'%`alpha'") lw(`lwidth') lc(`lcolor')) || 
			
		}
				

		twoway ///
			`arcs' ///
			`spikes' ///
			(scatter ymid xmid if num==1 & tag2==1, mcolor(none) mlabsize(`labsize')    mlab(lab2)  mlabpos(`labpos') mlabangle(`labangle')    mlabgap(`labgap') ) 	                           ///
			(scatter _y fmid                      , mcolor(none) mlabsize(`vallabsize') mlab(fval2) mlabpos(12)       mlabangle(`vallabangle') mlabgap(`vallabgap') mlabcolor(`vallabcolor') ) ///
				, legend(off) ///
					ylabel(0 0.6, nogrid) xlabel(0 1, nogrid) aspect(0.6)	///
					xscale(off) yscale(off)	`scheme' `name' `title' `subtitle' `note' `xsize' `ysize'
		
}
restore				
		
end



*********************************
******** END OF PROGRAM *********
*********************************


