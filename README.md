
![arcplot_banner](https://github.com/asjadnaqvi/stata-arcplot/assets/38498046/99e179c8-9ff0-4d7f-b0c4-92df813ff4cb)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-arcplot) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-arcplot) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-arcplot) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-arcplot) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-arcplot)

---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# arcplot v1.3
(31 Mar 2024)

This package allows us to draw arc plots in Stata. It is based on the [Arc plot Guide](https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6) (October 2021).


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.2**):

```
ssc install arcplot, replace
```

GitHub (**v1.3**):

```
net install arcplot, from("https://raw.githubusercontent.com/asjadnaqvi/stata-arcplot/main/installation/") replace
```


The following packages are required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
ssc install gtools, replace
```

Even if you have these packages installed, please check for updates: `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```stata
arcplot var [if] [in], from(var) to(var) 
                [ gap(num) arcpoints(num) palette(str) alpha(num) format(str) lcolor(str) lwidth(num) 
                  sort(value|name) boxwidth(str) boxintensity(num) offset(num)  
                  labgap(str) labangle(str) labsize(num) labcolor(str) labpos(str) 
                  valgap(str) valangle(str) valsize(num) valcolor(str) valpos(str) valcondition(num)
                  aspect(num) xsize(num) ysize(num) title(str) subtitle(str) note(str) scheme(str) name(str) 
                ]

```

See the help file `help arcplot` for details.

The most basic use is as follows:

```
arcplot var, from(var1) to(var2)
```

where `var1` and `var2` are the string source and destination variables respectively against which the numerical `var` variable is plotted. Out going values have the same color as the horizontal bar, while the incoming values have the colors of respective bars. Incoming boxes have a slightly different shade.



## Examples

Get the example data from GitHub:

```
use "https://github.com/asjadnaqvi/stata-arcplot/blob/main/data/trade_2022.dta?raw=true", clear
```

Let's test the `arcplot` command:

```
arcplot value, from(ex_region) to(im_region) 
```

<img src="/figures/arcplot1.png" width="100%">


```
arcplot value, from(ex_subregion) to(im_subregion) 
```

<img src="/figures/arcplot2.png" width="100%">

```
arcplot value, from(ex_subregion) to(im_subregion) ///
	labangle(45) labpos(7) 
```

<img src="/figures/arcplot3.png" width="100%">


```
arcplot value, from(ex_subregion) to(im_subregion) ///
	gap(1) labsize(1.3) labangle(45) labpos(7) labgap(0.5) offset(1)
```

<img src="/figures/arcplot4.png" width="100%">

```
arcplot value, from(ex_subregion) to(im_subregion) ///
	gap(1) labsize(1.3) labangle(45) labpos(7) labgap(0.5) offset(1)
```

<img src="/figures/arcplot5.png" width="100%">

```
arcplot value, from(ex_subregion) to(im_subregion) ///
	gap(1) labsize(1.3) labangle(45) labpos(7) labgap(0.5) ///
	offset(1) valcolor(black) valcond(100)	
```

<img src="/figures/arcplot6.png" width="100%">


Let's drop the minor regions:

```
drop if inlist(ex_subregion, "Melanesia", "Micronesia", "Polynesia")
drop if inlist(im_subregion, "Melanesia", "Micronesia", "Polynesia")
```



```
arcplot value, from(ex_subregion) to(im_subregion) ///
	gap(0.5) labsize(1.3) labangle(45) labpos(7) labgap(0.5) ///
	offset(1) valcolor(black) valcond(200) palette(CET C6)		
```

<img src="/figures/arcplot7.png" width="100%">

```
arcplot value, from(ex_region) to(im_region) ///
	gap(2) labsize(2) labangle(45) labpos(7) labgap(0.5) ///
	offset(1) valcolor(black) valcond(200) palette(CET C6)	///
	lc(black) lw(0.02) boxint(0.6) boxwid(2) alpha(50)
```

<img src="/figures/arcplot8.png" width="100%">

```
arcplot value, from(ex_region) to(im_region) ///
	gap(1) labsize(2) labangle(45) labpos(7) labgap(0.5) ///
	offset(1) valcolor(black) valcond(200) 	///
	lc(black) lw(0.02) boxint(0.6) boxwid(2) alpha(50)	///
	title("Value of regional trade (USD millions)") note("Source: COMTRADE-BACI", size(1.5))
```

<img src="/figures/arcplot9.png" width="100%">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-arcplot/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v1.3 (31 Mar 2024)**
- Options `sort()`, `boxwith()`, `boxintensity()`, `offset()`, `aspect()` added.
- Value labels of arcs now have simplified option names.
- `boxintensity()` allows users to control the color grading of the incoming flows part of the box.
- X-axis `gap()` for gaps between boxes and y-axis `offset()` now take on percentage values.
- Several defaults updates.
- Several fixes to optmize the code and draw faster.

**v1.2 (16 Feb 2023)**
- Massive speed improvements by flattening the code.

**v1.1 (08 Nov 2022)**
- Several bug fixes.
- Better label controls.
- Gtools added for faster reshapes.

**v1.0 (22 Jun 2022)**
- Public release.







