{smcl}
{* 22June2022}{...}
{hi:help arcplot}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-arcplot":arcplot v1.0 (GitHub)}}

{hline}

{title:arcplot}: A Stata package for arc plots. 

The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-arc-plots-eb87015510e6":Arc plots}.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:arcplot} {it:value} {ifin}, {cmdab:f:rom}({it:str var}) {cmdab:t:o}({it:str var}) 
                {cmd:[} {cmd:gap}({it:num}) {cmdab:arcp:oints}({it:num}) {cmd:palette}({it:str}) {cmd:alpha}({it:num}) {cmd:format}({it:str})
                {cmdab:lw:idth}({it:num}) {cmdab:lc:olor}({it:str}) {cmdab:vallabg:ap}({it:str}) {cmdab:vallaba:ngle}({it:str}) {cmdab:vallabs:ize}({it:num}) {cmdab:vallabc:olor}({it:str}) 
                {cmd:xsize}({it:num}) {cmd:ysize}({it:num}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt arcplot value}}The command requires a numeric variable variable that contains the values.{p_end}

{p2coldent : {opt f:rom(str var)}}This is the source or starting variable. This should be a string variable.{p_end}

{p2coldent : {opt t:o(str var)}}This is the destination or ending variable. This should be a string variable.{p_end}

{p2coldent : {opt gap(num)}}Gap between the horizontal bars. Default value is {it:0.03} or 3% of value total.{p_end}

{p2coldent : {opt arcp:oints(num)}}Number of arc sample points. Higher value equals smoother arcs. Default value is {it:50}.{p_end}

{p2coldent : {opt alpha(num)}}Transparency of the arcs. The default value is {it:50} for 50%.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette CET C1:{it:CET C1}}.{p_end}

{p2coldent : {opt lc:olor(str)}}The outline color of the area fill. Default is {it:black}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the area fill. Default is {it:none}.{p_end}

{p2coldent : {opt vallabg:ap(str)}}The gap of the value labels from the horizontal bars. The default value is {it:2}.{p_end}

{p2coldent : {opt vallaba:ngle(str)}}The angle of the value labels. The default value is {it:90} for 90 degrees.{p_end}

{p2coldent : {opt vallabs:ize(num)}}The size of the value labels. The default value is {it:1.2}.{p_end}

{p2coldent : {opt vallabc:olor(str)}}The color of the value labels. The default value is {it:black}.{p_end}

{p2coldent : {opt labs:ize(num)}}The size of the category labels. The default value is {it:2}.{p_end}

{p2coldent : {opt labc:olor(num)}}The color of the category labels. The default value is {it:black}.{p_end}

{p2coldent : {opt title}, {opt subtitle}, {opt note}}These are standard twoway graph options.{p_end}

{p2coldent : {opt xsize(value)}, {opt ysize(value)}}These are standard twoway graph options for changing the dimensions of the graphs.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{p2coldent : {opt name(string)}}Assign a name to the graph.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018) is required for {cmd:arcplot}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

It's too much work to write this so check {browse "https://github.com/asjadnaqvi/arcplot":GitHub}. Coming here soon...



{hline}

{title:Version history}


- {bf:1.0} : First version.



{title:Package details}

Version      : {bf:arcplot} v1.0
This release : 21 Aug 2022
First release: 21 Aug 2021
Repository   : {browse "https://github.com/asjadnaqvi/arcplot":GitHub}
Keywords     : Stata, graph, arc plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Acknowledgements}



{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-arcplot/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


