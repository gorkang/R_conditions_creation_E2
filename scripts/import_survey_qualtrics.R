# COG SCALES RANDOMIZER N20
# PER SCALES RANDOMIZER N27

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse)

# Resources ---------------------------------------------------------------
source("functions/get2survey.R")
source("functions/remove_blocks_qualtrics.R")
source("functions/remove_surveyflow_elements.R")
source("functions/go_gorka_04.R")
source("functions/UBER_IMPORT2QUALTRICS_miro.R")

# Start docker session ----------------------------------------------------

# Check docker containers
system('docker ps -q') 
# Kill all containers
system('docker stop $(docker ps -q)') # MATALOS todos
# Get chrome image (to use VNC use debug)
system('docker pull selenium/standalone-chrome-debug') 
# Run docker session. Map home directory to download docker container
system('docker run -d -v /home:/home/seluser/Downloads -P selenium/standalone-chrome-debug')
# Get important data about ports
system('docker ps')

# This is the path to materials folder within docker container
selenium_path <- "/home/seluser/Downloads/nicolas/asgard/fondecyt/gorka/2017 - Gorka - Fondecyt/Experimentos/Experimento 1/R_condition_creation_GITHUB/R_conditions_creation"

# To remove blocks
# remove_blocks_qualtrics(start_on = 1, survey_type = "miro")
# remDr$refresh()
# To remove survey flow elements
# remove_surveyflow_elements(start_on = 3)
# remDr$refresh()

# Selenium ----------------------------------------------------------------

# Create browser instance. This should be reflected in the VNC session
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 32769, browserName = "chrome")
remDr$open()

# Get to GORKA 4 --------------------------------------------------
# URL to login website
survey_link <- "https://login.qualtrics.com/login?_ga=2.25607227.743887377.1535235685-1311002066.1535235685"

# Qualtrics password
pass   <- .rs.askForPassword("Please enter Qualtrics password")

# Get to qualtrics
get2survey(survey_link)

# Gorka_04
go_gorka_04()

# Import Embedded data blocks --------------------------------------------------

# Dir with ED blocks
full_path <- 
  "materials/qualtrics/output/plain_text/embedded_data_blocks"

file_paths <- 
  full_path %>% dir(., ".txt", full.names = TRUE) %>% file.path(getwd(), .)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Move ED blocks ---------------------------------------------------------
# Get to Survey Flow
webElem <- remDr$findElement("css selector", "#surveyflow")
webElem$clickElement()

# Get blocks
ed_blocks <- remDr$findElements("class name", "Move")

# If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
while (length(ed_blocks) == 0) {
  # Get all survey flow blocks.
  ed_blocks <- remDr$findElements("class name", "Move")
}

# Remove first element (first element is not any of the survey flow elements)
ed_blocks <- ed_blocks[-1]

# Set counter to 0. This keeps track of the last block moved.
.GlobalEnv$safe_counter <- 0

while (.GlobalEnv$safe_counter != length(ed_blocks)) {
  
  .GlobalEnv$safe_counter <- .GlobalEnv$safe_counter + 1
  remDr$refresh()
  
  # Get to Survey Flow (if is not possible continue running the code)
  try(expr = {
    webElem <- remDr$findElement("css selector", "#surveyflow")
    webElem$clickElement()
  }, silent = TRUE)
  
  for (i in seq(from = .GlobalEnv$safe_counter, to = length(ed_blocks))) {
    # i <- 1
    
    # Progress message
    message(paste0("Moving block no. ", i, " out of ", length(ed_blocks)-3))
    
    # Get survey flow elements
    blocks <- remDr$findElements("class name", "Move")
    
    # If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
    while (length(blocks) == 0) {
      blocks <- remDr$findElements("class name", "Move")
      blocks <- blocks[-1]
    }
    
    # Identify block to move and randomizer "Add a new element here" element
    webElem1 <- blocks[[i+34]] # Block to move
    webElem2 <- remDr$findElement("css selector", "#Flow > div:nth-child(1) > div > div > div:nth-child(39) > div > div.FlowElement.DragScroll > div > div.ViewContainer.Type_SpecialChildElement > div > div.ElementView > div > div.DragScroll > div > div > a > span.add-element-label")
    
    # Move block to randomizer
    remDr$mouseMoveToLocation(webElement = webElem1)
    remDr$buttondown()
    remDr$mouseMoveToLocation(webElement = webElem2)
    remDr$buttonup()
    
    Sys.sleep(1)
    
    # Do batches of 15 blocks. after each batch save the survey flow and start again
    if (i == 10 + .GlobalEnv$safe_counter) {
      Sys.sleep(2)
      
      # Save Survey Flow
      webElem <- remDr$findElement("class name", "RightButtons")
      webElem$clickElement()
      .GlobalEnv$safe_counter <- i
      
      message(paste0("*********************\nCounter updated to ", .GlobalEnv$safe_counter))
      
      break
    }
  }
}

# Experiment description  ------------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/exp_design/experiment_design.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)


# Pilot warning ------------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/pilot_warning/pilot_warning.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Consent form ------------------------------------------------------------

file_paths <- 
  paste0(selenium_path, "/materials/qualtrics/output/plain_text/consent_form/consent_form.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Sociodemographics -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "/materials/qualtrics/output/plain_text/scales/sociodemographic_scale/sociodemographic_scale.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# A priori screening belief -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/scales/a_priori_screening_belief/a_priori_screening_belief.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Screening block -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "/materials/qualtrics/output/plain_text/screening_blocks/complete/screenings_blocks.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Scales instructions -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "/materials/qualtrics/output/plain_text/scales_instructions/scales_instructions.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Cognitive scales INSTRUCTIONS --------------------------------------------------

file_paths <- 
  file.path(selenium_path, "/materials/qualtrics/output/plain_text/scales_instructions/cog_title.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Import COGNITIVE scales --------------------------------------------------

# Cognitive scales 
cog_scales <- 
  read_csv("materials/Scales/scale_names.csv") %>% 
  filter(per_cog == "cog") %>% select(long_name) %>% 
    pull() %>% paste0("materials/qualtrics/output/plain_text/scales/", .)

cog_scales_path <- 
  cog_scales %>% 
  map(~dir(.x, pattern = ".txt", full.names = TRUE)) %>% 
  unlist()

file_paths <- cog_scales_path

# full absolute paths
file_paths <- file.path(selenium_path, file_paths)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)


# Personality scales INSTRUCTIONS --------------------------------------------------

file_paths <- 
  file.path(selenium_path, "/materials/qualtrics/output/plain_text/scales_instructions/pers_title.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Personality scales -------------------------------------------------------------- 

per_scales <- 
  read_csv("materials/Scales/scale_names.csv") %>% 
  filter(per_cog == "per") %>% select(long_name) %>% 
  pull() %>% paste0("materials/qualtrics/output/plain_text/scales/", .)

per_scales_path <- 
  per_scales %>% 
  map(~dir(.x, pattern = ".txt", full.names = TRUE)) %>% 
  unlist()

file_paths <- per_scales_path

# full absolute paths
file_paths <- file.path(selenium_path, file_paths)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Previous experience -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/previous_experience/previous_experience.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)


# Comments -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/comments/comments.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# survey effort -----------------------------------------------------------

file_paths <- 
  file.path(selenium_path, "materials/qualtrics/output/plain_text/survey_effort/survey_effort.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)
