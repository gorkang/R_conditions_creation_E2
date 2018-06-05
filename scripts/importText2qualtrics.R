# sudo apt install phantomjs
# binman::rm_platform("phantomjs")
# wdman::selenium(retcommand = TRUE)

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse, naptime)

# Re-sources --------------------------------------------------------------
source("functions/sign2qualtrics.R")
source("functions/get2survey.R")

# Get to survey -------------------------------------------------------------------

# Create browser instance
rD = RSelenium::rsDriver(browser = "chrome")
remDr <- rD[["client"]]

# Survey link
survey_link <- "https://eu.qualtrics.com/ControlPanel/?ClientAction=ChangePage&Section=EditSection&SubSection=Blocks&SurveyID=SV_cOr1TTOUoa1Uc9T"
# Qualtrics password
pass   <- .rs.askForPassword("Please enter Qualtrics password")

# Get to survey
get2survey(survey_link)
get2survey(survey_link)

# Start importing things --------------------------------------------------
source("functions/UBER_IMPORT2QUALTRICS.R")

# Dir with ED blocks
full_path <- 
  "/home/niki/Desktop/test_qualtrics/"
  # "/home/niki/midgard/fondecyt/gorka/2017 - Gorka - Fondecyt/Experimentos/Experimento 1/R_condition_creation_GITHUB/R_conditions_creation/materials/qualtrics/output/plain_text/embedded_data_blocks/"

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(full_path)