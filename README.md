
![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-arcplot) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-arcplot) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-arcplot) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-arcplot) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-arcplot)

# arcplot v1.1

This package allows us to draw arc plots in Stata. It is based on the [Arc plot Guide](https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6) (October 2021).


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.1**):

```
ssc install arcplot, replace
```

GitHub (**v1.1**):

```
net install arcplot, from("https://raw.githubusercontent.com/asjadnaqvi/stata-arcplot/main/installation/") replace
```



The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
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

The syntax for **v1.1** is as follows:

```
arcplot *num var* [if] [in], from(str var) to(str var) 
                [ gap(num) arcpoints(num) palette(str) alpha(num) format(str) lwidth(num) lcolor(str) 
				  labgap(str) labangle(str) labsize(str) labpos(str) labcolor(str)
				  vallabgap(str) vallabangle(str) vallabsize(str) vallabpos(str) vallabcolor(str)
                  xsize(num) ysize(num) title(str) subtitle(str) note(str) scheme(str) name(str) ]	
```

See the help file `help arcplot` for details.

The most basic use is as follows:

```
arcplot values, from(var1) to(var2)
```

where `var1` and `var2` are the string source and destination variables respectively against which the `values` are plotted. Out going values have the same color as the horizontal bar, while the incoming values have the colors of respective bars. This might still be refined but this is in line with standard arcplot packages in other softwares.



## Examples

Get the example data from GitHub:

```
use "https://github.com/asjadnaqvi/stata-arcplot/blob/main/data/sankey_example.dta?raw=true", clear
```

Let's test the `arcplot` command:

```
arcplot value, from(source) to(destination)
```

<img src="/figures/arcplot1.png" height="600">


```
arcplot value, f(source) t(destination) alpha(40) format(%9.2fc) gap(0.01) vallabg(3) vallabs(1.5) lc(black) lw(0.03) palette(scico romaO)
```

<img src="/figures/arcplot2.png" height="600">


## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-arcplot/issues) to report errors, feature enhancements, and/or other requests. 


## Versions


**v1.1 (08 Nov 2022)**
- Several bug fixes.
- Better label controls.
- Gtools added for faster reshapes.


**v1.0 (21 Aug 2022)**
- Public release.







