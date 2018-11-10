# If selenium is not working try with the following lines, and (maybe) installing Java.
# sudo apt install phantomjs
# binman::rm_platform("phantomjs")
# wdman::selenium(retcommand = TRUE)

# RUN SELENIUM USING DOCKER
# http://ropensci.github.io/RSelenium/articles/docker.html

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse)


# Resources ---------------------------------------------------------------
source("functions/get2survey.R")
source("functions/remove_blocks_qualtrics.R")
source("functions/remove_surveyflow_elements.R")
source("functions/go_gorka_04.R")
source("functions/UBER_IMPORT2QUALTRICS_miro.R")

# Close any docker session running (run in terminal)
# docker stop $(docker ps -q)
# docker ps
# sudo docker pull selenium/standalone-firefox-debug:2.53.0
# sudo docker run -d -p 4445:4444 -p 5901:5900 selenium/standalone-firefox-debug:2.53.0
# sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.ID}}'
# ALSO MAKE SURE YOU HAVE VINAGER (VNC CLIENT)
# sudo apt-get update
# sudo apt-get install vinagre


# To remove blocks
# remove_blocks_qualtrics(start_on = 1, survey_type = "miro")
# remDr$refresh()
# To remove survey flow elements
# remove_surveyflow_elements(start_on = 3)
# remDr$refresh()

# Selenium ----------------------------------------------------------------

# Create browser instance (this will pop-up a window)
remDr <- remoteDriver(port = 4445L)
remDr$open(silent = TRUE)

# rD = RSelenium::rsDriver(remoteServerAddr = "172.17.0.2", port = 4445L)
# rD = RSelenium::rsDriver(browser = "chrome")
# remDr <- rD[["client"]]

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

# # To remove blocks (use start_on = 1, or start_on = 2)
remove_blocks_qualtrics(start_on = 35, survey_type = "miro")
remDr$refresh()

# Move ED blocks ---------------------------------------------------------
# Get to Survey Flow
webElem <- remDr$findElement("css selector", "#surveyflow")
webElem$clickElement()

ed_blocks <- remDr$findElements("class name", "Move")

# If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
while (length(ed_blocks) == 0) {
  # Get all survey flow blocks.
  ed_blocks <- remDr$findElements("class name", "Move")
}

# Remove first element (first element is not any of the survey flow elements)
ed_blocks <- ed_blocks[-1]

# Set counter to 0. This keeps track of the last block moved.
.GlobalEnv$safe_counter <- 170

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
  file.path(getwd(), "materials/qualtrics/output/plain_text/exp_design/experiment_design.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Pilot warning ------------------------------------------------------------

file_paths <- 
  file.path(getwd(), "materials/qualtrics/output/plain_text/pilot_warning/pilot_warning.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Consent form ------------------------------------------------------------

file_paths <- 
  paste0(getwd(), "/materials/qualtrics/output/plain_text/consent_form/consent_form.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Sociodemographics -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "/materials/qualtrics/output/plain_text/scales/sociodemographic_scale/sociodemographic_scale.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# A priori screening belief -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "materials/qualtrics/output/plain_text/scales/a_priori_screening_belief/a_priori_screening_belief.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Screening block -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "/materials/qualtrics/output/plain_text/screening_blocks/complete/screenings_blocks.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Scales instructions -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "/materials/qualtrics/output/plain_text/scales_instructions/scales_instructions.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Import scales --------------------------------------------------

file_paths <- 
  "materials/qualtrics/output/plain_text/scales" %>% 
  dir(., full.names = TRUE) %>% 
  map(~dir(.x, pattern = ".txt", full.names = TRUE)) %>% 
  unlist()

# remove sociodemographic scale
file_paths <- 
  file_paths[!str_detect(file_paths, "sociodemo")]
# remove a priori screening belief scale
file_paths <- 
  file_paths[!str_detect(file_paths, "a_priori_screening_belief")]

# full absolute paths
file_paths <- file.path(getwd(), file_paths)

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# Previous experience -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "materials/qualtrics/output/plain_text/previous_experience/previous_experience.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)


# Comments -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "materials/qualtrics/output/plain_text/comments/comments.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)

# survey effort -----------------------------------------------------------

file_paths <- 
  file.path(getwd(), "materials/qualtrics/output/plain_text/survey_effort/survey_effort.txt")

# Iteration counter
Q_counter <- 0

# UPLOAD!
UBER_IMPORT2QUALTRICS_miro(file_paths)
