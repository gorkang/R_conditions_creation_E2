# This function takes:
# a list of strings, each element has to have a name that indicates a presentation format (e.g. nfab) present on fields2fill.csv (or in any other file with placeholders
# a data frame with numbers, (e.g. number_bayes.xls)
# a path to csv with fields to fill, each presentation format has to have a column indicating wich fields are to be filled.

numbers2problems <- function(problems, numbers_item, path2fields) {
  
  # Packages ************************************
  if (!require('stringi')) install.packages('stringi'); library('stringi')
  
  # ARGUMENTS *********************************
  # list with problems (from function argument)
  problems_x <- 
    problems
  
  # FILTER NUMBER SET *************************
  # filter numbers to keep format
  numbers_item_x <- 
    numbers_item
  
  # All fields to replace come from a csv file.
  fields2fill <- 
    read_csv(path2fields, col_types = cols())
  
  # MASTER LIST (this is going to global enviroment after 1. LOOP is finished)
  # # Create empty list with length of problems
  list_of_lists <- 
    rep(list(NULL), length(problems_x)) 
  
  # # name empty list
  names(list_of_lists) <- 
    names(problems_x)
  
  # 01. This loop goes through the list of problems
  for (i in 1:length(problems_x)) {
    # i=1
    
    # current element of the list: item to fill with numbers
    item2number <- 
      problems_x[[i]]
    
      # current item format (textual formats is set at the beginning of textonly_item_prep.R)
      item_format <- 
        gsub(paste0(".*(", paste(textual_formats, collapse = "|"), ").*"),
             "\\1", 
             names(problems_x[i]))
      
      # filtered number table # ACCORDING TO FORMAT
      numbers_item_x_filt <- 
        filter(numbers_item_x, format == item_format)
      
      # fields to replace of classic text items # ACCORDING TO FORMAT
      field_to_replace <- 
        fields2fill[[item_format]][!is.na(fields2fill[[item_format]])] # very ugly way to remove NA
      
      # list with repeated canvas item
      item2number_list <- rep(list(item2number), nrow(numbers_item_x_filt))
      
      # 01.1 Loop through number sets
      for (x in 1:nrow(numbers_item_x_filt)) {
        # x=1
        
        # 01.1 Name current problem (Loop 01)
        item2number_list[[x]] <-
          paste0("**",
                 paste(names(problems_x[i]), # item name and format
                       paste0("ppv",numbers_item_x_filt[x,]["prob"]), # normative ppv
                       # "\n", # line break
                       sep = "_"), "**\n\n",
                 item2number_list[[x]])
        
        # 01.1.1 Loop through fields to replace
        for (j in 1:length(field_to_replace)) {
          # j=1
          
          item2number_list[[x]] <-
            gsub(field_to_replace[j], # to be replaced
                 paste0(numbers_item_x_filt[x,][[field_to_replace[j]]]), #replacement
                 item2number_list[[x]]) # current problem (LOOP 1)
          
        } # END: 01.1.1 Loop through fields to replace
      } # END: 01.1 Loop through number sets
    
    # insert current item numbered into the master list
    list_of_lists[[i]] <- item2number_list
    
  } # END: 01. This loop goes through the list of problems
  
  # ASSIGN FINAL LIST TO ENVIROMENT
  assign("problems_numbered" , list_of_lists, envir = .GlobalEnv)
  
} # FUNCTION END
