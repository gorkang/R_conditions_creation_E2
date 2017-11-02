numbers2problems <- function(problems, number_format, normative_ppv) {
  
  
  # list with problems
  problems_x <- problems
  # set number format of numbers to fill items
  # number_format <- "nfab"
  number_format <- number_format
  # set normative ppv
  # normative_ppv <- "high"
  normative_ppv <- normative_ppv
  
  
  # filter numbers to keep format
  numbers_item_x <- 
    numbers_item %>%  
    filter(format == number_format, prob == normative_ppv)
  
  # keep only problems of number_format set
  
  # IF format is natural freq. or probabilities we keep non positive framework items
  if (number_format != "pofr") {
    
    problems_x <- problems_x[!grepl("pf", names(problems_x))]
    
    # IF format is not natural freq. or probabilities we keep positive framework items
  } else if (number_format == "pofr") {
    
    problems_x <- problems_x[grepl("pf", names(problems_x))]
    
  }
  
  
  for (i in 1:length(problems_x)) {
    
    # i=1
    
    # get context index according to element name in list
    context_index <- which((names(problems_x)[i] == numbers_item_x$context))
    
    # create a vector with current loop item to feed loop that replace fields for numbers
    item2number <- problems_x[[i]]
    
    # LOOP to put numbers into the item **********************************************
    
    # NATURAL FREQUENCIES ******************
    
    if (number_format == "nfab") {
      
      # keep fields to replace
      field_to_replace_x <- 
        grep("0[12]", field_to_replace, value = TRUE)
      
      # LOOP to replace fields
      for (j in seq(1, length(field_to_replace_x), 2)) {
        
        # j=1
        
        item2number <-
          gsub(field_to_replace[j], #to be replaced
               paste0(numbers_item_x[context_index,][[field_to_replace[j]]], " in every ",
                      numbers_item_x[context_index,][[field_to_replace[j+1]]])
               , #replacement
               item2number)
        
      }
      
    }
    
    # PROBABILITIES ******************
    
    if (number_format == "prab") {
      
      # keep fields to replace
      field_to_replace_x <- 
        grep("0[12]", field_to_replace, value = TRUE)
      
      for (j in seq(1, length(field_to_replace_x), 2)) {
        
        # j=3
        
        item2number <-
          gsub(field_to_replace[j], #to be replaced
               paste0(numbers_item_x[context_index,][[field_to_replace[j]]]*100, "% of")
               , #replacement
               item2number)
        
      }
      
    }
    
    # POSITIVE-FRAMEWORK ******************
    
    if (number_format == "pofr") {
      
      # keep fields to replace
      field_to_replace_x <- field_to_replace
      
      for (j in seq_along(field_to_replace_x)) {
        
        # j=1
        
        item2number <-
          gsub(field_to_replace[j], #to be replaced
               paste0(numbers_item_x[context_index,][[field_to_replace[j]]])
               , #replacement
               item2number)
        
      }
      
    }
    
    
    # ANY DIFFERENCE BETWEEN RELATIVE AND ABSOLUTE PROBS?
    
    
    # replace item with item with numbers
    problems_x[[i]] <- item2number
    
    # update element list name
    names(problems_x)[i] <- paste0(names(problems_x[i]), "_",  number_format, "_", numbers_item_x[context_index,][["prob"]])
    
    # create list in global envir.
    assign(paste0("problems_", number_format, "_", normative_ppv), problems_x, envir = .GlobalEnv)
    
    
  } # PROBLEMS LOOP END
  
} # FUNCTION END