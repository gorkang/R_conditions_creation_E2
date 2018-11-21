
# In case selenium is not working.
# sudo apt install phantomjs
# binman::rm_platform("phantomjs")
# wdman::selenium(retcommand = TRUE)

# Packages -------------------------------------------------------------
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(RSelenium, tidyverse, naptime)

# Re-sources --------------------------------------------------------------
source("functions/get2survey.R")

# Get to images gallery -------------------------------------------------------------------

# Create browser instance
rD = RSelenium::rsDriver(browser = "chrome")
remDr <- rD[["client"]]

# Survey link (why did the url change?)
survey_link <- "https://qsharingeu.eu.qualtrics.com/ControlPanel/?ClientAction=ChangePage&Section=GraphicsSection"

# Qualtrics password
pass   <- .rs.askForPassword("Please enter Qualtrics password")

# Get to survey (twice: first to get into qualtrics, then to get into survey)
get2survey(survey_link)
get2survey(survey_link)

# Get to folder (no permanent name to folder?)
webElem <- remDr$findElement(using = 'css selector', value = "#Folder_12 .folder-name")
webElem$clickElement()

Sys.sleep(3) # give it time

# Scrap images url --------------------------------------------------------

#  Check number of pages
# Css selector of "Next" button.
next_button_selector <- "#LibraryFoldersContainer > div.content.upload-drop-area.ng-isolate-scope > div.elements-container.ng-scope.angular-ui-tree > div.pagination-footer.ng-scope > div > div:nth-child(5) > div"
# Web element of "Next" Button
webElem <- remDr$findElement("css selector", next_button_selector)

# status and counter to use with while
status <- "go"
counter <- 1

# Count pages
while (status == "go") {
  # Check if button is visible (the button it's always there, if it's not vissible it's because there is not another page ahead)
  if (webElem$isElementDisplayed()[[1]]) {
    webElem$clickElement()
    counter <-  counter + 1
  } else if (!webElem$isElementDisplayed()[[1]]) {
    message(paste0(counter , " pages"))
    status = "stop"
  }
}

# Css selector of "Previous" button.
previous_button_selector <- "#LibraryFoldersContainer > div.content.upload-drop-area.ng-isolate-scope > div.elements-container.ng-scope.angular-ui-tree > div.pagination-footer.ng-scope > div > div:nth-child(1) > div"
# Web element of "Previous" Button
webElem <- remDr$findElement("css selector", previous_button_selector)

# Go back to first page
for (i in seq(counter-1)) {
  webElem$clickElement()
}

# Get elements (cog button). For some reason the second half are the actual buttons.
elements <- remDr$findElements("class name", "icon-gear")
max_elements <- length(elements)/2
# list to store urls (cog_buttons_elements*number_pages)
imgs <- rep(list(vector("character", 2)), length(elements)/2*counter)

# Scraping
for (i in seq(counter)) {
  # i = 1
  
  # Get elements (cog button). For some reason the second half are the actual buttons.
  # This has to be done on each page.
  elements <- remDr$findElements("class name", "icon-gear")
  
  # This loop doesn't start from 1 to n. It starts from the half of the lenght of "elements" + 1
  # If the lenght is 20, it starts from 11 to 20.
  for (o in seq(length(elements)/2)+length(elements)/2) {
    # o <- 21
    
    # Very ugly counter
    # because the o counter doesn't start from 1 nor goes all the way to "imgs" lenght.
    img_counter <- (o-length(elements)/2)+(max_elements)*i-(max_elements)
    
    # Cog button
    webElem <- elements[[o]]
    webElem$clickElement() # click cog button
    
    # "Edit Graphic"
    webElem <- remDr$findElement(using = 'css selector', value = "#QMenu > div > div > ul > li.Edit > a")
    webElem$clickElement()
    
    Sys.sleep(1) # give it time
    
    # Get image name (condition)
    webElem <- remDr$findElement(using = 'css selector', value = "#preview-graphic_modal > div > div > div.modal-header > h4")
    .GlobalEnv$imgs[[img_counter]][1] <- webElem$getElementText()[[1]]
    message(paste0("Image ", img_counter, ". x-"))
    
    # Get image url (copied to clipboard)
    webElem <- remDr$findElement(using = 'css selector', value = "#preview-graphic_modal > div > div > div.modal-header > div > div.btn.ng-scope")
    webElem$clickElement()
    
    # Get image url (copied to clipboard)
    webElem <- remDr$findElement(using = 'css selector', value = "#preview-graphic_modal > div > div > div.modal-header > div > div.btn.ng-scope")
    webElem$clickElement()
    
    # get url from clipboard
    .GlobalEnv$imgs[[img_counter]][2] <- clipr::read_clip()
    message(paste0("Image ", img_counter, ". xx"))
    # Close "Edit Graphic" window
    webElem <- remDr$findElement(using = 'css selector', value = "#preview-graphic_modal > div > div > div.modal-body > div > div.form.edit-options > div:nth-child(2) > div.footer > div.btn.btn-hover > span")
    webElem$clickElement()
  }
  # if this is not the last page, go to the next
  if (i != 9) {
    next_button_selector <- "#LibraryFoldersContainer > div.content.upload-drop-area.ng-isolate-scope > div.elements-container.ng-scope.angular-ui-tree > div.pagination-footer.ng-scope > div > div:nth-child(5) > div"
    webElem <- remDr$findElement("css selector", next_button_selector)
    webElem$clickElement()
  }
}

# close client/server
remDr$close()
rD$server$stop()

# filter to keep non-empty rows
final_imgs <- imgs[1:img_counter]

# list to table
matrix_imgs <- 
  data.frame(matrix(unlist(final_imgs), nrow=length(final_imgs), byrow=T)) %>% 
  as.tibble(.) %>% setNames(., c("name", "url"))

# export csv 
write_csv(matrix_imgs, "materials/matrices_imgs.csv")