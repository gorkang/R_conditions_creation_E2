# NO PROBADO. Si primero se anidan los elementos del surveyflow con qualtrics_move_ED_blocks(), despues se pueden borrar de una.

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
    # repeat {
    #   elements <- remDr$findElements("class name", 'Delete')
    #   done <- 1
    #   if (done == 1) break
    # }
    # # If the buttons are not loaded yet the list will be of lenght 0. Try again untill is not 0.
    # while(length(elements) == 0) {
    #   elements <- remDr$findElements("class name", 'Delete')
    # }
    
    message(paste0("Deleting Survey Flow no. ", length(i)))
    
    # Always delete the nth (start_on) element (they change on every interaction)
    repeat {
      # webElem <- elements[[start_on]]
      # webElem$clickElement()
      
      webElem <- remDr$findElement(
        using = 'xpath', 
        # using = 'css selector', 
        # value = '/html/body/div[6]/div/div[2]/div/div/div/div/div[1]/div/div/div[5]/div/div[1]/div/div[1]/div[3]/a[4]')
        value = '/html/body/div[5]/div/div[2]/div/div/div/div/div[1]/div/div/div[5]/div/div[1]/div/div[1]/div[3]/a[4]')
      webElem$highlightElement() # Selecciona el elemento
      webElem$clickElement()
      
      done <- 1
      if (done == 1) break
    }
    
    # Sys.sleep(.5) # give it time

    # Click Confirm - Yes    
    repeat {
      webElem <- remDr$findElement(using = 'css selector', value = '#alertDialogOKButton')
      # webElem <- remDr$findElement(using = 'css selector', value = "#alertDialogOKButton > span.icon.check")
      webElem$clickElement()
      done <- 1
      if (done == 1) break
    }
    
    # Sys.sleep(1) # give it time
    remDr$setTimeout(type = "implicit", milliseconds = 2000)
    
    
  }
  
  # Save Flow
  
  webElem <- remDr$findElement(using = 'xpath', value = '/html/body/div[6]/div/div[3]/div/div[2]/a[2]')
  
  # webElem <- remDr$findElement(using = 'css selector', value = "#Q_Window_QW_92025366 > div > div.Q_WindowFooterContainer > div > div.RightButtons > a.btn.btn-success > span:nth-child(2)")
  webElem$clickElement()
  webElem$highlightElement() # Selecciona el elemento
  
  send_email(to_email = "gorka.navarrete@uai.cl",
             type = "end",
             password_mail)
  
  
}
