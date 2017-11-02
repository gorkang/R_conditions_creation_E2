problems2responses <- function (problems2response, problems_names) {
  
  # problems2response <- problems_nfab
  # problems_names <- "problems_nfab"
  
  # problems_y <- problems_nfab
  
  # CONVERT THIS INTO FUNCTION: TAKES A LIST WITH PROBLEM/S AND PASTE RESPONSES INTO THEM. THE NUMBERS OF NEW ITEMS ES THE NUMBER OF RESPONSES TYPE
  
  # paste each problem with each response type
  problems2response <-
    lapply(problems2response, 
           function(x) paste0(x, lapply(responses, function(x) x)))
  
  # name each item according to response type and previous info.
  for (i in 1:length(problems2response)) {
    # i=1
    
    for (j in 1:length(responses)) {
      # j=4
      
      # item name is a combination of context_ppv_responsetype
      item_name <-
        paste0(names(problems2response)[i], # problem loop
               "_", 
               names(responses)[j]) # response loop
      
      # append item as list (named with item name)
      problems2response[[i]][[j]] <- # 1. problem loop, 2. response loop 
        setNames(list(problems2response[[i]][[j]]), item_name)
      
    } # RESPONSES LOOP END
    
    
  } # PROBLEMS TO BIND WITH RESPONSES END
  
  # assign list to envir.  
  assign(paste0(problems_names, "_responses"), problems2response, envir = .GlobalEnv)
  
  
} # FUNCTION END