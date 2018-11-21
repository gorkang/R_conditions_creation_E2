# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse)
# Pictorial problems prevalences #####
# (These are not captured but build)

# pictorial number bayes 
pic_numbers <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(grepl("[a-z]{2}pi", .$format))

# path to pictorial prevalences
pic_prevalences_path <- 
  "materials/Question/Follow_up/input/pictorial_prevalences/"
# files with prevalences
pic_prevalences_files <- 
  paste0(pic_prevalences_path, dir(pic_prevalences_path, pattern = "*.txt"))
# prevalences
pic_prevalences_str <-
  pic_prevalences_files %>% 
  map(~readChar(., file.size(.))) %>% 
  unlist() %>% 
  gsub("\\n\\b", "", .)
# fields to be filled on each prevalence
fields2fill <-
  read_csv("materials/Numbers/fields2fill.csv", col_types = cols()) %>% 
  select(fbpi_followup_export, nppi)
# duplicated list of prevalences to filled with final filled prevalences
pic_prevalences_str_filled <- 
  as.list(pic_prevalences_str)

# Wrapper function to keep temp variables away from global enviroment.
build_pic_prevalences <- 
  
  function(pic_prevalences_str) {
    # pic_prevalences_str <- pic_prevalences_str[[1]]
    
    for (a in seq(pic_prevalences_str)) {
      # a <- 2
      
      # Get info about the current prevalence
      curr_str         <- pic_prevalences_str[a]
      current_format   <- gsub("\\*\\*[a-z]{2}_([a-z]{4})\\*\\*.*", "\\1", curr_str)
      curr_fields2fill <- fields2fill %>% select(matches(current_format)) %>% drop_na() %>% pull
      curr_pic_numbers <- pic_numbers %>% filter(format == current_format)
      
      # Empty list with as many elements as set of numbers. These are going to be filled with prevalences filled with numbers
      temp_list <- rep(list(NULL), nrow(curr_pic_numbers))
      
      # Iterate through set of numbers
      for (b in 1:nrow(curr_pic_numbers)) {
        # b <- 2
        curr_str_n <- curr_str
        
        # Iterate filling all fields to fill 
        for (c in seq(curr_fields2fill)) {
          # c <- 1
          # add ppv probability (high/low) to name
          curr_str_n <- 
            gsub("(\\*\\*[a-z]{2}_[a-z]{4})(\\*\\*.*)", 
                 paste0("\\1_ppv", curr_pic_numbers[b, "prob"], "\\2"), 
                 curr_str_n)
          # repalce fields2fill with numbers
          curr_str_n <- 
            gsub(paste0(curr_fields2fill[c], "\\b"), 
                 curr_pic_numbers[b, curr_fields2fill[c]], 
                 curr_str_n)
        }
        # temp list contains the str filled with set of numbers
        temp_list[b] <- curr_str_n
      }
      # add temp list to master list (func output) 
      pic_prevalences_str_filled[[a]] <- temp_list
    }
    # convert list to flat vector
    pic_prevalences_str_filled <- 
      pic_prevalences_str_filled %>% unlist
    # output
    pic_prevalences_str_filled
  }
# Function call
pic_prevalences_str_filled <- 
  build_pic_prevalences(pic_prevalences_str)

pic_prevalences_str_filled %>% 
  walk(~cat(.x, sep = "", 
           file = paste0("materials/qualtrics/output/plain_text/prevalences/", gsub("\\*\\*(.*)\\*\\*.*", "\\1", .x), ".txt")))

