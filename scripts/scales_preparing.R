# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

question_size = "22"
choice_size = "15"

# Severity and emotional reaction scale ##########
source("scripts/scale_severity.R")

# A priori screening belief ######################
source("scripts/scale_apriori.R")

# Numeracy #######################################
source("scripts/scale_numeracy.R")

# Big five #######################################
source("scripts/scale_big_five.R")

# crt-7 (single choice) #######################################
source("scripts/scale_crt_7.R")

# General decision-making style ##################
source("scripts/scale_gdms.R")

# subjective numeracy scale ##################
source("scripts/scale_sns.R")

# risk propensity scale ##################
source("scripts/scale_risk_propensity.R")

# probabilistic reasoning scale ##################
source("scripts/scale_probabilistic_reasoning.R")

# beck anxiety inventory ##################
source("scripts/scale_beck_anxiety.R")

# risk avoidance scale ##################
source("scripts/scale_risk_avoidance.R")

# short mathematics anxiety rating scale ##################
source("scripts/scale_mathematics_anxiety.R")

# need for cognition ##################
source("scripts/scale_need_for_cognition.R")

# PRINT SCALES (BOOK)
# this vector with paths set the scales to be printed
scales2print <- c("materials/qualtrics/output/plain_text/scales/apriori_belief", 
                  "materials/qualtrics/output/plain_text/scales/severity_emotion/partial",
                  "materials/qualtrics/output/plain_text/scales/numeracy/",
                  "materials/qualtrics/output/plain_text/scales/crt_7/",
                  "materials/qualtrics/output/plain_text/scales/gdms/",
                  "materials/qualtrics/output/plain_text/scales/subjective_numeracy//") 

source("scripts/print_scales.R")