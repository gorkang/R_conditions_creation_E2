remove_surveyflow_elements <- function(start_on = 1) {
  # start_on <- 1
  
  # Go to Survey Flow
  webElem <- remDr$findElement(using = 'css selector', value = "#surveyflow > span:nth-child(2)")
  webElem$clickElement()
  
  # get blocks selectors 
  selectors <- remDr$findElements("class name", 'Delete')
  
  while (length(selectors) < 1) {
    # Get all windows 
    selectors <- remDr$findElements("class name", 'Delete')
  }
  
  for (i in seq(selectors)) {
    # i <- 1
    
    # Get "Block Options" button elements (they change after deleting a block, so it has to be done on every iteration)
    repeat {
      elements <- remDr$findElements("class name", 'Delete')
      done <- 1
      if (done == 1) break
    }
    # If the buttons are not loaded yet the list will be of lenght 0. Try again untill is not 0.
    while(length(elements) == 0) {
      elements <- remDr$findElements("class name", 'Delete')
    }
    
    message(paste0("Deleting Survey Flow no. ", length(elements)))
    
    # Always delete the nth element (they change on every interation)
    repeat {
      webElem <- elements[[start_on]]
      webElem$clickElement()
      done <- 1
      if (done == 1) break
    }
    
    # Sys.sleep(.5) # give it time
    
    repeat {
      
      webElem <- remDr$findElement(using = 'css selector', value = '#alertDialogOKButton')
      # webElem <- remDr$findElement(using = 'css selector', value = "#alertDialogOKButton > span.icon.check")
      webElem$clickElement()
      done <- 1
      if (done == 1) break
    }
    
    Sys.sleep(1) # give it time
    
  }
  
  # Save Flow
  webElem <- remDr$findElement(using = 'css selector', value = "#Q_Window_QW_92025366 > div > div.Q_WindowFooterContainer > div > div.RightButtons > a.btn.btn-success > span:nth-child(2)")
  webElem$clickElement()
  
}
