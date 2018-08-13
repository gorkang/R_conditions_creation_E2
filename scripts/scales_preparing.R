# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

question_size = "22"
choice_size = "16"

# Severity and emotional reaction scale
source("scripts/scale_severity.R")

# A priori screening belief
source("scripts/scale_apriori.R")

# Numeracy
source("scripts/scale_numeracy.R")

# Big five
source("scripts/scale_big_five.R")

# Big five
source("scripts/scale_crt_7.R")

# General decision-making style
source("scripts/scale_gdms.R")

# General decision-making style ##################
source("scripts/scale_sns.R")


# PRINT SCALES (BOOK)
# this vector with paths set the scales to be printed
scales2print <- c("materials/qualtrics/output/plain_text/scales/apriori_belief", 
                  "materials/qualtrics/output/plain_text/scales/severity_emotion/partial",
                  "materials/qualtrics/output/plain_text/scales/numeracy/",
                  "materials/qualtrics/output/plain_text/scales/crt_7/",
                  "materials/qualtrics/output/plain_text/scales/gdms/",
                  "materials/qualtrics/output/plain_text/scales/subjective_numeracy//") 

source("scripts/print_scales.R")