*! arcplot v1.5 (07 Jun 2026)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.5 (07 Jun 2026): New options added: split(), splitshift(), colorprop, aspect(), xsize(), and ysize()
* v1.4 (02 Oct 2024): several fixes to code. added laboffset(), valoffset(), novalues, weight options
* v1.3 (31 Mar 2024): See below for v1.3
* v1.2 (16 Feb 2023): Major speed improvements through a flat structure
* v1.1 (18 Nov 2022): Several bug fixes. Improvements to code. Gtools added.
* v1.0 (22 Jun 2022): First beta release


**********************************
* Step-by-step guide on Medium   *
**********************************

* if you want to go for even more customization, you can read the Arcplots (6 Oct 2021) guide:
* https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6


cap program drop arcplot

program arcplot, sortpreserve

version 15
 
	syntax varlist(min=1 max=1 numeric) [if] [in] [aw fw pw iw/], From(varname) To(varname) 			  		///
		[ gap(real 1)  palette(string) LColor(string) LWidth(string) alpha(real 50) format(string)   		]	///
		[ VALGap(str) VALSize(string) VALAngle(string) VALColor(string) VALPos(string) VALCONDition(real 0)	]  	///
		[ LABGap(str) LABSize(string) LABAngle(string) LABColor(string) LABPos(string) 						]  	///
		[ sort(string) BOXWIDth(string) BOXINTensity(real 0.7) offset(real 0) 		]   ///  // v1.3
		[ LABOFFset(real 0.02) VALOFFset(real 0.01) NOVALues wrap(numlist >0 max=1) points(real 100)  ] 	/// // v1.4
		[ colorprop cuts(real 10) PROPColor(string) ] 														/// // v1.4
		[ options(string) ] 																				/// // v1.4
		[ SPLIT(varname) SPLITSHIFT(real 0.01) aspect(numlist max=1 >0.1) xsize(numlist max=1 >=1) ysize(numlist max=1 >=1) *   ] 								/// // v1.5
		
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
	
	capture findfile labsplit.ado
		if _rc != 0 quietly ssc install graphfunctions, replace			
	
	if !inlist("`sort'", "", "name", "value") {
		display as error "Valid options for {it:sort()} are {it:sort(name)} or {it:sort(value)}."
		exit
	}
	
	marksample touse, strok
	
