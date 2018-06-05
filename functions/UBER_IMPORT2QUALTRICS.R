UBER_IMPORT2QUALTRICS <- function(full_path) {
  
  # Pre-map
  total_files    <- full_path %>% dir(., ".txt") %>% length()
  files_fullpath <- full_path %>% dir(., ".txt") %>% paste0(full_path, .)
  # Track of files uploading
  .GlobalEnv$track_table <- 
    tibble(file = full_path %>% dir(., ".txt")) %>% 
    mutate(tools = 0,
           import = 0, 
           import_survey = 0,
           upload = 0,
           done = 0)
  
  for (a in seq(files_fullpath)) {
    # a <- 1
    
    
    # absolute path to file
    file_absolute_path <- files_fullpath[a]
    
    # Update counter
    .GlobalEnv$Q_counter <- Q_counter+1
    # Current file to upload
    message(paste0("**************************************\n",
                   "File number: ", Q_counter, " out of ", total_files, "\n",
                   "File name: ", gsub(".*/(.*\\.txt)", "\\1", file_absolute_path), "\n",
                   "**************************************"))
    
    # SELECT TOOLS
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    
    while (!is_empty(status)) {
      .GlobalEnv$status <- 
        tryCatch(expr = {
          # TRY
          webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="Toolbar"]/ul/li[4]/div/span[3]')
          webElem$clickElement()
          
          cat("\n*.... - Select Tools\n") # MESSAGE
          .GlobalEnv$track_table[a, 2] <- .GlobalEnv$n
          Sys.sleep(1) # give it time
        }, 
        # ERROR
        error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(1) # give it time
          return("start")
        })
    }
    
    
    # SELECT IMPORT
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    while (!is_empty(status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          webElem <- remDr$findElement(using = 'css selector', value = '#body > div.qmenu.dropdown-menu.positioned > ul > li:nth-child(12)')
          webElem$clickElement()
          cat("\n**... - Select Import\n")
          .GlobalEnv$track_table[a, 3] <- .GlobalEnv$n
          Sys.sleep(1) # give it time
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(1) # give it time
          return("start")
        })
    }
    
    # SELECT IMPORT SURVEY
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    while (!is_empty(status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          webElem <- remDr$findElement(using = 'css selector', value = '#body > div.qmenu.dropdown-menu.qsubmenu.positioned > ul > li:nth-child(2)')
          webElem$clickElement()
          cat("\n***.. - Select Import Survey\n")
          .GlobalEnv$track_table[a, 4] <- .GlobalEnv$n
          Sys.sleep(1) # give it time
          
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(1) # give it time
          return("start")
        })
    }
    
    # UPLOAD FILE
    .GlobalEnv$n <- 0
    .GlobalEnv$status <- "start"
    while (!is_empty(status)) {
      
      .GlobalEnv$status <- 
        tryCatch(expr = {
          # TRY
          upload_btn <- remDr$findElement(using = 'xpath', value = '//*[@id="fileField"]')
          upload_btn$sendKeysToElement(list(file_absolute_path))
          
          webElem <- remDr$findElement(using = 'xpath', value = '//*[@id="importButton"]/span[2]')
          webElem$clickElement()
          
          cat("\n****. - Upload File\n") # MESSAGE
          .GlobalEnv$track_table[a, 5] <- .GlobalEnv$n
          Sys.sleep(2) # give it time
          
        }, error = function(e) {
          .GlobalEnv$n <- .GlobalEnv$n +1
          
          message("Retrying") # MESSAGE
          message(n) # MESSAGE
          
          Sys.sleep(1) # give it time
          return("start")
        })
    }
    
    # FINAL MESSAGE
    .GlobalEnv$track_table[a, 6] <- 1
    cat("\n***** - File Uploaded!\n\n\n")
    
  }
  
}
