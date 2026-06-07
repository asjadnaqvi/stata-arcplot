{smcl}
{* 07Jun2026}{...}
{hi:help arcplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-arcplot":arcplot v1.5 (GitHub)}}

{hline}


{title:arcplot}: is a Stata package for plotting flows as {browse "https://en.wikipedia.org/wiki/Arc_diagram":arc plots}.

{p 4 4 2}
The command draws flows between source and destination categories using arcs and aligned node bars. It is based on the
{browse "https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6":Arc plots} guide on Medium and supports weighted data, split layouts,
color gradients, and explicit graph sizing controls.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:arcplot} {it:numvar} {ifin} {weight}, {cmdab:f:rom}({it:var}) {cmdab:t:o}({it:var})
    {cmd:[} {cmd:gap}({it:num}) {cmd:format}({it:str}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:lw:idth}({it:str})
      {cmd:sort}({it:value}|{it:name}) {cmdab:spl:it}({it:varname}) {cmdab:splitsh:ift}({it:num}) {cmdab:boxw:idth}({it:str}) {cmdab:boxint:ensity}({it:num})
      {cmd:colorprop} {cmd:cuts}({it:num}) {cmd:propcolor}({it:str}) {cmd:offset}({it:num}) {cmd:aspect}({it:num}) {cmdab:xs:ize}({it:num}) {cmdab:ys:ize}({it:num})
      {cmdab:p:oints}({it:num}) {cmdab:noval:ues} {cmdab:valcond:ition}({it:num}) {cmd:options}({it:str})
      {cmdab:labs:ize}({it:str}) {cmdab:labc:olor}({it:str}) {cmdab:laba:ngle}({it:str}) {cmdab:labp:os}({it:str}) {cmdab:laboff:set}({it:num}) {cmdab:labg:ap}({it:str})
      {cmdab:vals:ize}({it:str}) {cmdab:valc:olor}({it:str}) {cmdab:vala:ngle}({it:str}) {cmdab:valp:os}({it:str}) {cmdab:valoff:set}({it:num}) {cmdab:valg:ap}({it:str}) {cmdab:*} {cmd:]}

{marker options}{title:Options}

{synoptset 24 tabbed}{...}

{marker required}{dlgtab:Required}

{p2coldent : {opt arcplot} numvar}The command requires a numeric variable that contains the flow values. Stata weights are allowed.{p_end}

{p2coldent : {opt f:rom(var)} {opt t:o(var)}}These are the source and destination variables. They can be string or labeled numeric variables.{p_end}

{marker display}{dlgtab:Display options}

{p2coldent : {opt gap(num)}}Gap between node groups as a percentage of total graph width. Default is {opt gap(1)}.{p_end}

{p2coldent : {opt format(str)}}Format used for the value labels. Default is {opt format(%7.2f)}.{p_end}

{p2coldent : {opt alpha(num)}}Transparency of the arcs. Default is {opt alpha(50)} for 50% opacity.{p_end}

{p2coldent : {opt sort(value|name)}}Sort node order by total flow value or alphabetically. Default is {opt sort(value)}.{p_end}

{p2coldent : {opt offset(num)}}Offset for the y-axis in percent of graph height. Default is {opt offset(0)}. This is useful if rotated labels are cut at the bottom.{p_end}

{p2coldent : {opt aspect(num)}}Control the graph aspect ratio. By default, standard arcplots use {opt aspect(0.5)} and split arcplots use {opt aspect(1)}.{p_end}

{p2coldent : {opt xs:ize(num)}, {opt ys:ize(num)}}Explicit graph width and height. Defaults are {opt xsize(2)} and {opt ysize(1)}. With {opt split()}, both default to 1.{p_end}

{p2coldent : {opt options(str)}}Pass standard graph options directly to the final {cmd:twoway} call. This is useful for options such as notes, captions, or graph region controls.{p_end}

{marker colors}{dlgtab:Colors and palette}

{p2coldent : {opt palette(str)}}Named color scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt colorprop}}Apply a proportional color gradient to the arcs based on their values. This splits flows into groups and shades each group within the source color.{p_end}

{p2coldent : {opt cuts(num)}}Number of color groups used by {opt colorprop}. Default is {opt cuts(10)}. Minimum allowed value is 3.{p_end}

{p2coldent : {opt propcolor(str)}}Starting color used for the {opt colorprop} gradient. Default is {opt propcolor(white)}.{p_end}

