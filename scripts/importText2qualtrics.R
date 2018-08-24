# sudo apt install phantomjs
# binman::rm_platform("phantomjs")
# wdman::selenium(retcommand = TRUE)

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse, naptime)

# Re-sources --------------------------------------------------------------
source("functions/get2survey.R")
source("functions/UBER_IMPORT2QUALTRICS.R")

# Get to survey -------------------------------------------------------------------

# Create browser instance
rD = RSelenium::rsDriver(browser = "chrome")
remDr <- rD[["client"]]

# Survey link (why did the url change?)
survey_link <- "https://qsharingeu.eu.qualtrics.com/ControlPanel/?ClientAction=ChangePage&Section=EditSection&SubSection=Blocks&SurveyID=SV_eKICbArg9lFKL9b"
# survey_link <- "https://qsharingeu.eu.qualtrics.com/ControlPanel/?ClientAction=EditSurvey&Section=SV_eKICbArg9lFKL9b&SubSection=&SubSubSection=&PageActionOptions=&TransactionID=4&Repeatable=0"
# survey_link <- "https://eu.qualtrics.com/ControlPanel/?ClientAction=ChangePage&Section=EditSection&SubSection=Blocks&SurveyID=SV_cOr1TTOUoa1Uc9T"

# Qualtrics password
pass   <- .rs.askForPassword("Please enter Qualtrics password")

# Get to survey (twice: first to get into qualtrics, then to get into survey)
get2survey(survey_link)
get2survey(survey_link)

# Start importing things --------------------------------------------------

# Dir with ED blocks
full_path <- 
  "/home/niki/midgard/fondecyt/gorka/2017 - Gorka - Fondecyt/Experimentos/Experimento 1/R_condition_creation_GITHUB/R_conditions_creation/materials/qualtrics/output/plain_text/embedded_data_blocks"

file_paths <- 
  full_path %>% dir(., ".txt", full.names = TRUE)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)


# Remove dummy blocks created when importing ED blocks -------------------

# get blocks selectors 
selectors <- remDr$findElements("css selector", '.StandardBlock')

for (i in seq(selectors)) {
  # i <- 2
  
  # Get "Block Options" button elements (they change after deleting a block, so it has to be done on every iteration)
  elements <- remDr$findElements("class name", "block-options-button")
  
  # If the buttons are not loaded yet the list will be of lenght 0. Try again untill is not 0.
  while(length(elements) == 0) {
    elements <- remDr$findElements("class name", "block-options-button")
  } 
  
  message(paste0("Deleting block no. ", length(elements)))
  
  # Always delete the first element (they change on every interation)
  webElem <- elements[[1]]
  webElem$clickElement()
  
  # Select "Delete Block..."
  webElem <- remDr$findElement(using = 'css selector', value = "#QMenu > div > div > ul > li:nth-child(17) > a")
  webElem$clickElement()
  
  # Confirm. Select "Delete"
  webElem <- remDr$findElement(using = 'css selector', value = "#ConfirmDeleteButton > span:nth-child(2)")
  webElem$clickElement()
  
  Sys.sleep(2) # give it time
  
}



# Consent form ------------------------------------------------------------

file_paths <- 
  paste0(getwd(), "/materials/qualtrics/output/plain_text/consent_form/consent_form.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)


# Comprehension -----------------------------------------------------------

file_paths <- 
  paste0(getwd(), "/materials/qualtrics/output/plain_text/scales/sociodemographic_scale/sociodemographic_scale.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)

# Screening block -----------------------------------------------------------

file_paths <- 
  paste0(getwd(), "/materials/qualtrics/output/plain_text/screening_blocks/complete/screenings_blocks.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)


# Import scales --------------------------------------------------

file_paths <- 
  "/materials/qualtrics/output/plain_text/scales" %>% 
  dir(., full.names = TRUE) %>% 
  map(~dir(.x, pattern = ".txt", full.names = TRUE)) %>% 
  unlist()

# remove sociodemographic scale
file_paths <- 
  file_paths[!str_detect(file_paths, "sociodemo")]

# full absolute paths
file_paths <- file.path(getwd(), file_paths)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)

# Comments -----------------------------------------------------------

file_paths <- 
  paste0(getwd(), "/materials/qualtrics/output/plain_text/comments/comments.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS(file_paths)
