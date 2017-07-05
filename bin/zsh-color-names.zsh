#!/bin/zsh -f
autoload -U colors
colors
print "
ZSH Color definitions:
\e[1mprompt simple\e[0m  [\e[1m<\e[0mcolor1\e[1m>\e[0m[\e[1m<\e[0mcolor2\e[1m>\e[0m[\e[1m<\e[0mcolor3\e[1m>\e[0m[\e[1m<\e[0mstring1\e[1m>\e[0m[\e[1m<\e[0mstring2\e[1m>\e[0m[\e[1m<\e[0mstring3\e[1m>\e[0m]]]]]]
Supply up to three \e[1mcolors\e[0m and then up to three alternate static \e[1mprompt strings \e[0m.
\e[1mcolor1\e[0m is the local prompt color: \e[1mzsh-% \e[0m   		color1=default
\e[1mcolor2\e[0m is the remote prompt color: \e[31m$HOST:r:r-%\e[0m  		color2=red
\e[1mcolor3\e[0m is the screensession prompt color: \e[1mScreen-% \e[0m  	color3=default

Allowed \e[1mcolorN\e[0m options include:           
\e[1mdefault\e[0m, \e[0m black\e[0m, \e[31m red\e[0m, \e[32m green\e[0m, \e[33m yellow\e[0m, \e[34m blue\e[0m, \e[35m magenta\e[0m, \e[36m cyan\e[0m, \e[0m white\e[0m  
\e[1mstringN\e[0m can be any (non-dynamic) text string or prompt special characters (eg: %m)
" 
