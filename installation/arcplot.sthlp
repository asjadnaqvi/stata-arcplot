{smcl}
{* 02Oct2024}{...}
{hi:help arcplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-arcplot":arcplot v1.4 (GitHub)}}

{hline}

{title:arcplot}: A Stata package for Arc plots. 

The command is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6":Arc plots} guide on Medium.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:arcplot} {it:numvar} {ifin} {weight}, {cmdab:f:rom}({it:var}) {cmdab:t:o}({it:var}) 
                {cmd:[} {cmd:gap}({it:num}) {cmdab:arcp:oints}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmd:format}({it:str}) {cmdab:lc:olor}({it:str}) {cmdab:lw:idth}({it:num}) 
                  {cmd:sort({it:value}|{it:name})} {cmdab:boxw:idth}({it:str}) {cmdab:boxint:ensity}({it:num}) {cmd:offset}({it:num})  {cmdab:valcond:ition}({it:num}) {cmdab:noval:ues} 
                  {cmdab:labs:ize}({it:num}) {cmdab:labc:olor}({it:str}) {cmdab:laba:ngle}({it:str}) {cmdab:labp:os}({it:str}) {cmdab:laboff:set}({it:num}) {cmdab:labg:ap}({it:str}) 
                  {cmdab:vals:ize}({it:num}) {cmdab:valc:olor}({it:str}) {cmdab:vala:ngle}({it:str}) {cmdab:valp:os}({it:str}) {cmdab:valoff:set}({it:num}) {cmdab:valg:ap}({it:str}) * {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt arcplot} {it:numvar}}The command requires a numeric variable. Weights are allowed.{p_end}

{p2coldent : {opt f:rom(var)} {opt t:o(var)}}These are the source and destination variables.{p_end}

{p2coldent : {opt gap(num)}}Gap between the horizontal bars. Default value is {opt gap(1)} or 1% of total width.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt alpha(num)}}Transparency of the arcs. The default value is {opt alpha(50)} for 50%.{p_end}

{p2coldent : {opt sort(value|name)}}Sort order of the boxes. Default is {opt sort(value)} which results in numerically sorted boxes and arcs. 
The option {opt sort(name)} is alphabetically organized.{p_end}

{p2coldent : {opt boxwid:th(num)}}Thickness of the boxes. Default is {opt boxw(1.6)}.{p_end}

{p2coldent : {opt boxint:ensity(num)}}Color intensity of the box indicating incoming flows. Default is {opt boxint(0.7)}.
A value of 1 will result in same inflow and outflow colors.{p_end}


{p2coldent : {opt lw:idth(num)}}The outline width of the arcs. Default is {opt lw(none)} or no outlines.{p_end}

{p2coldent : {opt lc:olor(str)}}The outline color of the arcs. Default is {opt lc(black)}.{p_end}

{p2coldent : {opt arcp:oints(num)}}Number of points for evaluating arcs. Default is {opt arcp(100)}. Increase this number only on a needs basis.{p_end}


{p2coldent : {opt labs:ize(str)}}The size of the category labels. The default is {opt labs(2)}.{p_end}

{p2coldent : {opt labc:olor(str)}}The color of the category labels. The default is {opt labc(black)}.{p_end}

{p2coldent : {opt laba:ngle(str)}}The angle of the category labels. The default is {opt laba(90)}.{p_end}

{p2coldent : {opt labg:ap(str)}}The gap of the category labels from the center of the bars. The default is {opt labg(0)}.{p_end}

{p2coldent : {opt labp:os(str)}}The position of the category labels. The default is {opt labpos(6)}.{p_end}

{p2coldent : {opt laboff:set(num)}}Vertical displacement down of category labels. The default is {opt laboff(0.02)}.{p_end}


{p2coldent : {opt noval:ues}}Hide the values.{p_end}

{p2coldent : {opt valcond:ition(num)}}The condition to label the values is >= {it:num}. The default is {opt valcond(0)}.{p_end}

{p2coldent : {opt format(str)}}The format of the value labels. Default is {opt format(%7.2f)}.{p_end}

{p2coldent : {opt vals:ize(str)}}The size of the value labels. The default is {opt vals(1.2)}.{p_end}

{p2coldent : {opt valc:olor(str)}}The color of the value labels. The default is {opt valc(black)}.{p_end}

{p2coldent : {opt vala:ngle(str)}}The angle of the value labels. The default is {opt vala(90)}.{p_end}

{p2coldent : {opt valg:ap(str)}}The gap of the value labels from the center of the horizontal bars. The default is {opt valg(0)}.{p_end}

{p2coldent : {opt valp:os(str)}}The position of the value labels. The default is {opt valpos(12)}.{p_end}

{p2coldent : {opt valoff:set(num)}}Vertical displacement up of value labels. The default value is {opt valoff(0.01)}.{p_end}


{p2coldent : {opt offset(num)}}Offset for the y-axis. Default is {opt offset(0)} or 0% of graph height.
Useful if rotated labels are cut at the bottom.{p_end}

{p2coldent : {opt *}}All other standard twoway options not elsewhere specified.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{cmd:arcplot} requires the following packages:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install gtools, replace}
{stata ssc install graphfunctions, replace}


{title:Examples}: 

See {browse "https://github.com/asjadnaqvi/arcplot":GitHub}.


{title:Package details}

Version      : {bf:arcplot} v1.4
This release : 02 Oct 2024
First release: 22 Jun 2022
Repository   : {browse "https://github.com/asjadnaqvi/arcplot":GitHub}
Keywords     : Stata, graph, arc plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-arcplot/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

Suggested citation guidlines for this package:

Naqvi, A. (2024). Stata package "arcplot" version 1.4. Release date 02 October 2024. https://github.com/asjadnaqvi/stata-arcplot.

@software{arcplot,
   author = {Naqvi, Asjad},
   title = {Stata package ``arcplot''},
   url = {https://github.com/asjadnaqvi/stata-arcplot},
   version = {1.4},
   date = {2024-10-02}
}


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: an update}. University of Bern Social Sciences Working Papers No. 43. 

{p 4 8 2}Caceres, M. (2022). {browse "https://gtools.readthedocs.io/en/latest/":Gtools website}.


{title:Other packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.