preserve	
quietly {
	
	keep if `touse'
	
	local keepvars `varlist' `from' `to'
	if "`split'" != "" local keepvars `keepvars' `split'
	keep `keepvars'
	
	drop if `varlist' < 0
	drop if missing(`varlist')
	

	// drop missing entries
	
	drop if missing(`from') | missing(`to')

	
	// rename for consistency
	cap ren `from' lab1
	cap ren `to'   lab2 

	if "`split'" != "" {
		capture confirm numeric variable `split'
		if _rc {
			display as error "{it:split()} requires a numeric binary variable coded 0/1."
			exit
		}

		capture assert inlist(`split', 0, 1) if !missing(`split')
		if _rc {
			display as error "{it:split()} must be binary and coded 0/1."
			exit
		}

		drop if missing(`split')
		cap ren `split' _split
	}
	else {
		gen byte _split = 1
	}
	
	
	if "`weight'" != "" local myweight  [`weight' = `exp']
	
	collapse (sum) `varlist' `myweight', by(lab1 lab2 _split)
	
	sort lab2 lab1
	
	gen id = _n

	
	greshape long lab, i(id) j(layer)
	*drop id
	
	*replace lab1 = "Other" if `varlist' <= `threshold'
	*replace lab2 = "Other" if `varlist' <= `threshold'
	
	
	if "`sort'" == "name" {
		sort lab _split layer `varlist'
		gen _sum = 1
	}
	if "`sort'" == "value"  | "`sort'" == "" {
		bysort lab: egen _sum = sum(`varlist')
	}
	
	gsort -_sum lab _split layer -`varlist'
	
	egen tag = tag(lab)
	gen lab2 = sum(tag)
	labmask lab2, val(lab)
	
	gsort lab2 _split layer -`varlist'
	
	gen _id = _n  // global draw order
	bysort lab2 _split: gen order = _n // internal draw order
	  
	order _id order  

	cap drop tag
	egen tag = tag(lab _split)
	expand 2 if tag==1, gen(tag2)
	
	replace `varlist' = 0 if tag2==1 // duplicate entries are labeled as zero
	replace order = 0 if tag2==1
	replace id    = 0 if tag2==1

	drop tag tag2
	
	// generate cumulative values; with split(), node width is max(split totals)
	sort lab2 _split layer order
	bysort lab2 _split: gen double valsum = sum(`varlist')
	bysort lab2 _split: egen double split_tot = max(valsum)
	bysort lab2: egen double nodew = max(split_tot)
	gen double split_pad = 0
	if "`split'" != "" {
		replace split_pad = (nodew - split_tot) / 2
	}

	bysort lab2: gen byte node_tag = _n==1
	gen double nodecum = .
	replace nodecum = sum(cond(node_tag==1, nodew, 0))
	bysort lab2: egen double nodecum2 = max(nodecum)
	gen double nodestart = nodecum2 - nodew

	// add gaps between nodes
	egen gap = group(lab2)
	summ nodecum2 if node_tag==1, meanonly
	replace gap = (gap - 1) * r(max) * (`gap' / 100)

	gen double _x = nodestart + split_pad + valsum + gap
	gen _y = 0

	gen double nodeend = nodestart + nodew + gap if node_tag==1
	sum nodeend, meanonly
	replace _x = _x / r(max)
	replace nodeend = nodeend / r(max)

	
	// get the spikes
	sort id layer _x
						
	gen double _x1 = .
	gen double _y1 = .

	gen double _xsplit = .
	gen double _ysplit = .	
	
	gen double _x2 = .
	gen double _y2 = .								
									
	egen tag = tag(lab _split)
	// Calculate unified node boundaries across all splits (for proper centering)
	bysort lab2: egen double _x1g = min(_x)
	bysort lab2: egen double _x2g = max(_x)
	bysort lab2 _split: egen double _xsplit_l1 = max(cond(layer==1, _x, .))
	bysort lab2 _split: egen double _xsplit_l2 = max(cond(layer==2, _x, .))

	replace _x1 = _x1g if tag==1
	replace _x2 = _x2g if tag==1
	
	// For split nodes, arcs connect directly to node boundaries to eliminate gaps
	if "`split'" != "" {
		replace _xsplit = _x2 if tag==1
	}
	else {
		replace _xsplit = _xsplit_l1 if tag==1
		replace _xsplit = _xsplit_l2 if tag==1 & missing(_xsplit)
	}

	// split(): vertical offset from baseline for top/bottom halves
	local _splitshift = `splitshift'
	if "`split'" == "" {
		replace _y1     = 0 if tag==1
		replace _ysplit = 0 if tag==1
		replace _y2     = 0 if tag==1
	}
	else {
		// split(): keep all split nodes on the same horizontal axis (y=0) for centering
		replace _y1     = 0 if tag==1
		replace _ysplit = 0 if tag==1
		replace _y2     = 0 if tag==1
	}

	gen double xmid = (_x1 + _x2) / 2
	if "`split'" == "" {
		gen double ymid = ((_y1 + _y2) / 2) - `laboffset'
	}
	else {
		gen double ymid = 0 - `laboffset'
	}
	
	
	***************************
	*** generate the arcs   ***
	***************************

	// set obs
	if _N < `points' {
		set obs `=`points' + 1'	
	}
	else {
		local points  = `=_N - 1'
	}


	sort lab2 _split layer order 
	levelsof id if layer==1 & order!=0, local(lvls)

	foreach x of local lvls {
		
		gen boxx`x' = _x if id==`x'
		gen boxy`x' = _y if id==`x'

		// layer 1
		gen     seq`x' = 1 if id==`x' & layer==1
		replace seq`x' = 2 if id==`x' & layer==2
		
		summ lab2  if id==`x' & layer==1, meanonly
		local labcat1 = r(mean)
		summ _split if id==`x' & layer==1, meanonly
		local splitcat1 = r(mean)
			
		// start future block. these are used much later in the last step after reshape
		gen double from`x' = `labcat1'		// from node (source category id)
		
		summ `varlist' if id==`x' & layer==1, meanonly
		gen double fval`x' = r(mean)		// from value
			
		summ order if id==`x' & layer==1, meanonly
		local prel1 = `r(mean)' - 1
		
		// end future block here
		replace boxx`x' = _x if lab2==`labcat1' & _split==`splitcat1' & order==`prel1'
		replace boxy`x' = _y if lab2==`labcat1' & _split==`splitcat1' & order==`prel1'

		
		*** one more item for the future. the mid point for labels on the from values
		summ boxx`x' if layer==1, meanonly
		gen double fmid`x' = r(mean)
		
		
		// layer 2
		summ lab2  if id==`x' & layer==2, meanonly
		local labcat2 = r(mean)
		summ _split if id==`x' & layer==2, meanonly
		local splitcat2 = r(mean)
		
		summ order if id==`x' & layer==2, meanonly
		local prel2 = `r(mean)' - 1
		
		replace boxx`x' = _x if lab2==`labcat2' & _split==`splitcat2' & order==`prel2'
		replace boxy`x' = _y if lab2==`labcat2' & _split==`splitcat2' & order==`prel2'
		
		
		replace seq`x' = seq`x'[_n+1] if seq`x'[_n+1]!=.
	}

		gen seq = _n
		local increment = _pi / `=`points' - 1'
		gen double t = `increment' * (seq - 1) in 1/`points'  // keep last observation free
		

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
			local arcsign = 1

			if "`split'" != "" {
				// split(): mirror arcs in opposite directions based on split value
				// split=1 arcs curve upward, split=0 arcs curve downward
				// but node centers remain at y=0 for proper alignment
				summ _split if id==`x' & layer==1, meanonly
				if r(N) == 0 summ _split if id==`x' & layer==2, meanonly
				local midy = cond(r(mean)==1, `_splitshift', -`_splitshift')
				local arcsign = cond(r(mean)==1, 1, -1)
			}

			gen double radius`x'_in  = abs(`xin1'  - `midx') in 1/`points'
			gen double radius`x'_out = abs(`xout1' - `midx') in 1/`points'

			gen double arcx_in`x'   = `midx' + radius`x'_in * cos(t) in 1/`points'
			// split(): arcsign flips sin() to mirror the lower half
			gen double arcy_in`x'   = `midy' + (`arcsign' * radius`x'_in * sin(t)) in 1/`points'
			
			gen double arcx_out`x'  = `midx' + radius`x'_out * cos(t) in 1/`points'
			gen double arcy_out`x'  = `midy' + (`arcsign' * radius`x'_out * sin(t)) in 1/`points'
			
		}
		
		
		cap drop tag*
		egen tag = tag(_y _x)
		egen taglab = tag(ymid xmid)

	
		// carry split id through reshape so mirrored arcs remain grouped correctly
		keep _y1 _x1 _xsplit _ysplit _y2 _x2 ymid xmid arc* from* layer _split `varlist' lab2 fval* fmid* seq
		greshape long arcx_in arcy_in arcx_out arcy_out from fval fmid, i(seq _x1 _y1 _x2 _y2 xmid ymid layer _split `varlist' lab2) j(num)		

		ren arcx_in arcx1
		ren arcy_in arcy1

		ren arcx_out arcx2
		ren arcy_out arcy2		
			
		
			
		greshape long arcx arcy, i(seq _x1 _y1 _xsplit _ysplit _x2 _y2 num lab2 layer _split `varlist') j(level)	

		sort num level seq
		
		
		
		// control variables
		egen tag = tag(num)	
		gen _y = 0 if tag==1		
	
		
		*** order the layers		
				
		gen order = .		
		sort num level seq
		replace order = `points' + 1 - seq if level==1
		replace order = `points'     + seq if level==2

		
		cap drop tag2
		egen tag2 = tag(num ymid xmid) 

		sort num level order	
		
		
		*******************************			
		*** put everything together	***
		*******************************		
		
		
		if "`palette'" == "" {
			local palette tableau
		}
		else {
			tokenize "`palette'", p(",")
			local palette  `1'
			local poptions `3'
		}
		if "`lcolor'"      == "" local lcolor black
		if "`lwidth'"      == "" local lwidth none
		
		if "`labcolor'"    == "" local labcolor black
		if "`labangle'"    == "" local labangle 90
		if "`labgap'"      == "" local labgap 0
		if "`labpos'"      == "" local labpos 9
		if "`labsize'"     == "" local labsize 2
		
		if "`valangle'" == "" local valangle 90
		if "`valcolor'" == "" local valcolor black
		if "`valgap'"   == "" local valgap 0
		if "`valsize'"  == "" local valsize 1.2
		if "`valpos'"   == "" local valpos 12
		
		if "`boxwidth'"   == "" local boxwidth 2
		
		if "`format'" 	   == "" local format %7.2f
		
		gen fval2 = string(fval, "`format'") if _y!=. & fval >= `valcondition'
		gen double ylab = _y + `laboffset' if tag2==1
		
		local spikes

		levelsof lab2, local(lvls)
		local items = `r(r)' 
		local i = 0

		foreach x of local lvls {
			local ++i

			colorpalette `palette', n(`items') nograph `poptions'
			local spikes1 `spikes1' (pcspike _y1 _x1 _ysplit _xsplit if num==1 & lab2==`x', lc( "`r(p`i')'") lwidth(`boxwidth'))
			
			colorpalette `palette', n(`items') intensity(`boxintensity') nograph  `poptions'
			local spikes2 `spikes2' (pcspike _ysplit _xsplit _y2 _x2 if num==1 & lab2==`x', lc( "`r(p`i')'") lwidth(`boxwidth'))
			
		}
		
		if "`colorprop'" != "" {

			if "`cuts'" != "" & `cuts' < 3 {
				display as error "{it:cuts()} requires a minimum of 3 cuts."
				exit
			}

			xtile _grp = fval, n(`cuts')
		}




		local arcs		

		levelsof from, local(lvls)
		local items = `r(r)' 
		local i = 0
		
		foreach x of local lvls {
			local ++i

			if "`colorprop'" == "" {
				colorpalette `palette', n(`items') nograph  `poptions'
				local arcs `arcs' (area arcy arcx if from==`x', cmissing(n) nodropbase fi(100) fc( "`r(p`i')'%`alpha'") lw(`lwidth') lc(`lcolor')) 				
			}
			else {
				
				if "`propcolor'" == "" local propcolor white
				
				levelsof _grp if from==`x', local(grps)
				
				foreach y of local grps {
					
					colorpalette `palette', n(`items') nograph `poptions' return(hex)
					local _myclr : word `i' of `r(c)'
					colorpalette `propcolor' `_myclr' , n(`cuts') nograph
					
					local arcs `arcs' (area arcy arcx if from==`x' & _grp==`y', cmissing(n) fi(100) fc( "`r(p`y')'%`alpha'") lw(`lwidth') lc(`lcolor')) 	
					
				}
				
			}
		}
			
			
		local ystart  = 0 - (1 * (`offset' / 100))
		local ylabels `ystart' 0.5
		local yscaleopt
		summ arcx if !missing(arcx), meanonly
		local _xlo = r(min)
		local _xhi = r(max)
		local _xspan = `_xhi' - `_xlo'
		if missing(`_xspan') | `_xspan'<=0 {
			local _xlo = 0
			local _xhi = 1
			local _xspan = 1
		}
		local _xpad = max(0.002, `_xspan' * 0.01)
		local _xlo_use = `_xlo' - `_xpad'
		local _xhi_use = `_xhi' + `_xpad'
		local xscaleopt range(`_xlo_use' `_xhi_use') noextend
		local _aspect_base = 0.5
		if "`aspect'" != "" {
			local _aspect_base = `aspect'
		}
		local _aspect_standard = `_aspect_base'
		local _aspect_split = `_aspect_base'
		if "`split'" != "" {
			summ arcy if !missing(arcy), meanonly
			local _split_yabs = max(abs(r(min)), abs(r(max)))
			if missing(`_split_yabs') | `_split_yabs'<=0 {
				local _split_yabs = max(0.05, abs(`_splitshift'))
			}
			local _split_ypad = max(0.02, `_split_yabs' * 0.08)
			local _split_ylo = -(`_split_yabs' + `_split_ypad')
			local _split_yhi =   `_split_yabs' + `_split_ypad'
			local _split_yspan = `_split_yhi' - `_split_ylo'
			local _split_aspect_auto = min(1.2, max(0.65, `_split_yspan'))
			if `_aspect_split' < `_split_aspect_auto' {
				local _aspect_split = `_split_aspect_auto'
			}
			local ylabels `_split_ylo' 0 `_split_yhi'
			local yscaleopt range(`_split_ylo' `_split_yhi')
		}
		else {
			summ arcy if !missing(arcy), meanonly
			local _ylo = r(min)
			local _yhi = r(max)
			if missing(`_ylo') | missing(`_yhi') {
				local _ylo = `ystart'
				local _yhi = 0.5
			}
			local _ylo = min(`_ylo', `ystart')
			local _yspan = `_yhi' - `_ylo'
			if missing(`_yspan') | `_yspan'<=0 {
				local _yspan = 0.1
			}
			local _ypad = max(0.005, `_yspan' * 0.03)
			local _ylo = `_ylo' - `_ypad'
			local _yhi = `_yhi' + `_ypad'
			local ylabels `_ylo' 0 `_yhi'
			local yscaleopt range(`_ylo' `_yhi')
		}
		local _aspect_use = `_aspect_standard'

		if "`split'" == "" {
			if "`aspect'" == "" local _aspect_use = 0.5
			*if "`xsize'"  == "" local xsize = 2
			*if "`ysize'"  == "" local ysize = 1
		}
		else {
			if "`aspect'" == "" local _aspect_use = 1
			*if "`xsize'"  == "" local xsize = 1
			*if "`ysize'"  == "" local ysize = 1
		}	
		

		
		if "`novalues'" != "" {
			local values
		}
		else {
			local values (scatter ylab fmid if 		   tag2==1, mcolor(none) mlabsize(`valsize') mlab(fval2) mlabpos(`valpos') mlabangle(`valangle') mlabgap(`valgap') mlabcolor(`valcolor') )
		}
		
		
		
		local labval lab2
		
		/*  // need to add checks for lab2 being num, num+lab, or string
		if "`wrap'" != "" {
			labsplit lab2, wrap(`wrap') gen(_lab2)
			local labval _lab2
		}
		*/
			
		*** final graph	

		twoway ///
			`arcs' ///
			`spikes1' ///
			`spikes2' ///
			(scatter ymid xmid if num==1 & tag2==1, mcolor(none) mlabsize(`labsize')  mlab(`labval') mlabpos(`labpos') mlabangle(`labangle') mlabgap(`labgap') mlabcolor(`labcolor') ) ///	 
			`values' ///
				, legend(off) ///
					ylabel(`ylabels', nogrid) xlabel(0 1, nogrid) aspect(`_aspect_use')	///
					xscale(off `xscaleopt') yscale(off noextend `yscaleopt')	///
					xsize(`xsize') ysize(`ysize') `options'
		
		
		*/
}
restore				
		
end



*********************************
******** END OF PROGRAM *********
*********************************


