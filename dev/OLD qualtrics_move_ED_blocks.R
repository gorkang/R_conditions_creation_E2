qualtrics_move_ED_blocks <- function(start_on = 1, debug = FALSE) {
  # start_on = 0
  
  # Get to Survey Flow
  webElem <- remDr$findElement("css selector", "#surveyflow")
  webElem$clickElement()
  
  # Get blocks
  ed_blocks <- remDr$findElements("class name", "Move")
  
  # # If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
  # while (length(ed_blocks) == 0) {
  #   # Get all survey flow blocks.
  #   ed_blocks <- remDr$findElements("class name", "Move")
  # }
  
  # Remove first element (first element is not any of the survey flow elements)
  ed_blocks <- ed_blocks[-1]
  
  # Set counter to 0. This keeps track of the last block moved.
  .GlobalEnv$safe_counter <- start_on
  
  while (.GlobalEnv$safe_counter != length(ed_blocks)) {
    
    # .GlobalEnv$safe_counter <- .GlobalEnv$safe_counter + 1
    remDr$refresh()
    
    # Get to Survey Flow (if is not possible continue running the code)
    try(expr = {
      webElem <- remDr$findElement("css selector", "#surveyflow")
      webElem$clickElement()
    }, silent = TRUE)
    
    for (i in seq(from = .GlobalEnv$safe_counter, to = length(ed_blocks))) {
      # i <- 1
      # i = i + 1
      
      # .GlobalEnv$safe_counter = 10
      # i = .GlobalEnv$safe_counter
      
      # Progress message
      message(paste0("Moving block ", i, " / ", length(ed_blocks) - 3))
      
      # Get survey flow elements
      blocks <- remDr$findElements("class name", "Move")
      
      # If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
      while (length(blocks) == 0) {
        blocks <- remDr$findElements("class name", "Move")
        blocks <- blocks[-1]
      }
      
      
      # Identify block to move
        if (debug == TRUE) message("* webElem1")
        .GlobalEnv$webElem1 <- blocks[[i + 3]] # Block to move
        .GlobalEnv$webElem1$getElementLocationInView()  
        .GlobalEnv$webElem1$highlightElement() # Selecciona el elemento

      # Identify randomizer "Add a new element here" element
        if (debug == TRUE) message("* webElem2")
        .GlobalEnv$webElem2 <- remDr$findElement(using = 'xpath', value = "//span[contains(text(),'Add a New Element Here')]")
        .GlobalEnv$webElem2$highlightElement() # Selecciona el elemento
      
      # Hay algo extraño en la primera iteracion del bucle, cuando se llama usando la funcion
      # Se mueve hasta el elemento 1
      if (i == 1) {
        .GlobalEnv$webElem2$getElementLocationInView()
        .GlobalEnv$webElem1$highlightElement()
      } else {
        .GlobalEnv$webElem1$getElementLocationInView()  
      }      

  
      # Move block to randomizer
      if (debug == TRUE) message("* Move to randomizer")
      remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem1)
      remDr$buttondown()
      remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem2)
      remDr$buttonup()
      
      
      
      # webElem <- remDr$findElement("css", "body")
      # webElem$sendKeysToElement(list(key = "up_arrow"))
      # # webElem$sendKeysToElement(list(key = "down_arrow"))
      # 
      # blocks <- remDr$findElements("class name", "Move")
      # .GlobalEnv$webElem1 <- blocks[[i + 5]] # Block to move
      # .GlobalEnv$webElem1$highlightElement()
      # .GlobalEnv$webElem1$getElementLocationInView()
      # 
      # remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem1)
      # remDr$buttondown()
      # remDr$buttonup()
      # webElem$sendKeysToElement(list(key = "up_arrow"))
      # 
      # remDr$click(buttonId = 1)
      # 
      # webElem <- remDr$findElement("css", "body")
      # webElem$sendKeysToElement(list(key = "page_down"))
      # Sys.sleep(1)
      # 
      # webElem <- remDr$findElement("css", "body")
      # webElem$sendKeysToElement(list(key = "page_down"))
      # 
      # remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem1)
      # remDr$buttondown()
      # webElem <- remDr$findElement("css", "body")
      # webElem$sendKeysToElement(list(key = "up_arrow"))
      # remDr$buttonup()
      
      # webElem$sendKeysToElement(list(key = "right_arrow"))
      
      
      # webElem <- remDr$findElement("css", "body")
      # # webElem$sendKeysToElement(list(key = "down_arrow"))
      # .GlobalEnv$webElem1$sendKeysToElement(list(key = "up_arrow"))
      # webElem$sendKeysToElement(list(key = "page_down"))
      
      # https://seleniumhq.github.io/selenium/docs/api/py/_modules/selenium/webdriver/common/keys.html
      # PAGE_UP = '\ue00e'
      # PAGE_DOWN = '\ue00f'
      

      
      Sys.sleep(1)
      
      if (.GlobalEnv$safe_counter == length(ed_blocks)) {
        
        webElem <- remDr$findElement("class name", "RightButtons")
        webElem$clickElement()
        .GlobalEnv$safe_counter <- i  
        
      }
      
      # Do batches of 15 blocks. after each batch save the survey flow and start again
      # if (i == 10 + .GlobalEnv$safe_counter) {
      #   Sys.sleep(2)
      #   
      #   # Save Survey Flow
      #   webElem <- remDr$findElement("class name", "RightButtons")
      #   webElem$clickElement()
      #   .GlobalEnv$safe_counter <- i
      #   
      #   message(paste0("*********************\nCounter updated to ", .GlobalEnv$safe_counter))
      #   
      #   break
      # }
      
    }
  }
  
}
