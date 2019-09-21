UBER_IMPORT2QUALTRICS_miro <- function(file_paths, debug_it = FALSE) {

  # DEBUG
  # debug_it = TRUE
  
  tictoc::tic.clearlog()
  
  # remDr$setImplicitWaitTimeout(milliseconds = 10000)
  remDr$setTimeout(type = "implicit", milliseconds = 2000)
  time_to_sleep = 6
  
  
  # Track of files uploading
  .GlobalEnv$track_table <- 
    tibble(file = file_paths) %>% 
    mutate(tools = 0,
           import = 0, 
           import_survey = 0,
           upload = 0,
           done = 0)
  
  for (a in seq(file_paths)) {
    # a <- 1
    
    tictoc::tic()
    beep(sound = 10)
    
    time_mean = mean(as.numeric(gsub(" sec elapsed", "", tictoc::tic.log() %>% unlist())))
    message("Promedio_bloque: ",  time_mean, ". Estimado: ", time_mean * (length(file_paths) - a))
    
    
    # absolute path to file
    file_absolute_path <- file_paths[a]
    
    # Update counter
    .GlobalEnv$Q_counter <- Q_counter+1
    # Current file to upload
    message(paste0("**************************************\n",
                   "File number: ", Q_counter, " out of ", length(file_paths), "\n",
                   "File name: ", gsub(".*/(.*\\.txt)", "\\1", file_absolute_path), "\n",
                   "**************************************"))
    
    # SELECT TOOLS
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    
    while (!is_empty(.GlobalEnv$status)) {
      .GlobalEnv$status <- 
        tryCatch(expr = {
          
          remDr$setTimeout(type = "page load", milliseconds = 10000) # Wait for page to load
          remDr$setTimeout(type = "implicit", milliseconds = 5000)
          # Sys.sleep(time_to_sleep/5) # give it time
          
          # TRY
          remDr$refresh()
          
          # Original
          # webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="Toolbar"]/ul/li[4]/div/span[3]')
          # webElem$clickElement()
          

          webElem <- remDr$findElement(using = 'css selector', value = '#Toolbar > ul > li.Tools.ng-scope > div > span:nth-child(2)')
          # Sys.sleep(time_to_sleep/5)
          webElem$highlightElement() # Selecciona el elemento
          webElem$clickElement()
  
          cat("\n*.... - Select Tools\n") # MESSAGE
          .GlobalEnv$track_table[a, 2] <- .GlobalEnv$n
          Sys.sleep(time_to_sleep/5) # give it time
          
        }, 
        # ERROR
        error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(time_to_sleep/5) # give it time
          return("start")
        })
    }
    
    
    # SELECT IMPORT
      # VER: https://mail.google.com/mail/u/0/#search/nicolas.csanchez%40gmail.com+selenium/KtbxLthtHgWJdCKqqrktmjZlPfPBtGftSV
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    
    # .GlobalEnv$webElem = ""
    # .GlobalEnv$second_try = FALSE
    
    while (!is_empty(.GlobalEnv$status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          # webElem <- remDr$findElement(using = 'css selector', value = '#body > div.qmenu.dropdown-menu.positioned > ul > li:nth-child(15)')
          # webElem$clickElement()
          # Sys.sleep(time_to_sleep/5) # give it time
          
           webElem <- remDr$findElement(using = 'css selector', value = '#body > div.qmenu.dropdown-menu.positioned > ul > li:nth-child(14)')
           webElem$highlightElement() # Selecciona el elemento
           webElem$clickElement()

          # if (second_try == FALSE) {
          #   message("ONE")
          #   second_try = TRUE
          #   remDr$setTimeout(type = "implicit", milliseconds = 0)
          #   webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="body"]/div[5]/ul/li[14]/a')
          # } else {
          #   message("TWO")
          #   remDr$setTimeout(type = "implicit", milliseconds = 10000)
          #   webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="body"]/div[4]/ul/li[14]/a')
          # }
          # webElem$clickElement() # No hace nada
          # webElem$highlightElement() # Selecciona el elemento
          # webElem$clickElement() # Funciona!
          
          cat("\n**... - Select Import\n")
          .GlobalEnv$track_table[a, 3] <- .GlobalEnv$n
          Sys.sleep(time_to_sleep/5) # give it time
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(time_to_sleep/5) # give it time
          return("start")
        })
    }
    
    # SELECT IMPORT SURVEY
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    while (!is_empty(.GlobalEnv$status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          
          remDr$setTimeout(type = "implicit", milliseconds = 2000)
          
          webElem <- remDr$findElement(using = 'css selector', value = '#body > div.qmenu.dropdown-menu.qsubmenu.positioned > ul > li:nth-child(2)') 
          webElem$clickElement()
          cat("\n***.. - Select Import Survey\n")
          .GlobalEnv$track_table[a, 4] <- .GlobalEnv$n
          Sys.sleep(time_to_sleep/5) # give it time
          
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(time_to_sleep/5) # give it time
          return("start")
        })
    }
    
    # UPLOAD FILE
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    while (!is_empty(.GlobalEnv$status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          # TRY
          # upload_btn <- remDr$findElement(using = 'css selector', value = "#fileField")
          upload_btn <- remDr$findElement(using = 'xpath', value = '//*[@id="fileField"]')
          
          upload_btn$sendKeysToElement(list(file_absolute_path))
          Sys.sleep(time_to_sleep/5) # give it time
          
          
          # webElem <- remDr$findElement(using = 'css selector', value = "#Q_Window_QW_35429289 > div > div.Q_WindowFooterContainer > div > div.RightButtons > a.btn.negative > span:nth-child(2)")
          webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="importButton"]/span[2]')
          webElem$clickElement()
          
          cat("\n****. - Upload File\n") # MESSAGE
          .GlobalEnv$track_table[a, 5] <- .GlobalEnv$n
          Sys.sleep(time_to_sleep/5) # give it time
          
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(time_to_sleep/5) # give it time
          return("start")
        })
    }
    
    # FINAL MESSAGE
    .GlobalEnv$track_table[a, 6] <- 1
    cat("\n***** - File Uploaded!\n\n\n")
    tictoc::toc(log = TRUE)
    
  }
  
  beep(sound = 4)
  
  
  
}
