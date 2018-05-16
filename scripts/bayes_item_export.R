# Resources
source("scripts/html_qualtrics_codes.R")
source("functions/items2qualtrics.R") # function to convert txt files to qualtrics txt format

# separated item folder
separated_item_dir <- "materials/qualtrics/output/separated_items/"
response_types_dir <- "materials/qualtrics/input/reponse_type/"
paired_items_dir   <- "materials/qualtrics/output/paired_items/"


# All possible prevalences ------------------------------------------------

# Textual problems prevalences #####

# Custom func to capture prevalences
capture_prevalence <- function(str) {
  prev <-
    str %>% 
    gsub(".*\\[first_piece\\](.*)\\[second_piece\\].*", "\\1", .) %>% 
    gsub("\\n", "", .)
  name <-
    str %>% 
    gsub(".*\\*\\*(.*)\\*\\*.*", "\\1", .) %>% 
    gsub("(.*_.*_.*)_.*", "\\1", .)
  
  c(name, prev) 
}

# iterate over problems to capture prevalences
prevalences <- 
  problems_numbered_ordered_responses %>% 
  map(., capture_prevalence)
# remove duplicates (each [presentation format x ppv] prevalence is duplicated 4 times (response types))
prevalences <- 
  prevalences[!duplicated(prevalences)]
# convert list with names and prevalences to a nice table
named_prevalences <- 
  unlist(prevalences) %>% 
  matrix(., nrow = length(.)/2, byrow = T) %>% 
  as.tibble(.) %>% 
  rename(name = V1, prevalence = V2)

# Pictorial problems prevalences (These are not captured but build)
# call nppi/fbpi ppv creator? twice

pic_numbers <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(grepl("[a-z]{2}pi", .$format))

pic_prevalences_path <- 
  "materials/Question/Follow_up/input/pictorial_prevalences/"

pic_prevalences_files <- 
  paste0(pic_prevalences_path, dir(pic_prevalences_path, pattern = "*.txt"))

pic_prevalences_str <- 
  pic_prevalences_files %>% 
  map(~readChar(., file.size(.))) %>% 
  unlist() %>% 
  gsub("\\n", "", .)

fields2fill <-
  read_csv("materials/Numbers/fields2fill.csv", col_types = cols()) %>% 
  select(fbpi_followup_export, nppi)

pic_prevalences_str_filled <- 
  as.list(pic_prevalences_str)

# Wrapper function to keep temp variables away from global enviroment.
build_pic_prevalences <- 
  function(pic_prevalences_str) {
    
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
    print(pic_prevalences_str_filled)
  }
# Function call
pic_prevalences_str_filled <- 
  build_pic_prevalences(pic_prevalences_str)

pic_prevalences_str_filled <- 
  pic_prevalences_str_filled %>% 
  as.tibble() %>% 
  mutate(name = gsub("\\*\\*(.*)\\*\\*.*", "\\1", value),
         prevalence = gsub("\\*\\*.*\\*\\*(.*)", "\\1", value)) %>% 
  select(-value)

# JOIN TEXT & PICTORIAL PREVALENCES
all_prevalences <- 
  named_prevalences %>% 
  bind_rows(pic_prevalences_str_filled)

# Convert items to qualtrics txt advanced format --------------------------
problems_numbered_ordered_responses %>% 
  walk(~items2qualtrics(list_of_items = .x, responsesdir = response_types_dir, outputdir = separated_item_dir, removePlaceholders = TRUE))

# # pair items: different context, same presentation format, different ppv prob, same response type
# # function to pair items
# source("functions/pair_items.R")
# 
# # items_txt <- dir(output_dir, pattern = ".txt")
# txt_files <- dir(separated_item_dir, pattern = ".txt")
# twins <- character(length(txt_files)/2)
# 
# txt_files %>%
#   walk(~pair_items(txt_files = .x, separated_item_dir = separated_item_dir, twins = twins, outputdir = paired_items_dir))


