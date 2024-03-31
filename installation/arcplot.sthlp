{smcl}
{* 31Mar2024}{...}
{hi:help arcplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-arcplot":arcplot v1.3 (GitHub)}}

{hline}

{title:arcplot}: A Stata package for Arc plots. 

The command is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6":Arc plots} guide on Medium.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:arcplot} {it:var} {ifin}, {cmdab:f:rom}({it:var}) {cmdab:t:o}({it:var}) 
                {cmd:[} {cmd:gap}({it:num}) {cmdab:arcp:oints}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmd:format}({it:str}) {cmdab:lc:olor}({it:str}) {cmdab:lw:idth}({it:num}) 
                  {cmd:sort({it:value}|{it:name})} {cmdab:boxw:idth}({it:str}) {cmdab:boxint:ensity}({it:num}) {cmd:offset}({it:num})  
                  {cmdab:labg:ap}({it:str}) {cmdab:laba:ngle}({it:str}) {cmdab:labs:ize}({it:num}) {cmdab:labc:olor}({it:str}) {cmdab:labp:os}({it:str}) 
                  {cmdab:valg:ap}({it:str}) {cmdab:vala:ngle}({it:str}) {cmdab:vals:ize}({it:num}) {cmdab:valc:olor}({it:str}) {cmdab:valp:os}({it:str}) {cmdab:valcond:ition}({it:num})
                  {cmd:aspect}({it:num}) {cmd:xsize}({it:num}) {cmd:ysize}({it:num}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) 
                {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt arcplot var}}The command requires a numeric {it:var} variable.{p_end}

{p2coldent : {opt f:rom(var)} {opt t:o(var)}}These are the source and destination variables.{p_end}

{p2coldent : {opt gap(num)}}Gap between the horizontal bars. Default value is {opt gap(2)} or 2% of total width.{p_end}

{p2coldent : {opt alpha(num)}}Transparency of the arcs. The default value is {opt alpha(50)} for 50%.{p_end}

{p2coldent : {opt sort(value|name)}}Sort order of the boxes. Default is {sort(value)} which results in numerically sorted boxes and arcs. 
The option {sort(name)} will be alphabetically organized.{p_end}

{p2coldent : {opt boxwid:th(num)}}Thickness of the boxes. Default is {opt boxw(1.6)}.{p_end}

{p2coldent : {opt boxint:ensity(num)}}Color intensity of the box indicating outgoing flows. Default is {opt boxint(0.7)}.
A value of 1 will result in same inflow and outflow colors.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt lc:olor(str)}}The outline color of the area fill. Default is {opt lc(black)}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the area fill. Default is {opt lw(none)}. Therefore by default the arcs will have no outlines.{p_end}

{p2coldent : {opt arcp:oints(num)}}Number of arc points. Higher values will result in smoother arcs. Default value is {opt arcp(100)}.{p_end}

{p2coldent : {opt labs:ize(str)}}The size of the category labels. The default value is {opt labs(2)}.{p_end}

{p2coldent : {opt labc:olor(str)}}The color of the category labels. The default value is {opt labc(black)}.{p_end}

{p2coldent : {opt laba:ngle(str)}}The angle of the category labels. The default value is {opt laba(0)} for horizontal.{p_end}

{p2coldent : {opt labg:ap(str)}}The gap of the category labels. The default value is {opt labg(0.5)}.{p_end}

{p2coldent : {opt labp:os(str)}}The position of the category labels. The default value is {opt labpos(6)}.{p_end}

{p2coldent : {opt offset(num)}}Offset for the y-axis. Default is {opt offset(0)} or 0% of graph height.
Highly useful if labels are rotated and a gap at the bottom is required to fully display them.{p_end}


{p2coldent : {opt format(str)}}The format of the value labels. Default is {opt format(%15.0fc)}.{p_end}

{p2coldent : {opt valcond:ition(num)}}The condition to label the values is >= {it:num}. The default value is {opt valcond(0)}.{p_end}

{p2coldent : {opt vals:ize(str)}}The size of the value labels. The default value is {opt vals(1.2)}.{p_end}

{p2coldent : {opt valc:olor(str)}}The color of the value labels. The default value is {opt valc(black)}.{p_end}

{p2coldent : {opt vala:ngle(str)}}The angle of the value labels. The default value is {opt vala(90)} for 90 degrees.{p_end}

{p2coldent : {opt valg:ap(str)}}The gap of the value labels from the horizontal bars. The default value is {opt valg(2)}.{p_end}

{p2coldent : {opt valp:os(str)}}The position of the category labels. The default value is {opt valpos(12)}.{p_end}


{p2coldent : {opt aspect(num)}}Aspect ratio of the graph. The default is set at {opt aspect(0.5)} to maintain the 2:1 graph ratio 
with default values. If gaps are added, this might need adjustment.{p_end}

{p2coldent : {opt title}, {opt subtitle}, {opt note}}These are standard twoway graph options.{p_end}

{p2coldent : {opt xsize()}, {opt ysize()}}These are standard twoway graph options for changing the dimensions of the graphs.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{p2coldent : {opt name(string)}}Assign a name to the graph.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{cmd:arcplot} requires {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palettes} package (Jann 2018, 2022):

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

and {browse "https://gtools.readthedocs.io/en/latest/":gtools} package to faster reshaping:

{stata ssc install gtools, replace}


{title:Examples}

Check {browse "https://github.com/asjadnaqvi/arcplot":GitHub} for examples.


{hline}

{title:Package details}

Version      : {bf:arcplot} v1.3
This release : 31 Mar 2024
First release: 22 Jun 2022
Repository   : {browse "https://github.com/asjadnaqvi/arcplot":GitHub}
Keywords     : Stata, graph, arc plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-arcplot/issues":GitHub} by opening a new issue.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: an update}. University of Bern Social Sciences Working Papers No. 43. 

{p 4 8 2}Caceres, M. (2022). {browse "https://gtools.readthedocs.io/en/latest/":Gtools website}.


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}