{p2coldent : {opt boxw:idth(str)}}Thickness of the node bars. Default is {opt boxw(2)}.{p_end}

{p2coldent : {opt boxint:ensity(num)}}Color intensity of the incoming side of the node bars. Default is {opt boxint(0.7)}. A value of 1 gives the same inflow and outflow colors.{p_end}

{p2coldent : {opt lw:idth(str)}}Outline width of the arcs. Default is {opt lw(none)} or no outlines.{p_end}

{p2coldent : {opt lc:olor(str)}}Outline color of the arcs. Default is {opt lc(black)}.{p_end}

{marker layout}{dlgtab:Layout options}

{p2coldent : {opt spl:it(varname)}}Binary split variable coded 0/1 that draws one split above and the other below the baseline. In this mode, node width is based on the maximum split total per node.{p_end}

{p2coldent : {opt splitsh:ift(num)}}Vertical displacement used for the two arc bundles under {opt split()}. Default is {opt splitshift(0.01)}.{p_end}

{p2coldent : {opt p:oints(num)}}Number of points used to evaluate the arc curves. Default is {opt points(100)}. Increase only when smoother arcs are needed.{p_end}

{marker labels}{dlgtab:Category labels}

{p2coldent : {opt labs:ize(str)}}Size of the category labels. Default is {opt labs(2)}.{p_end}

{p2coldent : {opt labc:olor(str)}}Color of the category labels. Default is {opt labc(black)}.{p_end}

{p2coldent : {opt laba:ngle(str)}}Angle of the category labels. Default is {opt laba(90)}.{p_end}

{p2coldent : {opt labg:ap(str)}}Gap of the category labels from the center of the node bars. Default is {opt labg(0)}.{p_end}

{p2coldent : {opt labp:os(str)}}Position of the category labels. Default is {opt labpos(6)}.{p_end}

{p2coldent : {opt laboff:set(num)}}Vertical displacement downward of category labels. Default is {opt laboff(0.02)}.{p_end}

{marker values}{dlgtab:Value labels}

{p2coldent : {opt noval:ues}}Do not display value labels on the arcs.{p_end}

{p2coldent : {opt valcond:ition(num)}}Only show value labels for values greater than or equal to the specified threshold. Default is {opt valcond(0)}.{p_end}

{p2coldent : {opt vals:ize(str)}}Size of the value labels. Default is {opt vals(1.2)}.{p_end}

{p2coldent : {opt valc:olor(str)}}Color of the value labels. Default is {opt valc(black)}.{p_end}

{p2coldent : {opt vala:ngle(str)}}Angle of the value labels. Default is {opt vala(90)}.{p_end}

{p2coldent : {opt valg:ap(str)}}Gap of the value labels from the center of the node bars. Default is {opt valg(0)}.{p_end}

{p2coldent : {opt valp:os(str)}}Position of the value labels. Default is {opt valpos(12)}.{p_end}

{p2coldent : {opt valoff:set(num)}}Vertical displacement upward of value labels. Default is {opt valoff(0.01)}.{p_end}

{marker twoway}{dlgtab:Twoway options}

{p2coldent : {opt *}}All other standard twoway options not elsewhere specified and not blocked by the program.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install gtools, replace}
{stata ssc install graphfunctions, replace}

{title:Examples}
See {browse "https://github.com/asjadnaqvi/stata-arcplot":GitHub} for examples.

{hline}

{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-arcplot/issues":GitHub} by opening a new issue.


{title:Package details}

Version      : {bf:arcplot} v1.5
This release : 07 Jun 2026
First release: 22 Jun 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-arcplot":GitHub}
Keywords     : Stata, graph, arc plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Citation guidelines}

See {browse "https://ideas.repec.org/c/boc/bocode/s459119.html"} for the official SSC citation.
Please note that the GitHub version might be newer than the SSC version.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: an update}. University of Bern Social Sciences Working Papers No. 43.

{p 4 8 2}Caceres, M. (2022). {browse "https://gtools.readthedocs.io/en/latest/":Gtools website}.


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions},
  {helpb geoboundary}, {helpb geoflow}, {helpb joyplot}, {helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot},
  {helpb sunburst}, {helpb ternary}, {helpb tidytuesday}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}, {helpb vcontrol}

Visit {browse "https://github.com/asjadnaqvi":GitHub} for further details.