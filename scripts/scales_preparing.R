# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

# Severity and emotional reaction scale
source("scripts/scale_severity.R")

# A priori screening belief
source("scripts/scale_apriori.R")

# READ SCALE
scales <- 
  c("materials/qualtrics/output/plain_text/scales/apriori_belief", 
    "materials/qualtrics/output/plain_text/scales/severity_emotion/partial") %>% 
  map(~dir(.x, ".txt", full.names = TRUE)) %>% unlist() %>% map(~readChar(.x, file.size(.x))) %>% 
  set_names(., 
            gsub(".*Block\\:([a-z_0-9]*).*", "\\1", .)) # Capture name of each scale
