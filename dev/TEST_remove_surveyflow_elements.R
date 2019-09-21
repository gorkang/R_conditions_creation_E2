remove_surveyflow_elements <- function(start_on = 3) {
  
  start_on <- 3
  
  # Go to Survey Flow
  webElem <- remDr$findElement(using = 'css selector', value = "#surveyflow > span:nth-child(2)")
  webElem$clickElement()
  
  # get blocks selectors 
  selectors <- remDr$findElements("class name", 'Delete')
  length(selectors)
  
  
  for (i in seq(selectors)) {
    # i <- 1
    
    remDr$setTimeout(type = "implicit", milliseconds = 2000)
    .GlobalEnv$webElem = ""
    
    message(paste0("Deleting Survey Flow no. ", i))
    
    
    # DELETE: Try one of two ways to do this
      tryCatch({
        .GlobalEnv$webElem <- remDr$findElement(
          using = 'xpath', 
          value = '/html/body/div[5]/div/div[2]/div/div/div/div/div[1]/div/div/div[5]/div/div[1]/div/div[1]/div[3]/a[4]')
        }, 
      # ERROR
      error = function(e) {
        .GlobalEnv$webElem <- remDr$findElement(
          using = 'xpath', 
          value = '/html/body/div[6]/div/div[2]/div/div/div/div/div[1]/div/div/div[5]/div/div[1]/div/div[1]/div[3]/a[4]')
      })
      
        webElem$highlightElement() # Selecciona el elemento
        webElem$clickElement()
        
      
      
    # CONFIRM - YES
      webElem <- remDr$findElement(using = 'css selector', value = '#alertDialogOKButton')
      webElem$clickElement()
    
  }
  
  # SAVE Flow
    webElem <- remDr$findElement(using = 'xpath', value = "//span[contains(text(),'Save')]")
    webElem$highlightElement() # Selecciona el elemento
    webElem$clickElement()
    
    
  send_email(to_email = "gorka.navarrete@uai.cl",
             type = "end",
             password_mail)
  
  
}
