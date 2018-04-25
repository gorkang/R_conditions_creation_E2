# THIS FUNCTION TAKES A LIST WITH PROBLEMS, A DATA FRAME WITH NUMBERS
# SETS, AND A STRING INDICATING "low" or "high" normative PPV

numbers2problems <- function(problems) {
  
  # PACKS ************************************
  if (!require('pacman')) install.packages('pacman'); library('pacman')
  p_load(stringi)
  # ******************************************
  
  # ARGUMENTS *********************************
  # list with problems (from function argument)
  problems_x <- problems
  
  # FILTER NUMBER SET *************************
  # filter numbers to keep format
  numbers_item_x <- 
    numbers_item
   
  
  # Fields to be replaced by presentation format
  fields2fill <- read_csv("materials/Numbers/fields2fill.csv", col_types = cols())
  fields_nfab <- fields2fill$nfab[!is.na(fields2fill$nfab)]
  fields_pr <- fields2fill$pr[!is.na(fields2fill$pr)]
  fields_pf <- fields2fill$pf[!is.na(fields2fill$pf)]
    # fields_tx <- c("prev_01", "prev_02", "hit_rate_01", "hit_rate_02", "false_positive_01", "false_positive_02")
  
  # MASTER LIST (this is going to global enviroment after 1. LOOP finish)
    # Create empty list with lenght of problems
    list_of_lists <- rep(list(NULL), length(problems_x)) 
    # name empty list
    names(list_of_lists) <- names(problems_x)
  
  for (i in 1:length(problems_x)) { # 1. LOOP PROBLEMS
    # i=4
    
    # create a vector with current loop item to feed loop that replace fields for numbers
    item2number <- problems_x[[i]]
    
    # IF NFAB
    if (grepl("nfab", names(problems_x[i]))) { # IF ITEM IS NATURAL FREQ.
      
      # current item format
      item_format = substr(names(problems_x[i]), 4, nchar(names(problems_x[i])))
      # filtered number table
      numbers_item_x_filt <- filter(numbers_item_x, format == item_format)
      
      # empty list
      item2number_list <- rep(list(NULL),nrow(numbers_item_x_filt))
      
      # fields to replace of classic text items
      field_to_replace <- fields_nfab
      
      # list with repeated canvas item
      for (list_loop in 1:nrow(numbers_item_x_filt)) 
        {item2number_list[[list_loop]] <- item2number}  #short loop to repeat current PROBLEM from LOOP 1
      
      for (x in 1:nrow(numbers_item_x_filt)) { # 1.1. LOOP NUMBER SET TABLE
        # x=1
        
        # NAME CURRENT PROBLEM (LOOP 1)
        item2number_list[[x]] <-
          paste0("**",
            paste(names(problems_x[i]), # item name and format
                  paste0("ppv",numbers_item_x_filt[x,]["prob"]), # normative ppv
                  # "\n", # line break
                  sep = "_"), "**\n\n",
            item2number_list[[x]]
            )
        
        for (j in 1:length(field_to_replace)) { # 1.1.1. LOOP FIELDS TO REPLACE
          # j=1
          
          item2number_list[[x]] <-
            gsub(field_to_replace[j], # to be replaced
                 paste0(numbers_item_x[x,][[field_to_replace[j]]]), #replacement
                 item2number_list[[x]]) # current problem (LOOP 1)
          
                                              } # END: 1.1.1. LOOP FIELDS TO REPLACE
        
                                        } # END: 1.1. LOOP NUMBER SET TABLE

      } else if (grepl("_pr", names(problems_x[i]))) { # END: IF ITEM IS NATURAL FREQ.
        
        # current item format
        item_format = substr(names(problems_x[i]), 4, nchar(names(problems_x[i])))
        
        # filtered number table
        numbers_item_x_filt <- filter(numbers_item_x, format == item_format)
        
        # empty list
        item2number_list <- rep(list(NULL),nrow(numbers_item_x_filt))
        
        # fields to replace of classic text items
        field_to_replace <- fields_pr
        
        # list with repeated canvas item
        for (list_loop in 1:nrow(numbers_item_x_filt)) 
        {item2number_list[[list_loop]] <- item2number}  #short loop to repeat current PROBLEM from LOOP 1
        
        for (x in 1:nrow(numbers_item_x_filt)) { # 1.1. LOOP NUMBER SET TABLE
          # x=1
          
          # NAME CURRENT PROBLEM (LOOP 1)
          item2number_list[[x]] <-
            paste0("**",
              paste(names(problems_x[i]), # item name and format
                    paste0("ppv",numbers_item_x_filt[x,]["prob"]), # normative ppv
                    # "\n", # line break
                    sep = "_"), "**\n\n",
              item2number_list[[x]]
            )
          
          for (j in 1:length(field_to_replace)) { # 1.1.1. LOOP FIELDS TO REPLACE
            # j=1
            
            item2number_list[[x]] <-
              gsub(field_to_replace[j], # to be replaced
                   paste0(as.numeric(numbers_item_x_filt[x,][[field_to_replace[j]]])*100), #replacement
                   item2number_list[[x]]) # current problem (LOOP 1)
            
          } # END: 1.1.1. LOOP FIELDS TO REPLACE
          
          } # END: 1.1. LOOP NUMBER SET TABLE
        
        
      } else if (grepl("_pf", names(problems_x[i]))) { # END: IF ITEM IS PROBABILITY
       
        # current item format
        item_format = substr(names(problems_x[i]), 4, nchar(names(problems_x[i])))
        
        # filtered number table
        numbers_item_x_filt <- filter(numbers_item_x, format == item_format)
        
        # empty list
        item2number_list <- rep(list(NULL),nrow(numbers_item_x_filt))
        
        # fields to replace of classic text items
        field_to_replace <- fields_pf
        
        # list with repeated canvas item
        for (list_loop in 1:nrow(numbers_item_x_filt)) 
        {item2number_list[[list_loop]] <- item2number}  #short loop to repeat current PROBLEM from LOOP 1
        
        for (x in 1:nrow(numbers_item_x_filt)) { # 1.1. LOOP NUMBER SET TABLE
          # x=1
          
          # NAME CURRENT PROBLEM (LOOP 1)
          item2number_list[[x]] <-
            paste0("**",
              paste(names(problems_x[i]), # item name and format
                    paste0("ppv", numbers_item_x_filt[x,]["prob"]), # normative ppv
                    # "\n", # line break
                    sep = "_"), "**\n\n",
              item2number_list[[x]]
            )
          
          for (j in 1:length(field_to_replace)) { # 1.1.1. LOOP FIELDS TO REPLACE
            # j=1
            
            item2number_list[[x]] <-
              gsub(field_to_replace[j], # to be replaced
                   paste0(numbers_item_x[x,][[field_to_replace[j]]]), #replacement
                   item2number_list[[x]]) # current problem (LOOP 1)
            
          } # END: 1.1.1. LOOP FIELDS TO REPLACE
          
        } # END: 1.1. LOOP NUMBER SET TABLE
        
        } # END: IF ITEM IS POSITIVE FRAMEWORK
        
    # insert current item numbered into the master list
    list_of_lists[[i]] <- item2number_list
    
    
  } # END: 1. LOOP PROBLEMS
  
    # ASSIGN FINAL LIST TO ENVIROMENT
    assign("problems_numbered" , list_of_lists, envir = .GlobalEnv)
    
} # FUNCTION END
    