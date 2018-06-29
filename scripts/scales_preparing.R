# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

# Severity and emotional reaction scale
source("scripts/scale_severity.R")

# A priori screening belief
source("scripts/scale_apriori.R")
