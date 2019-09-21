qualtrics_move_ED_blocks_OLD <- function(start_on = 0, debug_it = FALSE) {

  # start_on = 0
  # debug_it = TRUE
  tictoc::tic.clearlog()
  
  # Get to Survey Flow
  remDr$refresh()
  webElem <- remDr$findElement("css selector", "#surveyflow")
  webElem$clickElement()
  Sys.sleep(5) # give it time
  
  # Get blocks
  ed_blocks <- remDr$findElements("class name", "Move")
  # Si esta vacio, esperar unos segundos y reintentar
  if (length(ed_blocks) == 0 ) {
    Sys.sleep(5) # give it time
    ed_blocks <- remDr$findElements("class name", "Move")
  }
  
  # Remove first element (first element is not any of the survey flow elements)
  ed_blocks <- ed_blocks[-1]
  message(length(ed_blocks))
  
  # Set counter to 0. This keeps track of the last block moved.
  .GlobalEnv$safe_counter <- start_on
  
  while (.GlobalEnv$safe_counter != length(ed_blocks)) {
    remDr$refresh()

    # Get to Survey Flow (if is not possible continue running the code)
    try(expr = {
      webElem <- remDr$findElement("css selector", "#surveyflow")
      webElem$clickElement()
    }, silent = TRUE)

    # Get survey flow elements
    blocks <<- remDr$findElements("class name", "Move")
    
    # .GlobalEnv$safe_counter = 181
    for (i in seq(from = .GlobalEnv$safe_counter, to = length(ed_blocks))) {
      tictoc::tic()
      # Progress message
      message(paste0("Moving block ", i, " / ", length(ed_blocks) - 3))

      # Get survey flow elements
      blocks <- remDr$findElements("class name", "Move")

      # If survey flow is not loaded (blocks is empty) check for elemenst again, until is not empty.
      while (length(blocks) == 0) {
        blocks <- remDr$findElements("class name", "Move")
        blocks <- blocks[-1]
      }


      # Identify block to move webElem1
      if (debug_it == TRUE)
        message("* webElem1")
      .GlobalEnv$webElem1 <- blocks[[i + 3]] # Block to move
      .GlobalEnv$webElem1$getElementLocationInView()
      .GlobalEnv$webElem1$highlightElement() # Selecciona el elemento

      # Identify randomizer "Add a new element here" element webElem2
      if (debug_it == TRUE)
        message("* webElem2")
      .GlobalEnv$webElem2 <-
        remDr$findElement(using = 'xpath', value = "//span[contains(text(),'Add a New Element Here')]")
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
      if (debug_it == TRUE)
        message("* Move to randomizer")
      remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem1)
      remDr$buttondown()
      remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem2)
      remDr$buttonup()


      tictoc::toc(log = TRUE)
      
      # tictoc::tic()
      # # Progress message
      # message(paste0("Moving block ", i, " / ", length(ed_blocks) - 3))
      # .GlobalEnv$webElem1 <-
      #   remDr$findElement(using = 'css selector',
      #                     value = "div.FlowElement:nth-child(1) > div:nth-child(1) > div:nth-child(7) > div:nth-child(1) > div:nth-child(1)")
      # # value = "/html/body/div[5]/div/div[2]/div/div/div/div/div[1]/div/div/div[7]/div/div[1]/div/div[1]/div[3]/a[2]")
      # 
      # .GlobalEnv$webElem1$getElementLocationInView()
      # # .GlobalEnv$webElem1$highlightElement() # Selecciona el elemento
      # 
      # # .GlobalEnv$webElem2 <-
      # #   remDr$findElement(using = 'xpath', value = "//span[contains(text(),'Add a New Element Here')]")
      # # .GlobalEnv$webElem2$highlightElement() # Selecciona el elemento
      # 
      # remDr$mouseMoveToLocation(webElement = .GlobalEnv$webElem1)
      # remDr$click(buttonId = 1)
      # webElem <- remDr$findElement("css", "body")
      # webElem$sendKeysToElement(list(key = "up_arrow"))
      # tictoc::toc()
      
      
      
      
      # Si es el ultimo elemento, guarda los cambios!
      if (.GlobalEnv$safe_counter == length(ed_blocks)) {
        Sys.sleep(1)
        webElem <- remDr$findElement("class name", "RightButtons")
        webElem$clickElement()
        .GlobalEnv$safe_counter <- i
      }
      
    }
    
  }
  
}
