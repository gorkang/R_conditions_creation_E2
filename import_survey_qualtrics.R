# If selenium is not working try with the following lines, and (maybe) installing Java.
# sudo apt install phantomjs
# binman::rm_platform("phantomjs")
# wdman::selenium(retcommand = TRUE)

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse)