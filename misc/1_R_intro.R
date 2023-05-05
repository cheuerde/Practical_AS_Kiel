## ---- include = FALSE---------------------------------------------------------
library(pacman)
p_load(data.table, ggplot2, rrBLUP, lattice, brms, knitr, plotly, prettydoc, lubridate, DT, lsmeans, car, htmltools, pander, tidyverse)
interactive = FALSE


## ----global_options, include=FALSE--------------------------------------------

######################
### General Config ###
######################

knitr::opts_chunk$set(fig.width=12, fig.height=8, fig.path='Figs/',
		      echo=FALSE, warning=FALSE, message=FALSE, include = FALSE, eval = TRUE)

fontSize = 15



## ----assign_varialbes, include = TRUE, echo = TRUE----------------------------

############################################
### Assigning and manipulating variables ###
############################################

x = 5
print(x)

# just givng the variable name, will print it to the REPL by default
x

# assign value from one variable to the next
y = x

# object did not trigger a copy of "x", rather y "points" to x
print(y)

# change the value of x
x = 3

print(x)

# at the moment we changed the value of "x", a copy of the old "x" was triggered and assigned to "y"
print(y)



