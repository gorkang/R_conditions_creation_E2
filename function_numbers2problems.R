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
   
  fields_tx <- c("prev_01", "prev_02", "hit_rate_01", "hit_rate_02", "false_positive_01", "false_positive_02")
  fields_pf <- c("all_positive", "prev_02", "hit_rate_01", "false_positive_01")
  
  # MASTER LIST (this is going to global enviroment after 1. LOOP finish)
    # Create empty list with lenght of problems
    list_of_lists <- rep(list(NULL), length(problems_x)) 
    # name empty list
    names(list_of_lists) <- names(problems_x)
  
  for (i in 1:length(problems_x)) { # 1. LOOP PROBLEMS
    # i=1
    
    # create a vector with current loop item to feed loop that replace fields for numbers
    item2number <- problems_x[[i]]
    
    # LOOP to put numbers into the item **********************************************
    
    if (grepl("tx", names(problems_x[i]))) { # IF PROBLEM IS CLASSIC TEXT
            
            # empty list
            item2number_list <- rep(list(NULL),nrow(numbers_item_x))
            
            # fields to replace of classic text items
            field_to_replace <- fields_tx
            
            # list with repeated canvas item
            for (list_loop in 1:nrow(numbers_item_x)) {item2number_list[[list_loop]] <- item2number}  #short loop to repeat current PROBLEM from LOOP 1
            
                  
            for (x in 1:nrow(numbers_item_x)) { # 1.1. LOOP NUMBER SET TABLE
              # x=1
              
              # NAME CURRENT PROBLEM (LOOP 1)
              item2number_list[[x]] <- paste0(
                paste(names(problems_x[i]), # item name and format
                      numbers_item_x[x,]["format"], # format
                      numbers_item_x[x,]["prob"], # normative ppv
                      "\n",
                      sep = "_"),
                item2number_list[[x]]
                )
              
              
                    for (j in seq(1, length(field_to_replace), 2)) { # 1.1.1. LOOP FIELDS TO REPLACE
                          # j=1
                          
                      # if is not prob format
                      if (!grepl("pr",numbers_item_x[x, "format"]))         { # IF NOT PROB FORMAT
                        
                        item2number_list[[x]] <-
                          gsub(field_to_replace[j], # to be replaced
                               paste0(numbers_item_x[x,][[field_to_replace[j]]], " in every ",
                                      numbers_item_x[x,][[field_to_replace[j+1]]]), #replacement
                               item2number_list[[x]]) # current problem (LOOP 1)
                        
                        } else if (grepl("pr",numbers_item_x[x, "format"])) { # IF PROB FORMAT
                          
                          item2number_list[[x]] <-
                            gsub(field_to_replace[j], # to be replaced
                                 paste0(numbers_item_x[x,][[field_to_replace[j]]]*100, "%"), #replacement
                                 item2number_list[[x]]) # current problem (LOOP 1)
                                  
                                                                            } # END: IF NOT PROB/PROB FORMAT
                          
                                                                      } # END: 1.1.1. LOOP FIELDS TO REPLACE
                  
                                                  } # END: 1.1. LOOP NUMBER SET TABLE
              
              # IF PROBLEM IS CLASSIC TEXT, 1. LOOP ENDS here
              list_of_lists[[i]] <- item2number_list
              
    
    } else if (grepl("pf", names(problems_x[i]))) { # IF PROBLEM IS POSITIVE FRAMEWORK
    
      # fields to replace of positive framework items
      field_to_replace <- fields_pf
      # numbers for positive framework items (only natural freq.)
      numbers_item_y <- numbers_item_x %>% filter(format == "nfab")
      # empty list
      item2number_list <- rep(list(NULL),nrow(numbers_item_y))
      
      # list with repeated canvas item
      for (list_loop in 1:nrow(numbers_item_y)) {item2number_list[[list_loop]] <- item2number}  #short loop to repeat current PROBLEM from LOOP 1
      
        for (x in 1:nrow(numbers_item_y)) { # 1.2. LOOP NUMBER SET TABLE 
            # x=2
            
          # NAME CURRENT PROBLEM (LOOP 1)
          item2number_list[[x]] <- paste0(
            paste(names(problems_x[i]), # item name and format
                  numbers_item_x[x,]["format"], # format
                  numbers_item_x[x,]["prob"], # normative ppv
                  "\n",
                  sep = "_"),
            item2number_list[[x]]
          )
          
          
                for (j in 1:length(field_to_replace)) { # 1.2.1. LOOP FIELDS TO REPLACE
                  # j=4
                  
                      # if is not prob format
                      if (!grepl("pr", numbers_item_y[x, "format"])) { # IF NOT PROB FORMAT
                        
                        item2number_list[[x]] <-
                          gsub(field_to_replace[j], # to be replaced
                               paste0(numbers_item_y[x,][[field_to_replace[j]]])
                               , #replacement
                               item2number_list[[x]]) # current problem (LOOP 1)
                        
                                                                      } # IF PROB FORMAT
                  
                                                      } # END: 1.2.1. LOOP FIELDS TO REPLACE
            
                                              } # END: 1.2. LOOP NUMBER SET TABLE 
      
      # IF PROBLEM IS POSITIVE FRAMEWORK, 1. LOOP ENDS here
      list_of_lists[[i]] <- item2number_list
      
    } # IF PROBLEM IS CLASSIC TEXT/POSITIVE FRAMEWORK
    
  } # END: 1. LOOP PROBLEMS
  
    # ASSIGN FINAL LIST TO ENVIROMENT
    assign("problems_numbered" , list_of_lists, envir = .GlobalEnv)
  
} # FUNCTION END