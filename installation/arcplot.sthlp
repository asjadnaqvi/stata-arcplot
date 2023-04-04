{smcl}
{* 16Feb2023}{...}
{hi:help arcplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-arcplot":arcplot v1.2 (GitHub)}}

{hline}

{title:arcplot}: A Stata package for arc plots. 

The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6":Arc plots}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:arcplot} {it:var} {ifin}, {cmdab:f:rom}({it:var}) {cmdab:t:o}({it:var}) 
                {cmd:[} {cmd:gap}({it:num}) {cmdab:arcp:oints}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmd:format}({it:str}) {cmdab:lc:olor}({it:str}) {cmdab:lw:idth}({it:num}) 
                     {cmdab:labg:ap}({it:str})    {cmdab:laba:ngle}({it:str})    {cmdab:labs:ize}({it:num})    {cmdab:labc:olor}({it:str})     {cmdab:labp:os}({it:str}) 
                  {cmdab:vallabg:ap}({it:str}) {cmdab:vallaba:ngle}({it:str}) {cmdab:vallabs:ize}({it:num}) {cmdab:vallabc:olor}({it:str})  {cmdab:vallabp:os}({it:str}) {cmdab:valcond:ition}({it:num})
                  {cmd:xsize}({it:num}) {cmd:ysize}({it:num}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt arcplot var}}The command requires a numeric variable that contains the values that need to be plotted.{p_end}

{p2coldent : {opt f:rom(str)} {opt t:o(str)}}These are the source and destination variables.{p_end}

{p2coldent : {opt gap(num)}}Gap between the horizontal bars. Default value is {it:0.03} or 3% of value total.{p_end}

{p2coldent : {opt arcp:oints(num)}}Number of arc sample points. Higher value equals smoother arcs. Default value is {it:50}.{p_end}

{p2coldent : {opt alpha(num)}}Transparency of the arcs. The default value is {it:50} for 50%.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette CET C1:{it:CET C1}}.{p_end}

{p2coldent : {opt lc:olor(str)}}The outline color of the area fill. Default is {it:black}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the area fill. Default is {it:none}.{p_end}


{p2coldent : {opt labs:ize(str)}}The size of the category labels. The default value is {it:2}.{p_end}

{p2coldent : {opt labc:olor(str)}}The color of the category labels. The default value is {it:black}.{p_end}

{p2coldent : {opt laba:ngle(str)}}The angle of the category labels. The default value is {it:0} for horizontal.{p_end}

{p2coldent : {opt labg:ap(str)}}The gap of the category labels. The default value is {it:0.5}.{p_end}

{p2coldent : {opt labp:os(str)}}The position of the category labels. The default value is {opt labpos(6)}.{p_end}



{p2coldent : {opt valcond:ition(num)}}The condition to label the values is >= {it:num}. The default value is {opt valcond(0)}.{p_end}

{p2coldent : {opt vallabs:ize(str)}}The size of the value labels. The default value is {it:1.2}.{p_end}

{p2coldent : {opt vallabc:olor(str)}}The color of the value labels. The default value is {it:black}.{p_end}

{p2coldent : {opt vallaba:ngle(str)}}The angle of the value labels. The default value is {it:90} for 90 degrees.{p_end}

{p2coldent : {opt vallabg:ap(str)}}The gap of the value labels from the horizontal bars. The default value is {it:2}.{p_end}

{p2coldent : {opt vallabp:os(str)}}The position of the category labels. The default value is {opt vallabpos(12)}.{p_end}


{p2coldent : {opt title}, {opt subtitle}, {opt note}}These are standard twoway graph options.{p_end}

{p2coldent : {opt xsize(value)}, {opt ysize(value)}}These are standard twoway graph options for changing the dimensions of the graphs.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{p2coldent : {opt name(string)}}Assign a name to the graph.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{cmd:arcplot} requires {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palettes} package (Jann 2018, 2022):

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

and {browse "https://gtools.readthedocs.io/en/latest/":gtools} package:

{stata ssc install gtools, replace}

Even if you have these installed, it is highly recommended to check for their updates:
{stata ado update, update}

{title:Examples}

Check {browse "https://github.com/asjadnaqvi/arcplot":GitHub} for examples.



{hline}

{title:Version history}

- {bf:1.2} : Major speed improvement by flattening the code.
- {bf:1.1} : Various bug fixes. Improvements to label controls. Gtools added for faster reshaping.
- {bf:1.0} : First version.


{title:Package details}

Version      : {bf:arcplot} v1.2
This release : 16 Feb 2023
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
    {helpb alluvial}, {helpb circlebar}, {helpb spider}, {helpb treemap}, {helpb circlepack}, {helpb sankey}, {helpb treecluster}, {helpb sunburst}
	{helpb marimekko}, {helpb bimap}, {helpb joyplot}, {helpb streamplot}, {helpb delaunay}, {helpb clipgeo}, {helpb schemepack}