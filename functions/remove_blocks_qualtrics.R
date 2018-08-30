remove_blocks_qualtrics <- function(start_on = 1, survey_type = "gorka") {
  # start_on <- 1
  
  # get blocks selectors 
  selectors <- remDr$findElements("css selector", '.StandardBlock')
  
  for (i in seq(selectors)) {
    # i <- 2
    
    # Get "Block Options" button elements (they change after deleting a block, so it has to be done on every iteration)
    repeat {
    elements <- remDr$findElements("class name", "block-options-button")
    done <- 1
    if (done == 1) break
    }
    # If the buttons are not loaded yet the list will be of lenght 0. Try again untill is not 0.
    while(length(elements) == 0) {
      elements <- remDr$findElements("class name", "block-options-button")
    } 
    
    message(paste0("Deleting block no. ", length(elements)))
    
    # Always delete the first element (they change on every interation)
    repeat {
    webElem <- elements[[start_on]]
    webElem$clickElement()
    done <- 1
    if (done == 1) break
    }
    
    Sys.sleep(.5) # give it time
    
    if (survey_type == "gorka") {
        child <- "17"
      } else if (survey_type == "miro") {
        child <- "18"
      }
    
    # Select "Delete Block..."
    repeat {
    webElem <- remDr$findElement(using = 'css selector', value = paste0("#QMenu > div > div > ul > li:nth-child(", child, ") > a"))
    webElem$clickElement()
    done <- 1
    if (done == 1) break
    }
    
    Sys.sleep(.5) # give it time
    
    # Confirm. Select "Delete"
    repeat {
    webElem <- remDr$findElement(using = 'css selector', value = "#ConfirmDeleteButton > span:nth-child(2)")
    webElem$clickElement()
    done <- 1
    if (done == 1) break
    }
    
    Sys.sleep(2) # give it time
    
  }}